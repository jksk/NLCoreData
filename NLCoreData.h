//  
//  NLCoreData.h
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

// 
// Class methods use specified context
// Instance methods use shared context (preferably used for main/ui thread)
// 

#import "NLSingleton.h"

#import "NSManagedObject+Init.h"
#import "NSManagedObject+Count.h"
#import "NSManagedObject+Fetch.h"
#import "NSManagedObject+Delete.h"
#import "NSManagedObject+Misc.h"
#import "NSFetchRequest+Init.h"

@class NSPersistentStoreCoordinator;
@class NSManagedObjectModel;
@class NSManagedObjectContext;

@interface NLCoreData : NLSingleton
{
	NSPersistentStoreCoordinator*						storeCoordinator_;
	NSManagedObjectModel*								managedObjectModel_;
	NSManagedObjectContext*								managedObjectContext_;
}

@property (nonatomic, readonly)	NSManagedObjectContext*	context;
@property (nonatomic, readonly) BOOL					storeExists;
@property (nonatomic, assign)	BOOL					encryptedStore;

#pragma mark - Context

+ (NSManagedObjectContext *)persistentContext;

+ (BOOL)saveContext:(NSManagedObjectContext *)context;
- (BOOL)saveContext;

#pragma mark - New

+ (id)insert:(Class)entity
   inContext:(NSManagedObjectContext *)context;
- (id)insert:(Class)entity;

#pragma mark - Count

+ (NSUInteger)count:(Class)entity
		  inContext:(NSManagedObjectContext *)context;
+ (NSUInteger)count:(Class)entity
		  inContext:(NSManagedObjectContext *)context
	  withPredicate:(NSPredicate *)predicate;

- (NSUInteger)count:(Class)entity;
- (NSUInteger)count:(Class)entity
	  withPredicate:(NSPredicate *)predicate;

#pragma mark - Delete

+ (void)delete:(Class)entity
   fromContext:(NSManagedObjectContext *)context;
+ (void)delete:(Class)entity
   fromContext:(NSManagedObjectContext *)context
 withPredicate:(NSPredicate *)predicate;

- (void)delete:(Class)entity;
- (void)delete:(Class)entity
 withPredicate:(NSPredicate *)predicate;

#pragma mark - Fetch single objects

+ (id)singleFetch:(Class)entity
	  fromContext:(NSManagedObjectContext *)context;
+ (id)singleFetch:(Class)entity
	  fromContext:(NSManagedObjectContext *)context
	withPredicate:(NSPredicate *)predicate;

+ (id)singleFetchOrInsert:(Class)entity
			  fromContext:(NSManagedObjectContext *)context;
+ (id)singleFetchOrInsert:(Class)entity
			  fromContext:(NSManagedObjectContext *)context
			withPredicate:(NSPredicate *)predicate;

- (id)singleFetch:(Class)entity;
- (id)singleFetch:(Class)entity
	withPredicate:(NSPredicate *)predicate;

- (id)singleFetchOrInsert:(Class)entity;
- (id)singleFetchOrInsert:(Class)entity
			withPredicate:(NSPredicate *)predicate;

#pragma mark - Fetch collections

+ (NSArray *)fetch:(Class)entity
	   fromContext:(NSManagedObjectContext *)context;
+ (NSArray *)fetch:(Class)entity
	   fromContext:(NSManagedObjectContext *)context
	 withPredicate:(NSPredicate *)predicate;
+ (NSArray *)fetch:(Class)entity
	   fromContext:(NSManagedObjectContext *)context
withSortDescriptors:(NSArray *)sortDescriptors;
+ (NSArray *)fetch:(Class)entity
	   fromContext:(NSManagedObjectContext *)context
	 withPredicate:(NSPredicate *)predicate
andSortDescriptors:(NSArray *)sortDescriptors;
+ (NSArray *)fetch:(Class)entity
	   fromContext:(NSManagedObjectContext *)context
	 withPredicate:(NSPredicate *)predicate
andSortDescriptors:(NSArray *)sortDescriptors
	  limitResults:(NSUInteger)limit;

- (NSArray *)fetch:(Class)entity;
- (NSArray *)fetch:(Class)entity
	 withPredicate:(NSPredicate *)predicate;
- (NSArray *)fetch:(Class)entity
withSortDescriptors:(NSArray *)sortDescriptors;
- (NSArray *)fetch:(Class)entity
	 withPredicate:(NSPredicate *)predicate
andSortDescriptors:(NSArray *)sortDescriptors;
- (NSArray *)fetch:(Class)entity
	 withPredicate:(NSPredicate *)predicate
andSortDescriptors:(NSArray *)sortDescriptors
	  limitResults:(NSUInteger)limit;

@end
