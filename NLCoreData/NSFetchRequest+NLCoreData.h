//
//  NSFetchRequest+NLCoreData.h
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

@interface NSFetchRequest (NLCoreData)

/**
 @name Lifecycle
 A fetch request.
 @param entity The NSManagedObject subclass of the entity.
 @param context The context in which to execute the fetch request.
 @return The NSFetchRequest.
 */
+ (instancetype)fetchRequestWithEntity:(Class)entity context:(NSManagedObjectContext *)context;

/**
 @name Sorting
 Adds a sort descriptor to the fetch request. First added is primary, second added is secondary, etc.
 @param key The keypath to use when performing a comparison.
 @param ascending YES if the receiver specifies sorting in ascending order, otherwise NO.
 */
- (void)sortByKey:(NSString *)key ascending:(BOOL)ascending;

/**
 @name Sorting
 Adds a sort descriptor to the fetch request. First added is primary, second added is secondary, etc.
 @param key The keypath to use when performing a comparison.
 @param ascending YES if the receiver specifies sorting in ascending order, otherwise NO.
 @param selector The selector to use when performing a comparison.
 */
- (void)sortByKey:(NSString *)key ascending:(BOOL)ascending selector:(SEL)selector;

/**
 @name Predicate
 Sets predicate inline.
 @param predicateOrString A predicate or a predicate format string.
 */
- (void)setPredicateOrString:(id)predicateOrString, ...;

/**
 @name Configuration
 A default value for the includesSubentities setting of NSFetchRequests. Default is NO.
 @param includeSubentities
 @note Default is NO for historical reasons. Expect this to change in the next major version.
 */
+ (void)setIncludesSubentitiesByDefault:(BOOL)includesSubentities;
+ (BOOL)includesSubentitiesByDefault;

@end
