//
//  MIUPropertiesScanerTests.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/2/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIUPropertiesScanner.h"

static NSString *const stringWithExpectedProperties =
    @"WACategoryCustom"
    @"\n@interface WACategory : NSObject <NSCopying, NSCoding>"
    @"\n@property(copy) NSString *ID;"
    @"\n- (UIColor *)categoryColor;"
    @"\n@property(nonatomic, assign) WACategoryType categoryType; // for subcategory -> [parentCategory categoryType]"
    @"\n@property(nonatomic, copy) NSString *categoryName;"
    @"\n- (UIColor *)categoryColor;"
    @"\n}";

static NSString *const expectedStringWithTwoPropertyInLine =
    @"WACategoryCustom"
    @"\n@interface WACategory : NSObject <NSCopying, NSCoding>"
    @"\n@property(copy) NSString *ID; // for subcategory -> [parentCategory categoryType]"
    @"\n@property(nonatomic, assign) WACategoryType categoryType; // for subcategory -> [parentCategory categoryType]"
    @"\n@property(nonatomic, copy) NSString *categoryName;"
    @"\n- (UIColor *)categoryColor;"
    @"\n}";

static NSString *const expectedStringWithUncorrectSpacesInProperty =
    @"WACategoryCustom"
    @"\n@interface WACategory : NSObject <NSCopying, NSCoding>"
    @"\n@property(copy ) NSString * ID ; // for subcategory -> [parentCategory categoryType]"
    @"\n@property (nonatomic, assign)  WACategoryType  categoryType ; //  for subcategory -> [parentCategory categoryType]"
    @"\n@property( nonatomic ,  copy  ) NSString *categoryName;"
    @"\n@property(nonatomic,copy)NSString*categoryName;"
    @"\n- (UIColor *)categoryColor;"
    @"\n}";

static NSString *const expectedStringWithPropertyWithoutMemoryAttribute =
    @"WACategoryCustom"
    @"\n@interface WACategory : NSObject <NSCopying, NSCoding>"
    @"@property NSString * ID ;"
    @"@property (nonatomic, assign)  WACategoryType  categoryType ;"
    @"\n- (UIColor *)categoryColor;"
    @"@property NSString *categoryName;"
    @"@property(nonatomic,copy)NSString*categoryName;"
    @"\n}";

static NSString *const expectedStringWithPropertyWithDifficultType =
    @"WACategoryCustom"
    @"\n@interface WACategory : NSObject <NSCopying, NSCoding>"
    @"@property NSString * ID ;"
    @"@property (nonatomic, assign)  long long  categoryType ;"
    @"\n- (UIColor *)categoryColor;"
    @"@property unsigned long long categoryName;"
    @"@property(nonatomic,copy)NSString*categoryName;"
    @"\n}";

static NSString *const expectedStringWithProprtyWithSettersAndGetters =
    @"WACategoryCustom"
    @"\n@interface WACategory : NSObject <NSCopying, NSCoding>"
    @"@property NSString *ID ;"
    @"@property(nonatomic, assign, getter = asfdads, setter = dasdf:) long categoryType ;"
    @"\n- (UIColor *)categoryColor;"
    @"@property long categoryName;"
    @"@property(nonatomic,copy, getter = asfdads, setter = dasdf:) NSString *categoryName;"
    @"\n}";
//@"";

static NSString *const expectedStringWithProprtyWithIDConformed =
    @"WACategoryCustom"
    @"\n@interface WACategory : NSObject <NSCopying, NSCoding>"
    @"@property(nonatomic, assign) long categoryType ;"
    @"\n- (UIColor *)categoryColor;"
    @"@property(nonatomic, strong, setter = dasdf:) id<NSObject> propertyName;"
    @"\n}";

static NSString *const expectedStringWithProprtyWithMultiIDConformed =
    @"WACategoryCustom"
    @"\n@interface WACategory : NSObject <NSCopying, NSCoding>"
    @"@property(nonatomic, assign) long categoryType ;"
    @"\n@property(nonatomic, strong) id<DLAlertsUpdaterProtocol, DLAlertsStorageProtocol> alertsGateway;"
    @"\n- (UIColor *)categoryColor;"
    @"@property(nonatomic, strong, setter = dasdf:) id<NSObject> propertyName;"
    @"\n}";

