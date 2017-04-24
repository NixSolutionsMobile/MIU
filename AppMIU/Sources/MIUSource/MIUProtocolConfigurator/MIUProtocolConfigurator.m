//
//  MIUProtocolConfigurator.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/24/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUProtocolConfigurator.h"

static NSString *const MIUListOfProtocols = @"<NSCoding, NSCopying>";
static NSString *const MIUCoding = @"NSCoding";
static NSString *const MIUCopying = @"NSCopying";

@implementation MIUProtocolConfigurator

- (NSString *)configureProtocolListInString:(NSString *)string forInterfaceWithName:(NSString *)name
{
    NSMutableString *configuratedString = [string mutableCopy];
    
    // pattern to get conformed protocols from interface and add NSCoding, NSCopying if needed
    NSString *pattern = [NSString stringWithFormat:@"(\\@interface\\s*%@\\s*\\:\\s*\\w*()\\s*(\\<?)(((\\w*)\\s*\\,{0,1}\\s*)*)\\>?)", name];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if (match != nil)
    {
        NSString *interface = [string substringWithRange:[match rangeAtIndex:1]];
        
        if ([self checkToConformingForAnyProtocolInterace:interface])
        {
            NSString *protocolsString = [string substringWithRange:[match rangeAtIndex:4]];
            NSString *protocolsWithoutWhitespace = [protocolsString stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray *protocols = [protocolsWithoutWhitespace componentsSeparatedByString:@","];
            NSString *resultProtocols;
            
            if (![self checkToConformProtocol:MIUCopying inProtocolsArray:protocols])
            {
                resultProtocols  = [self insertProtocol:MIUCopying inStringWithProtocols:protocolsString];
            }
            
            if (![self checkToConformProtocol:MIUCoding inProtocolsArray:protocols])
            {
                resultProtocols = [self insertProtocol:MIUCoding inStringWithProtocols:protocolsString];
            }
            
            if (resultProtocols != nil)
            {
                [configuratedString replaceCharactersInRange:[match rangeAtIndex:4] withString:resultProtocols];
            }
        }
        else
        {
            NSRange range = [match rangeAtIndex:2];
            int indexToInsertProtocols = (int)(range.location + range.length);
            [configuratedString insertString:MIUListOfProtocols atIndex:indexToInsertProtocols];
        }
    }
    
    return configuratedString;
}

- (BOOL)checkToConformingForAnyProtocolInterace:(NSString *)interface
{
    // it is checking for interface, is it already conform to protocols NSCoding, NSCopying
    NSString *pattern = @"\\@interface\\s*\\w*\\s*\\:\\s*\\w*\\s*\\<";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    NSTextCheckingResult *match = [regex firstMatchInString:interface options:0 range:NSMakeRange(0, [interface length])];
    
    if (match != nil)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)checkToConformProtocol:(NSString *)protocol inProtocolsArray:(NSArray *)protocols
{
    if ([protocols indexOfObject:protocol] != NSNotFound)
    {
        return YES;
    }
    
    return NO;
}

- (NSString *)insertProtocol:(NSString *)protocol inStringWithProtocols:(NSString *)stringWithProtocols
{
    return [stringWithProtocols stringByAppendingString:[NSString stringWithFormat:@", %@", protocol]];
}

@end
