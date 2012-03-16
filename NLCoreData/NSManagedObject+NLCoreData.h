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

#pragma mark - Insert

/**
 @name Insert
 Inserts a new object.
 @param context The context to insert the object in.
 @return The inserted object.
 */
+ (id)insertInContext:(NSManagedObjectContext *)context;

/**
 @name Insert
 Inserts a new object in the shared context for current thread.
 @return The inserted object.
 */
+ (id)insert;

#pragma mark - Count

/**
 @name Count
 Counts objects filtered by predicate.
 @param context The context to count the objects in.
 @param predicate The predicate to filter the objects before counting.
 @return The number of objects.
 */
+ (NSUInteger)countInContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate;

/**
 @name Count
 Counts objects in the shared context for the current thread filtered by predicate.
 @param predicate The predicate to filter the objects before counting.
 @return The number of objects.
 */
+ (NSUInteger)countWithPredicate:(NSPredicate *)predicate;

/**
 @name Count
 Counts objects in the shared context for the current thread filtered by predicate.
 @return The number of objects.
 */
+ (NSUInteger)count;

#pragma mark - Delete

/**
 @name Delete
 Deletes objects filtered by predicate.
 @param context The context to delete the objects from.
 @param predicate The predicate to filter the objects before deleting.
 */
+ (void)deleteFromContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate;

/**
 @name Delete
 Deletes objects from the shared context for current thread filtered by predicate.
 @param predicate The predicate to filter the objects before deleting.
 */
+ (void)deleteWithPredicate:(NSPredicate *)predicate;

/**
 @name Delete
 Deletes objects from the shared context for the current thread.
 */
+ (void)delete;

/**
 @name Delete
 Deletes this object from the context it belongs to.
 */
- (void)delete;

#pragma mark - Fetch single objects

/**
 @name Fetch single objects
 Fetches a single object with specified object ID.
 Attempts to avoid disk IO if possible.
 @param context The context to fetch the object from.
 @param objectID The object ID to fetch.
 @return The object, or nil if none found
 */
+ (id)fetchSingleFromContext:(NSManagedObjectContext *)context withObjectID:(NSManagedObjectID *)objectID;

/**
 @name Fetch single objects
 Fetches a single object with specified object ID from shared context for current thread.
 Attempts to avoid disk IO if possible.
 @param objectID The object ID to fetch.
 @return The object, or nil if none found
 */
+ (id)fetchSingleWithObjectID:(NSManagedObjectID *)objectID;

/**
 @name Fetch single objects
 Fetches a single object filtered by predicate.
 @param context The context to fetch the object from.
 @param predicate The predicate to filter the objects before fetching.
 @return The object, or nil if none found.
 */
+ (id)fetchSingleFromContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate;

/**
 @name Fetch single objects
 Fetches a single object from the shared context for current thread filtered by predicate.
 @param predicate The predicate to filter the objects before fetching.
 @return The object, or nil if none found.
 */
+ (id)fetchSingleWithPredicate:(NSPredicate *)predicate;

/**
 @name Fetch single objects
 Fetches a single object from the shared context for current thread.
 @return The object, or nil if none found.
 */
+ (id)fetchSingle;

/**
 @name Fetch single objects
 Fetches a single object filtered by predicate, or inserts one if not found.
 @param context The context to fetch the object from.
 @param predicate The predicate to filter the objects before fetching.
 @return The object.
 */
+ (id)fetchSingleOrInsertInContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate;

/**
 @name Fetch single objects
 Fetches a single object from the shared context for current thread filtered by predicate, or inserts one if not found.
 @param predicate The predicate to filter the objects before fetching.
 @return The object.
 */
+ (id)fetchSingleOrInsertWithPredicate:(NSPredicate *)predicate;

/**
 @name Fetch single objects
 Fetches a single object from the shared context for current thread, or inserts one if not found.
 @return The object.
 */
+ (id)fetchSingleOrInsert;

#pragma mark - Fetch multiple objects

