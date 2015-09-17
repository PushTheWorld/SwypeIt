//  SIGame.h
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
// Framework Import
#import <UIKit/UIKit.h>
// Other Imports
#import "SIConstants.h"
#import "SIMove.h"

@interface SIGame : NSObject {
    
}
#pragma mark - Public Objects

#pragma mark - Public Properties
@property (assign, nonatomic) BOOL               isPaused;
@property (assign, nonatomic) BOOL               isStarted;
@property (assign, nonatomic) BOOL               isHighScore;
@property (assign, nonatomic) int                freeCoinsEarned;
@property (assign, nonatomic) int                currentNumberOfTimesContinued;
@property (assign, nonatomic) float              moveScore;
@property (assign, nonatomic) float              freeCoinPercentRemaining;
@property (assign, nonatomic) float              freeCoinInPoints;
@property (assign, nonatomic) float              moveScorePercentRemaining;
@property (assign, nonatomic) float              powerUpPercentRemaining;
@property (assign, nonatomic) float              totalScore;
@property (assign, nonatomic) NSInteger          currentPointsRemainingThisRound;
@property (assign, nonatomic) NSInteger          currentBackgroundColorNumber;
@property (assign, nonatomic) SIBackgroundSound  currentBackgroundSound;
@property (assign, nonatomic) SIContinueLifeCost currentContinueLifeCost;
@property (assign, nonatomic) SIGameMode         gameMode;
@property (strong, nonatomic) SIMove            *currentMove;
@property (strong, nonatomic) NSMutableArray    *powerUpArray;
@property (strong, nonatomic) NSString          *currentLevel;
@property (strong, nonatomic) UIColor           *currentBackgroundColor;

#pragma mark - Public Class Methods
+ (BOOL)                isDevieHighScore:(float)totalScore;
//+ (CGPoint)             emitterLocationFromGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
+ (float)               scoreForMoveDuration:(float)durationOfLastMove withLevelSpeedDivider:(float)levelSpeedDivider;
+ (float)               levelSpeedForScore:(float)score;
+ (float)               updatePointsTillFreeCoinMoveScore:(float)moveScore withCallback:(void (^)(BOOL willAwardFreeCoin))callback;
+ (int)                 nextLevelForScore:(float)score;
+ (int)                 numberOfCoinsForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          buttonNodeNameLabelDescriptionForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          buttonNodeNameLabelPriceForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          buttonNodeNameNodeForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          buttonTextForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          currentLevelStringForScore:(float)score;
+ (NSString *)          productIDForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          soundNameForSIBackgroundSound:(SIBackgroundSound)siBackgroundSound;
+ (NSString *)          stringForMove:(SIMoveCommand)move;
+ (NSString *)userMessageForScore:(float)score isHighScore:(BOOL)isHighScore highScore:(float)highScore;
/**
 Gets the title for the type of menu
 */
+ (NSString *)          titleForMenuType:(SISceneMenuType)type;
+ (SIBackgroundSound)   backgroundSoundForScore:(float)score;
+ (SIBackgroundSound)   checkBackgroundSound:(SIBackgroundSound)currentBackgroundSound forTotalScore:(float)totalScore withCallback:(void (^)(BOOL updatedBackgroundSound, SIBackgroundSound backgroundSound))callback;
/**
 Returns the number of ads to show given a number of times the user has continued
 */
+ (SIContinueAdCount)adCountForNumberOfTimesContinued:(int)numberOfTimesContinued;
/**
 Returns the IT Coin cost based on the number of times the user has continued
 */
+ (SIContinueLifeCost)lifeCostForNumberOfTimesContinued:(int)numberOfTimesContinued;
/**
 Determine prize to give based off when the last time a prize was given... either:
 SIGameFreePrizeNo -> No prize to be given
 SIGameFreePrizeYes -> Give prize, reset the days since last launch and such
 SIGameFreePrizeYesConsecutive -> give prize, increment days since last launch..
 */
+ (SIFreePrizeType)gamePrizeForCurrentDate:(NSDate *)currentDate lastPrizeGivenDate:(NSDate *)lastPrizeGivenDate;
+ (SIIAPPack)           siiapPackForNameNodeLabel:(NSString *)nodeName;
+ (SIIAPPack)           siiapPackForNameNodeNode:(NSString *)nodeName;
+ (SIMoveCommand)       getRandomMoveForGameMode:(SIGameMode)gameMode;
+ (SKAction *)          actionForSIMoveCommandAction:(SIMoveCommandAction)siMoveCommandAction;
+ (SKTexture *)         textureBackgroundColor:(SKColor *)backgroundColor size:(CGSize)size;
+ (SKTexture *)         textureBackgroundColor:(SKColor *)backgroundColor size:(CGSize)size cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (SKTexture *)         textureForSIPowerUp:(SIPowerUpType)powerUp;
+ (UIColor *)           backgroundColorForScore:(float)score forRandomNumber:(NSInteger)randomNumber;
+ (UIImage *)           getBluredScreenshot:(SKView *)view;
+ (void)                incrementGamesPlayed;
+ (void)                updateLifetimePointsScore:(float)totalScore;

/**
 Configures game properties for new game
 */
+ (void)setStartGameProperties:(SIGame *)game;

#pragma mark - Public Methods
- (NSString *)getCurrentLevelString;
- (NSNumber *)getNextLevelScore;

@end