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

/**
 Class methods use specified context.
 Instance methods use shared context.
 The shared context is on the main thread. Use this for UI work, etc.
 */

/**
 If an error occurs during a core data operation and DEBUG is defined, an exception is usually raised.
 Make sure not to define DEBUG in production.
 */

#import "NLSingleton.h"

#import "NSManagedObject+NLCoreData.h"
#import "NSManagedObjectContext+NLCoreData.h"
#import "NSFetchRequest+NLCoreData.h"
#import "NSFetchedResultsController+NLCoreData.h"

@class NSPersistentStoreCoordinator;
@class NSManagedObjectModel;
@class NSManagedObjectContext;

#pragma mark -
@interface NLCoreData : NLSingleton

/**
 The shared context.
 */
@property (strong, nonatomic, readonly) NSManagedObjectContext*	context;

/**
 Whether or not the store exists. This is likely NO before it's used the first time only.
 Use it to check if the store needs to be seeded.
 */
@property (assign, nonatomic, readonly) BOOL storeExists;

/**
 Whether or not the store is encrypted.
 */
@property (assign, nonatomic, getter=storeIsEncrypted) BOOL storeEncrypted;

/**
 @name Undo
 Enables/disables or checks if an NSUndoManager is present for the shared context.
 */
@property (assign, nonatomic, getter=isUndoEnabled) BOOL	undoEnabled;

#pragma mark - Initialization

/**
 @name Initialization
 Copies a preseeded database file to be used as your Core Data store.
 The filetype should be sqlite and it should conform to your model.
 @param filePath Path to the preseeded file.
 @warning This should be called before using Core Data on first run.
 */
- (void)usePreSeededFile:(NSString *)filePath;

#pragma mark - Context

/**
 @name Context
 Creates a new context on the persistent store.
 @return A new context.
 */
+ (NSManagedObjectContext *)createContext;

/**
 @name Context
 Saves the context.
 @param context The context to save.
 @return Whether the save was successful.
 */
+ (BOOL)saveContext:(NSManagedObjectContext *)context;

/**
 @name Context
 Saves the shared context.
 @return Whether the save was successful.
 */
- (BOOL)saveContext;

#pragma mark - New

/**
 @name New
 Inserts a new object.
 @param entity The NSManagedObject subclass of the entity.
 @param context The context to insert the object in.
 @return The inserted object.
 */
+ (id)insert:(Class)entity inContext:(NSManagedObjectContext *)context;

/**
 @name New
 Inserts a new object in the shared context.
 @param entity The NSManagedObject subclass of the entity.
 @return The inserted object.
 */
- (id)insert:(Class)entity;

#pragma mark - Count

/**
 @name Count
 Counts all objects.
 @param entity The NSManagedObject subclass of the entity.
 @param context The context to count the objects in.
 @return The number of objects.
 */
+ (NSUInteger)count:(Class)entity inContext:(NSManagedObjectContext *)context;

/**
 @name Count
 Counts objects filtered by predicate.
 @param entity The NSManagedObject subclass of the entity.
 @param context The context to count the objects in.
 @param predicate The predicate to filter the objects before counting.
 @return The number of objects.
 */
+ (NSUInteger)count:(Class)entity inContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate;

/**
 @name Count
 Counts all objects in the shared context.
 @param entity The NSManagedObject subclass of the entity.
 @return The number of objects.
 */
- (NSUInteger)count:(Class)entity;

/**
 @name Count
 Counts objects filtered by predicate in the shared context.
 @param entity The NSManagedObject subclass of the entity.
 @param predicate The predicate to filter the objects before counting.
 @return The number of objects.
 */
- (NSUInteger)count:(Class)entity withPredicate:(NSPredicate *)predicate;

#pragma mark - Delete

/**
 @name Delete
 Deletes all objects.
 @param entity The NSManagedObject subclass of the entity.
 @param context The context to delete the objects from.
 */
