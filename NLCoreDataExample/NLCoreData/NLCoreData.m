//
//  NLCoreData.m
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

#import <CoreData/CoreData.h>
#import "NLCoreData.h"

@interface NLCoreData ()

@property (strong, nonatomic) NSPersistentStoreCoordinator*	storeCoordinator;
@property (strong, nonatomic) NSManagedObjectModel*			managedObjectModel;

- (NSString *)storePath;
- (NSURL *)storeURL;

@end

#pragma mark -
@implementation NLCoreData

#ifndef NLCOREDATA_STORENAME
#error define NLCOREDATA_STORENAME as an NSString with the name of your model
#endif

@synthesize
storeCoordinator	= storeCoordinator_,
managedObjectModel	= managedObjectModel_,
context				= managedObjectContext_;

#pragma mark - Initialization

- (void)usePreSeededFile:(NSString *)filePath
{
	if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
#ifdef DEBUG
		[NSException raise:@"Preseed-file does not exist at path" format:@"%@", filePath];
#endif
		return;
	}
	
	NSError* error = nil;
	if (![[NSFileManager defaultManager] copyItemAtPath:filePath toPath:[self storePath] error:&error]) {
#ifdef DEBUG
		[NSException raise:@"Copy preseed-file failed" format:@"%@", [error localizedDescription]];
#endif
	}
}

#pragma mark - Context

+ (NSManagedObjectContext *)createContext
{
	NSManagedObjectContext* context = [[NSManagedObjectContext alloc] init];
	[context setPersistentStoreCoordinator:[[self shared] storeCoordinator]];
	
	return context;
}

+ (BOOL)saveContext:(NSManagedObjectContext *)context
{
	if (![context hasChanges]) return YES;
	
	NSError* error = nil;
	
	if (![context save:&error]) {
#ifdef DEBUG
		NSLog(@"NSManagedObjectContext Error: %@",
			  [error userInfo]);
		
		NSArray* details = [[error userInfo] objectForKey:@"NSDetailedErrors"];
		for (NSError* err in details) {
			NSLog(@"Error %i: %@", [err code], [err userInfo]);
		}
#endif
		return NO;
	}
	
	return YES;
}

- (BOOL)saveContext
{
	return [[self class] saveContext:[self context]];
}

#pragma mark - Heavy lifting

+ (id)insert:(Class)entity inContext:(NSManagedObjectContext *)context
{
	return [NSEntityDescription
			insertNewObjectForEntityForName:NSStringFromClass(entity)
			inManagedObjectContext:context];
}

+ (NSUInteger)count:(Class)entity inContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate
{
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription
						entityForName:NSStringFromClass(entity)
						inManagedObjectContext:context]];
	if (predicate) {
		[request setPredicate:predicate];
	}
	
	NSError* error = nil;
	NSUInteger count = [context countForFetchRequest:request error:&error];
	
#ifdef DEBUG
	if (error) {
		[NSException raise:@"Count Exception"
					format:@"Count Error: %@", [error localizedDescription]];
	}
#endif
	
	return count;
}

+ (void)delete:(Class)entity fromContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate
{
	NSArray* objects = [self fetch:entity
					   fromContext:context
					 withPredicate:predicate
				andSortDescriptors:nil
					  limitResults:0];
	
	for (NSManagedObject* object in objects) {
		[context deleteObject:object];
	}
}

+ (id)singleFetchOrInsert:(Class)entity
			  fromContext:(NSManagedObjectContext *)context
			withPredicate:(NSPredicate *)predicate
{
	id obj = [self singleFetch:entity fromContext:context withPredicate:predicate];
	if (!obj) obj = [[self class] insert:entity inContext:context];
	
	return obj;
}

+ (NSArray *)fetch:(Class)entity
	   fromContext:(NSManagedObjectContext *)context
	 withPredicate:(NSPredicate *)predicate
andSortDescriptors:(NSArray *)sortDescriptors
	  limitResults:(NSUInteger)limit
{
	NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntity:entity inContext:context];
	[request setReturnsObjectsAsFaults:NO];
	
	if (predicate) [request setPredicate:predicate];
	if (sortDescriptors) [request setSortDescriptors:sortDescriptors];
	if (limit > 0) [request setFetchLimit:limit];
	
	NSError* error = nil;
	NSArray* results = [context executeFetchRequest:request error:&error];
	
