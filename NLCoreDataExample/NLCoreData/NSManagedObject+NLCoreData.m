//
//  NSManagedObject+NLCoreData.m
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

#import "NSManagedObject+NLCoreData.h"
#import "NLCoreData.h"

@implementation NSManagedObject (NLCoreData)

#pragma mark - New

+ (id)insertInContext:(NSManagedObjectContext *)context
{
	return [NLCoreData insert:[self class] inContext:context];
}

+ (id)insertInSharedContext
{
	return [[NLCoreData shared] insert:[self class]];
}

#pragma mark - Count

+ (NSUInteger)countInContext:(NSManagedObjectContext *)context
{
	return [NLCoreData count:[self class] inContext:context withPredicate:nil];
}

+ (NSUInteger)countInContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate
{
	return [NLCoreData count:[self class] inContext:context withPredicate:predicate];
}

+ (NSUInteger)countInSharedContext
{
	return [[NLCoreData shared] count:[self class] withPredicate:nil];
}

+ (NSUInteger)countInSharedContextWithPredicate:(NSPredicate *)predicate
{
	return [[NLCoreData shared] count:[self class] withPredicate:predicate];
}

#pragma mark - Delete

- (void)deleteFromContext
{
	[[self managedObjectContext] deleteObject:self];
}

+ (void)deleteFromContext:(NSManagedObjectContext *)context
{
	[NLCoreData delete:[self class] fromContext:context withPredicate:nil];
}

+ (void)deleteFromContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate
{
	[NLCoreData delete:[self class] fromContext:context withPredicate:predicate];
}

+ (void)deleteFromSharedContext
{
	[[NLCoreData shared] delete:[self class] withPredicate:nil];
}

+ (void)deleteFromSharedContextWithPredicate:(NSPredicate *)predicate
{
	[[NLCoreData shared] delete:[self class] withPredicate:predicate];
}

#pragma mark - Fetch single objects

+ (id)singleFetchFromContext:(NSManagedObjectContext *)context
{
	return [NLCoreData fetch:[self class] fromContext:context withPredicate:nil];
}

+ (id)singleFetchFromContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate
{
	return [NLCoreData fetch:[self class] fromContext:context withPredicate:predicate];
}

+ (id)singleFetchOrInsertInContext:(NSManagedObjectContext *)context
{
	return [NLCoreData singleFetchOrInsert:[self class] fromContext:context];
}

+ (id)singleFetchOrInsertInContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate
{
	return [NLCoreData singleFetchOrInsert:[self class] fromContext:context withPredicate:predicate];
}

+ (id)singleFetchFromSharedContext
{
	return [[NLCoreData shared] singleFetch:[self class] withPredicate:nil];
}

+ (id)singleFetchFromSharedContextWithPredicate:(NSPredicate *)predicate
{
	return [[NLCoreData shared] singleFetch:[self class] withPredicate:predicate];
}

+ (id)singleFetchOrInsertInSharedContext
{
	return [[NLCoreData shared] singleFetchOrInsert:[self class]];
}

+ (id)singleFetchOrInsertInSharedContextWithPredicate:(NSPredicate *)predicate
{
	return [[NLCoreData shared] singleFetchOrInsert:[self class] withPredicate:predicate];
}

#pragma mark - Fetch multiple objects

+ (NSArray *)fetchFromContext:(NSManagedObjectContext *)context
{
	return [NLCoreData fetch:[self class]
				 fromContext:context
			   withPredicate:nil
		  andSortDescriptors:nil
				limitResults:0];
}

+ (NSArray *)fetchFromContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate
{
	return [NLCoreData fetch:[self class]
				 fromContext:context
			   withPredicate:predicate
		  andSortDescriptors:nil
				limitResults:0];
}

+ (NSArray *)fetchFromContext:(NSManagedObjectContext *)context withSortDescriptors:(NSArray *)sortDescriptors
{
	return [NLCoreData fetch:[self class]
				 fromContext:context
			   withPredicate:nil
		  andSortDescriptors:sortDescriptors
				limitResults:0];
}

+ (NSArray *)fetchFromContext:(NSManagedObjectContext *)context
				withPredicate:(NSPredicate *)predicate
		   andSortDescriptors:(NSArray *)sortDescriptors
{
	return [NLCoreData fetch:[self class]
				 fromContext:context
			   withPredicate:predicate
		  andSortDescriptors:nil
				limitResults:0];
}

+ (NSArray *)fetchFromContext:(NSManagedObjectContext *)context
				withPredicate:(NSPredicate *)predicate
		   andSortDescriptors:(NSArray *)sortDescriptors
				 limitResults:(NSUInteger)limit
{
	return [NLCoreData fetch:[self class]
				 fromContext:context
			   withPredicate:predicate
		  andSortDescriptors:sortDescriptors
				limitResults:limit];
}

+ (NSArray *)fetchFromSharedContext
{
	return [[NLCoreData shared] fetch:[self class]
						withPredicate:nil
				   andSortDescriptors:nil
						 limitResults:0];
}

+ (NSArray *)fetchFromSharedContextWithPredicate:(NSPredicate *)predicate
{
	return [[NLCoreData shared] fetch:[self class]
						withPredicate:predicate
				   andSortDescriptors:nil
						 limitResults:0];
}

+ (NSArray *)fetchFromSharedContextWithSortDescriptors:(NSArray *)sortDescriptors
{
	return [[NLCoreData shared] fetch:[self class]
						withPredicate:nil
				   andSortDescriptors:sortDescriptors
						 limitResults:0];
}

+ (NSArray *)fetchFromSharedContextWithPredicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)sortDescriptors
{
	return [[NLCoreData shared] fetch:[self class]
						withPredicate:predicate
				   andSortDescriptors:sortDescriptors
						 limitResults:0];
}

+ (NSArray *)fetchFromSharedContextWithPredicate:(NSPredicate *)predicate
							  andSortDescriptors:(NSArray *)sortDescriptors
									limitResults:(NSUInteger)limit
{
	return [[NLCoreData shared] fetch:[self class]
						withPredicate:predicate
				   andSortDescriptors:sortDescriptors
						 limitResults:limit];
}

#pragma mark - Miscellaneous

- (BOOL)isNew
{
	return [[self committedValuesForKeys:nil] count] == 0;
}

@end
