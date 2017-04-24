//
//  MIUEnumsScanner.h
//  ModelImprovementUtilite
//
//  Created by Nesteforenko Andrey on 9/17/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIUEnum.h"

@interface MIUEnumsScanner : NSObject

- (NSSet *)enumsFromPathes:(NSSet *)pathes;
- (NSSet *)enumsFromString:(NSString *)fileContent;

@end
