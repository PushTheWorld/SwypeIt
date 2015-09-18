//  SISegmentControl.m
//  Swype It
//
//  Created by Andrew Keller on 8/24/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is a quick segment control...
//
// Local Controller Import
#import "SIGameController.h"
#import "SISegmentControl.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
//#import "SKNode+HLGestureTarget.h"
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIGame.h"
// Other Imports
enum {
    SISegmentContorlZPositionLayerBackground = 0,
    SISegmentControlZPositionLayerButtons,
    SISegmentContorlZPositionLayerCount
};

@implementation SISegmentControl  {

    CGFloat                          _backgroundBorderWidth;
    CGFloat                          _backgroundCornerRadius;
    CGFloat                          _segmentBorderWidth;
    CGFloat                          _segmentCornerRadius;
    
    CGSize                           _segmentSize;
    
    NSArray                         *_titles;
    
    NSMutableArray                  *_segments;
    
    NSUInteger                       _initSelectedSegment;
    NSUInteger                       _numberOfSegments;
    NSUInteger                       _selectedSegment;
    
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

        _backgroundBorderWidth      = 8.0f;
        _backgroundCornerRadius     = 8.0f;
        
        _segmentBorderWidth         = 0.0f;
        _segmentCornerRadius        = 4.0f;
        
        _backgroundColor            = [SKColor clearColor];
        _borderColor                = [SKColor blackColor];
        _segmentColorSelected       = [SKColor mainColor];
        _segmentColorUnselected     = [SKColor whiteColor];
        
        _initSelectedSegment        = 0;
        
        _selectedSegment            = [titles count];
        
        [self initSetup:size];
    }
    return self;
}

- (void)setAnchorPoint:(CGPoint)anchorPoint {
    if (_backgroundNode) {
        self.anchorPoint            = _backgroundNode.anchorPoint;
        _backgroundNode.anchorPoint = self.anchorPoint;

    } else {
        self.anchorPoint            = CGPointMake(0.5, 0.5);
        _backgroundNode.anchorPoint = self.anchorPoint;
    }
}

- (CGPoint)anchorPoint {
    return _backgroundNode.anchorPoint;
}

- (NSUInteger)selectedSegment {
    return _selectedSegment;
}

- (void)setSelectedSegment:(NSUInteger)selectedSegment {
    if (!_segments) {
//        _selectedSegment = selectedSegment;
        return;
    }
//    NSLog(@"Current _selectedSegment = %u... new segment = %u",(unsigned)_selectedSegment,(unsigned)selectedSegment);
    if (selectedSegment < _numberOfSegments) {
        if (selectedSegment != _selectedSegment) {
            if (_selectedSegment == _numberOfSegments) { /*This is the first case*/
                _selectedSegment = _initSelectedSegment;
            }
            HLLabelButtonNode *newNode          = _segments[selectedSegment];
            HLLabelButtonNode *oldNode          = _segments[_selectedSegment];
            
            /*This is supposed to change the color of the node...*/
            [self setColorForNode:oldNode color:_segmentColorUnselected fontColor:[SKColor blackColor]];
            [self setColorForNode:newNode color:_segmentColorSelected fontColor:[SKColor whiteColor]];
//            oldNode.color                       = _segmentColorUnselected;
//            newNode.color                       = _segmentColorSelected;
            
            _selectedSegment                    = selectedSegment;
            
            [self.delegate segmentControl:self didTapNodeItem:newNode itemIndex:selectedSegment];
        }
    }
}

- (void)setColorForNode:(HLLabelButtonNode *)node color:(SKColor *)color fontColor:(SKColor *)fontColor {
    node.color              = color;
    node.colorBlendFactor   = 1.0f;
    node.fontColor          = fontColor;
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
                                                             _size.height - VERTICAL_SPACING_8);
    
}

- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    _backgroundNode                             = [SKSpriteNode spriteNodeWithTexture:[SISegmentControl textureBackgroundColor:[SKColor clearColor] size:_size cornerRadius:_backgroundCornerRadius borderWidth:_backgroundBorderWidth borderColor:_borderColor]];
//    [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:_size];
    [self addChild:_backgroundNode];

    [self createSegments];
    
    [self setSelectedSegment:_initSelectedSegment];
}

