//
//  MIUIsEqual.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/9/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUIsEqual.h"
#import "MIUProperty.h"
#import "MIUClass.h"

static NSString *const MIUWarning = @"    #warning Not defined rules to compare propertyWithType:%@";

@implementation MIUIsEqual

- (NSString *)methodBodyForClass:(MIUClass *)class
{
    NSMutableString *methodBody = [NSMutableString new];
    NSMutableString *warnings = [NSMutableString new];
    MIUProperty *firstProperty = [[[class properties] allObjects] firstObject];
    [methodBody appendString:@"{"];
    
    NSString *checkToSuperIfNeeded = [self checkToSuperIfNeededForClass:class];
    [methodBody appendFormat:@"\n%@\n\n%@%@", [self checkToSelf:[self argumentName]], [self sameClassAndNotNilObject:[self argumentName]], [checkToSuperIfNeeded isEqualToString:@""] ? @"" : [NSString stringWithFormat:@"\n\n%@", checkToSuperIfNeeded]];
    
    if (firstProperty != nil)
    {
        NSString *firstPropertyCondition = [self checkFirstObject:firstProperty with:warnings];
        
        [methodBody appendFormat:@"\n\n%@", firstPropertyCondition];
        
        for (int i = 1; i < [[class properties] count]; i++)
        {
            MIUProperty *property = [[[class properties] allObjects] objectAtIndex:i];
            
            if ([property isPointer])
            {
                if ([property typeConformed] != nil)
                {
                    [methodBody appendFormat:@" ||\n        ([self %@] != [%@ %@] && ![(id<NSObject>)[self %@] %@:[%@ %@]])", [property getGetter], [self argumentName], [property getGetter], [property getGetter], [self isEqualStringForDataType:[property type]], [self argumentName], [property getGetter]];
                }
                else
                {
                    [methodBody appendFormat:@" ||\n        ([self %@] != [%@ %@] && ![[self %@] %@:[%@ %@]])", [property getGetter], [self argumentName], [property getGetter], [property getGetter], [self isEqualStringForDataType:[property type]], [self argumentName], [property getGetter]];
                }
            }
            else
            {
                if ([[self typesOfDataToCustomCompare] containsObject:[property type]])
                {
                    [methodBody appendFormat:@" ||\n        %@", [self isEqualForNonPointerDataTypesProperty:property]];
                }
                else if ([[self typesOfDataToCompareByEqualityBySign] containsObject:[property type]])
                {
                    [methodBody appendFormat:@" ||\n        ([self %@] != [%@ %@])", [property getGetter], [self argumentName], [property getGetter]];
                }
                else
                {
                    NSPredicate *preidacte = [NSPredicate predicateWithFormat:@"SELF = %@", [property type]];
                    NSSet *types = [[self enums] valueForKey:NSStringFromSelector(@selector(name))];
                    NSSet *enumsTypes = [types filteredSetUsingPredicate:preidacte];
                    
                    if ([enumsTypes containsObject:[property type]])
                    {
                        [methodBody appendFormat:@" ||\n        ([self %@] != [%@ %@])", [property getGetter], [self argumentName], [property getGetter]];
                    }
                    else
                    {
                        [[super problematicProperties] setObject:[property type] forKey:[property name]];
                        [warnings appendFormat:MIUWarning, [property type]];
                    }
                }
            }
        }
        
        [methodBody appendString:@")\n    {\n        return NO;\n    }"];
    }
    
    if (![warnings isEqualToString:@""])
    {
        [methodBody appendFormat:@"\n\n%@", warnings];
    }

    [methodBody appendString:@"\n\n    return YES;\n}"];
    
    return methodBody;
}

- (NSString *)checkToSelf:(NSString *)argumentName
{
    return [NSString stringWithFormat:@"    if (%@ == self)\n    {\n        return YES;\n    }", argumentName];
}

- (NSString *)sameClassAndNotNilObject:(NSString *)argumentName
{
    return [NSString stringWithFormat:@"    if ([self class] != [%@ class])\n    {\n        return NO;\n    }", argumentName];
}

- (NSString *)checkToSuperIfNeededForClass:(MIUClass *)class
{
    if ([class isBase])
    {
        return @"";
    }
    else
    {
        return [NSString stringWithFormat:@"    if (![super isEqual:%@])\n    {\n        return NO;\n    }", [self argumentName]];
    }
}

