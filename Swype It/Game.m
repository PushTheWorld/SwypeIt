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
+ (float)levelSpeedForScoreOriginal:(float)score {
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

+ (float)scoreForMoveDuration:(float)durationOfLastMove withLevelSpeedDivider:(float)levelSpeedDivider {
    return MAX_MOVE_SCORE * exp(SCORE_EXP_POWER_WEIGHT * durationOfLastMove / levelSpeedDivider);
}
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
+ (int)numberLevelForScore:(float)score {
    int numberLevel = (int)score / 1000;
    numberLevel     = numberLevel + 1;
    numberLevel     = numberLevel * 1000;
    return numberLevel;
}
+ (NSString *)buttonNodeNameLabelDescriptionForSIIAPPack:(SIIAPPack)siiapPack {
    switch (siiapPack) {
        case SIIAPPackSmall:
            return kSINodeLabelDescriptionBag;
        case SIIAPPackMedium:
            return kSINodeLabelDescriptionPile;
        case SIIAPPackLarge:
            return kSINodeLabelDescriptionBucket;
        case SIIAPPackExtraLarge:
            return kSINodeLabelDescriptionChest;
        default:
            return nil;
    }
}
+ (NSString *)buttonNodeNameLabelPriceForSIIAPPack:(SIIAPPack)siiapPack {
    switch (siiapPack) {
        case SIIAPPackSmall:
            return kSINodeLabelPriceBag;
        case SIIAPPackMedium:
            return kSINodeLabelPricePile;
        case SIIAPPackLarge:
            return kSINodeLabelPriceBucket;
        case SIIAPPackExtraLarge:
            return kSINodeLabelPriceChest;
        default:
            return nil;
    }
}
+ (NSString *)buttonNodeNameNodeForSIIAPPack:(SIIAPPack)siiapPack {
    switch (siiapPack) {
        case SIIAPPackSmall:
            return kSINodeNodeBag;
        case SIIAPPackMedium:
            return kSINodeNodePile;
        case SIIAPPackLarge:
            return kSINodeNodeBucket;
        case SIIAPPackExtraLarge:
            return kSINodeNodeChest;
        default:
            return nil;
    }
}
+ (NSString *)buttonTextForSIIAPPack:(SIIAPPack)siiapPack {
    NSString *prefix;
    switch (siiapPack) {
        case SIIAPPackSmall:
            prefix = kSIIAPPackNameSmall;
            break;
        case SIIAPPackMedium:
            prefix = kSIIAPPackNameMedium;
            break;
        case SIIAPPackLarge:
            prefix = kSIIAPPackNameLarge;
            break;
        case SIIAPPackExtraLarge:
            prefix = kSIIAPPackNameExtraLarge;
            break;
        default:
            prefix = nil;
            break;
    }
    return [NSString stringWithFormat:@"%@ of Coins",prefix];
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
+ (NSString *)productIDForSIIAPPack:(SIIAPPack)siiapPack {
    switch (siiapPack) {
        case SIIAPPackSmall:
            return kSIIAPProductIDCoinPackSmall;
        case SIIAPPackMedium:
            return kSIIAPProductIDCoinPackMedium;
        case SIIAPPackLarge:
            return kSIIAPProductIDCoinPackLarge;
        case SIIAPPackExtraLarge:
            return kSIIAPProductIDCoinPackExtraLarge;
        default:
            return nil;
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
        case SIPowerUpFallingMonkeys:
            return kSIPowerUpFallingMonkeys;
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
+ (SIPowerUpCost)costForPowerUp:(SIPowerUp)powerUp {
    switch (powerUp) {
        case SIPowerUpTimeFreeze:
            return SIPowerUpCostTimeFreeze;
        case SIPowerUpRapidFire:
            return SIPowerUpCostRapidFire;
        case SIPowerUpFallingMonkeys:
            return SIPowerUpCostFallingMonkeys;
        default: /*Power Up None*/
            return SIPowerUpCostNone;
    }
}
/*AUTO TESTED*/
+ (SIPowerUpDuration)durationForPowerUp:(SIPowerUp)powerUp {
    switch (powerUp) {
        case SIPowerUpTimeFreeze:
            return SIPowerUpDurationTimeFreeze;
        case SIPowerUpFallingMonkeys:
            return SIPowerUpDurationFallingMonkeys;
        case SIPowerUpRapidFire:
            return SIPowerUpDurationRapidFire;
        default: /*None*/
            return SIPowerUpDurationNone;
    }
}
/*AUTO TESTED*/
+ (SIIAPPack)siiapPackForNameNodeNode:(NSString *)nodeName {
    if ([nodeName isEqualToString:kSINodeNodeBag]) {
        return SIIAPPackSmall;
    } else if ([nodeName isEqualToString:kSINodeNodePile]) {
        return SIIAPPackMedium;
    } else if ([nodeName isEqualToString:kSINodeNodeBucket]) {
        return SIIAPPackLarge;
    } else if ([nodeName isEqualToString:kSINodeNodeChest]) {
        return SIIAPPackExtraLarge;
    } else {
        return NUMBER_OF_IAP_PACKS;
    }
}
/*AUTO TESTED*/
+ (SIIAPPack)siiapPackForNameNodeLabel:(NSString *)nodeName {
    if ([nodeName isEqualToString:kSINodeLabelDescriptionBag]) {
        return SIIAPPackSmall;
    } else if ([nodeName isEqualToString:kSINodeLabelDescriptionPile]) {
        return SIIAPPackMedium;
    } else if ([nodeName isEqualToString:kSINodeLabelDescriptionBucket]) {
        return SIIAPPackLarge;
    } else if ([nodeName isEqualToString:kSINodeLabelDescriptionChest]) {
        return SIIAPPackExtraLarge;
    } else {
        return NUMBER_OF_IAP_PACKS;
    }
}
+ (int)numberOfCoinsForSIIAPPack:(SIIAPPack)siiapPack {
    switch (siiapPack) {
        case SIIAPPackSmall:
            return 30;
        case SIIAPPackMedium:
            return 200;
        case SIIAPPackLarge:
            return 500;
        case SIIAPPackExtraLarge:
            return 1500;
        default:
            return 0;
    }
}
+ (SIContinueLifeCost)lifeCostForCurrentContinueLeve:(SIContinueLifeCost)siContinuedLifeCost {
    if (siContinuedLifeCost < SIContinueLifeCost1) {
        return SIContinueLifeCost1;
    } else if (siContinuedLifeCost < SIContinueLifeCost2) {
        return SIContinueLifeCost2;
    } else if (siContinuedLifeCost < SIContinueLifeCost3) {
        return SIContinueLifeCost3;
    } else if (siContinuedLifeCost < SIContinueLifeCost4) {
        return SIContinueLifeCost4;
    } else if (siContinuedLifeCost < SIContinueLifeCost5) {
        return SIContinueLifeCost5;
    } else if (siContinuedLifeCost < SIContinueLifeCost6) {
        return SIContinueLifeCost6;
    } else if (siContinuedLifeCost < SIContinueLifeCost7) {
        return SIContinueLifeCost7;
    } else if (siContinuedLifeCost < SIContinueLifeCost8) {
        return SIContinueLifeCost8;
    } else if (siContinuedLifeCost < SIContinueLifeCost9) {
        return SIContinueLifeCost9;
    } else if (siContinuedLifeCost < SIContinueLifeCost10) {
        return SIContinueLifeCost10;
    } else if (siContinuedLifeCost < SIContinueLifeCost11) {
        return SIContinueLifeCost11;
    } else if (siContinuedLifeCost < SIContinueLifeCost12) {
        return SIContinueLifeCost12;
    } else if (siContinuedLifeCost < SIContinueLifeCost13) {
        return SIContinueLifeCost13;
    } else if (siContinuedLifeCost < SIContinueLifeCost14) {
        return SIContinueLifeCost14;
    } else if (siContinuedLifeCost < SIContinueLifeCost15) {
        return SIContinueLifeCost15;
    } else if (siContinuedLifeCost < SIContinueLifeCost16) {
        return SIContinueLifeCost16;
    } else if (siContinuedLifeCost < SIContinueLifeCost17) {
        return SIContinueLifeCost17;
    } else if (siContinuedLifeCost < SIContinueLifeCost18) {
        return SIContinueLifeCost18;
    } else if (siContinuedLifeCost < SIContinueLifeCost19) {
        return SIContinueLifeCost19;
    } else if (siContinuedLifeCost < SIContinueLifeCost20) {
        return SIContinueLifeCost20;
    } else {
        return SIContinueLifeCost0;
    }
}
#pragma mark - Private Class Methods
+ (float)levelSpeedForScore:(float)score {
    if (score < MAX_MOVE_SCORE) {
        return 4.0f;
    }
    return LEVEL_SPEED_DIV_MULT * log((double)score) + LEVEL_SPEED_INTERCEPT;
}
#pragma mark - Public Methods
- (NSNumber *)getNextLevelScore {
    return [NSNumber numberWithFloat:[Game nextLevelForScore:self.totalScore]];
}
- (NSString *)getCurrentLevelString {
    return [Game currentLevelStringForScore:self.totalScore];
}

+ (void)transisitionToSKScene:(SKScene *)scene toSKView:(SKView *)view DoorsOpen:(BOOL)doorsOpen pausesIncomingScene:(BOOL)pausesIncomingScene pausesOutgoingScene:(BOOL)pausesOutgoingScene duration:(CGFloat)duration {
    SKTransition *transistion;
    
    if (doorsOpen) {
        transistion = [SKTransition doorsOpenHorizontalWithDuration:duration];
    } else {
        transistion = [SKTransition doorsCloseHorizontalWithDuration:duration];
    }

    transistion.pausesIncomingScene = pausesIncomingScene;
    transistion.pausesOutgoingScene = pausesOutgoingScene;

    [view presentScene:scene transition:transistion];
}


@end
