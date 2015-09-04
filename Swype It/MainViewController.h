//
//  MainViewController.h
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



@interface MainViewController : UIViewController
+ (CGFloat)             fontSizeButton;
+ (CGFloat)             fontSizeHeader;
+ (CGFloat)             fontSizeHeader_x2;
+ (CGFloat)             fontSizeHeader_x3;
+ (CGFloat)             fontSizeMoveCommand;
+ (CGFloat)             fontSizeParagraph;
+ (CGFloat)             fontSizeParagraph_x2;
+ (CGFloat)             fontSizeParagraph_x3;
+ (CGFloat)             fontSizeParagraph_x4;
+ (CGFloat)             fontSizeText;
+ (CGFloat)             fontSizeText_x2;
+ (CGFloat)             fontSizeText_x3;

+ (CGSize)              buttonSize:(CGSize)size;

+ (HLLabelButtonNode *) SI_sharedMenuButtonPrototypeBack:(CGSize)size;
+ (HLLabelButtonNode *) SI_sharedMenuButtonPrototypeBasic:(CGSize)size;
+ (HLLabelButtonNode *) SI_sharedMenuButtonPrototypeBasic:(CGSize)size backgroundColor:(UIColor *)backgroundColor fontColor:(UIColor *)fontColor;
+ (HLLabelButtonNode *) SI_sharedMenuButtonPrototypePopUp:(CGSize)size;

+ (NSDate *)            getDateFromInternet;

+ (SIPopupNode *)       SISharedPopUpNodeTitle:(NSString *)title SceneSize:(CGSize)sceneSize;

+ (SKTexture *)         sharedMonkeyFace;

+ (SKLabelNode *)       SI_sharedLabelHeader:(NSString *)text;
+ (SKLabelNode *)       SI_sharedLabelHeader_x2:(NSString *)text;
+ (SKLabelNode *)       SI_sharedLabelHeader_x3:(NSString *)text;
+ (SKLabelNode *)       SI_sharedLabelParagraph:(NSString *)text;
+ (SKLabelNode *)       SI_sharedLabelParagraph_x2:(NSString *)text;
+ (SKLabelNode *)       SI_sharedLabelParagraph_x3:(NSString *)text;
+ (SKLabelNode *)       SI_sharedLabelParagraph_x4:(NSString *)text;
+ (SKLabelNode *)       SIInterfaceLabelFontSize:(CGFloat)fontSize;

/**
 Hids the banner ad
 */
- (void)bannerAdHide;
/**
 Shows the banner ad
 */
- (void)bannerAdShow;
/**
 Present the interstital ad
 */
- (void)presentInterstital;
/**
 Gets the height of the ad banner view
 */
+ (CGFloat)bannerViewHeight;
/**
 Returns if user is premium
 */
+ (BOOL)isPremiumUser;



@end
