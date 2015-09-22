//  SIGameModel.h
//  Swype It
//
//  Created by Andrew Keller on 9/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is the header file for the state machine based game engine
//
// Local Controller Import
// Framework Import
#import <Foundation/Foundation.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "TransitionKit.h"
// Category Import
// Support/Data Class Imports
#import "SIGame.h"
#import "SIMove.h"
// Other Imports


@protocol SIGameModelDelegate <NSObject>

/**
 //show menu with end configuration
 
 //send score to game center
 */
- (void)gameModelStateEndEntered;

/**
 reset all game data
 */
- (void)gameModelStateEndExited;

/**
 //pause time
 
 //make sure monkey scene is ready
 //transistion to monkey scene fast!
 */
- (void)gameModelStateFallingMonkeyEntered;

/**
 -update screen
 */
- (void)gameModelStateIdleEntered;

/**
 Called when the game wants to load
 */
- (void)gameModelStateLoadingEntered;

/**
 Called when the game is done loading
 */
- (void)gameModelStateLoadingExited;

/**
 //pause time
 
 //display blur screen
 
 //present ring node
 
 //connect it's gesture target
 */
- (void)gameModelStatePauseEntered;

/**
 Called when the game leaves the paused state
 */
- (void)gameModelStatePauseExited;

/**
 //show ad or charge user
 */
- (void)gameModelStatePayingForContinueEnteredWithPayMethod:(SISceneGamePopupContinueMenuItem)paymentMethod;

/**
 //pause time
 
 //display blur screen
 
 //present continue popup
 
 //connect it's gesture target!
 */
- (void)gameModelStatePopupContinueEntered;

/**
 //correctMove?
 
 //if correctMove
 //  launch the move command and such
 //  send move to achievement
 //  get new move data
 //  show new move data
 //else notCorrectMove
 //  display pop up
 //  load start/end scene
 */

- (void)gameModelStateProcessingMoveEnteredWithMove:(SIMove *)move;

/**
 get new move
 */
- (void)gameModelStateProcessingMoveExited;

/**
 //clear the data
 
 //send to wait for move
 */
- (void)gameModelStateStartEntered;

@end

@interface SIGameModel : NSObject

/// @name Delegate Methods

/**
 Delegate methods
 */
@property (nonatomic, weak) id <SIGameModelDelegate> delegate;

/**
 The state machine of the whole thing
 */
@property (nonatomic, strong) TKStateMachine  *stateMachine;

/**
 The game
 */
@property (nonatomic, strong) SIGame *game;

/**
 Powerup Array
 */
@property (nonatomic, strong) NSMutableArray *powerUpArray;


@end
