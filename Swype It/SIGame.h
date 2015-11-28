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
//@property (assign, nonatomic) BOOL               isPaused;
//@property (assign, nonatomic) BOOL               oneHandMode;
@property (assign, nonatomic) BOOL               isHighScore;
@property (assign, nonatomic) int                freeCoinsEarned;
@property (assign, nonatomic) int                currentNumberOfTimesContinued;
//@property (assign, nonatomic) float              moveScore;
@property (assign, nonatomic) float              freeCoinPercentRemaining;
@property (assign, nonatomic) float              freeCoinInPoints;
@property (assign, nonatomic) float              moveScorePercentRemaining;
@property (assign, nonatomic) float              powerUpPercentRemaining;
@property (assign, nonatomic) float              totalScore;
@property (assign, nonatomic) NSInteger          currentPointsRemainingThisRound;
@property (assign, nonatomic) int                currentBackgroundColorNumber;
@property (assign, nonatomic) SIBackgroundSound  currentBackgroundSound;
//@property (assign, nonatomic) SIContinueLifeCost currentContinueLifeCost;
@property (assign, nonatomic) SIGameMode         gameMode;
//@property (strong, nonatomic) SIMove            *currentMove;
@property (strong, nonatomic) NSMutableArray    *powerUpArray;
@property (strong, nonatomic) NSString          *currentLevel;
@property (strong, nonatomic) UIColor           *currentBackgroundColor;

#pragma mark - Public Class Methods
+ (BOOL)                isDevieHighScore:(float)totalScore withNSUserDefaults:(NSUserDefaults *)defaults;
+ (float)devieHighScoreNSUserDefaults:(NSUserDefaults *)defaults;
/**
 Checks NSUserDefaults to see if one hand mode is active...
 */
+ (float)scoreForMoveDuration:(NSTimeInterval)durationOfLastMove withLevelSpeedDivider:(float)levelSpeedDivider;
+ (float)levelSpeedForScore:(float)score;
+ (float)updatePointsTillFreeCoinMoveScore:(float)moveScore withNSUserDefaults:(NSUserDefaults *)defaults withCallback:(void (^)(BOOL willAwardFreeCoin))callback;


+ (int)newBackgroundColorNumberCurrentNumber:(int)currentColorNumber totalScore:(float)totalScore;
+ (int)nextLevelForScore:(float)score;


+ (NSString *)currentLevelStringForScore:(float)score;
+ (NSString *)soundNameForSIBackgroundSound:(SIBackgroundSound)siBackgroundSound;
+ (NSString *)stringForMove:(SIMoveCommand)move;
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
+ (SIMoveCommand)getRandomMoveForGameMode:(SIGameMode)gameMode;
+ (SKAction *)actionForSIMoveCommandAction:(SIMoveCommandAction)siMoveCommandAction;
+ (SKTexture *)textureBackgroundColor:(SKColor *)backgroundColor size:(CGSize)size;
+ (SKTexture *)textureBackgroundColor:(SKColor *)backgroundColor size:(CGSize)size cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
+ (SKTexture *)textureForSIPowerUp:(SIPowerUpType)powerUp;
+ (UIColor *)backgroundColorForScore:(float)score forRandomNumber:(NSInteger)randomNumber;
+ (UIImage *)getBluredScreenshot:(SKView *)view;
+ (void)incrementGamesPlayedWithNSUserDefaults:(NSUserDefaults *)defaults;
+ (void)updateLifetimePointsScore:(float)totalScore withNSUserDefaults:(NSUserDefaults *)defaults;

/**
 Configures game properties for new game
 */
+ (void)setStartGameProperties:(SIGame *)game;

#pragma mark State Machine Class Functions
/**
 Call this to get an SIGameState for a string key
 Default return is SIGameStateStartEnd
 */
+ (SIGameState)gameStateForStringName:(NSString *)gameStateString;
/**
 Call this to get the string name of a game state
 Default is Start End
 */
+ (NSString *)stateStringNameForGameState:(SIGameState)gameState;

/**
 Use SoundManager to play music
 Resposible for checking with nsuserdefaults
 No looping no fade in
 */
+ (void)playMusic:(NSString *)name;

/**
 Use SoundManager to play music
 Resposible for checking with nsuserdefaults
 */
+ (void)playMusic:(NSString *)name looping:(BOOL)looping fadeIn:(BOOL)fadeIn;

/**
 Use SoundManager to play sound
 Resposible for checking with nsuserdefaults
 No looping no fade in
 */
+ (void)playSound:(NSString *)name;

/**
 Use SoundManager to play music
 Resposible for checking with nsuserdefaults
 */
+ (void)playSound:(NSString *)name looping:(BOOL)looping fadeIn:(BOOL)fadeIn;

/**
 Stops music if any is started
 */
+ (void)stopAllMusic;

/**
 Stops sounds if any are started
 */
+ (void)stopAllSounds;

/**
 Used to stop a sound given a name
 */
+ (void)stopSoundNamed:(NSString *)name;

/**
 Called to setup the sound manager
 */
+ (void)initalizeSoundManager;

/**
 Configures background sound state with nsuserdefaults
 */
+ (void)setBackgroundSoundActive:(BOOL)active;

/**
 Configures fx sound state with nsuserdefaults
 */
+ (void)setFXSoundActive:(BOOL)active;


#pragma mark - Public Methods
- (NSString *)getCurrentLevelString;
- (NSNumber *)getNextLevelScore;

@end
