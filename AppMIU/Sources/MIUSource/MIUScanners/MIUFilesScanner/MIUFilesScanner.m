//
//  MIUFilesScanner.m
//  ModelImprovmentUtilite
//
//  Created by Nesteforenko Andrey on 4/27/15.
//  Copyright (c) 2015 NIX. All rights reserved.
//

#import "MIUFilesScanner.h"

@implementation MIUFilesScanner

- (NSSet *)pathsForFilesFromFolderAtPath:(NSString *)path
{
    BOOL isDirectory;
    [[NSFileManager defaultManager] fileExistsAtPath:path
                                         isDirectory:&isDirectory];
    
    if (!isDirectory)
    {
        return [NSSet setWithArray:@[path]];
    }
    
    return [self pathsFromFolder:path];
}

- (NSSet *)pathsFromFolder:(NSString *)path
{
    NSDirectoryEnumerator *enumerator = [self directoryEnumeratorForPath:path];
    NSMutableSet *mutableFileURLs = [NSMutableSet set];
    
    for (NSURL *fileURL in enumerator)
    {
        NSString *filename;
        [fileURL getResourceValue:&filename forKey:NSURLNameKey error:nil];
        
        NSNumber *isDirectory;
        [fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
        
        if (![isDirectory boolValue] && ([[fileURL pathExtension] isEqualToString:@"h"] || [[fileURL pathExtension] isEqualToString:@"m"]))
        {
            [mutableFileURLs addObject:[fileURL path]];
        }
    }
    
    return mutableFileURLs;
}

- (void)deleteGeneratedFoldersfromPath:(NSString *)path
{
    NSDirectoryEnumerator *enumerator = [self directoryEnumeratorForPath:path];
    NSMutableArray *arrayWithComponentsToDelete = [NSMutableArray new];
    
    for (NSURL *fileURL in enumerator)
    {
        NSString *filename;
        [fileURL getResourceValue:&filename forKey:NSURLNameKey error:nil];
        
        NSNumber *isDirectory;
        [fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
        
        if ([isDirectory boolValue] && [[[fileURL pathComponents] lastObject] isEqualToString:@"Generated"])
        {
            NSArray *dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fileURL.absoluteString error:NULL];
            
            for (NSString *components in dirs)
            {
                [arrayWithComponentsToDelete addObject:[[fileURL path] stringByAppendingPathComponent:components]];
            }
            
            [arrayWithComponentsToDelete addObject:[fileURL path]];
        }
    }
    
    for (NSString *components in arrayWithComponentsToDelete)
    {
        [[NSFileManager defaultManager] removeItemAtPath:components error:nil];
    }
}

- (void)changeToGeneratedFileAtPath:(NSString *)path
{
    NSDirectoryEnumerator *enumerator = [self directoryEnumeratorForPath:path];
    
    for (NSURL *fileURL in enumerator)
    {
        NSString *filename;
        [fileURL getResourceValue:&filename forKey:NSURLNameKey error:nil];
        
        NSNumber *isDirectory;
        [fileURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
        
        if ([isDirectory boolValue] && [[[fileURL pathComponents] lastObject] isEqualToString:@"Generated"])
        {
            NSArray *dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[fileURL path] error:NULL];
            
            for (NSString *components in dirs)
            {
                NSString *generatedFilePath = [[fileURL path] stringByAppendingPathComponent:components];
                NSString *contentOfGeneratedFile = [NSString stringWithContentsOfFile:generatedFilePath encoding:NSUTF8StringEncoding error:nil];
                NSArray *pathComponents = [generatedFilePath pathComponents];
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", [NSString pathWithComponents:[pathComponents subarrayWithRange:NSMakeRange(0, [pathComponents count] - 2)]], [pathComponents lastObject]];
                [contentOfGeneratedFile writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }
        }
    }
}

- (NSDirectoryEnumerator *)directoryEnumeratorForPath:(NSString *)path
{
    NSDirectoryEnumerator *enumerator = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* stringURL = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *pathUrl = [NSURL URLWithString:stringURL];
    
    if (pathUrl != nil)
    {
        enumerator = [fileManager enumeratorAtURL:pathUrl
                                              includingPropertiesForKeys:@[NSURLNameKey, NSURLIsDirectoryKey]
                                                                 options:NSDirectoryEnumerationSkipsHiddenFiles
                                                            errorHandler:^BOOL (NSURL *url, NSError *error)
                                                            {
                                                                if (error)
                                                                {
                                                                    NSLog(@"[Error] %@ (%@)", error, url);
                                                                    
                                                                    return NO;
                                                                }
                                                                 
                                                                return YES;
                                                            }];
    }
    
    return enumerator;
}

@end
