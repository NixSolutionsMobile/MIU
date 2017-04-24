//
//  MIUClassStatistics.h
//  ModelImprovementUtility
//
//  Created by Andrey on 2/29/16.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIUMethodStatistics.h"
#import "MIUClass.h"

@interface MIUClassStatistics : NSObject

@property(nonatomic, strong) MIUClass *generatingClass;
@property(nonatomic) BOOL isClassNeedUpdate;
@property(nonatomic, strong) NSArray<MIUMethodStatistics *> *methodsStatistic;

- (BOOL)isGeneratingSuccesed;

@end
