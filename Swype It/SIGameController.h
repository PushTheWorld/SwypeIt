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
#import "SIPopupGameOverOverDetailsRowNode.h"
// Framework Import
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "BMGlyphLabel.h"
#import "HLSpriteKit.h"
#import "INSpriteKit.h"
#import "TCProgressBarNode.h"
// Category Import
// Support/Data Class Imports
// Other Imports




@interface SIGameController : UIViewController
//+ (BMGlyphLabel *)BMGLabelLongIslandStroked;
//+ (BMGlyphLabel *)BMGLabelHiraginoKakuGothicText:(NSString *)text;
//+ (BMGlyphLabel *)BMGLabelSceneGameSwypeItCoins;
/**
 Gets the height of the ad banner view
 */
+ (CGFloat)             SIAdBannerViewHeight;
+ (CGFloat)             SIFontSizeButton;
+ (CGFloat)             SIFontSizeHeader;
+ (CGFloat)             SIFontSizeHeader_x2;
+ (CGFloat)             SIFontSizeHeader_x3;
+ (CGFloat)             SIFontSizeMoveCommand;
+ (CGFloat)             SIFontSizeMoveScore;
+ (CGFloat)             SIFontSizeParagraph;
+ (CGFloat)             SIFontSizeParagraph_x2;
+ (CGFloat)             SIFontSizeParagraph_x3;
+ (CGFloat)             SIFontSizeParagraph_x4;
+ (CGFloat)             SIFontSizeText;
+ (CGFloat)             SIFontSizeText_x2;
+ (CGFloat)             SIFontSizeText_x3;
+ (CGFloat)             SIFontSizeText_x4;
+ (CGFloat)xPaddingPopupContinue;

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
/**Quick zPosition for falling monkey scene content*/
+ (float)floatZPositionFallingMonkeyForContent:(SIZPositionFallingMonkey)layer;


+ (HLMenuNode *)SIHLMenuNodeSceneGamePopupContinue;

+ (INSKButtonNode *)SIINButtonNamed:(NSString *)name;
+ (INSKButtonNode *)SIINButtonNamed:(NSString *)name label:(SKLabelNode *)label;
//+ (INSKButtonNode *)SIINButtonPopupButtonImageNamed:(NSString *)imageName text:(NSString *)text;

/**Called when creating the grid for the start menu*/
+ (SIPopupNode *)SIPopupSceneGameContinueSize:(CGSize)size;
+ (SIPopupNode *)SIPopupNodeTitle:(NSString *)title SceneSize:(CGSize)sceneSize;
+ (SIPopupGameOverOverDetailsRowNode *)SIPopupGameOverDetailsRowNodeWithSize:(CGSize)size;
+ (SKTexture *)SITextureMonkeyFace;

+ (SKLabelNode *)SILabelText:(NSString *)text;
+ (SKLabelNode *)SILabelHeader:(NSString *)text;
+ (SKLabelNode *)SILabelHeader_x2:(NSString *)text;
+ (SKLabelNode *)SILabelHeader_x3:(NSString *)text;
+ (SKLabelNode *)SILabelParagraph:(NSString *)text;
+ (SKLabelNode *)SILabelParagraph_x2:(NSString *)text;
+ (SKLabelNode *)SILabelParagraph_x3:(NSString *)text;
+ (SKLabelNode *)SILabelParagraph_x4:(NSString *)text;
+ (SKLabelNode *)SILabelInterfaceFontSize:(CGFloat)fontSize;
+ (SKLabelNode *)SILabelSceneGameMoveCommand;
+ (SKLabelNode *)SILabelSceneGameMoveScoreLabel;
+ (SKLabelNode *)SILabelSceneGamePopupTitle;

/**
 This a spritenode made from falling monkey
    Utilize static variables to reduce overhead and reuseability
 */
+ (SKSpriteNode *)SISpriteNodeFallingMonkey;
+ (SKSpriteNode *)SISpriteNodeTarget;
+ (SKSpriteNode *)SISpriteNodePopupContinueCenterNode;

+ (SKSpriteNode *)SISpriteNodeBanana;
+ (SKSpriteNode *)SISpriteNodeBananaBunch;
+ (SKSpriteNode *)SISpriteNodePopupGameOverEndNode;

#pragma mark UIGestureRecognizers
+ (UIPinchGestureRecognizer *)SIGesturePinch;
+ (UISwipeGestureRecognizer *)SIGestureSwypeDown;
+ (UISwipeGestureRecognizer *)SIGestureSwypeLeft;
+ (UISwipeGestureRecognizer *)SIGestureSwypeUp;
+ (UISwipeGestureRecognizer *)SIGestureSwypeRight;
+ (UITapGestureRecognizer   *)SIGestureTap;

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
- (void)sceneGameDidRecieveMove:(SIMove *)move;

- (SIGameScene *)loadGameScene;

@end
