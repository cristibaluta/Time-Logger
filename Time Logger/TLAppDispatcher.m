//
//  AppDispatcher.m
//  Time Logger
//
//  Created by Baluta Cristian on 28/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import "TLAppDispatcher.h"

@interface TLAppDispatcher () {
	
	NSRunningApplication *_lastApp;
	NSString *_lastName;
	NSDate *_lastUserActivity;
}
@end


@implementation TLAppDispatcher

- (void)logApp:(NSRunningApplication*)app windowName:(NSString*)name {
	
	if (_lastApp != nil && (! [app isEqual:_lastApp] || ([app isEqual:_lastApp] && ! [name isEqualToString:_lastName]))) {
		
		// When we already have an lastApp and the activeApp has changed
		// Stop traking the last app and start traking the new app
		
		[self.delegate didStopTrackingApp:_lastApp windowName:name];
		[self.delegate didStartTrackingApp:app];
		
		_lastApp = app;
		_lastName = name;
	}
	else if (_lastApp == nil) {
		
		// Log the first app since you've opened TimeLogger
		
		_lastApp = app;
		_lastName = name;
		
		[self.delegate didStartTrackingApp:app];
	}
}

- (void)mouseMoved {
	
	_lastUserActivity = [NSDate date];
}

- (void)keyPressed {
	
	_lastUserActivity = [NSDate date];
}

@end
