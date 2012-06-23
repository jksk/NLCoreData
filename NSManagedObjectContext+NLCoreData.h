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

typedef void(^NLCoreDataNotificationBlock)(NSNotification* note);

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
 @return The shared context for current thread. Lazily loaded if non-existant.
 */
+ (NSManagedObjectContext *)contextForThread;

/**
 @name Lifecycle
 Use if you want the shared context for another thread.
 @return The shared context for specified thread. Lazily loaded if non-existant.
 */
+ (NSManagedObjectContext *)contextForThread:(NSThread *)thread;

#pragma mark - Notifications

/**
 @name Notifications
 Merges receiver with another context.
 @parameter completion Optional block to run after merge.
 */
- (void)mergeWithContextOnThread:(NSThread *)thread completion:(void (^)(NSNotification* note))completion;

#pragma mark - Properties

/**
 @name Undo
 Enables/disables or checks if an NSUndoManager is present for the context.
 */
@property (assign, nonatomic, getter=isUndoEnabled) BOOL	undoEnabled;

@end
