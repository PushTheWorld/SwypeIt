//  CustomProgressBar.m
//  Swype It
//
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: Thie is the custom progress view....
//
// Local Controller Import
#import "CustomProgressBar.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIConstants.h"
// Other Imports


@implementation CustomProgressBar

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}
- (void)configureForSize:(CGSize)size {
    self.maskNode = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(size.width, size.height)];
    
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:kSIImageProgressBarFill];
    sprite.anchorPoint      = CGPointMake(0, 0.5);
    
    [self addChild:sprite];
}
- (void)setProgress:(CGFloat)progress {
    self.maskNode.xScale = progress;
}

@end
