//  SIMenuContent.m
//  Swype It
//
//  Created by Andrew Keller on 9/7/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: The data type implementation file for Menus
//
// Local Controller Import
#import "SIMenuContent.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
// Support/Data Class Imports
// Other Imports


@implementation SIMenuContent

#pragma mark - Init Methods
- (instancetype)init {
    self = [super init];
    if (self) {
        _isHighScore        = NO;
        _userIsPremium      = NO;

        _coinsEarned        = 0;

        _scoreGame          = 0.0f;
        _scoreLifeTimeHigh  = 0.0f;

        _type               = SISceneMenuTypeStart;

    }
    return self;
}
- (instancetype)initEndMenuGameScore:(float)gameScore lifetimeHighScore:(float)lifetimeHighScore isHighScore:(BOOL)isHighScore coinsEarned:(int)coinsEarned {
    self = [self init];
    if (self) {
        _type               = SISceneMenuTypeEnd;
        _scoreGame          = gameScore;
        _scoreLifeTimeHigh  = lifetimeHighScore;
        _isHighScore        = isHighScore;
        _coinsEarned        = coinsEarned;
    }
    return self;
}

- (instancetype)initStartMenuUserIsPremium:(BOOL)userIsPremium {
    self = [self init];
    if (self) {
        _userIsPremium      = userIsPremium;
        _type               = SISceneMenuTypeStart;
    }
    return self;
}

#pragma mark - Public Accessors
- (NSString *)userMessageString {
    return [SIMenuContent userMessageForScore:_scoreGame isHighScore:_isHighScore highScore:_scoreLifeTimeHigh];
}

#pragma mark - Private Class Methods
+ (NSString *)userMessageForScore:(float)score isHighScore:(BOOL)isHighScore highScore:(float)highScore {
    if (isHighScore) {
        NSUInteger randomNumber = arc4random_uniform((u_int32_t)[SIConstants userMessageHighScore].count);
        return [SIConstants userMessageHighScore][randomNumber];
    }
    if (score / highScore > 0.8f) {
        NSUInteger randomNumber = arc4random_uniform((u_int32_t)[SIConstants userMessageHighScoreClose].count);
        return [SIConstants userMessageHighScoreClose][randomNumber];

    } else if ( score / highScore > 0.15) {
        NSUInteger randomNumber = arc4random_uniform((u_int32_t)[SIConstants userMessageHighScoreMedian].count);
        return [SIConstants userMessageHighScoreMedian][randomNumber];

    } else {
        NSUInteger randomNumber = arc4random_uniform((u_int32_t)[SIConstants userMessageHighScoreBad].count);
        return [SIConstants userMessageHighScoreBad][randomNumber];

    }
}

@end
