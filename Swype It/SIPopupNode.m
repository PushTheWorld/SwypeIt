//
//  SIPopupNode.m
//  Swype It
//
//  Created by Andrew Keller on 8/13/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is the pop up node stuff
//
// Local Controller Import
#import "SIGameController.h"
#import "SIPopupNode.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "INSpriteKit.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports

enum {
    SIPopupNodeZPositionLayerBackground = 0,
    SIPopupNodeZPositionLayerContent,
    SIPopupNodeZPositionLayerOverlay,
    SIPopupNodeZPositionLayerCount
};


@implementation SIPopupNode {
    
    CGFloat                          _floatThreshold;
    
    CGSize                           _sceneSize;
    
    SKNode                          *_bottomContentNode;
    SKNode                          *_titleContentNode;
//    SKNode                          *_popupContentContentNode;
    
    SKLabelNode                     *_titleLabelNode;
    
//    SKSpriteNode                    *_backgroundNode;
    INSKButtonNode                  *_dismissButton;
}


- (nonnull instancetype)init {
    self = [super init];
    if (self) {
        _cornerRadius                   = 0.0f;
        _borderColor                    = nil;
        _borderWidth                    = 0.0f;
        _xPadding                       = VERTICAL_SPACING_16;
        _yPadding                       = VERTICAL_SPACING_16;
        _titleLabelTopPading            = VERTICAL_SPACING_16;
        _titleAutomaticYPosition        = NO;
        _centerNodePosition             = CGPointMake(0.0f, 0.0f);
        _bottomNodeBottomSpacing        = VERTICAL_SPACING_8;
        _countDownTimerState            = SIPopupCountDownTimerNotStarted;
        _startTime                      = 0;
//        _centerNodeSticksToBottomNode   = NO;
    }
    return self;
}


- (instancetype)initWithSceneSize:(CGSize)size {
    self = [self init];
    if (self) {
        _sceneSize                  = size;
        
        [self createPoupNodeInitCommon:size];
    }
    return self;
}

- (instancetype)initWithSceneSize:(CGSize)size titleNode:(SKNode *)titleNode {
    self = [super init];
    if (self) {
        _sceneSize                  = size;
        _titleContentNode           = titleNode;
        
        [self createPoupNodeInitCommon:size];
    }
    return self;
}


- (instancetype)initWithSceneSize:(CGSize)size
                        popUpSize:(CGSize)popUpSize
                            title:(NSString *)titleText
                   titleFontColor:(SKColor *)titleFontColor
                    titleFontSize:(CGFloat)titleFontSize
                    titleYPadding:(CGFloat)titleYPadding
                  backgroundColor:(SKColor *)backgroundColor
                     cornerRadius:(CGFloat)cornerRadius
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(SKColor *)borderColor {
    self = [self init];
    if (self) {
        _sceneSize                  = size;
        _xPadding                   = size.width - popUpSize.width;
        _yPadding                   = size.height - popUpSize.height;
        _cornerRadius               = cornerRadius;
        _borderWidth                = borderWidth;
        _borderColor                = borderColor;
        
        _titleText                  = titleText;
        _titleFontColor             = titleFontColor;
        _titleFontSize              = titleFontSize;

        _titleLabelTopPading        = titleYPadding;
        
        if (backgroundColor) {
            _backgroundNode.color   = backgroundColor;
        }
        
        [self createPoupNodeInitCommon:size];
    }
    return self;
}
- (instancetype)initWithSceneSize:(CGSize)size
                            title:(NSString *)titleText
                   titleFontColor:(SKColor *)titleFontColor
                    titleFontSize:(CGFloat)titleFontSize
                         xPadding:(CGFloat)xPadding
                         yPadding:(CGFloat)yPadding
                  backgroundColor:(SKColor *)backgroundColor
                     cornerRadius:(CGFloat)cornerRadius
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(SKColor *)borderColor {
    self = [self init];
    if (self) {
        _xPadding                   = xPadding;
        _yPadding                   = yPadding;
        _cornerRadius               = cornerRadius;
        _borderWidth                = borderWidth;
        _borderColor                = borderColor;
        
        _titleText                  = titleText;
        _titleFontColor             = titleFontColor;
        _titleFontSize              = titleFontSize;
        
        
        if (backgroundColor) {
            _backgroundNode.color   = backgroundColor;
        }
        
        [self createPoupNodeInitCommon:size];
    }
    return self;
}

