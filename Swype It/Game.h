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
+ (UIColor *)           backgroundColorForScore:(float)score forRandomNumber:(NSInteger)randomNumber;
+ (NSString *)          currentLevelStringForScore:(float)score;
+ (SIPowerUpDuration)   durationForPowerUp:(SIPowerUp)powerUp;
+ (SIMove)              getRandomMoveForGameMode:(SIGameMode)gameMode isRapidFireActiviated:(BOOL)isRapidFireActivated;
+ (float)               levelSpeedForScore:(float)score;
+ (int)                 nextLevelForScore:(float)score;
+ (SIPowerUpCost)       costForPowerUp:(SIPowerUp)powerUp;
+ (NSString *)          stringForMove:(SIMove)move;
+ (NSString *)          stringForPowerUp:(SIPowerUp)powerUp;
+ (float)               scoreForMoveDuration:(float)durationOfLastMove withLevelSpeedDivider:(float)levelSpeedDivider;


#pragma mark - Public Methods
- (NSString *)getCurrentLevelString;
- (NSNumber *)getNextLevelScore;

@end
