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
    SKNode          *_bottomContentNode;
    SKNode          *_titleContentNode;
    SKNode          *_popupContentContentNode;
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
        _bottomNodeBottomSpacing    = VERTICAL_SPACING_8;
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
    _backgroundNode.zPosition       = SIPopUpNodeZPositionLayerBackground * self.zPositionScale / SIPopUpNodeZPositionLayerCount;
    [self addChild:_backgroundNode];
    
    _titleLabelNode                 = [SKLabelNode labelNodeWithFontNamed:kSISFFontDisplayHeavy];
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
        _titleContentNode           = titleContentNode;
        _titleContentNode.name         = kSINodePopupTitle;
        [_backgroundNode addChild:_titleContentNode];
    }
    [self layoutXY];

}

- (void)setPopupContentNode:(SKNode *)popupContentNode {
    if (_popupContentContentNode) {
        [_popupContentContentNode removeFromParent];
    }
    if (popupContentNode) {
        _popupContentContentNode                    = popupContentNode;
        _popupContentContentNode.name               = kSINodePopupContent;
        [_backgroundNode addChild:_popupContentContentNode];
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
    if (_bottomContentNode) {
        [self layoutXY];
    }
}

- (void)setContentPostion:(CGPoint)contentPostion {
    _contentPostion                     = contentPostion;
    [self layoutXY];
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
    
    if (_popupContentContentNode) {
        _popupContentContentNode.position   = CGPointMake(0.0f, 0.0f);
    }
    
    if (_bottomContentNode) {
        _bottomContentNode.position         = CGPointMake(0.0f, -1.0f * (_backgroundNode.size.height / 2.0f) + _bottomNodeBottomSpacing);
    }
    
    _backgroundNode.texture                 = [SIGame textureBackgroundColor:_backgroundNode.color size:_backgroundNode.size cornerRadius:_cornerRadius borderWidth:_borderWidth borderColor:_borderColor];
}

- (void)layoutZ {
    CGFloat zPositionLayerIncrement     = self.zPositionScale / (float)SIPopUpNodeZPositionLayerCount;
    
    _backgroundNode.zPosition               = SIPopUpNodeZPositionLayerBackground * zPositionLayerIncrement;
    
    if (_popupContentContentNode) {
        _popupContentContentNode.zPosition  = SIZPositionPopupContent * zPositionLayerIncrement;
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
            if ([_delegate respondsToSelector:@selector(dismissPopup:)]) {
                [_delegate dismissPopup:self];
            }
            return YES;
        }
    }
//    if ([_contentNode containsPoint:location]) {
//        if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
//            NSLog(@"Content Node Tapped");
//            *isInside       = YES;
//            return YES;
//        }
//
//    }
    
    return NO;
}

#pragma mark - Launch Coins
//- (void)launchCoins:(int)totalCoins coinsLaunched:(int)coinsLaunched {
//    if (coinsLaunched == totalCoins) {
//        [self finishPrize];
//    } else {
//        _prizeAmountLabelNode.text  = [NSString stringWithFormat:@"%d",totalCoins - coinsLaunched - 1];
//        [self lauchCoin];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(((CGFloat)(totalCoins - coinsLaunched) / (CGFloat)totalCoins) / 2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self launchCoins:totalCoins coinsLaunched:coinsLaunched + 1];
//        });
//    }
//}
- (void)launchNode:(SKSpriteNode *)node {
    
    CGFloat zPositionLayerIncrement             = self.zPositionScale / (float)SIPopUpNodeZPositionLayerCount;
    
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
//- (void)finishPrize {
//    if ([SIConstants isFXAllowed]) {
//        [[SoundManager sharedManager] playSound:kSISoundFXChaChing];
//    }
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSDate *currentDate = [SIGameController getDateFromInternet];
//        if (currentDate) {
//            [[MKStoreKit sharedKit] addFreeCredits:[NSNumber numberWithInt:[self getPrizeAmount]] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:kSINSUserDefaultLastPrizeAwardedDate];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            [self changeCoinValue];
//        }
//        [self increaseConsecutiveDaysLaunched];
//        [self dismissModalNodeAnimation:HLScenePresentationAnimationFade];
//    });
//}



@end
