//
//  ProtocolScannerTest.m
//  ModelImprovementUtility
//
//  Created by Nesteforenko Andrey on 10/27/15.
//  Copyright © 2015 NIX. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIUTestObjectsFactory.h"
#import "MIUProtocolsScanner.h"

@interface ProtocolScannerTest : XCTestCase

@end

@implementation ProtocolScannerTest

- (void)testProtocolScannerToReturnsExpectedProtocolWithProperties
{
    MIUProtocolsScanner *scanner = [MIUTestObjectsFactory protocolScanner];
    NSArray *protocols = [scanner protocolsFromString:[MIUTestObjectsFactory protocolWithPropertiesString]];
    
    XCTAssertEqualObjects(protocols, @[[MIUTestObjectsFactory protocolWithProperties]]);
}

- (void)testProtocolScannerToReturnsExpectedProtocolWithoutProperties
{
    MIUProtocolsScanner *scanner = [MIUTestObjectsFactory protocolScanner];
    NSArray *protocols = [scanner protocolsFromString:[MIUTestObjectsFactory protocolWithoutPropertiesString]];
    
    XCTAssertEqualObjects(protocols, @[[MIUTestObjectsFactory protocolWithoutProperties]]);
    
    MIUProtocol *protocol = [protocols firstObject];
    XCTAssertEqual([protocol isBaseProtocol], [[MIUTestObjectsFactory protocolWithoutProperties] isBaseProtocol]);
}

- (void)testProtocolScannerToReturnsExpectedProtocolWithPropertiesAndConformedProtocolString
{
    MIUProtocolsScanner *scanner = [MIUTestObjectsFactory protocolScanner];
    NSArray *protocols = [scanner protocolsFromString:[MIUTestObjectsFactory protocolWithPropertiesAndConformedProtocolString]];
    
    XCTAssertEqualObjects(protocols, @[[MIUTestObjectsFactory protocolWithPropertiesAndConformedProtocol]]);
    
    MIUProtocol *protocol = [protocols firstObject];
    XCTAssertEqual([protocol isBaseProtocol], [[MIUTestObjectsFactory protocolWithPropertiesAndConformedProtocol] isBaseProtocol]);
}

- (void)testProtocolScannerToReturnsExpectedProtocolWithPropertiesWithoutConformedProtocol
{
    MIUProtocolsScanner *scanner = [MIUTestObjectsFactory protocolScanner];
    NSArray *protocols = [scanner protocolsFromString:[MIUTestObjectsFactory protocolWithPropertiesWithoutConformedProtocolString]];
    
    XCTAssertEqualObjects(protocols, @[[MIUTestObjectsFactory protocolWithPropertiesWithoutConformedProtocol]]);
    
    MIUProtocol *protocol = [protocols firstObject];
    XCTAssertEqual([protocol isBaseProtocol], [[MIUTestObjectsFactory protocolWithPropertiesWithoutConformedProtocol] isBaseProtocol]);
}

- (void)testProtocolScannerToReturnsExpectedProtocolWithConformedProtocolWithoutProperties
{
    MIUProtocolsScanner *scanner = [MIUTestObjectsFactory protocolScanner];
    NSArray *protocols = [scanner protocolsFromString:[MIUTestObjectsFactory protocolWithConformedProtocolWithoutPropertiesString]];
    
    XCTAssertEqualObjects(protocols, @[[MIUTestObjectsFactory protocolWithConformedProtocolWithoutProperties]]);
    
    MIUProtocol *protocol = [protocols firstObject];
    XCTAssertEqual([protocol isBaseProtocol], [[MIUTestObjectsFactory protocolWithConformedProtocolWithoutProperties] isBaseProtocol]);
}

@end
