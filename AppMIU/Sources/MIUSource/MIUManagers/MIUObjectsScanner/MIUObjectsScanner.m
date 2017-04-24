//
//  MIUObjectsScanner.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/6/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//
#import "MIUObjectsScanner.h"
#import "MIUProtocolsScanner.h"
#import "MIUInterfacesScanner.h"
#import "MIUImplementationsScanner.h"
#import "MIUEnumsScanner.h"

#import "MIUInterface.h"
#import "MIUImplementation.h"
#import "MIUClass.h"
#import "MIUProperty.h"
#import "MIUProtocol.h"

@implementation MIUObjectsScanner

- (NSSet *)classesFromPaths:(NSSet *)paths withRootProjectPath:(NSSet *)rootPathes
{
    NSArray *protocols = [[MIUProtocolsScanner new] protocolsFromFilePathes:[rootPathes allObjects]];
    NSDictionary *protocolsRecursivelyMerged = [self protocolsDictionary:protocols]; // key PRotocol name value:array of properties
    
    NSSet *interfaces = [self interfacesFromFilePaths:paths];
    NSMutableSet *setWithInterfaces = [interfaces mutableCopy];
    NSSet *implementations = [[[MIUImplementationsScanner alloc] init] implementationsFromFilesAtPaths:paths];
    
    NSMutableSet *classes = [NSMutableSet new];
    
    for (MIUInterface *interface in interfaces)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", [interface name]];
        NSSet *filteredInterfaces = [setWithInterfaces filteredSetUsingPredicate:predicate];
        [self deleteInterfaces:filteredInterfaces fromSet:setWithInterfaces];
        
        if ([filteredInterfaces count] != 0)
        {
            MIUClass *class = [self classFromInterfaces:filteredInterfaces];
            [self addInformationsAboutImplementationToClass:class fromImplementations:implementations];
            [classes addObject:class];
        }
    }
    
    for (MIUClass *class in classes)
    {
        [self injectNeededObjectsInClass:class enums:nil protocols:protocolsRecursivelyMerged];
    }
    
    return classes;
}

- (NSSet *)enumsFromPaths:(NSSet *)paths
{
    MIUEnumsScanner *enumScanner = [MIUEnumsScanner new];
    NSMutableSet *resultSet = [NSMutableSet new];
    
    for (NSString *path in paths)
    {
        NSString *contentOfFile = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [resultSet addObjectsFromArray:[[enumScanner enumsFromString:contentOfFile] allObjects]];
    }
    
    return resultSet;
}

- (void)addInformationsAboutImplementationToClass:(MIUClass *)class fromImplementations:(NSSet *)implementations
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name==%@ AND isCategory == NO", [class name]];
    NSSet *filteredImplementations = [implementations filteredSetUsingPredicate:predicate];
    
    if ([filteredImplementations count] == 1)
    {
        MIUImplementation *implementation = [[filteredImplementations allObjects] firstObject];
        [class setImplementation:implementation];
    }
    else
    {
        NSAssert(YES, @"More than one implementations for merged interface");
    }
}

- (MIUClass *)classFromInterfaces:(NSSet *)interfaces
{
    MIUClass *class = [MIUClass new];
    [class setConformedToProtocolsStrings:[self protcolsFromInterfaces:[interfaces allObjects]]];
    
    if ([interfaces count] == 1)
    {
        MIUInterface *interface = [[interfaces allObjects] firstObject];
        [class setName:[interface name]];
        [class setProperties:[interface properties]];
        [class setSuperClass:[interface superClass]];
    }
    else
    {
        [class setName:[[[interfaces allObjects] firstObject] name]];
        [class setProperties:[self mergedPropertiesFromInterfacesWithSameName:interfaces]];
        
        for (MIUInterface *intrfc in interfaces)
        {
            if ([[intrfc superClass] length] > 0)
            {
                [class setSuperClass:[intrfc superClass]];
            }
        }
    }
    
    return class;
}

- (NSSet *)mergedPropertiesFromInterfacesWithSameName:(NSSet *)interfaces
{
    NSMutableSet *properties = [NSMutableSet new];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"extension == YES"];
    NSSet *extensions = [interfaces filteredSetUsingPredicate:predicate];
    
    for (MIUInterface *interface in extensions)
    {
        [properties addObjectsFromArray:[[interface properties] allObjects]];
    }
    
    NSPredicate *interfacePredicat = [NSPredicate predicateWithFormat:@"extension == NO"];
    NSSet *filteredInterfaces = [interfaces filteredSetUsingPredicate:interfacePredicat];
    
    for (MIUInterface *interface in filteredInterfaces)
    {
        [self addUncontainedPropertyToSet:properties fromInterface:interface];
    }
    
    return properties;
}

- (void)addUncontainedPropertyToSet:(NSMutableSet *)properties fromInterface:(MIUInterface *)interface
{
    for (MIUProperty *property in [interface properties])
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", [property name]];
        NSSet *filteredProperties = [properties filteredSetUsingPredicate:predicate];
        
        if ([filteredProperties count] == 0)
        {
            [properties addObject:property];
        }
    }
}

- (void)deleteInterfaces:(NSSet *)interfaces fromSet:(NSMutableSet *)set
{
    for (MIUInterface *interface in interfaces)
    {
        [set removeObject:interface];
    }
}

#pragma -mark method to get interfaces from file paths

