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
#import "PXSourceList.h"

@protocol TLProjectsSidebarDelegate <NSObject>

@required
- (void)projectDidSelect:(NSString*)project_id;

@end


@interface TLProjectsSidebarViewController : NSViewController <PXSourceListDataSource, PXSourceListDelegate> {
	
	IBOutlet PXSourceList *sourceList;
	NSMutableArray *sourceListItems;
}

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) id<TLProjectsSidebarDelegate> delegate;

- (id)initWithNibName:(NSString*)nibNameOrNil
			   bundle:(NSBundle*)nibBundleOrNil
 managedObjectContext:(NSManagedObjectContext*)managedContext
   managedObjectModel:(NSManagedObjectModel*)managedModel;

- (IBAction)addProject:(id)sender;
- (IBAction)deleteProject:(id)sender;

@end
