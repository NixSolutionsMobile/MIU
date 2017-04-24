//
//  MIUObjectsScanner.h
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/6/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIUObjectsScanner : NSObject

- (NSSet *)classesFromPaths:(NSSet *)paths withRootProjectPath:(NSSet *)rootPathes;
- (NSSet *)enumsFromPaths:(NSSet *)paths;

@end
