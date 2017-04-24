//
//  MIUFileGenerator.h
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/8/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MIUClassStatistics, MIUFileGenerator;

@protocol MIUProgressDelegate<NSObject>

- (void)didFileGenerator:(MIUFileGenerator *)fileGenerator allStatistics:(NSArray<MIUClassStatistics *> *)statistics newOneItem:(MIUClassStatistics *)newItem;

@end

@interface MIUFileGenerator : NSObject

@property(nonatomic, weak) id<MIUProgressDelegate>progressDelegate;

- (NSArray<MIUClassStatistics *> *)generateFilesFromFilesAtPaths:(NSSet *)paths withRootProjectPath:(NSSet *)rootProjectPath;

@end
