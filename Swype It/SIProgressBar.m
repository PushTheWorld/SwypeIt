//
//  SIProgressBar.m
//  Swype It
//
//  Created by Andrew Keller on 12/1/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: This is....
//
// Local Controller Import
#import "SIProgressBar.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIGame.h"
// Other Imports


@implementation SIProgressBar {
    CGFloat _barHeight;
    CGFloat _screenWidth;
}

#pragma mark -
#pragma mark - Node Life Cycle
- (instancetype)initWithScreenWidth:(CGFloat)width barHeight:(CGFloat)barHeight {
    self = [super init];
    if (self) {
        _screenWidth    = width;
        _barHeight      = barHeight;
        [self initSetup];
    }
    return self;
}

- (void)initSetup {
    [self createConstantsWithSize];
    [self createControlsWithSize];
    [self setupControlsWithSize];
}

/**
 Configure any constants
 */
- (void)createConstantsWithSize {
    _progress           = 1.0f;
}

/**
 Preform all your alloc/init's here
 */
- (void)createControlsWithSize {
    _node               = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(_screenWidth, _barHeight)];
    _node.anchorPoint   = CGPointMake(1.0f, 0.0f);
    
}

/**
 Configrue the labels, nodes and what ever else you can
 */
- (void)setupControlsWithSize {
    [self addChild:_node];
    
}

/**
 Layout both the XY & Z
 */
- (void)layoutXYZ {
    [self layoutXY];
    [self layoutZ];
}

/**
 Layout the XY
 */
- (void)layoutXY {
    
}

/**
 Layout the Z
 */
- (void)layoutZ {
    
}

#pragma mark -
#pragma mark - Public Accessors
- (void)setProgress:(float)progress {
    _progress = MIN(MAX(progress, 0.0), 1.0);
    [self updateProgress];

}



#pragma mark -
#pragma mark - Class Functions
- (void)updateProgress {
    _node.size = CGSizeMake(round(_screenWidth * (1.0 - _progress)), _barHeight);
    
}

@end
