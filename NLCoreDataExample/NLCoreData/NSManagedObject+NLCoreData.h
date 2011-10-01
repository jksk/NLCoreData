//
//  NSManagedObject+NLCoreData.h
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

@interface NSManagedObject (NLCoreData)

#pragma mark - New

+ (id)insertInContext:(NSManagedObjectContext *)context;
+ (id)insertInSharedContext;

#pragma mark - Count

+ (NSUInteger)countInContext:(NSManagedObjectContext *)context;
+ (NSUInteger)countInContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate;
+ (NSUInteger)countInSharedContext;
+ (NSUInteger)countInSharedContextWithPredicate:(NSPredicate *)predicate;

#pragma mark - Delete

- (void)deleteFromContext;
+ (void)deleteFromContext:(NSManagedObjectContext *)context;
+ (void)deleteFromContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate;
+ (void)deleteFromSharedContext;
+ (void)deleteFromSharedContextWithPredicate:(NSPredicate *)predicate;

#pragma mark - Fetch single objects

+ (id)singleFetchFromContext:(NSManagedObjectContext *)context;
+ (id)singleFetchFromContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate;
+ (id)singleFetchOrInsertInContext:(NSManagedObjectContext *)context;
+ (id)singleFetchOrInsertInContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate;
+ (id)singleFetchFromSharedContext;
+ (id)singleFetchFromSharedContextWithPredicate:(NSPredicate *)predicate;
+ (id)singleFetchOrInsertInSharedContext;
+ (id)singleFetchOrInsertInSharedContextWithPredicate:(NSPredicate *)predicate;

#pragma mark - Fetch multiple objects

+ (NSArray *)fetchFromContext:(NSManagedObjectContext *)context;
+ (NSArray *)fetchFromContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate;
+ (NSArray *)fetchFromContext:(NSManagedObjectContext *)context withSortDescriptors:(NSArray *)sortDescriptors;
+ (NSArray *)fetchFromContext:(NSManagedObjectContext *)context
				withPredicate:(NSPredicate *)predicate
		   andSortDescriptors:(NSArray *)sortDescriptors;
+ (NSArray *)fetchFromContext:(NSManagedObjectContext *)context
				withPredicate:(NSPredicate *)predicate
		   andSortDescriptors:(NSArray *)sortDescriptors
				 limitResults:(NSUInteger)limit;

+ (NSArray *)fetchFromSharedContext;
+ (NSArray *)fetchFromSharedContextWithPredicate:(NSPredicate *)predicate;
+ (NSArray *)fetchFromSharedContextWithSortDescriptors:(NSArray *)sortDescriptors;
+ (NSArray *)fetchFromSharedContextWithPredicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)sortDescriptors;
+ (NSArray *)fetchFromSharedContextWithPredicate:(NSPredicate *)predicate
							  andSortDescriptors:(NSArray *)sortDescriptors
									limitResults:(NSUInteger)limit;

#pragma mark - Miscellaneous

/**
 Checks if an object is saved to the persistent store.
 @return YES if the object is unsaved, otherwise NO.
 */
- (BOOL)isNew;

@end
