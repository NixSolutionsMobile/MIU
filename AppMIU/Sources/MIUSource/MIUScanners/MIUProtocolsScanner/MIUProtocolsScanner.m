//
//  MIUProtocolsScanner.m
//  ModelImprovementUtility
//
//  Created by Nesteforenko Andrey on 10/28/15.
//  Copyright © 2015 NIX. All rights reserved.
//

#import "MIUProtocolsScanner.h"
#import "MIUPropertiesScanner.h"
#import "MIUPropertyScanner.h"

#import "MIUProtocol.h"

// regular expression for matching protocols
// first match groupe  - name (required)
// second match groupe - conformedProtocols (optional) by Default NSObject
// third match groupe  - properties string (optional)
static NSString *const MIUProtocolRegularExpressionPattern = @"\\@protocol\\s*(\\w*)\\s*(?:\\<((?:.|\\s)*?)\\>){0,1}((?:.|\\s)*?)\\@end";

const NSUInteger MIUProtocolName = 1;
const NSUInteger MIUProtocolProtocols = 2;
const NSUInteger MIUProtocolProperties = 3;

@implementation MIUProtocolsScanner

#pragma mark - Public

- (NSArray *)protocolsFromFilePathes:(NSArray *)filePathes
{
    NSMutableArray *protocols = [[NSMutableArray alloc] init];
    
    for (NSString *path in filePathes)
    {
        NSString *contentOfFile = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSArray *protocolsFromFile = [self protocolsFromString:contentOfFile];
        
        [protocols addObjectsFromArray:protocolsFromFile];
    }
    
    return protocols;
}

- (NSArray *)protocolsFromString:(NSString *)fileContent
{
    NSMutableArray *protcols = [NSMutableArray new];

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:MIUProtocolRegularExpressionPattern options:0 error:NULL];
    NSArray *matchesFromString = [regex matchesInString:fileContent options:0 range:NSMakeRange(0, [fileContent length])];

    for (NSTextCheckingResult *match in matchesFromString)
    {
        NSString *conformedProtocolsString = nil;
        NSString *propertiesString = nil;
        
        NSString *name = [fileContent substringWithRange:[match rangeAtIndex:MIUProtocolName]];

        if ([match rangeAtIndex:MIUProtocolProtocols].location != NSNotFound)
        {
            conformedProtocolsString = [fileContent substringWithRange:[match rangeAtIndex:MIUProtocolProtocols]];
        }
        
        if ([match rangeAtIndex:MIUProtocolProperties].location != NSNotFound)
        {
            propertiesString = [fileContent substringWithRange:[match rangeAtIndex:MIUProtocolProperties]];
        }

        MIUProtocol *protocol = [self protocolWithName:name
                              conformedProtocolsString:conformedProtocolsString
                                      propertiesString:propertiesString];
        
        [protcols addObject:protocol];
    }

    return protcols;
}

#pragma mark - Private

- (MIUProtocol *)protocolWithName:(NSString *)name
         conformedProtocolsString:(NSString *)conformedProtocolsString
                 propertiesString:(NSString *)propertiesString
{
    MIUProtocol *protocol = [[MIUProtocol alloc] init];
    [protocol setProtocolName:name];
    
    NSString *protocolsWithoutSpaces = [conformedProtocolsString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *protocols = [protocolsWithoutSpaces componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%@", @","]]];
    
    [protocol setConformedToProtocols:protocols];
    
    MIUPropertiesScanner *propertiesScanner = [[MIUPropertiesScanner alloc] init];
    NSSet *properties = [propertiesScanner propertiesFromString:propertiesString];
    NSSet *propertyObjects = [self propertiesFromStrings:properties];
    [protocol setProperties:[propertyObjects allObjects]];
    
    return protocol;
}

#pragma mark - Proeprties scanning

- (NSSet *)propertiesFromStrings:(NSSet *)properties
{
    NSMutableSet *propertyObjectes = [NSMutableSet new];
    MIUPropertyScanner *propertyScanner = [MIUPropertyScanner new];
    
    for (NSString *stringWithProperty in properties)
    {
        MIUProperty *property = [propertyScanner propertyWithString:stringWithProperty];
        
        if (property == nil)
        {
            NSLog(@"ASAP can't parse property %@", stringWithProperty);
        }
        else
        {
            [propertyObjectes addObject:property];
        }
    }
    
    return propertyObjectes;
}

@end
