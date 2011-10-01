//
//  NLSingleton.m
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

#import "NLSingleton.h"

static NSMutableDictionary* Shared_ = nil;

@interface NLSingleton ()

+ (void)initializeShared;

@end

#pragma mark -
@implementation NLSingleton

+ (id)shared
{
	@synchronized(self) {
        
        [self initializeShared];
        id instance = [Shared_ objectForKey:NSStringFromClass([self class])];
        
		if (!instance) {
			instance = [[[self class] alloc] init];
			[Shared_ setObject:instance forKey:NSStringFromClass([self class])];
		}
        
        return instance;
	}
    
    return nil;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self) {
        
        [self initializeShared];
        id instance = [Shared_ objectForKey:NSStringFromClass([self class])];
        
		if (!instance) {
			instance = [super allocWithZone:zone];
			[Shared_ setObject:instance forKey:NSStringFromClass([self class])];
		}
        
        return instance;
	}
    
	return nil;
}

+ (void)initializeShared
{
	if (!Shared_) {
		Shared_ = [[NSMutableDictionary alloc] init];
	}
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

@end
