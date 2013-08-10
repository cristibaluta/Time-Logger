//
//  TimelineCell.h
//  Time Logger
//
//  Created by Baluta Cristian on 31/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TimelineCell : NSTableCellView

@property (nonatomic, retain) IBOutlet NSTextField *timeBegin;
@property (nonatomic, retain) IBOutlet NSTextField *timeEnd;
@property (nonatomic, retain) IBOutlet NSTextField *appName;
@property (nonatomic, retain) IBOutlet NSTextField *details;


@end