/**
 @name Fetch multiple objects
 Fetches all objects filtered by predicate, sorted.
 @param context The context to fetch the objects from.
 @param predicate The predicate to filter the objects before counting.
 @param sortDescriptors An array of NSSortDescriptors.
 @param limit Limits the number of results returned. 0 disables the limit.
 @return An array of objects. May be empty if none are found.
 */
+ (NSArray *)fetchFromContext:(NSManagedObjectContext *)context
				withPredicate:(NSPredicate *)predicate
		   andSortDescriptors:(NSArray *)sortDescriptors
				 limitResults:(NSUInteger)limit;

/**
 @name Fetch multiple objects
 Fetches all objects from the shared context for current thread filtered by predicate, sorted.
 @param predicate The predicate to filter the objects before counting.
 @param sortDescriptors An array of NSSortDescriptors.
 @param limit Limits the number of results returned. 0 disables the limit.
 @return An array of objects. May be empty if none are found.
 */
+ (NSArray *)fetchWithPredicate:(NSPredicate *)predicate
			 andSortDescriptors:(NSArray *)sortDescriptors
				   limitResults:(NSUInteger)limit;

/**
 @name Fetch multiple objects
 Fetches all objects from the shared context for current thread filtered by predicate, sorted.
 @param predicate The predicate to filter the objects before counting.
 @param sortDescriptors An array of NSSortDescriptors.
 @return An array of objects. May be empty if none are found.
 */
+ (NSArray *)fetchWithPredicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)sortDescriptors;

/**
 @name Fetch multiple objects
 Fetches all objects from the shared context for current thread filtered by predicate.
 @param predicate The predicate to filter the objects before counting.
 @param key The key to sort by.
 @param ascending is key ascending?
 @return An array of objects. May be empty if none are found.
 */
+ (NSArray *)fetchWithPredicate:(NSPredicate *)predicate sortByKey:(NSString *)key ascending:(BOOL)ascending;

/**
 @name Fetch multiple objects
 Fetches all objects from the shared context for current thread filtered by predicate.
 @param predicate The predicate to filter the objects before counting.
 @return An array of objects. May be empty if none are found.
 */
+ (NSArray *)fetchWithPredicate:(NSPredicate *)predicate;

/**
 @name Fetch multiple objects
 Fetches all objects from the shared context for current thread, sorted.
 @param key The key to sort by.
 @param ascending is key ascending?
 @return An array of objects. May be empty if none are found.
 */
+ (NSArray *)fetchAndSortByKey:(NSString *)key ascending:(BOOL)ascending;

/**
 @name Fetch multiple objects
 Fetches all objects from the shared context for current thread, sorted.
 @param sortDescriptors An array of NSSortDescriptors.
 @return An array of objects. May be empty if none are found.
 */
+ (NSArray *)fetchWithSortDescriptors:(NSArray *)sortDescriptors;

/**
 @name Fetch multiple objects
 Fetches all objects from the shared context for current thread.
 @return An array of objects. May be empty if none are found.
 */
+ (NSArray *)fetch;

/**
 @name Fetch multiple object IDs
 Fetches all matching object IDs asynchronously.
 @param predicate The predicate to filter the objects before fetching.
 @param sortDescriptors An array of NSSortDescriptors.
 @param limit Limits the number of results returned. 0 disables the limit.
 @param completion Block to run on completion. Runs on main thread. Must be non-nil.
 */
+ (void)fetchObjectIDsWithPredicate:(NSPredicate *)predicate
				 andSortDescriptors:(NSArray *)sortDescriptors
					   limitResults:(NSUInteger)limit
						 completion:(void (^)(NSArray* objectIDs))completion;

#pragma mark - Miscellaneous

/**
 Retrieves a list of the attributes in the NSManagedObject model.
 @return A list of strings.
 */
- (NSArray *)managedAttributeNames;

/**
 Checks if an object is saved to the persistent store.
 @return YES if the object is unsaved, otherwise NO.
 */
- (BOOL)isNew;

/**
 Forces an object to be marked as updated.
 Useful if you update faults and want an NSFetchedResultsController to update.
 Does nothing if it doesn't find any attributes on the object.
 */
- (void)touch;

@end
