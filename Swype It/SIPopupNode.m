//
//  SIPopupNode.m
//  Swype It
//
//  Created by Andrew Keller on 8/13/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import "SIPopupNode.h"
enum {
    SIPopUpNodeZPositionLayerBackground = 0,
    SIPopUpNodeZPositionLayerContent,
    SIPopUpNodeZPositionLayerCount
};


@implementation SIPopupNode {
    
    CGFloat          _floatThreshold;
    
    CGSize           _sceneSize;
    
    SKSpriteNode    *_backgroundNode;
    SKSpriteNode    *_dismissButton;
    SKLabelNode     *_titleNode;
}


- (instancetype)initWithSceneSize:(CGSize)size {
    self = [super init];
    if (self) {
        _floatThreshold             = 0.01;
        
        _backgroundNode             = [SKSpriteNode spriteNodeWithColor:[SKColor grayColor] size:CGSizeMake(size.width - VERTICAL_SPACING_16, size.width - VERTICAL_SPACING_16)];
        _backgroundNode.anchorPoint = CGPointMake(0.5f, 0.5f);
        _backgroundNode.zPosition   = SIPopUpNodeZPositionLayerBackground * self.zPositionScale / SIPopUpNodeZPositionLayerCount;
        [self addChild:_backgroundNode];
        
        [self popUpNodeInitCommon:size];
        
        _xPadding                   = 32.0f;
        _yPadding                   = 32.0f;
        _backgroundNode.color       = [SKColor redColor];
        
        [self layout];
    }
    return self;
}
- (instancetype)initWithSceneSize:(CGSize)size
                         xPadding:(CGFloat)xPadding
                         yPadding:(CGFloat)yPadding
                  backgroundColor:(SKColor *)backgroundColor
                     cornerRadius:(CGFloat)cornerRadius
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(SKColor *)borderColor {
    self = [self initWithSceneSize:size];
    if (self) {
        _xPadding           = xPadding;
        _yPadding           = yPadding;
        _cornerRadius       = cornerRadius;
        _borderWidth        = borderWidth;
        _borderColor        = borderColor;
        
        [self layout];
    }
    return self;
}
- (void)popUpNodeInitCommon:(CGSize)size {
    _sceneSize                      = size;
//    _backgroundColor                = [SKColor grayColor];
    _cornerRadius                   = 0.0f;
    _borderColor                    = nil;
    _borderWidth                    = 0.0f;
    _xPadding                       = VERTICAL_SPACING_16;
    _yPadding                       = VERTICAL_SPACING_16;
    _titleLabelTopPading            = VERTICAL_SPACING_16;
    _contentPostion                 = CGPointMake(0.5f, 0.5f);
    
    _titleNode                      = [SKLabelNode labelNodeWithFontNamed:kSIFontUltra];
    _titleNode.zPosition            = SIPopUpNodeZPositionLayerContent * self.zPositionScale / SIPopUpNodeZPositionLayerCount;
    [_backgroundNode addChild:_titleNode];
    
    _dismissButton                  = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonDismiss] size:CGSizeMake(size.width / 10.0f, size.width / 10.0f)];
    _dismissButton.zPosition        = SIPopUpNodeZPositionLayerContent * self.zPositionScale / SIPopUpNodeZPositionLayerCount;
    [_backgroundNode addChild:_dismissButton];
    
    [self layout];
}

- (void)setTitleText:(NSString *)text {
    _titleNode.text = text;
    [self layout];
}

- (NSString *)titleText {
    return _titleNode.text;
}

- (void)setSize:(CGSize)size {
    _backgroundNode.size = size;
    [self layout];
}

- (CGSize)size {
    return _backgroundNode.size;
}

- (void)setAnchorPoint:(CGPoint)anchorPoint {
    self.anchorPoint = anchorPoint;
}

- (CGPoint)anchorPoint {
    return self.anchorPoint;
}

- (NSString *)titleFontName {
    return _titleNode.fontName;
}

- (void)setTitleFontName:(NSString *)titleFontName {
    _titleNode.fontName = titleFontName;
    [self layout];
}

- (CGFloat)titleFontSize {
    return _titleNode.fontSize;
}

- (void)setTitleFontSize:(CGFloat)titleFontSize {
    _titleNode.fontSize = titleFontSize;
    [self layout];
}

- (SKColor *)titleFontColor {
    return _titleNode.fontColor;
}

- (void)setTitleFontColor:(SKColor *)titleFontColor {
    _titleNode.fontColor = titleFontColor;
}

