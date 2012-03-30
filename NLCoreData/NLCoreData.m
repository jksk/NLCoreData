//
//  NLCoreData.m
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
#import "NLCoreData.h"

@implementation NLCoreData

@synthesize
modelName			= modelName_,
storeCoordinator	= storeCoordinator_,
managedObjectModel	= managedObjectModel_;

#pragma mark - Lifecycle

+ (NLCoreData *)shared
{
	static dispatch_once_t onceToken;
	__strong static id NLCoreDataSingleton_ = nil;
	
	dispatch_once(&onceToken, ^{ NLCoreDataSingleton_ = [[self alloc] init]; });
	return NLCoreDataSingleton_;
}

- (void)useDatabaseFile:(NSString *)filePath
{
	if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
#ifdef DEBUG
		[NSException raise:NLCoreDataExceptions.fileExist format:@"%@", filePath];
#endif
		return;
	}
	
	NSError* error;
	
	if (![[NSFileManager defaultManager] copyItemAtPath:filePath toPath:[self storePath] error:&error]) {
#ifdef DEBUG
		[NSException raise:NLCoreDataExceptions.fileCopy format:@"%@", [error localizedDescription]];
#endif
	}
}

#pragma mark - Property Accessors

- (NSString *)modelName
{
	if (modelName_) return modelName_;
	
	modelName_ = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
	return modelName_;
}

- (NSString *)storePath
{
	return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
			stringByAppendingPathComponent:[[self modelName] stringByAppendingString:@".sqlite"]];
}

- (NSURL *)storeURL
{
	NSURL* path = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory
														  inDomains:NSUserDomainMask] lastObject];
	
	return [path URLByAppendingPathComponent:[[self modelName] stringByAppendingString:@".sqlite"]];
}

- (void)setStoreEncrypted:(BOOL)storeEncrypted
{
	NSString* encryption		= storeEncrypted ? NSFileProtectionComplete : NSFileProtectionNone;
	NSDictionary* attributes	= [NSDictionary dictionaryWithObject:encryption forKey:NSFileProtectionKey];
	NSError* error;
	
	if (![[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:[self storePath] error:&error]) {
#ifdef DEBUG		
		[NSException raise:NLCoreDataExceptions.encryption format:@"%@", [error localizedDescription]];
#endif
	}
}

- (BOOL)storeExists
{
	return [[NSFileManager defaultManager] fileExistsAtPath:[self storePath]];
}

- (BOOL)isStoreEncrypted
{
	NSError* error;
	NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[self storePath] error:&error];
	
	if (!attributes) {
#ifdef DEBUG
		[NSException raise:NLCoreDataExceptions.encryption format:@"%@", [error localizedDescription]];
#endif
		return NO;
	}
	
	return [[attributes objectForKey:NSFileProtectionKey] isEqualToString:NSFileProtectionComplete];
}

- (NSPersistentStoreCoordinator *)storeCoordinator
{
	if (storeCoordinator_) return storeCoordinator_;
	
	storeCoordinator_				= [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:
									   [self managedObjectModel]];
	NSMutableDictionary* options	= [NSMutableDictionary dictionary];
	NSError* error;
	
	[options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
	
	if (![storeCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType
										 configuration:nil
												   URL:[self storeURL]
											   options:options
												 error:&error]) {
#ifdef DEBUG
		NSDictionary* meta	= [NSPersistentStoreCoordinator
							   metadataForPersistentStoreOfType:nil URL:[self storeURL] error:nil];
		NSString* equiv		= ([[[error userInfo] valueForKeyPath:@"sourceModel"] isEqual:
								[[error userInfo] valueForKeyPath:@"destinationModel"]]) ? @"YES" : @"NO";
		
		NSLog(@"metaData: %@", meta);
		NSLog(@"source and dest equivalent? %@", equiv);
		NSLog(@"failreason: %@", [[error userInfo] valueForKeyPath:@"reason"]);
		
		[NSException raise:NLCoreDataExceptions.persistentStore format:@"%@", [error localizedDescription]];
#endif
	}
	
	return storeCoordinator_;
}

- (NSManagedObjectModel *)managedObjectModel
{
	if (managedObjectModel_) return managedObjectModel_;
	
	NSURL* url			= [[NSBundle mainBundle] URLForResource:[self modelName] withExtension:@"momd"];
	managedObjectModel_	= [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
	
	return managedObjectModel_;
}

@end
