//
//  ProjectConfigViewController.h
//  Time Logger
//
//  Created by Baluta Cristian on 29/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

// When you chose a project you're presented with this screen.
// You can add here the apps that are used by the project
// and the names of the documents of those apps

#import <Cocoa/Cocoa.h>

@interface ProjectConfigViewController : NSViewController

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil managedObjectContext:(NSManagedObjectContext *) managedContext managedObjectModel:(NSManagedObjectModel *) managedModel;

@end
