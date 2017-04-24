//
//  MIUProperty.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/2/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUProperty.h"

#define MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionary, property)\
    if ([self property] != nil)\
    {\
        [dictionary setObject:[self property] forKey:NSStringFromSelector(@selector(property))];\
    }

@interface MIUProperty ()

@property(nonatomic, strong) NSString *getter;
@property(nonatomic, strong) NSString *setter;

@end

@implementation MIUProperty

- (instancetype)initWithName:(NSString *)name type:(NSString *)type setter:(NSString *)setter getter:(NSString *)getter isPointer:(BOOL)isPointer isAtomic:(BOOL)isAtomic memoryAttribute:(MIUPropertyMemoryAttribute)memoryAttribute isReadonly:(BOOL)isReadonly
{
    if ((self = [super init]))
    {
        [self setName:name];
        [self setType:type];
        [self setSetter:setter];
        [self setGetter:getter];
        [self setIsPointer:isPointer];
        [self setIsAtomic:isAtomic];
        [self setMemoryAttribute:memoryAttribute];
        [self setIsReadonly:isReadonly];
        [self setTypeConformed:nil];
    }
    
    return self;
}

- (instancetype)initWithName:(NSString *)name type:(NSString *)type setter:(NSString *)setter getter:(NSString *)getter isPointer:(BOOL)isPointer isAtomic:(BOOL)isAtomic memoryAttribute:(MIUPropertyMemoryAttribute)memoryAttribute
{
    if ((self = [super init]))
    {
        [self setName:name];
        [self setType:type];
        [self setSetter:setter];
        [self setGetter:getter];
        [self setIsPointer:isPointer];
        [self setIsAtomic:isAtomic];
        [self setMemoryAttribute:memoryAttribute];
        [self setIsReadonly:NO];
        [self setTypeConformed:nil];
    }
    
    return self;
}

- (instancetype)initWithName:(NSString *)name type:(NSString *)type isPointer:(BOOL)isPointer isAtomic:(BOOL)isAtomic memoryAttribute:(MIUPropertyMemoryAttribute)memoryAttribute
{
    if ((self = [super init]))
    {
        [self setName:name];
        [self setType:type];
        [self setSetter:@""];
        [self setGetter:@""];
        [self setIsPointer:isPointer];
        [self setIsAtomic:isAtomic];
        [self setMemoryAttribute:memoryAttribute];
        [self setIsReadonly:NO];
        [self setTypeConformed:nil];
    }
    
    return self;
}

- (instancetype)init
{
    if ((self = [super init]))
    {
        [self setName:@"NAME"];
        [self setType:@"TYPE"];
        [self setSetter:@""];
        [self setGetter:@""];
        [self setIsPointer:NO];
        [self setIsAtomic:NO];
        [self setIsReadonly:NO];
        [self setMemoryAttribute:MIUPropertyMemoryAttributeUnknown];
        [self setTypeConformed:nil];
    }
    
    return self;
}

- (NSString *)getSetter
{
    if ([[self setter] isEqualToString:@""] || [self setter] == nil)
    {
        return [self propertyWordWithKeywordSet];
    }
    
    return [self setter];
}

- (NSString *)propertyWordWithKeywordSet
{
    NSString *firstCapChar = [[_name substringToIndex:1] capitalizedString];
    NSString *cappedString = [_name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[NSString stringWithFormat:@"set%@", firstCapChar]];
    
    return cappedString;
}

- (NSString *)getGetter
{
    if ([[self getter] isEqualToString:@""] || [self setter] == nil)
    {
        return [self name];
    }
    
    return [self getter];
}

- (NSString *)getGetterToUseWithOutSelf
{
    if ([[self getter] isEqualToString:@""] || [self setter] == nil)
    {
        return [NSString stringWithFormat:@"_%@", [self name]];
    }
    
    return [self getter];
}

- (BOOL)isEqual:(id)object
{
    if ([_name isEqualToString:[object name]] &&
        [_type isEqualToString:[object type]] &&
        [_setter isEqualToString:[object setter]] &&
        [_getter isEqualToString:[object getter]] &&
        _isAtomic == [object isAtomic] &&
        _isPointer == [object isPointer] &&
        _memoryAttribute == [object memoryAttribute] &&
        _isReadonly == [object isReadonly])
    {
        return YES;
    }
    
    return NO;
}

- (NSUInteger)hash
{
    return [[self name] hash] ^ [[self type] hash] ^ [[self setter] hash] ^ [[self getter] hash];
}

