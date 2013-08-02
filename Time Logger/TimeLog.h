//
//  TimeLog.h
//  Time Logger
//
//  Created by Baluta Cristian on 02/08/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class App;

@interface TimeLog : NSManagedObject

@property (nonatomic, retain) NSString * app_identifier;
@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * document_name;
@property (nonatomic, retain) NSDate * end_time;
@property (nonatomic, retain) NSDate * start_time;
@property (nonatomic, retain) App *app_cache;

@end
