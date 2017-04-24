//
//  MIUDefaultsManager.h
//  AppMIU
//
//  Created by Ovcharuk on 11/4/16.
//  Copyright © 2016 NIX. All rights reserved.
//
#import "MIUClass.h"
#import <Foundation/Foundation.h>

@class MIUProjectModel, MIUClass;

@interface MIUProjectsManager : NSObject

+ (instancetype)sharedManager;

- (NSArray<MIUProjectModel *> *)projects;
- (void)addProject:(MIUProjectModel *)project;
- (void)deleteProject:(MIUProjectModel *)project;
- (void)replaceProject:(MIUProjectModel *)project;

- (NSArray<NSString *> *)pathesInProject:(MIUProjectModel *)project;
- (void)addPath:(NSString *)path toProject:(MIUProjectModel *)project;
- (void)deletePath:(NSString *)path inProject:(MIUProjectModel *)project;

- (NSMutableArray *)getClassesForProject:(MIUProjectModel *)project;
- (void)deleteClass:(NSString *)className inProject:(MIUProjectModel *)project;
- (void)addClass:(MIUClass *)class toProject:(MIUProjectModel *)project;

@end
