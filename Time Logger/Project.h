//
//  Project.h
//  Time Logger
//
//  Created by Baluta Cristian on 10/08/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectApp;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSDate * date_created;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * project_id;
@property (nonatomic, retain) NSNumber * tracking;
@property (nonatomic, retain) NSString * client_id;
@property (nonatomic, retain) NSString * descr;
@property (nonatomic, retain) ProjectApp *apps;

@end
