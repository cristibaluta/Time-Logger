//
//  AppDelegate.h
//  Time Logger
//
//  Created by Baluta Cristian on 25/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDispatcher.h"
#import "ProjectsSidebarViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate, AppDispatcherDelegate> {
	
	NSArray *runningApplications;
	NSRunningApplication *activeApp;
	NSMutableDictionary *timeLogs;
	
	ProjectsSidebarViewController *projectsList;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *mainView;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) IBOutlet NSTableView *appsTable;


- (IBAction)saveAction:(id)sender;

@end
