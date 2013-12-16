//
//  AppDispatcher.m
//  Time Logger
//
//  Created by Baluta Cristian on 28/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import "AppDispatcher.h"

@implementation AppDispatcher


- (void) logApp:(NSRunningApplication*)app windowName:(NSString*)name {
	
	if (lastApp != nil && (! [app isEqual:lastApp] || ([app isEqual:lastApp] && ! [name isEqualToString:lastName]))) {
		
		// When we already have an lastApp and the activeApp has changed
		// Stop traking the last app and start traking the new app
		
		[self.delegate didStopTrackingApp:lastApp windowName:name];
		[self.delegate didStartTrackingApp:app];
		
		lastApp = app;
		lastName = name;
	}
	else if (lastApp == nil) {
		
		// Log the first app since you've opened TimeLogger
		
		lastApp = app;
		lastName = name;
		
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
