//
//  MIUInterfacesScannerTests.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/3/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MIUInterfacesScanner.h"

#import "MIUInterface.h"
#import "MIUProperty.h"

#pragma mark - Strings for testing Interfaces

static NSString *const MIUSimpleEmptyInterface = @"@interface MIUClassForTesting : MIUSuperClass\n\n"
"@end";

static NSString *const MIUSimpleEmptyInterfaceWithProtocols = @"@interface MIUClassForTesting : MIUSuperClass<MIUProtocol1, MIUProtocol2, MIUProtocol3>\n\n"
"@end";

static NSString *const MIUSimpleEmptyExtension = @"@interface MIUClassForTesting () \n\n"
"@end";

static NSString *const MIUSimpleEmptyExtensionWithConformedProtocols = @"@interface MIUClassForTesting ()<MIUProtocol1, MIUProtocol2, MIUProtocol3> \n\n"
"@end";

static NSString *const MIUSimpleInterfaceWithProperties = @"@interface MIUClassForTesting : NSObject\n\n"
"@property(nonatomic, strong) NSString *string;\n"
"@property(nonatomic, strong) NSString *string1;\n"
"@property(nonatomic, strong) NSString *string2;\n\n"
"@end";

static NSString *const MIUSimpleBaseInterface = @"@interface MIUClassForTesting : NSObject\n\n"
"@end";

@interface MIUInterfacesScannerTests : XCTestCase

@end

@implementation MIUInterfacesScannerTests

- (void)testSimpleEmptyInterfaceScannedAsExpected
{
    MIUInterfacesScanner *scanner = [MIUInterfacesScanner new];
    
    NSSet *interfaces = [scanner interfacesFromString:MIUSimpleEmptyInterface];
    XCTAssertEqualObjects(interfaces, [self simpleEmptyInterfaces]);
}

- (void)testSimpleEmptyInterfacesWithProtocolsScannedAsExpected
{
    MIUInterfacesScanner *scanner = [MIUInterfacesScanner new];
    
    NSSet *interfaces = [scanner interfacesFromString:MIUSimpleEmptyInterfaceWithProtocols];
    XCTAssertEqualObjects(interfaces, [self simpleEmptyInterfacesWithProtocols]);
}

- (void)testSimpleEmptyExtensionScannerReturnExpectedModel
{
    MIUInterfacesScanner *scanner = [MIUInterfacesScanner new];
    
    NSSet *interfaces = [scanner interfacesFromString:MIUSimpleEmptyExtension];
    XCTAssertEqualObjects(interfaces, [self simpleEmptyExtension]);
}

- (void)testSimpleEmptyExtensionWithConformedProtocolsScannerReturnExpectedModel
{
    MIUInterfacesScanner *scanner = [MIUInterfacesScanner new];
    
    NSSet *interfaces = [scanner interfacesFromString:MIUSimpleEmptyExtensionWithConformedProtocols];
    XCTAssertEqualObjects(interfaces, [self simpleEmptyExtensionWithConformedProtocols]);
}

- (void)testSimpleInterfaceWithProperties
{
    MIUInterfacesScanner *scanner = [MIUInterfacesScanner new];
    
    NSSet *interfaces = [scanner interfacesFromString:MIUSimpleInterfaceWithProperties];
    XCTAssertEqualObjects(interfaces, [self simpleInterfaceWithProperties]);
}

- (void)testSimpleBaseInterface
{
    MIUInterfacesScanner *scanner = [MIUInterfacesScanner new];
    
    NSSet *interfaces = [scanner interfacesFromString:MIUSimpleBaseInterface];
    XCTAssertEqualObjects(interfaces, [self simpleBaseInterface]);
    XCTAssertEqual([[[interfaces allObjects] firstObject] isBase], [[[[self simpleBaseInterface] allObjects] firstObject] isBase]);
}

#pragma - mark private methods

