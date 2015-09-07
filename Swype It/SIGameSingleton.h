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

@class SIGameSingleton;
@protocol SIGameSingletonDelegate <NSObject>
/**
 Called when the model is ready for a new move to be 
    loaded by the controller to the view
 */
- (void)sceneWillLoadNewMove;

/**
 Called when the user should be prompted to continue
    the game
 */
- (void)sceneWillShowContinue;

/**
 Called when there is a high score
 */
- (void)sceneWillShowIsHighScore;

/**
 Called when a free coin is earned
 Handle the sound for this in the controller?
 */
- (void)sceneWillShowFreeCoinEarned;

/**
 Called by model to alert controller when sound is ready to be played...
 */
- (void)contorllerWillPlayFXSoundNamed:(NSString *)soundName;

/**
 Called when the model is ready for the powerup to start
 */
- (void)sceneWillActivatePowerUp:(SIPowerUpType)powerUp;

/**
 Called when the powerup is deactived
 */
- (void)sceneWillDeactivatePowerUp:(SIPowerUpType)powerUp;

@end


@class Game;
@interface SIGameSingleton : NSObject {
    
}
/// @name Delegate Methods

/**
 Delegate methods
 */
@property (nonatomic, weak) id <SIGameSingletonDelegate> delegate;

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
 
 Public function called by view.. takes SIMove as input
 
 If correct -> calls singletonGameWillShowNewMove
 If incorrect -> calls singletonGameWillEnd
 */
- (void)singletonDidEnterMove:(SIMove *)move;

/**
 Called when the user enters the first move
 */
- (void)singletonDidStart;

/**
 Pauses the game state...
 
 Use Case:
    1. Called when the user taps the pause button
 */
- (void)singletonWillPause;

/**
 willContinue if you want a new move to be loaded
 Called in several scenarios
 
 1. User paid for to continue the game when they died...
 
 2. User tapped pause and now wants to play...
 */
- (void)singletonWillResumeAndContinue:(BOOL)willContinue;

/**
 Called to really end the game, invalidates timers and such...
 */
- (void)singletonDidEnd;

@end

