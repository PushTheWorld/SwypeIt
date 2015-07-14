//  Game.m
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//
//  Purpose: Singleton file for a game, there can only be one game played at a time.
//

// Local Controller Import
#import "Game.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports
@interface Game () {
    
}

@end

@implementation Game

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        // Do setup here for new game
    }
    return self;
}

#pragma mark - Class Methods
+ (int)nextLevelForScore:(float)score {
    int levelScore = 0;
    
    if (score < LEVEL1) {
        levelScore  = LEVEL1;
    } else if (score < LEVEL2) {
        levelScore  = LEVEL2;
    } else if (score < LEVEL3) {
        levelScore  = LEVEL3;
    } else if (score < LEVEL4) {
        levelScore  = LEVEL4;
    } else if (score < LEVEL5) {
        levelScore  = LEVEL5;
    } else if (score < LEVEL6) {
        levelScore  = LEVEL6;
    } else if (score < LEVEL7) {
        levelScore  = LEVEL7;
    } else if (score < LEVEL8) {
        levelScore  = LEVEL8;
    } else if (score < LEVEL9) {
        levelScore  = LEVEL9;
    } else if (score < LEVEL10) {
        levelScore  = LEVEL10;
    } else if (score < LEVEL11) {
        levelScore  = LEVEL11;
    } else if (score < LEVEL12) {
        levelScore  = LEVEL12;
    } else if (score < LEVEL13) {
        levelScore  = LEVEL13;
    } else if (score < LEVEL14) {
        levelScore  = LEVEL14;
    } else if (score < LEVEL15) {
        levelScore  = LEVEL15;
    } else if (score < LEVEL16) {
        levelScore  = LEVEL16;
    } else if (score < LEVEL17) {
        levelScore  = LEVEL17;
    } else if (score < LEVEL18) {
        levelScore  = LEVEL18;
    } else if (score < LEVEL19) {
        levelScore  = LEVEL19;
    } else if (score < LEVEL20) {
        levelScore  = LEVEL20;
    } else {
        levelScore  = [Game numberLevelForScore:score];
    }
    return levelScore;
}

+ (NSString *)currentLevelStringForScore:(float)score {
    int numberLevel = 0;
    if (score < LEVEL1) {
        numberLevel = 1;
    } else if (score < LEVEL2) {
        numberLevel = 2;
    } else if (score < LEVEL3) {
        numberLevel = 3;
    } else if (score < LEVEL4) {
        numberLevel = 4;
    } else if (score < LEVEL5) {
        numberLevel = 5;
    } else if (score < LEVEL6) {
        numberLevel = 6;
    } else if (score < LEVEL7) {
        numberLevel = 7;
    } else if (score < LEVEL8) {
        numberLevel = 8;
    } else if (score < LEVEL9) {
        numberLevel = 9;
    } else if (score < LEVEL10) {
        numberLevel = 10;
    } else if (score < LEVEL11) {
        numberLevel = 11;
    } else if (score < LEVEL12) {
        numberLevel = 12;
    } else if (score < LEVEL13) {
        numberLevel = 13;
    } else if (score < LEVEL14) {
        numberLevel = 14;
    } else if (score < LEVEL15) {
        numberLevel = 15;
    } else if (score < LEVEL16) {
        numberLevel = 16;
    } else if (score < LEVEL17) {
        numberLevel = 17;
    } else if (score < LEVEL18) {
        numberLevel = 18;
    } else if (score < LEVEL19) {
        numberLevel = 19;
    } else if (score < LEVEL20) {
        numberLevel = 20;
    }else {
        numberLevel = ([Game numberLevelForScore:score]/1000) + 10;
    }
    
    return [NSString stringWithFormat:@"Level %d",numberLevel];
}

+ (int)numberLevelForScore:(float)score {
    int numberLevel = (int)score / 1000;
    numberLevel     = numberLevel + 1;
    numberLevel     = numberLevel * 1000;
    return numberLevel;
}

