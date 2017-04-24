//
//  MIUPropertyScannerTests.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/2/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIUPropertyScanner.h"
#import "MIUProperty.h"

static NSString *const stringWithPropertyFormatedCorrectly = @"@property(nonatomic, strong) NSString *propertyName;";
static NSString *const stringWithPropertyFormatedUncorrectly = @"@property (  nonatomic  , strong )  NSString  *  propertyName;";
static NSString *const stringWithPropertyWithoutMemoryAttributes = @"@property  NSString *propertyName;";
static NSString *const stringWithNonPointerPropertyWithoutMemoryAttributes = @"@property  int propertyName;";

#pragma properties With difficult type
static NSString *const stringWithPropertyLongLongType = @"@property (nonatomic, assign) long long  propertyName;";
static NSString *const stringWithPropertyUnsignedLongLong = @"@property  unsigned long long propertyName;";

#pragma properties With setter and getter
static NSString *const cPropertyStringWithSetter = @"@property(nonatomic, assign, setter = dasdf:)long propertyName;";
static NSString *const cPropertyStringWithGetter = @"@property(nonatomic, assign, getter = asfdads)long propertyName;";
static NSString *const cPropertyStringWithGetterAndSetter = @"@property(nonatomic, assign, getter = asfdads, setter = dasdf:)long propertyName;";

#pragma properties With setter and getter
static NSString *const cPropertyStringWithIDConformed = @"@property(nonatomic, strong, setter = dasdf:) id<NSObject> propertyName;";

#pragma properties With readonlyAttr
static NSString *const cPropertyStringWithReadOnlyAttribute = @"@property(nonatomic, readonly) int propertyName;";
static NSString *const cPropertyStringWithReadOnlyAttributeAtTheEnd = @"@property(nonatomic, readonly, assign) int propertyName;";
static NSString *const cPropertyStringWithReadOnlyAttributeAtTheBegining = @"@property(assign, nonatomic, readonly) int propertyName;";

@interface MIUPropertyScannerTests : XCTestCase

@end

@implementation MIUPropertyScannerTests

- (void)testInitializationPropertyWithStringReturnsExpectedModel
{
    NSString *propertyString = @"@property(nonatomic, strong) NSString *propertyName;";
    MIUPropertyScanner *propertyScanner = [MIUPropertyScanner new];
    
    MIUProperty *property1 = [[MIUProperty alloc] initWithName:@"propertyName" type:@"NSString" isPointer:YES isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeStrong];
    MIUProperty *property2 = [propertyScanner propertyWithString:propertyString];
    
    [self testToEqualentExpectedProperty:property1 toExisting:property2];
}

- (void)testScannerReturnsAtomicPropertyFromStringWithoutAtomicAttribute
{
    NSString *propertyString = @"@property(strong) NSString *type;";
    [self testScannerReturnsPropertyWithAtomicAttribute:YES From:propertyString];
}

- (void)testScannerReturnsAtomicPropertyFromStringWithAtomicAttribute
{
    NSString *propertyString = @"@property(atomic, strong) NSString *type;";
    [self testScannerReturnsPropertyWithAtomicAttribute:YES From:propertyString];
}

- (void)testScannerReturnsNonatomicPropertyFromStringWithNonatomicAttribute
{
    NSString *propertyString = @"@property(nonatomic, strong) NSString *type;";
    [self testScannerReturnsPropertyWithAtomicAttribute:NO From:propertyString];
}

- (void)testScannerReturnsNonPointerPropertyFromStringWithoutAsterisk
{
    NSString *propertyString = @"@property(atomic, assign) BOOL type;";
    [self testScannerReturnsPointerType:NO fromPropertyString:propertyString];
}

- (void)testScannerReturnsPointerPropertyFromStringWithAsterisk
{
    NSString *propertyString = @"@property(atomic, strong) NSString *type;";
    [self testScannerReturnsPointerType:YES fromPropertyString:propertyString];
}

- (void)testScannerReturnsPropertyWithStrongAttributeForCorrespondingString
{
    [self testThatScannerReturnsPropertyWithMemoryType:MIUPropertyMemoryAttributeStrong forPropertyString:@"@property(atomic, strong) NSString *type;"];
}

- (void)testScannerReturnsPropertyWithWeakAttributeForCorrespondingString
{
    [self testThatScannerReturnsPropertyWithMemoryType:MIUPropertyMemoryAttributeWeak forPropertyString:@"@property(atomic, weak) NSString *type;"];
}

- (void)testScannerReturnsPropertyWithCopyAttributeForCorrespondingString
{
    [self testThatScannerReturnsPropertyWithMemoryType:MIUPropertyMemoryAttributeCopy forPropertyString:@"@property(atomic, copy) NSString *type;"];
}