- (void)createPoupNodeInitCommon:(CGSize)size {
    
    _backgroundNode                 = [SKSpriteNode spriteNodeWithColor:[SKColor grayColor] size:CGSizeMake(size.width - VERTICAL_SPACING_16, size.height - VERTICAL_SPACING_16)];
    _backgroundNode.anchorPoint     = CGPointMake(0.5f, 0.5f);
    _backgroundNode.zPosition       = SIPopupNodeZPositionLayerBackground * self.zPositionScale / SIPopupNodeZPositionLayerCount;
    [self addChild:_backgroundNode];
    
//    _overlayNode                    = [SKSpriteNode spriteNodeWithColor:[SKColor grayColor] size:CGSizeMake(size.width - VERTICAL_SPACING_16, size.height - VERTICAL_SPACING_16)];
//    _overlayNode.anchorPoint        = CGPointMake(0.5f, 0.5f);
//    _overlayNode.alpha              = 0.0f;
//    _overlayNode.zPosition          = SIPopupNodeZPositionLayerOverlay * self.zPositionScale / SIPopupNodeZPositionLayerCount;
//    [_overlayNode runAction:[SKAction fadeOutWithDuration:0.0f]];
//    _overlayNode.userInteractionEnabled = YES;
//    _overlayNode.hidden = YES;
//    [self addChild:_overlayNode];
    
    _titleLabelNode                 = [SKLabelNode labelNodeWithFontNamed:kSISFFontDisplayHeavy];
    _titleLabelNode.zPosition       = SIPopupNodeZPositionLayerContent * self.zPositionScale / SIPopupNodeZPositionLayerCount;
    [_backgroundNode addChild:_titleLabelNode];
    
    _dismissButton                  = [SIGameController SIINButtonNamed:kSIAssestPopupButtonDismissNormal];
    _dismissButton.zPosition        = SIPopupNodeZPositionLayerContent * self.zPositionScale / SIPopupNodeZPositionLayerCount;
    [_dismissButton setTouchUpInsideTarget:self selector:@selector(dismissButtonTapped:)];
    [_backgroundNode addChild:_dismissButton];
    
//    _lightNodeEdge                  = [[SKLightNode alloc] init];
//    _lightNodeEdge.categoryBitMask  = SIPopupNodeCategoryLight;
//    _lightNodeEdge.zPosition        = 100;
//    _lightNodeEdge.lightColor       = [SKColor blackColor];
//    _lightNodeEdge.enabled          = YES;
//    [_backgroundNode addChild:_lightNodeEdge];
    
    [self layoutXY];
}

//- (void)makeLightNodeFollowTheBackgroundOfThePopup {
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, _backgroundNode.frame.size.width - VERTICAL_SPACING_8, _backgroundNode.frame.size.height - VERTICAL_SPACING_8) cornerRadius:_cornerRadius];
//    SKAction *followBackground = [SKAction followPath:path.CGPath asOffset:NO orientToPath:NO duration:3.0f];
//    
//    for (SKNode *node in _backgroundNode.children) {
//        if ([node.name isEqualToString:@"Temp"]) {
//            [node removeFromParent];
//        }
//    }
//    
//    [_lightNodeEdge runAction:[SKAction repeatActionForever:followBackground]];
//}

- (CGSize)backgroundSize {
    return _backgroundNode.size;
}

- (void)setBackgroundSize:(CGSize)backgroundSize {
    _xPadding                       = _sceneSize.width - backgroundSize.width;
    _yPadding                       = _sceneSize.height - backgroundSize.height;
    [self layoutXY];
}

- (void)setSize:(CGSize)size {
    _backgroundNode.size            = size;
    [self layoutXY];
}

