//
//  AppDelegate.m
//  AppMIU
//
//  Created by Ovcharuk on 10/28/16.
//  Copyright © 2016 NIX. All rights reserved.
//

#import "AppDelegate.h"
#import "NSColor+MIUColor.h"
#import "MIUProjectsViewController.h"

@interface AppDelegate ()

@property(nonatomic, strong) NSWindowController *mainWindowController;

@end

@implementation AppDelegate

- (IBAction)didClickAddActionButton:(id)sender
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"DidClickAddNewProject"
     object:self];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    NSWindow *mainWindow = [[[NSApplication sharedApplication] windows] firstObject];
    [self setupWindowStyle:mainWindow];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    if (!flag)
    {
        NSStoryboard *mainStoryboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
        MIUProjectsViewController *viewController = [mainStoryboard instantiateControllerWithIdentifier:@"ProjectsViewController"];
        
        NSWindowController *windowController = [mainStoryboard instantiateControllerWithIdentifier:@"ProjectsWindowController"];
        [windowController setContentViewController:viewController];
        [self setupWindowStyle:[windowController window]];
        
        [self setMainWindowController:windowController];
        [windowController showWindow:self];
    }
    
    return YES;
}

#pragma mark -

- (void)setupWindowStyle:(NSWindow *)window
{
    [window setTitleVisibility:NSWindowTitleHidden];
    [window setBackgroundColor:[NSColor miuColor]];
}

@end
