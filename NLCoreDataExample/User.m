//
//  User.m
//  NLCoreDataExample
//
//  Created by j on 1/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "Group.h"

@implementation User

@dynamic username;
@dynamic password;
@dynamic group;

#pragma mark - Initialization

- (void)awakeFromInsert
{
	[self setUsername:@""];
	[self setPassword:@""];
}

@end