static NSString *const expectedStringWithComentedProprty =
    @"WACategoryCustom"
    @"\n@interface WACategory : NSObject <NSCopying, NSCoding>"
    @"@property(nonatomic, assign) long categoryType ;"
    @"\n- (UIColor *)categoryColor;"
    @"//@property(nonatomic, strong, setter = dasdf:) id<NSObject> propertyName;"
    @"\n}";

static NSString *const expectedStringWithPropertyWithMultilineComment =
    @"WACategoryCustom"
    @"\n@interface WACategory : NSObject <NSCopying, NSCoding>"
    @"@property NSString * ID ;"
    @"@property (nonatomic, assign)  long long  categoryType ;"
    @"\n- (UIColor *)categoryColor;"
    @"/*@property unsigned long long categoryName;"
    @"@property(nonatomic,copy)NSString*categoryName;*/"
    @"\n}";

@interface MIUPropertiesScanerTests : XCTestCase

@end

@implementation MIUPropertiesScanerTests

- (void)testScannerReturnsExpectedPropertyStringsFromString
{
    [self testScannerReturnPropertyStrings:[self expectedPropertyStrings] fromString:stringWithExpectedProperties description:nil];
};

- (void)testScannerReturnsExpectedPropertyStringsFromStringWithMultiIDConformed
{
    [self testScannerReturnPropertyStrings:[self expectedPropertyStringsWithMultiIdConformedType] fromString:expectedStringWithProprtyWithMultiIDConformed description:nil];
};

- (void)testScannerReturnsExpectedPropertyStringsFromStringWithTwoPropertyInOneLine
{
    [self testScannerReturnPropertyStrings:[self expectedPropertyStrings] fromString:expectedStringWithTwoPropertyInLine description:@""];
}

- (void)testScannerReturnsExpectedPropertyStringFromStringWithUncorrectSpaces
{
    [self testScannerReturnPropertyStrings:[self expectedPropertyStringsWithPropertiesWithSpaces] fromString:expectedStringWithUncorrectSpacesInProperty description:@"Scanner return unexpected properties"];
}

- (void)testScannerReturnsExpectedPropertyStringFromStringWithPropertyWithoutMemoryAttributes
{
   [self testScannerReturnPropertyStrings:[self expectedPropertyStringsWithPropertiesWithoutMemoryAttributes] fromString:expectedStringWithPropertyWithoutMemoryAttribute description:@"Scanner returned unexpected properties from string with properties without memory attributes"];
}

- (void)testScannerReturnsExpectedPropertyStringFromStringWithPropertyWithDifficultType
{
    [self testScannerReturnPropertyStrings:[self expectedPropertyStringsWithPropertiesWithDifficultType] fromString:expectedStringWithPropertyWithDifficultType description:@"Scanner returned unexpected properties from string with difficult types"];
}

- (void)testScannerReturnsExpectedPreopertyStringFromStringWithSettersAndGetters
{
    [self testScannerReturnPropertyStrings:[self expectedPropertyStringsWithPropertiesWithSettersAndGetters] fromString:expectedStringWithProprtyWithSettersAndGetters description:@"Scanner returned unexpected properties from string with setters and getters types"];
}

- (void)testScannerReturnsExpectedPreopertyStringFromStringWithIdTypeConformed
{
    [self testScannerReturnPropertyStrings:[self expectedPropertyStringsWithIdConformedType] fromString:expectedStringWithProprtyWithIDConformed description:@"Scanner returned unexpected properties from string with type of property id<???>"];
}

- (void)testScannerReturnsExpectedPreopertyStringFromStringWithComentedProperties
{
    [self testScannerReturnPropertyStrings:[self expectedPropertyStringsWithOneLineComment] fromString:expectedStringWithComentedProprty description:@"Scanner returned unexpected properties from string with type of property id<???>"];
}

