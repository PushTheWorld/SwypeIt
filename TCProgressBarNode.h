//
//  TCProgressBarNode.h
//  TCProgressBarNode
//
//  Created by Charles Chamblee on 7/23/15.
//  Copyright (c) 2015 Tony Chamblee. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TCProgressBarNode : SKNode

/**Size of Progress Bar*/
@property (nonatomic) CGSize size;

/** Current progress of the progress bar, value between 0.0 and 1.0 */
@property (nonatomic) CGFloat progress;

/**The fill color*/
@property (nonatomic, strong) UIColor *fillColor;

/** Configurable title label, displayed centered in the progress bar by default */
@property (nonatomic, strong, readonly) SKLabelNode *titleLabelNode;

/** Uses hue special*/
@property (nonatomic, assign) BOOL colorDoesChange;

/** Initialize a plain progress bar with the given colors and sizes. */
- (instancetype)initWithSize:(CGSize)size
             backgroundColor:(UIColor *)backgroundColor
                   fillColor:(UIColor *)fillColor
                 borderColor:(UIColor *)borderColor
                 borderWidth:(CGFloat)borderWidth
                cornerRadius:(CGFloat)cornerRadius;

/** Initialize a custom progress bar with the given textures for background, fill and overlay layers */
- (instancetype)initWithBackgroundTexture:(SKTexture *)backgroundTexture
                              fillTexture:(SKTexture *)fillTexture
                           overlayTexture:(SKTexture *)overlayTexture;

@end
