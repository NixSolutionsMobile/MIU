//
//  MIUFileAnalyzer.h
//  MIU
//
//  Created by Vlad Yalovenko on 01/12/2016.
//  Copyright © 2016 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MIUClassStatistics, MIUProjectModel;

@interface MIUFileAnalyzer : NSObject

- (NSArray<MIUClassStatistics *> *)analyzeFilesFromFilesAtPaths:(NSSet *)paths withRootProjectPath:(NSSet *)rootProjectPath inProject:(MIUProjectModel *)project;

@end