- (CGSize)size {
    return _backgroundNode.size;
}

- (void)setAnchorPoint:(CGPoint)anchorPoint {
    self.anchorPoint                = anchorPoint;
    [self layoutXY];
}

- (CGPoint)anchorPoint {
    return self.anchorPoint;
}

- (void)setTitleText:(NSString *)titleText {
    _titleText                      = titleText;
    [self layoutXY];
}

- (void)setTitleFontName:(NSString *)titleFontName {
    _titleFontName                  = titleFontName;
    [self layoutXY];
}

- (void)setTitleFontSize:(CGFloat)titleFontSize {
    _titleFontSize                  = titleFontSize;
    [self layoutXY];
}

- (void)setTitleFontColor:(SKColor *)titleFontColor {
    _titleFontColor                 = titleFontColor;
    [self layoutXY];
}

- (void)setTitleLabelTopPading:(CGFloat)titleLabelTopPading {
    _titleLabelTopPading = titleLabelTopPading;
    [self layoutXY];
}

- (SKColor *)backgroundColor {
    return _backgroundNode.color;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundNode.color               = backgroundColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius                       = cornerRadius;
    [self layoutXY];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    if (_borderColor == nil) {
        _borderColor                    = [SKColor blackColor];
    }
    [self layoutXY];
}

- (void)setBorderColor:(SKColor *)borderColor
{
    _borderColor                        = borderColor;
    [self layoutXY];
}
- (CGSize)dismissButtonSize {
    return _dismissButton.size;
}

- (void)setDismissButtonSize:(CGSize)dismissButtonSize {
    _dismissButton.size                 = dismissButtonSize;
    
    [self layoutXY];
}

- (CGPoint)dismissButtonPosition {
    return _dismissButton.position;
}

- (void)setDismissButtonPosition:(CGPoint)dismissButtonPosition {
    CGFloat newX                        = self.size.width * dismissButtonPosition.x;
    CGFloat newY                        = self.size.height * dismissButtonPosition.y;

    _dismissButton.position             = CGPointMake(newX, newY);
    
    [self layoutXY];
}

- (void)setXPadding:(CGFloat)xPadding {
    _xPadding                           = xPadding;
    [self layoutXY];
}

- (void)setYPadding:(CGFloat)yPadding {
    _yPadding                           = yPadding;
    [self layoutXY];
}

- (void)setTitleAutomaticYPosition:(BOOL)titleAutomaticYPosition {
    _titleAutomaticYPosition            = titleAutomaticYPosition;
    [self layoutXY];
}

- (void)setTitleContentNode:(SKNode *)titleContentNode {
    if (_titleLabelNode) {
        [_titleLabelNode removeFromParent];
    }
    
    if (_titleContentNode) {
        [_titleContentNode removeFromParent];
    }
    
    if (titleContentNode) {
        _titleContentNode               = titleContentNode;
        _titleContentNode.name          = kSINodePopupTitle;
        [_backgroundNode addChild:_titleContentNode];
    }
    [self layoutXY];

}

- (void)setCenterNode:(SKNode *)centerNode {
    if (_centerNode) {
        [_centerNode removeFromParent];
    }
    if (centerNode) {
        _centerNode                                 = centerNode;
        _centerNode.name                            = kSINodePopupContent;
        [_backgroundNode addChild:_centerNode];
    }
    [self layoutXYZ];
}

- (SKNode *)bottomNode {
    if (_bottomContentNode) {
        return _bottomContentNode;
    } else {
        return nil;
    }
}

- (void)setBottomNode:(SKNode *)bottomNode {
    if (_bottomContentNode) {
        [_bottomContentNode removeFromParent];
    }
    if (bottomNode) {
        _bottomContentNode                          = bottomNode;
        [_backgroundNode addChild:bottomNode];
    }
    [self layoutXYZ];
}

- (void)setBottomNodeBottomSpacing:(CGFloat)bottomNodeBottomSpacing {
    _bottomNodeBottomSpacing = bottomNodeBottomSpacing;
    [self layoutXY];

}

