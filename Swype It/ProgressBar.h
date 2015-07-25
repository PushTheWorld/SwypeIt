//
//  ProgressBar.h
//  Swype It
//
//  Created by Andrew Keller on 7/25/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ProgressBar : SKNode

#pragma mark - Convience Methods
- (instancetype)initWithSize:(CGSize)size progressColor:(UIColor *)progressColor backgroundColor:(UIColor *)backgroundColor;
- (instancetype)initWithSize:(CGSize)size progressColor:(UIColor *)progressColor backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius;

#pragma mark - Public Methods
- (void)setProgress:(CGFloat)progress;

@end
