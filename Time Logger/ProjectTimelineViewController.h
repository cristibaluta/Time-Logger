//
//  ProjectTimelineViewController.h
//  Time Logger
//
//  Created by Baluta Cristian on 29/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ProjectTimelineViewController : NSViewController {
	
	NSArray *runningApplications;
	NSRunningApplication *activeApp;
	NSMutableDictionary *timeLogs;
}

@end
