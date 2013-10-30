//
//  AppDbInitialization.h
//  Time Logger
//
//  Created by Baluta Cristian on 30/10/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDbInitialization : NSObject

+ (void) addDefaultProjects:(NSManagedObjectContext*)context;
@end
