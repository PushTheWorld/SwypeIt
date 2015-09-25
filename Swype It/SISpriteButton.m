//
//  SISpriteButton.m
//  Swype It
//
//  Created by Andrew Keller on 9/25/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import "SISpriteButton.h"

@implementation SISpriteButton 

#pragma mark - Touch Stuff
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self runAction:[SKAction scaleTo:0.9f duration:0.2f]];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self animateReleased];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self animateReleased];
}

- (void)animateReleased {
    SKAction *grow      = [SKAction scaleTo:1.05f duration:0.2f];
    SKAction *shrink    = [SKAction scaleTo:0.95f duration:0.2f];
    SKAction *normalize = [SKAction scaleTo:1.0f duration:0.2f];
    SKAction *sequence  = [SKAction sequence:@[grow, shrink, normalize]];
    [self runAction:sequence];
}



@end
