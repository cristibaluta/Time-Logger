//
//  ProjectApp.h
//  Time Logger
//
//  Created by Baluta Cristian on 02/08/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class App, Project, TimeLog;

@interface ProjectApp : NSManagedObject

@property (nonatomic, retain) NSString * app_identifier;
@property (nonatomic, retain) NSString * document_name;
@property (nonatomic, retain) NSString * project_id;
@property (nonatomic, retain) App *app_cache;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) TimeLog *time_logs;

@end
