//  AppDelegate.m
//  Swype It
//  Created by Andrew Keller on 6/21/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//  Purpose: Thie is the startign screen for the swype it game
//
// Local Controller Import
#import "AppDelegate.h"
#import "BaseNavigationViewController.h"
#import "SIGameController.h"
// Framework Import
#import <Crashlytics/Crashlytics.h>
#import <Fabric/Fabric.h>
#import <Instabug/Instabug.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "FXReachability.h"
#import "MKStoreKit.h"
#import "NHNetworkTime.h"
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
    [Fabric with:@[CrashlyticsKit]];
    
    /*Start Instabug*/
    [Instabug startWithToken:@"dd30ee11bb2fde9bf61f850ba2d73b30" captureSource:IBGCaptureSourceUIKit invocationEvent:IBGInvocationEventTwoFingersSwipeLeft];
    [Instabug setWillShowStartAlert: NO];
    
    /*FXReachability*/
    [FXReachability sharedInstance].host = @"google.com";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatus) name:FXReachabilityStatusDidChangeNotification object:nil];
    
    /*Check the NSUserDefaults*/
    [self setNSUserDefaults];
    
    /*Get In App Purcahses Up and Running*/
    [self configureMKStoreKit];
    
    /*Setup Sound Manager*/
    
    /*Start the shared network clock*/
    [[NHNetworkClock sharedNetworkClock] syncWithComplete:nil];
    
    
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
        [[NSUserDefaults standardUserDefaults] setBool:NO                           forKey:kSINSUserDefaultOneHandMode];
        [[NSUserDefaults standardUserDefaults] setBool:NO                           forKey:kSINSUserDefaultPremiumUser];
        [[NSUserDefaults standardUserDefaults] setBool:NO                           forKey:kSINSUserDefaultFreePrizeGiven];
        [[NSUserDefaults standardUserDefaults] setBool:YES                          forKey:kSINSUserDefaultFirstLaunch];
        [[NSUserDefaults standardUserDefaults] setBool:YES                          forKey:kSINSUserDefaultSoundIsAllowedBackground];
        [[NSUserDefaults standardUserDefaults] setBool:YES                          forKey:kSINSUserDefaultSoundIsAllowedFX];
        [[NSUserDefaults standardUserDefaults] setInteger:SIGameModeTwoHand         forKey:kSINSUserDefaultGameMode];
        [[NSUserDefaults standardUserDefaults] setInteger:0                         forKey:kSINSUserDefaultLifetimeGamesPlayed];
        [[NSUserDefaults standardUserDefaults] setInteger:0                         forKey:kSINSUserDefaultGameMode];
        [[NSUserDefaults standardUserDefaults] setInteger:NUMBER_OF_MONKEYS_INIT    forKey:kSINSUserDefaultNumberOfMonkeys];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:kSINSUserDefaultLifetimeHighScore];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:kSINSUserDefaultPointsTowardsFreeCoin];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:kSINSUserDefaultLifetimePointsEarned];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:kSINSUserDefaultNumberConsecutiveAppLaunches];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date]              forKey:kSINSUserDefaultLastLaunchDate];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date]              forKey:kSINSUserDefaultLastPrizeAwardedDate];
        [[NSUserDefaults standardUserDefaults] setBool:NO                           forKey:kSINSUserDefaultUserTipShownPowerUpFallingMonkey];
        [[NSUserDefaults standardUserDefaults] setBool:NO                           forKey:kSINSUserDefaultUserTipShownPowerUpRapidFire];
        [[NSUserDefaults standardUserDefaults] setBool:NO                           forKey:kSINSUserDefaultUserTipShownPowerUpTimeFreeze];
        [[NSUserDefaults standardUserDefaults] setBool:NO                           forKey:kSINSUserDefaultInstabugDemoShown];
        [[NSUserDefaults standardUserDefaults] setBool:NO                           forKey:kSINSUserDefaultUserTipShownPopupContinue];
        [[NSUserDefaults standardUserDefaults] setBool:NO                           forKey:kSINSUserDefaultFirstGame];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (void)configureMKStoreKit {
    [[MKStoreKit sharedKit] startProductRequest];
    [[MKStoreKit sharedKit] setDefaultCredits:[NSNumber numberWithInt:0] forConsumableIdentifier:kSIIAPConsumableIDCoins];
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductsAvailableNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      /*Good Debug line to see if MKStoreKit is working*/
                                                      NSLog(@"Products available: %@", [[MKStoreKit sharedKit] availableProducts]);
                                                  }];
}
static BOOL isRunningTests(void) {
    NSDictionary* environment = [[NSProcessInfo processInfo] environment];
    NSString* injectBundle = environment[@"XCInjectBundle"];
    return [[injectBundle pathExtension] isEqualToString:@"octest"];
}
#pragma mark - FXReachability Methods
- (void)updateStatus {
    NSLog(@"Internet Status:\n\n%@\n\n",[self statusText]);
}
- (NSString *)statusText
{
    switch ([FXReachability sharedInstance].status)
    {
        case FXReachabilityStatusUnknown:
        {
            return @"Status Unknown";
        }
        case FXReachabilityStatusNotReachable:
        {
            return @"Not reachable";
        }
        case FXReachabilityStatusReachableViaWWAN:
        {
            return @"Reachable via WWAN";
        }
        case FXReachabilityStatusReachableViaWiFi:
        {
            return @"Reachable via WiFi";
        }
    }
}


+ (void)showFontsInResources {
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
}
@end
