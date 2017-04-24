//
//  MIUTableViewPathesDataSource.h
//  AppMIU
//
//  Created by Ovcharuk on 10/28/16.
//  Copyright © 2016 NIX. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MIUFilesDataSource : NSObject<NSTableViewDelegate, NSTableViewDataSource>

@property(strong, nonatomic) NSArray *pathesArray;

- (instancetype)initWithTableView:(NSTableView *)tableView;

@end
