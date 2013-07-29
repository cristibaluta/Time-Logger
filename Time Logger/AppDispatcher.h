//
//  AppDispatcher.h
//  Time Logger
//
//  Created by Baluta Cristian on 28/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//


// Receives when an app became in focus or keyboard and mouse activity,
// and decides which app to start tracking.

#import <Foundation/Foundation.h>

@class AppDispatcher;
@protocol AppDispatcherDelegate <NSObject>

- (void) didStartTrackingApp:(NSRunningApplication*)app;
- (void) didStopTrackingApp:(NSRunningApplication*)app;
- (void) didBecomeIdle;

@end


@interface AppDispatcher : NSObject {
	
	NSRunningApplication *activeApp;
	NSRunningApplication *lastApp;
	
	NSDate *lastUserActivity;
}

@property (nonatomic, retain) id<AppDispatcherDelegate> delegate;

- (void) logApp:(NSRunningApplication*)app;
- (void) mouseMoved;
- (void) keyPressed;

@end
