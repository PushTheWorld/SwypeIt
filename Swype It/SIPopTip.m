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
    
    SKColor                                     *_backgroundColor;
    
    SKShapeNode                                 *_pointerNode;
    
    SKSpriteNode                                *_backgroundNode;
    
}

#pragma mark -
#pragma mark - Node Life Cycle
- (instancetype)initWithSize:(CGSize)size withMessage:(NSString *)message {
    self = [super init];
    if (self) {
        [self initSetup:size];
        _message                                = message;
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
    
    _backgroundColor                            = [UIColor SIColorSecondary];
    
    _popTipPositionVertical                     = SIPopTipPositionVerticalBottom;
    _popTipPositionHorizontal                   = SIPopTipPositionHorizontalCenter;
    
}

/**
 Preform all your alloc/init's here
 */
- (void)createControlsWithSize:(CGSize)size {
    
    _backgroundNode                             = [SKSpriteNode spriteNodeWithTexture:[SIGame textureBackgroundColor:_backgroundColor size:_size cornerRadius:4.0f borderWidth:0.0f borderColor:[UIColor clearColor]]];
    
    _pointerNode                                = [SIPopTip makeTriangleInRect:CGRectMake(0.0f, 0.0f, _size.width / 3.0f, _size.height / 3.0f) withBackgroundColor:_backgroundColor];

    _multiLineNode                              = [[DSMultilineLabelNode alloc] initWithFontNamed:kSISFFontTextMedium];
    
}

/**
 Configrue the labels, nodes and what ever else you can
 */
- (void)setupControlsWithSize:(CGSize)size {
    [self addChild:_backgroundNode];

    /*Set the paragraph width to spacing times two minus 4*/
    _multiLineNode.paragraphWidth               = _size.width - (VERTICAL_SPACING_4 * 2);
    _multiLineNode.fontColor                    = [SKColor whiteColor];
    _multiLineNode.text                         = _message;
    _multiLineNode.verticalAlignmentMode        = SKLabelVerticalAlignmentModeCenter;
    _multiLineNode.horizontalAlignmentMode      = SKLabelHorizontalAlignmentModeCenter;
    [_backgroundNode addChild:_multiLineNode];
    
    [_backgroundNode addChild:_pointerNode];
    
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
    
    /*Set the tip vertical position*/
    CGPoint popTipPosition = CGPointZero;
    
    switch (_popTipPositionVertical) {
        case SIPopTipPositionVerticalTop:
            popTipPosition.y                    = (_backgroundNode.size.height / 2.0f);
            break;
        case SIPopTipPositionVerticalBottom:
        default:
            popTipPosition.y                    = -1.0f * (_backgroundNode.size.height / 2.0f);
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


#pragma mark -
#pragma mark - Class Functions
+ (SKShapeNode *)makeTriangleInRect:(CGRect)rect withBackgroundColor:(UIColor *)backgroundColor {
    SKShapeNode *shape                          = [SKShapeNode node];
    shape.path                                  = [SIPopTip triangleInRect:rect];
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
