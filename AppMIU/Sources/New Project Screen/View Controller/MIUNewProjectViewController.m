//
//  MIUNewProjectViewController.m
//  AppMIU
//
//  Created by Ovcharuk on 11/8/16.
//  Copyright © 2016 NIX. All rights reserved.
//

#import "MIUNewProjectViewController.h"
#import "MIUProjectsManager.h"
#import "MIUProjectModel.h"
#import "MIUFilesManager.h"

@interface MIUNewProjectViewController ()<NSTextFieldDelegate, NSWindowDelegate>

@property(nonatomic, weak) IBOutlet NSTextField *projectNameTextField;
@property(nonatomic, weak) IBOutlet NSTextField *projectRootPathTextField;
@property(nonatomic, weak) IBOutlet NSButton *buttonAdd;

@end

@implementation MIUNewProjectViewController

#pragma mark - VC life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setPreferredContentSize:[[self view] frame].size];
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    if ([[self rootFolder] length] == 0)
    {
        [self showOpenDialog];
    }
    else
    {
        [[self projectRootPathTextField] setStringValue:[self rootFolder]];
        
        MIUFilesManager *filesManager = [MIUFilesManager sharedManager];
        NSString *projectName = [filesManager projectNameFromRootFolder:[self rootFolder]];
        [[self projectNameTextField] setStringValue:projectName];
        
        if ([[[self projectNameTextField] stringValue] length] > 0)
        {
            [[self buttonAdd] setEnabled:YES];
        }
    }
}

- (void)viewDidDisappear
{
    [super viewDidDisappear];

    [[NSApplication sharedApplication] stopModal];
}

#pragma mark - IBActions

- (IBAction)buttonCancelDidTap:(id)sender
{
    [[[self view] window] close];
}

- (IBAction)buttonAddDidTap:(id)sender
{
    MIUProjectsManager *manager = [MIUProjectsManager sharedManager];
    [manager addProject:[self newProject]];
    
    [[[self view] window] close];
    [[self delegate] reloadProjects];
}

- (MIUProjectModel *)newProject
{
    NSString *uuidString = [[NSUUID UUID] UUIDString];
    NSString *projectName = [[self projectNameTextField] stringValue];
    NSString *rootFolder = [[self projectRootPathTextField] stringValue];
    MIUProjectModel *newProject = [[MIUProjectModel alloc] initWithID:uuidString projectName:projectName rootFolder:rootFolder];
    
    return newProject;
}

- (IBAction)buttonSelectPathDidTap:(id)sender
{
    [self showOpenDialog];
}

- (void)showOpenDialog
{
    NSOpenPanel *openDialog = [self openDialog];
    
    if ([openDialog runModal] == NSModalResponseOK)
    {
        NSString *projectRootPath = [[openDialog URL] relativePath];
        [[self projectRootPathTextField] setStringValue:projectRootPath];
        
        MIUFilesManager *filesManager = [MIUFilesManager sharedManager];
        NSString *projectName = [filesManager projectNameFromRootFolder:projectRootPath];
        [[self projectNameTextField] setStringValue:projectName];
        
        if ([[[self projectNameTextField] stringValue] length] > 0)
        {
            [[self buttonAdd] setEnabled:YES];
        }
    }
}

- (NSOpenPanel *)openDialog
{
    NSOpenPanel *openDialog = [NSOpenPanel openPanel];
    [openDialog setCanChooseFiles:NO];
    [openDialog setAllowsMultipleSelection:NO];
    [openDialog setCanChooseDirectories:YES];
    [openDialog setCanCreateDirectories:YES];
    
    return openDialog;
}

#pragma mark - NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)obj
{
    NSUInteger rootPathLength = [[[self projectRootPathTextField] stringValue] length];
    NSUInteger projectNameLength = [[[self projectNameTextField] stringValue] length];
    
    if (rootPathLength > 0 && projectNameLength > 0)
    {
        [[self buttonAdd] setEnabled:YES];
    }
    else
    {
        [[self buttonAdd] setEnabled:NO];
    }
}

@end
