//
//  MIUPropertiesScanner.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/2/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUPropertiesScanner.h"

@implementation MIUPropertiesScanner

- (NSSet *)propertiesFromString:(NSString *)stringWithProperties
{
    NSMutableSet *propertiesString = [NSMutableSet new];
    
    // delete commented code from string with properties
    NSString *stringWithOutComments = [self deleteComentedPartFromString:stringWithProperties startCommentSymbol:@"//" endCommentSymbol:@"\n"];
    stringWithOutComments = [self deleteComentedPartFromString:stringWithOutComments startCommentSymbol:@"/*" endCommentSymbol:@"*/"];
    
    // pattern to get all properties strings from "@" to ";"
    NSString *pattern = @"(\\@property\\s*(?:\\([\\w|\\,\\s\\:\\=]*\\))?(?:\\s*\\w*\\s*){1,3}?(?:\\<.*?\\>)?\\s*\\*?\\s*\\w*\\s*\\;)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    NSArray *matchesFromString = [regex matchesInString:stringWithOutComments options:0 range:NSMakeRange(0, [stringWithOutComments length])];
    
    for (NSTextCheckingResult *match in matchesFromString)
    {
        if (match != nil)
        {
            NSString *substringForMatch = [stringWithOutComments substringWithRange:[match range]];
            [propertiesString addObject:substringForMatch];
        }
    }
    
    return propertiesString;
}

- (NSString *)deleteComentedPartFromString:(NSString *)string startCommentSymbol:(NSString *)startCommentSymbol endCommentSymbol:(NSString *)endCommentSymbol
{
    NSMutableString *result = [string mutableCopy];
    
    while (YES)
    {
        NSRange searchRange = NSMakeRange(0, result.length);
        NSRange foundStartCommentRange;
        NSRange foundEndCommentRange;
        
        searchRange.length = result.length - searchRange.location;
        foundStartCommentRange = [result rangeOfString:startCommentSymbol options:NSCaseInsensitiveSearch range:searchRange];
      
        if (foundStartCommentRange.location != NSNotFound)
        {
            int location = (int)(foundStartCommentRange.length + foundStartCommentRange.location);
            foundEndCommentRange = [result rangeOfString:endCommentSymbol options:NSCaseInsensitiveSearch range:NSMakeRange(location, searchRange.length - location)];
            [result deleteCharactersInRange:NSMakeRange(foundStartCommentRange.location, foundEndCommentRange.location - foundStartCommentRange.location)];
            searchRange.location = foundEndCommentRange.location + foundEndCommentRange.length;
        }
        else
        {
            break;
        }
    }

    return result;
}

@end