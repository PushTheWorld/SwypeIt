//  GameScene.h
//  Swype It
//
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is....
//
// Local Controller Import
// Framework Import
#import <SpriteKit/SpriteKit.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "HLSpriteKit.h"
// Category Import
// Support/Data Class Imports
#import "Game.h"
// Other Imports

@class SIGameScene;
@protocol GameSceneDelegate <NSObject>

/**
 Called when the scene recognizes a gesture
    Pinch, Tap, Swype of Shake
 */
- (void)sceneDidRecieveMoveCommand:(SIMove)moveCommand;

/**
 Asks the controller if the game is paused
 */
- (BOOL)gameIsPaused;

/**
 Asks the controller is the game has started
 */
- (BOOL)gameIsStarted;

/**
 Fires when the pause button is pressed
 */
- (void)scenePauseButtonTapped;





@end

@interface GameScene : HLScene <SKPhysicsContactDelegate>

@property (weak, nonatomic) id <GameSceneDelegate> sceneDelegate;

/**
 Initalizer Method for Scene...
 */
- (instancetype)initWithSize:(CGSize)size;

/**
 Used to fade all of the UI elements in
 */
- (void)fadeUIElementsInDuration:(CGFloat)duration;

/**
 Used to fade all of the UI elements out
 */
- (void)fadeUIElementsOutDuration:(CGFloat)duration;

/**
 The game mode.. configured at runtime
 */
@property (nonatomic, assign) SIGameMode gameMode;


@end
