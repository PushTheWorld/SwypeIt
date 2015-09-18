//  SIPopupContentNode.m
//  Swype It
//
//  Created by Andrew Keller on 9/14/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is....
//
// Local Controller Import
#import "SIPopupContentNode.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports

enum {
    SIPopUpNodeContentZPositionLayerBackground = 0,
    SIPopUpNodeContentZPositionLayerContent,
    SIPopUpNodeContentZPositionLayerText,
    SIPopUpNodeContentZPositionLayerCount
};
@implementation SIPopupContentNode {
    
    SKSpriteNode    *_backgroundNode;
    SKSpriteNode    *_backgroundImageContentNode;
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _size = CGSizeZero;
        _backgroundNode = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeZero];
        [self addChild:_backgroundNode];
    }
    return self;
}

- (instancetype)initWithSize:(CGSize)size {
    self = [self init];
    if (self) {
        _size = size;
        _backgroundNode.size        = size;
        _backgroundNode.anchorPoint = CGPointMake(0.5f, 0.5f);
        _backgroundNode.position    = CGPointZero;
    }
    return self;
}

- (void)setLabelNode:(SKLabelNode *)labelNode {
    if (_labelNode) {
        [_labelNode removeFromParent];
    }
    if (labelNode) {
        _labelNode = labelNode;
        [_backgroundNode addChild:_labelNode];
    }
    [self layoutXYZ];
}

- (void)setBackgroundImageNode:(SKSpriteNode *)backgroundImageNode {
    if (_backgroundImageContentNode) {
        [_backgroundImageContentNode removeFromParent];
    }
    if (backgroundImageNode) {
        _backgroundImageContentNode = backgroundImageNode;
        [_backgroundNode addChild:_backgroundImageContentNode];
    }
    [self layoutXYZ];
}

- (void)layoutXYZ {
    [self layoutXY];
    [self layoutZ];
}

- (void)layoutXY {
    if (_labelNode) {
        _labelNode.position  = CGPointMake(0.0f, -1.0f * _size.height / 2.0f);
    }
    
    if (_backgroundImageContentNode) {
        _backgroundImageContentNode.position = CGPointZero;
    }
}

- (void)layoutZ {
    if (_backgroundImageContentNode) {
        _backgroundImageContentNode.zPosition   = (float)SIPopUpNodeContentZPositionLayerBackground / (float)SIPopUpNodeContentZPositionLayerCount;
    }
    
    if (_labelNode) {
        _labelNode.zPosition             = (float)SIPopUpNodeContentZPositionLayerContent / (float)SIPopUpNodeContentZPositionLayerCount;
    }
}



@end
