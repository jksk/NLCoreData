//
//  Group.m
//  NLCoreDataExample
//
//  Created by j on 1/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Group.h"
#import "User.h"

@implementation Group

@dynamic
name,
users;

#pragma mark - Lifecycle

- (void)awakeFromInsert
{
	[self setName:@""];
}

@end
