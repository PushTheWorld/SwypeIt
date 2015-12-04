//  SILoadingScene.h
//  Swype It
//
//  Created by Andrew Keller on 9/4/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "TCProgressBarNode.h"

@protocol SILoadingSceneDelegate <NSObject>

/**
 Called right after the view loads
 */
- (void)loadingSceneDidLoad;

/**
 Called after 3 seconds
 */
//- (void)loadingSceneDidFinishWaitTime;


@end
@interface SILoadingScene : SKScene

/**
 The delegate for the scene
 */
@property (weak, nonatomic) id <SILoadingSceneDelegate> sceneDelegate;

/**
 Sets the progress of the loading bar.. 0.0f - 1.0f
 */
- (void)sceneLoadingSetProgressPercent:(float)percent;

@end