- (void)testScannerReturnsExpectedPreopertyStringFromStringWithMultiLineComentedProperties
{
    [self testScannerReturnPropertyStrings:[self expectedPropertyStringsWithPropertiesWithMultiLineComment] fromString:expectedStringWithPropertyWithMultilineComment description:@"Scanner returned unexpected properties from string with type of property id<???>"];
}

#pragma mark - Private methods

- (void)testScannerReturnPropertyStrings:(NSSet *)propertyStrings fromString:(NSString *)string description:(NSString *)description
{
    MIUPropertiesScanner *scanner = [MIUPropertiesScanner new];
    NSSet *propertiesSetFromScanner = [scanner propertiesFromString:string];
    XCTAssert([propertiesSetFromScanner isEqualToSet:propertyStrings]);
}

- (NSSet *)expectedPropertyStringsWithPropertiesWithMultiLineComment
{
    return [NSSet setWithArray:@[
                                 @"@property NSString * ID ;",
                                 @"@property (nonatomic, assign)  long long  categoryType ;"
                                 ]];
}

- (NSSet *)expectedPropertyStringsWithOneLineComment
{
    return [NSSet setWithArray:@[
                                 @"@property(nonatomic, assign) long categoryType ;"
                                 ]];
}

- (NSSet *)expectedPropertyStringsWithIdConformedType
{
    return [NSSet setWithArray:@[
                                 @"@property(nonatomic, assign) long categoryType ;",
                                 @"@property(nonatomic, strong, setter = dasdf:) id<NSObject> propertyName;"
                                 ]];
}

- (NSSet *)expectedPropertyStrings
{
    return [NSSet setWithArray:@[
                                    @"@property(copy) NSString *ID;",
                                    @"@property(nonatomic, assign) WACategoryType categoryType;",
                                    @"@property(nonatomic, copy) NSString *categoryName;"
                                ]];
}

- (NSSet *)expectedPropertyStringsWithMultiIdConformedType
{
    return [NSSet setWithArray:@[
                                 @"@property(nonatomic, assign) long categoryType ;",
                                 @"@property(nonatomic, strong, setter = dasdf:) id<NSObject> propertyName;",
                                 @"@property(nonatomic, strong) id<DLAlertsUpdaterProtocol, DLAlertsStorageProtocol> alertsGateway;"
                                 ]];
}

- (NSSet *)expectedPropertyStringsWithPropertiesWithSpaces
{
    return [NSSet setWithArray:@[
                                 @"@property(copy ) NSString * ID ;",
                                 @"@property (nonatomic, assign)  WACategoryType  categoryType ;",
                                 @"@property( nonatomic ,  copy  ) NSString *categoryName;",
                                 @"@property(nonatomic,copy)NSString*categoryName;"
                                 ]];
}

- (NSSet *)expectedPropertyStringsWithPropertiesWithoutMemoryAttributes
{
    return [NSSet setWithArray:@[
                                 @"@property NSString * ID ;",
                                 @"@property (nonatomic, assign)  WACategoryType  categoryType ;",
                                 @"@property NSString *categoryName;",
                                 @"@property(nonatomic,copy)NSString*categoryName;"
                                 ]];
}

- (NSSet *)expectedPropertyStringsWithPropertiesWithDifficultType
{
    return [NSSet setWithArray:@[
                                 @"@property NSString * ID ;",
                                 @"@property (nonatomic, assign)  long long  categoryType ;",
                                 @"@property unsigned long long categoryName;",
                                 @"@property(nonatomic,copy)NSString*categoryName;"
                                 ]];
}

- (NSSet *)expectedPropertyStringsWithPropertiesWithSettersAndGetters
{
    return [NSSet setWithArray:@[
                                 @"@property NSString *ID ;",
                                 @"@property(nonatomic, assign, getter = asfdads, setter = dasdf:) long categoryType ;",
                                 @"@property long categoryName;",
                                 @"@property(nonatomic,copy, getter = asfdads, setter = dasdf:) NSString *categoryName;"
                                 ]];
}

@end
