//
//  MIUInterfacesScanner.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/3/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUInterfacesScanner.h"
#import "MIUInterface.h"
#import "MIUPropertiesScanner.h"
#import "MIUInterface.h"
#import "MIUProperty.h"
#import "MIUPropertyScanner.h"

@implementation MIUInterfacesScanner

- (NSSet *)interfacesFromString:(NSString *)contentOfFile
{
    NSMutableSet *interfaces = [NSMutableSet new];
    // pattern to parsing and creating interfaces models from content of file at path
    NSString *pattern = @"\\@interface\\s*(\\w*)\\s*(?:(?:\\:\\s*(\\w*))|(\\(\\s*\\)))\\s*(?:\\<(.*)\\>)?\\s*((?:.*\\s*)*?)\\@end";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    NSArray *matchesFromString = [regex matchesInString:contentOfFile options:0 range:NSMakeRange(0, [contentOfFile length])];
    
    for (NSTextCheckingResult *match in matchesFromString)
    {
        NSString *name = [contentOfFile substringWithRange:[match rangeAtIndex:1]];
        
        BOOL isExtension = NO;
        NSArray *protocols = nil;
        NSString *superClass = nil;
        NSString *properties = nil;
        
        if ([match rangeAtIndex:2].location != NSNotFound)
        {
            superClass = [contentOfFile substringWithRange:[match rangeAtIndex:2]];
        }
        
        if ([match rangeAtIndex:3].location != NSNotFound)
        {
            NSString *extension = [contentOfFile substringWithRange:[match rangeAtIndex:3]];
            
            NSString *patternForCheckIsExtension = @"\\(\\s*\\)";
            NSRegularExpression *regularExpressionForCheckIsExtension = [NSRegularExpression regularExpressionWithPattern:patternForCheckIsExtension
                                                                                                                  options:0
                                                                                                                    error:NULL];
            
            if ([extension length] > 0)
            {
                isExtension = [[regularExpressionForCheckIsExtension matchesInString:extension options:0 range:NSMakeRange(0, [extension length])] count] > 0;
            }
        }
        
        if ([match rangeAtIndex:4].location != NSNotFound)
        {
            NSString *protocolsString = [contentOfFile substringWithRange:[match rangeAtIndex:4]];
            NSString *protocolsWithoutSpaces = [protocolsString stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            protocols = [protocolsWithoutSpaces componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%@", @","]]];
        }
        
        if ([match rangeAtIndex:5].location != NSNotFound)
        {
            properties = [contentOfFile substringWithRange:[match rangeAtIndex:5]];
        }
        
        MIUInterface *interface = [self interfaceWithName:name
                                              isExtension:isExtension
                                               superClass:superClass
                                  andStringWithProperties:properties
                                     conformedToProtocols:protocols];
        
        [interfaces addObject:interface];
    }
    
    return interfaces;
}

- (NSSet *)interfacesFromFileAtPath:(NSString *)path
{
    NSString *contentOfFile = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    return [self interfacesFromString:contentOfFile];
}

- (NSSet *)propertiesFromStrings:(NSSet *)properties
{
    NSMutableSet *propertyObjectes = [NSMutableSet new];
    MIUPropertyScanner *propertyScanner = [MIUPropertyScanner new];
    
    for (NSString *stringWithProperty in properties)
    {
        MIUProperty *property = [propertyScanner propertyWithString:stringWithProperty];
        
        if (property)
        {
            [propertyObjectes addObject:property];
        }
        else
        {
            NSLog(@"Cant Parse property %@", stringWithProperty);
        }
    }
    
    return propertyObjectes;
}

- (MIUInterface *)interfaceWithName:(NSString *)name
                        isExtension:(BOOL)isExtension
                         superClass:(NSString *)superClass
            andStringWithProperties:(NSString *)stringWithProperties
               conformedToProtocols:(NSArray *)conformedToProtocol
{
    MIUPropertiesScanner *propertiesScanner = [MIUPropertiesScanner new];
    NSSet *properties = [propertiesScanner propertiesFromString:stringWithProperties];
    NSSet *propertyObjects = [self propertiesFromStrings:properties];
    
    return [[MIUInterface alloc] initWithName:name isExtension:isExtension andProperties:propertyObjects superClass:superClass conformedToProtocols:conformedToProtocol];
}

@end
