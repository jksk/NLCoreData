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

#pragma mark - Inserting

/**
 @name Inserting
 
 */
+ (id)insert;
+ (id)insertInContext:(NSManagedObjectContext *)context;

#pragma mark - Deleting

/**
 @name Deleting
 
 */
- (void)delete;

/**
 @name Deleting
 
 */
+ (void)deleteWithRequest:(void (^)(NSFetchRequest* request))block;
+ (void)deleteWithRequest:(void (^)(NSFetchRequest* request))block context:(NSManagedObjectContext *)context;

/**
 @name Deleting
 
 */
+ (void)deleteWithPredicate:(id)predicateOrString, ...;
+ (void)deleteRange:(NSRange)range withPredicate:(id)predicateOrString, ...;
+ (void)deleteRange:(NSRange)range
		  sortByKey:(NSString *)keyPath
		  ascending:(BOOL)ascending
	  withPredicate:(id)predicateOrString, ...;

#pragma mark - Counting

/**
 @name Counting
 
 */
+ (NSUInteger)countWithPredicate:(id)predicateOrString, ...;
+ (NSUInteger)countWithRequest:(void (^)(NSFetchRequest* request))block;
+ (NSUInteger)countWithRequest:(void (^)(NSFetchRequest* request))block context:(NSManagedObjectContext *)context;

#pragma mark - Fetching

/**
 @name Fetching
 
 */
+ (id)fetchWithObjectID:(NSManagedObjectID *)objectID;
+ (id)fetchWithObjectID:(NSManagedObjectID *)objectID context:(NSManagedObjectContext *)context;

/**
 @name Fetching
 
 */
+ (NSArray *)fetchWithRequest:(void (^)(NSFetchRequest* request))block;
+ (NSArray *)fetchWithRequest:(void (^)(NSFetchRequest* request))block context:(NSManagedObjectContext *)context;

/**
 @name Fetching
 
 */
+ (NSArray *)fetchWithPredicate:(id)predicateOrString, ...;
+ (NSArray *)fetchRange:(NSRange)range withPredicate:(id)predicateOrString, ...;
+ (NSArray *)fetchRange:(NSRange)range
			  sortByKey:(NSString *)keyPath
			  ascending:(BOOL)ascending
		  withPredicate:(id)predicateOrString, ...;

/**
 @name Fetching
 
 */
+ (id)fetchSingle:(NSUInteger)index withPredicate:(id)predicateOrString, ...;
+ (id)fetchSingle:(NSUInteger)index
		sortByKey:(NSString *)keyPath
		ascending:(BOOL)ascending
	withPredicate:(id)predicateOrString, ...;

/**
 @name Fetching
 
 */
+ (id)fetchOrInsertSingle:(NSUInteger)index withPredicate:(id)predicateOrString, ...;
+ (id)fetchOrInsertSingle:(NSUInteger)index
				sortByKey:(NSString *)keyPath
				ascending:(BOOL)ascending
			withPredicate:(id)predicateOrString, ...;

/**
 @name Fetching
 
 */
+ (void)fetchAsynchronouslyWithRequest:(void (^)(NSFetchRequest* request))block
							completion:(void (^)(NSArray* objects))completion;

@end
