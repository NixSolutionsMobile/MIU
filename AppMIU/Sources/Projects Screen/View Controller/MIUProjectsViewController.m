//
//  MIUProjectsViewController.m
//  AppMIU
//
//  Created by Ovcharuk on 11/4/16.
//  Copyright © 2016 NIX. All rights reserved.
//

#import "MIUProjectsViewController.h"
#import "MIUPathesViewController.h"
#import "MIUProjectsManager.h"
#import "MIUNewProjectViewController.h"
#import "MIUProjectTableViewCell.h"
#import "MIUProjectModel.h"

static CGFloat const RowHeight = 44.f;

@interface MIUProjectsViewController ()<NSTableViewDelegate, NSTableViewDataSource, MIUNewProjectViewControllerDelegate, MIUPathesViewControllerDelegate, MIUProjectTableViewCellDelegate>

@property(nonatomic, weak) IBOutlet NSTableView *tableViewProjects;
@property(nonatomic, weak) IBOutlet NSSearchField *searchTextField;
@property(nonatomic, strong) NSArray<MIUProjectModel *> *projectsArray;
@property(nonatomic, strong) NSMutableDictionary<NSString *, id> *projectWindows;
@property(nonatomic, strong) NSArrayController *projectsArrayController;
@property(nonatomic, strong) NSMutableArray *projectsRootFolders;

@end

@implementation MIUProjectsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupView];
}

- (void)setupView
{
    [self setupTableViewContextMenu];
    [self setProjectWindows:[NSMutableDictionary dictionary]];
    [self setProjectsArrayController:[[NSArrayController alloc] init]];
    [self setProjectsRootFolders:[NSMutableArray new]];
    [[self view] setWantsLayer:YES];
    [[[self view] layer] setBackgroundColor:[[NSColor controlColor] CGColor]];
}

- (void)viewWillAppear
{
    [super viewWillAppear];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addNewProject:)
                                                 name:@"DidClickAddNewProject"
                                               object:nil];
    
    [self reloadProjects];
}

- (void)viewWillDisappear
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Right click menu
- (void)setupTableViewContextMenu
{
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@"Context menu"];
    [menu addItemWithTitle:NSLocalizedString(@"context_menu.open", nil) action:@selector(menuOpenTapped:) keyEquivalent:@""];
    [menu addItemWithTitle:NSLocalizedString(@"context_menu.rename", nil) action:@selector(menuRenameTapped:) keyEquivalent:@""];
    [menu addItemWithTitle:NSLocalizedString(@"context_menu.remove", nil) action:@selector(menuRemoveTapped:) keyEquivalent:@""];
    
    [[self tableViewProjects] setMenu:menu];
}

- (void)menuOpenTapped:(NSMenuItem *)item
{
    [self openProject];
}

- (void)menuRenameTapped:(NSMenuItem *)item
{
    [self editProject];
}

- (void)menuRemoveTapped:(NSMenuItem *)item
{
    NSInteger projectSelectedIndex = [[self tableViewProjects] clickedRow];
    
    if (projectSelectedIndex != -1)
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:NSLocalizedString(@"alert.deleting_project.confirm_button.title", nil)];
        [alert addButtonWithTitle:NSLocalizedString(@"alert.deleting_project.cancel_button.title", nil)];
        [alert setIcon:[NSImage imageNamed:@"icon.png"]];
        [alert setInformativeText:NSLocalizedString(@"alert.deleting_project.title", nil)];
        [alert setMessageText:NSLocalizedString(@"alert.deleting_project.description", nil)];
        
        if ([alert runModal] == NSAlertFirstButtonReturn)
        {
            [self deleteProjectAtIndex:projectSelectedIndex];
        }
    }
}

#pragma mark - Work with projects

- (void)openProject
{
    NSInteger projectSelectedIndex = [[self tableViewProjects] clickedRow];
    
    if (projectSelectedIndex != -1)
    {
        NSStoryboard *mainStoryboard = [NSStoryboard storyboardWithName:@"Pathes" bundle:nil];
        MIUPathesViewController *viewController = [mainStoryboard instantiateControllerWithIdentifier:@"PathesViewController"];
        MIUProjectModel *selectedProject = [[[self projectsArrayController] arrangedObjects] objectAtIndex:projectSelectedIndex];
        [viewController setCurrentProject:selectedProject];
        [viewController setDelegate:self];
        
        NSWindowController *windowController = [mainStoryboard instantiateControllerWithIdentifier:@"PathesWindowController"];
        [windowController setContentViewController:viewController];
        [[windowController window] setDelegate:viewController];
        
        [[self projectWindows] setObject:windowController forKey:[selectedProject projectID]];
        [windowController showWindow:self];
    }
}

