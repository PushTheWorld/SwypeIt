//  SIAdBannerNode.m
//  Swype It
//
//  Created by Andrew Keller on 9/2/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is node for ads... will integrate internet connectivity eventually
//
// Local Controller Import
#import "SIAdBannerNode.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports
enum {
    SIAdBannerNodeZPositionLayerBackground = 0,
    SIAdBannerNodeZPositionLayerGraphic,
    SIAdBannerNodeZPositionLayerText,
    SIAdBannerNodeZPositionLayerCount
};
@implementation SIAdBannerNode {
    CGSize                               _backgroundNodeSize;
    CGSize                               _graphicNodeSize;
    
    SKLabelNode                         *_callToActionLabelNode;
    
    SKSpriteNode                        *_backgroundNode;
    SKSpriteNode                        *_graphicNode;
}

#pragma mark - Node Life Cycle
- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        [self initSetup:size];
    }
    return self;
}
- (void)initSetup:(CGSize)size {
    [self createConstantsWithSize:size];
    [self createControlsWithSize:size];
    [self setupControlsWithSize:size];
    [self layoutControlsWithSize:size];
}
- (void)createConstantsWithSize:(CGSize)size {
    /**Configure any constants*/
    _backgroundNodeSize                 = size;
    
    _graphicNodeSize                    = CGSizeMake(size.width, size.height - VERTICAL_SPACING_8);
}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    _backgroundNode                     = [SKSpriteNode spriteNodeWithColor:[SKColor simplstMainColor] size:size];
    
    _graphicNode                        = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:_graphicNodeSize];
    
    _callToActionLabelNode              = [SKLabelNode labelNodeWithFontNamed:kSISFFontDisplayLight];
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    _backgroundNode.anchorPoint         = CGPointMake(0.0f, 0.0f);
    _backgroundNode.zPosition           = (CGFloat)SIAdBannerNodeZPositionLayerBackground / SIAdBannerNodeZPositionLayerCount;

    _graphicNode.anchorPoint            = CGPointMake(0.5f, 0.5f);
    _graphicNode.zPosition              = (CGFloat)SIAdBannerNodeZPositionLayerGraphic / SIAdBannerNodeZPositionLayerCount;
    
    _callToActionLabelNode.zPosition    = (CGFloat)SIAdBannerNodeZPositionLayerText / SIAdBannerNodeZPositionLayerCount;
    _callToActionLabelNode.fontColor    = [SKColor whiteColor];
    _callToActionLabelNode.fontSize     = _graphicNodeSize.height - VERTICAL_SPACING_8;
    _callToActionLabelNode.text         = @"DOWNLOAD SIMPLST";
    [_callToActionLabelNode setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    [_callToActionLabelNode setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
}
- (void)layoutControlsWithSize:(CGSize)size {
    /**Layout those controls*/
    [self addChild:_backgroundNode];
    
    [_backgroundNode addChild:_graphicNode];
    
    [_graphicNode addChild:_callToActionLabelNode];
    
    [self layout];
}
#pragma mark - SIAdBannerNode Property Methods
- (void)setSize:(CGSize)size {
    _backgroundNode.size = size;
    [self layout];
}

- (CGSize)size {
    return _backgroundNode.size;
}
- (void)setAnchorPoint:(CGPoint)anchorPoint
{
    _backgroundNode.anchorPoint = anchorPoint;
    [self layout];
}

- (CGPoint)anchorPoint
{
    return _backgroundNode.anchorPoint;
}

- (void)setBackgroundColor:(SKColor *)backgroundColor
{
    _backgroundNode.color = backgroundColor;
    [self layout];
}

- (SKColor *)backgroundColor
{
    return _backgroundNode.color;
}
#pragma mark - Layout Methods
- (void)layout {
    /*Do layout stuff if needed...*/
    if (!_backgroundNode) {
        return;
    }
    
    if (_graphicNode) {
        /*Perform setup...*/
        _graphicNode.position   = CGPointMake(_backgroundNodeSize.width  / 2.0f, _backgroundNodeSize.height / 2.0f);
    }
    
}
#pragma mark - HLGestureTarget Delegate Methods
- (NSArray *)addsToGestureRecognizers {
    return @[ [[UITapGestureRecognizer alloc] init] ];
}
- (BOOL)addToGesture:(UIGestureRecognizer *)gestureRecognizer firstTouch:(UITouch *)touch isInside:(BOOL *)isInside {
    if (HLGestureTarget_areEquivalentGestureRecognizers(gestureRecognizer, [[UITapGestureRecognizer alloc] init])) {
        [gestureRecognizer addTarget:self action:@selector(adTapped)];
        *isInside = YES;
        return YES;
    }
    return NO;
}
- (void)adTapped {
    if ([_delegate respondsToSelector:@selector(adBannerWasTapped)]) {
        [_delegate adBannerWasTapped];
    }
}



@end
