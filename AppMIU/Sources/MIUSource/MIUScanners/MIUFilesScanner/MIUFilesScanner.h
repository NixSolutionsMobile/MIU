//
//  MIUFilesScanner.h
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/27/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIUFilesScanner : NSObject

- (NSSet *)pathsForFilesFromFolderAtPath:(NSString *)path;
- (void)deleteGeneratedFoldersfromPath:(NSString *)path;
- (void)changeToGeneratedFileAtPath:(NSString *)path;

@end
