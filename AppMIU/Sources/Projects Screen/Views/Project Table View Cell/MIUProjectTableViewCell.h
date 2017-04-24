//
//  MIUProjectTableViewCell.h
//  AppMIU
//
//  Created by ovcharuk on 11/17/16.
//  Copyright © 2016 NIX. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MIUProjectModel;

@protocol MIUProjectTableViewCellDelegate

- (void)didChangeProject:(MIUProjectModel *)project;

@end

@interface MIUProjectTableViewCell : NSTableCellView

@property(weak, nonatomic) id<MIUProjectTableViewCellDelegate> delegate;

- (void)configureCellWithModel:(MIUProjectModel *)projectModel;
- (void)startEditingProjectName;
- (void)selectCellOnRow:(BOOL)selectedType;
- (BOOL)selected;

@end
