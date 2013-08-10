//
//  ProjectApp.h
//  Time Logger
//
//  Created by Baluta Cristian on 10/08/2013.
//  Copyright (c) 2013 Baluta Cristian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ProjectApp : NSManagedObject

@property (nonatomic, retain) NSString * app_identifier;
@property (nonatomic, retain) NSString * document_name;
@property (nonatomic, retain) NSString * project_id;

@end
