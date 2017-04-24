//
//  MIUPropertyScanner.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/2/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUPropertyScanner.h"
#import "MiuProperty.h"

static const NSUInteger MIUPropertyBracketsIndex = 1;
static const NSUInteger MIUAttributesIndex = 3;
static const NSUInteger MIUTypeIndex = 4;
static const NSUInteger MIUAsteriskIndex = 5;
static const NSUInteger MIUNameIndex = 6;

static NSString *const MIUStrong = @"strong";
static NSString *const MIUCopy = @"copy";
static NSString *const MIUWeak = @"weak";
static NSString *const MIUAssign = @"assign";

@implementation MIUPropertyScanner

- (NSTextCheckingResult *)firstMatchFromString:(NSString *)string withPattern:(NSString *)pattern
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];

    return [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
}

- (MIUProperty *)propertyWithString:(NSString *)property
{
    // general pattern to get main property attributes like (type, isPointer, memory attribute, setter, getter ...)
    NSString *pattern = @"\\@property\\s*((\\((.*)\\)){0,1})\\s*(\\w*)\\s*(\\**)\\s*(\\w*)\\s*\\;";
    NSTextCheckingResult *match = [self firstMatchFromString:property withPattern:pattern];
    
    if (match != nil)
    {
        return [self getPropertyFromString:property withTypeIndex:MIUTypeIndex nameIndex:MIUNameIndex withTextMatching:match isDifficultTypeMethod:NO];
    }
    else
    {
        //  pattern for case when property type consist from more than one word, like (long long, unsigned long long)
        NSString *pattern = @"\\@property\\s*((\\((.*)\\)){0,1})\\s*((((\\bunsigned\\b|\\blong\\b|\\bchar\\b)*\\s*)*)?)(\\w*)\\;";
        NSTextCheckingResult *match = [self firstMatchFromString:property withPattern:pattern];
        
        if (match != nil)
        {
            return [self getPropertyFromString:property withTypeIndex:4 nameIndex:8 withTextMatching:match isDifficultTypeMethod:YES];
        }
        else
        {
            //  this case is for situation when property like @property id<NSObject> propertyName;, must to be parsed
            //  @property(nonatomic, strong, setter = dasdf:) id < NSObject >  propertyName;
            NSString *pattern = @"\\@property\\s*((\\((.*)\\)){0,1})\\s*(\\w*\\s*\\<.*?\\>)\\s*\\*?\\s*(\\w*)\\s*\\;";
            NSTextCheckingResult *match = [self firstMatchFromString:property withPattern:pattern];
            
            if (match != nil)
            {
                MIUProperty *propertyWithIncorrectPointerProperty = [self getPropertyFromString:property withTypeIndex:4 nameIndex:5 withTextMatching:match isDifficultTypeMethod:YES];
                [propertyWithIncorrectPointerProperty setTypeConformed:[self typeConformedProtocol:property]];
                [propertyWithIncorrectPointerProperty setIsPointer:YES];

                return propertyWithIncorrectPointerProperty;
            }
        }
    }
    
    return nil;
}

- (MIUProperty *)getPropertyFromString:(NSString *)property
                         withTypeIndex:(int)typeIndex
                             nameIndex:(int)nameIndex
                      withTextMatching:(NSTextCheckingResult *)match
                 isDifficultTypeMethod:(BOOL)isDifficultTypeMethod
{
    NSString *bracketsString = [property substringWithRange:[match rangeAtIndex:MIUPropertyBracketsIndex]];
    NSArray *attributes = nil;
    NSString *propertyGetter = @"";
    NSString *propertySetter = @"";
    
    if ([bracketsString length] > 0)
    {
        NSString *attributesString = [property substringWithRange:[match rangeAtIndex:MIUAttributesIndex]];
        attributes = [self separateAttributes:attributesString];
        propertyGetter = [self getterFromStringWithAttributes:[property substringWithRange:[match rangeAtIndex:MIUAttributesIndex]]];
        propertySetter = [self setterFromStringWithAttributes:[property substringWithRange:[match rangeAtIndex:MIUAttributesIndex]]];
    }
    
    NSString *asteriskString;
    BOOL isPointer = NO;
    NSString *typeString = [property substringWithRange:[match rangeAtIndex:typeIndex]];
    NSString *nameString = [property substringWithRange:[match rangeAtIndex:nameIndex]];
    NSString *stringWithType = [self stringByTrimmingTrailingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] stringWithType:typeString];
    
    if (!isDifficultTypeMethod)
    {
        asteriskString = [property substringWithRange:[match rangeAtIndex:MIUAsteriskIndex]];
        isPointer = [self isPointerType:asteriskString];
    }
    
    BOOL isAtomic = [self checkIsAtomic:attributes];
    BOOL isReadonly = [self checkIsReadonly:attributes];
    MIUPropertyMemoryAttribute memoryAttribute = [self memoryAttributeFromAttributesArray:attributes isPropertyPointerType:isPointer];
    
    return [[MIUProperty alloc] initWithName:nameString type:stringWithType setter:propertySetter getter:propertyGetter isPointer:isPointer isAtomic:isAtomic memoryAttribute:memoryAttribute isReadonly:isReadonly];
}

