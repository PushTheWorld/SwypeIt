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
@property (assign, nonatomic) BOOL               isPaused;
@property (assign, nonatomic) BOOL               isStarted;
@property (assign, nonatomic) BOOL               isHighScore;
@property (assign, nonatomic) int                freeCoinsEarned;
@property (assign, nonatomic) float              moveScore;
@property (assign, nonatomic) float              freeCoinPercentRemaining;
@property (assign, nonatomic) float              freeCoinInPoints;
@property (assign, nonatomic) float              moveScorePercentRemaining;
@property (assign, nonatomic) float              powerUpPercentRemaining;
@property (assign, nonatomic) float              totalScore;
@property (assign, nonatomic) NSInteger          currentPointsRemainingThisRound;
@property (assign, nonatomic) NSInteger          currentBackgroundColorNumber;
@property (assign, nonatomic) SIBackgroundSound  currentBackgroundSound;
@property (assign, nonatomic) SIContinueLifeCost currentNumberOfTimesContinued;
@property (assign, nonatomic) SIGameMode         gameMode;
@property (assign, nonatomic) SIMove             currentMove;
@property (assign, nonatomic) SIPowerUp          currentPowerUp;

@property (strong, nonatomic) NSString          *currentLevel;

#pragma mark - Public Class Methods
+ (float)               scoreForMoveDuration:(float)durationOfLastMove withLevelSpeedDivider:(float)levelSpeedDivider;
+ (float)               levelSpeedForScore:(float)score;
+ (int)                 nextLevelForScore:(float)score;
+ (int)                 numberOfCoinsForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          buttonNodeNameLabelDescriptionForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          buttonNodeNameLabelPriceForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          buttonNodeNameNodeForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          buttonTextForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          currentLevelStringForScore:(float)score;
+ (NSString *)          productIDForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          soundNameForSIBackgroundSound:(SIBackgroundSound)siBackgroundSound;
+ (NSString *)          stringForMove:(SIMove)move;
+ (NSString *)          stringForPowerUp:(SIPowerUp)powerUp;
+ (NSString *)          userMessageForScore:(float)score highScore:(float)highScore;
+ (SIBackgroundSound)   backgroundSoundForScore:(float)score;
+ (SIContinueLifeCost)  lifeCostForCurrentContinueLeve:(SIContinueLifeCost)siContinuedLifeCost;
+ (SIIAPPack)           siiapPackForNameNodeLabel:(NSString *)nodeName;
+ (SIIAPPack)           siiapPackForNameNodeNode:(NSString *)nodeName;
+ (SIMove)              getRandomMoveForGameMode:(SIGameMode)gameMode isRapidFireActiviated:(BOOL)isRapidFireActivated;
+ (SIPowerUpCost)       costForPowerUp:(SIPowerUp)powerUp;
+ (SIPowerUpDuration)   durationForPowerUp:(SIPowerUp)powerUp;
+ (UIColor *)           backgroundColorForScore:(float)score forRandomNumber:(NSInteger)randomNumber;
+ (UIImage *)           getBluredScreenshot:(SKView *)view;
+ (void)                incrementGamesPlayed;
+ (void)                transisitionToSKScene:(SKScene *)scene toSKView:(SKView *)view DoorsOpen:(BOOL)doorsOpen pausesIncomingScene:(BOOL)pausesIncomingScene pausesOutgoingScene:(BOOL)pausesOutgoingScene duration:(CGFloat)duration;


#pragma mark - Public Methods
- (NSString *)getCurrentLevelString;
- (NSNumber *)getNextLevelScore;

@end
