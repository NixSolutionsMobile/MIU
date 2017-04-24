//
//  MIUImplementationsScanner.h
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/8/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIUImplementationsScanner : NSObject

- (NSSet *)implementationsFromFilesAtPaths:(NSSet *)paths;

@end
