//
//  ProjectsSidebarCell.h
//  Time Logger
//
//  Created by Silviu Turuga on 30.07.2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ProjectsSidebarCell : NSTableCellView
{
    IBOutlet NSTextField *name;
    IBOutlet NSTextField *time;
    IBOutlet NSButton *tracking;
}

@property (assign) NSTextField *name;
@property (assign) NSTextField *time;
@property (assign) NSButton *tracking;
@end
