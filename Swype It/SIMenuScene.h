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
// Framework Import
#import <SpriteKit/SpriteKit.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
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
- (void)sceneMenuDidLoadType:(SISceneMenuType)sceneMenuType;



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
 Setting this property will handle all animations for going to a differnt configuration of the
    menu scene
 */
@property (nonatomic, assign) SISceneMenuType sceneMenuType;





@end
