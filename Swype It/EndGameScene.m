//
//  EndGameScene.m
//  Swype It
//
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
#import "AppSingleton.h"
#import "EndGameScene.h"
#import "GameScene.h"
#import "StoreScene.h"
#import "UIColor+Additions.h"

@implementation EndGameScene
-(nonnull instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor sandColor];
        
        [self addLabels:size];
        [self addButtons:size];
    }
    
    return self;
}
- (void)addLabels:(CGSize)size {
    /*Game Over Label*/
    SKLabelNode *label          = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    label.text                  = @"Game Over";
    label.fontColor             = [SKColor blackColor];
    label.fontSize              = 44;
    label.position              = CGPointMake(size.width / 2.0f,size.height / 2.0f);
    [self addChild:label];
}
- (void)addButtons:(CGSize)size {
    /*Replay Button*/
    SKSpriteNode *replay        = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:kSIImageButtonReplay] size:CGSizeMake(size.width / 2.0f, size.width / 4.0f)];
    replay.position             = CGPointMake(-1.0f * (replay.size.width / 2.0f), (size.height / 2.0f) - replay.size.height);
    replay.name                 = kSINodeButtonReplay;
    
    SKAction *moveReplayButton  = [SKAction moveToX:size.width/2 duration:1.0];
    [replay runAction:moveReplayButton];
    [self addChild:replay];
    
    /*Store Button*/
    SKSpriteNode *store         = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:kSIImageButtonStore] size:CGSizeMake(size.width / 2.0f, size.width / 4.0f)];
    store.position              = CGPointMake(size.width + (store.size.width / 2.0f), (size.height / 2.0f) - replay.size.height - VERTICAL_SPACING_8 - store.size.height);
    store.name                  = kSINodeButtonStore;
    
    SKAction *moveStoreButton   = [SKAction moveToX:size.width/2 duration:1.0];
    [store runAction:moveStoreButton];
    [self addChild:store];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch          = [touches anyObject];
    CGPoint location        = [touch locationInNode:self];
    SKNode *node            = [self nodeAtPoint:location];

    if ([node.name isEqualToString:kSINodeButtonReplay]) {
        GameScene *firstScene = [GameScene sceneWithSize:self.size];
        [self.view presentScene:firstScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
    } else if ([node.name isEqualToString:kSINodeButtonStore]) {
        StoreScene *storeScene = [StoreScene sceneWithSize:self.size];
        [self.view presentScene:storeScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.5]];
    }
    
}

@end