- (NSSet *)interfacesFromFile
{
    MIUProperty *property1 = [[MIUProperty alloc] initWithName:@"ID" type:@"NSString" isPointer:YES isAtomic:YES memoryAttribute:MIUPropertyMemoryAttributeCopy];
    MIUProperty *property2 = [[MIUProperty alloc] initWithName:@"categoryType" type:@"MIUTestClassType" isPointer:NO isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeAssign];
    MIUProperty *property3 = [[MIUProperty alloc] initWithName:@"categoryName" type:@"NSString" isPointer:YES isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeCopy];
    MIUProperty *property4 = [[MIUProperty alloc] initWithName:@"icon" type:@"UIImage" isPointer:YES isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeStrong];
    MIUProperty *property5 = [[MIUProperty alloc] initWithName:@"subCategories" type:@"NSArray" isPointer:YES isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeCopy];
    MIUProperty *property6 = [[MIUProperty alloc] initWithName:@"parentCategory" type:@"MIUTestClass" isPointer:YES isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeWeak];
    
    MIUInterface *interface = [[MIUInterface alloc] initWithName:@"MIUTestClass"
                                                     isExtension:NO
                                                   andProperties:[NSSet setWithArray:@[property1, property2, property3, property4, property5, property6]]
                                                      superClass:@"NSObject"
                                            conformedToProtocols:@[@"NSCopying",@"NSCoding"]];
    
    MIUInterface *interface1 = [[MIUInterface alloc] initWithName:@"MIUTestClass2"
                                                      isExtension:NO
                                                    andProperties:[NSSet setWithArray:@[property1, property2, property3]]
                                                       superClass:@"NSObject"
                                             conformedToProtocols:@[@"NSCopying",@"NSCoding"]];
    
    return [NSSet setWithArray:@[interface, interface1]];
}

- (NSSet *)simpleEmptyInterfaces
{
    MIUInterface *interface = [[MIUInterface alloc] initWithName:@"MIUClassForTesting"
                                                     isExtension:NO
                                                   andProperties:[NSSet new]
                                                      superClass:@"MIUSuperClass"
                                            conformedToProtocols:nil];
    
    return [NSSet setWithArray:@[interface]];
}

- (NSSet *)simpleEmptyInterfacesWithProtocols
{
    MIUInterface *interface = [[MIUInterface alloc] initWithName:@"MIUClassForTesting"
                                                     isExtension:NO
                                                   andProperties:[NSSet setWithArray:@[]]
                                                      superClass:@"MIUSuperClass"
                                            conformedToProtocols:@[@"MIUProtocol1", @"MIUProtocol2", @"MIUProtocol3"]];
    
    return [NSSet setWithArray:@[interface]];
}

- (NSSet *)simpleEmptyExtension
{
    MIUInterface *interface = [[MIUInterface alloc] initWithName:@"MIUClassForTesting"
                                                     isExtension:YES
                                                   andProperties:[NSSet setWithArray:@[]]
                                                      superClass:nil
                                            conformedToProtocols:nil];
        
    return [NSSet setWithArray:@[interface]];
}

- (NSSet *)simpleEmptyExtensionWithConformedProtocols
{
    MIUInterface *interface = [[MIUInterface alloc] initWithName:@"MIUClassForTesting"
                                                     isExtension:YES
                                                   andProperties:[NSSet setWithArray:@[]]
                                                      superClass:nil
                                            conformedToProtocols:@[@"MIUProtocol1", @"MIUProtocol2", @"MIUProtocol3"]];
    
    return [NSSet setWithArray:@[interface]];
}

- (NSSet *)simpleInterfaceWithProperties
{
    MIUProperty *property1 = [[MIUProperty alloc] initWithName:@"string" type:@"NSString" isPointer:YES isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeStrong];
    MIUProperty *property2 = [[MIUProperty alloc] initWithName:@"string1" type:@"NSString" isPointer:YES isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeStrong];
    MIUProperty *property3 = [[MIUProperty alloc] initWithName:@"string2" type:@"NSString" isPointer:YES isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeStrong];
    
    MIUInterface *interface = [[MIUInterface alloc] initWithName:@"MIUClassForTesting"
                                                     isExtension:NO
                                                   andProperties:[NSSet setWithArray:@[property1, property2, property3]]
                                                      superClass:@"NSObject"
                                            conformedToProtocols:nil];
    
    return [NSSet setWithArray:@[interface]];
}

- (NSSet *)simpleBaseInterface
{
    MIUInterface *interface = [[MIUInterface alloc] initWithName:@"MIUClassForTesting"
                                                     isExtension:NO
                                                   andProperties:[NSSet setWithArray:@[]]
                                                      superClass:@"NSObject"
                                            conformedToProtocols:nil];
    
    return [NSSet setWithArray:@[interface]];
}

@end
