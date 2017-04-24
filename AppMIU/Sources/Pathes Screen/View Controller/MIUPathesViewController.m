//
//  ViewController.m
//  AppMIU
//
//  Created by Ovcharuk on 10/28/16.
//  Copyright © 2016 NIX. All rights reserved.
//

#import "MIUPathesViewController.h"
#import "MIUFilesScanner.h"
#import "MIUFileGenerator.h"
#import "MIUFileAnalyzer.h"
#import "MIUClassStatistics.h"
#import "MIUFilesDataSource.h"
#import "MIUResultDataSource.h"
#import "MIUProjectsManager.h"
#import <Foundation/NSFileManager.h>

#import "NSColor+MIUColor.h"

@interface MIUPathesViewController ()

@property(weak, nonatomic) IBOutlet NSTableView *tableViewPathes;
@property(weak, nonatomic) IBOutlet NSTableView *tableViewResult;
@property(weak, nonatomic) IBOutlet NSProgressIndicator *progressIndicator;
@property(strong, nonatomic) MIUFilesDataSource *filesDataSource;
@property(strong, nonatomic) MIUResultDataSource *resultDataSource;
@property(weak) IBOutlet NSSegmentedControl *resultTypeSegment;
@property(weak) IBOutlet NSButtonCell *runButton;

@end

@implementation MIUPathesViewController

#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self runButton] setBackgroundColor:[NSColor miuColor]];
    [self setupDataSources];
}

- (void)viewDidAppear
{
    [super viewDidAppear];
    
    [self setupWindowTitle];
    [self reloadPathes];
    [[self progressIndicator] stopAnimation:nil];
}

- (void)setupWindowTitle
{
    NSString *projectName = [[self currentProject] projectName];
    [[[self view] window] setTitle:projectName];
}

#pragma mark - NSWindowDelegate

- (BOOL)windowShouldClose:(id)sender
{
    [[self delegate] closeProject:[self currentProject]];
    
    return YES;
}

#pragma mark - Setup datasources

- (void)setupDataSources
{
    [self setupPathesDataSource];
    [self setupResultDataSource];
}

- (void)setupPathesDataSource
{
    MIUFilesDataSource *filesDataSource = [[MIUFilesDataSource alloc] initWithTableView:[self tableViewPathes]];
    [[self tableViewPathes] setDelegate:filesDataSource];
    [[self tableViewPathes] setDataSource:filesDataSource];
    [self setFilesDataSource:filesDataSource];
}

- (void)setupResultDataSource
{
    MIUResultDataSource *resultDataSource = [[MIUResultDataSource alloc] initWithTableView:[self tableViewResult]];
    [[self tableViewResult] setDelegate:resultDataSource];
    [[self tableViewResult] setDataSource:resultDataSource];
    [self setResultDataSource:resultDataSource];
}

#pragma mark -
- (IBAction)segmentPathsClick:(NSSegmentedControl *)sender
{
    if (sender.selectedSegment == 0)
    {
        [self buttonAddPathsClick];
    }
    else if (sender.selectedSegment == 1)
    {
        [self buttonDeletePathsClick];
    }
}

- (void)buttonAddPathsClick
{
    NSOpenPanel *openDialog = [self openDialog];

    if ([openDialog runModal] == NSModalResponseOK)
    {
        NSArray *urls = [openDialog URLs];
        MIUProjectsManager *manager = [MIUProjectsManager sharedManager];
        
        for (NSURL *url in urls)
        {
            [manager addPath:[url relativePath] toProject:[self currentProject]];
        }
        
        NSArray *pathes = [manager pathesInProject:[self currentProject]];
        [[self filesDataSource] setPathesArray:pathes];
    }
}

- (NSOpenPanel *)openDialog
{
    NSOpenPanel *openDialog = [NSOpenPanel openPanel];
    [openDialog setCanChooseFiles:YES];
    [openDialog setAllowsMultipleSelection:YES];
    [openDialog setCanChooseDirectories:YES];
    [openDialog setDirectoryURL:[NSURL URLWithString:[[self currentProject] rootFolder]]];
    
    return openDialog;
}

- (void)buttonDeletePathsClick
{
    MIUProjectsManager *manager = [MIUProjectsManager sharedManager];
    
    NSIndexSet *indexSet = [[self tableViewPathes] selectedRowIndexes];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *_Nonnull stop)
    {
        NSString *pathForDeleting = [[[self filesDataSource] pathesArray] objectAtIndex:idx];
        [manager deletePath:pathForDeleting inProject:[self currentProject]];
    }];
    
    [self reloadPathes];
}

