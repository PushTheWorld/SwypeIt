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
#import "SIGame.h"
// Other Imports

@protocol SIAchievementSingletonDelegate <NSObject>
/**
 Called when challenge was complete
 */
- (void)WillLoadNewMove;

@end

@interface SIAchievementSingleton : NSObject

/// @name Delegate Methods

/**
 Delegate methods
 */
@property (nonatomic, weak) id <SIAchievementSingletonDelegate> delegate;

/**
 Enters a move into the singlton
 */
- (void)singletonChallengeEnterMove:(SIMove *)move; 

#pragma mark - Singleton Method
+ (instancetype)singleton;

#pragma mark - Public Methods

#pragma mark - Public Class Methods
+ (NSDictionary *)challengeLevelBeginnerSublevelOne;

@end
