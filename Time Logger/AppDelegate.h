//
//  AppDelegate.h
//  Time Logger
//
//  Created by Baluta Cristian on 25/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TLAppDispatcher.h"
#import "App.h"
#import "TimeLog.h"
#import "Project.h"
#import "ProjectApp.h"
#import "TLProjectsSidebarViewController.h"
#import "TLProjectConfigViewController.h"
#import "TLProjectTimelineViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, TLAppDispatcherDelegate, TLProjectsSidebarDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *mainView;
@property (assign) IBOutlet NSSplitView *splitView;
@property (assign) IBOutlet NSTabView *tabView;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
