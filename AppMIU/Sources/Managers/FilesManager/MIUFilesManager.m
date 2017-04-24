//
//  MIUFilesManager.m
//  MIU
//
//  Created by ovcharuk on 11/28/16.
//  Copyright © 2016 NIX. All rights reserved.
//

#import "MIUFilesManager.h"

static NSString *const WorkspaceFileName = @"xcworkspace";
static NSString *const ProjectFileName = @"xcodeproj";
static NSString *const PodsFileName = @"Pods";

@interface MIUFilesManager ()

@end

@implementation MIUFilesManager

+ (instancetype)sharedManager
{
    static MIUFilesManager *filesManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        filesManager = [[MIUFilesManager alloc] init];
    });
    
    return filesManager;
}

- (NSString *)projectNameFromRootFolder:(NSString *)rootFolder
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *urlString = [rootFolder stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSURL *directoryURL = [NSURL URLWithString:urlString];
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtURL:directoryURL includingPropertiesForKeys:keys options:0 errorHandler:^(NSURL *url, NSError *error)
    {
        return YES;
    }];
    
    return [self projectNameFromDirectoryEnumerator:enumerator];
}

- (NSString *)projectNameFromDirectoryEnumerator:(NSDirectoryEnumerator *)enumerator
{
    for (NSURL *url in enumerator)
    {
        NSString *fileName = [[url lastPathComponent] stringByDeletingPathExtension];
        NSString *fileExtension = [url pathExtension];
        
        if ([fileName isEqualToString:PodsFileName])
        {
            continue;
        }
        
        if ([fileExtension isEqualToString:WorkspaceFileName])
        {
            return fileName;
        }
        else
        {
            if ([fileExtension isEqualToString:ProjectFileName])
            {
                return fileName;
            }
        }
    }

    return @"";
}

@end
