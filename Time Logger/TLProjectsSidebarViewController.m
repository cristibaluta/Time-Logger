//
//  ProjectsListViewController.m
//  Time Logger
//
//  Created by Baluta Cristian on 28/07/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import "TLProjectsSidebarViewController.h"
#import "TLProjectsSidebarCell.h"
#import "SourceListItem.h"
#import "Project.h"

@implementation TLProjectsSidebarViewController

@synthesize managedObjectModel;
@synthesize managedObjectContext;


#pragma mark -
#pragma mark Init/Dealloc


- (id)initWithNibName:(NSString *)nibNameOrNil
			   bundle:(NSBundle *)nibBundleOrNil
 managedObjectContext:(NSManagedObjectContext *)managedContext
   managedObjectModel:(NSManagedObjectModel *)managedModel
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.managedObjectContext = managedContext;
		self.managedObjectModel = managedModel;
	}
    return self;
}


- (void)awakeFromNib {
	
	sourceListItems = [[NSMutableArray alloc] init];
	
	// Set up the categories
	
	SourceListItem *libraryItem = [SourceListItem itemWithTitle:@"PROJECTS" identifier:@"projects"];
	SourceListItem *archiveItem = [SourceListItem itemWithTitle:@"ARCHIVED PROJECTS" identifier:@"archive"];
	SourceListItem *recreationalItem = [SourceListItem itemWithTitle:@"RECREATIONAL" identifier:@"recreational"];
	
	[sourceListItems addObjectsFromArray:@[libraryItem, archiveItem, recreationalItem]];
	
	
	// Read all the projects
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortByDate]];
	
	NSError *error;
	NSArray *projects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	//RCLog(@"Projects %@", projects);
	
	if (!error) {
		for (Project *project in projects) {
//			RCLog(@"List project: %@ -> %@", project.name, project.category);
			
			SourceListItem *item = [sourceListItems objectAtIndex:[project.category intValue]];
			SourceListItem *newItem = [SourceListItem itemWithTitle:project.name identifier:project.project_id];
			[newItem setIcon:[NSImage imageNamed:[project.name stringByAppendingString:@".png"]]];
			
			NSArray *arr = item.children;
			if (arr == nil) {
				arr = [NSArray array];
			}
			item.children = [arr arrayByAddingObject:newItem];
		}
	}
	
	[sourceList reloadData];
}



- (void)loadView {
    [super loadView];
}


#pragma mark -
#pragma mark Source List Data Source Methods

- (NSUInteger)sourceList:(PXSourceList*)sourceList numberOfChildrenOfItem:(id)item {
	// Works the same way as the NSOutlineView data source: `nil` means a parent item
	if (item == nil) {
		return [sourceListItems count];
	}
	else {
		return [[item children] count];
	}
}

- (id)sourceList:(PXSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item {
	//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if (item == nil) {
		return [sourceListItems objectAtIndex:index];
	}
	else {
		return [[item children] objectAtIndex:index];
	}
}

- (id)sourceList:(PXSourceList*)aSourceList objectValueForItem:(id)item {
	return [item title];
}

- (void)sourceList:(PXSourceList*)aSourceList setObjectValue:(id)object forItem:(id)item {
	[item setTitle:object];
}

- (BOOL)sourceList:(PXSourceList*)aSourceList isItemExpandable:(id)item {
	return [item hasChildren];
}

- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasBadge:(id)item {
	return [item hasBadge];
}

- (NSInteger)sourceList:(PXSourceList*)aSourceList badgeValueForItem:(id)item {
	return [item badgeValue];
}

- (BOOL)sourceList:(PXSourceList*)aSourceList itemHasIcon:(id)item {
	return [item hasIcon];
}

- (NSImage*)sourceList:(PXSourceList*)aSourceList iconForItem:(id)item {
	return [item icon];
}

- (NSMenu*)sourceList:(PXSourceList*)aSourceList menuForEvent:(NSEvent*)theEvent item:(id)item
{
	RCLog(@"menuForEvent %@", theEvent);
	if ([theEvent type] == NSRightMouseDown ||
		([theEvent type] == NSLeftMouseDown && ([theEvent modifierFlags] & NSControlKeyMask) == NSControlKeyMask))
	{
		NSMenu * m = [[NSMenu alloc] init];
		if (item != nil) {
			[m addItemWithTitle:@"Enable tracking" action:nil keyEquivalent:@""];
			[m addItemWithTitle:@"Disable tracking" action:nil keyEquivalent:@""];
			[m addItemWithTitle:@"Archive" action:nil keyEquivalent:@""];
		} else {
			[m addItemWithTitle:@"New Project" action:nil keyEquivalent:@""];
			[m addItemWithTitle:@"Colapse all" action:nil keyEquivalent:@""];
		}
		return m;
	}
	return nil;
}

#pragma mark -
#pragma mark Source List Delegate Methods

- (BOOL)sourceList:(PXSourceList*)aSourceList isGroupAlwaysExpanded:(id)group {
	
	if ([[group identifier] isEqualToString:@"archive"]) return NO;
	return YES;
}

