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

/**
 This combines the prefix the next quantity to reach and postfix.
    NOTE: if this is an ALL, it just returns the title assigned to it
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
@property (strong, nonatomic) NSDictionary *currentLevels;

/**
 This is the current sequence being worked on
 */
@property (assign, nonatomic) SIAchievementMoveSequence currentSequence;

/**
 This is the current challenge level
 */
@property (assign, nonatomic) SIAchievementLevel currentLevel;

/**
 This is the current move we are looking for
    Move and MoveSequence use this
 */
@property (assign, nonatomic) SIMoveCommand currentMoveCommand;

/**
 The index of the current move sequence
 */
@property (assign, nonatomic) NSUInteger currentIndexOfMoveSequenceCommand;

/**
 The amount of the current level
 */
@property (assign, nonatomic) int currentAmount;

@end