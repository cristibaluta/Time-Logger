//
//  ProjectsListViewController.m
//  Time Logger
//
//  Created by Baluta Cristian on 28/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import "ProjectsSidebarViewController.h"
#import "ProjectsSidebarCell.h"

@interface ProjectsSidebarViewController ()

@end

@implementation ProjectsSidebarViewController

@synthesize managedObjectModel;
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil managedObjectContext:(NSManagedObjectContext *) managedContext managedObjectModel:(NSManagedObjectModel *) managedModel
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        self.managedObjectContext=managedContext;
        self.managedObjectModel=managedModel;

         }
    return self;
}


- (void)loadView
{
    [super loadView];

    NSError *error;
    if ([projectsArray fetchWithRequest:nil merge:YES error:&error]==NO)
    {
        NSLog(@"Error fetching the projects array controller");
    }


    [projectsTable reloadData];

}

// Projects Outline View START

#pragma mark -
#pragma mark OutlineView Data Source Delegate Methods

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    return [[projectsArray arrangedObjects] objectAtIndex:index];
}

-(NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    if (![item isKindOfClass:[ProjectsSidebarCell class]]) {
        ProjectsSidebarCell *cellView = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
        cellView.name.stringValue=[item valueForKey:@"name"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];

        
        NSString *currentTime = [dateFormatter stringFromDate:[item valueForKey:@"date_created"]];
        
        cellView.time.stringValue=currentTime;
        if ([[item valueForKey:@"tracking"] intValue]==1) {
            [cellView.tracking setState:NSOnState];
        }
        else
        {
            [cellView.tracking setState:NSOffState];
        }
        return cellView;
    } else {
        return [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
    }

}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    //Return YES for the top level item, NO for the others.
    if (item == nil) {
        return YES;
    }
    
    return NO;
    
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    //return [dataSource count];
    return [[projectsArray arrangedObjects] count];
    
}

// Projects Outline END

- (IBAction)addProject:(id)sender
{
    NSWindow *w = [projectsTable window];
	BOOL endEdit = [w makeFirstResponder:w];
	if (!endEdit)
		return;
	
    //create a new object to add to NSTableView
	NSObject *new = [projectsArray newObject];
    [new setValue:@"New Project..." forKey:@"name"];
    [new setValue:[NSDate date]forKey:@"date_created"];
    [new setValue:[NSNumber numberWithInt:1] forKey:@"tracking"];
    
    [projectsArray addObject:new];
    [projectsTable reloadData];
    
    
	[projectsTable editColumn:0 row:[[projectsArray arrangedObjects] indexOfObject:new] withEvent:nil select:YES];
}

- (IBAction)deleteProject:(id)sender
{
    if ([projectsTable selectedRow]>=0) {
        [projectsArray removeObjectAtArrangedObjectIndex:[projectsTable selectedRow]];
        [projectsTable reloadData];
    }
 
}
- (IBAction)toggleTracking:(id)sender
{
    
    NSInteger row=[projectsTable rowForView:sender];
    int state=[(NSButton *)sender state]==NSOnState?1:0;
    
    [[[projectsArray arrangedObjects] objectAtIndex:row] setValue:[NSNumber numberWithInt:state] forKey:@"tracking"];


}

-(void)controlTextDidEndEditing:(NSNotification *)notification {
    if ([[notification object] isKindOfClass:[NSTextField class]])
     {
         NSTextField *textField = [notification object];
         [[[projectsArray arrangedObjects] objectAtIndex:[projectsTable selectedRow]] setValue:textField.stringValue forKey:@"name"];
     }

}

@end