- (NSSet *)interfacesFromFilePaths:(NSSet *)paths
{
    NSMutableSet *interfacesFromFiles = [NSMutableSet new];
    MIUInterfacesScanner *interfacesScanner = [MIUInterfacesScanner new];
    
    for (NSString *path in paths)
    {
        NSSet *interfaces = [interfacesScanner interfacesFromFileAtPath:path];
        [interfacesFromFiles addObjectsFromArray:[interfaces allObjects]];
    }
    
    return interfacesFromFiles;
}

- (void)injectNeededObjectsInClass:(MIUClass *)class enums:(NSSet *)enums protocols:(NSDictionary *)protocols
{
    for (NSString *conformedProtocol in [class conformedToProtocolsStrings])
    {
        NSArray *propertiesFromProtocol = [protocols objectForKey:conformedProtocol];
        
        for (MIUProperty *propertyFromProtocol in propertiesFromProtocol)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", [propertyFromProtocol name]];
            NSSet *filteredProperties = [[class properties] filteredSetUsingPredicate:predicate];
            
            if ([filteredProperties count] == 0 && [[[class implementation] synthesizedProperties] indexOfObject:[propertyFromProtocol name]] != NSNotFound)
            {
                NSMutableArray *properties = [[[class properties] allObjects] mutableCopy];
                [properties addObject:propertyFromProtocol];
                
                [class setProperties:[NSSet setWithArray:properties]];
            }
        }
    }
}

- (NSArray *)arrayOfConformingProtocols:(MIUProtocol *)protocol protocols:(NSArray *)protocols
{
    NSMutableArray *tempProtocols = [NSMutableArray new];
    NSArray *protocolsNames = [protocols valueForKey:@"protocolName"];
    
    for (NSString *conformedProtocol in [protocol conformedToProtocols])
    {
        if ([protocolsNames containsObject:conformedProtocol])
        {
            for (MIUProtocol *protocolForSearch in protocols)
            {
                if ([[protocolForSearch protocolName] isEqualToString:conformedProtocol])
                {
                    [tempProtocols addObject:protocolForSearch];
                    
                    NSArray *newProtocols = [self arrayOfConformingProtocols:protocolForSearch protocols:protocols];
                    
                    if (newProtocols)
                    {
                        [tempProtocols addObject:newProtocols];
                    }
                }
            }
        }
        else
        {
            MIUProtocol *tempProtocol = [MIUProtocol new];
            [tempProtocol setProtocolName:conformedProtocol];
            [tempProtocol setStatus:MIUProtocolStatusNotFound];
            
            [tempProtocols addObject:tempProtocol];
        }
    }
    
    return tempProtocols;
}

- (NSArray *)arrayWithUnknownProtocolsFromProtocls:(NSArray *)protocols
{
    if ([protocols count] > 0)
    {
        NSMutableArray *unknownProtocols = [NSMutableArray arrayWithArray:protocols];
        
        if ([unknownProtocols containsObject:@"NSObject"])
        {
            [unknownProtocols removeObject:@"NSObject"];
        }
        
        if ([unknownProtocols containsObject:@"NSCopying"])
        {
            [unknownProtocols removeObject:@"NSCopying"];
        }
        
        if ([unknownProtocols containsObject:@"NSCoding"])
        {
            [unknownProtocols removeObject:@"NSCoding"];
        }

        return unknownProtocols;
    }
    
    return nil;
}

- (NSArray *)protcolsFromInterfaces:(NSArray *)interfaces
{
    NSMutableSet *protocols = [NSMutableSet new];
    
    for (MIUInterface *interface in interfaces)
    {
        if ([[interface conformedToProtocols] count] > 0)
        {
            [protocols addObjectsFromArray:[interface conformedToProtocols]];
        }
    }
    
    return [protocols allObjects];
}

- (MIUProtocol *)protocolWithName:(NSString *)protocolName fromProtocols:(NSArray *)protocols
{
    for (MIUProtocol *cPRT in protocols)
    {
        if ([[cPRT protocolName] isEqualToString:protocolName])
        {
            return cPRT;
        }
    }
    
    return nil;
}

- (NSDictionary *)protocolsDictionary:(NSArray *)protocols
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    for (MIUProtocol *prt in protocols)
    {
        NSMutableArray *mut = [NSMutableArray new];
        
        [self propertiesForProtocol:prt protocols:protocols resultProperties:mut];
        
        if ([mut count] > 0)
        {
            [dict setValue:mut forKey:[prt protocolName]];
        }
    }
    
    return dict;
}

- (void)propertiesForProtocol:(MIUProtocol *)prt protocols:(NSArray *)protocols resultProperties:(NSMutableArray *)resultProperties
{
    NSArray *conformedProtocols = [self arrayWithUnknownProtocolsFromProtocls:[prt conformedToProtocols]];
    
    if ([conformedProtocols count] == 0)
    {
        if ([[prt properties] count] > 0)
        {
            [resultProperties addObjectsFromArray:[prt properties]];
        }
    }
    else
    {
        if ([[prt properties] count] > 0)
        {
            [resultProperties addObjectsFromArray:[prt properties]];
        }
        
        for (NSString *cPRT in conformedProtocols)
        {
            MIUProtocol *protocolll = [self protocolWithName:cPRT fromProtocols:protocols];
            [self propertiesForProtocol:protocolll protocols:protocols resultProperties:resultProperties];
        }
        
    }
}

@end