- (IBAction)buttonPrepareUtilityClick:(id)sender
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[self currentProject] rootFolder]])
    {
        [self showAlertRootFolder];
        
        return;
    }
    
    [[self progressIndicator] startAnimation:sender];
    NSMutableSet *filesPathes = [NSMutableSet set];
    MIUFilesScanner *filesScanner = [[MIUFilesScanner alloc] init];
    
    for (NSString *path in [[self filesDataSource] pathesArray])
    {
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
        
        if (isExist)
        {
            NSSet *pathesSet = [filesScanner pathsForFilesFromFolderAtPath:path];
            filesPathes = [NSMutableSet setWithSet:[filesPathes setByAddingObjectsFromSet:pathesSet]];
        }
    }

    MIUFileGenerator *fileGenerator = [[MIUFileGenerator alloc] init];
    NSArray<MIUClassStatistics *> *statictics = [fileGenerator generateFilesFromFilesAtPaths:filesPathes withRootProjectPath:filesPathes];
    [[self resultDataSource] setResultStatistics:statictics];
    [self showStatisticsResult];
    
    [self updateClassStatistics:statictics];
    
    [filesScanner changeToGeneratedFileAtPath:[[self currentProject] rootFolder]];
    [filesScanner deleteGeneratedFoldersfromPath:[[self currentProject] rootFolder]];
    [[self progressIndicator] stopAnimation:sender];
}

- (void)updateClassStatistics:(NSArray<MIUClassStatistics *> *)statistics
{
    MIUProjectsManager *projectManager = [MIUProjectsManager sharedManager];
    NSArray<MIUClass *> *oldClasses = [projectManager getClassesForProject:[self currentProject]];
    
    for (MIUClass *class in oldClasses)
    {
        [projectManager deleteClass:[class name] inProject:[self currentProject]];
    }
    
    for (MIUClassStatistics *classStatictics in statistics)
    {
        MIUClass *class = [classStatictics generatingClass];
        [projectManager addClass:class toProject:[self currentProject]];
    }
}

- (IBAction)buttonAnalyzeClick:(id)sender
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[self currentProject] rootFolder]])
    {
        [self showAlertRootFolder];
        
        return;
    }
    
    [[self progressIndicator] startAnimation:sender];
    NSMutableSet *filesPathes = [NSMutableSet set];
    MIUFilesScanner *filesScanner = [[MIUFilesScanner alloc] init];
    
    for (NSString *path in [[self filesDataSource] pathesArray])
    {
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path];
        
        if (isExist)
        {
            NSSet *pathesSet = [filesScanner pathsForFilesFromFolderAtPath:path];
            filesPathes = [NSMutableSet setWithSet:[filesPathes setByAddingObjectsFromSet:pathesSet]];
        }
    }
    
    MIUFileAnalyzer *fileAnalyzer = [[MIUFileAnalyzer alloc] init];
    NSArray<MIUClassStatistics *> *statictics = [fileAnalyzer analyzeFilesFromFilesAtPaths:filesPathes withRootProjectPath:filesPathes inProject:[self currentProject]];
    [[self resultDataSource] setResultStatistics:statictics];
    [self showStatisticsResult];
    
    [filesScanner changeToGeneratedFileAtPath:[[self currentProject] rootFolder]];
    [filesScanner deleteGeneratedFoldersfromPath:[[self currentProject] rootFolder]];
    [[self progressIndicator] stopAnimation:sender];
}

- (void)showAlertRootFolder
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:NSLocalizedString(@"alert.showing_root_folder_doesnt_exist.title", nil)];
    [alert setInformativeText:NSLocalizedString(@"alert.showing_root_folder_doesnt_exist.description", nil)];
    [alert setIcon:[NSImage imageNamed:@"icon"]];
    [alert runModal];
}

- (IBAction)resultStateDidChange:(id)sender
{
    [self showStatisticsResult];
}

- (void)showStatisticsResult
{
    [[self resultDataSource] displayResultsWithSuccessState:(ResultType)[[self resultTypeSegment] selectedSegment]];
}

- (void)reloadPathes
{
    MIUProjectsManager *manager = [MIUProjectsManager sharedManager];
    NSArray *pathes = [manager pathesInProject:[self currentProject]];
    [[self filesDataSource] setPathesArray:pathes];
}

@end