- (void)testScannerReturnsPropertyWithAssignAttributeForCorrespondingString
{
    [self testThatScannerReturnsPropertyWithMemoryType:MIUPropertyMemoryAttributeAssign forPropertyString:@"@property(atomic, assign) NSString *type;"];
}

- (void)testScannerReturnsPropertyWithStrongAttributeForStringWithoutMemoryAttribute
{
    [self testThatScannerReturnsPropertyWithMemoryType:MIUPropertyMemoryAttributeStrong forPropertyString:@"@property(atomic) NSString *type;"];
}

- (void)testScannerReturnCorrectPropertyFromStringWithCorrectFormat
{
    MIUProperty *expectedProperty = [[MIUProperty alloc] initWithName:@"propertyName" type:@"NSString" isPointer:YES isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeStrong];

    [self testScanerThatReturnsExpectedProperty:expectedProperty FromString:stringWithPropertyFormatedCorrectly assertDescriptions:@"Scanner returned unexpected property from string formatted correctly"];
}

- (void)testScannerReturnCorrectPropertyFromStringWithUncorrectFormat
{
    MIUProperty *expectedProperty = [[MIUProperty alloc] initWithName:@"propertyName" type:@"NSString" isPointer:YES isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeStrong];
    
    [self testScanerThatReturnsExpectedProperty:expectedProperty FromString:stringWithPropertyFormatedUncorrectly assertDescriptions:@"Scanner returned unexpected property from string formatted uncorrectly"];
}

- (void)testScannerReturnCorrectPropertyFromStringWithWithoutMemoryAttribues
{
    MIUProperty *expectedProperty = [[MIUProperty alloc] initWithName:@"propertyName" type:@"NSString" isPointer:YES isAtomic:YES memoryAttribute:MIUPropertyMemoryAttributeStrong];
    [self testScanerThatReturnsExpectedProperty:expectedProperty FromString:stringWithPropertyWithoutMemoryAttributes assertDescriptions:@"Scanner returned unexpected property from string with out memory attributes"];
}

- (void)testScannerReturnCorrectPropertyFromStringWithNonPointerPropertyWithoutMemoryAttributes
{
    MIUProperty *expectedProperty = [[MIUProperty alloc] initWithName:@"propertyName" type:@"int" isPointer:NO isAtomic:YES memoryAttribute:MIUPropertyMemoryAttributeAssign];
    
    [self testScanerThatReturnsExpectedProperty:expectedProperty FromString:stringWithNonPointerPropertyWithoutMemoryAttributes assertDescriptions:@"Scanner returned unexpected non pointer property from string with out memory attributes"];
}

- (void)testScannerReturnCorrectPropertyFromStringWithDifficultType
{
    MIUProperty *expectedProperty = [[MIUProperty alloc] initWithName:@"propertyName" type:@"long long" isPointer:NO isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeAssign];
    
    [self testScanerThatReturnsExpectedProperty:expectedProperty FromString:stringWithPropertyLongLongType assertDescriptions:@"Scanner returned unexpected property from string with out memory attributes"];
}

- (void)testScannerReturnCorrectPropertyFromStringWithDifficultTypeWithOutMemoryAttrib
{
    MIUProperty *expectedProperty = [[MIUProperty alloc] initWithName:@"propertyName" type:@"unsigned long long" isPointer:NO isAtomic:YES memoryAttribute:MIUPropertyMemoryAttributeAssign];
    
    [self testScanerThatReturnsExpectedProperty:expectedProperty FromString:stringWithPropertyUnsignedLongLong assertDescriptions:@"Scanner returned unexpected property from string with out memory attributes and difficult type"];
}

- (void)testScannerReturnsCorrectPropertyFromStringWithSetter
{
    MIUProperty *expectedProperty = [[MIUProperty alloc] initWithName:@"propertyName" type:@"long" setter:@"dasdf" getter:@"" isPointer:NO isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeAssign];
    
    [self testScanerThatReturnsExpectedProperty:expectedProperty FromString:cPropertyStringWithSetter assertDescriptions:@"Scanner returned unexpected property from string with setter"];
}

- (void)testScannerReturnsCorrectPropertyFromStringWithGetter
{
    MIUProperty *expectedProperty = [[MIUProperty alloc] initWithName:@"propertyName" type:@"long" setter:@"" getter:@"asfdads" isPointer:NO isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeAssign];
    
    [self testScanerThatReturnsExpectedProperty:expectedProperty FromString:cPropertyStringWithGetter assertDescriptions:@"Scanner returned unexpected property from string with getter"];
}

