//
//  MIUClass.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/6/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUClass.h"
#import "MIUImplementation.h"

#define MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionary, property)\
    if ([self property] != nil)\
    {\
        [dictionary setObject:[self property] forKey:NSStringFromSelector(@selector(property))];\
    }

static NSString *MIUBaseClass = @"NSObject";

@implementation MIUClass

- (instancetype)initWithName:(NSString *)name
                  properties:(NSSet *)properties
           andImplementation:(MIUImplementation *)implementation
                  superClass:(NSString *)superClass
        conformedToProtocols:(NSArray *)conformedToProtocols
{
    self = [super init];
    
    if (self != nil)
    {
        [self setName:name];
        [self setProperties:properties];
        [self setImplementation:implementation];
        [self setSuperClass:superClass];
        [self setConformedToProtocols:conformedToProtocols];
    }
    
    return self;
}

- (instancetype)initWithName:(NSString *)name
                  properties:(NSSet *)properties
                  superClass:(NSString *)superClass
        conformedToProtocols:(NSArray *)conformedToProtocols
{
    self = [super init];
    
    if (self != nil)
    {
        [self setName:name];
        [self setProperties:properties];
        [self setSuperClass:superClass];
        [self setConformedToProtocols:conformedToProtocols];
    }
    
    return self;
}

#pragma mark - Public

- (BOOL)isBase
{
    return [[self superClass] isEqualToString:MIUBaseClass];
}

// generated
- (id)copyWithZone:(NSZone *)theZone
{
    MIUClass *copy = [[[self class] alloc] init];

    if (copy)
    {
        [copy setConformedToProtocols:[[self conformedToProtocols] copy]];
        [copy setConformedToProtocolsStrings:[[self conformedToProtocolsStrings] copy]];
        [copy setProperties:[[self properties] copy]];
        [copy setSuperClass:[self superClass]];
        [copy setName:[[self name] copy]];
        [copy setImplementation:[[self implementation] copy]];
    }

    return copy;
}

// generated
- (void)encodeWithCoder:(NSCoder *)theCoder
{
    NSMutableDictionary *dictionaryForEncoding = [NSMutableDictionary dictionary];

    MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionaryForEncoding, conformedToProtocols);
    MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionaryForEncoding, conformedToProtocolsStrings);
    MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionaryForEncoding, properties);
    MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionaryForEncoding, superClass);
    MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionaryForEncoding, name);
    MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionaryForEncoding, implementation);

    [theCoder encodeObject:dictionaryForEncoding forKey:NSStringFromClass([MIUClass class])];
}

// generated
- (id)initWithCoder:(NSCoder *)theDecoder
{
    self = [super init];

    if (self)
    {
        NSDictionary *dictionaryForDecoding = [theDecoder decodeObjectForKey:NSStringFromClass([MIUClass class])];

        [self setConformedToProtocols:dictionaryForDecoding[NSStringFromSelector(@selector(conformedToProtocols))]];
        [self setConformedToProtocolsStrings:dictionaryForDecoding[NSStringFromSelector(@selector(conformedToProtocolsStrings))]];
        [self setProperties:dictionaryForDecoding[NSStringFromSelector(@selector(properties))]];
        [self setSuperClass:dictionaryForDecoding[NSStringFromSelector(@selector(superClass))]];
        [self setName:dictionaryForDecoding[NSStringFromSelector(@selector(name))]];
        [self setImplementation:dictionaryForDecoding[NSStringFromSelector(@selector(implementation))]];
    }

    return self;
}

// generated
- (BOOL)isEqual:(MIUClass *)theObject
{
    if (theObject == self)
    {
        return YES;
    }

    if ([self class] != [theObject class])
    {
        return NO;
    }

    if (([self conformedToProtocols] != [theObject conformedToProtocols] && ![[self conformedToProtocols] isEqualToArray:[theObject conformedToProtocols]]) ||
        ([self conformedToProtocolsStrings] != [theObject conformedToProtocolsStrings] && ![[self conformedToProtocolsStrings] isEqualToArray:[theObject conformedToProtocolsStrings]]) ||
        ([self properties] != [theObject properties] && ![[self properties] isEqualToSet:[theObject properties]]) ||
        ([self superClass] != [theObject superClass] && ![[self superClass] isEqual:[theObject superClass]]) ||
        ([self name] != [theObject name] && ![[self name] isEqual:[theObject name]]) ||
        ([self implementation] != [theObject implementation] && ![[self implementation] isEqual:[theObject implementation]]))
    {
        return NO;
    }

    return YES;
}

// generated
- (NSString *)description
{
    NSMutableString *description = [NSMutableString new];

    [description appendString:[NSString stringWithFormat:@"conformedToProtocols - %@ \n", [self conformedToProtocols]]];
    [description appendString:[NSString stringWithFormat:@"conformedToProtocolsStrings - %@ \n", [self conformedToProtocolsStrings]]];
    [description appendString:[NSString stringWithFormat:@"properties - %@ \n", [self properties]]];
    [description appendString:[NSString stringWithFormat:@"superClass - %@ \n", [self superClass]]];
    [description appendString:[NSString stringWithFormat:@"name - %@ \n", [self name]]];
    [description appendString:[NSString stringWithFormat:@"implementation - %@ \n", [self implementation]]];

    return description;
}

// generated
- (NSUInteger)hash
{
    return [[self conformedToProtocols] hash] ^ [[self conformedToProtocolsStrings] hash] ^ [[self properties] hash] ^ [[self superClass] hash] ^ [[self name] hash] ^ [[self implementation] hash];
}

@end
