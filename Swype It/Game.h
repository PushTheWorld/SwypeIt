//  Game.h
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
// Framework Import
#import <UIKit/UIKit.h>
// Other Imports
#import "SIConstants.h"

@interface Game : NSObject {
    
}
#pragma mark - Public Objects

#pragma mark - Public Properties
@property (assign, nonatomic) NSInteger          currentPointsRemainingThisRound;
@property (assign, nonatomic) NSInteger          currentBackgroundColorNumber;
@property (assign, nonatomic) float              moveScore;
@property (assign, nonatomic) float              moveScorePercentRemaining;
@property (assign, nonatomic) float              powerUpPercentRemaining;
@property (assign, nonatomic) float              totalScore;
@property (assign, nonatomic) SIGameMode         gameMode;
@property (assign, nonatomic) SIMove             currentMove;
@property (assign, nonatomic) SIPowerUp          currentPowerUp;

@property (strong, nonatomic) NSString          *currentLevel;

#pragma mark - Public Class Methods
+ (float)               scoreForMoveDuration:(float)durationOfLastMove withLevelSpeedDivider:(float)levelSpeedDivider;
+ (float)               levelSpeedForScore:(float)score;
+ (int)                 nextLevelForScore:(float)score;
+ (NSString *)          buttonNodeNameLabelDescriptionForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          buttonNodeNameLabelPriceForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          buttonNodeNameNodeForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          buttonTextForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          currentLevelStringForScore:(float)score;
+ (NSString *)          productIDForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          stringForMove:(SIMove)move;
+ (NSString *)          stringForPowerUp:(SIPowerUp)powerUp;
+ (SIIAPPack)           siiapPackForNameNodeLabel:(NSString *)nodeName;
+ (SIIAPPack)           siiapPackForNameNodeNode:(NSString *)nodeName;
+ (SIMove)              getRandomMoveForGameMode:(SIGameMode)gameMode isRapidFireActiviated:(BOOL)isRapidFireActivated;
+ (SIPowerUpCost)       costForPowerUp:(SIPowerUp)powerUp;
+ (SIPowerUpDuration)   durationForPowerUp:(SIPowerUp)powerUp;
+ (UIColor *)           backgroundColorForScore:(float)score forRandomNumber:(NSInteger)randomNumber;



#pragma mark - Public Methods
- (NSString *)getCurrentLevelString;
- (NSNumber *)getNextLevelScore;

@end
