//
//  MIUProtocol.m
//  ModelImprovementUtility
//
//  Created by Nesteforenko Andrey on 10/27/15.
//  Copyright © 2015 NIX. All rights reserved.
//

#import "MIUProtocol.h"

static NSString *const MIUBaseProtocol = @"NSObject";

@interface MIUProtocol ()

/**
 *  contains conformed |MIUProtocol *| objects
 */
@property(nonatomic, strong) NSArray *conformedToProtocolsModels;

@end

@implementation MIUProtocol

#pragma mark - Public

- (BOOL)isBaseProtocol
{
    if ([[self conformedToProtocols] containsObject:MIUBaseProtocol])
    {
        return YES;
    }
    
    if ([[self conformedToProtocols] count] == 0)
    {
        return YES;
    }
    
    return NO;
}

- (NSArray *)propertiesFromAllConformedProtocols
{
    NSMutableArray *allProperties = [[NSMutableArray alloc] init];
    [allProperties addObjectsFromArray:[self properties]];
    
    for (MIUProtocol *protocol in [self conformedToProtocolsModels])
    {
        [allProperties addObjectsFromArray:[protocol properties]];
    }
    
    return allProperties;
}

- (void)appendWithNeededProtocolsModels:(NSArray *)protocolModels
{
    [self setConformedToProtocolsModels:protocolModels];
}

- (id)copyWithZone:(NSZone *)theZone
{
    MIUProtocol *copy = [[[self class] alloc] init];

    if (copy)
    {
        [copy setProtocolName:[self protocolName]];
        [copy setProperties:[[self properties] copy]];
        [copy setConformedToProtocols:[[self conformedToProtocols] copy]];
        [copy setStatus:[self status]];
    }

    return copy;
}

- (BOOL)isEqual:(MIUProtocol *)theObject
{
    if (theObject == self)
    {
        return YES;
    }

    if ([self class] != [theObject class])
    {
        return NO;
    }

    if (([self protocolName] != [theObject protocolName] && ![[self protocolName] isEqual:[theObject protocolName]]) ||
        ([self properties] != [theObject properties] && ![[NSSet setWithArray:[self properties]] isEqualToSet:[NSSet setWithArray:[theObject properties]]]) ||
        ([self conformedToProtocols] != [theObject conformedToProtocols] &&
         ![[NSSet setWithArray:[self conformedToProtocols]] isEqualToSet:[NSSet setWithArray:[theObject conformedToProtocols]]]) ||
        ([self status] != [theObject status]))
    {
        return NO;
    }

    return YES;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString new];

    [description appendString:[NSString stringWithFormat:@"protocolName - %@ \n", [self protocolName]]];
    [description appendString:[NSString stringWithFormat:@"properties - %@ \n", [self properties]]];
    [description appendString:[NSString stringWithFormat:@"conformedToProtocols - %@ \n", [self conformedToProtocols]]];
    [description appendString:[NSString stringWithFormat:@"status - %@ \n", [@([self status]) stringValue]]];

    return description;
}

- (NSUInteger)hash
{
    return [[self protocolName] hash] ^ [[self properties] hash] ^ [[self conformedToProtocols] hash] ^ [self status];
}

@end