- (BOOL)isPointerType:(NSString *)propertyAsterisk
{
    return [propertyAsterisk isEqualToString:@"*"];
}

- (BOOL)checkIsAtomic:(NSArray *)attributes
{
    return ([attributes indexOfObject:@"nonatomic"] == NSNotFound) || ([attributes count] == 0);
}

- (BOOL)checkIsReadonly:(NSArray *)attributes
{
    return ([attributes indexOfObject:@"readonly"] != NSNotFound && attributes != nil);
}

- (MIUPropertyMemoryAttribute)memoryAttributeFromAttributesArray:(NSArray *)attributes isPropertyPointerType:(BOOL)isPointer
{
    NSString *memoryAttribute = [self memoryAttributeStringFromAttributes:attributes isPropertyPointerType:isPointer];
    MIUPropertyMemoryAttribute result = MIUPropertyMemoryAttributeUnknown;
    
    if ([memoryAttribute isEqualToString:MIUStrong])
    {
        result = MIUPropertyMemoryAttributeStrong;
    }
    else if ([memoryAttribute isEqualToString:MIUCopy])
    {
        result = MIUPropertyMemoryAttributeCopy;
    }
    else if ([memoryAttribute isEqualToString:MIUWeak])
    {
        result = MIUPropertyMemoryAttributeWeak;
    }
    else if ([memoryAttribute isEqualToString:MIUAssign])
    {
        result = MIUPropertyMemoryAttributeAssign;
    }
    
    return result;
}

- (NSString *)setterFromStringWithAttributes:(NSString *)attributes
{
    // pattern for parsing for property with setter
    NSString *pattern = @"setter\\s*\\=\\s*(\\w*)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    NSTextCheckingResult *match = [regex firstMatchInString:attributes options:0 range:NSMakeRange(0, [attributes length])];
    
    if (match != nil)
    {
        return [attributes substringWithRange:[match rangeAtIndex:1]];
    }
    
    return @"";
}

- (NSString *)getterFromStringWithAttributes:(NSString *)attributes
{
    // pattern for parsing for property with getter
    NSString *pattern = @"getter\\s*\\=\\s*(\\w*)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    NSTextCheckingResult *match = [regex firstMatchInString:attributes options:0 range:NSMakeRange(0, [attributes length])];
    
    if (match != nil)
    {
        return [attributes substringWithRange:[match rangeAtIndex:1]];
    }
    
    return @"";
}

- (NSString *)memoryAttributeStringFromAttributes:(NSArray *)attributes isPropertyPointerType:(BOOL)isPointer
{
    NSSet *allMemoryAttributes = [NSSet setWithArray:@[MIUStrong, MIUCopy, MIUWeak, MIUAssign]];
    NSMutableSet *memoryAttributes = [allMemoryAttributes mutableCopy];
    NSSet *attributesSet = [NSSet setWithArray:attributes];
    
    [memoryAttributes intersectSet:attributesSet];
    
    if ([memoryAttributes count] > 0)
    {
        return [[memoryAttributes allObjects] firstObject];
    }
    else
    {
        if (isPointer)
        {
            return MIUStrong;
        }
        else
        {
            return MIUAssign;
        }
    }
}

- (NSArray *)separateAttributes:(NSString *)attributes
{
    NSString *stringWithOutSpaces = [attributes stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return [stringWithOutSpaces componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%@", @","]]];
}

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet stringWithType:(NSString *)stringWithType
{
    NSUInteger location = 0;
    NSUInteger length = [stringWithType length];
    unichar charBuffer[length];
    [stringWithType getCharacters:charBuffer];
    
    for ((void)length; length > 0; length--)
    {
        if (![characterSet characterIsMember:charBuffer[length - 1]])
        {
            break;
        }
    }
    
    return [stringWithType substringWithRange:NSMakeRange(location, length - location)];
}

- (NSString *)typeConformedProtocol:(NSString *)type
{
    // pattern for parsing for property with type like "@property id<SomeProtocol> propertyName;"
    NSString *pattern = @"\\<\\s*(\\w*)\\s*\\>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    NSTextCheckingResult *match = [regex firstMatchInString:type options:0 range:NSMakeRange(0, [type length])];
    
    if (match != nil)
    {
        return [type substringWithRange:[match rangeAtIndex:1]];
    }
    
    return nil;
}

@end
