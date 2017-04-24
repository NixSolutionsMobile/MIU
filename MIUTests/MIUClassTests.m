//
//  MIUClassTests.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/7/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "MIUClass.h"
#import "MIUProperty.h"

@interface MIUClassTests : XCTestCase

@end

@implementation MIUClassTests

- (void)testIdenticalObjectsAreEqual
{
    MIUClass *class1 = [self classWith:@"class" andProperties:[self properties]];
    MIUClass *class2 = [self classWith:@"class" andProperties:[self properties]];
     
     XCTAssertEqualObjects(class1, class2);
}

- (void)testObjectsWithDifferentPropertiesAreNotEqual
{
    MIUClass *class1 = [self classWith:@"class" andProperties:[self properties]];
    MIUClass *class2 = [self classWith:@"class" andProperties:nil];
    
    XCTAssertNotEqualObjects(class1, class2);
}

- (void)testObjectsWithDifferentNameAreNotEqual
{
    MIUClass *class1 = [self classWith:@"class" andProperties:[self properties]];
    MIUClass *class2 = [self classWith:@"class1" andProperties:[self properties]];
    
    XCTAssertNotEqualObjects(class1, class2);
}

- (void)testInitializationWithParametersCreatesObjectWithSameParameters
{
//    NSString *name = @"object";
//    NSSet *properties = [NSSet setWithArray:[[self properties] allObjects]];
//    
//    MIUClass *class = [[MIUClass alloc] initWithName:name properties:properties];
//    XCTAssertEqualObjects([class name], name);
//    XCTAssertEqualObjects([class properties], properties);
}

#pragma - mark private methods

- (MIUClass *)classWith:(NSString *)name andProperties:(NSSet *)properties
{
    MIUClass *class = [MIUClass new];
    [class setName:name];
    [class setProperties:properties];
    
    return class;
}

- (NSSet *)properties
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
    
    return [NSSet setWithArray:@[property1, property2]];
}

@end
