//
//  MIUImplementationScanner.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/8/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUImplementationsScanner.h"
#import "MIUImplementation.h"

@implementation MIUImplementationsScanner

- (NSSet *)implementationsFromFilesAtPaths:(NSSet *)paths
{
    NSMutableSet *implementations = [NSMutableSet new];
    
    for (NSString *path in paths)
    {
        NSArray<MIUImplementation *> *tempImplementations = [self implementationFromFilePath:path];

        if ([tempImplementations count] > 0)
        {
            [implementations addObjectsFromArray:tempImplementations];
        }
    }
    
    return implementations;
}

- (NSArray<MIUImplementation *> *)implementationFromFilePath:(NSString *)path
{
    NSMutableArray *implementations = [NSMutableArray new];
    
    NSString *contentOfFile = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    // pattern for creating from content of file at path MIUImplementation model
    // 1 match group full implementation from "@implementation" to "@end"
    // 2 match group is implementation name
    NSString *pattern = [NSString stringWithFormat:@"(\\@implementation\\s*(\\w*)(\\s*\\(\\s*\\w*\\s*\\)\\s*)?((.*\\s)*?)\\s*\\@end)"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    NSArray *matches = [regex matchesInString:contentOfFile options:0 range:NSMakeRange(0, [contentOfFile length])];
    
    for (NSTextCheckingResult *match in matches)
    {
        NSString *implementationString = [contentOfFile substringWithRange:[match rangeAtIndex:1]];
        NSArray *syntheziedProperties = [self synthesizedPropertiesFromString:implementationString];
        
        MIUImplementation *implementation = [MIUImplementation new];
        
        [implementation setFilePath:path];
        [implementation setRange:[match rangeAtIndex:1]];
        [implementation setName:[contentOfFile substringWithRange:[match rangeAtIndex:2]]];
        [implementation setSynthesizedProperties:syntheziedProperties];
        [implementation setCategory:([match rangeAtIndex:3].location != NSNotFound)];
        
        [implementations addObject:implementation];
    }
    
    return implementations;
}

#pragma mark - Private

- (NSArray *)synthesizedPropertiesFromString:(NSString *)string
{
    NSMutableArray *properties = [NSMutableArray new];
    
    // 1 - main name
    // 2 - assigned name
    NSString *patternForSynthesizedProperty = @"\\@synthesize\\s*(\\w*)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:patternForSynthesizedProperty options:0 error:NULL];
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    for (NSTextCheckingResult *match in matches)
    {
        NSString *synthesisedPropertyName = nil;
        
        if ([match rangeAtIndex:1].location != NSNotFound)
        {
            synthesisedPropertyName = [string substringWithRange:[match rangeAtIndex:1]];
            [properties addObject:synthesisedPropertyName];
        }
    }
    
    return properties;
}

@end
