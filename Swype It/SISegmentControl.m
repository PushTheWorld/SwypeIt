//  SISegmentControl.m
//  Swype It
//
//  Created by Andrew Keller on 8/24/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is a quick segment control...
//
// Local Controller Import
#import "SISegmentControl.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
//#import "SKNode+HLGestureTarget.h"
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "Game.h"
// Other Imports

@implementation SISegmentControl  {
    
    CGFloat                          _borderWidth;
    CGFloat                          _cornerRadius;
    
    CGSize                           _segmentSize;
    
    NSArray                         *_titles;
    
    NSMutableArray                  *_segments;
    
    NSUInteger                       _numberOfSegments;
    
    SKColor                         *_backgroundColor;
    SKColor                         *_borderColor;
    SKColor                         *_segmentColorSelected;
    SKColor                         *_segmentColorUnselected;
    
    SKSpriteNode                    *_backgroundNode;
    
}

- (instancetype)initWithSize:(CGSize)size titles:(NSArray *)titles {
    self = [super init];
    if (self) {
        _size                       = size;
        
        _titles                     = titles;
        
        _cornerRadius               = 4.0f;
        _borderWidth                = 4.0f;
        
        _backgroundColor            = [SKColor blackColor];
        _borderColor                = [SKColor lightGrayColor];
        _segmentColorSelected       = [SKColor greenColor];
        _segmentColorUnselected     = [SKColor grayColor];
        
        [self initSetup:size];
    }
    return self;
}

#pragma mark - Node Setup
- (void)initSetup:(CGSize)size {
    /**Preform initalization pre-view load*/
    [self createConstantsWithSize:size];
    [self createControlsWithSize:size];
}

- (void)createConstantsWithSize:(CGSize)size {
    /**Configure any constants*/
    _numberOfSegments                           = [_titles count];
    
    _segmentSize                                = CGSizeMake((_size.width / _numberOfSegments) - VERTICAL_SPACING_4,
                                                             _size.height - VERTICAL_SPACING_4);
    
}

- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    _backgroundNode                             = [SKSpriteNode spriteNodeWithColor:_backgroundColor size:_size];
    
    _selectedSegment                            = 0;
    
    [self createSegments];
}

- (void)createSegments {
    if (_numberOfSegments == 1) {

    } else {
        for (int i = 0; i < _numberOfSegments; i++) {
            HLLabelButtonNode *segmentNode;
            
            if (i == 0) {
                segmentNode                         = [[HLLabelButtonNode alloc] initWithTexture:[self textureForSprite:segmentNode isSelected:YES]];
            } else {
                segmentNode                         = [[HLLabelButtonNode alloc] initWithTexture:[self textureForSprite:segmentNode isSelected:YES]];

            }
            
            segmentNode.text                    = _titles[i];
            
            segmentNode.anchorPoint             = CGPointMake(0.0f, 0.0f);
            
            segmentNode.position                = CGPointMake(0.0f, i * _segmentSize.width);
            
            [_backgroundNode addChild:segmentNode];
            
            [segmentNode hlSetGestureTarget:[HLTapGestureTarget tapGestureTargetWithHandleGestureBlock:^(UIGestureRecognizer *gestureRecognizer) {
                [self setSelectedSegment:[_segments indexOfObject:segmentNode]];
            }]];
            
            [_segments addObject:segmentNode];
            
        }
    }
}

- (void)setSelectedSegment:(NSUInteger)selectedSegment {
    if (!_segments) {
        return;
    }
    if (selectedSegment < _numberOfSegments - 1) {
        if (selectedSegment != _selectedSegment) {
            HLLabelButtonNode *newNode          = _segments[selectedSegment];
            HLLabelButtonNode *oldNode          = _segments[_selectedSegment];
            
            oldNode.color                       = _segmentColorUnselected;
            newNode.color                       = _segmentColorSelected;
            
            _selectedSegment                    = selectedSegment;
            
        }
    }
}

