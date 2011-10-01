//
//  Group.h
//  NLCoreDataExample
//
//  Created by j on 1/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

#pragma mark -
@interface Group : NSManagedObject

@property (nonatomic, retain) NSString*	name;
@property (nonatomic, retain) NSSet*	users;

@end

#pragma mark -
@interface Group (CoreDataGeneratedAccessors)

- (void)addUsersObject:(User *)value;
- (void)removeUsersObject:(User *)value;
- (void)addUsers:(NSSet *)values;
- (void)removeUsers:(NSSet *)values;

@end
