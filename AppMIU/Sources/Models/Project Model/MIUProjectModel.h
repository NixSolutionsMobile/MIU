//
//  MIUProjectModel.h
//  AppMIU
//
//  Created by Ovcharuk on 11/4/16.
//  Copyright © 2016 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIUProjectModel : NSObject<NSCoding, NSCopying>

@property(nonatomic, copy) NSString *projectID;
@property(nonatomic, copy) NSString *projectName;
@property(nonatomic, copy) NSString *rootFolder;
@property(nonatomic, copy) NSArray *pathes;

- (instancetype)initWithID:(NSString *)projectID projectName:(NSString *)projectName rootFolder:(NSString *)rootFolder;

@end
