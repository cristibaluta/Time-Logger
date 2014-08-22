//
//  ProjectsSidebarCell.h
//  Time Logger
//
//  Created by Silviu Turuga on 30.07.2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ProjectsSidebarCell : NSTableCellView

@property (assign) IBOutlet NSTextField *name;
@property (assign) IBOutlet NSTextField *time;
@property (assign) IBOutlet NSButton *tracking;

@end
