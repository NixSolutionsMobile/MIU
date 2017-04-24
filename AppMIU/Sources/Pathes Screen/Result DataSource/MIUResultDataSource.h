//
//  MIUResultDataSource.h
//  AppMIU
//
//  Created by Ovcharuk on 10/28/16.
//  Copyright © 2016 NIX. All rights reserved.
//
#import "NSColor+MIUColor.h"
#import "ResultStateEnum.h"
#import <Cocoa/Cocoa.h>

@interface MIUResultDataSource : NSObject<NSTableViewDelegate, NSTableViewDataSource>

@property(strong, nonatomic) NSArray *resultStatistics;

- (instancetype)initWithTableView:(NSTableView *)tableView;
- (void)displayResultsWithSuccessState:(ResultType)resultType;

@end
