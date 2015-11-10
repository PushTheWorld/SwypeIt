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
#import "SIAdBannerNode.h"
#import "SIGameNode.h"
#import "SIPopupNode.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "BMGlyphLabel.h"
#import "TCProgressBarNode.h"
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
- (void)sceneGameDidRecieveMove:(SIMove *)move;

/**
 Fires when the pause button is pressed
 */
- (void)controllerSceneGamePauseButtonTapped;


/**
 The toolbar 'toolTag' node of the powerup
 */
- (void)controllerSceneGamePowerUpToolbarTappedWithToolTag:(NSString *)toolTag;

///**
// Fires after the continue meny node has been pressed...
// If coins -> PayMethod - Coin
// If ads   -> PayMethod - Ads
// If no    -> PayMethod - User is not going to pay for this shit...
// */
//- (void)controllerSceneGameWillDismissPopupContinueWithPayMethod:(SISceneGamePopupContinueMenuItem)continuePayMethod;
//
///**
// Called when the ring node is tapped and the result
// needs to be sent to the controller
// */
//- (void)controllerSceneGameDidRecieveRingNode:(HLRingNode *)ringNode tap:(SISceneGameRingNode)gameSceneRingNode;
//
///**
// Powerup tool bar was tapped
// */
//- (void)controllerSceneGameToolbar:(HLToolbarNode *)toolbar powerUpWasTapped:(SIPowerUpType)powerUp;

/**
 This is called on every update... So it gets called a ton!
 */
- (SISceneGameProgressBarUpdate *)sceneGameWillUpdateProgressBars;

@end


@interface SIGameScene : HLScene <UIGestureRecognizerDelegate> //<SIGameNodeDelegate>

/**
 The delegate for the scene
 */
@property (weak, nonatomic) id <SIGameSceneDelegate> sceneDelegate;

/**
 Initalizer Method for Scene...
 */
- (instancetype)initWithSize:(CGSize)size;

///**
// When you need to move power up progress bar on or off screen
// */
//- (void)sceneGameMovePowerUpProgressBarOnScreen:(BOOL)OnScreen animate:(BOOL)animate;

/**
 Used to launch a move command
 */
- (void)sceneGameLaunchMoveCommandLabelWithCommandAction:(SIMoveCommandAction)commandAction;

/**
 Called when the scene shall notify the user they got a free coin
 */
- (void)sceneGameShowFreeCoinEarned;

/**
 Called to show an exploding move score
 */
//- (void)sceneGameWillShowMoveScore:(SKLabelNode *)moveLabel;

/**
 Layout the Scene
 */
- (void)layoutScene;

/**
 The ad content
 
 Default is nil...
 We are just going to make this an SIAdBannerNode!
 */
@property (nonatomic, strong) SIAdBannerNode *adBannerNode;

/**
 The duration for how long it takes to animate objects in for layout
 default is `1.0f`
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 Set this true to display a blur screen above the view
 */
@property (nonatomic, assign) BOOL blurScreen;

/**
 Blur screen duration
 Default is `0.25`
 */
@property (nonatomic, assign) CGFloat blurScreenDuration;

/**
 The label of the move command
 */
@property (nonatomic, strong) SKLabelNode *moveCommandLabel;

/**
 Move Command Label Position Random
 Set this true to make the moveCommand move in random around the scene
 */
@property (nonatomic, assign) BOOL moveCommandRandomLocation;

/**
 Oh yeah, so good news kids! if you set this to content it will get blaster up to the top of the screen!!
 */
@property (nonatomic, strong) SIPopupNode *popupNode;

/**
 A Power Up Toolbar
 */
@property (nonatomic, strong) HLToolbarNode *powerUpToolbarNode;

/**
 The progress bar for the free coin
 */
@property (nonatomic, strong) TCProgressBarNode *progressBarFreeCoin;

/**
 The progress bar for the power up
 */
@property (nonatomic, strong) TCProgressBarNode *progressBarPowerUp;

/**
 The progress bar for the move
 */
//@property (nonatomic, strong) TCProgressBarNode *progressBarMove;

/**
 A ring node to display
 */
@property (nonatomic, strong) HLRingNode *ringNode;

/**
 The total score label
 */
@property (nonatomic, strong) SKLabelNode *scoreTotalLabel;

/**
 The move score label
 */
@property (nonatomic, strong) SKLabelNode *scoreMoveLabel;

/**
 Pading of the top label
 Default is `8.0f`
 */
@property (nonatomic, assign) CGFloat scoreTotalLabelTopPadding;

/**
 Number of Coins the user has
 */
@property (nonatomic, assign) int swypeItCoins;

/**
 High score
 */
@property (nonatomic, assign) BOOL highScore;
@end
