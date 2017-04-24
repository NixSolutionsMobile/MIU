//
//  MIUDefaultsManager.m
//  AppMIU
//
//  Created by Ovcharuk on 11/4/16.
//  Copyright © 2016 NIX. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "MIUProjectsManager.h"
#import "MIUProjectModel.h"
#import "MIUClass.h"

@interface MIUProjectsManager ()
@property(strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation MIUProjectsManager

#pragma mark - Singleton Methods

+ (instancetype)sharedManager
{
    static MIUProjectsManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^
    {
        sharedManager = [[MIUProjectsManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - Projects

- (NSArray<MIUProjectModel *> *)projects
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Project"];
    NSError *error = nil;
    NSArray *task = [[self managedObjectContext] executeFetchRequest:request error:&error];
    NSMutableArray *mutableProjects = [NSMutableArray new];
    
    for (NSManagedObject *object in task)
    {
        [mutableProjects addObject:[self convertToProjectModel:object]];
    }
    
    return mutableProjects;
}

- (NSManagedObject *)convertFromProjectModel:(MIUProjectModel *)object
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Project"];
    NSError *error = nil;
    request.predicate = [NSPredicate predicateWithFormat:@"ANY id like %@",
                         object.projectID];
    NSArray *task = [[self managedObjectContext] executeFetchRequest:request error:&error];
    return [task lastObject];
}

- (MIUProjectModel *)convertToProjectModel:(NSManagedObject *)object
{
    MIUProjectModel *newModel = [[MIUProjectModel alloc] init];
    [newModel setProjectID:[object valueForKey:@"id"]];
    [newModel setProjectName:[object valueForKey:@"name"]];
    [newModel setRootFolder:[object valueForKey:@"rootPath"]];
    return newModel;
}

- (void)addProject:(MIUProjectModel *)project
{
    NSManagedObject *projectObject = [NSEntityDescription insertNewObjectForEntityForName:@"Project"
                                                                   inManagedObjectContext:self.managedObjectContext];
    [projectObject setValue:[NSString stringWithFormat:@"%@", [project projectName]] forKey:@"name"];
    [projectObject setValue:[NSString stringWithFormat:@"%@", [project rootFolder]]  forKey:@"rootPath"];
    [projectObject setValue:[NSString stringWithFormat:@"%@", [project projectID]] forKey:@"id"];
    NSError *error = nil;
    
    if (![[self managedObjectContext] save:&error])
    {
        NSAssert(NO, @"Error delete context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}

- (void)deleteProject:(MIUProjectModel *)project
{
    [self.managedObjectContext deleteObject:[self convertFromProjectModel:project]];
    
    NSError *error = nil;
    
    if (![[self managedObjectContext] save:&error])
    {
        NSAssert(NO, @"Error delete context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}

- (void)replaceProject:(MIUProjectModel *)project
{
    NSManagedObject *projectObject = [self convertFromProjectModel:project];
    [projectObject setValue:[NSString stringWithFormat:@"%@", [project projectName]] forKey:@"name"];
    NSError *error = nil;
    
    if (![[self managedObjectContext] save:&error])
    {
        NSAssert(NO, @"Error delete context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}

#pragma mark - Class

- (void)deleteClass:(NSString *)className inProject:(MIUProjectModel *)project
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Class"];
    NSError *error = nil;
    request.predicate = [NSPredicate predicateWithFormat:@"ANY project == %@", [self convertFromProjectModel:project]];
    NSArray *task = [[self managedObjectContext] executeFetchRequest:request error:&error];
    [self.managedObjectContext deleteObject:[task lastObject]];
    
    NSError *saveError = nil;
    
    if (![[self managedObjectContext] save:&saveError])
    {
        NSAssert(NO, @"Error delete context: %@\n%@", [saveError localizedDescription], [saveError userInfo]);
    }
}

- (NSArray *)getClassesForProject:(MIUProjectModel *)project
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Class"];
    NSError *error = nil;
    NSMutableArray *classes = [NSMutableArray new];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY project == %@",
                         [self convertFromProjectModel:project]];
    NSArray *task = [[self managedObjectContext] executeFetchRequest:request error:&error];
    
    for (int i = 0; i < [task count]; ++i)
    {
        NSManagedObject *managedObject = [task objectAtIndex:i];
        NSSet *properties = [NSKeyedUnarchiver unarchiveObjectWithData:[managedObject valueForKey:@"properties"]];
        MIUClass *class = [MIUClass new];
        [class setName:[managedObject valueForKey:@"name"]];
        [class setProperties:properties];
        [classes addObject:class];
    }
    
    return classes;
}

- (void)addClass:(MIUClass *)class toProject:(MIUProjectModel *)project
{
    NSManagedObject *classObject = [NSEntityDescription insertNewObjectForEntityForName:@"Class" inManagedObjectContext:[self managedObjectContext]];
    [classObject setValue:[self convertFromProjectModel:project] forKey:@"project"];
    [classObject setValue:[class name] forKey:@"name"];
    
    NSData *serializedProperties = [NSKeyedArchiver archivedDataWithRootObject:[class properties]];
    [classObject setValue:serializedProperties forKey:@"properties"];
    
    NSError *error = nil;
    
    if (![[self managedObjectContext] save:&error])
    {
        NSAssert(NO, @"Error delete context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}

#pragma mark - Pathes

- (NSArray<NSString *> *)pathesInProject:(MIUProjectModel *)project
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Path"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"project == %@", [self convertFromProjectModel:project]]];
    NSError *error = nil;
    NSArray<NSManagedObject *> *managedObjects = [[self managedObjectContext] executeFetchRequest:request error:&error];
    NSMutableArray<NSString *> *pathesArray = [NSMutableArray new];
    
    for (NSManagedObject *object in managedObjects)
    {
        [pathesArray addObject:[object valueForKey:@"path"]];
    }
    
    return pathesArray;
}

- (void)addPath:(NSString *)path toProject:(MIUProjectModel *)project
{
    NSManagedObject *pathObject = [NSEntityDescription insertNewObjectForEntityForName:@"Path" inManagedObjectContext:[self managedObjectContext]];
    [pathObject setValue:[self convertFromProjectModel:project] forKey:@"project"];
    [pathObject setValue:[NSString stringWithFormat:@"%@", path] forKey:@"path"];
    [pathObject setValue:[NSString stringWithFormat:@"%@", [[NSUUID UUID] UUIDString]] forKey:@"id"];
    
    NSError *error = nil;
    
    if (![[self managedObjectContext] save:&error])
    {
        NSAssert(NO, @"Error delete context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}

- (void)deletePath:(NSString *)path inProject:(MIUProjectModel *)project
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Path"];
    NSError *error = nil;
    request.predicate = [NSPredicate predicateWithFormat:@"ANY path like %@",
                         path];
    NSArray *task = [[self managedObjectContext] executeFetchRequest:request error:&error];
    [self.managedObjectContext deleteObject:[task lastObject]];
    
    NSError *saveError = nil;
    
    if (![[self managedObjectContext] save:&saveError])
    {
        NSAssert(NO, @"Error delete context: %@\n%@", [saveError localizedDescription], [saveError userInfo]);
    }
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (nil != _managedObjectModel)
        return _managedObjectModel;
    
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (nil != _persistentStoreCoordinator)
        return _persistentStoreCoordinator;
    
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"MIU"];
    NSError *errorFolder;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&errorFolder])
        {
            NSLog(@"Create directory error: %@", errorFolder);
        }
    }
    
    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory
                                                               inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"MIU/MIU.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (nil != _managedObjectContext)
        return _managedObjectContext;
    
    NSPersistentStoreCoordinator *store = self.persistentStoreCoordinator;
    
    if (nil != store)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:store];
    }
    
    return _managedObjectContext;
}

@end
