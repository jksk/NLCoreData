//
//  NSManagedObject+Misc.m
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
// aggregateOperation by Jeff Lamarche:
// http://iphonedevelopment.blogspot.com/2010/11/nsexpression.html
// 

#import "NSManagedObject+Misc.h"

@implementation NSManagedObject (Misc)

- (BOOL)isNew
{
	return [[self committedValuesForKeys:nil] count] == 0;
}

+ (NSNumber *)aggregateOperation:(NSString *)function
					 onAttribute:(NSString *)attributeName
				   withPredicate:(NSPredicate *)predicate
		  inManagedObjectContext:(NSManagedObjectContext *)context
{
	NSArray* attr = [NSArray
					 arrayWithObject:[NSExpression
									  expressionForKeyPath:attributeName]];
	NSExpression* expr = [NSExpression
						  expressionForFunction:function
						  arguments:attr];
	NSExpressionDescription* description = [[[NSExpressionDescription alloc]
											 init] autorelease];
	[description setName:@"result"];
	[description setExpression:expr];
	[description setExpressionResultType:NSInteger64AttributeType];
	
	NSArray* properties = [NSArray arrayWithObject:description];
	NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
	[request setPropertiesToFetch:properties];
	[request setResultType:NSDictionaryResultType];
	
	if (predicate) {
		[request setPredicate:predicate];
	}
	
	NSEntityDescription* entity = [NSEntityDescription
								   entityForName:NSStringFromClass([self class])
								   inManagedObjectContext:context];
	[request setEntity:entity];
	
	NSDictionary* results = [[context executeFetchRequest:request error:nil]
							 objectAtIndex:0];
	NSNumber* value = [results objectForKey:@"result"];
	return value;
}

@end
