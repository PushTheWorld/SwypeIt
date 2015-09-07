//  SILoadingScene.h
//  Swype It
//
//  Created by Andrew Keller on 9/4/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "TCProgressBarNode.h"

@interface SILoadingScene : SKScene

/**
 Sets the progress of the progress bar
 */
- (void)sceneLoadingWillLoadProgressPercent:(float)percent;

@end
