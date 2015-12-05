//
//  SIUserHelpPopTip.m
//  Swype It
//
//  Created by Andrew Keller on 11/27/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: This is the implementation file for a pop tip
//
// Local Controller Import
#import "SIGameController.h"
#import "SIPopTip.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "DSMultilineLabelNode.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports


@implementation SIPopTip {
    CGSize                                       _size;
    
    DSMultilineLabelNode                        *_multiLineNode;
    
    SKAction                                    *_bounceEffect;
    
    SKColor                                     *_backgroundColor;
    
    SKSpriteNode                                *_backgroundNode;
    SKSpriteNode                                *_pointerNode;
    SKSpriteNode                                *_pointerNodeNormal;
    SKSpriteNode                                *_pointerNodeReverse;
    
    
}

#pragma mark -
#pragma mark - Node Life Cycle
- (instancetype)initWithSize:(CGSize)size withMessage:(NSString *)message {
    self = [super init];
    if (self) {
        _message                                = message;
        _size                                   = size;
        [self initSetup:size];
    }
    return self;
    
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
    
    _backgroundColor                            = [UIColor simplstMainColor];
    
    _positionVertical                           = SIPopTipPositionVerticalBottom;
    _positionHorizontal                         = SIPopTipPositionHorizontalCenter;
    
    _effect                                     = SIPopTipEffectNone;
    
    _effectDeltaY                               = 10.0f;
    
    _bounceEffect                               = [SIPopTip createBounceEffectActionWithDeltaY:_effectDeltaY];

    
}

/**
 Preform all your alloc/init's here
 */
- (void)createControlsWithSize:(CGSize)size {
    
    _backgroundNode                             = [SKSpriteNode spriteNodeWithTexture:[SIGame textureBackgroundColor:_backgroundColor size:_size cornerRadius:4.0f borderWidth:0.0f borderColor:[UIColor clearColor]]];
    
    _pointerNodeNormal                          = [SKSpriteNode spriteNodeWithImageNamed:kSIAssestPopTipPointer];
    _pointerNodeReverse                         = [SKSpriteNode spriteNodeWithImageNamed:kSIAssestPopTipPointerReverse];

    _multiLineNode                              = [[DSMultilineLabelNode alloc] initWithFontNamed:kSISFFontTextMedium];
    
}

/**
 Configrue the labels, nodes and what ever else you can
 */
- (void)setupControlsWithSize:(CGSize)size {
    _backgroundNode.anchorPoint                 = CGPointMake(0.5f, 0.5f);
    [self addChild:_backgroundNode];

    /*Set the paragraph width to spacing times two minus 4*/
    _multiLineNode.paragraphWidth               = _size.width - (VERTICAL_SPACING_4 * 2);
    _multiLineNode.fontColor                    = [SKColor whiteColor];
    _multiLineNode.fontSize                     = [SIGameController SIFontSizeText_x2];
    _multiLineNode.text                         = _message;
    _multiLineNode.verticalAlignmentMode        = SKLabelVerticalAlignmentModeCenter;
    _multiLineNode.horizontalAlignmentMode      = SKLabelHorizontalAlignmentModeCenter;
    [_backgroundNode addChild:_multiLineNode];
    
    [_backgroundNode addChild:_pointerNodeReverse];
    
    /*Call a layout*/
    [self layoutXYZ];
    
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
    
    if (_pointerNodeNormal.parent) {
        [_pointerNodeNormal removeFromParent];
    }
    if (_pointerNodeReverse.parent) {
        [_pointerNodeReverse removeFromParent];
    }
    
    if (_pointerNode) {
        _pointerNode                            = nil;
    }
    
    /*Set the tip vertical position*/
    CGPoint popTipPosition = CGPointZero;
    
    switch (_positionVertical) {
        case SIPopTipPositionVerticalTop:
            popTipPosition.y                    = (_backgroundNode.size.height) - [SIPopTip popTipPointerOffset];
            [_backgroundNode addChild:_pointerNodeNormal];
            _pointerNode                        = _pointerNodeNormal;
            break;
        case SIPopTipPositionVerticalBottom:
        default:
            popTipPosition.y                    = -1.0f * (_backgroundNode.size.height) + [SIPopTip popTipPointerOffset];
            [_backgroundNode addChild:_pointerNodeReverse];
            _pointerNode                        = _pointerNodeReverse;
            break;
    }
    
    /*Set the tip horizontal position*/
    switch (_positionHorizontal) {
        case SIPopTipPositionHorizontalLeft:
            popTipPosition.x                    = -1.0 * (_size.width * 0.25);
            break;
        case SIPopTipPositionHorizontalCenter:
            popTipPosition.x                    = 0.0f;
            break;
        case SIPopTipPositionHorizontalRight:
        default:
            popTipPosition.x                    = _size.width * 0.25;
            break;
    }
    
    _pointerNode.position                       = popTipPosition;
    
    switch (_effect) {
        case SIPopTipEffectBounce:
            [_backgroundNode runAction:[SKAction repeatActionForever:_bounceEffect]];
            break;
        default:
            break;
    }
    
    
}

/**
 Layout the Z
 */
- (void)layoutZ {
    _backgroundNode.zPosition                   = [SIGameController floatZPositionGameForContent:SIZPositionGameContentBottom];
    
    _pointerNode.zPosition                      = [SIGameController floatZPositionGameForContent:SIZPositionGameContentBottom];
    
    _multiLineNode.zPosition                    = [SIGameController floatZPositionGameForContent:SIZPositionGameContentMiddle];
}

#pragma mark -
#pragma mark - Touch Methods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([_delegate respondsToSelector:@selector(dismissPopTip:)]) {
        [_delegate dismissPopTip:self];
    }
}


#pragma mark -
#pragma mark - Public Accessors
- (void)setPositionHorizontal:(SIPopTipPositionHorizontal)positionHorizontal {
    _positionHorizontal = positionHorizontal;
    [self layoutXY];
}

- (void)setPositionVertical:(SIPopTipPositionVertical)positionVertical {
    _positionVertical                           = positionVertical;
    [self layoutXY];
}

- (void)setMessage:(NSString *)message {
    _message                                    = message;
    _multiLineNode.text                         = message;
}

- (void)setEffect:(SIPopTipEffect)effect {
    _effect                                     = effect;
    [self layoutXY];
}

- (void)setEffectDeltaY:(float)effectDeltaY {
    _effectDeltaY                               = effectDeltaY;
    _bounceEffect                               = [SIPopTip createBounceEffectActionWithDeltaY:_effectDeltaY];
    [self layoutXY];
}


#pragma mark -
#pragma mark - Class Functions
+ (float)floatZPositionPopTipForContent:(SIZPositionPopTip)layer {
    return (float)layer / (float)SIZPositionPopTipCount;
}

+ (float)popTipPointerOffset {
    if (IS_IPHONE_4) {
        return 12.0f;
        
    } else if (IS_IPHONE_5) {
        return 12.0f;
        
    } else if (IS_IPHONE_6) {
        return 16.0f;
        
    } else if (IS_IPHONE_6_PLUS) {
        return 19.0f;
        
    } else {
        return 19.0f;
        
    }
}

+ (SKAction *)createBounceEffectActionWithDeltaY:(float)deltaY {
    SKAction *moveY                             = [SKAction moveByX:0.0f y:deltaY duration:1.0f];
    SKAction *oppositeY                         = [moveY reversedAction];
    return [SKAction sequence:@[moveY, oppositeY]];

}

@end
