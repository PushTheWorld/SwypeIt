//  CustomProgressBar.h
//  Swype It
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
#import "SIConstants.h"
#import <SpriteKit/SpriteKit.h>

@interface CustomProgressBar : SKCropNode

- (void)configureForSize:(CGSize)size withType:(SIProgressBar)progressBar;
- (void)setProgress:(CGFloat)progress;

@end
