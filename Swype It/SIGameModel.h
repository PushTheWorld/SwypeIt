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
 -update screen
 */
- (void)gameModelEnteredStateIdle;

/**
 //pause time
 
 //display blur screen
 
 //present ring node
 
 //connect it's gesture target
 */
- (void)gameModelEnteredStatePause;

/**
 //show ad or charge user
 */
- (void)gameModelEnteredStatePayingForContinue;

/**
 //pause time
 
 //display blur screen
 
 //present continue popup
 
 //connect it's gesture target!
 */
- (void)gameModelEnteredStatePopupContinue;

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

- (void)gameModelEnteredStateProcessingMove:(SIMove *)move;

/**
 //show menu with end configuration
 
 //send score to game center
 */
- (void)gameModelEnteredStateEnd;

/**
 clear data
 */
- (void)gameModelGameStateExitedEnd;

/**
 //clear the data
 
 //send to wait for move
 */
- (void)gameModelEnteredStateStart;

/**
 //pause time
 
 //make sure monkey scene is ready
 //transistion to monkey scene fast!
 */
- (void)gameModelEnteredStateFallingMonkey;


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


@end
