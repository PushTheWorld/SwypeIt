//
//  SIGameController.h
//  Swype It
//
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is the header for the controller class
//
// Local Controller Import
#import "BaseViewController.h"
#import "SIGameScene.h"
#import "SIPopupNode.h"
// Framework Import
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "BMGlyphLabel.h"
#import "HLSpriteKit.h"
#import "TCProgressBarNode.h"
// Category Import
// Support/Data Class Imports
// Other Imports




@interface SIGameController : UIViewController
+ (BMGlyphLabel *)BMGLabelLongIslandStroked;
+ (BMGlyphLabel *)BMGLabelHiraginoKakuGothicText:(NSString *)text;
/**
 Gets the height of the ad banner view
 */
+ (CGFloat)             SIAdBannerViewHeight;
+ (CGFloat)             SIFontSizeButton;
+ (CGFloat)             SIFontSizeHeader;
+ (CGFloat)             SIFontSizeHeader_x2;
+ (CGFloat)             SIFontSizeHeader_x3;
+ (CGFloat)             SIFontSizeMoveCommand;
+ (CGFloat)             SIFontSizeParagraph;
+ (CGFloat)             SIFontSizeParagraph_x2;
+ (CGFloat)             SIFontSizeParagraph_x3;
+ (CGFloat)             SIFontSizeParagraph_x4;
+ (CGFloat)             SIFontSizeText;
+ (CGFloat)             SIFontSizeText_x2;
+ (CGFloat)             SIFontSizeText_x3;

+ (CGSize)              SIButtonSize:(CGSize)size;
+ (CGSize)              SIFallingMonkeySize;
/**
 Input the scene size
 */
+ (CGSize)SIProgressBarGameFreeCoinSize:(CGSize)size;
/**
 Input the scene size
 */
+ (CGSize)SIProgressBarGameMoveSize:(CGSize)size;
/**
 Input the scene size
 */
+ (CGSize)SIProgressBarGamePowerUpSize:(CGSize)size;

+ (CGSize)SIToolbarSceneMenuSize:(CGSize)size;

/**Quick zPosition for game content*/
+ (float)floatZPositionGameForContent:(SIZPositionGame)layer;
/**Quick zPosition for menu content*/
+ (float)floatZPositionMenuForContent:(SIZPositionMenu)layer;
/**Quick zPosition for popup content*/
+ (float)floatZPositionPopupForContent:(SIZPositionPopup)layer;

/**Called when creating the grid for the start menu*/
//+ (HLGridNode *)SIHLGridNodeMenuSceneStartSize:(CGSize)size;
//+ (HLMenuNode *)SIHLMenuNodeSceneGamePopup:(SIPopupNode *)popupNode;
//+ (HLRingNode *)SIHLRingNodeSceneGamePause;
//+ (HLToolbarNode *)SIHLToolbarGamePowerUpToolbarSize:(CGSize)toolbarSize toolbarNodeSize:(CGSize)toolbarNodeSize horizontalSpacing:(CGFloat)horizontalSpacing;
//+ (SIPopupNode *)SIPopupSceneGameContinue;
+ (SIPopupNode *)SIPopupNodeTitle:(NSString *)title SceneSize:(CGSize)sceneSize;
//+ (TCProgressBarNode *)SIProgressBarSceneGameFreeCoinSceneSize:(CGSize)size;
//+ (TCProgressBarNode *)SIProgressBarSceneGameMoveSceneSize:(CGSize)size;
//+ (TCProgressBarNode *)SIProgressBarSceneGamePowerUpSceneSize:(CGSize)size;

+ (SKTexture *)         SITextureMonkeyFace;

+ (SKLabelNode *)       SILabelHeader:(NSString *)text;
+ (SKLabelNode *)       SILabelHeader_x2:(NSString *)text;
+ (SKLabelNode *)       SILabelHeader_x3:(NSString *)text;
+ (SKLabelNode *)       SILabelParagraph:(NSString *)text;
+ (SKLabelNode *)       SILabelParagraph_x2:(NSString *)text;
+ (SKLabelNode *)       SILabelParagraph_x3:(NSString *)text;
+ (SKLabelNode *)       SILabelParagraph_x4:(NSString *)text;
+ (SKLabelNode *)       SILabelInterfaceFontSize:(CGFloat)fontSize;
+ (SKLabelNode *)       SILabelSceneGameMoveCommand;

/**
 This a spritenode made from falling monkey
    Utilize static variables to reduce overhead and reuseability
 */
+ (SKSpriteNode *)SISpriteNodeFallingMonkey;

//+ (void)SILoaderEmitters;

/** For animating a node for a screen */
+ (void)SIControllerNode:(SKNode *)node
               animation:(SISceneContentAnimation)animation
          animationStyle:(SISceneContentAnimationStyle)animationStyle
       animationDuration:(float)animationDuration
         positionVisible:(CGPoint)positionVisible
          positionHidden:(CGPoint)positionHidden;


#pragma mark - Public Methods for Testing
- (void)launchSceneGameWithGameMode:(SIGameMode)gameMode;
- (void)controllerSceneGameDidRecieveMove:(SIMove *)move;
- (SIGameScene *)loadGameScene;

@end
