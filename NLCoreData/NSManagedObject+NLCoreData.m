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

#define EXCEPTION_FETCH	@"NLCoreData Fetch Exception"
#define EXCEPTION_COUNT	@"NLCoreData Count Exception"

@implementation NSManagedObject (NLCoreData)

#pragma mark - Heavy lifting

+ (id)fetchSingleFromContext:(NSManagedObjectContext *)context withObjectID:(NSManagedObjectID *)objectID
{
	id object = [context objectRegisteredForID:objectID];
	if (object) return object;
	
	object = [context objectWithID:objectID];
	if (![object isFault]) return object;
	
	NSError* error = nil;
	object = [context existingObjectWithID:objectID error:&error];
	
#ifdef DEBUG
	if (error)
		[NSException raise:EXCEPTION_FETCH
					format:@"Error getting object with id %@: %@", objectID, [error localizedDescription]];
#endif
	
	return object;
}

+ (NSArray *)fetchFromContext:(NSManagedObjectContext *)context
				withPredicate:(NSPredicate *)predicate
		   andSortDescriptors:(NSArray *)sortDescriptors
				 limitResults:(NSUInteger)limit
{
	NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntity:[self class] inContext:context];
	[request setReturnsObjectsAsFaults:NO];
	
	if (predicate) [request setPredicate:predicate];
	if (sortDescriptors) [request setSortDescriptors:sortDescriptors];
	if (limit > 0) [request setFetchLimit:limit];
	
	NSError* error = nil;
	NSArray* results = [context executeFetchRequest:request error:&error];
	
#ifdef DEBUG
	if (!results) [NSException raise:EXCEPTION_FETCH format:@"Error fetching: %@", [error localizedDescription]];
#endif
	return results;
}

+ (id)fetchSingleFromContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate
{
	NSArray* objects = [self fetchFromContext:context
								withPredicate:predicate
						   andSortDescriptors:nil
								 limitResults:0];
#ifdef DEBUG
	if ([objects count] > 1)
		[NSException raise:EXCEPTION_FETCH format:@"Expected single object, retrieved %i objects", [objects count]];
#endif
	return [objects count] ? [objects objectAtIndex:0] : nil;
}

+ (id)fetchSingleOrInsertInContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate
{
	id object = [self fetchSingleFromContext:context withPredicate:predicate];
	if (!object) object = [[self class] insertInContext:context];
	return object;
}

+ (id)insertInContext:(NSManagedObjectContext *)context
{
	return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
										   inManagedObjectContext:context];
}

+ (NSUInteger)countInContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate
{
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription
						entityForName:NSStringFromClass([self class])
						inManagedObjectContext:context]];
	
	if (predicate) [request setPredicate:predicate];
	
	NSError* error = nil;
	NSUInteger count = [context countForFetchRequest:request error:&error];
	
#ifdef DEBUG
	if (error) [NSException raise:EXCEPTION_COUNT format:@"Count Error: %@", [error localizedDescription]];
#endif
	return count;
}

+ (void)deleteFromContext:(NSManagedObjectContext *)context withPredicate:(NSPredicate *)predicate
{
	NSArray* objects = [self fetchFromContext:context
								withPredicate:predicate
						   andSortDescriptors:nil
								 limitResults:0];
	
	for (NSManagedObject* object in objects) [context deleteObject:object];
}

+ (void)fetchObjectIDsWithPredicate:(NSPredicate *)predicate
				 andSortDescriptors:(NSArray *)sortDescriptors
					   limitResults:(NSUInteger)limit
						 completion:(void (^)(NSArray *))completion
{
#ifdef DEBUG
	if (!completion)
		[NSException raise:EXCEPTION_FETCH format:@"completion block must not be nil"];
#endif
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		
		NSArray* objects = [self fetchWithPredicate:predicate andSortDescriptors:sortDescriptors limitResults:limit];
		NSMutableArray* objectIDs = [NSMutableArray arrayWithCapacity:[objects count]];
		
		for (NSManagedObject* obj in objects)
			[objectIDs addObject:[obj objectID]];
		
		dispatch_async(dispatch_get_main_queue(), ^{ completion([NSArray arrayWithArray:objectIDs]); });
	});
}

#pragma mark - Insert convenience methods

+ (id)insert
{
	return [self insertInContext:[NSManagedObjectContext contextForThread]];
}

