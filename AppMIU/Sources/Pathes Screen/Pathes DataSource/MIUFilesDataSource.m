//
//  MIUTableViewPathesDataSource.m
//  AppMIU
//
//  Created by Ovcharuk on 10/28/16.
//  Copyright © 2016 NIX. All rights reserved.
//

#import "MIUFilesDataSource.h"
#import "MIUProjectsManager.h"

@interface MIUFilesDataSource ()

@property(strong, nonatomic) NSTableView *tableView;

@end

@implementation MIUFilesDataSource

- (instancetype)initWithTableView:(NSTableView *)tableView
{
    self = [super init];
    
    if (self)
    {
        [self setTableView:tableView];
    }
    
    return self;
}

- (void)setPathesArray:(NSArray *)pathesArray
{
    _pathesArray = pathesArray;
    
    [[self tableView] reloadData];
}

#pragma mark - NSTableViewDelegate & NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [[self pathesArray] count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *tableCellView = [tableView makeViewWithIdentifier:@"CellID" owner:nil];
    NSString *stringValue = [[self pathesArray] objectAtIndex:row];
    [[tableCellView textField] setStringValue:stringValue];
    return tableCellView;
}

@end
