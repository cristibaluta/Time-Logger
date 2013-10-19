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

@required
- (void) didStartTrackingApp:(NSRunningApplication*)app;
- (void) didStopTrackingApp:(NSRunningApplication*)app windowName:(NSString*)name;
- (void) didBecomeIdle;

@end


@interface AppDispatcher : NSObject {
	
	NSRunningApplication *lastApp;
	NSString *lastName;
	NSDate *lastUserActivity;
}

@property (nonatomic, retain) id<AppDispatcherDelegate> delegate;

- (void) logApp:(NSRunningApplication*)app windowName:(NSString*)name;
- (void) mouseMoved;
- (void) keyPressed;

@end
