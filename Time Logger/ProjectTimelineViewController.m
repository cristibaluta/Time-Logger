//
//  ProjectTimelineViewController.m
//  Time Logger
//
//  Created by Baluta Cristian on 29/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import "ProjectTimelineViewController.h"

@interface ProjectTimelineViewController ()

@end

@implementation ProjectTimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
		
		runningApplications = [[NSWorkspace sharedWorkspace] runningApplications];
		NSLog(@"%@", runningApplications);
		for (NSRunningApplication *app in runningApplications) {
			if ([app ownsMenuBar]) {
				activeApp = app;
				break;
			}
		}
    }
    
    return self;
}




#pragma mark TableViewDatasource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	return runningApplications.count;
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
	
	NSRunningApplication *app = [runningApplications objectAtIndex:row];
	
	result.imageView.image = app.icon;
	result.timeBegin.stringValue = @"20:14";//[app.launchDate description];
	result.timeEnd.stringValue = @"22:38";//[app.launchDate description];
	result.appName.stringValue = app.localizedName;
	
	return result;
}


-(CGFloat) tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
	
	return 100;
}

@end
