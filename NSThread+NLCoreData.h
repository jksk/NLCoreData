//
//  NSThread+NLCoreData.h
//  NLCoreDataExample
//
//  Created by Jesper Skrufve on 23/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSThread (NLCoreData)

- (void)performBlock:(void (^)(void))block;
- (void)performBlockOnThread:(void (^)(void))block;
- (void)performBlockAndWaitOnThread:(void (^)(void))block;

@end
