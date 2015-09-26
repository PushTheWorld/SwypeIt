//
//  StartScreenScene.h
//  Swype It
//
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is start screen
//
// Local Controller Import
// Framework Import
#import <SpriteKit/SpriteKit.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "HLSpriteKit.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIGame.h"
// Other Imports

@protocol StartDelegate <NSObject>

/**
 Start toolbar button was tapped
 */
- (void)sceneStartToolbarNodeWasTapped:(SISceneStartToolBarNode)toolbarNode;

@end

@interface StartScene : HLScene



@end
