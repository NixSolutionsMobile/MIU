//
//  MIUInterfacesScanner.h
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/3/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIUInterfacesScanner : NSObject

- (NSSet *)interfacesFromFileAtPath:(NSString *)path;
- (NSSet *)interfacesFromString:(NSString *)contentOfFile;

@end
