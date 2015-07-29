//
//  GameScene.h
//  Swype It
//
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HLSpriteKit.h"

@interface GameScene : HLScene <SKPhysicsContactDelegate>

- (instancetype)initWithSize:(CGSize)size gameMode:(SIGameMode)gameMode;

@end