- (void)editProject
{
    NSInteger projectSelectedIndex = [[self tableViewProjects] clickedRow];
    
    if (projectSelectedIndex != -1)
    {
        MIUProjectTableViewCell *cell = [[self tableViewProjects] viewAtColumn:0 row:projectSelectedIndex makeIfNecessary:NO];
        [cell startEditingProjectName];
    }
}

- (void)deleteProjectAtIndex:(NSInteger)index
{
    MIUProjectModel *selectedProject = [[[self projectsArrayController] arrangedObjects] objectAtIndex:index];
    MIUProjectsManager *manager = [MIUProjectsManager sharedManager];
    [manager deleteProject:selectedProject];
    
    if ([[self projectsRootFolders] containsObject:[selectedProject rootFolder]])
    {
        [[self projectsRootFolders] removeObject:[selectedProject rootFolder]];
    }
    
    [[self projectWindows] removeObjectForKey:[selectedProject projectID]];
    [self reloadProjects];
}

- (void)addNewProject:(NSNotification *)notification
{
    NSStoryboard *mainStoryboard = [NSStoryboard storyboardWithName:@"NewProject" bundle:nil];
    MIUNewProjectViewController *viewController = [mainStoryboard instantiateControllerWithIdentifier:@"NewProjectViewController"];
    [viewController setDelegate:self];

    if ([[self projectsRootFolders] containsObject:[[[notification userInfo] objectForKey:@"files"] firstObject]])
    {
        [self showAlertRootFolderWithPath:[[[notification userInfo] objectForKey:@"files"] firstObject]];
    }
    else
    {
        [viewController setRootFolder:[[[notification userInfo] objectForKey:@"files"] firstObject]];
        [self presentViewControllerAsSheet:viewController];
    }
}

- (void)showAlertRootFolderWithPath:(NSString *)path
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:[NSString stringWithFormat:NSLocalizedString(@"alert.adding_exist_path %@", nil), path]];
    [alert setInformativeText:@""];
    [alert setIcon:[NSImage imageNamed:@"icon"]];
    [alert runModal];
}

#pragma mark - IBActions
- (IBAction)buttonAddNewProjectDidTap:(id)sender
{
    [self addNewProject:nil];
}

- (IBAction)doubleClickRow:(id)sender
{
    [self openProject];
}

#pragma mark - NSTableViewDelegate & NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [[[self projectsArrayController] arrangedObjects] count];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    MIUProjectTableViewCell *tableCellView = [tableView makeViewWithIdentifier:[tableColumn identifier] owner:nil];
    MIUProjectModel *project = [[[self projectsArrayController] arrangedObjects] objectAtIndex:row];
    [tableCellView setDelegate:self];
    [tableCellView configureCellWithModel:project];
    
    if (![[self projectsRootFolders] containsObject:[project rootFolder]])
    {
        [[self projectsRootFolders] addObject:[project rootFolder]];
    }
    
    [tableCellView selectCellOnRow:NO];
    return tableCellView;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    NSInteger selectedRow = [[self tableViewProjects] selectedRow];
    
    if (selectedRow >= 0)
    {
        MIUProjectTableViewCell *myRowView = (MIUProjectTableViewCell *)[[self tableViewProjects] viewAtColumn:0 row:selectedRow makeIfNecessary:NO];
        [myRowView selectCellOnRow:NO];
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return RowHeight;
}

#pragma mark - MIUNewProjectViewControllerDelegate

- (void)reloadProjects
{
    MIUProjectsManager *manager = [MIUProjectsManager sharedManager];
    [self setProjectsArray:[manager projects]];
    [[self projectsArrayController] setContent:[manager projects]];
    [[self tableViewProjects] reloadData];
}

#pragma mark - MIUPathesViewControllerDelegate

- (void)closeProject:(MIUProjectModel *)project
{
    [[self projectWindows] removeObjectForKey:[project projectID]];
}

#pragma mark - MIUProjectTableViewCellDelegate

- (void)didChangeProject:(MIUProjectModel *)project
{
    MIUProjectsManager *manager = [MIUProjectsManager sharedManager];
    [manager replaceProject:project];
}

#pragma mark - Filtering

- (void)controlTextDidChange:(NSNotification *)obj
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"projectName CONTAINS[cd] %@", [[self searchTextField] stringValue]];
    NSInteger searchTextLenght = [[[self searchTextField] stringValue] length];
    
    if (searchTextLenght > 0)
    {
        [[self projectsArrayController] setFilterPredicate:predicate];
    }
    else
    {
        [[self projectsArrayController] setFilterPredicate:nil];
    }
    
    [[self tableViewProjects] reloadData];
}

@end
