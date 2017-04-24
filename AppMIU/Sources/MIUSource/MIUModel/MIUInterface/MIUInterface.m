//
//  MIUInterface.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/3/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUInterface.h"

static NSString *MIUBaseClass = @"NSObject";

@implementation MIUInterface

#pragma mark -  Public

- (instancetype)initWithName:(NSString *)name
                 isExtension:(BOOL)isExtension
               andProperties:(NSSet *)properties
                  superClass:(NSString *)superClass
        conformedToProtocols:(NSArray *)conformedProtocols
{
    self = [super init];
    
    if (self != nil)
    {
        _name = name;
        _extension = isExtension;
        _properties = properties;
        _superClass = superClass;
        _conformedToProtocols = conformedProtocols;
    }
    
    return self;
}

- (BOOL)isBase
{
    return [[self superClass] isEqualToString:MIUBaseClass];
}

- (BOOL)isEqual:(MIUInterface *)theObject
{
    if (theObject == self)
    {
        return YES;
    }

    if ([self class] != [theObject class])
    {
        return NO;
    }

    if (([self name] != [theObject name] && ![[self name] isEqual:[theObject name]]) ||
        ([self superClass] != [theObject superClass] && ![[self superClass] isEqual:[theObject superClass]]) ||
        ([self properties] != [theObject properties] && ![[self properties] isEqualToSet:[theObject properties]]) ||
        ([self conformedToProtocols] != [theObject conformedToProtocols] &&
         ![[NSSet setWithArray:[self conformedToProtocols]] isEqualToSet:[NSSet setWithArray:[theObject conformedToProtocols]]]) ||
        ([self isExtension] != [theObject isExtension]) ||
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

    [description appendString:[NSString stringWithFormat:@"name - %@ \n", [self name]]];
    [description appendString:[NSString stringWithFormat:@"superClass - %@ \n", [self superClass]]];
    [description appendString:[NSString stringWithFormat:@"properties - %@ \n", [self properties]]];
    [description appendString:[NSString stringWithFormat:@"conformedToProtocols - %@ \n", [self conformedToProtocols]]];
    [description appendString:[NSString stringWithFormat:@"extension - %@ \n", [self isExtension] ? @"YES" : @"NO"]];
    [description appendString:[NSString stringWithFormat:@"synthesizedProperties - %@ \n", [self synthesizedProperties]]];

    return description;
}

- (NSUInteger)hash
{
    return [[self name] hash] ^ [[self superClass] hash] ^ [[self properties] hash] ^ [[self conformedToProtocols] hash] ^ [self isExtension] ^ [[self synthesizedProperties] hash];
}

@end
