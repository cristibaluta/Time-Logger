//
//  AppDbInitialization.m
//  Time Logger
//
//  Created by Baluta Cristian on 30/10/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import "AppDbInitialization.h"
#import "Client.h"
#import "Project.h"
#import "ProjectApp.h"

@implementation AppDbInitialization

+ (void) addDefaultProjects:(NSManagedObjectContext*)context {
	
	RCLog(@"addDefaultProjects");
	
	NSArray *projects_arr = @[
	@{@"name":@"Facebook", @"apps":@[@"com.apple.Safari"], },
	@{@"name":@"YouTube", @"apps":@[@"com.apple.Safari"], },
	@{@"name":@"Movie Time", @"apps":@[@"org.videolan.vlc", @"com.apple.QuickTimePlayerX"], },
	@{@"name":@"Photography", @"apps":@[@"com.adobe.Photoshop", @"com.adobe.bridge4.1"], },
	@{@"name":@"Reading Books", @"apps":@[@"com.apple.iBooksX", @"com.apple.Preview"], },
	@{@"name":@"Idle", @"apps":@[], },
	@{@"name":@"Sleep", @"apps":@[], }
	];
	
	
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
		for (NSString *appIdentifier in dict[@"apps"]) {
			
			ProjectApp *app = [NSEntityDescription insertNewObjectForEntityForName:@"ProjectApp" inManagedObjectContext:context];
			app.app_identifier = appIdentifier;
			app.document_name = @"";
			app.project_id = @"";
			[apps addObject:app];
		}
		project.apps = apps;
		
		[projects addObject:project];
	}
	
	client.projects = projects;
	
}

@end
