//
//  MIUEncodeWithCoder.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/7/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUEncodeWithCoder.h"
#import "MIUClass.h"
#import "MIUProperty.h"

static NSString *const MIUWarning = @"    #warning Is undefined rules for decoding weak property, propertyName:%@\n";
static NSString *const MIUPointerPropertySetterTemplate = @"MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionaryForEncoding, %@);";
static NSString *const MIUNumberDictionarySetter = @"[dictionaryForEncoding setObject:@([self %@]) forKey:NSStringFromSelector(@selector(%@))];";
static NSString *const MIUInitialDictionaryWithSuper = @"{\n    NSMutableDictionary *dictionaryForEncoding = [NSMutableDictionary dictionary];\n\n    [super encodeWithCoder:%@];";
static NSString *const MIUInitialDictionary = @"{\n    NSMutableDictionary *dictionaryForEncoding = [NSMutableDictionary dictionary];\n";
static NSString *const MIUFinalEncodingMethodPart = @"\n    [theCoder encodeObject:dictionaryForEncoding forKey:NSStringFromClass([%@ class])];\n}";
static NSString *const MIUValueSetter = @"[dictionaryForEncoding setObject:[NSValue %@:[self %@]] forKey:NSStringFromSelector(@selector(%@))];";
static NSString *const MIUBytesSetter = @"[dictionaryForEncoding setObject:[NSData dataWithBytes:&%@ length:sizeof(%@)] forKey:NSStringFromSelector(@selector(%@))];";

@interface MIUEncodeWithCoder ()

@property(nonatomic, strong) NSMutableString *warnings;

@end

@implementation MIUEncodeWithCoder

- (NSString *)methodBodyForClass:(MIUClass *)class
{
    NSMutableString *methodBody = [[self getFirstPartOfMethodForClass:class] mutableCopy];
    _warnings = [NSMutableString new];
    
    for (MIUProperty *property in [class properties])
    {
        if ([property isReadonly] != YES)
        {
            NSString *propertySetterString = [self propertySetterString:property];
            
            if (![propertySetterString isEqualToString:@""])
            {
                [methodBody appendFormat:@"\n    %@", propertySetterString];
            }
        }
    }
    
    if (![_warnings isEqualToString:@""])
    {
        [methodBody appendFormat:@"\n\n%@%@", _warnings, [self getLastPartOfMethodWithClassName:[class name]]];
    }
    else
    {
        [methodBody appendFormat:@"\n%@", [self getLastPartOfMethodWithClassName:[class name]]];
    }
    
    return [methodBody copy];
}

- (NSString *)propertySetterString:(MIUProperty *)property
{
    if ([property isPointer])
    {
        if ([property memoryAttribute] != MIUPropertyMemoryAttributeWeak)
        {
            return [NSString stringWithFormat:MIUPointerPropertySetterTemplate, [property getGetter]];
        }
        else
        {
            [[super problematicProperties] setObject:[property type] forKey:[property name]];
            [_warnings appendFormat:MIUWarning, [property name]];

            return @"";
        }
    }
    else
    {
        if ([[self typesOfDataToGenerateWarnings] containsObject:[property type]])
        {
            return [NSString stringWithFormat:MIUValueSetter, [self nsvaluesMethodForCGDataTypes:[property type]], [property getGetter], [property getGetter]];
        }
        else if ([[self typesOfDataToCreateNSNumberFrom] containsObject:[property type]])
        {
            return [NSString stringWithFormat:MIUNumberDictionarySetter, [property getGetter], [property getGetter]];
        }
        else
        {
            return [NSString stringWithFormat:MIUBytesSetter, [property getGetterToUseWithOutSelf], [property type], [property getGetter]];
        }
    }
}

- (NSString *)propertyNameWithSymbol:(NSString *)propertyName
{
    return [@"_" stringByAppendingString:propertyName];
}

- (NSString *)getFirstPartOfMethodForClass:(MIUClass *)class
{
    if (![class isBase])
    {
        return [NSString stringWithFormat:MIUInitialDictionaryWithSuper, [self argumentName]];
    }
    else
    {
        return MIUInitialDictionary;
    }
}

- (NSString *)getLastPartOfMethodWithClassName:(NSString *)className
{
    return [NSString stringWithFormat:MIUFinalEncodingMethodPart, className];
}

- (NSString *)nsvaluesMethodForCGDataTypes:(NSString *)dataTypes
{
    NSString *method = nil;
    
    if ([dataTypes isEqualToString:@"CGPoint"])
    {
        method = @"valueWithCGPoint";
    }
    else if ([dataTypes isEqualToString:@"CGRect"])
    {
        method = @"valueWithCGRect";
    }
    else if ([dataTypes isEqualToString:@"CGSize"])
    {
        method = @"valueWithCGSize";
    }
    else if ([dataTypes isEqualToString:@"CGVector"])
    {
        method = @"valueWithCGVector";
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

- (NSSet *)typesOfDataToCreateNSNumberFrom
{
    return [NSSet setWithArray:@[
                                    @"BOOL",
                                    @"char",
                                    @"NSDecimal",
                                    @"double",
                                    @"float",
                                    @"CGFloat",
                                    @"NSTimeInterval",
                                    @"int",
                                    @"NSInteger",
                                    @"NSUInteger",
                                    @"long",
                                    @"short",
                                    @"long long",
                                    @"unsigned char",
                                    @"unsigned int",
                                    @"unsigned short",
                                    @"unsigned long long",
                                    @"unsigned long"
                                ]];
}

@end
