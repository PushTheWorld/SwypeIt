//  SIMenuNode.h
//  Swype It
//
//  Created by Andrew Keller on 9/14/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is the header file for the menu nodes
//
// Local Controller Import
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
// Support/Data Class Imports
#import "SIGame.h"
// Other Imports
#import "HLSpriteKit.h"

@class SIMenuNode;
@protocol SIMenuNodeDelegate <NSObject>
@optional

/// @name Managing Interaction

/**
 The delegate invoked on back button presses
 
 */
- (void)menuNodeDidTapBackButton:(SIMenuNode *)menuNode;

@end

@interface SIMenuNode : HLComponentNode

/// @name Delegate Method

/**
 Delegate methods
 */
@property (nonatomic, weak) id <SIMenuNodeDelegate> delegate;

/**
 Init the backgrond node with size
 */
- (instancetype)initWithSize:(CGSize)size Node:(SKNode *)mainNode type:(SISceneMenuType)type;

/**
 The duration for how long it takes to animate objects in for layout
 default is `1.0f`
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 Set true when you want the back button to be activated
 */
@property (nonatomic, assign) BOOL backButtonVisible;

/**
 Set this if you want the menu to have a bottom toolbar....
    This will allow a move toolbar to move in sink
 */
@property (nonatomic, strong) HLToolbarNode *bottomToolBarNode;

/**
 Bottom toolbar bottom y padding
    Default is `8.0`
 */
@property (nonatomic, assign) CGFloat bottomToolbarYPadding;

/**
 The main node of info to be displayed
 */
@property (nonatomic, strong) SKNode *mainNode;

/**
 Returns the size of the whole thing... generally will be a sceneSize
 */
@property (nonatomic, assign) CGSize size;

/**
 Bottom toolbar bottom y padding
 Default is `8.0`
 */
@property (nonatomic, assign) CGFloat topTitleYPadding;

/**
 The type of menu
 */
@property (nonatomic, assign) SISceneMenuType type;

/**
 Use for aninmating the menu in
 */
- (void)layoutXYAnimation:(SIMenuNodeAnimation)animation;




@end
