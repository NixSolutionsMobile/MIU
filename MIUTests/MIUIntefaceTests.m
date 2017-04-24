//
//  MIUIntefaceTests.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/3/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "MIUInterface.h"
#import "MIUPRoperty.h"

@interface MIUIntefaceTests : XCTestCase

@end

@implementation MIUIntefaceTests

- (void)testIdenticalObjectsAreEqual
{
    MIUInterface *interface1 = [[MIUInterface new] initWithName:@"interface" isExtension:YES andProperties:[self properties] superClass:@"Super" conformedToProtocols:[NSArray new]];
    MIUInterface *interface2 = [[MIUInterface new] initWithName:@"interface" isExtension:YES andProperties:[self properties] superClass:@"Super" conformedToProtocols:[NSArray new]];

    XCTAssertEqualObjects(interface1, interface2);
}

- (void)testDifferentObjectsAreNotEqual
{
    MIUInterface *interface1 = [MIUInterface new];
    [interface1 setName:@"interface1"];
    [interface1 setProperties:[self properties]];
    
    MIUInterface *interface2 = [MIUInterface new];
    [interface2 setName:@"interface2"];
    [interface2 setProperties:[self properties]];
    
    XCTAssertNotEqualObjects(interface1, interface2);}

- (void)testInitializationWithParametersCreatesObjectWithSameParameters
{
    NSString *name = @"object";
    NSSet *porperties = [self properties];
    
    MIUInterface *interface = [[MIUInterface alloc] initWithName:name isExtension:YES andProperties:porperties superClass:@"Super" conformedToProtocols:[NSArray new]];
    XCTAssertEqualObjects([interface name], name);
    XCTAssertEqualObjects([interface properties], porperties);
    XCTAssertEqual([interface isExtension], YES);
}

#pragma - mark private methods

- (NSSet *)properties
{
    MIUProperty *property1 = [MIUProperty new];
    [property1 setName:@"object1"];
    [property1 setType:@"1"];
    [property1 setIsPointer:YES];
    [property1 setIsAtomic:NO];
    [property1 setMemoryAttribute:MIUPropertyMemoryAttributeStrong];
    
    MIUProperty *property2 = [MIUProperty new];
    [property2 setName:@"object2"];
    [property2 setType:@"2"];
    [property2 setIsPointer:YES];
    [property2 setIsAtomic:NO];
    [property2 setMemoryAttribute:MIUPropertyMemoryAttributeStrong];

    return [NSSet setWithArray:@[property1, property2]];
}


@end
