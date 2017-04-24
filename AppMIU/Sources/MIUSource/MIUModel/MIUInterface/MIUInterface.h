//
//  MIUInterface.h
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/3/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIUInterface : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *superClass;
@property(nonatomic, assign, getter = isExtension) BOOL extension;

/**
 *  contain |MIUProperty| objects
 */
@property(nonatomic, strong) NSSet *properties;
/**
 *  contains |NSString| objects
 */
@property(nonatomic, strong) NSArray *conformedToProtocols;
/**
 *  contains |NSString *| objects (name of syntesized properties)
 */
@property(nonatomic, strong) NSArray *synthesizedProperties;

- (instancetype)initWithName:(NSString *)name
                 isExtension:(BOOL)isExtension
               andProperties:(NSSet *)properties
                  superClass:(NSString *)superClass
        conformedToProtocols:(NSArray *)conformedProtocols;

- (BOOL)isBase;

@end
