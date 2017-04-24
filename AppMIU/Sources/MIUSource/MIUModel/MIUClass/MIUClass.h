//
//  MIUClass.h
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/6/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MIUImplementation;

@interface MIUClass : NSObject<NSCoding, NSCopying>

@property(nonatomic, strong) NSString *name;
@property(nonatomic, copy) NSString *superClass;
@property(nonatomic, strong) MIUImplementation *implementation;

@property(nonatomic, strong) NSSet *properties;
@property(nonatomic, strong) NSArray *conformedToProtocols; // contains |MIUProtocol *| objects
@property(nonatomic, strong) NSArray *conformedToProtocolsStrings; // contains |MIUProtocol *| objects

- (instancetype)initWithName:(NSString *)name
                  properties:(NSSet *)properties
           andImplementation:(MIUImplementation *)implementation
                  superClass:(NSString *)superClass
        conformedToProtocols:(NSArray *)conformedToProtocols;

- (instancetype)initWithName:(NSString *)name
                  properties:(NSSet *)properties
                  superClass:(NSString *)superClass
        conformedToProtocols:(NSArray *)conformedToProtocols;

- (BOOL)isBase;

@end