- (SKTexture *)textureForSprite:(HLLabelButtonNode *)segmentNode isSelected:(BOOL)isSelected {
    SKTexture *texture;
        
    SKColor *buttonColor;
    if (isSelected) {
        buttonColor     = _segmentColorSelected;
    } else {
        buttonColor     = _segmentColorUnselected;
    }
    
    NSUInteger indexOfSegmentNode = [_segments indexOfObject:segmentNode];
    
    if (_numberOfSegments == 1) {
        texture         = [SISegmentControl textureBackgroundColor:buttonColor
                                                              size:_segmentSize
                                                      cornerRadius:_cornerRadius
                                                       borderWidth:_borderWidth
                                                       borderColor:_borderColor];
    } else if (indexOfSegmentNode == 0) {
        texture         = [SISegmentControl textureLeftSegmentButtonColor:buttonColor
                                                                     size:_segmentSize
                                                             cornerRadius:_cornerRadius
                                                              borderWidth:_borderWidth
                                                              borderColor:_borderColor];
    } else if (indexOfSegmentNode == _numberOfSegments - 1) {
        texture         = [SISegmentControl textureRightSegmentButtonColor:buttonColor
                                                                         size:_segmentSize
                                                                 cornerRadius:_cornerRadius
                                                                  borderWidth:_borderWidth
                                                                  borderColor:_borderColor];
    } else {
        texture         = [SISegmentControl textureBackgroundColor:buttonColor
                                                              size:_segmentSize
                                                      cornerRadius:_cornerRadius
                                                       borderWidth:_borderWidth
                                                       borderColor:_borderColor];
    }
    
    return texture;
}

+ (SKTexture *)textureRightSegmentButtonColor:(SKColor *)backgroundColor size:(CGSize)size cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    UIBezierPath *maskPath      = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, 0.0f, size.width, size.height) byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    
    CAShapeLayer *shapeLayer    = [CAShapeLayer layer];
    shapeLayer.frame            = CGRectMake(0, 0, size.width, size.height);
    shapeLayer.path             = maskPath.CGPath;
    shapeLayer.fillColor        = backgroundColor.CGColor;
    shapeLayer.strokeColor      = borderColor.CGColor;
    shapeLayer.lineWidth        = borderWidth;
    shapeLayer.cornerRadius     = cornerRadius;
    shapeLayer.masksToBounds    = YES;
    
    return [SISegmentControl textureFromLayer:shapeLayer];
}

+ (SKTexture *)textureLeftSegmentButtonColor:(SKColor *)backgroundColor size:(CGSize)size cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    UIBezierPath *maskPath      = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.0f, 0.0f, size.width, size.height) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft) cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    
    CAShapeLayer *shapeLayer    = [CAShapeLayer layer];
    shapeLayer.frame            = CGRectMake(0, 0, size.width, size.height);
    shapeLayer.path             = maskPath.CGPath;
    shapeLayer.fillColor        = backgroundColor.CGColor;
    shapeLayer.strokeColor      = borderColor.CGColor;
    shapeLayer.lineWidth        = borderWidth;
    shapeLayer.cornerRadius     = cornerRadius;
    shapeLayer.masksToBounds    = YES;
    
    return [SISegmentControl textureFromLayer:shapeLayer];
}
                                 
+ (SKTexture *)textureBackgroundColor:(SKColor *)backgroundColor size:(CGSize)size cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    UIBezierPath *maskPath      = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius];
    
    CAShapeLayer *shapeLayer    = [CAShapeLayer layer];
    shapeLayer.frame            = CGRectMake(0, 0, size.width, size.height);
    shapeLayer.path             = maskPath.CGPath;
    shapeLayer.fillColor        = backgroundColor.CGColor;
    shapeLayer.strokeColor      = borderColor.CGColor;
    shapeLayer.lineWidth        = borderWidth;
    shapeLayer.cornerRadius     = cornerRadius;
    shapeLayer.masksToBounds    = YES;
    
    return [SISegmentControl textureFromLayer:shapeLayer];
}

+ (SKTexture *)textureFromLayer:(CALayer *)layer {
    CGFloat width = layer.frame.size.width;
    CGFloat height = layer.frame.size.height;
    
    // value of 0 for scale will use device's main screen scale
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, width, height));
    
    [layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    SKTexture *texture = [SKTexture textureWithImage:image];
    
    return texture;
}

@end
