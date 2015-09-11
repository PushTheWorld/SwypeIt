//  SIGameSceneTemp.h
//  Swype It
//
//  Created by Andrew Keller on 9/10/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose:
//
// Local Scene Import
#import "HLSpriteKit.h"
#import "SIGameNode.h"
#import "SIPopupNode.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "BMGlyphLabel.h"
// Category Import
// Support/Data Class Imports
#import "SIGame.h"
#import "SISceneGameProgressBarUpdate.h"
// Other Imports

@protocol SIGameSceneDelegate <NSObject>

/**
 Called when the scene recognizes a gesture
 Pinch, Tap, Swype of Shake
 */
- (void)controllerSceneGameDidRecieveMove:(SIMove *)move;

/**
 Fires when the pause button is pressed
 */
- (void)controllerSceneGamePauseButtonTapped;

/**
 Fires after the continue meny node has been pressed...
 If coins -> PayMethod - Coin
 If ads   -> PayMethod - Ads
 If no    -> PayMethod - User is not going to pay for this shit...
 */
- (void)controllerSceneGameWillDismissPopupContinueWithPayMethod:(SISceneGamePopupContinueMenuItem)continuePayMethod;

/**
 Called when the ring node is tapped and the result
 needs to be sent to the controller
 */
- (void)controllerSceneGameDidRecieveRingNode:(HLRingNode *)ringNode tap:(SISceneGameRingNode)gameSceneRingNode;

/**
 Powerup tool bar was tapped
 */
- (void)controllerSceneGameToolbar:(HLToolbarNode *)toolbar powerUpWasTapped:(SIPowerUpType)powerUp;

/**
 This is called on every update... So it gets called a ton!
 */
- (SISceneGameProgressBarUpdate *)controllerSceneGameWillUpdateProgressBars;

@end


@interface SIGameScene : HLScene <HLToolbarNodeDelegate, SIGameNodeDelegate, HLRingNodeDelegate, SIPopUpNodeDelegate, HLMenuNodeDelegate>

/**
 The delegate for the scene
 */
@property (weak, nonatomic) id <SIGameSceneDelegate> sceneDelegate;

/**
 Initalizer Method for Scene...
 */
- (instancetype)initWithSize:(CGSize)size;

/**
 I guess you could use this for a pause menu... if that's something
 you're into.
 */
- (void)sceneGameBlurDisplayRingNode:(HLRingNode *)ringNode;

/**
 Present a popup without a menu node
 */
- (void)sceneGameDisplayPopup:(SIPopupNode *)popupNode;

/**
 Used to fade all of the UI elements in
 */
- (void)sceneGameFadeUIElementsInDuration:(CGFloat)duration;

/**
 Used to fade all of the UI elements out
 */
- (void)sceneGameFadeUIElementsOutDuration:(CGFloat)duration;

/**
 When you need to move power up progress bar on or off screen
 */
- (void)sceneGameMovePowerUpProgressBarOnScreen:(BOOL)OnScreen animate:(BOOL)animate;

/**
 Present a node modally with a pop up
 */
- (void)sceneGamePresentPopup:(SIPopupNode *)popupNode withMenuNode:(HLMenuNode *)menuNode;

/**
 Called when the scene shall show a new high score
 */
- (void)sceneGameShowHighScore;

/**
 Called when the scene shall notify the user they got a free coin
 */
- (void)sceneGameShowFreeCoinEarned;


/**
 The ad content
 
 Default is nil...
 We are just going to make this an SIAdBannerNode!
 */
@property (nonatomic, strong) SIAdBannerNode *adBannerNode;

/**
 Oh yeah, so good news kids! if you set this to content it will get blaster up to the top of the screen!!
 */
@property (nonatomic, strong) SIPopupNode *popupNode;

/**
 A ring node to display
 */
@property (nonatomic, strong) HLRingNode *ringNode;

@end