+ (void)delete:(Class)entity fromContext:(NSManagedObjectContext *)context;

/**
 @name Delete
 Deletes objects filtered by predicate.
 @param entity The NSManagedObject subclass of the entity.
 @param context The context to delete the objects from.
 @param predicate The predicate to filter the objects before deleting.
 */
+ (void)delete:(Class)entity fromContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate;

/**
 @name Delete
 Deletes all objects from the shared context.
 @param entity The NSManagedObject subclass of the entity.
 */
- (void)delete:(Class)entity;

/**
 @name Delete
 Deletes objects filtered by the predicate from the shared context.
 @param entity The NSManagedObject subclass of the entity.
 @param predicate The predicate to filter the objects before deleting.
 */
- (void)delete:(Class)entity withPredicate:(NSPredicate *)predicate;

#pragma mark - Fetch single objects

/**
 @name Fetch single objects
 Fetches a single object.
 @param entity The NSManagedObject subclass of the entity.
 @param context The context to fetch the objects from.
 @return The object, or nil if none found.
 */
+ (id)singleFetch:(Class)entity fromContext:(NSManagedObjectContext *)context;

/**
 @name Fetch single objects
 Fetches a single object filtered by predicate.
 @param entity The NSManagedObject subclass of the entity.
 @param context The context to count the objects in.
 @param predicate The predicate to filter the objects before fetching.
 @return The object, or nil if none found.
 */
+ (id)singleFetch:(Class)entity fromContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate;

/**
 @name Fetch single objects
 Fetches a single object or inserts one if none is found.
 @param entity The NSManagedObject subclass of the entity.
 @param context The context to fetch the objects from.
 @return The object.
 */
+ (id)singleFetchOrInsert:(Class)entity fromContext:(NSManagedObjectContext *)context;

/**
 @name Fetch single objects
 Fetches a single object filtered by predicate or inserts one if none is found.
 @param entity The NSManagedObject subclass of the entity.
 @param context The context to fetch the objects from.
 @param predicate The predicate to filter the objects before counting.
 @return The object.
 */
+ (id)singleFetchOrInsert:(Class)entity
			  fromContext:(NSManagedObjectContext *)context
			withPredicate:(NSPredicate *)predicate;

/**
 @name Fetch single objects
 Fetches a single object from the shared context.
 @param entity The NSManagedObject subclass of the entity.
 @return The object, or nil if none found.
 */
- (id)singleFetch:(Class)entity;

/**
 @name Fetch single objects
 Fetches a single object filtered by predicate from the shared context.
 @param entity The NSManagedObject subclass of the entity.
 @param predicate The predicate to filter the objects before fetching.
 @return The object, or nil if none found.
 */
- (id)singleFetch:(Class)entity withPredicate:(NSPredicate *)predicate;

/**
 @name Fetch single objects
 Fetches a single object from the shared context or inserts one if none is found.
 @param entity The NSManagedObject subclass of the entity.
 @return The object.
 */
- (id)singleFetchOrInsert:(Class)entity;

/**
 @name Fetch single objects
 Fetches a single object from the shared context filtered by predicate or inserts one if none is found.
 @param entity The NSManagedObject subclass of the entity.
 @param predicate The predicate to filter the objects before fetching.
 @return The object.
 */
- (id)singleFetchOrInsert:(Class)entity withPredicate:(NSPredicate *)predicate;

#pragma mark - Fetch multiple objects

/**
 @name Fetch multiple objects
 Fetches all objects.
 @param entity The NSManagedObject subclass of the entity.
 @param context The context to fetch the objects from.
 @return An array of objects or nil if none found.
 */
+ (NSArray *)fetch:(Class)entity fromContext:(NSManagedObjectContext *)context;

/**
 @name Fetch multiple objects
 Fetches all objects filtered by predicate.
 @param entity The NSManagedObject subclass of the entity.
 @param context The context to fetch the objects from.
 @param predicate The predicate to filter the objects before fetching.
 @return An array of objects or nil if none found.
 */
