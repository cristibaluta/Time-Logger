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
		NSLog(@"initWithNibName %@", runningApplications);
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

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	
	//NSLog(@"populate row %li", rowIndex);
	
	NSRunningApplication *app = [runningApplications objectAtIndex:rowIndex];
	
	// icon
	// localizedName
	// bundleIdentifier
	
	if ([[aTableColumn identifier] isEqualToString:@"icon"]) {
        return app.icon;
    }
	if ([[aTableColumn identifier] isEqualToString:@"name"]) {
        return  app.localizedName;
    }
	if ([[aTableColumn identifier] isEqualToString:@"identifier"]) {
        return app.bundleIdentifier;
    }
	if ([[aTableColumn identifier] isEqualToString:@"time"]) {
		NSNumber *currentTime = [timeLogs objectForKey:app.bundleIdentifier];
		if ([activeApp.bundleIdentifier isEqualTo:app.bundleIdentifier]) {
			return [[currentTime description] stringByAppendingString:@"sec"];
		}
		else {
			if (currentTime == nil) {
				return @"";
			}
			else {
				return [[currentTime description] stringByAppendingString:@"sec"];
			}
		}
    }
	else {
		return [NSString stringWithFormat:@"%@ (%@)", app.localizedName, app.bundleIdentifier];
	}
	
    return nil;
}




@end
