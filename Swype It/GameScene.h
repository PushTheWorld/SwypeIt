//  GameScene.h
//  Swype It
//
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is....
//
// Local Controller Import
#import "SIPopupNode.h"
#import "SIPowerUpToolbarNode.h"
// Framework Import
#import <SpriteKit/SpriteKit.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "HLSpriteKit.h"
// Category Import
// Support/Data Class Imports
#import "Game.h"
#import "SIMove.h"
#import "SISceneGameProgressBarUpdate.h"
// Other Imports

@class GameScene;
@protocol GameSceneDelegate <NSObject>

/**
 Called when the scene recognizes a gesture
    Pinch, Tap, Swype of Shake
 */
- (void)sceneGameDidRecieveMove:(SIMove *)move;

/**
 Fires when the pause button is pressed
 */
- (void)sceneGamePauseButtonTapped;

/**
 Fires after the continue meny node has been pressed...
    If coins -> PayMethod - Coin
    If ads   -> PayMethod - Ads
    If no    -> PayMethod - User is not going to pay for this shit...
 */
- (void)sceneGameWillDismissPopupContinueWithPayMethod:(SISceneGamePopupContinueMenuItem)continuePayMethod;

/**
 Called when the ring node is tapped and the result
    needs to be sent to the controller
 */
- (void)sceneGameDidRecieveRingNode:(HLRingNode *)ringNode Tap:(SISceneGameRingNode)gameSceneRingNode;

/**
 Powerup tool bar was tapped
 */
- (void)sceneGameToolbar:(HLToolbarNode *)toolbar powerUpWasTapped:(SIPowerUpType)powerUp;

/**
 This is called on every update... So it gets called a ton!
 */
- (SISceneGameProgressBarUpdate *)sceneGameWillUpdateProgressBars;




@end

@interface GameScene : HLScene <SKPhysicsContactDelegate>

/**
 The delegate for the scene
 */
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
 A super convient method for doing one thing and one thing only
    but im not sure i should say here. I mean really this is a 
    MVC and the view shall never have knowledge.. or shall it?
    
    Alright fine this is for a new move. there i said it...
 */
- (void)updateSceneWithBackgroundColor:(UIColor *)backgroundColor
                            totalScore:(float)totalScore
                             moveScore:(float)moveScore
            freeCoinProgressBarPercent:(float)freeCoinProgressBarPercent
                     moveCommandString:(NSString *)moveCommandString
                           isHighScore:(BOOL)isHighScore
                         touchLocation:(CGPoint)touchLocation;

/**
 I guess you could use this for a pause menu... if that's something
    you're into.
 */
- (void)sceneBlurDisplayRingNode:(HLRingNode *)ringNode;

/**
 Present a node modally
 */
- (void)sceneModallyPresentPopup:(SIPopupNode *)popupNode withMenuNode:(HLMenuNode *)menuNode;

/**
 Make and explosion at a point already set...
 */
- (void)sceneWillPresentEmitter:(SKEmitterNode *)emitter;




@end