+ (NSArray *)fetch:(Class)entity fromContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate;

/**
 @name Fetch multiple objects
 Fetches all objects, sorted.
 @param entity The NSManagedObject subclass of the entity.
 @param context The context to fetch the objects from.
 @param sortDescriptors An array of NSSortDescriptors.
 @return An array of objects or nil if none found.
 */
+ (NSArray *)fetch:(Class)entity
	   fromContext:(NSManagedObjectContext *)context
	withSortDescriptors:(NSArray *)sortDescriptors;

/**
 @name Fetch multiple objects
 Fetches all objects filtered by predicate, sorted.
 @param entity The NSManagedObject subclass of the entity.
 @param context The context to fetch the objects from.
 @param predicate The predicate to filter the objects before counting.
 @param sortDescriptors An array of NSSortDescriptors.
 @return An array of objects or nil if none found.
 */
+ (NSArray *)fetch:(Class)entity
	   fromContext:(NSManagedObjectContext *)context
	 withPredicate:(NSPredicate *)predicate
andSortDescriptors:(NSArray *)sortDescriptors;

/**
 @name Fetch multiple objects
 Fetches all objects filtered by predicate, sorted.
 @param entity The NSManagedObject subclass of the entity.
 @param context The context to fetch the objects from.
 @param predicate The predicate to filter the objects before counting.
 @param sortDescriptors An array of NSSortDescriptors.
 @param limit Limits the number of results returned. 0 disables.
 @return An array of objects or nil if none found.
 */
+ (NSArray *)fetch:(Class)entity
	   fromContext:(NSManagedObjectContext *)context
	 withPredicate:(NSPredicate *)predicate
andSortDescriptors:(NSArray *)sortDescriptors
	  limitResults:(NSUInteger)limit;

/**
 @name Fetch multiple objects
 Fetches all objects from the shared context.
 @param entity The NSManagedObject subclass of the entity.
 @return An array of objects or nil if none found.
 */
- (NSArray *)fetch:(Class)entity;

/**
 @name Fetch multiple objects
 Fetches all objects from the shared context filtered by predicate.
 @param entity The NSManagedObject subclass of the entity.
 @param predicate The predicate to filter the objects before fetching.
 @return An array of objects or nil if none found.
 */
- (NSArray *)fetch:(Class)entity withPredicate:(NSPredicate *)predicate;

/**
 @name Fetch multiple objects
 Fetches all objects from the shared context, sorted.
 @param entity The NSManagedObject subclass of the entity.
 @param context The context to fetch the objects from.
 @param sortDescriptors An array of NSSortDescriptors.
 @return An array of objects or nil if none found.
 */
- (NSArray *)fetch:(Class)entity withSortDescriptors:(NSArray *)sortDescriptors;

/**
 @name Fetch multiple objects
 Fetches all objects from the shared context filtered by predicate, sorted.
 @param entity The NSManagedObject subclass of the entity.
 @param predicate The predicate to filter the objects before counting.
 @param sortDescriptors An array of NSSortDescriptors.
 @return An array of objects or nil if none found.
 */
- (NSArray *)fetch:(Class)entity withPredicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)sortDescriptors;

/**
 @name Fetch multiple objects
 Fetches all objects filtered from the shared context by predicate, sorted.
 @param entity The NSManagedObject subclass of the entity.
 @param predicate The predicate to filter the objects before counting.
 @param sortDescriptors An array of NSSortDescriptors.
 @param limit Limits the number of results returned. 0 disables.
 @return An array of objects or nil if none found.
 */
- (NSArray *)fetch:(Class)entity
	 withPredicate:(NSPredicate *)predicate
andSortDescriptors:(NSArray *)sortDescriptors
	  limitResults:(NSUInteger)limit;

@end
