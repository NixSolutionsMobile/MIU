//
//  MIUInitWithCoder.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/10/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUInitWithCoder.h"
#import "MIUClass.h"
#import "MIUProperty.h"

static NSString *const MIUWarning = @"    #warning Is undefined rules for initing weak property, propertyName:%@\n";
static NSString *const MIUDecodingBytes = @"%@ %@;\n        [dictionaryForDecoding[NSStringFromSelector(@selector(%@))] getBytes:&%@ length:sizeof(%@)];\n        [self %@:%@];";
static NSString *const MIUDecodingNumbers = @"[self %@:[dictionaryForDecoding[NSStringFromSelector(@selector(%@))] %@]];";
static NSString *const MIUDecodingValues = @"[self %@:[dictionaryForDecoding[NSStringFromSelector(@selector(%@))] %@]];";

@interface MIUInitWithCoder ()

@property(nonatomic, strong) NSMutableString *warnings;

@end

@implementation MIUInitWithCoder

- (NSString *)methodBodyForClass:(MIUClass *)class
{
    NSMutableString *methodBody = [[self firstPartOfMethodForClass:class] mutableCopy];
    _warnings = [NSMutableString new];
    
    for (MIUProperty *property in [class properties])
    {
        if ([property isReadonly] != YES)
        {
            NSString *decodeing = [self decodingProperty:property isPointerType:[property isPointer]];
            
            if (![decodeing isEqualToString:@""])
            {
                [methodBody appendFormat:@"\n        %@", decodeing];
            }
        }
    }
    
    if ([_warnings isEqualToString:@""])
    {
        [methodBody appendFormat:@"\n    }\n\n    return self;\n}"];
    }
    else
    {
        [methodBody appendFormat:@"\n    }\n\n%@\n%@", _warnings, @"    return self;\n}"];
    }
    
    return [methodBody copy];
}

- (NSString *)decodingProperty:(MIUProperty *)property isPointerType:(BOOL)isPointer
{
    NSString *decoding;
    
    if (!isPointer)
    {
        NSString *typeMethod = [self methodForDataType:[property type]];
        
        if (typeMethod)
        {
            decoding =  [NSString stringWithFormat:MIUDecodingNumbers, [property getSetter], [property getGetter], typeMethod];
        }
        else if ([[self typesOfDataToGenerateWarnings] containsObject:[property type]])
        {
            decoding = [NSString stringWithFormat:MIUDecodingValues, [property getSetter], [property getGetter], [self nsvaluesMethodForCGDataTypes:[property type]]];
        }
        else
        {
            decoding =  [NSString stringWithFormat:MIUDecodingBytes, [property type], [property name], [property name], [property name], [property type], [property getSetter], [property name]];
        }
    }
    else
    {
        if ([property memoryAttribute] != MIUPropertyMemoryAttributeWeak)
        {
            decoding =  [NSString stringWithFormat:@"[self %@:dictionaryForDecoding[NSStringFromSelector(@selector(%@))]];", [property getSetter], [property getGetter]];
        }
        else
        {
            decoding = @"";
            [[super problematicProperties] setObject:[property type] forKey:[property name]];
            [_warnings appendFormat:MIUWarning, [property name]];
        }
    }
    
    return decoding;
}

- (NSString *)firstPartOfMethodForClass:(MIUClass *)class
{
    NSString *initialObj;
    
    if ([class isBase])
    {
        initialObj = @"self = [super init];";
    }
    else
    {
        initialObj = [NSString stringWithFormat:@"self = [super initWithCoder:%@];", [self argumentName]];
    }
    
    return [NSString stringWithFormat:@"{\n    %@\n\n    if (self)\n    {\n        NSDictionary *dictionaryForDecoding = [theDecoder decodeObjectForKey:NSStringFromClass([%@ class])];\n", initialObj, [class name]];
}

- (NSString *)methodForDataType:(NSString *)type
{
    if ([type isEqualToString:@"BOOL"])
    {
        return @"boolValue";
    }
    
    if ([type isEqualToString:@"char"])
    {
        return @"charValue";
    }
    
    if ([type isEqualToString:@"NSDecimal"])
    {
        return @"decimalValue";
    }
    
    if ([type isEqualToString:@"double"])
    {
        return @"doubleValue";
    }
    
    if ([type isEqualToString:@"float"] || [type isEqualToString:@"CGFloat"] || [type isEqualToString:@"NSTimeInterval"])
    {
        return @"floatValue";
    }
    
    if ([type isEqualToString:@"int"])
    {
        return @"intValue";
    }
    
    if ([type isEqualToString:@"NSInteger"])
    {
        return @"integerValue";
    }
    
    if ([type isEqualToString:@"NSUInteger"])
    {
        return @"unsignedIntegerValue";
    }
    
    if ([type isEqualToString:@"long"])
    {
        return @"longValue";
    }
    
    if ([type isEqualToString:@"short"])
    {
        return @"shortValue";
    }
    
    if ([type isEqualToString:@"long long"])
    {
        return @"longLongValue";
    }
    
    if ([type isEqualToString:@"unsigned char"])
    {
        return @"unsignedCharValue";
    }
    
    if ([type isEqualToString:@"unsigned int"])
    {
        return @"unsignedIntValue";
    }
    
    if ([type isEqualToString:@"unsigned long"])
    {
        return @"unsignedLongValue";
    }
    
    if ([type isEqualToString:@"unsigned long long"])
    {
        return @"unsignedLongLongValue";
    }
    
    if ([type isEqualToString:@"unsigned short"])
    {
        return @"unsignedShortValue";
    }
    
    return nil;
}

- (NSString *)nsvaluesMethodForCGDataTypes:(NSString *)dataTypes
{
    NSString *method = nil;
    
    if ([dataTypes isEqualToString:@"CGPoint"])
    {
        method = @"CGPointValue";
    }
    else if ([dataTypes isEqualToString:@"CGRect"])
    {
        method = @" CGRectValue";
    }
    else if ([dataTypes isEqualToString:@"CGSize"])
    {
        method = @"CGSizeValue";
    }
    else if ([dataTypes isEqualToString:@"CGVector"])
    {
        method = @"CGVectorValue";
    }
    
    return method;
}

- (NSSet *)typesOfDataToGenerateWarnings
{
    return [NSSet setWithArray:@[
                                    @"CGPoint",
                                    @"CGRect",
                                    @"CGSize",
                                    @"CGVector"
                                ]];
}

@end
