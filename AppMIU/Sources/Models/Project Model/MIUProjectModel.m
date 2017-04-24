//
//  MIUProjectModel.m
//  AppMIU
//
//  Created by Ovcharuk on 11/4/16.
//  Copyright © 2016 NIX. All rights reserved.
//

#import "MIUProjectModel.h"

#define MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionary, property)\
    if ([self property] != nil)\
    {\
        [dictionary setObject:[self property] forKey:NSStringFromSelector(@selector(property))];\
    }

@interface MIUProjectModel ()

@end

@implementation MIUProjectModel

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self setPathes:[NSArray array]];
    }
    
    return self;
}

- (instancetype)initWithID:(NSString *)projectID projectName:(NSString *)projectName rootFolder:(NSString *)rootFolder
{
    self = [super init];
    
    if (self)
    {
        [self setProjectID:projectID];
        [self setProjectName:projectName];
        [self setRootFolder:rootFolder];
        [self setPathes:[NSArray array]];
    }
    
    return self;
}

// generated
- (id)copyWithZone:(NSZone *)theZone
{
    MIUProjectModel *copy = [[[self class] alloc] init];

    if (copy)
    {
        [copy setProjectID:[self projectID]];
        [copy setProjectName:[self projectName]];
        [copy setPathes:[self pathes]];
        [copy setRootFolder:[self rootFolder]];
    }

    return copy;
}

// generated
- (void)encodeWithCoder:(NSCoder *)theCoder
{
    NSMutableDictionary *dictionaryForEncoding = [NSMutableDictionary dictionary];

    MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionaryForEncoding, projectID);
    MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionaryForEncoding, projectName);
    MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionaryForEncoding, pathes);
    MIU_DICTIONARY_SET_POINTER_PROPERTY(dictionaryForEncoding, rootFolder);

    [theCoder encodeObject:dictionaryForEncoding forKey:NSStringFromClass([MIUProjectModel class])];
}

// generated
- (id)initWithCoder:(NSCoder *)theDecoder
{
    self = [super init];

    if (self)
    {
        NSDictionary *dictionaryForDecoding = [theDecoder decodeObjectForKey:NSStringFromClass([MIUProjectModel class])];

        [self setProjectID:dictionaryForDecoding[NSStringFromSelector(@selector(projectID))]];
        [self setProjectName:dictionaryForDecoding[NSStringFromSelector(@selector(projectName))]];
        [self setPathes:dictionaryForDecoding[NSStringFromSelector(@selector(pathes))]];
        [self setRootFolder:dictionaryForDecoding[NSStringFromSelector(@selector(rootFolder))]];
    }

    return self;
}

// generated
- (BOOL)isEqual:(MIUProjectModel *)theObject
{
    if (theObject == self)
    {
        return YES;
    }

    if ([self class] != [theObject class])
    {
        return NO;
    }

    if (([self projectID] != [theObject projectID] && ![[self projectID] isEqual:[theObject projectID]]) ||
        ([self projectName] != [theObject projectName] && ![[self projectName] isEqual:[theObject projectName]]) ||
        ([self pathes] != [theObject pathes] && ![[self pathes] isEqualToArray:[theObject pathes]]) ||
        ([self rootFolder] != [theObject rootFolder] && ![[self rootFolder] isEqual:[theObject rootFolder]]))
    {
        return NO;
    }

    return YES;
}

// generated
- (NSString *)description
{
    NSMutableString *description = [NSMutableString new];

    [description appendString:[NSString stringWithFormat:@"projectID - %@ \n", [self projectID]]];
    [description appendString:[NSString stringWithFormat:@"projectName - %@ \n", [self projectName]]];
    [description appendString:[NSString stringWithFormat:@"pathes - %@ \n", [self pathes]]];
    [description appendString:[NSString stringWithFormat:@"rootFolder - %@ \n", [self rootFolder]]];

    return description;
}

// generated
- (NSUInteger)hash
{
    return [[self projectID] hash] ^ [[self projectName] hash] ^ [[self pathes] hash] ^ [[self rootFolder] hash];
}

@end
