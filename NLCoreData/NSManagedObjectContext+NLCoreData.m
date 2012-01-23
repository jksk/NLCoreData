//
//  NSManagedObjectContext+NLCoreData.m
//  
//  Created by Jesper Skrufve <jesper@neolo.gy>
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//  

#import "NSManagedObjectContext+NLCoreData.h"

static NSString* kNLCoreDataNotifyBlockKey	= @"NLCoreDataContextNotifyBlock";
static NSString* kNLCoreDataContextKey		= @"NLCoreDataContext";

@implementation NSManagedObjectContext (NLCoreData)

@dynamic
undoEnabled;

#pragma mark - Lifecycle

- (BOOL)save
{
	if (![self hasChanges]) return YES;
	
	NSError* error = nil;
	
	if (![self save:&error]) {
#ifdef DEBUG
		NSLog(@"NSManagedObjectContext Error: %@", [error userInfo]);
		
		NSArray* details = [[error userInfo] objectForKey:@"NSDetailedErrors"];
		for (NSError* err in details) NSLog(@"Error %i: %@", [err code], [err userInfo]);
#endif
		return NO;
	}
	
	return YES;
}

+ (NSManagedObjectContext *)context
{
	NSManagedObjectContext* context = [[NSManagedObjectContext alloc] init];
	[context setPersistentStoreCoordinator:[[NLCoreData shared] storeCoordinator]];
	
	return context;
}

+ (NSManagedObjectContext *)contextForThread
{
	return [self contextForThread:[NSThread currentThread]];
}

+ (NSManagedObjectContext *)contextForThread:(NSThread *)thread
{
	NSManagedObjectContext* context = [[thread threadDictionary] objectForKey:kNLCoreDataContextKey];
	
	if (!context) {
		context = [self context];
		[[thread threadDictionary] setObject:context forKey:kNLCoreDataContextKey];
	}
	
	return context;
}

#pragma mark - Notifications

- (void)notifyMainThreadContextOnSaveWithBlock:(NLCoreDataNotificationBlock)block
{
	NSManagedObjectContext* context = [[[NSThread mainThread] threadDictionary] objectForKey:kNLCoreDataContextKey];
	if (!context || self == context) return;
	
	if (block)
		[[[NSThread currentThread] threadDictionary] setObject:block forKey:kNLCoreDataNotifyBlockKey];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(contextDidSave:)
												 name:NSManagedObjectContextDidSaveNotification
											   object:context];
}

- (void)notifyMainThreadContextOnSave
{
	[self notifyMainThreadContextOnSaveWithBlock:nil];
}

- (void)stopNotifyingMainThreadContextOnSave
{
	NSManagedObjectContext* context = [[[NSThread mainThread] threadDictionary] objectForKey:kNLCoreDataContextKey];
	
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self name:NSManagedObjectContextDidSaveNotification object:context];
}

#pragma mark - Events

- (void)contextDidSave:(NSNotification *)note
{
	NLCoreDataNotificationBlock block = [[[NSThread currentThread] threadDictionary]
										 objectForKey:kNLCoreDataNotifyBlockKey];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		
		NSManagedObjectContext* context = [NSManagedObjectContext contextForThread];
		[context mergeChangesFromContextDidSaveNotification:note];
		
		if (block) block(note);
	});
}

#pragma mark - Property Accessors

- (void)setUndoEnabled:(BOOL)undoEnabled
{
	if (undoEnabled && ![self isUndoEnabled]) [self setUndoManager:[[NSUndoManager alloc] init]];
	else if (!undoEnabled) [self setUndoManager:nil];
}

- (BOOL)isUndoEnabled
{
	return !![self undoManager];
}

@end
