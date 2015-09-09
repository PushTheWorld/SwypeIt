//  SIAchievementManager.h
//  Swype It
//
//  Created by Andrew Keller on 9/7/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is header file for the challenge singleton
//
// Local Controller Import
// Framework Import
#import <Foundation/Foundation.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
// Support/Data Class Imports
#import "SIAchievement.h"
#import "SIGame.h"
// Other Imports

@protocol SIAchievementSingletonDelegate <NSObject>
/**
 Called when challenge was complete
 */
- (void)controllerSingletonAchievementDidCompleteAchievement:(SIAchievement *)achievement;

/**
 Called when singleton is unable to pull from internet for sync
 */
- (void)controllerSingletonAchievementFailedToReachGameCenterWithError:(NSError *)error;

@end

@interface SIAchievementSingleton : NSObject

/// @name Delegate Methods

/**
 Delegate methods
 */
@property (nonatomic, weak) id <SIAchievementSingletonDelegate> delegate;

#pragma mark - Singleton Method
+ (instancetype)singleton;

#pragma mark - Public Methods
/**
 Enters a move into the singlton
 */
- (void)singletonAchievementWillProcessMove:(SIMove *)move;

#pragma mark - Public Class Methods


@end
