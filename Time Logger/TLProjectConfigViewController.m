//
//  ProjectConfigViewController.m
//  Time Logger
//
//  Created by Baluta Cristian on 29/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import "TLProjectConfigViewController.h"
#import "Project.h"
#import "Client.h"

@implementation TLProjectConfigViewController

@synthesize managedObjectModel;
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil
			   bundle:(NSBundle *)nibBundleOrNil
 managedObjectContext:(NSManagedObjectContext *)managedContext
   managedObjectModel:(NSManagedObjectModel *)managedModel
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
	
	Client *client = nil;
	Project *project = nil;
	
	// Check if the client email already exists
	NSError *error;
	NSFetchRequest *clientRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *clientEntity = [NSEntityDescription entityForName:@"Client" inManagedObjectContext:self.managedObjectContext];
	[clientRequest setEntity:clientEntity];
	NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:clientRequest error:&error];
	for (Client *c in fetchedObjects) {
		RCLogO(c);
		if ([c.email isEqualToString:self.textClientEmail.stringValue]) {
			client = c;
		}
	}
	
	
	// Check if the project already exists
	project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:self.managedObjectContext];
	project.category = [NSNumber numberWithInt:0];
	project.dateCreated = [NSDate date];
	project.name = self.textDescription.stringValue;
	project.projectId = @"";
	project.tracking = [NSNumber numberWithBool:YES];
	project.clientId = @"";
	project.projectDescription = self.textDescription.stringValue;
	project.apps = [[NSSet alloc] init];
	
	if (![self.managedObjectContext save:&error]) {
		RCLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
	}
	
	// Read the database
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	for (NSManagedObject *info in fetchedObjects) {
		RCLog(@"app_identifier: %@", [info valueForKey:@"app_identifier"]);
		RCLog(@"start_time: %@", [info valueForKey:@"start_time"]);
		RCLog(@"end_time: %@", [info valueForKey:@"end_time"]);
	}
	//	RCLog(@"FIN TESTING \n");
}

@end
