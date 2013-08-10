//
//  Client.h
//  Time Logger
//
//  Created by Baluta Cristian on 10/08/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Client : NSManagedObject

@property (nonatomic, retain) NSString * client_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * email;

@end