// generated
- (id)copyWithZone:(NSZone *)theZone
{
    MIUProperty *copy = [[[self class] alloc] init];

    if (copy)
    {
        [copy setName:[[self name] copy]];
        [copy setIsPointer:[self isPointer]];
        [copy setMemoryAttribute:[self memoryAttribute]];
        [copy setIsAtomic:[self isAtomic]];
        [copy setGetter:[[self getter] copy]];
        [copy setSetter:[[self setter] copy]];
        [copy setIsReadonly:[self isReadonly]];
        [copy setType:[[self type] copy]];
        [copy setTypeConformed:[[self typeConformed] copy]];
    }

    return copy;
}

// generated
- (void)encodeWithCoder:(NSCoder *)theCoder
{
    NSMutableDictionary *dictionaryForEncoding = [NSMutableDictionary dictionary];

    MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionaryForEncoding, name);
    [dictionaryForEncoding setObject:@([self isPointer]) forKey:NSStringFromSelector(@selector(isPointer))];
    [dictionaryForEncoding setObject:[NSData dataWithBytes:&_memoryAttribute length:sizeof(MIUPropertyMemoryAttribute)] forKey:NSStringFromSelector(@selector(memoryAttribute))];
    [dictionaryForEncoding setObject:@([self isAtomic]) forKey:NSStringFromSelector(@selector(isAtomic))];
    MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionaryForEncoding, getter);
    MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionaryForEncoding, setter);
    [dictionaryForEncoding setObject:@([self isReadonly]) forKey:NSStringFromSelector(@selector(isReadonly))];
    MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionaryForEncoding, type);
    MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionaryForEncoding, typeConformed);

    [theCoder encodeObject:dictionaryForEncoding forKey:NSStringFromClass([MIUProperty class])];
}

// generated
- (id)initWithCoder:(NSCoder *)theDecoder
{
    self = [super init];

    if (self)
    {
        NSDictionary *dictionaryForDecoding = [theDecoder decodeObjectForKey:NSStringFromClass([MIUProperty class])];

        [self setName:dictionaryForDecoding[NSStringFromSelector(@selector(name))]];
        [self setIsPointer:[dictionaryForDecoding[NSStringFromSelector(@selector(isPointer))] boolValue]];
        MIUPropertyMemoryAttribute memoryAttribute;
        [dictionaryForDecoding[NSStringFromSelector(@selector(memoryAttribute))] getBytes:&memoryAttribute length:sizeof(MIUPropertyMemoryAttribute)];
        [self setMemoryAttribute:memoryAttribute];
        [self setIsAtomic:[dictionaryForDecoding[NSStringFromSelector(@selector(isAtomic))] boolValue]];
        [self setGetter:dictionaryForDecoding[NSStringFromSelector(@selector(getter))]];
        [self setSetter:dictionaryForDecoding[NSStringFromSelector(@selector(setter))]];
        [self setIsReadonly:[dictionaryForDecoding[NSStringFromSelector(@selector(isReadonly))] boolValue]];
        [self setType:dictionaryForDecoding[NSStringFromSelector(@selector(type))]];
        [self setTypeConformed:dictionaryForDecoding[NSStringFromSelector(@selector(typeConformed))]];
    }

    return self;
}

// generated
- (NSString *)description
{
    NSMutableString *description = [NSMutableString new];

    [description appendString:[NSString stringWithFormat:@"name - %@ \n", [self name]]];
    [description appendString:[NSString stringWithFormat:@"isPointer - %@ \n", [self isPointer] ? @"YES" : @"NO"]];
    [description appendString:[NSString stringWithFormat:@"memoryAttribute - %@ \n", [@([self memoryAttribute]) stringValue]]];
    [description appendString:[NSString stringWithFormat:@"isAtomic - %@ \n", [self isAtomic] ? @"YES" : @"NO"]];
    [description appendString:[NSString stringWithFormat:@"getter - %@ \n", [self getter]]];
    [description appendString:[NSString stringWithFormat:@"setter - %@ \n", [self setter]]];
    [description appendString:[NSString stringWithFormat:@"isReadonly - %@ \n", [self isReadonly] ? @"YES" : @"NO"]];
    [description appendString:[NSString stringWithFormat:@"type - %@ \n", [self type]]];
    [description appendString:[NSString stringWithFormat:@"typeConformed - %@ \n", [self typeConformed]]];

    return description;
}

@end
