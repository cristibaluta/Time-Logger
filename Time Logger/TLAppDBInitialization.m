//
//  AppDbInitialization.m
//  Time Logger
//
//  Created by Baluta Cristian on 30/10/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import "TLAppDBInitialization.h"
#import "Client.h"
#import "Project.h"
#import "ProjectApp.h"

@implementation TLAppDBInitialization

+ (void)addDefaultProjects:(NSManagedObjectContext*)context {
	
	RCLog(@"addDefaultProjects");
	
	NSDictionary *app_fb = @{@"name":@"Facebook",
							 @"apps":@[@{@"identifier":@"com.apple.Safari", @"documents":@[@"facebook.com"]}] };
	NSDictionary *app_ytb = @{@"name":@"YouTube/Vimeo",
							  @"apps":@[@{@"identifier":@"com.apple.Safari", @"documents":@[@"youtube.com", @"vimeo.com"]}] };
	NSDictionary *app_movie = @{@"name":@"Movie Time",
								@"apps":@[@{@"identifier":@"org.videolan.vlc"}, @{@"identifier":@"com.apple.QuickTimePlayerX"}, @{@"identifier":@"com.intel.nw"}] };
	NSDictionary *app_photo = @{@"name":@"Photography",
								@"apps":@[@{@"identifier":@"com.adobe.Photoshop"}, @{@"identifier":@"com.adobe.bridge4.1"}] };
	NSDictionary *app_book = @{@"name":@"Reading Books",
							   @"apps":@[@{@"identifier":@"com.apple.iBooksX"}, @{@"identifier":@"com.apple.Preview", @"documents":@[@".pdf"]}] };
	NSDictionary *app_idle = @{@"name":@"Idle",
							   @"apps":@[] };
	NSDictionary *app_sleep = @{@"name":@"Sleep",
								@"apps":@[] };
	
	NSArray *projects_arr = @[app_fb, app_ytb, app_movie, app_photo, app_book, app_idle, app_sleep];
	
	
	// Create a client, me
	
	Client *client = [NSEntityDescription insertNewObjectForEntityForName:@"Client" inManagedObjectContext:context];
	client.client_id = @"0";
	client.email = @"";
	client.name = @"Me, the owner";
	
	
	// Create the default projects
	
	NSMutableSet *projects = [[NSMutableSet alloc] init];
	
	for (NSDictionary *dict in projects_arr) {
		
		Project *project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:context];
		project.category = [NSNumber numberWithInt:2];
		project.client_id = client.client_id;
		project.date_created = [NSDate date];
		project.descr = @"Free time";
		project.name = dict[@"name"];
		project.project_id = @"";
		project.tracking = [NSNumber numberWithBool:YES];
		project.time_spent = [NSNumber numberWithInt:0];
		project.client = client;
		
		NSMutableSet *apps = [[NSMutableSet alloc] init];
		for (NSDictionary *app in dict[@"apps"]) {
			
			NSArray *documents = app[@"documents"];
			if (documents.count == 0) {
				documents = @[@""];
			}
			for (NSString *doc in documents) {
				ProjectApp *papp = [NSEntityDescription insertNewObjectForEntityForName:@"ProjectApp" inManagedObjectContext:context];
				papp.app_identifier = app[@"identifier"];
				papp.document_name = doc;
				papp.project_id = @"";
				[apps addObject:papp];
			}
		}
		project.apps = apps;
		
		[projects addObject:project];
	}
	
	client.projects = projects;
	
}

@end
