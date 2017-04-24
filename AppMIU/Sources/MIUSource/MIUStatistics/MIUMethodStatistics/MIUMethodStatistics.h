//
//  MIUMethodStatistics.h
//  ModelImprovementUtility
//
//  Created by Andrey on 2/29/16.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MIUMethod;

typedef NS_ENUM(NSUInteger, MIUMethodState)
{
    MIUMethodStateTheNone,
    MIUMethodStateTheSame,
    MIUMethodStateGenerated,
    MIUMethodStateRegenerated,
    MIUMethodStateSupportedByUser,
    MIUMethodStateGeneratedWithWarnings
};

@interface MIUMethodStatistics : NSObject

@property(nonatomic, strong) MIUMethod *method;
@property(nonatomic, strong) NSDictionary *problematicProperties; // [NSString *name : NSString type]
@property(nonatomic, assign) MIUMethodState state;

- (NSString *)stateFromSelf;

@end
