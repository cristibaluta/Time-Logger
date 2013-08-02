//
//  App.h
//  Time Logger
//
//  Created by Baluta Cristian on 02/08/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface App : NSManagedObject

@property (nonatomic, retain) NSString * app_identifier;
@property (nonatomic, retain) NSString * app_name;
@property (nonatomic, retain) NSData * icon;

@end
