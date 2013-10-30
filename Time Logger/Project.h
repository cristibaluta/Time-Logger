//
//  Project.h
//  Time Logger
//
//  Created by Baluta Cristian on 30/10/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Client, ProjectApp, TimeLog;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSString * client_id;
@property (nonatomic, retain) NSDate * date_created;
@property (nonatomic, retain) NSString * descr;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * project_id;
@property (nonatomic, retain) NSNumber * tracking;
@property (nonatomic, retain) NSNumber * time_spent;
@property (nonatomic, retain) NSSet *apps;
@property (nonatomic, retain) Client *client;
@property (nonatomic, retain) NSOrderedSet *logs;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addAppsObject:(ProjectApp *)value;
- (void)removeAppsObject:(ProjectApp *)value;
- (void)addApps:(NSSet *)values;
- (void)removeApps:(NSSet *)values;

- (void)insertObject:(TimeLog *)value inLogsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLogsAtIndex:(NSUInteger)idx;
- (void)insertLogs:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLogsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLogsAtIndex:(NSUInteger)idx withObject:(TimeLog *)value;
- (void)replaceLogsAtIndexes:(NSIndexSet *)indexes withLogs:(NSArray *)values;
- (void)addLogsObject:(TimeLog *)value;
- (void)removeLogsObject:(TimeLog *)value;
- (void)addLogs:(NSOrderedSet *)values;
- (void)removeLogs:(NSOrderedSet *)values;
@end
