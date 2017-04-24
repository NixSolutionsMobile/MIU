//
//  MIUEnum.m
//  ModelImprovementUtilite
//
//  Created by Nesteforenko Andrey on 9/17/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUEnum.h"

@implementation MIUEnum

- (instancetype)initEnumWithName:(NSString *)name type:(NSString *)type
{
    if (self = [super init])
    {
        [self setName:name];
        [self setType:type];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)theZone
{
    MIUEnum *copy = [[[self class] alloc] init];

    if (copy)
    {
        [copy setType:[self type]];
        [copy setName:[self name]];
    }

    return copy;
}

- (BOOL)isEqual:(MIUEnum *)theObject
{
    if (theObject == self)
    {
        return YES;
    }

    if ([self class] != [theObject class])
    {
        return NO;
    }

    if (([self type] != [theObject type] && ![[self type] isEqual:[theObject type]]) ||
        ([self name] != [theObject name] && ![[self name] isEqual:[theObject name]]))
    {
        return NO;
    }

    return YES;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString new];

    [description appendString:[NSString stringWithFormat:@"type - %@ \n", [self type]]];
    [description appendString:[NSString stringWithFormat:@"name - %@ \n", [self name]]];

    return description;
}

- (NSUInteger)hash
{
    return [[self type] hash] ^ [[self name] hash];
}

@end
