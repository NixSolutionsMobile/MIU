//
//  MIUFilesManager.h
//  MIU
//
//  Created by ovcharuk on 11/28/16.
//  Copyright © 2016 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIUFilesManager : NSObject

+ (instancetype)sharedManager;

- (NSString *)projectNameFromRootFolder:(NSString *)rootFolder;

@end
