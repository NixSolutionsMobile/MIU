//
//  MIUResultDataSource.m
//  AppMIU
//
//  Created by Ovcharuk on 10/28/16.
//  Copyright © 2016 NIX. All rights reserved.
//

#import "MIUResultDataSource.h"
#import "MIUClassStatistics.h"
#import "MIUMethod.h"

typedef NS_ENUM(NSInteger, PathState)
{
    PathStateSuccess,
    PathStateWarnings
};

@interface MIUResultDataSource ()

@property(strong, nonatomic) NSTableView *tableView;
@property(assign, nonatomic) NSInteger successState;
@property(assign, nonatomic) NSInteger warningsState;
@property(strong, readonly, nonatomic) NSDictionary *dictionary;
@property(strong, nonatomic) NSArray *resultStates;
@property(copy, nonatomic) NSArray *resultStatisticsWithStates;

@end

@implementation MIUResultDataSource

- (instancetype)initWithTableView:(NSTableView *)tableView
{
    self = [super init];
    
    if (self)
    {
        [self setSuccessState:1];
        [self setWarningsState:1];
        [self setTableView:tableView];
        
        _dictionary = @{@(MIUMethodStateTheSame) : @"not_changed_icon.png",
                        @(MIUMethodStateGenerated) : @"first_generation_icon.png",
                        @(MIUMethodStateRegenerated) : @"regenerated_icon.png",
                        @(MIUMethodStateSupportedByUser) : @"supported_by_user.png",
                        @(MIUMethodStateGeneratedWithWarnings) : @"generate_with_warnings_icon.png"};
    }
    
    return self;
}

- (void)setResultStatistics:(NSArray *)resultStatistics
{
    _resultStatistics = resultStatistics;
    
    [self setupResultStates];
    [self setResultStatisticsWithStates:resultStatistics];
    [[self tableView] reloadData];
}

- (void)setResultStatisticsWithStates:(NSArray *)resultStatisticsWithStates
{
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"generatingClass.name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    _resultStatisticsWithStates = [resultStatisticsWithStates sortedArrayUsingDescriptors:@[sort]];
    
    [[self tableView] reloadData];
}

- (void)setupResultStates
{
    NSMutableArray *resultStates = [[NSMutableArray alloc] init];
    
    for (MIUClassStatistics *statictics in [self resultStatistics])
    {
        NSInteger state = PathStateSuccess;
        
        for (MIUMethodStatistics *methodStatictics in [statictics methodsStatistic])
        {
            if ([methodStatictics state] == MIUMethodStateGeneratedWithWarnings)
            {
                state = PathStateWarnings;
                break;
            }
        }
        
        [resultStates addObject:@(state)];
    }
    
    [self setResultStates:resultStates];
}

#pragma mark - NSTableViewDelegate & NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [[self resultStatisticsWithStates] count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *stringValue = @"";
    NSImage *image = nil;
    MIUClassStatistics *statistics = [[self resultStatisticsWithStates] objectAtIndex:row];
    NSString *tableCellIdentifier = @"";
    
    if ([[tableColumn identifier] isEqualToString:@"Class"])
    {
        tableCellIdentifier = @"ClassCellID";
        stringValue = [[statistics generatingClass] name];
        image = nil;
    }
    else
    {
        tableCellIdentifier = @"ResultCellID";
        stringValue = @"";
        image = [self imageForColumnName:[tableColumn title] inStatistics:statistics];
    }

    NSTableCellView *tableCellView = [tableView makeViewWithIdentifier:tableCellIdentifier owner:nil];
    [[tableCellView textField] setStringValue:stringValue];
    [tableCellView setWantsLayer:YES];

    if ([statistics isClassNeedUpdate])
    {
        [tableCellView.layer setBackgroundColor:[[NSColor miuWarningColor] CGColor]];
    }
    else
    {
        [tableCellView.layer setBackgroundColor:[[NSColor clearColor] CGColor]];
    }
    
    [[tableCellView imageView] setImage:image];
    return tableCellView;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 20.f;
}

#pragma mark -

- (NSImage *)imageForColumnName:(NSString *)methodName inStatistics:(MIUClassStatistics *)statistics
{
    for (MIUMethodStatistics *methodStatistics in [statistics methodsStatistic])
    {
        if ([[[methodStatistics method] name] isEqualToString:methodName])
        {
            NSInteger methodState = [methodStatistics state];
            NSString *imageName = [[self dictionary] objectForKey:@(methodState)];

            return [NSImage imageNamed:imageName];
        }
    }
    
    return nil;
}

- (void)displayResultsWithSuccessState:(ResultType)resultType
{
    NSMutableArray *mutableStatesAllResult = [NSMutableArray array];
    NSMutableArray *mutableStatesWarningsResult = [NSMutableArray array];
    NSMutableArray *mutableStatesSuccessResult = [NSMutableArray array];

    for (NSInteger index = 0; index < [[self resultStatistics] count]; index++)
    {
        NSInteger currentState = [[[self resultStates] objectAtIndex:index] integerValue];
        [mutableStatesAllResult addObject:[[self resultStatistics] objectAtIndex:index]];

        if (currentState == PathStateSuccess)
        {
            [mutableStatesSuccessResult addObject:[[self resultStatistics] objectAtIndex:index]];
        }
        else
        {
            if (currentState == PathStateWarnings)
            {
                [mutableStatesWarningsResult addObject:[[self resultStatistics] objectAtIndex:index]];
            }
        }
    }
    
    switch (resultType)
    {
        case Warnings:
            
            [self setResultStatisticsWithStates:mutableStatesWarningsResult];
            break;
        case Success:
            
            [self setResultStatisticsWithStates:mutableStatesSuccessResult];
            break;
        default:
            
            [self setResultStatisticsWithStates:mutableStatesAllResult];
            break;
    }
}

@end
