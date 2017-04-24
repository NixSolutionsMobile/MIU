//
//  MIUImplementation.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/8/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUImplementation.h"

@implementation MIUImplementation

- (instancetype)initWithName:(NSString *)name isCategory:(BOOL)isCategory filePath:(NSString *)filePath range:(NSRange)range synthesizedProperty:(NSArray *)synthesizedProperty
{
    self = [super init];
    
    if (self)
    {
        [self setCategory:isCategory];
        [self setName:name];
        [self setFilePath:filePath];
        [self setRange:range];
        [self setSynthesizedProperties:synthesizedProperty];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)theZone
{
    MIUImplementation *copy = [[[self class] alloc] init];

    if (copy)
    {
        [copy setFilePath:[[self filePath] copy]];
        [copy setRange:[self range]];
        [copy setName:[[self name] copy]];
        [copy setSynthesizedProperties:[[self synthesizedProperties] copy]];
    }

    return copy;
}

- (BOOL)isEqual:(MIUImplementation *)theObject
{
    if (theObject == self)
    {
        return YES;
    }

    if ([self class] != [theObject class])
    {
        return NO;
    }

    if (([self filePath] != [theObject filePath] && ![[self filePath] isEqual:[theObject filePath]]) ||
        ([self name] != [theObject name] && ![[self name] isEqual:[theObject name]]) ||
        [self range].location != [theObject range].location ||
        [self range].length != [theObject range].length ||
        ([self synthesizedProperties] != [theObject synthesizedProperties] &&
         ![[NSSet setWithArray:[self synthesizedProperties]] isEqualToSet:[NSSet setWithArray:[theObject synthesizedProperties]]]))
    {
        return NO;
    }

    return YES;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString new];

    [description appendString:[NSString stringWithFormat:@"filePath - %@ \n", [self filePath]]];
    [description appendString:[NSString stringWithFormat:@"name - %@ \n", [self name]]];
    [description appendString:[NSString stringWithFormat:@"synthesizedProperties - %@ \n", [self synthesizedProperties]]];

    return description;
}

- (NSUInteger)hash
{
    return [[self filePath] hash] ^ [[self name] hash] ^ [[self synthesizedProperties] hash];
}

@end
