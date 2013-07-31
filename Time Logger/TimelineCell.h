//
//  TimelineCell.h
//  Time Logger
//
//  Created by Baluta Cristian on 31/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TimelineCell : NSCell

@property (nonatomic, retain) NSImage *icon;
@property (nonatomic, retain) NSTextView *timeBegin;
@property (nonatomic, retain) NSTextView *timeEnd;
@property (nonatomic, retain) NSTextView *appName;
@property (nonatomic, retain) NSTextView *details;


@end
