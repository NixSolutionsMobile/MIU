//
//  MIUEnum.h
//  ModelImprovementUtilite
//
//  Created by Nesteforenko Andrey on 9/17/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIUEnum : NSObject<NSCopying>

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *type;

- (instancetype)initEnumWithName:(NSString *)name type:(NSString *)type;

@end
