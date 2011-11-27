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

@interface NSManagedObjectContext (NLCoreData)

#pragma mark - Lifecycle

/**
 @name Lifecycle
 Saves the context.
 */
- (BOOL)save;

/**
 @name Lifecycle
 Creates a new context. Use this is you need a secondary context for the same thread.
 */
+ (NSManagedObjectContext *)context;

/**
 @name Lifecycle
 Typically use this instead of +context above.
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
 Notifies context with changes when a save is performed.
 @param context The context to notify.
 */
- (void)notifyContextOnSave:(NSManagedObjectContext *)context;

/**
 @name Notifications
 Stops notifying context with changes when a save is performed.
 @param context The context to stop notifying.
 */
- (void)stopNotifyingContextOnSave:(NSManagedObjectContext *)context;

#pragma mark - Properties

/**
 @name Undo
 Enables/disables or checks if an NSUndoManager is present for the context.
 */
@property (assign, nonatomic, getter=isUndoEnabled) BOOL	undoEnabled;

@end
