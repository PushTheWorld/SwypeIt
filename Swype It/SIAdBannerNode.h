//  SIAdBannerNode.h
//  Swype It
//
//  Created by Andrew Keller on 9/2/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is the PTW banner ad... should make this internet connected!
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
#pragma mark - Delegate Protocol
@protocol SIAdBannerNodeDelegate <NSObject>
/// @name Managing Interaction

/**
 The delegate invoked on interaction
 
 */
- (void)adBannerWasTapped;

@end

@interface SIAdBannerNode : HLComponentNode <HLGestureTarget>

/// @name Required Delegate Method

/**
 Delegate methods
 */
@property (nonatomic, weak) id <SIAdBannerNodeDelegate> delegate;

/// @name Creating a Game Node [A node that has pinch, swipe, and tap gesture recognizers]

/**
 Initializes an ad banner 
 */
- (instancetype)initWithSize:(CGSize)size;

/**
 The size of the node.
 */
@property (nonatomic, assign) CGSize size;

/**
 The anchor point for the position of the `SIGameNode` within its parent.
 Default value `(0.0, 0.0)`.
 */
@property (nonatomic, assign) CGPoint anchorPoint;

/**
 The backgroundColor of the spriteNode
 Default value `redColor`.
 */
@property (nonatomic, strong) SKColor *backgroundColor;

/**
 Does this Ad pull from our servers?
 Default is `NO`
 */
@property (nonatomic, assign) BOOL doesPullAdFromRemote;

@end
