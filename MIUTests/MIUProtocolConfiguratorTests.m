//
//  MIUProtocolConfiguratorTests.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/24/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIUProtocolConfigurator.h"

static NSString *cInterfaceWithoutProtocols = @"@interface SomeInterface : NSObject";
static NSString *cExpectedInterfaceWithProtocols = @"@interface SomeInterface : NSObject<NSCoding, NSCopying>";

static NSString *cInterfaceWithCopyiongProtocol = @"@interface SomeInterface : NSObject<SomeProtocol1, NSCopying, SomeProtocol2>";
static NSString *cExpectedInterfaceWithCopyingProtocol = @"@interface SomeInterface : NSObject<SomeProtocol1, NSCopying, SomeProtocol2, NSCoding>";

static NSString *cInterfaceWithCopyiongProtocolWithSpace = @"@interface SomeInterface : NSObject <SomeProtocol1, NSCopying, SomeProtocol2>";
static NSString *cExpectedInterfaceWithCopyingProtocolWithSpace = @"@interface SomeInterface : NSObject <SomeProtocol1, NSCopying, SomeProtocol2, NSCoding>";

@interface MIUProtocolConfiguratorTests : XCTestCase

@end

@implementation MIUProtocolConfiguratorTests

- (void)testToCorectConfigurationInterfaceWithoutAnyProtocol
{
    MIUProtocolConfigurator *protocolConfigurator = [MIUProtocolConfigurator new];
    NSString *configuratedString = [protocolConfigurator configureProtocolListInString:cInterfaceWithoutProtocols forInterfaceWithName:@"SomeInterface"];
    
    XCTAssertEqualObjects(configuratedString, cExpectedInterfaceWithProtocols);
}

- (void)testToCorectConfigurationInterfaceWithCopingProtocol
{
    MIUProtocolConfigurator *protocolConfigurator = [MIUProtocolConfigurator new];
    NSString *configuratedString = [protocolConfigurator configureProtocolListInString:cInterfaceWithCopyiongProtocol forInterfaceWithName:@"SomeInterface"];
    
    XCTAssertEqualObjects(configuratedString, cExpectedInterfaceWithCopyingProtocol);
}

- (void)testToCorectConfigurationInterfaceWithCopingProtocolAndSpaces
{
    MIUProtocolConfigurator *protocolConfigurator = [MIUProtocolConfigurator new];
    NSString *configuratedString = [protocolConfigurator configureProtocolListInString:cInterfaceWithCopyiongProtocolWithSpace forInterfaceWithName:@"SomeInterface"];
    
    XCTAssertEqualObjects(configuratedString, cExpectedInterfaceWithCopyingProtocolWithSpace);
}

- (void)testToCorectConfigurationInterfaceWithAllProtocols
{
    MIUProtocolConfigurator *protocolConfigurator = [MIUProtocolConfigurator new];
    NSString *configuratedString = [protocolConfigurator configureProtocolListInString:cExpectedInterfaceWithCopyingProtocol forInterfaceWithName:@"SomeInterface"];
    
    XCTAssertEqualObjects(configuratedString, cExpectedInterfaceWithCopyingProtocol);
}

@end
