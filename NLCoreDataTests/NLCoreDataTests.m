//
//  NLCoreDataTests.m
//  NLCoreDataTests
//
//  Created by j on 27/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NLCoreDataTests.h"
#import "NLCoreData.h"
#import "User.h"
#import "Group.h"

@interface NLCoreDataTests ()

- (void)seedUsers:(NSInteger)count;
- (void)deleteUsers;

@end

#pragma mark -
@implementation NLCoreDataTests

#pragma mark - Lifecycle

- (void)setUp
{
	[super setUp];
	
	[[NLCoreData shared] setModelName:@"CoreDataStore"];
}

- (void)tearDown
{
	[User deleteWithPredicate:nil];
	[Group deleteWithPredicate:nil];
	
	[super tearDown];
}

#pragma mark - Logic tests

- (void)testInsert
{
	[self seedUsers:1];
	STAssertNotNil([User fetchSingleWithPredicate:nil], @"");
	[self deleteUsers];
}

- (void)testFetch
{
	[self seedUsers:1];
	STAssertNotNil([User fetchSingleWithPredicate:nil], @"");
	STAssertTrue([[User fetchWithPredicate:nil] count] == 1, @"");
	[self deleteUsers];
}

- (void)testDelete
{
	[self seedUsers:1];
	[User deleteWithPredicate:nil];
	STAssertNil([User fetchSingleWithPredicate:nil], @"");
}

- (void)testCount
{
	[self seedUsers:1];
	STAssertTrue([User countWithPredicate:nil] == 1, @"");
}

- (void)testAsynchronousFetch
{
	[self seedUsers:1];
	
	[User fetchAsynchronouslyWithRequest:^(NSFetchRequest *request) {
		
	} completion:^(NSArray *objects) {
		
		STAssertTrue([objects count] == 1, @"");
	}];
}

- (void)testPopulateWithDictionary
{
	[self seedUsers:1];
	
	User* user			= [User fetchSingleWithPredicate:nil];
	NSString* username	= @"Bob";
	NSString* password	= @"myPassword";
	
	[user populateWithDictionary:@{@"username": username, @"password": password}];
	
	STAssertTrue([[user username] isEqualToString:username], @"");
	STAssertTrue([[user password] isEqualToString:password], @"");
}

#pragma mark - Helpers

- (void)seedUsers:(NSInteger)count
{
	for (int i = 0; i < count; i++) {
		
		User* user = [User insert];
		[user setUsername:@""];
	}
}

- (void)deleteUsers
{
	[User deleteWithPredicate:nil];
}

@end
