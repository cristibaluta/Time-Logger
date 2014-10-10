//
//  Project.h
//  Time Logger
//
//  Created by Baluta Cristian on 09/10/14.
//  Copyright (c) 2014 Baluta Cristian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Client, ProjectApp, TimeLog;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSString * clientId;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * projectDescription;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * projectId;
@property (nonatomic, retain) NSNumber * timeSpent;
@property (nonatomic, retain) NSNumber * tracking;
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
