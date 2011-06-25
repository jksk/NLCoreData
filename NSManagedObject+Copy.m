//
//  NSManagedObject+Copy.m
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

// THESE METHODS AREN'T TESTED, USE AT YOUR OWN RISK

#import "NSManagedObject+Copy.h"
#import "NLCoreData.h"

@implementation NSManagedObject (Copy)

- (id)copyToSharedContext
{
	return [self copyToContext:[[NLCoreData shared] context]];
}

- (id)copyToContext:(NSManagedObjectContext *)context
{
	id object = [context objectWithID:[self objectID]];
	
	// attributes
	NSDictionary* attr = [[self entity] attributesByName];
	[attr enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
		[object setValue:obj forKey:key];
	}];
	
	// relationships
	NSDictionary* rels = [[self entity] relationshipsByName];
	[rels enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
		
		NSRelationshipDescription* rel = (NSRelationshipDescription *)obj;
		NSString* relName = [NSString stringWithFormat:@"%@", rel];
		
		if ([rel isToMany]) {
			NSMutableSet* source = [self mutableSetValueForKey:relName];
			NSMutableSet* cloned = [self mutableSetValueForKey:relName];
			
			for (id remoteObject in source) {
				id copiedRemoteObject = [remoteObject copyToContext:context];
				[cloned addObject:copiedRemoteObject];
			}
		}
		else {
			[object setValue:[self valueForKey:relName] forKey:relName];
		}
		
	}];
	
	return object;
}

- (id)cloneInSameContext
{
	return [self cloneInContext:[self managedObjectContext]];
}

- (id)cloneInSharedContext
{
	return [self cloneInContext:[[NLCoreData shared] context]];
}

- (id)cloneInContext:(NSManagedObjectContext *)context
{
	id object = [[self class] insertInContext:context];
	
	// attributes
	NSDictionary* attr = [[self entity] attributesByName];
	[attr enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
		[object setValue:obj forKey:key];
	}];
	
	// relationships
	NSDictionary* rels = [[self entity] relationshipsByName];
	[rels enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL* stop) {
		
		NSRelationshipDescription* rel = (NSRelationshipDescription *)obj;
		NSString* relName = [NSString stringWithFormat:@"%@", rel];
		
		if ([rel isToMany]) {
			NSMutableSet* source = [self mutableSetValueForKey:relName];
			NSMutableSet* cloned = [self mutableSetValueForKey:relName];
			
			for (id remoteObject in source) {
				id clonedRemoteObject = [remoteObject cloneInContext:context];
				[cloned addObject:clonedRemoteObject];
			}
		}
		else {
			[object setValue:[self valueForKey:relName] forKey:relName];
		}
		
	}];
	
	return object;
}

@end
