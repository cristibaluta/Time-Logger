//
//  ProjectConfigViewController.m
//  Time Logger
//
//  Created by Baluta Cristian on 29/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import "ProjectConfigViewController.h"
#import "Project.h"

@implementation ProjectConfigViewController

@synthesize managedObjectModel;
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil managedObjectContext:(NSManagedObjectContext *) managedContext managedObjectModel:(NSManagedObjectModel *) managedModel
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
		self.managedObjectContext = managedContext;
		self.managedObjectModel = managedModel;
		
	}
    return self;
}

- (void)loadView {
    [super loadView];
	
	runningApplications = [[NSWorkspace sharedWorkspace] runningApplications];
	
}




#pragma mark TableViewDatasource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	
	return runningApplications.count;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {

	//RCLog(@"populate row %li %@", rowIndex, [aTableColumn identifier]);

	NSRunningApplication *app = [runningApplications objectAtIndex:rowIndex];

	// icon
	// localizedName
	// bundleIdentifier

	if ([[aTableColumn identifier] isEqualToString:@"icon"]) {
        return app.icon;
    }
	if ([[aTableColumn identifier] isEqualToString:@"name"]) {
        return app.localizedName;
    }
	if ([[aTableColumn identifier] isEqualToString:@"identifier"]) {
        return app.bundleIdentifier;
    }

    return nil;
}



#pragma mark save data

- (void)save {
	
	NSManagedObjectContext *context = self.managedObjectContext;
	Project *project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:context];
	project.category = [NSNumber numberWithInt:0];
	project.date_created = [NSDate date];
	project.name = @"";
	project.project_id = @"";
	project.tracking = [NSNumber numberWithBool:YES];
	project.client_id = @"";
	project.descr = self.textDescription.stringValue;
	project.apps = @[];
	
	NSError *error;
	if (![context save:&error]) {
		RCLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
	}
	
	// Read the database
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
	for (NSManagedObject *info in fetchedObjects) {
		RCLog(@"app_identifier: %@", [info valueForKey:@"app_identifier"]);
		RCLog(@"start_time: %@", [info valueForKey:@"start_time"]);
		RCLog(@"end_time: %@", [info valueForKey:@"end_time"]);
	}
	//	RCLog(@"FIN TESTING \n");
}

@end