+ (UIColor *)backgroundColorForScore:(float)score forRandomNumber:(NSInteger)randomNumber {
    if (score < LEVEL1) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelOneA];
            case 1:
                return [UIColor backgroundColorForLevelOneB];
            default:
                return [UIColor backgroundColorForLevelOneC];
        }
    } else if (score < LEVEL2) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelTwoA];
            case 1:
                return [UIColor backgroundColorForLevelTwoB];
            default:
                return [UIColor backgroundColorForLevelTwoC];
        }
    } else if (score < LEVEL3) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelThreeA];
            case 1:
                return [UIColor backgroundColorForLevelThreeB];
            default:
                return [UIColor backgroundColorForLevelThreeC];
        }
    } else if (score < LEVEL4) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelFourA];
            case 1:
                return [UIColor backgroundColorForLevelFourB];
            default:
                return [UIColor backgroundColorForLevelFourC];
        }
    } else if (score < LEVEL5) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelFiveA];
            case 1:
                return [UIColor backgroundColorForLevelFiveB];
            default:
                return [UIColor backgroundColorForLevelFiveC];
        }
    } else if (score < LEVEL6) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelSixA];
            case 1:
                return [UIColor backgroundColorForLevelSixB];
            default:
                return [UIColor backgroundColorForLevelSixC];
        }
    } else if (score < LEVEL7) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelSevenA];
            case 1:
                return [UIColor backgroundColorForLevelSevenB];
            default:
                return [UIColor backgroundColorForLevelSevenC];
        }
    } else if (score < LEVEL8) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelEightA];
            case 1:
                return [UIColor backgroundColorForLevelEightB];
            default:
                return [UIColor backgroundColorForLevelEightC];
        }
    } else if (score < LEVEL9) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelNineA];
            case 1:
                return [UIColor backgroundColorForLevelNineB];
            default:
                return [UIColor backgroundColorForLevelNineC];
        }
    } else if (score < LEVEL10) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelTenA];
            case 1:
                return [UIColor backgroundColorForLevelTenB];
            default:
                return [UIColor backgroundColorForLevelTenC];
        }
    } else if (score < LEVEL11) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelElevenA];
            case 1:
                return [UIColor backgroundColorForLevelElevenB];
            default:
                return [UIColor backgroundColorForLevelElevenC];
        }
    } else if (score < LEVEL12) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelTwelveA];
            case 1:
                return [UIColor backgroundColorForLevelTwelveB];
            default:
                return [UIColor backgroundColorForLevelTwelveC];
        }
    } else {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelOneA];
            case 1:
                return [UIColor backgroundColorForLevelTwoB];
            case 2:
                return [UIColor backgroundColorForLevelThreeC];
            case 3:
                return [UIColor backgroundColorForLevelFourA];
            case 4:
                return [UIColor backgroundColorForLevelSixB];
            case 5:
                return [UIColor backgroundColorForLevelSevenC];
            case 6:
                return [UIColor backgroundColorForLevelEightA];
            case 7:
                return [UIColor backgroundColorForLevelNineB];
            case 8:
                return [UIColor backgroundColorForLevelTenC];
            default:
                return [UIColor backgroundColorForLevelElevenB];
        }
    }
}
+ (float)scoreForMoveDuration:(float)durationOfLastMove withLevelSpeedDivider:(float)levelSpeedDivider {
    return MAX_MOVE_SCORE * exp(SCORE_EXP_POWER_WEIGHT * durationOfLastMove / levelSpeedDivider);
}
+ (SIMove)getRandomMoveForGameMode:(SIGameMode)gameMode isRapidFireActiviated:(BOOL)isRapidFireActivated {
    if (isRapidFireActivated) {
        return SIMoveTap;
    }
    NSInteger randomNumber = arc4random_uniform(NUMBER_OF_MOVES);
    switch (randomNumber) {
        case 0:
            return SIMoveTap;
        case 1:
            return SIMoveSwype;
        default:
            if (gameMode == SIGameModeOneHand) {
                return SIMoveShake;
            } else { /*GameModeTwoHane*/
                return SIMovePinch;
            }
    }
}
/*AUTO TESTED*/
+ (NSString *)stringForMove:(SIMove)move {
    switch (move) {
        case SIMoveTap:
            return kSIMoveCommandTap;
        case SIMoveSwype:
            return kSIMoveCommandSwype;
        case SIMovePinch:
            return kSIMoveCommandPinch;
        case SIMoveShake:
            return kSIMoveCommandShake;
        default:
            return nil;
    }
}
/*AUTO TESTED*/
+ (NSString *)stringForPowerUp:(SIPowerUp)powerUp {
    switch (powerUp) {
        case SIPowerUpDoublePoints:
            return kSIPowerUpDoublePoints;
        case SIPowerUpTimeFreeze:
            return kSIPowerUpTimeFreeze;
        case SIPowerUpRapidFire:
            return kSIPowerUpRapidFire;
        case SIPowerUpNone:
            return kSIPowerUpNone;
        default:
            return nil;
    }
}
/*AUTO TESTED*/
+ (SIPowerUpCost)costForPowerUp:(SIPowerUp)powerUp {
    switch (powerUp) {
        case SIPowerUpTimeFreeze:
            return SIPowerUpCostTimeFreeze;
        case SIPowerUpRapidFire:
            return SIPowerUpCostRapidFire;
        case SIPowerUpDoublePoints:
            return SIPowerUpCostDoublePoints;
        default: /*Power Up None*/
            return SIPowerUpCostNone;
    }
}
/*AUTO TESTED*/
+ (SIPowerUpDuration)durationForPowerUp:(SIPowerUp)powerUp {
    switch (powerUp) {
        case SIPowerUpTimeFreeze:
            return SIPowerUpDurationTimeFreeze;
        case SIPowerUpDoublePoints:
            return SIPowerUpDurationDoublePoints;
        case SIPowerUpRapidFire:
            return SIPowerUpDurationRapidFire;
        default: /*None*/
            return SIPowerUpDurationNone;
    }
}
+ (float)levelSpeedForScore:(float)score {
    if (score < LEVEL1) {
        return 4.0f;
    } else if (score < LEVEL2) {
        return 3.0f;
    } else if (score < LEVEL3) {
        return 2.5f;
    } else if (score < LEVEL4) {
        return 2.0f;
    } else if (score < LEVEL5) {
        return 1.5f;
    } else if (score < LEVEL8) {
        return 1.0f;
    } else {
        return 0.9f;
    }
}

#pragma mark - Public Methods
- (NSNumber *)getNextLevelScore {
    return [NSNumber numberWithFloat:[Game nextLevelForScore:self.totalScore]];
}
- (NSString *)getCurrentLevelString {
    return [Game currentLevelStringForScore:self.totalScore];
}

@end
