//
//  AppDispatcher.m
//  Time Logger
//
//  Created by Baluta Cristian on 28/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import "AppDispatcher.h"

@implementation AppDispatcher


- (void) logApp:(NSRunningApplication*)app {
	
	if (lastApp != nil && ! [app isEqual:lastApp]) {
		
		// When we already have an lastApp and the activeApp has switched
		// Stop logging the last app and start logging the new app
		
		[self.delegate didStopTrackingApp:lastApp];
		[self.delegate didStartTrackingApp:app];
		
		lastApp = app;
	}
	else if (lastApp == nil) {
		
		// Log the first app since you've opened TimeLogger
		
		lastApp = app;
		[self.delegate didStartTrackingApp:app];
	}
}

- (void) mouseMoved {
	
	lastUserActivity = [NSDate date];
}

- (void) keyPressed {
	
	lastUserActivity = [NSDate date];
}

@end
