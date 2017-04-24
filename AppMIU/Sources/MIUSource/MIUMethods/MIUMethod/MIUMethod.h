//
//  MIUMethod.h
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/7/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MIUClass;
@class MIUMethodStatistics;

@interface MIUMethod : NSObject

@property(nonatomic, strong) NSString *returnType;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *argumentType;
@property(nonatomic, strong) NSString *argumentName;
@property(nonatomic, assign, getter = isPointerReturnType) BOOL pointerReturnType;
@property(nonatomic, assign, getter = isPointerArgumentType) BOOL pointerArgumentType;

@property(nonatomic, strong) NSMutableDictionary *problematicProperties; // [NSString *name : NSString type]

- (NSString *)headerOfMethod;
- (NSString *)methodBodyForClass:(MIUClass *)classWithProperties;

- (instancetype)initWithName:(NSString *)name
                  returnType:(NSString *)returnType
         isPointerReturnType:(BOOL)pointerReturnType
                     argName:(NSString *)argName
                     argType:(NSString *)argType
            isPointerArgType:(BOOL)pointerArgType;

@end
