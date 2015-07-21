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
//#import "SIConstants.h"
// Other Imports


@implementation CustomProgressBar

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}
- (void)configureForSize:(CGSize)size withType:(SIProgressBar)progressBar {
    self.maskNode = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(size.width, size.height)];
    
    NSString *progressBarFillImageName;
    
    switch (progressBar) {
        case SIProgressBarMove:
            progressBarFillImageName = kSIImageProgressBarFill;
            break;
        case SIProgressBarPowerUp:
            progressBarFillImageName = kSIImageProgressBarPowerUpFill;
            break;
        default:
            progressBarFillImageName = kSIImageProgressBarFill;
            break;
    }
    
    SKSpriteNode *sprite    = [SKSpriteNode spriteNodeWithImageNamed:progressBarFillImageName];
    sprite.size             = size;
    
    sprite.anchorPoint      = CGPointMake(0, 0.5);
    
    [self addChild:sprite];
}
- (void)setProgress:(CGFloat)progress {
    self.maskNode.xScale = progress;
}

@end
