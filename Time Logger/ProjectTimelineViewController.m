//
//  ProjectTimelineViewController.m
//  Time Logger
//
//  Created by Baluta Cristian on 29/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import "ProjectTimelineViewController.h"


@implementation ProjectTimelineViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil managedObjectContext:(NSManagedObjectContext*)managedContext managedObjectModel:(NSManagedObjectModel*)managedModel {
    
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
	if (self) {
        // Initialization code here.
		self.managedObjectContext = managedContext;
        self.managedObjectModel = managedModel;
		[self fetch];
    }
    
    return self;
}

- (void)fetch {
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"TimeLog" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"end_time" ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByDate]];
	
	NSError *error;
	logs = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	
	[self.appsTable reloadData];
}



#pragma mark TableViewDatasource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	
	return logs.count;
}

//- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
//	
//	NSLog(@"populate row %li %@", rowIndex, [aTableColumn identifier]);
//	
//	NSRunningApplication *app = [runningApplications objectAtIndex:rowIndex];
//	
//	// icon
//	// localizedName
//	// bundleIdentifier
//	
//	if ([[aTableColumn identifier] isEqualToString:@"icon"]) {
//        return app.icon;
//    }
//	if ([[aTableColumn identifier] isEqualToString:@"name"]) {
//        return  app.localizedName;
//    }
//	if ([[aTableColumn identifier] isEqualToString:@"identifier"]) {
//        return app.bundleIdentifier;
//    }
//	if ([[aTableColumn identifier] isEqualToString:@"time"]) {
//		NSNumber *currentTime = [timeLogs objectForKey:app.bundleIdentifier];
//		if ([activeApp.bundleIdentifier isEqualTo:app.bundleIdentifier]) {
//			return [[currentTime description] stringByAppendingString:@"sec"];
//		}
//		else {
//			if (currentTime == nil) {
//				return @"";
//			}
//			else {
//				return [[currentTime description] stringByAppendingString:@"sec"];
//			}
//		}
//    }
//	else {
//		return [NSString stringWithFormat:@"%@ (%@)", app.localizedName, app.bundleIdentifier];
//	}
//	
//    return nil;
//}

-(NSView *) tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
				  row:(NSInteger)row {
	
	TimelineCell *result = [tableView makeViewWithIdentifier:@"TimelineCell" owner:self];
	
	if (result == nil) {
		result = [[TimelineCell alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
		result.identifier = @"TimelineCell";
	}
	
	TimeLog *log = [logs objectAtIndex:row];
	//NSLog(@"adding data to cell %@", log);
	NSDate *t1 = log.start_time;
	NSDate *t2 = log.end_time;
	NSString *t3 = log.caption;
	
	if (t1 == nil) t1 = [NSDate date];
	if (t2 == nil) t2 = [NSDate date];
	if (t3 == nil) t3 = @"Dummy app";
	
	result.imageView.image = [[NSImage alloc] init];
	result.timeBegin.stringValue = [t1 description];
	result.timeEnd.stringValue = [t2 description];
	result.appName.stringValue = [t3 description];
	
	return result;
}


-(CGFloat) tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
	
	return 100;
}

@end
