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
    SKNode          *_detailNode;
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
        
        [self layout];
    }
    return self;
}

- (instancetype)initWithSceneSize:(CGSize)size titleLabelNode:(SKLabelNode *)titleLabelNode {
    self = [super init];
    if (self) {
        _floatThreshold             = 0.01;
        
        _backgroundNode             = [SKSpriteNode spriteNodeWithColor:[SKColor grayColor] size:CGSizeMake(size.width - VERTICAL_SPACING_16, size.width - VERTICAL_SPACING_16)];
        _backgroundNode.anchorPoint = CGPointMake(0.5f, 0.5f);
        _backgroundNode.zPosition   = SIPopUpNodeZPositionLayerBackground * self.zPositionScale / SIPopUpNodeZPositionLayerCount;
        [self addChild:_backgroundNode];
        
        [self popUpNodeInitCommon:size withTitleLabel:titleLabelNode];
        
        [self layout];
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
    self = [self initWithSceneSize:size];
    if (self) {
        
        _xPadding               = size.width - popUpSize.width;
        _yPadding               = size.height - popUpSize.height;
        _cornerRadius           = cornerRadius;
        _borderWidth            = borderWidth;
        _borderColor            = borderColor;
        
        _titleNode.text         = titleText;
        _titleNode.fontColor    = titleFontColor;
        _titleNode.fontSize     = titleFontSize;
        _titleLabelTopPading    = titleYPadding;
        
        if (backgroundColor) {
            _backgroundNode.color = backgroundColor;
        }
        
        [self layout];
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
    self = [self initWithSceneSize:size];
    if (self) {
        _xPadding               = xPadding;
        _yPadding               = yPadding;
        _cornerRadius           = cornerRadius;
        _borderWidth            = borderWidth;
        _borderColor            = borderColor;
        
        _titleNode.text         = titleText;
        _titleNode.fontColor    = titleFontColor;
        _titleNode.fontSize     = titleFontSize;
        
        if (backgroundColor) {
            _backgroundNode.color = backgroundColor;
        }
        
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

- (void)popUpNodeInitCommon:(CGSize)size withTitleLabel:(SKLabelNode *)titleLabelNode {
    _sceneSize                      = size;
    //    _backgroundColor                = [SKColor grayColor];
    _cornerRadius                   = 0.0f;
    _borderColor                    = nil;
    _borderWidth                    = 0.0f;
    _xPadding                       = VERTICAL_SPACING_16;
    _yPadding                       = VERTICAL_SPACING_16;
    _titleLabelTopPading            = VERTICAL_SPACING_16;
    _contentPostion                 = CGPointMake(0.5f, 0.5f);
    
    _titleNode                      = titleLabelNode;
    _titleNode.zPosition            = SIPopUpNodeZPositionLayerContent * self.zPositionScale / SIPopUpNodeZPositionLayerCount;
    [_backgroundNode addChild:_titleNode];
    
    _dismissButton                  = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonDismiss] size:CGSizeMake(size.width / 10.0f, size.width / 10.0f)];
    _dismissButton.zPosition        = SIPopUpNodeZPositionLayerContent * self.zPositionScale / SIPopUpNodeZPositionLayerCount;
    [_backgroundNode addChild:_dismissButton];
    
    [self layout];
}

- (CGSize)backgroundSize {
    return _backgroundNode.size;
}

- (void)setBackgroundSize:(CGSize)backgroundSize {
    _xPadding               = _sceneSize.width - backgroundSize.width;
    _yPadding               = _sceneSize.height - backgroundSize.height;
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

//- (void)setMenuNode:(HLMenuNode *)menuNode {
//    if (_contentNode) {
//        [_contentNode removeFromParent];
//    }
//    if (menuNode) {
//        _contentNode               = menuNode;
//        _contentNode.name          = kSINodePopUpContent;
//        _contentNode.zPosition     = SIPopUpNodeZPositionLayerContent * self.zPositionScale / SIPopUpNodeZPositionLayerCount;
//        [_backgroundNode addChild:_contentNode];
//        [_contentNode hlSetGestureTarget:_contentNode];
//    }
//}

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
- (void)setContentNode:(SKNode *)contentNode {
    if (_detailNode) {
        [_detailNode removeFromParent];
    }
    if (contentNode) {
        _detailNode             = contentNode;
        _detailNode.name        = kSINodePopUpContent;
        _detailNode.zPosition   = SIPopUpNodeZPositionLayerContent * self.zPositionScale / SIPopUpNodeZPositionLayerCount;
        [_backgroundNode addChild:_detailNode];
        id <HLGestureTarget> target = [_detailNode hlGestureTarget];
        if (target) {
            [_detailNode hlSetGestureTarget:_detailNode];
        }
    }
}


- (void)setContentPostion:(CGPoint)contentPostion {
    _contentPostion             = contentPostion;
    [self layout];
}

- (void)layout {

    if (_backgroundNode) {
        _backgroundNode.size            = CGSizeMake(_sceneSize.width - _xPadding, _sceneSize.height - _yPadding);
    }
    
    if (_titleNode.text && _backgroundNode) {
        _titleNode.position             = CGPointMake(0.0f, (_backgroundNode.size.height / 2.0f) - _titleNode.frame.size.height - _titleLabelTopPading);
    }
    if (_dismissButton && _backgroundNode) {
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
    
//    if (_menuNode) {
//        NSUInteger numberOfMenuItems    = _menuNode.menu.itemCount;
//        
//        for (NSUInteger i = 0; i < numberOfMenuItems; i++) {
//            HLMenuItem *menuItem        = [_menuNode.menu itemAtIndex:i];
//            if ([menuItem.buttonPrototype containsPoint:location]) {
//                *isInside       = YES;
//                NSLog(@"Holy shit button with text `%@` tapped",menuItem.text);
//                return YES;
//            }
//        }
//    }


    return NO;
}


@end
