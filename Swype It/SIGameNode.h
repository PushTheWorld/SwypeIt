//  SIGameNode.h
//  Swype It
//
//  Created by Andrew Keller on 8/10/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is the main game node that will be used for recognizing gestures for gaem play
//
// Local Controller Import
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "HLComponentNode.h"
#import "HLGestureTarget.h"
// Category Import
// Support/Data Class Imports
#import "Game.h"
// Other Imports
@protocol SIGameNodeDelegate <NSObject>

/// @name Managing Interaction

/**
 The delegate invoked on interaction
 
 */
//- (BOOL)gestureDidBegin:(SIMove)move;
- (void)gestureEnded:(SIMove)move;
- (void)monkeyTapped:(SKNode *)node;

@end

@interface SIGameNode : HLComponentNode <HLGestureTarget>

/// @name Optional Delegate Method

/**
 Delegate methods
 */
@property (nonatomic, weak) id <SIGameNodeDelegate> delegate;

/// @name Creating a Game Node [A node that has pinch, swipe, and tap gesture recognizers]

/**
 Initializes an `SIGameNode` in either SIGameModeOneHand or SIGameModeTwoHand
 Default color is red
 */
- (instancetype)initWithSize:(CGSize)size gameMode:(SIGameMode)gameMode;

/**
 The size of the node.
 */

@property (nonatomic, assign) CGSize size;

/**
 The anchor point for the position of the `SIGameNode` within its parent.
 Default value `(0.5, 0.5)`.
 */
@property (nonatomic, assign) CGPoint anchorPoint;

/**
 The backgroundColor of the spriteNode
 Default value `redColor`.
 */
@property (nonatomic, strong) SKColor *backgroundColor;

/// @name Configuring Node Geometry

/**
 Effects layout according to all object properties.
 
 In general, this method must be called after modifying any geometry-related (layout-affecting) 
 object property.  Requiring an explicit call allows the caller to set multiple properties at 
 the same time efficiently.
 */
- (void)layoutToolsAnimation;

@end
