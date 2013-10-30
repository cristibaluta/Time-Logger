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
	
	NSDate *                date;
	NSString *              string, *timestamp;
	NSDateFormatter *       formatter;
	
	timestamp = @"00:00";
	
	formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat: @"yyyy-MM-dd "];
	[formatter setTimeZone: [NSTimeZone localTimeZone]];
	
	string = [formatter stringFromDate: [NSDate date]];
	string = [string stringByAppendingString: timestamp];
	
	[formatter setDateFormat: @"yyyy-MM-dd HH:mm"];
	date = [formatter dateFromString: string];
	
	NSPredicate *todaysLogs = [NSPredicate predicateWithFormat:@"start_time > %@", date];
	[fetchRequest setPredicate:todaysLogs];
	
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
//	RCLog(@"populate row %li %@", rowIndex, [aTableColumn identifier]);
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
	//RCLog(@"adding data to cell %@", log);
	NSDate *t1 = log.start_time;
	NSDate *t2 = log.end_time;
	NSString *t3 = log.caption;
	NSString *t4 = log.document_name;
	
	if (t1 == nil) t1 = [NSDate date];
	if (t2 == nil) t2 = [NSDate date];
	if (t3 == nil) t3 = @"Dummy app";
	if (t4 == nil) t4 = @"";
	
	NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
	[formatter1 setDateFormat: @"HH:mm:ss"];
	NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
	[formatter2 setDateFormat: @"HH:mm:ss"];
	
	result.timeBegin.stringValue = [formatter1 stringFromDate:t1];
	result.timeEnd.stringValue = [formatter2 stringFromDate:t2];
	result.appName.stringValue = [t3 description];
	result.details.stringValue = [t4 description];
	
	// Add app icon
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSPredicate *todaysLogs = [NSPredicate predicateWithFormat:@"app_identifier == %@", log.app_identifier];
	[fetchRequest setPredicate:todaysLogs];
	NSEntityDescription *a = [NSEntityDescription entityForName:@"App" inManagedObjectContext:[self managedObjectContext]];
	[fetchRequest setEntity:a];
	
	NSError *error;
	NSArray *arr = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
	
	if (arr.count > 0) {
		RCLog(@"%@", arr);
		result.imageView.image = [[NSImage alloc] initWithData:((App*)[arr objectAtIndex:0]).icon];
	}
	
	return result;
}


-(CGFloat) tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
	
	return 100;
}

@end
