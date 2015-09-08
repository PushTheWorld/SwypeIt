//  SIAchievement.h
//  Swype It
//
//  Created by Andrew Keller on 9/7/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is....
//
// Local Controller Import
// Framework Import
#import <Foundation/Foundation.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
// Support/Data Class Imports
#import "SIAchievementDetail.h"
#import "SIGame.h"
// Other Imports


@interface SIAchievement : NSObject

- (instancetype)initWithName:(NSString *)name;

/**
 This combines the prefix the next quantity to reach and postfix
 */
@property (strong, nonatomic) NSString *title;

/**
 The details of the challenge
 
 If type is SIAchievementTypeAll then this returns the
 */
@property (strong, nonatomic) SIAchievementDetail *details;

/**
 Dictionary that contains the quanity of `types` per level

    When the user has reached 10, 30 or 50 user gets
        at least a notification... maybe a reward
 */
@property (strong, nonatomic) NSMutableDictionary *challengeLevel;

/**
 This is the current sequence being worked on
 */
@property (assign, nonatomic) SIAchievementMoveSequence currentSequence;

/**
 This is the current challenge level
 */
@property (assign, nonatomic) SIAchievementLevel currentLevel;

/**
 The amount to be given upon completion of the reward
 */
@property (assign, nonatomic) int completionReward;

/**
 Whether or not the skill has been mastered
 */
@property (assign, nonatomic) BOOL completed;

@end