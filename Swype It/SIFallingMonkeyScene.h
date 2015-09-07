//
//  SIFallingMonkeyScene.h
//  Swype It
//
//  Created by Andrew Keller on 9/4/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import "HLScene.h"
@protocol SIFallingMonkeySceneDelegate <NSObject>

/**
 Called when the scene registers a monkey tap
 */
- (void)sceneFallingMonkeyWasTappedMonkey:(SKNode *)monkey;

/**
 Called when a monkey has hit the bottom of the screen
 */
- (void)sceneFallingMonkeyDidCollideWithBottomEdge;

@end

@interface SIFallingMonkeyScene : HLScene

/**
 The delegate for the scene
 */
@property (weak, nonatomic) id <SIFallingMonkeySceneDelegate> sceneDelegate;

/**
 The initializer for the monkey scene
 */
- (instancetype)initWithSize:(CGSize)size;

/**
 Called to launch a monkey from the scene
 */
- (void)launchMonkeyFromLocation:(CGPoint)location;

/**
 This is the score label.. you can change
 */
@property (strong, nonatomic) NSString *scoreString;

/**
 The ad content
 
 Default is nil... 
 
 We are just going to make this an SIAdBannerNode!
 */
@property (nonatomic, strong) SIAdBannerNode *adBannerNode;


@end
