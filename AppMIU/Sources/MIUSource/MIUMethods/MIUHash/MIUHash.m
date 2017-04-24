//
//  MIUHash.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/27/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUHash.h"
#import "MIUClass.h"
#import "MIUProperty.h"

const NSUInteger MIUEmptyHashMethodLength = 13;
const NSUInteger MIULastSpacesAndXorOperationLength = 3;

@implementation MIUHash

- (NSString *)methodBodyForClass:(MIUClass *)class
{
    NSMutableString *methodBody = [NSMutableString new];
    NSMutableString *warnings = [NSMutableString new];
    [methodBody appendString:@"{\n    return "];
    [methodBody appendString:[self isSuperHashNeededForclass:class]];
    
    for (MIUProperty *property in [class properties])
    {
        NSString *hashString = [self hashForProperty:property withWarnings:warnings];
        [methodBody appendString:hashString ? hashString : @""];
    }
    
    [self deleteLastOneXorSymbolWithWhitespaceFrom:methodBody andWarnings:warnings];

    [methodBody appendFormat:@";\n%@%@}", [warnings isEqualToString:@""] ? @"" : @"\n", warnings];
    
    return [methodBody copy];
}

- (NSString *)hashForProperty:(MIUProperty *)property withWarnings:(NSMutableString *)warnings
{
    NSString *hashForProperty;

    NSPredicate *preidacte = [NSPredicate predicateWithFormat:@"SELF.name = %@", [property type]];
    NSSet *enumsTypes = [[self enums] filteredSetUsingPredicate:preidacte];
    
    if ([property isPointer])
    {
        if ([property typeConformed] != nil)
        {
            hashForProperty = [NSString stringWithFormat:@"[(id<NSObject>)[self %@] hash] ^ ", [property getGetter]];
        }
        else
        {
            hashForProperty = [NSString stringWithFormat:@"[[self %@] hash] ^ ", [property getGetter]];
        }
    }
    else if ([[self typesOfDataConformingOperationXor] containsObject:[property type]] || [[enumsTypes allObjects] count])
    {
        hashForProperty = [NSString stringWithFormat:@"[self %@] ^ ", [property getGetter]];
    }
    else if ([[self typesOfDataToGetHashFromNSNumber] containsObject:[property type]])
    {
        hashForProperty = [NSString stringWithFormat:@"[@([self %@]) hash] ^ ", [property getGetter]];
    }
    else
    {
        [[super problematicProperties] setObject:[property type] forKey:[property name]];
        [warnings appendFormat:@"    #warning Not enought info about data type:%@\n", [property type]];
    }

    return hashForProperty;
}

- (NSString *)isSuperHashNeededForclass:(MIUClass *)class
{
    if (![class isBase])
    {
        return @"[super hash] ^ ";
    }
    
    return @"";
}

- (NSSet *)typesOfDataConformingOperationXor
{
    return [NSSet setWithArray:@[
                                    @"int", @"char",
                                    @"unsigned int", @"long",
                                    @"long long", @"unsigned long long", @"BOOL",
                                    @"short", @"unsigned char", @"unsigned short",
                                    @"unsigned long", @"long double", @"NSInteger", @"NSUInteger"
                                ]];
}

- (NSSet *)typesOfDataToGetHashFromNSNumber
{
    return [NSSet setWithArray:@[
                                    @"float",
                                    @"double",
                                    @"CGFloat",
                                    @"NSTimeInterval"
                                ]];
}

- (void)deleteLastOneXorSymbolWithWhitespaceFrom:(NSMutableString *)string andWarnings:(NSMutableString *)warnings
{
    // situation when for generating hash method is not enought data
    if ([string length] == MIUEmptyHashMethodLength)
    {
        [string appendFormat:@"#error you must to override hash method by yourself"];
    }
    else
    {
        [string deleteCharactersInRange:NSMakeRange([string length] - MIULastSpacesAndXorOperationLength, MIULastSpacesAndXorOperationLength)];
    }
}

@end