- (NSString *)checkFirstObject:(MIUProperty *)property with:(NSMutableString *)warnings
{
    if ([property isPointer])
    {
        if ([property typeConformed] != nil)
        {
            return [NSString stringWithFormat:@"    if (([self %@] != [%@ %@] && ![(id<NSObject>)[self %@] %@:[%@ %@]])", [property getGetter], [self argumentName], [property getGetter], [property getGetter], [self isEqualStringForDataType:[property type]], [self argumentName], [property getGetter]];
        }
        else
        {
            return [NSString stringWithFormat:@"    if (([self %@] != [%@ %@] && ![[self %@] %@:[%@ %@]])", [property getGetter], [self argumentName], [property getGetter], [property getGetter], [self isEqualStringForDataType:[property type]], [self argumentName], [property getGetter]];
        }
    }
    else
    {
        if ([[self typesOfDataToCustomCompare] containsObject:[property type]])
        {
            return [NSString stringWithFormat:@"    if (%@", [self isEqualForNonPointerDataTypesProperty:property]];
        }
        else if ([[self typesOfDataToCompareByEqualityBySign] containsObject:[property type]])
        {
            return [NSString stringWithFormat:@"    if (([self %@] != [%@ %@])", [property getGetter], [self argumentName], [property getGetter]];
        }
        else
        {
            NSPredicate *preidacte = [NSPredicate predicateWithFormat:@"SELF = %@", [property type]];
            NSSet *types = [[self enums] valueForKey:NSStringFromSelector(@selector(name))];
            NSSet *enumsTypes = [types filteredSetUsingPredicate:preidacte];
            
            if ([enumsTypes containsObject:[property type]])
            {
                return [NSString stringWithFormat:@"    if (([self %@] != [%@ %@])", [property getGetter], [self argumentName], [property getGetter]];
            }
            else
            {
                [[super problematicProperties] setObject:[property type] forKey:[property name]];
                [warnings appendFormat:MIUWarning, [property type]];
            }
        }
        
        return @"    if (";
    }
}

- (NSString *)isEqualStringForDataType:(NSString *)dataType
{
    NSString *isEqual = nil;
    
    if ([dataType isEqual:@"NSArray"] || [dataType isEqual:@"NSMutableArray"])
    {
        isEqual = @"isEqualToArray";
    }
    else if ([dataType isEqual:@"NSSet"] || [dataType isEqual:@"NSMutableSet"])
    {
        isEqual = @"isEqualToSet";
    }
    else if ([dataType isEqual:@"NSDictionary"] || [dataType isEqual:@"NSMutableDictionary"])
    {
        isEqual = @"isEqualToDictionary";
    }
    else if ([dataType isEqual:@"NSData"] || [dataType isEqual:@"NSMutableData"])
    {
        isEqual = @"isEqualToData";
    }
    else
    {
        isEqual = @"isEqual";
    }
    
    return isEqual;
}

- (NSSet *)typesOfDataToCustomCompare
{
    return [NSSet setWithArray:@[
                                    @"CGPoint",
                                    @"CGRect",
                                    @"CGSize",
                                    @"CGVector"
                                ]];
}

- (NSSet *)typesOfDataToCompareByEqualityBySign
{
    return [NSSet setWithArray:@[
                                    @"BOOL",
                                    @"char",
                                    @"NSDecimal",
                                    @"double",
                                    @"float",
                                    @"NSTimeInterval",
                                    @"CGFloat",
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

- (NSString *)isEqualForNonPointerDataTypesProperty:(MIUProperty *)property
{
    NSString *dataType = [property type];
    NSString *isEqual = nil;
    
    if ([dataType isEqual:@"CGRect"])
    {
        isEqual = [NSString stringWithFormat:@"!CGRectEqualToRect([self %@], [%@ %@])", [property getGetter], [self argumentName], [property getGetter]];
    }
    else if ([dataType isEqual:@"CGPoint"])
    {
        isEqual = [NSString stringWithFormat:@"!CGPointEqualToPoint([self %@], [%@ %@])", [property getGetter], [self argumentName], [property getGetter]];
    }
    else if ([dataType isEqual:@"CGSize"])
    {
        isEqual = [NSString stringWithFormat:@"!CGSizeEqualToSize([self %@], [%@ %@])", [property getGetter], [self argumentName], [property getGetter]];
    }
    else if ([dataType isEqual:@"CGVector"])
    {
        isEqual = [NSString stringWithFormat:@"!CGPointEqualToPoint(CGPointMake([self %@].dx, [self %@].dy), CGPointMake([%@ %@].dx, [%@ %@].dy))", [property getGetter], [property getGetter], [self argumentName], [property getGetter], [self argumentName], [property getGetter]];
    }
    
    return isEqual;
}

@end
