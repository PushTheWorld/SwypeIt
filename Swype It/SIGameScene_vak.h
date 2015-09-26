////  GameScene.h
////  Swype It
////
////  Created by Andrew Keller on 7/19/15.
////  Copyright © 2015 Push The World LLC. All rights reserved.
////
////  Purpose: This is....
////
//// Local Controller Import
//#import "SIAdBannerNode.h"
//#import "SIPopupNode.h"
//#import "SIPowerUpToolbarNode.h"
//// Framework Import
//#import <SpriteKit/SpriteKit.h>
//// Drop-In Class Imports (CocoaPods/GitHub/Guru)
//#import "BMGlyphLabel.h"
//#import "HLSpriteKit.h"
//// Category Import
//// Support/Data Class Imports
//#import "SIGame.h"
//#import "SIMove.h"
//#import "SISceneGameProgressBarUpdate.h"
//// Other Imports
//
//@protocol SIGameSceneDelegate <NSObject>
//
///**
// Called when the scene recognizes a gesture
//    Pinch, Tap, Swype of Shake
// */
//- (void)sceneGameDidRecieveMove:(SIMove *)move;
//
///**
// Fires when the pause button is pressed
// */
//- (void)controllerSceneGamePauseButtonTapped;
//
///**
// Fires after the continue meny node has been pressed...
//    If coins -> PayMethod - Coin
//    If ads   -> PayMethod - Ads
//    If no    -> PayMethod - User is not going to pay for this shit...
// */
//- (void)controllerSceneGameWillDismissPopupContinueWithPayMethod:(SISceneGamePopupContinueMenuItem)continuePayMethod;
//
///**
// Called when the ring node is tapped and the result
//    needs to be sent to the controller
// */
//- (void)controllerSceneGameDidRecieveRingNode:(HLRingNode *)ringNode tap:(SISceneGameRingNode)gameSceneRingNode;
//
///**
// Powerup tool bar was tapped
// */
//- (void)controllerSceneGameToolbar:(HLToolbarNode *)toolbar powerUpWasTapped:(SIPowerUpType)powerUp;
//
///**
// This is called on every update... So it gets called a ton!
// */
//- (SISceneGameProgressBarUpdate *)sceneGameWillUpdateProgressBars;
//
//@end
//
//@interface SIGameScene : HLScene <SKPhysicsContactDelegate>
//
///**
// The delegate for the scene
// */
//@property (weak, nonatomic) id <SIGameSceneDelegate> sceneDelegate;
//
///**
// Initalizer Method for Scene...
// */
//- (instancetype)initWithSize:(CGSize)size;
//
///**
// Used to fade all of the UI elements in
// */
//- (void)sceneGameFadeUIElementsInDuration:(CGFloat)duration;
//
///**
// Used to fade all of the UI elements out
// */
//- (void)sceneGameFadeUIElementsOutDuration:(CGFloat)duration;
//
///**
// A super convient method for doing one thing and one thing only
//    but im not sure i should say here. I mean really this is a 
//    MVC and the view shall never have knowledge.. or shall it?
//    
//    Alright fine this is for a new move. there i said it...
// */
//- (void)updateSceneGameWithBackgroundColor:(UIColor *)backgroundColor
//                            totalScore:(float)totalScore
//                                  move:(SIMove *)move
//                        moveScoreLabel:(BMGlyphLabel *)moveScoreLabel
//            freeCoinProgressBarPercent:(float)freeCoinProgressBarPercent
//                     moveCommandString:(NSString *)moveCommandString;
//
///**
// I guess you could use this for a pause menu... if that's something
//    you're into.
// */
//- (void)sceneGameBlurDisplayRingNode:(HLRingNode *)ringNode;
//
///**
// Present a popup without a menu node
// */
//- (void)sceneGameWillDisplayPopup:(SIPopupNode *)popupNode;
///**
// Present a node modally with a pop up
// */
//- (void)sceneGameModallyPresentPopup:(SIPopupNode *)popupNode withMenuNode:(HLMenuNode *)menuNode;
//
/////**
//// Make and explosion at a point already set...
//// */
////- (void)sceneWillPresentEmitter:(SKEmitterNode *)emitter;
//
///**
// Called when the scene shall show a new high score
// */
//- (void)sceneGameWillShowHighScore;
//
///**
// Called when the scene shall notify the user they got a free coin
// */
//- (void)sceneGameWillShowFreeCoinEarned;
//
///**
// When you need to move power up progress bar on or off screen
// 
// */
//- (void)sceneGameMovePowerUpProgressBarOnScreen:(BOOL)willMoveOnScreen animate:(BOOL)animate;
//
///**
// The ad content
// 
// Default is nil...
// 
// We are just going to make this an SIAdBannerNode!
// */
//@property (nonatomic, strong) SIAdBannerNode *adBannerNode;
//
//@end
