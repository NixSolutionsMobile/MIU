//
//  MIUProtocolsScanner.h
//  ModelImprovementUtility
//
//  Created by Nesteforenko Andrey on 10/28/15.
//  Copyright © 2015 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIUProtocolsScanner : NSObject

- (NSArray *)protocolsFromFilePathes:(NSArray *)filePathes;
- (NSArray *)protocolsFromString:(NSString *)fileContent;

@end
