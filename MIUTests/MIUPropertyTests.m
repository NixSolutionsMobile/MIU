//
//  MIUPropertyTests.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/2/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIUProperty.h"

@interface MIUPropertyTests : XCTestCase

@end

@implementation MIUPropertyTests

- (void)testIdenticalObjectsAreEqual
{
    MIUProperty *property1 = [MIUProperty new];
    [property1 setName:@"object"];
    [property1 setType:@"NSObject"];
    [property1 setIsPointer:YES];
    [property1 setIsAtomic:NO];
    [property1 setMemoryAttribute:MIUPropertyMemoryAttributeStrong];
    
    MIUProperty *property2 = [MIUProperty new];
    [property2 setName:@"object"];
    [property2 setType:@"NSObject"];
    [property2 setIsPointer:YES];
    [property2 setIsAtomic:NO];
    [property2 setMemoryAttribute:MIUPropertyMemoryAttributeStrong];
    XCTAssertEqualObjects(property1, property2);
}

- (void)testDifferentObjectsAreNotEqual
{
    MIUProperty *property1 = [MIUProperty new];
    [property1 setName:@"object"];
    [property1 setType:@"NSObject"];
    [property1 setIsPointer:YES];
    [property1 setIsAtomic:YES];
    [property1 setMemoryAttribute:MIUPropertyMemoryAttributeStrong];
    
    MIUProperty *property2 = [MIUProperty new];
    [property2 setName:@"object"];
    [property2 setType:@"NSObject"];
    [property2 setIsPointer:YES];
    [property2 setIsAtomic:NO];
    [property2 setMemoryAttribute:MIUPropertyMemoryAttributeStrong];
    XCTAssertNotEqualObjects(property1, property2);
}

- (void)testInitializationWithParametersCreatesObjectWithSameParameters
{
    BOOL isPointer = YES;
    BOOL isAtomic = YES;
    MIUPropertyMemoryAttribute memoryAttribute = MIUPropertyMemoryAttributeCopy;
    NSString *name = @"object";
    NSString *type = @"NSString";
    
    MIUProperty *property = [[MIUProperty alloc] initWithName:name type:type setter:@"setter" getter:@"getter"  isPointer:isPointer isAtomic:isAtomic memoryAttribute:memoryAttribute];
    XCTAssertEqualObjects([property name], name);
    XCTAssertEqualObjects([property type], type);
    XCTAssertEqual([property isPointer], isPointer);
    XCTAssertEqual([property isAtomic], isAtomic);
    XCTAssertEqual([property memoryAttribute], memoryAttribute);
}

@end
