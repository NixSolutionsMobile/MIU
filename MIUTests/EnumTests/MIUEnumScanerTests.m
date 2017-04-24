//
//  MIUEnumScanerTests.m
//  ModelImprovementUtility
//
//  Created by Nesteforenko Andrey on 10/28/15.
//  Copyright © 2015 NIX. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIUEnum.h"
#import "MIUEnumsScanner.h"

#pragma mark - NS_Enums strings

static NSString *const stringWithDefaultNSEnumFormatedCorrectly = @"typedef NS_ENUM(NSUInteger, DefaultNSEnum)\n"
                                                                "{\n"
                                                                    "Value1 = 0,\n"
                                                                    "Value2\n"
                                                                    "Value3\n"
                                                                "};";

static NSString *const stringWithDefaultNSEnumFormatedUncorrectly = @"typedef    NS_ENUM( NSUInteger  , DefaultNSEnum )\n"
                                                                    "{\n"
                                                                        "     Value1   =   0 ,  \n"
                                                                        "Value2 \n"
                                                                        " Value3\n"
                                                                    " }; ";

#pragma mark - Enum strings

static NSString *const stringWithDefaultEnumFormatedCorrectly = @"typedef enum : NSUInteger\n"
                                                                "{\n"
                                                                    "Value1 = 0,\n"
                                                                    "Value2\n"
                                                                    "Value3\n"
                                                                "} DefaultEnum;";

static NSString *const stringWithDefaultEnumFormatedUncorrectly = @"typedef enum : NSUInteger\n"
                                                                    "{\n"
                                                                    "      Value1   =   0  ,  \n"
                                                                    "Value2 \n"
                                                                    "  Value3\n"
                                                                    "  }  DefaultEnum;  ";

#pragma mark - Combined string with few enums

static NSString *const stringWithCombinedEnumsFormattedRandomly = @"typedef    NS_ENUM( NSUInteger  , DefaultNSEnum )\n"
                                                                "{\n"
                                                                    "     Value1   =   0 ,  \n"
                                                                    "Value2 \n"
                                                                    " Value3\n"
                                                                " }; "
                                                                "\n"
                                                                "\n"
                                                                "typedef enum : NSUInteger\n"
                                                                "{\n"
                                                                    "Value1 = 0,\n"
                                                                    "Value2\n"
                                                                    "Value3\n"
                                                                "} DefaultEnum;";


@interface MIUEnumScanerTests : XCTestCase

@end

@implementation MIUEnumScanerTests

#pragma mark - NS_ENUM tests

- (void)testToScanDefaultNSEnumFormattedCorrectlyReturnExpectedModel
{
    MIUEnumsScanner *scanner = [self enumScanner];
    NSSet *enums = [scanner enumsFromString:stringWithDefaultNSEnumFormatedCorrectly];
    
    XCTAssertEqualObjects(enums, [NSSet setWithObject:[self defaultNSEnum]]);
}

- (void)testToScanDefaultNSEnumFormattedUncorrectlyReturnExpectedModel
{
    MIUEnumsScanner *scanner = [self enumScanner];
    NSSet *enums = [scanner enumsFromString:stringWithDefaultNSEnumFormatedUncorrectly];
    
    XCTAssertEqualObjects(enums, [NSSet setWithObject:[self defaultNSEnum]]);
}

#pragma mark - enum tests

- (void)testToScanDefaultEnumFormattedCorrectlyReturnExpectedModel
{
    MIUEnumsScanner *scanner = [self enumScanner];
    NSSet *enums = [scanner enumsFromString:stringWithDefaultEnumFormatedCorrectly];
    
    XCTAssertEqualObjects(enums, [NSSet setWithObject:[self defaultEnum]]);
}

- (void)testToScanDefaultEnumFormattedUncorrectlyReturnExpectedModel
{
    MIUEnumsScanner *scanner = [self enumScanner];
    NSSet *enums = [scanner enumsFromString:stringWithDefaultEnumFormatedUncorrectly];
    
    XCTAssertEqualObjects(enums, [NSSet setWithObject:[self defaultEnum]]);
}

#pragma mark - Combined NS_Enum and enum tests

- (void)testToScanCombinedStringWithEnumsReturnExpectedModel
{
    MIUEnumsScanner *scanner = [self enumScanner];
    NSSet *enums = [scanner enumsFromString:stringWithCombinedEnumsFormattedRandomly];
    
    NSSet *expectedEnums = [NSSet setWithObjects:[self defaultEnum], [self defaultNSEnum], nil];
    XCTAssertEqualObjects(enums, expectedEnums);
}

#pragma mark - Private

- (MIUEnumsScanner *)enumScanner
{
    return [[MIUEnumsScanner alloc] init];
}

- (MIUEnum *)defaultEnum
{
    MIUEnum *defaultEnum = [[MIUEnum alloc] init];
    [defaultEnum setName:@"DefaultEnum"];
    [defaultEnum setType:@"NSUInteger"];
    
    return defaultEnum;
}

- (MIUEnum *)defaultNSEnum
{
    MIUEnum *defaultEnum = [[MIUEnum alloc] init];
    [defaultEnum setName:@"DefaultNSEnum"];
    [defaultEnum setType:@"NSUInteger"];
    
    return defaultEnum;
}

@end
