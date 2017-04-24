//
//  MIUClassStatistics.m
//  ModelImprovementUtility
//
//  Created by Andrey on 2/29/16.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUClassStatistics.h"

@implementation MIUClassStatistics

- (BOOL)isGeneratingSuccesed
{
    for (MIUMethodStatistics *methodStat in _methodsStatistic)
    {
        if ([[[methodStat problematicProperties] allKeys] count] > 0)
        {
            return NO;
        }
    }
    
    return YES;
}

@end
