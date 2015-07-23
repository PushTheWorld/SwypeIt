//
//  StartScreenScene.m
//  Swype It
//
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
#import "AppSingleton.h"
#import "StartScreenScene.h"
#import "GameScene.h"
#import "UIColor+Additions.h"
#import "StoreScene.h"

@implementation StartScreenScene

-(nonnull instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor sandColor];
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        label.text = @"Welcome";
        label.fontColor = [SKColor blackColor];
        label.fontSize = 44;
        label.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        [self addChild:label];
        
        SKSpriteNode *oneHand   = [SKSpriteNode spriteNodeWithImageNamed:kSIImageButtonGameModeOneHand];
        [oneHand setScale:0.25];
        oneHand.name            = kSINodeButtonOneHand;
        oneHand.position        = CGPointMake(CGRectGetMidX(self.frame),
                                              CGRectGetMidY(self.frame) - (oneHand.frame.size.height/2.0f) - VERTICAL_SPACING_8);
        [self addChild:oneHand];
        
        SKSpriteNode *twoHand = [SKSpriteNode spriteNodeWithImageNamed:kSIImageButtonGameModeTwoHand];
        [twoHand setScale:0.25];
        twoHand.name            = kSINodeButtonTwoHand;
        twoHand.position        = CGPointMake(CGRectGetMidX(self.frame),
                                              oneHand.frame.origin.y - (oneHand.frame.size.height/2.0f) - VERTICAL_SPACING_8);
        [self addChild:twoHand];
        
        /*Store Button*/
        SKSpriteNode *store     = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:kSIImageButtonStore] size:CGSizeMake(size.width / 2.0f, size.width / 4.0f)];
        store.position          = CGPointMake(CGRectGetMidX(self.frame),
                                              twoHand.frame.origin.y - (twoHand.frame.size.height/2.0f) - VERTICAL_SPACING_8);
        store.name              = kSINodeButtonStore;
        [self addChild:store];
        
    }
    
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch      = [touches anyObject];
    CGPoint location    = [touch locationInNode:self];
    SKNode  *node       = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:kSINodeButtonOneHand]) {
        [self launchGameSceneForGameMode:SIGameModeOneHand];
    } else if ([node.name isEqualToString:kSINodeButtonTwoHand]) {
        [self launchGameSceneForGameMode:SIGameModeTwoHand];
    } else if ([node.name isEqualToString:kSINodeButtonStore]) {
        StoreScene *storeScene = [StoreScene sceneWithSize:self.size];
        storeScene.wasLaunchedFromMainMenu = YES;
        [self.view presentScene:storeScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.5]];

    } else {
        // Do Nothing...
        NSLog(@"Non button area touched");
    }
    
}
- (void)launchGameSceneForGameMode:(SIGameMode)gameMode {
    [[AppSingleton singleton] initAppSingletonWithGameMode:gameMode];
    GameScene *firstScene = [GameScene sceneWithSize:self.size];
    [self.view presentScene:firstScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.5]];
}

@end
