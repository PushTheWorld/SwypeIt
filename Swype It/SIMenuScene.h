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
@protocol SIMenuSceneDelegate <NSObject>

/**
 Called right after a new scene has been loaded... essentially
    notifies that the scene is ready to animate in the buttons and 
    such
 */
- (void)controllerSceneMenuDidLoadType:(SISceneMenuType)type;

/**
 Called when the back button is pressed
 */
- (void)controllerSceneMenuDidTapBackButton;



@end
@interface SIMenuScene : HLScene

/**
 The delegate for the scene
 */
@property (weak, nonatomic) id <SIMenuSceneDelegate> sceneDelegate;

/**
 The bottom toolbar... this allows you to put what ever you want in here
    
 Use Case: that peskey user pays for ad free and you need to reconfigure our banner node
 */
@property (assign, nonatomic)HLToolbarNode *toolBarBottom;

/**
 The ad content
 
 Default is nil...
 */
@property (nonatomic, strong) SIAdBannerNode *adBannerNode;

/**
 The duration for how long it takes to animate objects in for layout
 default is `1.0f`
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 Setting this property will handle all animations for going to a differnt configuration of the
    menu scene
 */
@property (nonatomic, assign) SISceneMenuType type;

/**
 Use this to easily present a grid of buttons to click on
 */
@property (nonatomic, strong) HLGridNode *gridNode;

/**
 Toolbar to be displayed towards the bottom
 */
@property (nonatomic, strong) HLToolbarNode *toolbarNode;

/**
 Spacing between the bottom of the toolbar and the background node
 Default `4.0f`
 */
@property (nonatomic, assign) CGFloat spacingToolbarBottom;

/**
 Oh yeah, so good news kids! if you set this to content it will get blaster up to the top of the screen!!
 */
@property (nonatomic, strong) SIPopupNode *popupNode;

/**
 Set the menu node of the thing
 */
@property (nonatomic, strong) SIMenuNode *menuNode;










@end