#pragma mark - Count convenience methods

+ (NSUInteger)count
{
	return [self countInContext:[NSManagedObjectContext contextForThread] withPredicate:nil];
}

+ (NSUInteger)countWithPredicate:(NSPredicate *)predicate
{
	return [self countInContext:[NSManagedObjectContext contextForThread] withPredicate:predicate];
}

#pragma mark - Delete convenience methods

- (void)delete
{
	[[self managedObjectContext] deleteObject:self];
}

+ (void)delete
{
	[self deleteFromContext:[NSManagedObjectContext contextForThread] withPredicate:nil];
}

+ (void)deleteWithPredicate:(NSPredicate *)predicate
{
	[self deleteFromContext:[NSManagedObjectContext contextForThread] withPredicate:predicate];
}

#pragma mark - Fetch single objects convenience methods

+ (id)fetchSingleWithObjectID:(NSManagedObjectID *)objectID
{
	return [self fetchSingleFromContext:[NSManagedObjectContext contextForThread] withObjectID:objectID];
}

+ (id)fetchSingle
{
	return [self fetchSingleFromContext:[NSManagedObjectContext contextForThread] withPredicate:nil];
}

+ (id)fetchSingleWithPredicate:(NSPredicate *)predicate
{
	return [self fetchSingleFromContext:[NSManagedObjectContext contextForThread] withPredicate:predicate];
}

+ (id)fetchSingleOrInsert
{
	return [self fetchSingleOrInsertInContext:[NSManagedObjectContext contextForThread] withPredicate:nil];
}

+ (id)fetchSingleOrInsertWithPredicate:(NSPredicate *)predicate
{
	return [self fetchSingleOrInsertInContext:[NSManagedObjectContext contextForThread] withPredicate:predicate];
}

#pragma mark - Fetch multiple objects convenience methods

+ (NSArray *)fetch
{
	return [self fetchFromContext:[NSManagedObjectContext contextForThread]
					withPredicate:nil
			   andSortDescriptors:nil
					 limitResults:0];
}

+ (NSArray *)fetchWithPredicate:(NSPredicate *)predicate
{
	return [self fetchFromContext:[NSManagedObjectContext contextForThread]
					withPredicate:predicate
			   andSortDescriptors:nil
					 limitResults:0];
}

+ (NSArray *)fetchWithPredicate:(NSPredicate *)predicate sortByKey:(NSString *)key ascending:(BOOL)ascending
{
	NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
	return [self fetchFromContext:[NSManagedObjectContext contextForThread]
					withPredicate:predicate
			   andSortDescriptors:[NSArray arrayWithObject:sort]
					 limitResults:0];
}

+ (NSArray *)fetchAndSortByKey:(NSString *)key ascending:(BOOL)ascending
{
	NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
	return [self fetchFromContext:[NSManagedObjectContext contextForThread]
					withPredicate:nil
			   andSortDescriptors:[NSArray arrayWithObject:sort]
					 limitResults:0];
}

+ (NSArray *)fetchWithSortDescriptors:(NSArray *)sortDescriptors
{
	return [self fetchFromContext:[NSManagedObjectContext contextForThread]
					withPredicate:nil
			   andSortDescriptors:sortDescriptors
					 limitResults:0];
}

+ (NSArray *)fetchWithPredicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)sortDescriptors
{
	return [self fetchFromContext:[NSManagedObjectContext contextForThread]
					withPredicate:predicate
			   andSortDescriptors:sortDescriptors
					 limitResults:0];
}

+ (NSArray *)fetchWithPredicate:(NSPredicate *)predicate
			 andSortDescriptors:(NSArray *)sortDescriptors
				   limitResults:(NSUInteger)limit
{
	return [self fetchFromContext:[NSManagedObjectContext contextForThread]
					withPredicate:predicate
			   andSortDescriptors:sortDescriptors
					 limitResults:limit];
}

#pragma mark - Miscellaneous

- (NSArray *)managedAttributeNames
{
	return [[[self entity] attributesByName] allKeys];
}

- (BOOL)isNew
{
	return [[self committedValuesForKeys:nil] count] == 0;
}

- (void)touch
{
	NSArray* attributes = [self managedAttributeNames];
	
	if ([attributes count]) {
		
		NSString* key = [attributes objectAtIndex:0];
		[self setValue:[self valueForKey:key] forKey:key];
	}
}

@end
