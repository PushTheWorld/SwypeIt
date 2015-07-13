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
@property (assign, nonatomic) float              moveScore;
@property (assign, nonatomic) float              moveScorePercentRemaining;
@property (assign, nonatomic) float              totalScore;
@property (assign, nonatomic) GameMode           gameMode;
@property (assign, nonatomic) Move               nextMove;
@property (assign, nonatomic) Move               currentMove;
@property (assign, nonatomic) PowerUp            currentPowerUp;

@property (strong, nonatomic) NSString          *currentLevel;

#pragma mark - Public Class Methods
+ (int)nextLevelForScore:(float)score;
+ (NSString *)currentLevelStringForScore:(float)score;
+ (Move)getRandomMoveForGameMode:(GameMode)gameMode;
+ (PowerUpCost)powerUpCostForPowerUp:(PowerUp)powerUp;
+ (NSString *)stringForMove:(Move)move;
+ (float)scoreForMoveDuration:(float)durationOfLastMove withLevelSpeedDivider:(float)levelSpeedDivider;


#pragma mark - Public Methods
- (NSString *)getCurrentLevelString;
- (NSNumber *)getNextLevelScore;

@end
