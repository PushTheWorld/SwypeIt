//  CustomProgressBar.h
//  Swype It
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>

@interface CustomProgressBar : SKCropNode

- (instancetype)initWithSize:(CGSize)size color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;
- (void)setProgress:(CGFloat)progress;

@end
