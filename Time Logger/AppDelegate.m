//
//  AppDelegate.m
//  Time Logger
//
//  Created by Baluta Cristian on 25/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	
	self.window.backgroundColor = [NSColor colorWithDeviceWhite:0.94 alpha:1];
	
	// Add projects list
	
	projectsList = [[ProjectsSidebarViewController alloc] initWithNibName:@"ProjectsSidebarViewController"
																   bundle:[NSBundle mainBundle]
													 managedObjectContext:self.managedObjectContext
													   managedObjectModel:self.managedObjectModel];
	//projectsList.view.frame = CGRectMake(0, 0, 215, 660);
	
	// Add the projects sidebar in the left view of the splitview
	//[[[self.splitView subviews] objectAtIndex:0] setView:projectsList.view];
	[self.splitView replaceSubview:[[self.splitView subviews] objectAtIndex:0] with:projectsList.view];
	
	
	projectConfig = [[ProjectConfigViewController alloc] initWithNibName:@"ProjectConfigViewController"
																  bundle:[NSBundle mainBundle]
													managedObjectContext:self.managedObjectContext
													  managedObjectModel:self.managedObjectModel];
	//projectTimeline.view.frame = ((NSView*)self.tabView.selectedTabViewItem.view).frame;
	projectConfig.view.autoresizesSubviews = YES;
	[projectConfig.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	
	
	projectTimeline = [[ProjectTimelineViewController alloc] initWithNibName:@"ProjectTimelineViewController"
																	  bundle:[NSBundle mainBundle]
														managedObjectContext:self.managedObjectContext
														  managedObjectModel:self.managedObjectModel];
	//projectTimeline.view.frame = ((NSView*)self.tabView.selectedTabViewItem.view).frame;
	projectTimeline.view.autoresizesSubviews = YES;
	[projectTimeline.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	
	//[self.window visualizeConstraints:projectTimeline.view.constraints];
	
	NSTabViewItem *timelineTab = [self.tabView tabViewItemAtIndex:0];
	[timelineTab setView:projectTimeline.view];
	
	NSTabViewItem *graphTab = [self.tabView tabViewItemAtIndex:1];
	[graphTab setView:projectTimeline.view];
	
	NSTabViewItem *configTab = [self.tabView tabViewItemAtIndex:2];
	[configTab setView:projectConfig.view];
	
	// Create the dispatcher
	
	dispatcher = [[AppDispatcher alloc] init];
	dispatcher.delegate = self;
	
	// Start the timer
	
	//[self startTimerWithInterval:1.0];
	
	
	// Testing database
	
	NSManagedObjectContext *context = [self managedObjectContext];
//	TimeLog *timelog = [NSEntityDescription insertNewObjectForEntityForName:@"TimeLog" inManagedObjectContext:context];
//	timelog.app_identifier = @"Test app";
//	timelog.caption = @"Test  caption";
//	timelog.document_name = @"document name";
//	timelog.end_time = [NSDate date];
//	timelog.start_time = lastDate;
//	
	NSError *error;
//	if (![context save:&error]) {
//		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//	}
	
	// Read the database
//	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//	NSEntityDescription *entity = [NSEntityDescription entityForName:@"TimeLog" inManagedObjectContext:context];
//	[fetchRequest setEntity:entity];
//	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//	for (NSManagedObject *info in fetchedObjects) {
//		NSLog(@"app_identifier: %@", [info valueForKey:@"app_identifier"]);
//		NSLog(@"start_time: %@", [info valueForKey:@"start_time"]);
//		NSLog(@"end_time: %@", [info valueForKey:@"end_time"]);
//	}
//	NSLog(@"FIN TESTING \n");
}


#pragma mark Timer

- (void) startTimerWithInterval:(float)interval {
	
	[timer invalidate];
	
	timer = [NSTimer scheduledTimerWithTimeInterval:interval
											 target:self
										   selector:@selector(tick)
										   userInfo:nil
											repeats:YES];
}

- (void) tick {
	
	// Get the current app
	
	NSDictionary *activeApp = [[NSWorkspace sharedWorkspace] activeApplication];
	NSRunningApplication *app = activeApp[NSWorkspaceApplicationKey];
	pid_t pid = app.processIdentifier;
	[dispatcher logApp:app];
	
	//NSLog(@"Active application is: %@ %i", activeApp, pid);
	
	
//	CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionAll, kCGNullWindowID);
//	for (NSMutableDictionary* entry in (__bridge NSArray*)windowList)
//	{
//		NSString* winName = [entry objectForKey:(id)kCGWindowName];
//		NSInteger ownerPID = [[entry objectForKey:(id)kCGWindowOwnerPID] integerValue];
//		NSLog(@"%@ %li", winName, (long)ownerPID);
//		
//		if (ownerPID == pid) {
//			NSLog(@"-----------------------FOUND");
//		}
//	}
//	CFRelease(windowList);
	
	
//	NSError *err = nil;
	NSDictionary *derr = nil;
	NSURL* scriptURL = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"GetSafariUrl" ofType:@"scpt"]];
	NSAppleScript *ascr = [[NSAppleScript alloc] initWithContentsOfURL:scriptURL error:&derr];
	NSAppleEventDescriptor *res = [ascr executeAndReturnError:&derr];
	
	if (derr != nil) {
		NSLog(@"err: %@", derr);
	}
	else {
		NSLog(@"good: %@", res);
	}
}


#pragma mark AppDispatcher delegate

- (void) didStartTrackingApp:(NSRunningApplication*)app {
	
	NSLog(@"start tracking %@", app.localizedName);
	lastDate = [NSDate date];
	[projectTimeline fetch];
}
- (void) didStopTrackingApp:(NSRunningApplication*)app {
	
	NSLog(@"stop tracking %@", app.localizedName);
	
	// Store in the database this app and its running time
	
	NSManagedObjectContext *context = [self managedObjectContext];
	TimeLog *timelog = [NSEntityDescription insertNewObjectForEntityForName:@"TimeLog" inManagedObjectContext:context];
	timelog.app_identifier = app.bundleIdentifier;
	timelog.caption = app.localizedName;
	timelog.document_name = app.localizedName;
	timelog.end_time = [NSDate date];
	timelog.start_time = lastDate;
	
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
	}
}
- (void) didBecomeIdle {
	
	
}




// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "ralcr.com.Time_Logger" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.ralcr.Time_Logger"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Time_Logger" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"Time_Logger.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
    
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}




#pragma mark AppDelegates

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

- (void)applicationDidBecomeActive:(NSNotification *)aNotification {
	[self startTimerWithInterval:1.0];
}

- (void)applicationWillResignActive:(NSNotification *)aNotification {
	// We do not want to consume too much cpu when the app is not active. Make it 15sec
	[self startTimerWithInterval:3.0];
	[self tick];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    if (flag) {
        return NO;
    } else {
        [self.window orderFront:self];
        return YES;
    }
}

@end
