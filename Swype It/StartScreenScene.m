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

@implementation StartScreenScene

-(nonnull instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blueColor];
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        label.text = @"Welcome";
        label.fontColor = [SKColor whiteColor];
        label.fontSize = 44;
        label.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        [self addChild:label];
        
        SKSpriteNode *oneHand   = [SKSpriteNode spriteNodeWithImageNamed:kSIImageButtonGameModeOneHand];
        [oneHand setScale:0.25];
        oneHand.name            = kSINodeButtonOneHand;
        oneHand.position        = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - (oneHand.frame.size.height/2.0f) - VERTICAL_SPACING_8);
        [self addChild:oneHand];
        
        SKSpriteNode *twoHand = [SKSpriteNode spriteNodeWithImageNamed:kSIImageButtonGameModeTwoHand];
        [twoHand setScale:0.25];
        twoHand.name            = kSINodeButtonTwoHand;
        twoHand.position        = CGPointMake(CGRectGetMidX(self.frame), oneHand.frame.origin.y - (oneHand.frame.size.height/2.0f) - VERTICAL_SPACING_8);
        [self addChild:twoHand];
        
        // second label
//        SKLabelNode *tryAgain = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
//        tryAgain.text = @"Tap to start";
//        tryAgain.fontColor = [SKColor whiteColor];
//        tryAgain.fontSize = 24;
//        tryAgain.position = CGPointMake(size.width/2, -50);
        
        
//        SKAction *moveLabel = [SKAction moveToY:(size.height/2 - 40) duration:0.5];
//        [tryAgain runAction:moveLabel];
//        
//        
//        [self addChild:tryAgain];
        
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
