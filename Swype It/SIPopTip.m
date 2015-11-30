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
    
    _popTipPositionVertical                     = SIPopTipPositionVerticalBottom;
    _popTipPositionHorizontal                   = SIPopTipPositionHorizontalCenter;
    
    _popTipEffect                               = SIPopTipEffectNone;
    
    SKAction *moveY                             = [SKAction moveByX:0.0f y:10.0f duration:1.0f];
    SKAction *oppositeY                         = [moveY reversedAction];
    _bounceEffect                               = [SKAction sequence:@[moveY, oppositeY]];

    
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
        [_pointerNodeNormal removeFromParent];
    }
    
    if (_pointerNode) {
        _pointerNode                            = nil;
    }
    
    /*Set the tip vertical position*/
    CGPoint popTipPosition = CGPointZero;
    
    switch (_popTipPositionVertical) {
        case SIPopTipPositionVerticalTop:
            popTipPosition.y                    = (_backgroundNode.size.height);
            _pointerNode                        = _pointerNodeNormal;
            break;
        case SIPopTipPositionVerticalBottom:
        default:
            popTipPosition.y                    = -1.0f * (_backgroundNode.size.height) + 12;
            _pointerNode                        = _pointerNodeReverse;
            break;
    }
    
    /*Set the tip horizontal position*/
    switch (_popTipPositionHorizontal) {
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


    switch (_popTipEffect) {
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
    _backgroundNode.zPosition                   = [SIPopTip floatZPositionPopTipForContent:SIZPositionPopTipBackground];
    
    _pointerNode.zPosition                      = [SIPopTip floatZPositionPopTipForContent:SIZPositionPopTipBackground];
    
    _multiLineNode.zPosition                    = [SIPopTip floatZPositionPopTipForContent:SIZPositionPopTipText];
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
- (void)setPopTipPositionHorizontal:(SIPopTipPositionHorizontal)popTipPositionHorizontal {
    _popTipPositionHorizontal                   = popTipPositionHorizontal;
    [self layoutXY];
}

- (void)setPopTipPositionVertical:(SIPopTipPositionVertical)popTipPositionVertical {
    _popTipPositionVertical                     = popTipPositionVertical;
    [self layoutXY];
}

- (void)setMessage:(NSString *)message {
    _message = message;
    _multiLineNode.text = message;
}

- (void)setPopTipEffect:(SIPopTipEffect)popTipEffect {
    _popTipEffect = popTipEffect;
    [self layoutXY];
}


#pragma mark -
#pragma mark - Class Functions
+ (SKShapeNode *)makeTriangleInRect:(CGRect)rect withBackgroundColor:(UIColor *)backgroundColor {

    SKShapeNode *shape                          = [SKShapeNode shapeNodeWithCircleOfRadius:rect.size.width];//[SKShapeNode shapeNodeWithPath:[SIPopTip triangleInRect:rect] centered:YES];
    shape.fillColor                             = backgroundColor;
    
    return shape;
}

+ (CGPathRef) triangleInRect:(CGRect)rect {
    CGFloat offsetX                             = CGRectGetMidX(rect);
    CGFloat offsetY                             = CGRectGetMidY(rect);
    UIBezierPath* bezierPath                    = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint: CGPointMake(offsetX, 0)];
    [bezierPath addLineToPoint: CGPointMake(-offsetX, offsetY)];
    [bezierPath addLineToPoint: CGPointMake(-offsetX, -offsetY)];
    
    [bezierPath closePath];
    return bezierPath.CGPath;
}

+ (float)floatZPositionPopTipForContent:(SIZPositionPopTip)layer {
    return (float)layer / (float)SIZPositionPopTipCount;
}

@end
