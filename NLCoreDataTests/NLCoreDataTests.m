//
//  NLCoreDataTests.m
//  NLCoreDataTests
//
//  Created by j on 27/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NLCoreDataTests.h"
#import "User.h"
#import "Group.h"

@interface NLCoreDataTests ()

- (void)seedUsers:(NSInteger)count;
- (void)deleteUsers;

@end

#pragma mark -
@implementation NLCoreDataTests

#pragma mark - Setup/Teardown

- (void)setUp
{
	[super setUp];
}

- (void)tearDown
{
	[super tearDown];
}

#pragma mark - Logic tests

- (void)testInsert
{
	[self seedUsers:1];
	STAssertNotNil([User singleFetchFromSharedContext], @"");
	[self deleteUsers];
}

- (void)testFetch
{
	[self seedUsers:1];
	STAssertNotNil([User singleFetchFromSharedContext], @"");
	STAssertTrue([[User fetchFromSharedContext] count] == 1, @"");
	[self deleteUsers];
}

- (void)testDelete
{
	[self seedUsers:1];
	[User deleteFromSharedContext];
	STAssertNil([User singleFetchFromSharedContext], @"");
}

- (void)testCount
{
	[self seedUsers:1];
	STAssertTrue([User countInSharedContext] == 1, @"");
}

#pragma mark - Helpers

- (void)seedUsers:(NSInteger)count
{
	for (int i = 0; i < count; i++) {
		
		User* user = [User insertInSharedContext];
		[user setUsername:@""];
	}
	
	[[NLCoreData shared] saveContext];
}

- (void)deleteUsers
{
	[User deleteFromSharedContext];
	[[NLCoreData shared] saveContext];
}

@end