#ifdef DEBUG
	if (!results) {
		[NSException raise:@"Fetch Exception"
					format:@"Error fetching: %@", [error localizedDescription]];
	}
#endif
	
	return results;
}

#pragma mark - Insert

- (id)insert:(Class)entity
{
	return [[self class] insert:entity inContext:[self context]];
}

#pragma mark - Count

+ (NSUInteger)count:(Class)entity inContext:(NSManagedObjectContext *)context
{
	return [self count:entity inContext:context withPredicate:nil];
}

- (NSUInteger)count:(Class)entity
{
	return [[self class] count:entity inContext:[self context] withPredicate:nil];
}

- (NSUInteger)count:(Class)entity withPredicate:(NSPredicate *)predicate
{
	return [[self class] count:entity inContext:[self context] withPredicate:predicate];
}

#pragma mark - Delete

+ (void)delete:(Class)entity fromContext:(NSManagedObjectContext *)context
{
	[self delete:entity fromContext:context withPredicate:nil];
}

- (void)delete:(Class)entity
{
	[[self class] delete:entity fromContext:[self context] withPredicate:nil];
}

- (void)delete:(Class)entity withPredicate:(NSPredicate *)predicate
{
	[[self class] delete:entity fromContext:[self context] withPredicate:predicate];
}

#pragma mark - Fetch

+ (id)singleFetch:(Class)entity fromContext:(NSManagedObjectContext *)context
{
	return [[self fetch:entity
			fromContext:context
		  withPredicate:nil
	 andSortDescriptors:nil
		   limitResults:1] lastObject];
}

+ (id)singleFetch:(Class)entity fromContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate
{
	return [[self fetch:entity
			fromContext:context
		  withPredicate:predicate
	 andSortDescriptors:nil
		   limitResults:1] lastObject];
}

+ (id)singleFetchOrInsert:(Class)entity fromContext:(NSManagedObjectContext *)context
{
	return [self singleFetchOrInsert:entity
						 fromContext:context
					   withPredicate:nil];
}

+ (NSArray *)fetch:(Class)entity fromContext:(NSManagedObjectContext *)context
{
	return [self fetch:entity
		   fromContext:context
		 withPredicate:nil
	andSortDescriptors:nil
		  limitResults:0];
}

+ (NSArray *)fetch:(Class)entity fromContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate
{
	return [self fetch:entity
		   fromContext:context
		 withPredicate:predicate
	andSortDescriptors:nil
		  limitResults:0];
}

+ (NSArray *)fetch:(Class)entity
	fromContext:(NSManagedObjectContext *)context
	withSortDescriptors:(NSArray *)sortDescriptors
{
	return [self fetch:entity
		   fromContext:context
		 withPredicate:nil
	andSortDescriptors:sortDescriptors
		  limitResults:0];
}

+ (NSArray *)fetch:(Class)entity
	   fromContext:(NSManagedObjectContext *)context
	 withPredicate:(NSPredicate *)predicate
andSortDescriptors:(NSArray *)sortDescriptors
{
	return [self fetch:entity
		   fromContext:context
		 withPredicate:predicate
	andSortDescriptors:sortDescriptors
		  limitResults:0];
}

- (id)singleFetch:(Class)entity
{
	return [[self class] singleFetch:entity fromContext:[self context] withPredicate:nil];
}

- (id)singleFetch:(Class)entity withPredicate:(NSPredicate *)predicate
{
	return [[self class] singleFetch:entity fromContext:[self context] withPredicate:predicate];
}

- (id)singleFetchOrInsert:(Class)entity
{
	return [[self class] singleFetchOrInsert:entity fromContext:[self context] withPredicate:nil];
}

- (id)singleFetchOrInsert:(Class)entity
			withPredicate:(NSPredicate *)predicate
{
	return [[self class] singleFetchOrInsert:entity fromContext:[self context] withPredicate:predicate];
}

- (NSArray *)fetch:(Class)entity
{
	return [[self class] fetch:entity
				   fromContext:[self context]
				 withPredicate:nil
			andSortDescriptors:nil
				  limitResults:0];
}

