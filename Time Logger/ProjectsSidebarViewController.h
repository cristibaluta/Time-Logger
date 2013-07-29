//
//  ProjectsListViewController.h
//  Time Logger
//
//  Created by Baluta Cristian on 28/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

// A list of projects with the posibility to add and remove them
// Each project will have a checkmark to indicate if it's being tracked or not.

#import <Cocoa/Cocoa.h>

@interface ProjectsSidebarViewController : NSViewController

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
