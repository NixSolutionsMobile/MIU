//
//  MIUTestObjectsFactory.m
//  ModelImprovementUtility
//
//  Created by Nesteforenko Andrey on 10/28/15.
//  Copyright © 2015 NIX. All rights reserved.
//

#import "MIUTestObjectsFactory.h"

@implementation MIUTestObjectsFactory

#pragma mark - Properties

+ (MIUProperty *)assignProperty
{
    return [[MIUProperty alloc] initWithName:@"assignProperty" type:@"BOOL" isPointer:NO isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeAssign];
}

+ (MIUProperty *)strongProperty
{
    return [[MIUProperty alloc] initWithName:@"strongProperty" type:@"NSString" isPointer:YES isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeStrong];
}

+ (MIUProperty *)copyProperty
{
    return [[MIUProperty alloc] initWithName:@"copyProperty" type:@"NSString" isPointer:YES isAtomic:NO memoryAttribute:MIUPropertyMemoryAttributeCopy];
}

#pragma mark - Protocols

+ (MIUProtocol *)protocolWithProperties
{
    MIUProtocol *protocol = [[MIUProtocol alloc] init];
    [protocol setProtocolName:@"protocolWithProperties"];
    
    [protocol setProperties:@[[MIUTestObjectsFactory assignProperty], [MIUTestObjectsFactory strongProperty], [MIUTestObjectsFactory copyProperty]]];
    
    return protocol;
}

+ (NSString *)protocolWithPropertiesString
{
    return @"@protocol protocolWithProperties\n\n"
            "@property(nonatomic, assign) BOOL assignProperty;\n"
            "@property(nonatomic, strong) NSString *strongProperty;\n"
            "@property(nonatomic, copy) NSString *copyProperty;\n"
            "\n"
            "\n@end";
}

+ (MIUProtocol *)protocolWithoutProperties
{
    MIUProtocol *protocol = [[MIUProtocol alloc] init];
    [protocol setProtocolName:@"protocolWithoutProperties"];
    
    return protocol;
}

+ (NSString *)protocolWithoutPropertiesString
{
    return @"@protocol protocolWithoutProperties\n"
    "\n"
    "\n@end";
}

+ (MIUProtocol *)protocolWithPropertiesAndConformedProtocol
{
    MIUProtocol *protocol = [[MIUProtocol alloc] init];
    [protocol setProtocolName:@"protocolWithPropertiesAndConformedProtocol"];
    [protocol setConformedToProtocols:@[@"Protocol1", @"Protocol2", @"Protocol3"]];
    [protocol setProperties:@[[MIUTestObjectsFactory assignProperty], [MIUTestObjectsFactory strongProperty], [MIUTestObjectsFactory copyProperty]]];
    
    return protocol;
}

+ (NSString *)protocolWithPropertiesAndConformedProtocolString
{
    return @"@protocol protocolWithPropertiesAndConformedProtocol<Protocol1, Protocol2, Protocol3>\n\n"
            "@property(nonatomic, assign) BOOL assignProperty;\n"
            "@property(nonatomic, strong) NSString *strongProperty;\n"
            "@property(nonatomic, copy) NSString *copyProperty;\n"
            "\n"
            "\n@end";
}

+ (MIUProtocol *)protocolWithPropertiesWithoutConformedProtocol
{
    MIUProtocol *protocol = [[MIUProtocol alloc] init];
    [protocol setProtocolName:@"protocolWithPropertiesAndConformedProtocol"];
    [protocol setProperties:@[[MIUTestObjectsFactory assignProperty], [MIUTestObjectsFactory strongProperty], [MIUTestObjectsFactory copyProperty]]];
    
    return protocol;
}

+ (NSString *)protocolWithPropertiesWithoutConformedProtocolString
{
    return @"@protocol protocolWithPropertiesAndConformedProtocol\n\n"
    "@property(nonatomic, assign) BOOL assignProperty;\n"
    "@property(nonatomic, strong) NSString *strongProperty;\n"
    "@property(nonatomic, copy) NSString *copyProperty;\n"
    "\n"
    "\n@end";
}

+ (MIUProtocol *)protocolWithConformedProtocolWithoutProperties
{
    MIUProtocol *protocol = [[MIUProtocol alloc] init];
    [protocol setProtocolName:@"protocolWithPropertiesAndConformedProtocol"];
    [protocol setConformedToProtocols:@[@"Protocol1", @"Protocol2", @"Protocol3"]];
    
    return protocol;
}

+ (NSString *)protocolWithConformedProtocolWithoutPropertiesString
{
    return @"@protocol protocolWithPropertiesAndConformedProtocol<Protocol1, Protocol2, Protocol3>\n\n"
    "\n"
    "\n@end";
}

#pragma mark - Components

+ (MIUProtocolsScanner *)protocolScanner
{
    return [[MIUProtocolsScanner alloc] init];
}

+ (MIUPropertiesScanner *)propertiesScanner
{
    return [[MIUPropertiesScanner alloc] init];
}

+ (MIUPropertyScanner *)propertyScanner
{
    return [[MIUPropertyScanner alloc] init];
}

#pragma mark - Private

+ (MIUProtocol *)protocolWithName:(NSString *)name
{
    MIUProtocol *protocol = [MIUTestObjectsFactory protocolWithoutProperties];
    [protocol setProtocolName:name];
    
    return protocol;
}

@end
