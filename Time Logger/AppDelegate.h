//
//  AppDelegate.h
//  Time Logger
//
//  Created by Baluta Cristian on 25/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDispatcher.h"
#import "TimeLog.h"
#import "ProjectsSidebarViewController.h"
#import "ProjectConfigViewController.h"
#import "ProjectTimelineViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, AppDispatcherDelegate> {
	
	NSArray *runningApplications;
	NSTimer *timer;
	AppDispatcher *dispatcher;
	NSDate *lastDate;
	
	ProjectsSidebarViewController *projectsList;
	ProjectConfigViewController *projectConfig;
	ProjectTimelineViewController *projectTimeline;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *mainView;
@property (assign) IBOutlet NSSplitView *splitView;
@property (assign) IBOutlet NSTabView *tabView;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
