//
//  AppDelegate.m
//
//  Initially Created by Jean-André Santoni + Nicolas Morin on 17/07/13.
//  Copyright (c) 2014 http://kplusn.com. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
NSArray* chapters;
NSArray* colors;
int current;

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_rootViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    chapters = [NSArray arrayWithObjects:
                @"Couture géométrique",
                @"Introduction",
                @"Conseils techniques",
                @"Le top à manches kimono",
                @"La cape cache-ccœur",
                @"La robe « Y »",
                @"La robe modulaire à plis",
                @"Le chauffe-épaules",
                @"Le tablier girly",
                @"La ceinture Obi origami",
                @"Le bandeau vintage",
                @"La broche pétales",
                @"Une pochette pour tablettes",
                @"Et maintenant?",
                nil];
    
    current = 0;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
