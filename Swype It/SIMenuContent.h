//  SIMenuContent.h
//  Swype It
//
//  Created by Andrew Keller on 9/7/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose:
//
// Local Controller Import
// Framework Import
#import <Foundation/Foundation.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
// Support/Data Class Imports
#import "SIGame.h"
// Other Imports

/**
 Object used to load a menu scene
 */
@interface SIMenuContent : NSObject

/**
 Convience initializer for an end game menu
 */
- (instancetype)initEndMenuGameScore:(float)gameScore lifetimeHighScore:(float)lifetimeHighScore isHighScore:(BOOL)isHighScore coinsEarned:(int)coinsEarned;

/**
 Convience initializer for an end game menu
 */
- (instancetype)initStartMenuUserIsPremium:(BOOL)userIsPremium;

/**
 If the game was a high score or not
 */
@property (assign, nonatomic) BOOL isHighScore;

/**
 Set true if the user is premium
 */
@property (assign, nonatomic) BOOL userIsPremium;

/**
 The number of coins earned in the game
 */
@property (assign, nonatomic) int coinsEarned;

/**
 The score for the last round
 */
@property (assign, nonatomic) float scoreGame;

/**
 The lifetime high score for the user
 */
@property (assign, nonatomic) float scoreLifeTimeHigh;

/**
 The string displayed to the user
 */
@property (strong, nonatomic) NSString *userMessageString;

/**
 The type of scene the menu is currently laid out in
 */
@property (assign, nonatomic) SISceneMenuType type;

@end
