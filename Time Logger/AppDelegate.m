//
//  AppDelegate.m
//  Time Logger
//
//  Created by Baluta Cristian on 25/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDbInitialization.h"

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
	projectsList.delegate = self;
	// Add the projects sidebar in the left view of the splitview
	[self.splitView replaceSubview:[[self.splitView subviews] objectAtIndex:0] with:projectsList.view];
	
	
	projectConfig = [[ProjectConfigViewController alloc] initWithNibName:@"ProjectConfigViewController"
																  bundle:[NSBundle mainBundle]
													managedObjectContext:self.managedObjectContext
													  managedObjectModel:self.managedObjectModel];
	
	projectTimeline = [[ProjectTimelineViewController alloc] initWithNibName:@"ProjectTimelineViewController"
																	  bundle:[NSBundle mainBundle]
														managedObjectContext:self.managedObjectContext
														  managedObjectModel:self.managedObjectModel];

	
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
//		RCLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
//	}
	
	// Read the database
//	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//	NSEntityDescription *entity = [NSEntityDescription entityForName:@"TimeLog" inManagedObjectContext:context];
//	[fetchRequest setEntity:entity];
//	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//	for (NSManagedObject *info in fetchedObjects) {
//		RCLog(@"app_identifier: %@", [info valueForKey:@"app_identifier"]);
//		RCLog(@"start_time: %@", [info valueForKey:@"start_time"]);
//		RCLog(@"end_time: %@", [info valueForKey:@"end_time"]);
//	}
//	RCLog(@"FIN TESTING \n");
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
	//pid_t pid = app.processIdentifier;
	NSString *document_name = @"";
	NSString *script;
	NSString *browsers = @"com.apple.Safari,org.mozilla.firefox,com.google.Chrome,com.operasoftware.Opera";
	if ([browsers rangeOfString:app.bundleIdentifier].location != NSNotFound)
	{
		script = @"GetBrowserUrl";
	}
	else {
		script = @"GetAppWindowName";
	}
	
	NSDictionary *derr = nil;
	NSError *err;
	NSURL *url = [[NSBundle mainBundle] URLForResource:script withExtension:@"txt"];
	NSString *scrpt = [NSString stringWithContentsOfURL:url encoding:NSStringEncodingConversionAllowLossy error:&err];
	scrpt = [scrpt stringByReplacingOccurrencesOfString:@"app_identifier" withString:app.bundleIdentifier];
	NSAppleScript *ascr = [[NSAppleScript alloc] initWithSource:scrpt];
	NSAppleEventDescriptor *descriptor = [ascr executeAndReturnError:&derr];
	
	if (derr != nil) {
		RCLog(@"err2: %@", derr);
	}
	else {
		//RCLog(@"good2: %@", descriptor);
		document_name = [descriptor stringValue];
	}
	
	[dispatcher logApp:app windowName:document_name];
	
	//RCLog(@"Active application is: %@ %i", activeApp, pid);
	
	
//	CFArrayRef windowList = CGWindowListCopyWindowInfo(kCGWindowListOptionAll, kCGNullWindowID);
//	for (NSMutableDictionary* entry in (__bridge NSArray*)windowList)
//	{
//		NSString* winName = [entry objectForKey:(id)kCGWindowName];
//		NSInteger ownerPID = [[entry objectForKey:(id)kCGWindowOwnerPID] integerValue];
//		RCLog(@"%@ %li", winName, (long)ownerPID);
//		
//		if (ownerPID == pid) {
//			RCLog(@"-----------------------FOUND");
//		}
//	}
//	CFRelease(windowList);
	
}


#pragma mark AppDispatcher delegate

- (void) didStartTrackingApp:(NSRunningApplication*)app {
	
	RCLog(@"start tracking %@", app.localizedName);
	lastDate = [NSDate date];
	[projectTimeline fetch];
}

- (void) didStopTrackingApp:(NSRunningApplication*)app windowName:(NSString*)name {
	
	RCLog(@"stop tracking and log %@ %@", app.localizedName, app.bundleIdentifier);
	NSError *error;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSManagedObjectContext *context = [self managedObjectContext];
	
	// Store in the database this app and its running time
	
	TimeLog *timelog = [NSEntityDescription insertNewObjectForEntityForName:@"TimeLog" inManagedObjectContext:[self managedObjectContext]];
	timelog.app_identifier = app.bundleIdentifier;
	timelog.caption = app.localizedName;
	timelog.end_time = [NSDate date];
	timelog.start_time = lastDate;
	timelog.document_name = name;
	
	// Get the project for this log
	
//	NSPredicate *projectPredicate = [NSPredicate predicateWithFormat:@"app_identifier == %@", app.bundleIdentifier];
//	[fetchRequest setPredicate:projectPredicate];
	NSEntityDescription *projectEntity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:context];
	[fetchRequest setEntity:projectEntity];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	
	if (fetchedObjects.count > 0) {
		Project *p = fetchedObjects[0];
		NSNumber *oldTime = p.time_spent;
		p.time_spent = [NSNumber numberWithLongLong:[oldTime longLongValue] + [lastDate timeIntervalSinceNow]];
	}

	
	// Insert the app in database if does not exist
	
	NSPredicate *todaysLogs = [NSPredicate predicateWithFormat:@"app_identifier == %@", app.bundleIdentifier];
	[fetchRequest setPredicate:todaysLogs];
	NSEntityDescription *a = [NSEntityDescription entityForName:@"App" inManagedObjectContext:[self managedObjectContext]];
	[fetchRequest setEntity:a];
	
	//NSUInteger nr = [context countForFetchRequest:fetchRequest error:&error];
	
//	if (nr == 0) {
//		RCLog(@"store app %@", app.bundleIdentifier);
//		App *aa = [NSEntityDescription insertNewObjectForEntityForName:@"App" inManagedObjectContext:context];
//		aa.app_identifier = app.bundleIdentifier;
//		aa.app_name = app.localizedName;
//		aa.icon = [app.icon TIFFRepresentation];
//	}
	
	
	if (![context save:&error]) {
		RCLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
	}
}

- (void) didBecomeIdle {
	
	
}



#pragma mark ProjectsSidebar delegate

- (void)projectDidSelect:(NSString*)project_id {
	
	[self.tabView selectTabViewItemAtIndex:2];
	
	projectConfig.textDescription.stringValue = @"Description here...";
}





- (NSURL *)applicationFilesDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.ralcr.Time_Logger"];
}

- (NSManagedObjectModel *)managedObjectModel {
	
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Time_Logger" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        RCLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"Time_Logger.storedata"];
	
	firstRun = ![url checkResourceIsReachableAndReturnError:&error];
	
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
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;
	
    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application
// (which is already bound to the persistent store coordinator for the application.)
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
	
	if (firstRun) {
		
		// After you created the database for the first time add some default values
		
		[AppDbInitialization addDefaultProjects:_managedObjectContext];
		[self saveAction:nil];
		
	}
	
    return _managedObjectContext;
}

// Returns the NSUndoManager for the application.
// In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window
{
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application,
// which is to send the save: message to the application's managed object context.
// Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender
{
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        RCLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
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
        RCLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
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

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"");
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
