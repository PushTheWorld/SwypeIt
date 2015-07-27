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


- (instancetype)initWithSize:(CGSize)size color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    if (self = [super init]) {
        [self addProgressBar:size color:color cornerRadius:cornerRadius];
    }
    return self;
}
//- (void)configureForSize:(CGSize)size withType:(SIProgressBar)progressBar {
//    
//    
//    NSString *progressBarFillImageName;
//    
//    switch (progressBar) {
//        case SIProgressBarMove:
//            progressBarFillImageName = kSIImageProgressBarFill;
//            break;
//        case SIProgressBarPowerUp:
//            progressBarFillImageName = kSIImageProgressBarPowerUpFill;
//            break;
//        default:
//            progressBarFillImageName = kSIImageProgressBarFill;
//            break;
//    }
//    
//
//}
- (void)addProgressBar:(CGSize)size color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    
    SKShapeNode *maskNode;
#ifdef __IPHONE_8_0
    maskNode                = [SKShapeNode shapeNodeWithRectOfSize:size cornerRadius:cornerRadius];
#else
    maskNode                = [SKShapeNode node];
    [maskNode setPath:CGPathCreateWithRoundedRect(CGRectMake(-1.0f * (size.width / 2.0f), -1.0f * (size.height / 2.0f), size.width, size.height), cornerRadius, cornerRadius, nil)];
#endif
    
    maskNode.fillColor      = [SKColor whiteColor];
    
    self.maskNode           = maskNode;
    
    SKSpriteNode *sprite    = [SKSpriteNode spriteNodeWithColor:color size:CGSizeMake(size.width, size.height)];
    
    sprite.anchorPoint      = CGPointMake(0, 0.5);
    
    [self addChild:sprite];
}
- (void)setProgress:(CGFloat)progress {
    self.maskNode.xScale = progress;
}

@end
