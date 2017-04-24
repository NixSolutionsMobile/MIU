//
//  MIUTestObjectsFactory.h
//  ModelImprovementUtility
//
//  Created by Nesteforenko Andrey on 10/28/15.
//  Copyright © 2015 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MIUProperty.h"
#import "MIUProtocol.h"

#import "MIUPropertiesScanner.h"
#import "MIUProtocolsScanner.h"
#import "MIUPropertyScanner.h"

@interface MIUTestObjectsFactory : NSObject

#pragma mark - Models

#pragma mark - Components assembly

+ (MIUProtocolsScanner *)protocolScanner;
+ (MIUPropertiesScanner *)propertiesScanner;
+ (MIUPropertyScanner *)propertyScanner;

#pragma mark - Properties

+ (MIUProperty *)assignProperty;
+ (MIUProperty *)strongProperty;
+ (MIUProperty *)copyProperty;

#pragma mark - Protocols

+ (MIUProtocol *)protocolWithProperties;
+ (MIUProtocol *)protocolWithoutProperties;

+ (MIUProtocol *)protocolWithPropertiesAndConformedProtocol;
+ (MIUProtocol *)protocolWithPropertiesWithoutConformedProtocol;

+ (MIUProtocol *)protocolWithConformedProtocolWithoutProperties;

#pragma mark - Protocols strings

+ (NSString *)protocolWithPropertiesString;
+ (NSString *)protocolWithoutPropertiesString;

+ (NSString *)protocolWithPropertiesAndConformedProtocolString;
+ (NSString *)protocolWithPropertiesWithoutConformedProtocolString;

+ (NSString *)protocolWithConformedProtocolWithoutPropertiesString;

@end
