//
//  MIUMethod.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/7/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUMethod.h"

@implementation MIUMethod

- (instancetype)initWithName:(NSString *)name
                  returnType:(NSString *)returnType
         isPointerReturnType:(BOOL)pointerReturnType
                     argName:(NSString *)argName
                     argType:(NSString *)argType
            isPointerArgType:(BOOL)pointerArgType
{
    if ((self = [super init]))
    {
        _problematicProperties = [NSMutableDictionary new];
        [self setReturnType:returnType];
        [self setPointerReturnType:pointerReturnType];
        [self setName:name];
        [self setArgumentName:argName];
        [self setPointerArgumentType:pointerArgType];
        [self setArgumentType:argType];
    }
    
    return self;
}

- (NSString *)headerOfMethod
{
    NSString *returnType = [NSString stringWithFormat:@"%@%@", [self returnType], [self isPointerReturnType] ? @" *" : @""];
    
    if (_argumentType != nil && _argumentName != nil)
    {
        NSString *argType = [NSString stringWithFormat:@"%@%@", [self argumentType], [self isPointerArgumentType] ? @" *" : @""];
        
        // prefix generated is used for mark method as automatic "// generated" by MIU and can be modified by MIU
        // for existing methods that not marked as "// generated" MIU skip generating new body
        return [NSString stringWithFormat:@"// generated\n- (%@)%@:(%@)%@", returnType, [self name], argType, [self argumentName]];
    }
    else
    {
        return [NSString stringWithFormat:@"// generated\n- (%@)%@", returnType, [self name]];
    }
}

- (NSString *)methodBodyForClass:(MIUClass *)class
{
    NSAssert(YES, @"You mustn't call virtual method");
    return nil;
}

@end
