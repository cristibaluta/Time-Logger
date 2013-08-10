//
//  ProjectConfigViewController.m
//  Time Logger
//
//  Created by Baluta Cristian on 29/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import "ProjectConfigViewController.h"

@implementation ProjectConfigViewController

@synthesize managedObjectModel;
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil managedObjectContext:(NSManagedObjectContext *) managedContext managedObjectModel:(NSManagedObjectModel *) managedModel
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
		self.managedObjectContext = managedContext;
		self.managedObjectModel = managedModel;
		
	}
    return self;
}


@end
