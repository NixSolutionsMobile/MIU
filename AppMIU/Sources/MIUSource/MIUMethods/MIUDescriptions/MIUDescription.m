//
//  MIUDescriptions.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/27/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUDescription.h"
#import "MIUProperty.h"
#import "MIUClass.h"

static NSString *const MIUPointerTypeTemplateString = @"    [description appendString:[NSString stringWithFormat:@\"%@ - %@ \\n\", [self %@]]];\n";
static NSString *const MIUInititalMethodPartWithSuper = @"{\n    NSMutableString *description = [NSMutableString stringWithFormat:@\" \\n %@ \\n\", [super description]];\n\n";
static NSString *const MIUInititalMethodPart = @"{\n    NSMutableString *description = [NSMutableString new];\n\n";
static NSString *const MIUWarning = @"\n    #warning Unknown specifier for data type %@\n";
static NSString *const MIUStringCompabilityProperty = @"    [description appendString:[NSString stringWithFormat:@\"%@ - %@ \\n\", [@([self %@]) stringValue]]];\n";
static NSString *const MIUBaseDescriptionTemplate = @"    [description appendString:[NSString stringWithFormat:@\"%@ - %@ \\n\", [self %@]]];\n";
static NSString *const MIUBoolDescriptionTemplate = @"    [description appendString:[NSString stringWithFormat:@\"%@ - %@ \\n\", [self %@] ? @\"YES\" : @\"NO\"]];\n";

@interface MIUDescription ()

@property(nonatomic, strong) NSMutableString *warnings;
@property(nonatomic, strong) NSMutableString *outputElements;

@end

@implementation MIUDescription

- (NSString *)methodBodyForClass:(MIUClass *)class
{
    NSMutableString *methodBody = [NSMutableString new];
    _warnings = [NSMutableString new];
    _outputElements = [NSMutableString new];
    [_warnings appendString:@""];
    
    if ([class isBase])
    {
        [methodBody appendString:MIUInititalMethodPart];
    }
    else
    {
        [methodBody appendString:MIUInititalMethodPartWithSuper];
    }
    
    [methodBody appendFormat:@"%@", [self formatStringForMethod:class]];
    [methodBody appendFormat:@"\n    return description;\n}"];
    
    return methodBody;
}

- (NSString *)formatStringForMethod:(MIUClass *)class
{
    NSMutableString *formatElements = [NSMutableString new];
    
    for (MIUProperty *property in [class properties])
    {
        if ([property isPointer])
        {
            [formatElements appendFormat:MIUPointerTypeTemplateString, [property name], @"%@", [property getGetter]];
        }
        else
        {
            NSString *specifier = [self outputSpecifierForDataType:property];
            
            if (specifier != nil)
            {
                if ([[property type] isEqualToString:@"BOOL"])
                {
                    [formatElements appendFormat:MIUBoolDescriptionTemplate, [property name], @"%@", [property getGetter]];
                }
                else
                {
                    [formatElements appendFormat:MIUBaseDescriptionTemplate, [property name], specifier, [property getGetter]];
                }
            }
            else
            {
                NSPredicate *preidacte = [NSPredicate predicateWithFormat:@"SELF = %@", [property type]];
                NSSet *types = [[self enums] valueForKey:NSStringFromSelector(@selector(name))];
                NSSet *enumsTypes = [types filteredSetUsingPredicate:preidacte];
                
                if ([enumsTypes containsObject:[property type]])
                {
                    [formatElements appendFormat:MIUStringCompabilityProperty, [property name], @"%@", [property getGetter]];
                }
                else
                {
                    [[super problematicProperties] setObject:[property type] forKey:[property name]];
                    [formatElements appendFormat:MIUWarning, [property type]];
                }
            }
        }
    }
    
    return formatElements;
}

- (NSString *)outputSpecifierForDataType:(MIUProperty *)property
{
    NSString *specifier;
    NSString *type = [property type];
    
    if ([type isEqualToString:@"char"])
    {
        specifier = @"%%";
        [_outputElements appendFormat:@", [self %@]", [property getGetter]];
    }
    else if ([type isEqualToString:@"int"])
    {
        specifier = @"%d";
        [_outputElements appendFormat:@", [self %@]", [property getGetter]];
    }
    else if ([type isEqualToString:@"long"])
    {
        specifier = @"%ld";
        [_outputElements appendFormat:@", [self %@]", [property getGetter]];
    }
    else if ([type isEqualToString:@"NSInteger"])
    {
        specifier = @"%ld";
        [_outputElements appendFormat:@", (long)[self %@]", [property getGetter]];
    }
    else if ([type isEqualToString:@"NSUInteger"])
    {
        specifier = @"%ld";
        [_outputElements appendFormat:@", (unsigned long)[self %@]", [property getGetter]];
    }
    else if ([type isEqualToString:@"long long"])
    {
        specifier = @"%lld";
        [_outputElements appendFormat:@", [self %@]", [property getGetter]];
    }
    else if ([type isEqualToString:@"unsigned int"])
    {
        specifier = @"%u";
        [_outputElements appendFormat:@", [self %@]", [property getGetter]];
    }
    else if ([type isEqualToString:@"BOOL"])
    {
        specifier = @"%@";
        [_outputElements appendFormat:@", [self %@] ? @\"YES\" : @\"NO\"", [property getGetter]];
    }
    else if ([type isEqualToString:@"double"] || [type isEqualToString:@"float"] || [type isEqualToString:@"CGFloat"] || [type isEqualToString:@"NSTimeInterval"])
    {
        specifier = @"%f";
        [_outputElements appendFormat:@", [self %@]", [property getGetter]];
    }
    else if ([type isEqualToString:@"unsigned char"])
    {
        specifier = @"%c";
        [_outputElements appendFormat:@", [self %@]", [property getGetter]];
    }
    else if ([type isEqualToString:@"unsigned int"])
    {
        specifier = @"%u";
        [_outputElements appendFormat:@", [self %@]", [property getGetter]];
    }
    else if ([type isEqualToString:@"unsigned long long"])
    {
        specifier = @"%llu";
        [_outputElements appendFormat:@", [self %@]", [property getGetter]];
    }
    else if ([type isEqualToString:@"CGRect"])
    {
        specifier = @"%@";
        [_outputElements appendFormat:@", NSStringFromCGRect([self %@])", [property getGetter]];
    }
    else if ([type isEqualToString:@"CGSize"])
    {
        specifier = @"%@";
        [_outputElements appendFormat:@", NSStringFromCGSize([self %@])", [property getGetter]];
    }
    else if ([type isEqualToString:@"CGPoint"])
    {
        specifier = @"%@";
        [_outputElements appendFormat:@", NSStringFromCGPoint([self %@])", [property getGetter]];
    }
    else if ([type isEqualToString:@"CGVector"])
    {
        specifier = @"%@";
        [_outputElements appendFormat:@", NSStringFromCGVector([self %@])", [property getGetter]];
    }
    
    return specifier;
}
@end
