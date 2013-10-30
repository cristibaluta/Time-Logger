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

@implementation AppDbInitialization

+ (void) addDefaultProjects:(NSManagedObjectContext*)context {
	
	RCLog(@"addDefaultProjects");
	
	NSArray *projects_arr = @[
	@{@"name":@"Facebook", @"apps":@[@"com.apple.Safari"], },
	@{@"name":@"YouTube", @"apps":@[@"com.apple.Safari"], },
	@{@"name":@"Movie Time", @"apps":@[@"com.apple.Safari"], },
	@{@"name":@"Photography", @"apps":@[@"com.apple.Safari"], },
	@{@"name":@"Reading Books", @"apps":@[@"com.apple.Safari"], },
	@{@"name":@"Idle", @"apps":@[@"com.apple.Safari"], },
	@{@"name":@"Sleep", @"apps":@[@"com.apple.Safari"], }
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
		//project.apps = [[NSSet alloc] init];
		project.client = client;
		
		[projects addObject:project];
	}
	
	client.projects = projects;
	
}

@end
