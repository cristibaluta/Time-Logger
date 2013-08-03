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
	
	projectsList = [[ProjectsSidebarViewController alloc]
                        initWithNibName:@"ProjectsSidebarViewController"
                        bundle:[NSBundle mainBundle]
                        managedObjectContext:self.managedObjectContext
                        managedObjectModel:self.managedObjectModel];
	//projectsList.view.frame = CGRectMake(0, 0, 215, 660);
	
	// Add the projects sidebar in the left view of the splitview
	[[[self.splitView subviews] objectAtIndex:0] addSubview:projectsList.view];
	
	
	projectTimeline = [[ProjectTimelineViewController alloc] initWithNibName:@"ProjectTimelineViewController" bundle:[NSBundle mainBundle]];
	//projectTimeline.view.frame = ((NSView*)self.tabView.selectedTabViewItem.view).frame;
	projectTimeline.view.autoresizesSubviews = YES;
	[projectTimeline.view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	[self.tabView.selectedTabViewItem.view addSubview:projectTimeline.view];
	
	//[self.window visualizeConstraints:projectTimeline.view.constraints];
	
	// Create the dispatcher
	
	dispatcher = [[AppDispatcher alloc] init];
	dispatcher.delegate = self;
	
	// Start the timer
	
	//[self startTimerWithInterval:1.0];
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
	
	runningApplications = [[NSWorkspace sharedWorkspace] runningApplications];
	
	for (NSRunningApplication *app in runningApplications) {
		if ([app ownsMenuBar]) {
			NSLog(@"tick: %@", app.localizedName);
			[dispatcher logApp:app];
			break;
		}
	}
}


#pragma mark AppDispatcher delegate

- (void) didStartTrackingApp:(NSRunningApplication*)app {
	
	NSLog(@"start tracking %@", app.localizedName);
}
- (void) didStopTrackingApp:(NSRunningApplication*)app {
	
	NSLog(@"stop tracking %@", app.localizedName);
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
