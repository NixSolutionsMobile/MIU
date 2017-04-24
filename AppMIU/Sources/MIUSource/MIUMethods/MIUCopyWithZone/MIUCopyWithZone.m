//
//  MIUCopyWithZone.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/7/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUCopyWithZone.h"
#import "MIUProperty.h"
#import "MIUClass.h"

#define MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionary, property)\
    if ([self property] != nil)\
    {\
        [dictionary setObject:[self property] forKey:NSStringFromSelector(@selector(property))];\
    }

@implementation MIUCopyWithZone

- (NSString *)methodBodyForClass:(MIUClass *)class
{
    NSMutableString *methodBody = [[self firstPartOfMethodForClass:class] mutableCopy];
    
    for (MIUProperty *property in [class properties])
    {
        NSString *setterString = [self propertySetterString:property isPropertyPointer:[property isPointer]];
        
        if (![setterString isEqualToString:@""])
        {
            [methodBody appendFormat:@"\n        %@", setterString];
        }
    }
    
    [methodBody appendString:@"\n    }\n\n    return copy;\n}"];
    
    return [methodBody copy];
}

- (NSString *)propertySetterString:(MIUProperty *)property isPropertyPointer:(BOOL)isPointer
{
    if ([property isReadonly] != YES)
    {
        if (isPointer)
        {
            if ([property memoryAttribute] == MIUPropertyMemoryAttributeCopy || [property memoryAttribute] == MIUPropertyMemoryAttributeWeak)
            {
                return [NSString stringWithFormat:@"[copy %@:[self %@]];", [property getSetter], [property getGetter]];
            }
            else if ([property typeConformed] != nil)
            {
                return [NSString stringWithFormat:@"[copy %@:[[self %@] copyWithZone:%@]];", [property getSetter], [property getGetter], [self argumentName]];
            }
            
            return [NSString stringWithFormat:@"[copy %@:[[self %@] %@]];", [property getSetter], [property getGetter], [self copyMethodForDataType:[property type]]];
        }
        else
        {
            return [NSString stringWithFormat:@"[copy %@:[self %@]];", [property getSetter], [property getGetter]];
        }
    }
    
    return @"";
}

- (NSString *)firstPartOfMethodForClass:(MIUClass *)class
{
    if ([class isBase])
    {
        return [NSString stringWithFormat:@"{\n    %@ *copy = [[[self class] alloc] init];\n\n    if (copy)\n    {", [class name]];
    }
    else
    {
        return [NSString stringWithFormat:@"{\n    %@ *copy = [super copyWithZone:%@];\n\n    if (copy)\n    {", [class name], [self argumentName]];
    }
}

- (NSString *)copyMethodForDataType:(NSString *)dataType
{
    NSString *copyMethod = nil;
    
    if ([dataType hasPrefix:@"NSMutable"])
    {
        copyMethod = @"mutableCopy";
    }
    else
    {
        copyMethod = @"copy";
    }
    
    return copyMethod;
}

@end
