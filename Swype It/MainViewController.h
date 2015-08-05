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
#import "HLSpriteKit.h"


@interface MainViewController : UIViewController
+ (CGFloat)             fontSizeButton;
+ (CGFloat)             fontSizeHeader;
+ (CGFloat)             fontSizeParagraph1;
+ (CGFloat)             fontSizeParagraph2;
+ (CGFloat)             fontSizeParagraph3;
+ (CGFloat)             fontSizeParagraph4;

+ (CGSize)              buttonSize:(CGSize)size;

+ (HLLabelButtonNode *) SI_sharedMenuButtonPrototypeBack:(CGSize)size;
+ (HLLabelButtonNode *) SI_sharedMenuButtonPrototypeBasic:(CGSize)size fontSize:(CGFloat)fontSize;
+ (HLLabelButtonNode *) SI_sharedMenuButtonPrototypeBasic:(CGSize)size fontSize:(CGFloat)fontSize backgroundColor:(SKColor *)backgroundColor fontColor:(UIColor *)fontColor;

+ (SKLabelNode *)       SI_sharedLabelHeader:(NSString *)text;
+ (SKLabelNode *)       SI_sharedLabelParagraph1:(NSString *)text;
+ (SKLabelNode *)       SI_sharedLabelParagraph2:(NSString *)text;
+ (SKLabelNode *)       SI_sharedLabelParagraph3:(NSString *)text;
+ (SKLabelNode *)       SI_sharedLabelParagraph4:(NSString *)text;
@end
