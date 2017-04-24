//
//  MIUNewProjectViewController.h
//  AppMIU
//
//  Created by Ovcharuk on 11/8/16.
//  Copyright © 2016 NIX. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol MIUNewProjectViewControllerDelegate<NSObject>

- (void)reloadProjects;

@end

@interface MIUNewProjectViewController : NSViewController

@property(nonatomic, weak) id<MIUNewProjectViewControllerDelegate> delegate;
@property(copy, nonatomic) NSString *rootFolder;

@end
