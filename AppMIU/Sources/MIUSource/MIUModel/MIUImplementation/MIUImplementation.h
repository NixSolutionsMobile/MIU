//
//  MIUImplementation.h
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/8/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIUImplementation : NSObject<NSCopying>

@property(nonatomic, strong) NSString *filePath;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) NSRange range;
@property(nonatomic, strong) NSArray *synthesizedProperties;

@property(nonatomic, assign, getter=isCategory) BOOL category;

- (instancetype)initWithName:(NSString *)name isCategory:(BOOL)isCategory filePath:(NSString *)filePath range:(NSRange)range synthesizedProperty:(NSArray *)synthesizedProperty;

@end