- (void)testScannerReturnsCorrectPropertyFromStringWithGetterAndSetter
{
    MIUProperty *expectedProperty = [[MIUProperty alloc] initWithName:@"propertyName" type:@"long" setter:@"dasdf" getter:@"asfdads" isPointer:NO isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeAssign];
    
    [self testScanerThatReturnsExpectedProperty:expectedProperty FromString:cPropertyStringWithGetterAndSetter assertDescriptions:@"Scanner returned unexpected property from string with getter and setter"];
}

- (void)testScannerReturnsCorrectPropertyFromStringWithIdConformed
{
    MIUProperty *expectedProperty = [[MIUProperty alloc] initWithName:@"propertyName" type:@"id<NSObject>" setter:@"dasdf" getter:@"" isPointer:YES isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeStrong];
    
    [self testScanerThatReturnsExpectedProperty:expectedProperty FromString:cPropertyStringWithIDConformed assertDescriptions:@"Scanner returned unexpected property from string with getter and setter"];
}

- (void)testScannerReturnsCorrectPropertyFromStringWithReadOnlyAttribute
{
    MIUProperty *expectedProperty = [[MIUProperty alloc] initWithName:@"propertyName" type:@"int" setter:@"" getter:@"" isPointer:NO isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeAssign isReadonly:YES];
    
    [self testScanerThatReturnsExpectedProperty:expectedProperty FromString:cPropertyStringWithReadOnlyAttribute assertDescriptions:@""];
}

- (void)testScannerReturnsCorrectPropertyFromStringWithReadOnlyAttributeAtTheEnd
{
    MIUProperty *expectedProperty = [[MIUProperty alloc] initWithName:@"propertyName" type:@"int" setter:@"" getter:@"" isPointer:NO isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeAssign isReadonly:YES];
    
    [self testScanerThatReturnsExpectedProperty:expectedProperty FromString:cPropertyStringWithReadOnlyAttributeAtTheEnd assertDescriptions:@""];
}

- (void)testScannerReturnsCorrectPropertyFromStringWithReadOnlyAttributeAtTheBegining
{
    MIUProperty *expectedProperty = [[MIUProperty alloc] initWithName:@"propertyName" type:@"int" setter:@"" getter:@"" isPointer:NO isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeAssign isReadonly:YES];
    
    [self testScanerThatReturnsExpectedProperty:expectedProperty FromString:cPropertyStringWithReadOnlyAttributeAtTheBegining assertDescriptions:@""];
}

#pragma mark - Private methods

- (void)testThatScannerReturnsPropertyWithMemoryType:(MIUPropertyMemoryAttribute)memoryType forPropertyString:(NSString *)propertyString
{
    MIUPropertyScanner *propertyScanner = [MIUPropertyScanner new];
    MIUProperty *property = [propertyScanner propertyWithString:propertyString];
    
    XCTAssertEqual([property memoryAttribute], memoryType);
}

- (void)testScanerThatReturnsExpectedProperty:(MIUProperty *)expectedProperty FromString:(NSString *)propertyString assertDescriptions:(NSString *)assertDescription
{
    MIUPropertyScanner *propertyScanner = [MIUPropertyScanner new];
    MIUProperty *property = [propertyScanner propertyWithString:propertyString];
    
    [self testToEqualentExpectedProperty:expectedProperty toExisting:property];
}

- (void)testScannerReturnsPropertyWithAtomicAttribute:(BOOL)isAtomic From:(NSString *)propertyString
{
    MIUPropertyScanner *propertyScanner = [MIUPropertyScanner new];
    MIUProperty *property = [propertyScanner propertyWithString:propertyString];
    
    XCTAssertEqual([property isAtomic], isAtomic);
}

- (void)testScannerReturnsPointerType:(BOOL)isPointer fromPropertyString:(NSString *)propertyString
{
    MIUPropertyScanner *propertyScanner = [MIUPropertyScanner new];
    MIUProperty *property = [propertyScanner propertyWithString:propertyString];
    
    XCTAssertEqual([property isPointer], isPointer);
}

- (void)testToEqualentExpectedProperty:(MIUProperty *)expectedProperty toExisting:(MIUProperty *)existingProperty
{
    XCTAssertEqualObjects([expectedProperty name], [existingProperty name]);
    XCTAssertEqualObjects([expectedProperty type], [existingProperty type]);
    XCTAssertEqualObjects([expectedProperty getSetter], [existingProperty getSetter]);
    XCTAssertEqualObjects([expectedProperty getGetter], [existingProperty getGetter]);
    XCTAssertEqual([expectedProperty isPointer], [existingProperty isPointer]);
    XCTAssertEqual([expectedProperty isAtomic], [existingProperty isAtomic]);
    XCTAssertEqual([expectedProperty memoryAttribute], [existingProperty memoryAttribute]);
}

@end
