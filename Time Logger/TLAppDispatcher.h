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

@protocol TLAppDispatcherDelegate <NSObject>

@required
- (void)didStartTrackingApp:(NSRunningApplication*)app;
- (void)didStopTrackingApp:(NSRunningApplication*)app windowName:(NSString*)name;
- (void)didBecomeIdle;

@end


@interface TLAppDispatcher : NSObject

@property (nonatomic, retain) id<TLAppDispatcherDelegate> delegate;

- (void)logApp:(NSRunningApplication*)app windowName:(NSString*)name;
- (void)mouseMoved;
- (void)keyPressed;

@end
