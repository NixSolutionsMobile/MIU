//
//  MIUProjectTableViewCell.m
//  AppMIU
//
//  Created by ovcharuk on 11/17/16.
//  Copyright © 2016 NIX. All rights reserved.
//

#import "MIUProjectTableViewCell.h"
#import "MIUProjectModel.h"

@interface MIUProjectTableViewCell ()<NSTextFieldDelegate>

@property(nonatomic) MIUProjectModel *project;
@property(weak, nonatomic) IBOutlet NSTextField *projectNameLabel;
@property(weak, nonatomic) IBOutlet NSTextField *rootFolderLabel;
@property(nonatomic) BOOL didSelected;

@end

@implementation MIUProjectTableViewCell

- (void)configureCellWithModel:(MIUProjectModel *)projectModel
{
    [self setProject:projectModel];
    
    [[self projectNameLabel] setStringValue:[projectModel projectName]];
    [[self rootFolderLabel] setStringValue:[projectModel rootFolder]];
    [self setDidSelected:NO];
}

- (void)controlTextDidEndEditing:(NSNotification *)obj
{
    MIUProjectModel *changedProject = [self project];
    [changedProject setProjectName:[[self projectNameLabel] stringValue]];
    [[self delegate] didChangeProject:changedProject];
}

- (void)startEditingProjectName
{
    [[self projectNameLabel] becomeFirstResponder];
}

- (void)selectCellOnRow:(BOOL)selectedType
{
    if (selectedType == YES)
    {
        [[self projectNameLabel] setTextColor:[NSColor whiteColor]];
        [self setDidSelected:selectedType];
    }
    else
    {
        [[self projectNameLabel] setTextColor:[NSColor blackColor]];
        [self setDidSelected:selectedType];
    }
}

- (BOOL)selected
{
    return self.didSelected;
}

@end
