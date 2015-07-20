//
//  StartScreenScene.m
//  Swype It
//
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import "StartScreenScene.h"
#import "GameScene.h"

@implementation StartScreenScene

-(nonnull instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blueColor];
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        label.text = @"GAME OVER";
        label.fontColor = [SKColor whiteColor];
        label.fontSize = 44;
        label.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        [self addChild:label];
        
        // second label
        SKLabelNode *tryAgain = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        tryAgain.text = @"Tap to start";
        tryAgain.fontColor = [SKColor whiteColor];
        tryAgain.fontSize = 24;
        tryAgain.position = CGPointMake(size.width/2, -50);
        
        SKAction *moveLabel = [SKAction moveToY:(size.height/2 - 40) duration:2.0];
        [tryAgain runAction:moveLabel];
        
        
        [self addChild:tryAgain];
        
    }
    
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GameScene *firstScene = [GameScene sceneWithSize:self.size];
    [self.view presentScene:firstScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.5]];
}

@end
