//  
//  NLCoreData.h
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

/**
 If an error occurs during a core data operation and DEBUG is defined, an exception is usually raised.
 Make sure not to define DEBUG in production.
 */

#import <Foundation/Foundation.h>

#import "NLCoreDataCommon.h"
#import "NSManagedObject+NLCoreData.h"
#import "NSManagedObjectContext+NLCoreData.h"
#import "NSFetchRequest+NLCoreData.h"
#import "NSFetchedResultsController+NLCoreData.h"

@class
NSManagedObjectModel,
NSPersistentStoreCoordinator,
NSManagedObjectContext;

#pragma mark -
@interface NLCoreData : NSObject

/**
 Model name. Set this before use, typically in application:didFinishLaunchingWithOptions:
 If your data model is named MyDataModel.xcdatamodeld, set modelName to @"MyDataModel".
 This is optional. If not explicitly set, NLCoreData uses CFBundleName for the main bundle.
 E.g., if the app is named "MyApp", the model should be named "MyApp".
 */
@property (strong, nonatomic) NSString*	modelName;

/**
 Whether or not the store exists. This is likely NO before it's used the first time only.
 Use it to check if the store needs to be seeded.
 */
@property (assign, nonatomic, readonly) BOOL storeExists;

/**
 Whether or not the store is encrypted.
 */
@property (assign, nonatomic, getter=isStoreEncrypted) BOOL storeEncrypted;

/**
 Options for the persistent store. Set to automigrate by default.
 */
@property (strong, nonatomic) NSDictionary* persistentStoreOptions;

/**
 The persistent store coordinator.
 */
@property (strong, nonatomic) NSPersistentStoreCoordinator*	storeCoordinator;

/**
 The managed object model.
 */
@property (strong, nonatomic) NSManagedObjectModel* managedObjectModel;

/**
 @name Path
 Filesystem path to the store as NSString and NSURL.
 */
- (NSString *)storePath;
- (NSURL *)storeURL;

#pragma mark - Lifecycle

/**
 @name Lifecycle
 The shared instance. Use this, not alloc/init.
 */
+ (NLCoreData *)shared;

/**
 @name Lifecycle
 Copies a preseeded database file to be used as your Core Data store.
 The filetype should be sqlite and it should conform to your model.
 @param filePath Path to the preseeded file.
 @warning This should be called before using Core Data on first run.
 */
- (void)useDatabaseFile:(NSString *)filePath;

/**
 @name Lifecycle
 @return A boolean on whether or not the operation succeeded.
 Resets the database (deletes all content).
 @warning If you use this, be sure to drop all references to managed objects beforehand.
 */
- (BOOL)resetDatabase;

@end
