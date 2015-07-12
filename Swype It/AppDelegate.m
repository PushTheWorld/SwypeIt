//  AppDelegate.m
//  Swype It
//  Created by Andrew Keller on 6/21/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//  Purpose: Thie is the startign screen for the swype it game
//
// Local Controller Import
#import "AppDelegate.h"
#import "BaseNavigationViewController.h"
#import "StartScreenViewController.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIConstants.h"
// Other Imports

@interface AppDelegate ()

@end

@implementation AppDelegate
static BOOL isRunningTests(void) __attribute__((const));

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*TEST LOGIC*/
    if (isRunningTests()) {
        return YES;
    }
    /*RUN LOGIC*/
    /*Init window*/
    self.window                             = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    StartScreenViewController       *vc1    = [[StartScreenViewController alloc] init];
    BaseNavigationViewController    *nav    = [[BaseNavigationViewController alloc] initWithRootViewController:vc1];
    
    self.window.rootViewController          = nav;
    [self.window makeKeyAndVisible];
    
    /*Check the NSUserDefaults*/
    [self setNSUserDefaults];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setNSUserDefaults {
    BOOL isThisTheFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:kSINSUserDefaultFirstLaunch];
    if (isThisTheFirstLaunch == NO) {
        //set to no
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kSINSUserDefaultGameMode];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kSINSUserDefaultNumberOfItCoins];
        [[NSUserDefaults standardUserDefaults] setBool:YES   forKey:kSINSUserDefaultFirstLaunch];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
static BOOL isRunningTests(void) {
    NSDictionary* environment = [[NSProcessInfo processInfo] environment];
    NSString* injectBundle = environment[@"XCInjectBundle"];
    return [[injectBundle pathExtension] isEqualToString:@"octest"];
}

@end
