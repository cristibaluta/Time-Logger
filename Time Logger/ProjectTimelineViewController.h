//
//  ProjectTimelineViewController.h
//  Time Logger
//
//  Created by Baluta Cristian on 29/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TimelineCell.h"
#import "TimeLog.h"
#import "App.h"

@interface ProjectTimelineViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate> {
	
	NSArray *logs;
}

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) IBOutlet NSTableView *appsTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil managedObjectContext:(NSManagedObjectContext *) managedContext managedObjectModel:(NSManagedObjectModel *) managedModel;
- (void)fetch;

@end
