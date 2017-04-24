//
//  MIUPropertyScanner.h
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/2/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MIUProperty;

@interface MIUPropertyScanner : NSObject

- (MIUProperty *)propertyWithString:(NSString *)property;

@end
