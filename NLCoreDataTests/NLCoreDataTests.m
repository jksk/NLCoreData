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
	
#ifndef DEBUG
#define DEBUG 1
#endif
	
	[[NLCoreData shared] setModelName:@"CoreDataStore"];
}

- (void)tearDown
{
	[User deleteInContext:[NSManagedObjectContext mainContext] predicate:nil];
	[Group deleteInContext:[NSManagedObjectContext mainContext] predicate:nil];
	
	[super tearDown];
}

#pragma mark - Logic tests

- (void)testInsert
{
	[self seedUsers:1];
	STAssertNotNil([User fetchSingleInContext:[NSManagedObjectContext mainContext] predicate:nil], @"");
	[self deleteUsers];
}

- (void)testFetch
{
	[self seedUsers:1];
	STAssertNotNil([User fetchSingleInContext:[NSManagedObjectContext mainContext] predicate:nil], @"");
	STAssertTrue([[User fetchInContext:[NSManagedObjectContext mainContext] predicate:nil] count] == 1, @"");
	[self deleteUsers];
}

- (void)testDelete
{
	[self seedUsers:1];
	[User deleteInContext:[NSManagedObjectContext mainContext] predicate:nil];
	STAssertNil([User fetchSingleInContext:[NSManagedObjectContext mainContext] predicate:nil], @"");
}

- (void)testCount
{
	[self seedUsers:1];
	STAssertTrue([User countInContext:[NSManagedObjectContext mainContext] predicate:nil] == 1, @"");
}

- (void)testAsynchronousFetch
{
	[self seedUsers:1];
	
	[User fetchAsynchronouslyToMainContextWithRequest:^(NSFetchRequest *request) {
		
	} completion:^(NSArray *objects) {
		
		STAssertTrue([objects count] == 1, @"");
	}];
}

- (void)testPopulateWithDictionary
{
	[self seedUsers:1];
	
	User* user			= [User fetchSingleInContext:[NSManagedObjectContext mainContext] predicate:nil];
	NSString* username	= @"Bob";
	NSString* password	= @"myPassword";
	
	[user populateWithDictionary:@{@"username": username, @"password": password}];
	
	STAssertTrue([[user username] isEqualToString:username], @"");
	STAssertTrue([[user password] isEqualToString:password], @"");
}

- (void)testSortByKey
{
	NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntity:[User class] context:[NSManagedObjectContext mainContext]];
	
	[request sortByKey:@"username" ascending:YES];
	[request sortByKey:@"password" ascending:NO];
	
	NSArray* descriptors = [request sortDescriptors];
	
	STAssertTrue([descriptors count] == 2, @"");
	
	NSSortDescriptor* firstSort		= descriptors[0];
	NSSortDescriptor* secondSort	= descriptors[1];
	
	STAssertTrue([[firstSort key] isEqualToString:@"username"], @"");
	STAssertTrue([[secondSort key] isEqualToString:@"password"], @"");
	
	STAssertTrue([firstSort ascending] == YES, @"");
	STAssertTrue([secondSort ascending] == NO, @"");
}

- (void)testResetStore
{
	[self seedUsers:5];
	[[NSManagedObjectContext mainContext] save];
	
	STAssertTrue([User countInContext:[NSManagedObjectContext mainContext] predicate:nil] == 5, @"");
	
	[[NLCoreData shared] resetDatabase];
	
	STAssertTrue([User countInContext:[NSManagedObjectContext mainContext] predicate:nil] == 0, @"");
	
	[self seedUsers:3];
	[[NSManagedObjectContext mainContext] saveNested];
	[NSManagedObjectContext storeContext];
	
	STAssertTrue([User countInContext:[NSManagedObjectContext mainContext] predicate:nil] == 3, @"");
	
	[User deleteInContext:[NSManagedObjectContext mainContext] predicate:nil];
	[[NSManagedObjectContext mainContext] saveNested];
}

#pragma mark - Helpers

- (void)seedUsers:(NSInteger)count
{
	for (int i = 0; i < count; i++) {
		
		User* user = [User insertInContext:[NSManagedObjectContext mainContext]];
		[user setUsername:@""];
	}
}

- (void)deleteUsers
{
	[User deleteInContext:[NSManagedObjectContext mainContext] predicate:nil];
}

@end
