//  SIAchievementDetail.h
//  Swype It
//
//  Created by Andrew Keller on 9/8/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is....
//
// Local Controller Import
// Framework Import
#import <Foundation/Foundation.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIGame.h"
// Other Imports

@interface SIAchievementDetail : NSObject

/**
 Used for when the user clicks on the help icon
 */
@property (strong, nonatomic) NSString *helpString;

/**
 Used for the prefix of the challenge show on the table
 */
@property (strong, nonatomic) NSString *prefixString;

/**
 Used for the post fix of the challenge shoud on the table
 */
@property (strong, nonatomic) NSString *postfixString;

/**
 The type [SIAchievementType] of the challenge
 */
@property (assign, nonatomic) SIAchievementType type;

/**
 Whether or not the challenge has been completed or not
 */
@property (assign, nonatomic) BOOL completed;

/**
 The amount to be given upon completion of the reward
    NOTE: This is only used by ALL class
 */
@property (assign, nonatomic) int completionReward;

/**
 Array that contains n `moveCommands` to make up a sequence
 */
@property (strong, nonatomic) NSArray *moveSequenceArray;

/**
 The dictionary key for this achievement
 */
@property (strong, nonatomic) NSString *dictionaryKey;


@end
