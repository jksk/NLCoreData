//
//  NSManagedObjectContext+NLCoreData.h
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

typedef void(^NLCoreDataSaveCompleteBlock)(BOOL success);

#pragma mark -
@interface NSManagedObjectContext (NLCoreData)

#pragma mark - Lifecycle

/**
 @name Lifecycle
 Saves the context.
 */
- (BOOL)save;

/**
 @name Lifecycle
 Saves the context and all parent contexts asynchronously.
 */
- (void)saveNestedAsynchronous;

/**
 @name Lifecycle
 Saves the context and all parent contexts asynchronously.
 @param block Calback for when save is complete
 */
- (void)saveNestedAsynchronousWithCallback:(NLCoreDataSaveCompleteBlock)block;

/**
 @name Lifecycle
 Saves the context and all parent contexts synchronously.
 */
- (BOOL)saveNested;

/**
 @name Lifecycle
 Rebuilds all contexts (the background context, the store context and the main context).
 @warning You probably don't want to call this manually.
 */
+ (void)rebuildAllContexts;

/**
 @name Lifecycle
 @return The main thread context. Lazily loaded if non-existant.
 */
+ (NSManagedObjectContext *)mainContext;

/**
 @name Lifecycle
 @return The context tied to the persistent store. Lazily loaded if non-existant.
 */
+ (NSManagedObjectContext *)storeContext;

/**
 @name Lifecycle
 @return The background thread context. Lazily loaded if non-existant.
 */
+ (NSManagedObjectContext *)backgroundContext;

#pragma mark - Properties

/**
 @name Undo
 Enables/disables or checks if an NSUndoManager is present for the context.
 */
@property (assign, nonatomic, getter=isUndoEnabled) BOOL	undoEnabled;

@end
