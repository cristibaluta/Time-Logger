//
//  ProjectsSidebarCell.m
//  Time Logger
//
//  Created by Silviu Turuga on 30.07.2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import "ProjectsSidebarCell.h"

@implementation ProjectsSidebarCell
@synthesize name=_name;
@synthesize time=_time;
@synthesize tracking=_tracking;


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.

    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end
