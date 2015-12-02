//
//  SIProgressBar.h
//  Swype It
//
//  Created by Andrew Keller on 12/1/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SIProgressBar : SKNode

- (instancetype)initWithScreenWidth:(CGFloat)width barHeight:(CGFloat)barHeight;

/**
 Set the progress of the node
 Between `0` - `1.0`
 */
@property (assign, nonatomic) float progress;

/**
 The node
 */
@property (strong, nonatomic) SKSpriteNode *node;


@end