- (void)sourceListSelectionDidChange:(NSNotification *)notification {
	
	NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];
	RCLog(@"sourceListSelectionDidChange %@", selectedIndexes);
	
	//Set the label text to represent the new selection
	if ([selectedIndexes count] > 1) {
		
	}
	else if ([selectedIndexes count] == 1) {
		NSString *identifier = [[sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
		RCLog(@"identifier %@", identifier);
		
		[self.delegate projectDidSelect:identifier];
	}
	else {
		
	}
}

- (void)sourceListDeleteKeyPressedOnRows:(NSNotification *)notification {
	
	NSIndexSet *rows = [[notification userInfo] objectForKey:@"rows"];
	RCLog(@"Delete key pressed on rows %@", rows);
	
	//Do something here
	
}


//-(NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
//{
//    if (![item isKindOfClass:[ProjectsSidebarCell class]]) {
//        ProjectsSidebarCell *cellView = [outlineView makeViewWithIdentifier:@"DataCell" owner:self];
//        cellView.name.stringValue=[item valueForKey:@"name"];
//        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
//        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
//
//        
//        NSString *currentTime = [dateFormatter stringFromDate:[item valueForKey:@"date_created"]];
//        
//        cellView.time.stringValue=currentTime;
//        if ([[item valueForKey:@"tracking"] intValue]==1) {
//            [cellView.tracking setState:NSOnState];
//        }
//        else
//        {
//            [cellView.tracking setState:NSOffState];
//        }
//        return cellView;
//    } else {
//        return [outlineView makeViewWithIdentifier:@"HeaderCell" owner:self];
//    }
//
//}


#pragma mark Actions

- (IBAction)addProject:(id)sender {
	
    NSWindow *w = [sourceList window];
	BOOL endEdit = [w makeFirstResponder:w];
	if (!endEdit)
		return;
	
	NSError *error = nil;
	Project *project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:self.managedObjectContext];
	project.category = 0;
	project.date_created = [NSDate date];
	project.name = @"New Project";
	project.project_id = @"new_project";
	project.tracking = [NSNumber numberWithBool:YES];
	project.client_id = @"clientid1";
	project.descr = @"Some description for this project....";
	
    if (![self.managedObjectContext save:&error]) {
		RCLog(@"Whoops, couldn't add a new project: %@", [error localizedDescription]);
		return;
	}
	
	// Create a new object to add to NSTableView
	
	SourceListItem *libraryItem = [sourceListItems firstObject];
	SourceListItem *newItem = [SourceListItem itemWithTitle:project.name identifier:@"new_project"];
	[newItem setIcon:[NSImage imageNamed:@"Facebook.png"]];
	
	NSArray *arr = libraryItem.children;
	if (arr == nil) {
		arr = [NSArray array];
	}
	libraryItem.children = [arr arrayByAddingObject:newItem];
	
	[sourceList reloadData];
	[sourceList editColumn:-1 row:[sourceListItems indexOfObject:newItem] withEvent:nil select:YES];
	
	// Animate the new item
	
//	[sourceList beginUpdates];
//	[sourceList insertItemsAtIndexes:[NSIndexSet indexSetWithIndex:1]
//							inParent:libraryItem
//					   withAnimation:NSTableViewAnimationEffectFade];
//	[sourceList endUpdates];
}

- (IBAction)deleteProject:(id)sender {
	RCLog(@"Delete Project at index %li", (long)sourceList.selectedRow);
	RCLogI((int)[sourceList numberOfGroups]);
	RCLogO([sourceList itemAtRow:sourceList.selectedRow]);
	// failing, don't know why
	[sourceList beginUpdates];
	[sourceList removeItemsAtIndexes:[NSIndexSet indexSetWithIndex:sourceList.selectedRow]
							inParent:[sourceList parentForItem:[sourceList itemAtRow:sourceList.selectedRow]]
					   withAnimation:NSTableViewAnimationEffectFade];
	[sourceList endUpdates];
	
	if ([sourceList selectedRow] >= 0) {
        [sourceListItems removeObjectAtIndex:[sourceList selectedRow]];
        [sourceList reloadData];
    }
}

//- (IBAction)toggleTracking:(id)sender
//{
//    
//    NSInteger row=[projectsTable rowForView:sender];
//    int state=[(NSButton *)sender state]==NSOnState?1:0;
//    
//    [[[projectsArray arrangedObjects] objectAtIndex:row] setValue:[NSNumber numberWithInt:state] forKey:@"tracking"];
//
//
//}

- (void)controlTextDidEndEditing:(NSNotification *)notification {
	
	RCLog(@"controlTextDidEndEditing %@", notification);
	
	if ([[notification object] isKindOfClass:[NSTextField class]]) {
//		NSTextField *textField = [notification object];
//		[[[projectsArray arrangedObjects] objectAtIndex:[projectsTable selectedRow]] setValue:textField.stringValue forKey:@"name"];
	}
}

@end
