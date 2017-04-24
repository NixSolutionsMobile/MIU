//
//  ViewController.h
//  AppMIU
//
//  Created by Ovcharuk on 10/28/16.
//  Copyright © 2016 NIX. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MIUProjectModel.h"

@protocol MIUPathesViewControllerDelegate<NSObject>

- (void)closeProject:(MIUProjectModel *)project;

@end

@interface MIUPathesViewController : NSViewController<NSWindowDelegate>

@property(nonatomic, strong) MIUProjectModel *currentProject;
@property(nonatomic, weak) id<MIUPathesViewControllerDelegate> delegate;

@end

