//
//  NSFetchRequest+NLCoreData.m
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

#import <objc/runtime.h>
#import "NSFetchRequest+NLCoreData.h"
#import "NLCoreData.h"

typedef void(^NLCoreDataFetchRequestBlock)(NSFetchRequest* request);

const static void* NLCoreDataFetchRequestDefaultsBlockKey = "NLCoreDataFetchRequestDefaultsBlockKey";

@implementation NSFetchRequest (NLCoreData)

+ (void)setDefaults:(void (^)(NSFetchRequest *))block
{
	uintptr_t policy = block ? OBJC_ASSOCIATION_COPY : OBJC_ASSOCIATION_ASSIGN;
	
	objc_setAssociatedObject(self, NLCoreDataFetchRequestDefaultsBlockKey, block, policy);
}

+ (NSFetchRequest *)fetchRequestWithEntity:(Class)entity
{
	return [self fetchRequestWithEntity:entity context:[NSManagedObjectContext contextForThread]];
}

+ (NSFetchRequest *)fetchRequestWithEntity:(Class)entity context:(NSManagedObjectContext *)context
{
	NSFetchRequest* request = [[NSFetchRequest alloc] init];
	
	[request setEntity:[NSEntityDescription
						entityForName:NSStringFromClass(entity)
						inManagedObjectContext:context]];
	
	NLCoreDataFetchRequestBlock block = objc_getAssociatedObject(self, NLCoreDataFetchRequestDefaultsBlockKey);
	
	if (block)
		block(request);
	
	return request;
}

- (void)sortByKey:(NSString *)key ascending:(BOOL)ascending
{
	NSSortDescriptor* sortDescriptor	= [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending];
	NSMutableArray* newDescriptors		= [NSMutableArray array];
	NSArray* existingDescriptors		= [self sortDescriptors];
	
	if (existingDescriptors)
		[newDescriptors addObjectsFromArray:existingDescriptors];
	
	[newDescriptors addObject:sortDescriptor];
	[self setSortDescriptors:newDescriptors];
}

@end
