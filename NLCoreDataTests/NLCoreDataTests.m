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
	[super tearDown];
}

#pragma mark - Logic tests

- (void)testInsert
{
	[self seedUsers:1];
	STAssertNotNil([User fetchSingle], @"");
	[self deleteUsers];
}

- (void)testFetch
{
	[self seedUsers:1];
	STAssertNotNil([User fetchSingle], @"");
	STAssertTrue([[User fetch] count] == 1, @"");
	[self deleteUsers];
}

- (void)testDelete
{
	[self seedUsers:1];
	[User delete];
	STAssertNil([User fetchSingle], @"");
}

- (void)testCount
{
	[self seedUsers:1];
	STAssertTrue([User count] == 1, @"");
}

- (void)testNotification
{
	[User delete];
	STAssertTrue([User count] == 0, @"");
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		NSManagedObjectContext* context = [NSManagedObjectContext contextForThread];
		
		STAssertTrue([User count] == 0, @"");
		[User insert];
		STAssertTrue([User count] == 1, @"");
		
		[context notifyMainThreadContextOnSave];
		[context save];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			STAssertTrue([User count] == 1, @"");
		});
	});
}

- (void)testNotificationWithBlock
{
	[User delete];
	STAssertTrue([User count] == 0, @"");
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		NSManagedObjectContext* context = [NSManagedObjectContext contextForThread];
		
		STAssertTrue([User count] == 0, @"");
		[User insert];
		STAssertTrue([User count] == 1, @"");
		
		[context notifyMainThreadContextOnSaveWithBlock:^(NSNotification *note) {
			
			STAssertTrue([NSThread mainThread] == [NSThread currentThread], @"");
			STAssertTrue([User count] == 1, @"");
		}];
		
		[context save];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
			STAssertTrue([User count] == 1, @"");
		});
	});
}

#pragma mark - Helpers

- (void)seedUsers:(NSInteger)count
{
	for (int i = 0; i < count; i++) {
		
		User* user = [User insert];
		[user setUsername:@""];
	}
	
	[[NSManagedObjectContext contextForThread] save];
}

- (void)deleteUsers
{
	[User delete];
	[[NSManagedObjectContext contextForThread] save];
}

@end