- (NSArray *)fetch:(Class)entity withPredicate:(NSPredicate *)predicate
{
	return [[self class] fetch:entity
				   fromContext:[self context]
				 withPredicate:predicate
			andSortDescriptors:nil
				  limitResults:0];
}

- (NSArray *)fetch:(Class)entity withSortDescriptors:(NSArray *)sortDescriptors
{
	return [[self class] fetch:entity
				   fromContext:[self context]
				 withPredicate:nil
			andSortDescriptors:sortDescriptors
				  limitResults:0];
}

- (NSArray *)fetch:(Class)entity withPredicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)sortDescriptors
{
	return [[self class] fetch:entity
				   fromContext:[self context]
				 withPredicate:predicate
			andSortDescriptors:sortDescriptors
				  limitResults:0];
}

- (NSArray *)fetch:(Class)entity
	 withPredicate:(NSPredicate *)predicate
andSortDescriptors:(NSArray *)sortDescriptors
	  limitResults:(NSUInteger)limit
{
	return [[self class] fetch:entity
				   fromContext:[self context]
				 withPredicate:predicate
			andSortDescriptors:sortDescriptors
				  limitResults:limit];
}

#pragma mark - Properties

- (NSString *)storePath
{
	return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
			stringByAppendingPathComponent:[NLCOREDATA_STORENAME stringByAppendingString:@".sqlite"]];
}

- (NSURL *)storeURL
{
	NSURL* path = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory
														  inDomains:NSUserDomainMask] lastObject];
	
	return [path URLByAppendingPathComponent:[NLCOREDATA_STORENAME stringByAppendingString:@".sqlite"]];
}

- (void)setStoreEncrypted:(BOOL)storeEncrypted
{
	NSString* encryption = storeEncrypted ? NSFileProtectionComplete : NSFileProtectionNone;
	NSDictionary* attributes = [NSDictionary dictionaryWithObject:encryption forKey:NSFileProtectionKey];
	
	NSError* error = nil;
	if (![[NSFileManager defaultManager] setAttributes:attributes
										  ofItemAtPath:[self storePath]
												 error:&error]) {
#ifdef DEBUG		
		[NSException
		 raise:@"Persistent Store Exception"
		 format:@"Error Encryping Store: %@", [error localizedDescription]];
#endif
	}
}

- (BOOL)storeExists
{
	return [[NSFileManager defaultManager] fileExistsAtPath:[self storePath]];
}

- (BOOL)storeIsEncrypted
{
	NSError* error = nil;
	NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self storePath] error:&error];
	if (!attributes) {
#ifdef DEBUG
		[NSException raise:@"Persistent Store Exception"
					format:@"Error Retrieving Store Attributes: %@", [error localizedDescription]];
#endif
		return NO;
	}
	
	return [[attributes objectForKey:NSFileProtectionKey] isEqualToString:NSFileProtectionComplete];
}

- (NSPersistentStoreCoordinator *)storeCoordinator
{
	if (storeCoordinator_) return storeCoordinator_;
	
	storeCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	
	NSError* error = nil;
	if (![storeCoordinator_
		  addPersistentStoreWithType:NSSQLiteStoreType
		  configuration:nil
		  URL:[self storeURL]
		  options:nil
		  error:&error]) {
		
#ifdef DEBUG
		[NSException
		 raise:@"Persistent Store Exception"
		 format:@"Error Creating Store: %@", [error localizedDescription]];
#endif
	}
	
	return storeCoordinator_;
}

- (NSManagedObjectModel *)managedObjectModel
{
	if (managedObjectModel_) return managedObjectModel_;
	
	NSURL* url = [[NSBundle mainBundle] URLForResource:NLCOREDATA_STORENAME withExtension:@"momd"];
	managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
	return managedObjectModel_;
}

- (NSManagedObjectContext *)context
{
	if (managedObjectContext_) return managedObjectContext_;
	
	managedObjectContext_ = [[NSManagedObjectContext alloc] init];
	[managedObjectContext_ setPersistentStoreCoordinator:[self storeCoordinator]];
	return managedObjectContext_;
}

@end
