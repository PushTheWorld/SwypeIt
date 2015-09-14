//
//  SIGameController.h
//  Swype It
//
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
// Framworks
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
// Dropin Classes
#import "BaseViewController.h"
#import "HLSpriteKit.h"
#import "SIPopupNode.h"



@interface SIGameController : UIViewController
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

/**Quick zPosition for game content*/
+ (float)floatZPositionGameForContent:(SIZPositionGame)layer;
/**Quick zPosition for popup content*/
+ (float)floatZPositionPopupForContent:(SIZPositionPopup)layer;

+ (HLLabelButtonNode *) SILabelButtonMenuPrototypeBack:(CGSize)size;
+ (HLLabelButtonNode *) SILabelButtonMenuPrototypeBasic:(CGSize)size;
+ (HLLabelButtonNode *) SILabelButtonMenuPrototypeBasic:(CGSize)size backgroundColor:(UIColor *)backgroundColor fontColor:(UIColor *)fontColor;
+ (HLLabelButtonNode *) SILabelButtonMenuPrototypePopUp:(CGSize)size;
/**
 Returns the number of coins the user has
 */
+ (int)numberOfCoinsForUser;

+ (NSDate *)            getDateFromInternet;

+ (SIPopupNode *)       SIPopUpNodeTitle:(NSString *)title SceneSize:(CGSize)sceneSize;

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

/** For animating a node for a screen */
+ (void)SIControllerNode:(SKNode *)node
               animation:(SISceneContentAnimation)animation
          animationStyle:(SISceneContentAnimationStyle)animationStyle
       animationDuration:(float)animationDuration
         positionVisible:(CGPoint)positionVisible
          positionHidden:(CGPoint)positionHidden;



@end