- (void)setCenterNodePosition:(CGPoint)centerNodePosition {
    _centerNodePosition = centerNodePosition;
    [self layoutXY];
}

//- (void)setCenterNodeSticksToBottomNode:(BOOL)centerNodeSticksToBottomNode {
//    _centerNodeSticksToBottomNode = centerNodeSticksToBottomNode;
//    [self layoutXY];
//}

- (void)setDismissButtonVisible:(BOOL)dismissButtonVisible {
    _dismissButton.hidden = !dismissButtonVisible;
    _dismissButtonVisible           = dismissButtonVisible;
//    [self layoutXYZ];
}

- (void)setTopNode:(SKNode *)topNode {
    if (_topNode) {
        [_topNode removeFromParent];
    }
    if (topNode) {
        _topNode    = topNode;
        [_backgroundNode addChild:_topNode];
    }
    [self layoutXYZ];
}

- (void)updateTopNode:(SKNode *)topNode
           centerNode:(SKNode *)centerNode
   centerNodePosition:(CGPoint)centerNodePosition
           bottomNode:(SKNode *)bottomNode
 bottomNodeBottomSpacing:(CGFloat)bottomNodeBottomSpacing
 dismissButtonVisible:(BOOL)dismissButtonVisible
 updateBackgroundSize:(BOOL)updateBackgroundSize
       backgroundSize:(CGSize)backgroundSize {

    //Background Size updates
    if (updateBackgroundSize) {
        _xPadding               = _sceneSize.width - backgroundSize.width;
        _yPadding               = _sceneSize.height - backgroundSize.height;
    }
    
    _dismissButtonVisible       = dismissButtonVisible;
    _dismissButton.hidden       = !dismissButtonVisible;
    
    // Top Node
    if (_topNode) {
        [_topNode removeFromParent];
    }
    if (topNode) {
        _topNode                = topNode;
        [_backgroundNode addChild:_topNode];
    }
    
    _centerNodePosition = centerNodePosition;
    
    if (_centerNode) {
        [_centerNode removeFromParent];
    }
    if (centerNode) {
        _centerNode             = centerNode;
        _centerNode.name        = kSINodePopupContent;
        [_backgroundNode addChild:_centerNode];
    }
    
    if (_bottomContentNode) {
        [_bottomContentNode removeFromParent];
    }
    if (bottomNode) {
        _bottomContentNode      = bottomNode;
        [_backgroundNode addChild:bottomNode];
    }
    
    _bottomNodeBottomSpacing = bottomNodeBottomSpacing;
    
    [self layoutXYZ];

}

- (void)layoutXYZ {
    [self layoutXY];
    [self layoutZ];
}
- (void)layoutXY {

    if (!_backgroundNode) {
        return;
    }
    _backgroundNode.size                = CGSizeMake(_sceneSize.width - _xPadding, _sceneSize.height - _yPadding);
//    _overlayNode.size                   = CGSizeMake(_sceneSize.width - _xPadding, _sceneSize.height - _yPadding);

    if (_titleContentNode) {
        /*If someone supplied their own node*/
        _titleContentNode.position      = CGPointMake(0.0f, self.backgroundSize.height / 2.0f - _titleLabelTopPading - _titleContentNode.frame.size.height / 2.0f);
        
    } else {
        /*Use titleLabelNode*/
        _titleLabelNode.position        = CGPointMake(0.0f, self.backgroundSize.height / 2.0f - _titleLabelTopPading);

        if (_titleAutomaticYPosition) { //this moves the top label
            _titleLabelNode.position    = CGPointMake(0.0f, (_backgroundNode.size.height / 2.0f) - _titleLabelNode.frame.size.height - _titleLabelTopPading);
        }

    }


    if (_dismissButton && _dismissButtonVisible) {
        CGPoint dismissButtonPosition   = CGPointMake((_backgroundNode.size.width / 2.0f), (_backgroundNode.size.height / 2.0f));
        
        // note: We must bring in the dismiss button if it is layed out over the screen, this will allow us to use a popup that has a small padding
        while ((dismissButtonPosition.x + (_dismissButton.frame.size.width / 2.0f)) > (_sceneSize.width / 2.0f)) {
            dismissButtonPosition.x--;
        }
        
        while ((dismissButtonPosition.y + (_dismissButton.frame.size.height / 2.0f)) > (_sceneSize.height / 2.0f)) {
            dismissButtonPosition.y--;
        }
        
        _dismissButton.position         = dismissButtonPosition;
    }
    
    if (_bottomContentNode) {
        _bottomContentNode.position         = CGPointMake(0.0f, -1.0f * (_backgroundNode.size.height / 2.0f) + _bottomNodeBottomSpacing);
    }
    
    if (_centerNode && _centerNode.parent) {
        _centerNode.position                = _centerNodePosition;
    }
    
    _backgroundNode.texture                 = [SIGame textureBackgroundColor:_backgroundNode.color size:_backgroundNode.size cornerRadius:_cornerRadius borderWidth:_borderWidth borderColor:_borderColor];

//    [self makeLightNodeFollowTheBackgroundOfThePopup];
}

