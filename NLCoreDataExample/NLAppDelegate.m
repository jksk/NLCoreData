//
//  NLAppDelegate.m
//  NLCoreDataExample
//
//  Created by j on 27/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NLAppDelegate.h"
#import "User.h"
#import "Group.h"

@implementation NLAppDelegate

@synthesize
window = window_;

#pragma mark - Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[self window] makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

#pragma mark - Property Accessors

- (UIWindow *)window
{
	if (window_) return window_;
	
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	return window_;
}


@end
