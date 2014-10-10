//
//  TimeLog.h
//  Time Logger
//
//  Created by Baluta Cristian on 09/10/14.
//  Copyright (c) 2014 Baluta Cristian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimeLog : NSManagedObject

@property (nonatomic, retain) NSString * appIdentifier;
@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSString * documentName;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSDate * startTime;

@end
