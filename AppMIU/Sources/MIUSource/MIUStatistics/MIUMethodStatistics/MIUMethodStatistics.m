//
//  MIUMethodStatistics.m
//  ModelImprovementUtility
//
//  Created by Andrey on 2/29/16.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUMethodStatistics.h"
#import "MIUMethod.h"

@implementation MIUMethodStatistics

- (NSString *)description
{
    NSMutableString *description = [NSMutableString new];
    NSString *warnings = [self stringFromProblematicProperties];
    
    if ([warnings length] > 0)
    {
        [description appendString:[NSString stringWithFormat:@"Warnings:\n\n"]];
        [description appendString:[NSString stringWithFormat:@"%@ \n", warnings]];
    }
    
    return description;
}

- (NSString *)stringFromProblematicProperties
{
    if ([[_problematicProperties allKeys] count] == 0)
    {
        return nil;
    }
    
    NSMutableString *description = [NSMutableString new];
    
    for (NSString *key in [_problematicProperties allKeys])
    {
        NSString *value = [_problematicProperties valueForKey:key];
        
        [description appendFormat:@"        name:%@      type:%@\n", key, value];
    }

    return description;
}

- (NSString *)stateFromSelf
{
    if ([[_problematicProperties allKeys] count] > 0)
    {
        _state = MIUMethodStateGeneratedWithWarnings;
    }
    
    switch (_state)
    {
        case MIUMethodStateTheNone:
            return @"none";
            break;
        case MIUMethodStateGeneratedWithWarnings:
            return @"Generated With Warnings";
            break;
        case MIUMethodStateTheSame:
            return @"Not Changed";
            break;
        case MIUMethodStateSupportedByUser:
            return @"Supported By User";
            break;
        case MIUMethodStateRegenerated:
            return @"Regenerated";
            break;
        case MIUMethodStateGenerated:
            return @"First Generation";
            break;
    }
}

- (MIUMethodState)state
{
    if ([[_problematicProperties allKeys] count] > 0)
    {
        _state = MIUMethodStateGeneratedWithWarnings;
    }
    
    return _state;
}

@end
