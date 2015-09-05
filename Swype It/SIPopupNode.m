//
//  SIPopupNode.m
//  Swype It
//
//  Created by Andrew Keller on 8/13/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
#import "SKNode+HLGestureTarget.h"
#import "SIPopupNode.h"
enum {
    SIPopUpNodeZPositionLayerBackground = 0,
    SIPopUpNodeZPositionLayerContent,
    SIPopUpNodeZPositionLayerCount
};


@implementation SIPopupNode {
    
    CGFloat          _floatThreshold;
    
    CGSize           _sceneSize;
    
//    HLComponentNode *_contentNode;
    SKNode          *_titleNode;
    SKNode          *_contentNode;
    SKSpriteNode    *_backgroundNode;
    SKSpriteNode    *_dismissButton;
    SKLabelNode     *_titleLabelNode;
}


- (nonnull instancetype)init {
    self = [super init];
    if (self) {
        _cornerRadius               = 0.0f;
        _borderColor                = nil;
        _borderWidth                = 0.0f;
        _xPadding                   = VERTICAL_SPACING_16;
        _yPadding                   = VERTICAL_SPACING_16;
        _titleLabelTopPading        = VERTICAL_SPACING_16;
        _titleAutomaticYPosition    = NO;
        _contentPostion             = CGPointMake(0.5f, 0.5f);
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
        _titleNode                  = titleNode;
        
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
    _backgroundNode.zPosition       = SIPopUpNodeZPositionLayerBackground * self.zPositionScale / SIPopUpNodeZPositionLayerCount;
    [self addChild:_backgroundNode];
    
    _titleLabelNode                 = [SKLabelNode labelNodeWithFontNamed:kSIFontUltra];
    _titleLabelNode.zPosition       = SIPopUpNodeZPositionLayerContent * self.zPositionScale / SIPopUpNodeZPositionLayerCount;
    [_backgroundNode addChild:_titleLabelNode];
    
    _dismissButton                  = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonDismiss] size:CGSizeMake(size.width / 10.0f, size.width / 10.0f)];
    _dismissButton.zPosition        = SIPopUpNodeZPositionLayerContent * self.zPositionScale / SIPopUpNodeZPositionLayerCount;
    [_backgroundNode addChild:_dismissButton];
    
    [self layoutXY];
}


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
}

- (CGPoint)dismissButtonPosition {
    return _dismissButton.position;
}

- (void)setDismissButtonPosition:(CGPoint)dismissButtonPosition {
    CGFloat newX                        = self.size.width * dismissButtonPosition.x;
    CGFloat newY                        = self.size.height * dismissButtonPosition.y;

    _dismissButton.position             = CGPointMake(newX, newY);
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
    
    if (_titleNode) {
        [_titleNode removeFromParent];
    }
    
    if (titleContentNode) {
        _titleNode                      = titleContentNode;
        _titleNode.name                 = kSINodePopupTitle;
        [_backgroundNode addChild:_titleNode];
    }
    [self layoutXY];

}

- (void)setPopupContentNode:(SKNode *)popupContentNode {
    if (_contentNode) {
        [_contentNode removeFromParent];
    }
    if (popupContentNode) {
        _contentNode                    = popupContentNode;
        _contentNode.name               = kSINodePopupContent;
        [_backgroundNode addChild:_contentNode];
    }
    [self layoutXY];
}

- (void)setContentPostion:(CGPoint)contentPostion {
    _contentPostion                     = contentPostion;
    [self layoutXY];
}

- (void)layoutXY {

    if (!_backgroundNode) {
        return;
    }
    _backgroundNode.size                = CGSizeMake(_sceneSize.width - _xPadding, _sceneSize.height - _yPadding);

    if (_titleNode) {
        /*If someone supplied their own node*/
        _titleNode.position             = CGPointMake(0.0f, self.backgroundSize.height / 2.0f - _titleLabelTopPading - _titleNode.frame.size.height / 2.0f);
        
    } else {
        /*Use titleLabelNode*/
        _titleLabelNode.position        = CGPointMake(0.0f, self.backgroundSize.height / 2.0f - _titleLabelTopPading);

        if (_titleAutomaticYPosition) { //this moves the top label
            _titleLabelNode.position    = CGPointMake(0.0f, (_backgroundNode.size.height / 2.0f) - _titleLabelNode.frame.size.height - _titleLabelTopPading);
        }

    }


    if (_dismissButton) {
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
    
    _backgroundNode.texture             = [Game textureBackgroundColor:_backgroundNode.color size:_backgroundNode.size cornerRadius:_cornerRadius borderWidth:_borderWidth borderColor:_borderColor];
}

- (void)layoutZ
{
    CGFloat zPositionLayerIncrement     = self.zPositionScale / SIPopUpNodeZPositionLayerCount;
    _backgroundNode.zPosition           = SIPopUpNodeZPositionLayerBackground * zPositionLayerIncrement;
    _popupContentNode.zPosition         = SIPopUpNodeZPositionLayerContent * zPositionLayerIncrement;
//    _popupContentNode.zPositionScale    = zPositionLayerIncrement;
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
            NSLog(@"Dismiss Pop Up View");
            [self.delegate dismissPopUp:self];
            return YES;
        }
    }
    if ([_contentNode containsPoint:location]) {
        if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            NSLog(@"Content Node Tapped");
            *isInside       = YES;
            return YES;        }

    }
    
    return NO;
}


@end