- (void)layoutZ {
    CGFloat zPositionLayerIncrement     = self.zPositionScale / (float)SIPopupNodeZPositionLayerCount;
    
    _backgroundNode.zPosition               = SIPopupNodeZPositionLayerBackground * zPositionLayerIncrement;
//    _overlayNode.zPosition                  = SIPopupNodeZPositionLayerOverlay * zPositionLayerIncrement;
    
    if (_centerNode) {
        _centerNode.zPosition               = SIZPositionPopupContentTop * zPositionLayerIncrement;
    }
    
    if (_dismissButton) {
        _dismissButton.zPosition            = SIZPositionPopupContent * zPositionLayerIncrement;
    }
    
    if (_bottomContentNode) {
        _bottomContentNode.zPosition        = SIZPositionPopupContent * zPositionLayerIncrement;
    }
    
    if (_titleContentNode) {
        _titleContentNode.zPosition         = SIZPositionPopupContent * zPositionLayerIncrement;
    } else {
        _titleLabelNode.zPosition           = SIZPositionPopupContent * zPositionLayerIncrement;
    }
    
    if (_topNode) {
        _topNode.zPosition                  = SIZPositionPopupContent * zPositionLayerIncrement;
    }
    
}

- (void)dismissButtonTapped:(INSKButtonNode *)button {
    if ([_delegate respondsToSelector:@selector(dismissPopup:)]) {
        [_delegate dismissPopup:self];
    }
}

#pragma mark - HLGestureTarget


#pragma mark - Launch Coins

- (void)launchNode:(SKSpriteNode *)node {
    
    CGFloat zPositionLayerIncrement             = self.zPositionScale / (float)SIPopupNodeZPositionLayerCount;
    
    node.zPosition                              = SIZPositionPopupContentTop * zPositionLayerIncrement;
    node.position                               = CGPointZero;
    node.physicsBody                            = [SKPhysicsBody bodyWithCircleOfRadius:node.size.height/2.0f];
    node.physicsBody.collisionBitMask           = 0;
    node.physicsBody.linearDamping              = 0.0f;
    
    [_backgroundNode addChild:node];
    
    
    CGFloat randomDx                            = arc4random_uniform(LAUNCH_DX_VECTOR_MAX);
    while (randomDx < LAUNCH_DX_VECTOR_MIX) {
        randomDx                                = arc4random_uniform(LAUNCH_DX_VECTOR_MAX);
    }
    int randomDirection                         = arc4random_uniform(2);
    if (randomDirection == 1) { /*Negative Direction*/
        randomDx                                = -1.0f * randomDx;
    }
    
    CGFloat randomDy                            = ((arc4random_uniform(5)/5) + 1)* LAUNCH_DY_MULTIPLIER;
    
    //    NSLog(@"Vector... dX = %0.2f | Y = %0.2f",randomDx,randomDy);
    CGVector moveScoreVector                    = CGVectorMake(randomDx, randomDy);
    
    [node.physicsBody applyImpulse:moveScoreVector];
    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"HEY");
}

@end
