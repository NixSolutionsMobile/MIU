//
//  MIUProtocol.h
//  ModelImprovementUtility
//
//  Created by Nesteforenko Andrey on 10/27/15.
//  Copyright © 2015 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIUProperty.h"

typedef NS_ENUM(NSUInteger, MIUProtocolStatus)
{
    MIUProtocolStatusFound = 0,
    MIUProtocolStatusNotFound
};

@interface MIUProtocol : NSObject<NSCopying>

@property(nonatomic, copy) NSString *protocolName;
@property(nonatomic, assign) MIUProtocolStatus status;

/**
 *  contains |NSString *| objects
 */
@property(nonatomic, strong) NSArray *conformedToProtocols;

/**
 *  contains |MIUProperty *| objects
 */
@property(nonatomic, strong) NSArray *properties;


#pragma mark - Methods

/**
 *  check is current protocol is Base is conform just NSobjec protocol
 *
 *  @return |BOOL| for is Current protocol is Base(NSobject conformed) Protocol
 */
- (BOOL)isBaseProtocol;

/**
 *  method for append model with needed conformed protocol models
 *
 *  @param protocolModels contains |MIUProtocol *| objects
 */
- (void)appendWithNeededProtocolsModels:(NSArray *)protocolModels;

/**
 *  all properties from app conformed protocols
 *
 *  @return |MIUProperty *|
 */
- (NSArray *)propertiesFromAllConformedProtocols;

@end