- (void)createSegments {
    if (_numberOfSegments == 1) {

    } else {
        _segments                       = [NSMutableArray array];
        CGFloat currentXPositionSegment = -1.0f * (_numberOfSegments - 1) * _segmentSize.width;
        for (int i = 0; i < _numberOfSegments; i++) {
            HLLabelButtonNode *segmentNode;
            
            segmentNode                         = [[HLLabelButtonNode alloc] initWithTexture:[self textureForSprite:segmentNode indexOfNode:(NSUInteger)i]]; // isSelected:NO]];
            
            segmentNode.text                    = _titles[i];
            
            segmentNode.anchorPoint             = CGPointMake(0.0f, 0.5f);
            
            segmentNode.fontSize                = [SIGameController SIFontSizeParagraph];
            
            segmentNode.fontName                = kSISFFontDisplayRegular;
            
            segmentNode.fontColor               = [SKColor blackColor];
            
            segmentNode.position                = CGPointMake(currentXPositionSegment, 0.0f);
            
            segmentNode.color                   = _segmentColorUnselected;
            segmentNode.colorBlendFactor        = 1.0f;
            
            currentXPositionSegment             = currentXPositionSegment + _segmentSize.width;
            
            segmentNode.userInteractionEnabled  = YES;
            
            [_backgroundNode addChild:segmentNode];
            
//            [segmentNode hlSetGestureTarget:[HLTapGestureTarget tapGestureTargetWithHandleGestureBlock:^(UIGestureRecognizer *gestureRecognizer) {
//                NSLog(@"Segment (%d) tapped",(int)[_segments indexOfObject:segmentNode]);
//                [self setSelectedSegment:[_segments indexOfObject:segmentNode]];
//            }]];
            
            [_segments addObject:segmentNode];
            
        }
    }
}

#pragma mark - HLGestureTarget
- (NSArray *)addsToGestureRecognizers
{
    return @[ [[UITapGestureRecognizer alloc] init] ];
}

- (BOOL)addToGesture:(UIGestureRecognizer *)gestureRecognizer firstTouch:(UITouch *)touch isInside:(BOOL *)isInside
{
    CGPoint location = [touch locationInNode:self];
    
    *isInside = NO;
    for (SKNode *buttonNode in _backgroundNode.children) {
        if ([buttonNode containsPoint:location]) {
            *isInside = YES;
            if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
                // note: Require only one tap and one touch, same as our gesture recognizer
                // returned from addsToGestureRecognizers?  I think it's okay to be non-strict.
                [gestureRecognizer addTarget:self action:@selector(handleTap:)];
                return YES;
            }
            break;
        }
    }
    return NO;
}

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer
{
    // note: Clearly, could retain state from addToGesture if it improved performance
    // significantly.
    CGPoint viewLocation = [gestureRecognizer locationInView:self.scene.view];
    CGPoint sceneLocation = [self.scene convertPointFromView:viewLocation];
    CGPoint menuLocation = [self convertPoint:sceneLocation fromNode:self.scene];
    
    NSUInteger i = 0;
    for (SKNode *buttonNode in _backgroundNode.children) {
        if ([buttonNode containsPoint:menuLocation]) {
//            NSLog(@"Segment (%d) tapped",(int)i);
            [self setSelectedSegment:i];
            return;
        }
        ++i;
    }
}


#pragma mark - Texture Features
- (SKTexture *)textureForSprite:(HLLabelButtonNode *)segmentNode indexOfNode:(NSUInteger)indexOfNode { // isSelected:(BOOL)isSelected {
    SKTexture *texture;
    
    if (_numberOfSegments == 1) {
        texture         = [SISegmentControl textureBackgroundColor:_segmentColorUnselected
                                                              size:_segmentSize
                                                      cornerRadius:_segmentCornerRadius
                                                       borderWidth:_segmentBorderWidth
                                                       borderColor:_borderColor];
    } else if (indexOfNode == 0) {
        texture         = [SISegmentControl textureLeftSegmentButtonColor:_segmentColorUnselected
                                                                     size:_segmentSize
                                                             cornerRadius:_segmentCornerRadius
                                                              borderWidth:_segmentBorderWidth
                                                              borderColor:_borderColor];
    } else if (indexOfNode == _numberOfSegments - 1) {
        texture         = [SISegmentControl textureRightSegmentButtonColor:_segmentColorUnselected
                                                                      size:_segmentSize
                                                              cornerRadius:_segmentCornerRadius
                                                               borderWidth:_segmentBorderWidth
                                                               borderColor:_borderColor];
    } else {
        texture         = [SISegmentControl textureBackgroundColor:_segmentColorUnselected
                                                              size:_segmentSize
                                                      cornerRadius:_segmentCornerRadius
                                                       borderWidth:_segmentBorderWidth
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
//    shapeLayer.cornerRadius     = cornerRadius;
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
//    shapeLayer.cornerRadius     = cornerRadius;
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
