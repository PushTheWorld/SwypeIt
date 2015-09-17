//  AppSingleton.h
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is the header file for the app singleton
//
// Local Controller Import
// Framework Import
#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIKit.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
// Support/Data Class Imports
#import "SIPowerUp.h"
#import "SIIAPUtility.h"
#import "SIMove.h"
// Other Imports

@protocol SISingletonGameDelegate <NSObject>
/**
 Called when the model is ready for a new move to be 
    loaded by the controller to the view
 */
- (void)controllerSingletonGameLoadNewMove;

/**
 Called when the user should be prompted to continue
    the game
 */
- (void)controllerSingletonGameShowContinue;

/**
 Called when a free coin is earned
 Handle the sound for this in the controller?
 */
- (void)controllerSingletonGameShowFreeCoinEarned;

/**
 Called by model to alert controller when sound is ready to be played...
 */
- (void)controllerSingletonGamePlayFXSoundNamed:(NSString *)soundName;

/**
 Called when the model is ready for the powerup to start
 */
- (void)controllerSingletonGameActivatePowerUp:(SIPowerUpType)powerUp;

/**
 Called when the powerup is deactived
 */
- (void)controllerSingletonGameDeactivatePowerUp:(SIPowerUpType)powerUp;

@end


@class SIGame;
@interface SISingletonGame : NSObject {
    
}
/// @name Delegate Methods

/**
 Delegate methods
 */
@property (nonatomic, weak) id <SISingletonGameDelegate> delegate;

#pragma mark - Singleton Method
+ (instancetype)singleton;

#pragma mark - Public Properties
@property (assign, nonatomic) BOOL               isSaving;
@property (assign, nonatomic) BOOL               willResume;

#pragma mark - Public Objects
@property (strong, nonatomic) SIGame              *currentGame;


#pragma mark - Public Instance Methods
/**
 Method to determine if the user can continue...
 */
//- (BOOL)canAffordContinue;

//- (void)endGame; /*Should only be used for force quit*/
//- (void)initAppSingletonWithGameMode:(SIGameMode)gameMode;
//- (void)moveEnterForType:(SIMove)move;
//- (UIColor *)newBackgroundColor;
//- (void)setAndCheckDefaults:(float)score;
//- (void)startGame;
//- (void)stopGame;
//- (void)pause;
//- (void)play;
//- (void)powerUpDidLoad:(SIPowerUp)powerUp;
//- (void)powerUpWillActivate:(SIPowerUp)powerUp withPowerUpCost:(SIPowerUpCost)powerUpCost;
//- (void)powerUpDidActivate;
//- (void)powerUpDidEnd;
//- (void)willPrepareToShowNewMove;



#pragma mark - Public Game Functions
/**
 Trys the move entered on view to see if it was correct one
 Must check to make sure pause is not YES
 
 Public function called by view.. takes SIMove as input
 
 If correct -> calls singletonGameWillShowNewMove
 If incorrect -> calls singletonGameWillEnd
 */
- (void)singletonGameDidEnterMove:(SIMove *)move;

/**
 Called when the user enters the first move
 */
- (void)singletonGameDidStart;

/**
 Pauses the game state...
 
 Use Case:
    1. Called when the user taps the pause button
 */
- (void)singletonGameWillPause;

/**
 willContinue if you want a new move to be loaded
 Called in several scenarios
 
 1. User paid for to continue the game when they died...
 
 2. User tapped pause and now wants to play...
 */
- (void)singletonGameWillResumeAndContinue:(BOOL)willContinue;

/**
 Called to really end the game, invalidates timers and such...
 */
- (void)singletonGameDidEnd;

/**
 This will be called by the controller when asking to start a power up
 */
- (void)singletonGameWillActivatePowerUp:(SIPowerUpType)powerUp;

/**
 Called internally by the timer functions when a powerup's
 percent remaining value drops below the epsilon value
 */
- (void)singletonGameWillDectivatePowerUp:(SIPowerUp *)powerUpClass;

@end
