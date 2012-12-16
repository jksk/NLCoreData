//
//  User.h
//  NLCoreDataExample
//
//  Created by j on 1/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class
Group;

#pragma mark -
@interface User : NSManagedObject

@property (strong, nonatomic) NSString*	username;
@property (strong, nonatomic) NSString*	password;
@property (strong, nonatomic) Group*	group;

@end
