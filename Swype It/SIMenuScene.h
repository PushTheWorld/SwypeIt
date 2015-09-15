//  SIMenuScene.h
//  Swype It
//
//  Created by Andrew Keller on 9/6/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is main menu screen
//
// Local Controller Import
#import "SIAdBannerNode.h"
#import "SIPopupNode.h"
#import "SIMenuNode.h"
// Framework Import
#import <SpriteKit/SpriteKit.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "BMGlyphLabel.h"
#import "HLSpriteKit.h"
// Category Import
// Support/Data Class Imports
#import "SIGame.h"
// Other Imports
@protocol SIMenuSceneDelegate <NSObject, SIMenuNodeDelegate>

///**
// Called right after a new scene has been loaded... essentially
//    notifies that the scene is ready to animate in the buttons and 
//    such
// */
//- (void)controllerSceneMenuDidLoadType:(SISceneMenuType)type;





@end
@interface SIMenuScene : HLScene

/**
 The delegate for the scene
 */
@property (weak, nonatomic) id <SIMenuSceneDelegate> sceneDelegate;

/**
 The ad content
 Default is nil...
 */
@property (nonatomic, strong) SIAdBannerNode *adBannerNode;

/**
 The duration for how long it takes to animate objects in for layout
 default is `1.0f` or `SCENE_TRANSISTION_DURATION_NORMAL`
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 Oh yeah, so good news kids! if you set this to content it will get blaster up to the top of the screen!!
 */
@property (nonatomic, strong) SIPopupNode *popupNode;

/**
 Show a menu node and animate it
 */
- (void)showMenuNode:(SIMenuNode *)menuNode menuNodeAnimation:(SIMenuNodeAnimation)menuNodeAnimation;






@end
