//
//  MIUProperty.h
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/2/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MIUPropertyMemoryAttribute)
{
    MIUPropertyMemoryAttributeUnknown = 0,
    MIUPropertyMemoryAttributeAssign,
    MIUPropertyMemoryAttributeStrong,
    MIUPropertyMemoryAttributeCopy,
    MIUPropertyMemoryAttributeWeak
};

@interface MIUProperty : NSObject<NSCoding, NSCopying>

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSString *typeConformed;
@property(nonatomic, assign) BOOL isPointer;
@property(nonatomic, assign) BOOL isAtomic;
@property(nonatomic, assign) BOOL isReadonly;
@property(nonatomic, assign) MIUPropertyMemoryAttribute memoryAttribute;

- (instancetype)initWithName:(NSString *)name
                        type:(NSString *)type
                      setter:(NSString *)setter
                      getter:(NSString *)getter
                   isPointer:(BOOL)isPointer
                    isAtomic:(BOOL)isAtomic
             memoryAttribute:(MIUPropertyMemoryAttribute)memoryAttribute;

- (instancetype)initWithName:(NSString *)name
                        type:(NSString *)type
                      setter:(NSString *)setter
                      getter:(NSString *)getter
                   isPointer:(BOOL)isPointer
                    isAtomic:(BOOL)isAtomic
             memoryAttribute:(MIUPropertyMemoryAttribute)memoryAttribute
                  isReadonly:(BOOL)isReadonly;

- (instancetype)initWithName:(NSString *)name type:(NSString *)type isPointer:(BOOL)isPointer isAtomic:(BOOL)isAtomic memoryAttribute:(MIUPropertyMemoryAttribute)memoryAttribute;

- (NSString *)getSetter;
- (NSString *)getGetter;
- (NSString *)getGetterToUseWithOutSelf;

@end
