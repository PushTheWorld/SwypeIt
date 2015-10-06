//
//  SIPopupGameOverOverDetailsRowNode.m
//  Swype It
//
//  Created by Andrew Keller on 9/30/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is for a row on the final game scene
//
// Local Controller Import
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIGameController.h"
// Other Imports
#import "SIPopupGameOverOverDetailsRowNode.h"

@implementation SIPopupGameOverOverDetailsRowNode  {
    SKSpriteNode            *_backgroundNode;
}

#pragma mark -
#pragma mark - Node Life Cycle
- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        [self initSetup:size];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    SIPopupGameOverOverDetailsRowNode *copy = [super copyWithZone:zone];
    if (copy) {
        copy->_backgroundNode = _backgroundNode;
        copy->_textLabel = _textLabel;
        copy->_scoreLabel = _scoreLabel;
    }
    return copy;
}

- (void)initSetup:(CGSize)size {
    [self createConstantsWithSize:size];
    [self createControlsWithSize:size];
    [self setupControlsWithSize:size];
}

/**
 Configure any constants
 */
- (void)createConstantsWithSize:(CGSize)size {
    
}

/**
 Preform all your alloc/init's here
 */
- (void)createControlsWithSize:(CGSize)size {
    _backgroundNode = [SKSpriteNode spriteNodeWithColor:[SKColor SIColorSecondary] size:size];
    
    _textLabel      = [SIGameController SILabelText:@"Score"];
    _scoreLabel     = [SIGameController SILabelText:@"0.0"];
}

/**
 Configrue the labels, nodes and what ever else you can
 */
- (void)setupControlsWithSize:(CGSize)size {
    _textLabel.verticalAlignmentMode        = SKLabelVerticalAlignmentModeCenter;
    _textLabel.horizontalAlignmentMode      = SKLabelHorizontalAlignmentModeLeft;

    _scoreLabel.verticalAlignmentMode       = SKLabelVerticalAlignmentModeCenter;
    _scoreLabel.horizontalAlignmentMode     = SKLabelHorizontalAlignmentModeRight;
    
    [self addChild:_backgroundNode];
    
    [_backgroundNode addChild:_textLabel];
    [_backgroundNode addChild:_scoreLabel];
    
    [self layoutXYZ];
}

- (void)setScoreLabel:(SKLabelNode *)scoreLabel {
    _scoreLabel = scoreLabel;
    [self layoutXY];
}

- (void)setTextLabel:(SKLabelNode *)textLabel {
    _textLabel = textLabel;
    [self layoutXY];
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
    _textLabel.position                     = CGPointMake((-1.0f * (_backgroundNode.size.width / 2.0f) + VERTICAL_SPACING_8), 0.0f);
    _scoreLabel.position                    = CGPointMake((_backgroundNode.size.width / 2.0f) - VERTICAL_SPACING_8, 0.0f);
}

/**
 Layout the Z
 */
- (void)layoutZ {
    _backgroundNode.zPosition               = [SIGameController floatZPositionPopupForContent:SIZPositionPopupContent];
    _textLabel.zPosition                    = [SIGameController floatZPositionPopupForContent:SIZPositionPopupContent];
    _scoreLabel.zPosition                   = [SIGameController floatZPositionPopupForContent:SIZPositionPopupContent];

}

#pragma mark -
#pragma mark - Class Functions


@end