- (SKColor *)backgroundColor {
    return _backgroundNode.color;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundNode.color   = backgroundColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    [self layout];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    if (_borderColor == nil) {
        _borderColor = [SKColor blackColor];
    }
    [self layout];
}

- (void)setBorderColor:(SKColor *)borderColor
{
    _borderColor = borderColor;
    [self layout];
}
- (CGSize)dismissButtonSize {
    return _dismissButton.size;
}

- (void)setDismissButtonSize:(CGSize)dismissButtonSize {
    _dismissButton.size = dismissButtonSize;
}

- (CGPoint)dismissButtonPosition {
    return _dismissButton.position;
}

- (void)setDismissButtonPosition:(CGPoint)dismissButtonPosition {
    CGFloat newX = self.size.width * dismissButtonPosition.x;
    CGFloat newY = self.size.height * dismissButtonPosition.y;

    _dismissButton.position = CGPointMake(newX, newY);
}

- (void)setContentNode:(SKNode *)contentNode {
    SKNode *oldContentNode      = [_backgroundNode childNodeWithName:kSINodePopUpContent];
    if (oldContentNode) {
        [oldContentNode removeFromParent];
    }
    if (contentNode) {
        contentNode.name        = kSINodePopUpContent;
        contentNode.zPosition   = SIPopUpNodeZPositionLayerContent * self.zPositionScale / SIPopUpNodeZPositionLayerCount;
        [_backgroundNode addChild:contentNode];
    }
}

- (void)setXPadding:(CGFloat)xPadding {
    _xPadding = xPadding;
    [self layout];
}

- (void)setYPadding:(CGFloat)yPadding {
    _yPadding = yPadding;
    [self layout];
}

- (SKNode *)contentNode {
    return [_backgroundNode childNodeWithName:kSINodePopUpContent];
}

- (void)setContentPostion:(CGPoint)contentPostion {
    _contentPostion             = contentPostion;
    [self layout];
}

- (void)layout {
    
    CGPoint anchorPoint             = _backgroundNode.anchorPoint;
    

    if (_backgroundNode) {
//        self.position               = CGPointMake(_sceneSize.width / 2.0f, _sceneSize.height / 2.0f);
        
        _backgroundNode.size        = CGSizeMake(_sceneSize.width - _xPadding, _sceneSize.height - _yPadding);
        
//        _backgroundNode.position    = CGPointMake(-anchorPoint.x * (_backgroundNode.size.width / 2.0f) + VERTICAL_SPACING_8, -anchorPoint.y * (_backgroundNode.size.height / 2.0f) + VERTICAL_SPACING_8);
    }
    
    if (_titleNode.text) {
        _titleNode.position         = CGPointMake(self.frame.size.height / 2.0f, self.frame.size.height - _titleNode.frame.size.height - _titleLabelTopPading);
    }
    if (_dismissButton) {
        _dismissButton.position     = CGPointMake((_sceneSize.width / 2.0f) - _dismissButton.frame.size.height / 2.0f, (_sceneSize.height / 2.0f) - _dismissButton.frame.size.height / 2.0f);
    }
    
    if (_cornerRadius > _floatThreshold) {
        _backgroundNode.texture     = [Game textureBackgroundColor:_backgroundNode.color size:_backgroundNode.size];
    }
    
    if (_borderWidth > _floatThreshold) {
        _backgroundNode.texture     = [Game textureBackgroundColor:_backgroundNode.color size:_backgroundNode.size];
    }
    
    if (_borderColor) {
        _backgroundNode.texture     = [Game textureBackgroundColor:_backgroundNode.color size:_backgroundNode.size];
    }
    //617-347-8210

}

#pragma mark - HLGestureTarget

- (NSArray *)addsToGestureRecognizers {
    return @[ [[UITapGestureRecognizer alloc] init] ];
}

- (BOOL)addToGesture:(UIGestureRecognizer *)gestureRecognizer firstTouch:(UITouch *)touch isInside:(BOOL *)isInside
{
    CGPoint location    = [touch locationInNode:self];
    
    *isInside           = NO;
    
    if ([_dismissButton containsPoint:location]) {
        *isInside       = YES;
        if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            // note: Require only one tap and one touch, same as our gesture recognizer
            // returned from addsToGestureRecognizers?  I think it's okay to be non-strict.
//            [gestureRecognizer addTarget:self action:@selector(handleTap:)];
            NSLog(@"Dismiss Pop Up View");
            [self.delegate dismissPopUp:self];
            return YES;
        }
    }

    return NO;
}


@end
