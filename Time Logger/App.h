//
//  App.h
//  Time Logger
//
//  Created by Baluta Cristian on 09/10/14.
//  Copyright (c) 2014 Baluta Cristian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface App : NSManagedObject

@property (nonatomic, retain) NSString * appIdentifier;
@property (nonatomic, retain) NSString * appName;
@property (nonatomic, retain) NSData * iconData;

@end
