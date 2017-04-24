//
//  NSColor+MIUColor.m
//  AppMIU
//
//  Created by ovcharuk on 11/21/16.
//  Copyright © 2016 NIX. All rights reserved.
//

#import "NSColor+MIUColor.h"

@implementation NSColor (MIUColor)

+ (NSColor *)miuColor
{
    return [NSColor colorWithRed:0.f green:193 / 255.f blue:128 / 255.f alpha:1.0f];
}

+ (NSColor *)miuWarningColor
{
    return [NSColor colorWithRed:255 / 255.f green:226 / 255.f blue:154 / 255.f alpha:1.0f];
}

@end
