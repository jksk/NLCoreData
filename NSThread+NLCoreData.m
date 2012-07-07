//
//  NSThread+NLCoreData.m
//  NLCoreDataExample
//
//  Created by Jesper Skrufve on 23/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSThread+NLCoreData.h"

@implementation NSThread (NLCoreData)

- (void)performBlock:(void (^)(void))block
{
	block();
}

- (void)performBlockOnThread:(void (^)(void))block
{
	[self performSelector:@selector(performBlock:) onThread:self withObject:[block copy] waitUntilDone:NO];
}

@end
