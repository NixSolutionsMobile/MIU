//
//  MIUEnumsScanner.m
//  ModelImprovementUtilite
//
//  Created by Nesteforenko Andrey on 9/17/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUEnumsScanner.h"


@implementation MIUEnumsScanner

#pragma mark - Public

- (NSSet *)enumsFromPathes:(NSSet *)pathes
{
    NSMutableArray *enums = [NSMutableArray new];
    
    for (NSString *path in pathes)
    {
        NSString *contentOfFile = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSSet *tempEnums = [self enumsFromString:contentOfFile];
        [enums addObjectsFromArray:[tempEnums allObjects]];
    }
    
    return [NSSet setWithArray:enums];
}

- (NSSet *)enumsFromString:(NSString *)fileContent
{
    // pattern for parsing NS_ENUM
    NSString *pattern = @"typedef\\s*(?:NS_ENUM|NS_OPTIONS)\\s*\\(\\s*(\\w*)\\s*\\,\\s*(\\w*)";
    NSSet *nsEnums = [self enumsFromFile:fileContent regularExpressionPattern:pattern];

    // pattern for parsing enum
    NSString *patternEnum = @"typedef\\s*enum\\s*\\:\\s*(\\w*)\\s*\\{(?:\\s|.)*?\\}\\s*(\\w*)";
    NSSet *enums = [self enumsFromFile:fileContent regularExpressionPattern:patternEnum];
 
    // in regex
    // 1 match group is enum TYPE
    // 2 match group is enum NAME
    
    if ([nsEnums count] > 0 && [enums count] > 0)
    {
        NSMutableArray *resultEnums = [NSMutableArray new];
        [resultEnums addObjectsFromArray:[nsEnums allObjects]];
        [resultEnums addObjectsFromArray:[enums allObjects]];
        
        return [NSSet setWithArray:resultEnums];
    }
    
    if ([nsEnums count] > 0)
    {
        return nsEnums;
    }
    
    if ([enums count] > 0)
    {
        return enums;
    }
    
    return nil;
}

#pragma mark - Private

- (NSSet *)enumsFromFile:(NSString *)contentOfFile regularExpressionPattern:(NSString *)pattern
{
    NSMutableSet *enums = [[NSMutableSet alloc] init];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    NSArray *matchesFromString = [regex matchesInString:contentOfFile options:0 range:NSMakeRange(0, [contentOfFile length])];
    
    for (NSTextCheckingResult *match in matchesFromString)
    {
        NSString *type = [contentOfFile substringWithRange:[match rangeAtIndex:1]];
        NSString *name = [contentOfFile substringWithRange:[match rangeAtIndex:2]];
        
        MIUEnum *foundEnum = [[MIUEnum alloc] initEnumWithName:name type:type];
        [enums addObject:foundEnum];
    }
    
    return enums;
}

@end
