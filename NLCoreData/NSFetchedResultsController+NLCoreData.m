//
//  NSFetchedResultsController+NLCoreData.m
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

#import "NSFetchedResultsController+NLCoreData.h"
#import "NLCoreData.h"

@implementation NSFetchedResultsController (NLCoreData)

- (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest
{
	return [self initWithFetchRequest:fetchRequest
				 managedObjectContext:[NSManagedObjectContext contextForThread]
				   sectionNameKeyPath:nil
							cacheName:nil];
}

- (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest cacheName:(NSString *)name
{
	return [self initWithFetchRequest:fetchRequest
				 managedObjectContext:[NSManagedObjectContext contextForThread]
				   sectionNameKeyPath:nil
							cacheName:name];
}

- (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest
		sectionNameKeyPath:(NSString *)sectionNameKeyPath
				 cacheName:(NSString *)name
{
	return [self initWithFetchRequest:fetchRequest
				 managedObjectContext:[NSManagedObjectContext contextForThread]
				   sectionNameKeyPath:sectionNameKeyPath
							cacheName:name];
}

- (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest managedObjectContext:(NSManagedObjectContext *)context
{
	return [self initWithFetchRequest:fetchRequest
				 managedObjectContext:context
				   sectionNameKeyPath:nil
							cacheName:nil];
}

- (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest
	  managedObjectContext:(NSManagedObjectContext *)context
				 cacheName:(NSString *)name
{
	return [self initWithFetchRequest:fetchRequest
				 managedObjectContext:context
				   sectionNameKeyPath:nil
							cacheName:name];
}

@end
