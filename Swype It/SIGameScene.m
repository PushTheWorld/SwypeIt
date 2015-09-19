//  SIGameSceneTemp.m
//  Swype It
//
//  Created by Andrew Keller on 9/10/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: This is....
//
// Local Controller Import
#import "SIAdBannerNode.h"
#import "SIGameScene.h"
#import "SIGameController.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIIAPUtility.h"
// Other Imports

#define FALLING_MONKEY_Z_POSITION_INCREMENTER 0.01
static const uint32_t SIGameSceneCategoryZero          = 0x0;      // 00000000000000000000000000000000
static const uint32_t SIGameSceneCategoryUIControl     = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t SIGameSceneCategoryEdge          = 0x1 << 2; // 00000000000000000000000000000100
static const uint32_t SIGameSceneCategoryMoveScore     = 0x1 << 3; // 00000000000000000000000000001000



@implementation SIGameScene {
    
//    BMGlyphLabel                                        *_scoreTotalContentLabel;
    SKLabelNode                                         *_swypeItCoinsLabelNode;
    
    CGSize                                               _coinSize;
    CGSize                                               _swypeItCoinsBackgroundNodeSize;
    CGSize                                               _pauseButtonSize;
    CGSize                                               _sceneSize;
    CGSize                                               _moveCommandLabelSize;
    
    HLLabelButtonNode                                   *_pauseButtonNode;
    
    HLRingNode                                          *_ringContentNode;
    
    HLToolbarNode                                       *_powerUpToolbarContentNode;
    
    SIAdBannerNode                                      *_adContentNode;
    
    SIPopupNode                                         *_popupContentNode;
    
    SKLabelNode                                         *_highScoreLabelNode;
    
    SKNode                                              *_edge;
    
    SIGameNode                                          *_backgroundNode;

    SKSpriteNode                                        *_coinNode;
    SKSpriteNode                                        *_overlayContentNode;
    SKSpriteNode                                        *_swypeItCoinsBackgroundNode;
    
//    TCProgressBarNode                                   *_progressBarFreeCoinContent;
//    TCProgressBarNode                                   *_progressBarMoveContent;
//    TCProgressBarNode                                   *_progressBarPowerUpContent;
}

#pragma mark -
#pragma mark - Scene Life Cycle
+ (CGFloat)SIGameSceneSwypeItCoinsLabelScale {
    if (IS_IPHONE_4) {
        return 0.8f;
        
    } else if (IS_IPHONE_5) {
        return 0.9f;
        
    } else if (IS_IPHONE_6) {
        return 0.7f;
        
    } else if (IS_IPHONE_6_PLUS) {
        return 0.9f;

    } else {
        return 1.0f;
    }
}

- (nonnull instancetype)init {
    self = [super init];
    if (self) {
        _animationDuration                              = 1.0f;
        _blurScreenDuration                             = 0.25f;
        _moveCommandRandomLocation                      = NO;
        _scoreTotalLabelTopPadding                      = VERTICAL_SPACING_8;
        _swypeItCoins                                   = 0;
    }
    return self;
}
- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /**Do any setup before self.view is loaded*/
        [self initSetup:size];
    }
    return self;
}
- (void)didMoveToView:(nonnull SKView *)view {
    [super didMoveToView:view];
    /**Do any setup post self.view creation*/
    [self viewSetup:view];
    self.gestureTargetHitTestMode                       = HLSceneGestureTargetHitTestModeDeepestThenParent;
    
    [_backgroundNode hlSetGestureTarget:_backgroundNode];
    [self registerDescendant:_backgroundNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];

}
- (void)willMoveFromView:(nonnull SKView *)view {
    /**Do any breakdown prior to the view being unloaded*/
    
    /*Resume move from view*/
    [super willMoveFromView:view];
}
- (void)initSetup:(CGSize)size {
    /**Preform initalization pre-view load*/
    [self createConstantsWithSize:size];
    [self createControlsWithSize:size];
    [self setupControlsWithSize:size];
    [self layoutControlsWithSize:size];
}
- (void)viewSetup:(SKView *)view {
    /**Preform setup post-view load*/
    [self layoutScene];
}


#pragma mark Scene Setup
- (void)createConstantsWithSize:(CGSize)size {
    /**Configure any constants*/
    _sceneSize                                              = size;
    _pauseButtonSize                                        = CGSizeMake(size.width / 8.0f, size.width / 8.0f);
        
}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    
    /*Create Background Node*/
    _backgroundNode                                         = [[SIGameNode alloc] initWithSize:_sceneSize gameMode:SIGameModeTwoHand];

    _edge                                                   = [SKNode node];
    
    _swypeItCoinsLabelNode                                  = [SKLabelNode labelNodeWithFontNamed:kSISFFontDisplayHeavy];
    _swypeItCoinsLabelNode.fontSize                         = [SIGameController SIFontSizeParagraph];
    _swypeItCoinsLabelNode.text                             = @"-1";//[NSString stringWithFormat:@"%d",[SIIAPUtility numberOfCoinsForUser]];
    
    _coinSize                                               = CGSizeMake(_swypeItCoinsLabelNode.frame.size.height * 0.75f, _swypeItCoinsLabelNode.frame.size.height * 0.75f);
    _coinNode                                               = [SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageCoinSmallFront] size:_coinSize];
    
    _swypeItCoinsBackgroundNodeSize                         = CGSizeMake(_swypeItCoinsLabelNode.frame.size.width + _coinSize.width + VERTICAL_SPACING_8, _swypeItCoinsLabelNode.frame.size.height + VERTICAL_SPACING_8);
    _swypeItCoinsBackgroundNode                             = [SKSpriteNode spriteNodeWithTexture:[SIGame textureBackgroundColor:[SKColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1]
                                                                                                                            size:_swypeItCoinsBackgroundNodeSize
                                                                                                                    cornerRadius:8.0f
                                                                                                                     borderWidth:2.0f
                                                                                                                     borderColor:[SKColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]]];
//    [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1] size:_swypeItCoinsBackgroundNodeSize];

    _pauseButtonNode                                        = [[HLLabelButtonNode alloc] initWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonPause]];
    
    _highScoreLabelNode                                     = [SIGameController SILabelParagraph_x2:@"HIGH SCORE!"];
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    _backgroundNode.anchorPoint                             = CGPointMake(0.0f, 0.0f);
//    _backgroundNode.physicsBody.categoryBitMask                 = SIFallingMonkeySceneCategoryUIControl;
    _backgroundNode.zPosition                               = [SIGameController floatZPositionGameForContent:SIZPositionGameBackground];
    _backgroundNode.backgroundColor                         = [SKColor mainColor];;
    _backgroundNode.delegate                                = self;
    [_backgroundNode hlSetGestureTarget:_backgroundNode];
    
    _edge.physicsBody.categoryBitMask                       = SIGameSceneCategoryEdge;
    _edge.physicsBody.collisionBitMask                      = SIGameSceneCategoryZero;
    
    _coinNode.anchorPoint                                   = CGPointMake(0.0f, 0.5);
    _coinNode.physicsBody.categoryBitMask                   = SIGameSceneCategoryUIControl;
    
    _swypeItCoinsBackgroundNode.anchorPoint                 = CGPointMake(0.0f, 1.0f);
    _swypeItCoinsBackgroundNode.physicsBody.categoryBitMask = SIGameSceneCategoryUIControl;
    
    _pauseButtonNode.name                                   = kSINodeButtonPause;
    _pauseButtonNode.size                                   = _pauseButtonSize;
    _pauseButtonNode.physicsBody.categoryBitMask            = SIGameSceneCategoryUIControl;
    _pauseButtonNode.userInteractionEnabled                 = YES;
    _pauseButtonNode.zPosition                              = [SIGameController floatZPositionGameForContent:SIZPositionGameContent];
    
    _swypeItCoinsLabelNode.zPosition                        = [SIGameController floatZPositionGameForContent:SIZPositionGameContent];
    _swypeItCoinsLabelNode.physicsBody.categoryBitMask      = SIGameSceneCategoryUIControl;
    _swypeItCoinsLabelNode.horizontalAlignmentMode          = SKLabelHorizontalAlignmentModeLeft;
    _swypeItCoinsLabelNode.verticalAlignmentMode            = SKLabelVerticalAlignmentModeTop;
//    [_swypeItCoinsLabelNode runAction:[SKAction scaleBy:[SIGameScene SIGameSceneSwypeItCoinsLabelScale] duration:0.0f]];

    
    _highScoreLabelNode.zPosition                           = [SIGameController floatZPositionGameForContent:SIZPositionGameContent];
    _highScoreLabelNode.physicsBody.categoryBitMask         = SIGameSceneCategoryUIControl;
    _highScoreLabelNode.horizontalAlignmentMode             = SKLabelHorizontalAlignmentModeCenter;
    _highScoreLabelNode.verticalAlignmentMode               = SKLabelVerticalAlignmentModeCenter;
    _highScoreLabelNode.hidden                              = YES;

}

- (void)layoutControlsWithSize:(CGSize)size {
    /**Layout those controls*/
    _backgroundNode.position                                = CGPointMake(0.0f, 0.0f);
    [self addChild:_backgroundNode];
    
    [self addChild:_edge];
    
    [self addChild:_pauseButtonNode];
    
    [self addChild:_highScoreLabelNode];
    
    [self addChild:_swypeItCoinsBackgroundNode];
    
//    _swypeItCoinsLabelNode.position                         = CGPointMake(VERTICAL_SPACING_8, 0);
    [_swypeItCoinsBackgroundNode addChild:_swypeItCoinsLabelNode];

//    _coinNode.position                                      = CGPointMake(VERTICAL_SPACING_8 + _swypeItCoinsLabelNode.frame.size.width, -1.0f * (_swypeItCoinsBackgroundNodeSize.height / 2.0f));
    [_swypeItCoinsBackgroundNode addChild:_coinNode];
}

#pragma mark -
#pragma mark - Public Accessors
- (SIAdBannerNode *)adBannerNode {
    if (_adContentNode) {
        return _adContentNode;
    } else {
        return nil;
    }
}
- (void)setAdBannerNode:(SIAdBannerNode *)adBannerNode {
    if (_adContentNode) {
        [_adContentNode removeFromParent];
    }
    if (adBannerNode) {
        _adContentNode                                      = adBannerNode;
        _adContentNode.name                                 = kSINodeAdBannerNode;
        _adContentNode.position                             = CGPointMake(0.0f, 0.0f);
        [self addChild:_adContentNode];
        [_adContentNode hlSetGestureTarget:_adContentNode];
        [self registerDescendant:_adContentNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];

    }
    [self layoutXYAnimation:SISceneContentAnimationNone];
    [self updatePhysicsEdges];
}

/**
 When blur screen is set true at run time it updates and adds it
 */
- (void)setBlurScreen:(BOOL)blurScreen {
    if (_overlayContentNode) {
        [_overlayContentNode removeFromParent];
    }
    if (blurScreen) {
        _overlayContentNode                                 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[SIGame getBluredScreenshot:self.view]]];
        _overlayContentNode.alpha                           = 0.0f;
        [self addChild:_overlayContentNode];
    }
    [self layoutXYZAnimation:SISceneContentAnimationNone];
}

/**
 This will intercept the and override the command going to self
 and will allow us to actually change the color of the background node
 */
- (void)setMoveCommandLabel:(SKLabelNode *)moveCommandLabel {
    //We are not removing the original because it is being launched and handled
    _moveCommandLabel = moveCommandLabel;
    
    if (moveCommandLabel) {
        SKAction *fadeActionSequenceForNewLabel         = [SKAction sequence:@[[SKAction fadeOutWithDuration:0.0f],
                                                                               [SKAction fadeInWithDuration:MOVE_COMMAND_LAUNCH_DURATION]]];
        [_moveCommandLabel runAction:fadeActionSequenceForNewLabel];
        _moveCommandLabel.horizontalAlignmentMode       = SKLabelHorizontalAlignmentModeCenter;
        _moveCommandLabel.verticalAlignmentMode         = SKLabelVerticalAlignmentModeCenter;
        _moveCommandLabel.userInteractionEnabled        = YES;
        [self addChild:_moveCommandLabel];
        _moveCommandLabelSize                           = _moveCommandLabel.frame.size;
    }
    [self layoutXYZAnimation:SISceneContentAnimationNone];
}

- (SIPopupNode *)popupNode {
    if (_popupContentNode) {
        return _popupContentNode;
    } else {
        return nil;
    }
}
/**
 A popup node to be displayed modally
 */
- (void)setPopupNode:(SIPopupNode *)popupNode {
    if (_popupContentNode) {
        if ([self modalNodePresented]) {
            [self dismissModalNodeAnimation:HLScenePresentationAnimationFade];
        }
        [_popupContentNode removeFromParent];
    }
    if (popupNode) {
        _popupContentNode                                   = popupNode;
        [self addChild:_popupContentNode];
    }
    [self layoutXYZAnimation:SISceneContentAnimationNone];
}

- (HLToolbarNode *)powerUpToolbarNode {
    return _powerUpToolbarContentNode;
}
- (void)setPowerUpToolbarNode:(HLToolbarNode *)powerUpToolbarNode {
    if (_powerUpToolbarContentNode) {
        [_powerUpToolbarContentNode removeFromParent];
    }
    if (powerUpToolbarNode) {
        _powerUpToolbarContentNode                              = powerUpToolbarNode;
        _powerUpToolbarContentNode.physicsBody.categoryBitMask  = SIGameSceneCategoryUIControl;
        _powerUpToolbarContentNode.anchorPoint                  = CGPointMake(0.5f, 0.0f);
        
        [self addChild:_powerUpToolbarContentNode];
    }
    [self layoutXYZAnimation:SISceneContentAnimationNone];
}

- (void)setProgressBarFreeCoin:(TCProgressBarNode *)progressBarFreeCoin {
    if (_progressBarFreeCoin) {
        [_progressBarFreeCoin removeFromParent];
    }
    if (progressBarFreeCoin) {
        _progressBarFreeCoin = progressBarFreeCoin;
//        _progressBarFreeCoin.position   = CGPointZero;
//        [self addChild:_progressBarFreeCoin];
    }
    [self layoutXYZAnimation:SISceneContentAnimationNone];
}

- (void)setProgressBarMove:(TCProgressBarNode *)progressBarMove {
    if (_progressBarMove) {
        [_progressBarMove removeFromParent];
    }
    if (progressBarMove) {
        _progressBarMove = progressBarMove;
        _progressBarMove.physicsBody.categoryBitMask = SIGameSceneCategoryUIControl;
        [self addChild:_progressBarMove];
        _progressBarMove.progress = 1.0f;
    }
    [self layoutXYZAnimation:SISceneContentAnimationNone];
}

- (void)setProgressBarPowerUp:(TCProgressBarNode *)progressBarPowerUp {
    if (_progressBarPowerUp) {
        [_progressBarPowerUp removeFromParent];
    }
    if (progressBarPowerUp) {
        _progressBarPowerUp = progressBarPowerUp;
        _progressBarPowerUp.physicsBody.categoryBitMask = SIGameSceneCategoryUIControl;
        [self addChild:_progressBarPowerUp];
        _progressBarPowerUp.progress = 1.0f;
    }
    [self layoutXYZAnimation:SISceneContentAnimationNone];
}

/**
 A ring node to be displayed in the center
 */
- (void)setRingNode:(HLRingNode *)ringNode {
    if (_ringContentNode) {
        if ([self modalNodePresented]) {
            [self dismissModalNodeAnimation:HLScenePresentationAnimationFade];
        }
        [_ringContentNode removeFromParent];
    }
    if (ringNode) {
        _ringContentNode                            = ringNode;
        [self addChild:_ringContentNode];
    }
    [self layoutXYZAnimation:SISceneContentAnimationNone];
}

/**
 The label for the total score
 */
- (void)setScoreTotalLabel:(SKLabelNode *)scoreTotalLabel {
    if (_scoreTotalLabel) {
        [_scoreTotalLabel removeFromParent];
    }
    if (scoreTotalLabel) {
        _scoreTotalLabel                             = scoreTotalLabel;
        _scoreTotalLabel.physicsBody.categoryBitMask = SIGameSceneCategoryUIControl;
        [self addChild:_scoreTotalLabel];
    }
    [self layoutXYAnimation:SISceneContentAnimationNone];
}

/**
 The padding of the top label
 */
- (void)setScoreTotalLabelTopPadding:(CGFloat)scoreTotalLabelTopPadding {
    [self layoutXYAnimation:SISceneContentAnimationNone];
}


- (BOOL)highScore {
    return !_highScoreLabelNode.hidden;
}

- (void)setHighScore:(BOOL)highScore {
    _highScoreLabelNode.hidden = !highScore;
    if (highScore) {
        if (_highScoreLabelNode.hidden == YES) {
            _highScoreLabelNode.hidden = NO;
            [_highScoreLabelNode runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction scaleTo:1.1 duration:0.5f],
                                                                                              [SKAction scaleTo:0.9 duration:0.5f]]]]];
        }
    } else {
        _highScoreLabelNode.hidden = YES;
    }
}

#pragma mark Layout
- (void)layoutScene {
    [self layoutXYZAnimation:SISceneContentAnimationNone];
    [self updatePhysicsEdges];
}
- (void)layoutXYZAnimation:(SISceneContentAnimation)animation {
    [self layoutXYAnimation:animation];
    [self layoutZ];
}

- (void)layoutXYAnimation:(SISceneContentAnimation)animation {
    /**Layout those controls*/
    CGFloat sceneMidX                               = _sceneSize.width /2.0f;
    CGFloat sceneMidY                               = _sceneSize.height /2.0f;
    CGPoint sceneMidPoint = CGPointMake(sceneMidX, sceneMidY);
    
    CGPoint positionHidden = CGPointZero;
    CGPoint positionVisible = CGPointZero;
    
    if (_overlayContentNode) {
        _overlayContentNode.position                = sceneMidPoint;
        [_overlayContentNode runAction:[SKAction fadeAlphaTo:1 duration:_blurScreenDuration]];
    }
    
    if (_scoreTotalLabel) {
        positionHidden      = CGPointMake(sceneMidX, _sceneSize.height + _scoreTotalLabel.frame.size.height + VERTICAL_SPACING_4);
        positionVisible     = CGPointMake(_sceneSize.width / 2.0f, _sceneSize.height - _scoreTotalLabelTopPadding);
        [SIGameController SIControllerNode:_scoreTotalLabel
                                 animation:animation
                            animationStyle:SISceneContentAnimationStyleSlide
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    if (_progressBarPowerUp) {
        positionHidden      = CGPointMake(sceneMidX, sceneMidY - _progressBarPowerUp.size.height);
        positionVisible     = CGPointMake(sceneMidX,sceneMidY + (_progressBarPowerUp.size.height / 2.0f) + (_moveCommandLabelSize.height / 2.0f) + VERTICAL_SPACING_8);
        [SIGameController SIControllerNode:_progressBarPowerUp
                                 animation:animation
                            animationStyle:SISceneContentAnimationStyleGrow
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    if (_moveCommandLabel) {
        positionHidden      = CGPointMake(sceneMidX, sceneMidY);
        positionVisible     = CGPointMake(sceneMidX,sceneMidY);

//        CGFloat progressBarYOffset                  = _scoreTotalContentLabel.frame.origin.y + (_scoreTotalContentLabel.frame.size.height / 2.0f) + VERTICAL_SPACING_8;
//        _moveCommandLabel.position = CGPointMake(_sceneSize.width / 2.0f, progressBarYOffset + (_moveCommandLabel.size.height / 2.0f));
        [SIGameController SIControllerNode:_moveCommandLabel
                                 animation:animation
                            animationStyle:SISceneContentAnimationStyleGrow
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }

    
    if (_progressBarMove) {
        _progressBarMove.userInteractionEnabled = YES;
        positionHidden      = CGPointMake(sceneMidX, sceneMidY - _progressBarMove.size.height);
        positionVisible     = CGPointMake(sceneMidX,sceneMidY - (_progressBarMove.size.height / 2.0f) - (_moveCommandLabelSize.height / 2.0f) - VERTICAL_SPACING_8);

//        positionHidden      = CGPointMake(sceneMidX, -1.0f * _powerUpToolbarContentNode.frame.size.height);
//        positionVisible     = CGPointMake(0.0f,_adContentNode.size.height + VERTICAL_SPACING_4 + ((_powerUpToolbarContentNode.frame.size.height / 2.0f)));
        [SIGameController SIControllerNode:_progressBarMove
                                 animation:animation
                            animationStyle:SISceneContentAnimationStyleSlide
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    if (_powerUpToolbarContentNode) {
        positionHidden      = CGPointMake(sceneMidX, -1.0f * _powerUpToolbarContentNode.frame.size.height);
        positionVisible     = CGPointMake(0.0f,_adContentNode.size.height + VERTICAL_SPACING_4 + ((_powerUpToolbarContentNode.frame.size.height / 2.0f)));
        [SIGameController SIControllerNode:_powerUpToolbarContentNode
                                 animation:animation
                            animationStyle:SISceneContentAnimationStyleSlide
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    if (_pauseButtonNode) {
        [_pauseButtonNode removeFromParent];
        [self addChild:_pauseButtonNode];
        [_pauseButtonNode hlSetGestureTarget:[HLTapGestureTarget tapGestureTargetWithHandleGestureBlock:^(UIGestureRecognizer *gr) {
            if ([_sceneDelegate respondsToSelector:@selector(controllerSceneGamePauseButtonTapped)]) {
                [_sceneDelegate controllerSceneGamePauseButtonTapped];
            }
        }]];
        [self registerDescendant:_pauseButtonNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];

        positionVisible = CGPointMake(_sceneSize.width - VERTICAL_SPACING_16 - (_pauseButtonSize.width / 2.0f), _sceneSize.height - VERTICAL_SPACING_8 - (_pauseButtonSize.width / 2.0f));
        positionHidden = CGPointMake(_sceneSize.width + positionVisible.x, positionVisible.y);
        [SIGameController SIControllerNode:_pauseButtonNode
                                 animation:animation
                            animationStyle:SISceneContentAnimationStyleSlide
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    if (_swypeItCoinsBackgroundNode) {
        [_swypeItCoinsBackgroundNode removeFromParent];
        [self addChild:_swypeItCoinsBackgroundNode];
        positionVisible = CGPointMake(VERTICAL_SPACING_8,_sceneSize.height - VERTICAL_SPACING_8);
        positionHidden = CGPointMake(-1.0f * _swypeItCoinsLabelNode.frame.size.width, positionVisible.y);
        [SIGameController SIControllerNode:_swypeItCoinsBackgroundNode
                                 animation:animation
                            animationStyle:SISceneContentAnimationStyleSlide
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
        
//        if (_progressBarFreeCoin) {
//            positionVisible = CGPointMake(VERTICAL_SPACING_8 +_swypeItCoinsBackgroundNodeSize.width + VERTICAL_SPACING_8 +(_progressBarFreeCoin.size.width / 2.0f), _sceneSize.height - VERTICAL_SPACING_8 - (_swypeItCoinsBackgroundNodeSize.height / 2.0f));
//            positionHidden = CGPointMake(0.0f, positionVisible.y + _progressBarFreeCoin.size.height);
//            [SIGameController SIControllerNode:_progressBarFreeCoin
//                                     animation:SISceneContentAnimationIn
//                                animationStyle:SISceneContentAnimationStyleSlide
//                             animationDuration:_animationDuration
//                               positionVisible:positionVisible
//                                positionHidden:positionHidden];
//        }

    }
    
    if (_highScoreLabelNode) {
        positionVisible     = CGPointMake(_sceneSize.width / 2.0f, _sceneSize.height - _scoreTotalLabelTopPadding - _moveCommandLabel.frame.size.height);
        [SIGameController SIControllerNode:_highScoreLabelNode
                                 animation:animation
                            animationStyle:SISceneContentAnimationStyleGrow
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    if (_swypeItCoinsLabelNode) {
        if ([[NSString stringWithFormat:@"%d",[SIIAPUtility numberOfCoinsForUser]] isEqualToString:_swypeItCoinsLabelNode.text] == NO) {
            _swypeItCoinsLabelNode.text                 = [NSString stringWithFormat:@"%d",[SIIAPUtility numberOfCoinsForUser]];
            _swypeItCoinsBackgroundNodeSize             = CGSizeMake(VERTICAL_SPACING_4 + _swypeItCoinsLabelNode.frame.size.width + VERTICAL_SPACING_4 + _coinSize.width + VERTICAL_SPACING_4, VERTICAL_SPACING_4 + _swypeItCoinsLabelNode.frame.size.height + VERTICAL_SPACING_4 + _swypeItCoinsLabelNode.fontSize + VERTICAL_SPACING_4);
            _swypeItCoinsBackgroundNode.size            = _swypeItCoinsBackgroundNodeSize;
            _swypeItCoinsLabelNode.position             = CGPointMake(VERTICAL_SPACING_8, -VERTICAL_SPACING_4);
            _coinNode.position                          = CGPointMake(VERTICAL_SPACING_4 + _swypeItCoinsLabelNode.frame.size.width + VERTICAL_SPACING_4, -1.0f * (_swypeItCoinsLabelNode.fontSize / 2.0f));
            CGFloat multiplier                          = (_swypeItCoinsBackgroundNodeSize.height + VERTICAL_SPACING_8) / _pauseButtonSize.height;
            [_pauseButtonNode runAction:[SKAction scaleTo:multiplier duration:0.0f]];
        }
        [_progressBarFreeCoin removeFromParent];
        _progressBarFreeCoin                            = [[TCProgressBarNode alloc] initWithSize:CGSizeMake(_swypeItCoinsBackgroundNodeSize.width - VERTICAL_SPACING_16,_swypeItCoinsLabelNode.fontSize - VERTICAL_SPACING_8) backgroundColor:[SKColor lightGrayColor] fillColor:[SKColor goldColor] borderColor:[UIColor clearColor] borderWidth:0.0f cornerRadius:8.0f];
        _progressBarFreeCoin.position                   = CGPointMake((_swypeItCoinsBackgroundNodeSize.width / 2.0f), -1.0f * (_swypeItCoinsBackgroundNodeSize.height / 2.0f) - (_swypeItCoinsLabelNode.fontSize / 2.0f) + VERTICAL_SPACING_4);
        [_swypeItCoinsBackgroundNode addChild:_progressBarFreeCoin];
    }
//    if (_progressBarFreeCoin) {
//        [_progressBarFreeCoin removeFromParent];
//        [_swypeItCoinsBackgroundNode addChild:_progressBarFreeCoin];
//        _progressBarFreeCoin.position               = CGPointMake((_swypeItCoinsBackgroundNodeSize.width / 2.0f), -1.0f * (_swypeItCoinsBackgroundNodeSize.height / 2.0f) - (_swypeItCoinsLabelNode.fontSize / 2.0f));
//    }

    _backgroundNode.size                                = CGSizeMake(_sceneSize.width, _sceneSize.height - _adContentNode.size.height);
    _backgroundNode.position                            = CGPointMake(0.0f, _adContentNode.size.height);
}



- (void)layoutZ {
    if (_popupContentNode) {
        [self presentModalNode:_popupContentNode
                     animation:HLScenePresentationAnimationFade
                  zPositionMin:[SIGameController floatZPositionGameForContent:SIZPositionGameModalMin]
                  zPositionMax:[SIGameController floatZPositionGameForContent:SIZPositionGameModalMax]];
    }
    
    if (_ringContentNode) {
        [self presentModalNode:_ringContentNode
                     animation:HLScenePresentationAnimationFade
                  zPositionMin:[SIGameController floatZPositionGameForContent:SIZPositionGameModalMin]
                  zPositionMax:[SIGameController floatZPositionGameForContent:SIZPositionGameModalMax]];
    }
    
    if (_overlayContentNode) {
        _overlayContentNode.zPosition                       = [SIGameController floatZPositionGameForContent:SIZPositionGameOverlayMin];
    }
    
    if (_scoreTotalLabel) {
        _scoreTotalLabel.zPosition                          = [SIGameController floatZPositionGameForContent:SIZPositionGameContent];
    }
    
    if (_progressBarFreeCoin) {
        _progressBarFreeCoin.zPosition                      = [SIGameController floatZPositionGameForContent:SIZPositionGameContent];
        _coinNode.zPosition                                 = [SIGameController floatZPositionGameForContent:SIZPositionGameContentMoveScore];
    }
    
    if (_progressBarMove) {
        _progressBarMove.zPosition                          = [SIGameController floatZPositionGameForContent:SIZPositionGameContent];
    }
    
    if (_progressBarPowerUp) {
        _progressBarPowerUp.zPosition                       = [SIGameController floatZPositionGameForContent:SIZPositionGameContent];
    }
}
- (void)update:(NSTimeInterval)currentTime {
    if ([_sceneDelegate respondsToSelector:@selector(controllerSceneGameWillUpdateProgressBars)]) {
        SISceneGameProgressBarUpdate *progressBarUpdate     = [_sceneDelegate controllerSceneGameWillUpdateProgressBars];
        if (progressBarUpdate.hasStarted) {
            if (_progressBarMove) {
                _progressBarMove.titleLabelNode.text        = progressBarUpdate.textMove;
                _progressBarMove.progress                   = progressBarUpdate.percentMove;
            }
            if (_progressBarPowerUp) {
                _progressBarPowerUp.progress                = progressBarUpdate.percentPowerUp;
            }
        } else {
            _progressBarMove.progress                       = 1.0f;
            _progressBarMove.titleLabelNode.text            = @"";
            _progressBarPowerUp.progress                    = 1.0f;
            
            
        }
    }
}

#pragma mark Physics
- (void)updatePhysicsEdges {
    if (_backgroundNode == nil) {
        return;
    }
    _edge.physicsBody                               = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(_sceneSize.width, _sceneSize.height - _adContentNode.size.height) center:CGPointMake(0.0f, 0.0f)];
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    SKPhysicsBody *notTheBottomEdge;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        notTheBottomEdge                        = contact.bodyA;
    } else {
        notTheBottomEdge                        = contact.bodyB;
    }
    
    if (notTheBottomEdge.categoryBitMask == SIGameSceneCategoryUIControl) {
        /*Remove the label*/
        SKNode *moveLabelNode = notTheBottomEdge.node;
        
        SKAction *fadeOut                       = [SKAction fadeOutWithDuration:0.3];
        SKAction *removeNode                    = [SKAction removeFromParent];
        
        SKAction *removeNodeSequence            = [SKAction sequence:@[fadeOut, removeNode]];
        
        [moveLabelNode runAction:removeNodeSequence];
    }
}

#pragma mark -
#pragma mark - Public Methods
/**
 Use this to launch the move score label
 */
- (void)sceneGameLaunchMoveCommandLabelWithCommandAction:(SIMoveCommandAction)commandAction {
    [_moveCommandLabel runAction:[SIGame actionForSIMoveCommandAction:commandAction]];
}

/**
 Called when the scene shall show a new high score
 */
- (void)sceneGameShowHighScore {
    if (_highScoreLabelNode.hidden) {
        _highScoreLabelNode.hidden  = NO;
        [_highScoreLabelNode runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction scaleTo:1.1 duration:0.5f],
                                                                                          [SKAction scaleTo:0.9 duration:0.5f]]]]];
    }
    
}

/**
 Called when the scene shall notify the user they got a free coin
 */
- (void)sceneGameShowFreeCoinEarned {
    SKSpriteNode *coinCpoy = [_coinNode copy];
    coinCpoy.zPosition = [SIGameController floatZPositionGameForContent:SIZPositionGameContentMoveScore];
//    SKAction *enlargeSize = [SKAction ]
}

/**
 Called to show an exploding move score
 */
- (void)sceneGameWillShowMoveScore:(SKLabelNode *)moveLabel {
    //Had to create a node for scaling the moveLabel
    SKSpriteNode *moveLabelNode = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(200.0f, 100.0f)];

    //    moveLabelNode.position                          = launchPoint; //CGPointMake(self.frame.size.width / 2.0f, (self.frame.size.height / 2.0f) - _moveCommandLabel.frame.size.height);
    moveLabelNode.physicsBody                       = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50.0f, 50.0f)];  //CGSizeMake(moveLabel.frame.size.width, moveLabel.frame.size.height)];
    moveLabelNode.physicsBody.categoryBitMask       = SIGameSceneCategoryUIControl;
    moveLabelNode.physicsBody.contactTestBitMask    = SIGameSceneCategoryEdge;
    moveLabelNode.physicsBody.collisionBitMask      = 0;
    moveLabelNode.physicsBody.linearDamping         = 0.0f;
    moveLabelNode.zPosition                         = [SIGameController floatZPositionGameForContent:SIZPositionGameContentMoveScore];
    moveLabelNode.userInteractionEnabled            = YES;
    
    SKAction *animateIn                             = [SKAction fadeInWithDuration:0.5];
    [moveLabelNode runAction:animateIn];
    
    // add the sprite node to the scene
    if (_backgroundNode == nil) {
        return;
    }
    [_backgroundNode addChild:moveLabelNode];
    
    SKAction *scale;
    if (IDIOM == IPAD) {
        scale                                       = [SKAction scaleBy:3.0 duration:1.0f];
    } else {
        scale                                       = [SKAction scaleBy:2.0 duration:1.0f];
    }
    
    [moveLabel runAction:scale];
    
    [moveLabelNode addChild:moveLabel];
    
    HLEmitterStore *emitterStore = [HLEmitterStore sharedStore];
    SKEmitterNode *sparkEmitter = [emitterStore emitterCopyForKey:kSIEmitterSpark];
    
    sparkEmitter.position                           = CGPointMake(0.0f, 0.0f);
    sparkEmitter.zPosition                          = [SIGameController floatZPositionGameForContent:SIZPositionGameContentMoveScoreEmitter];
    [moveLabelNode addChild:sparkEmitter];
    
    CGFloat randomDx                                = arc4random_uniform(LAUNCH_DX_VECTOR_MAX);
    while (randomDx < LAUNCH_DX_VECTOR_MIX) {
        randomDx                                    = arc4random_uniform(LAUNCH_DX_VECTOR_MAX);
    }
    int randomDirection                             = arc4random_uniform(2);
    if (randomDirection == 1) { /*Negative Direction*/
        randomDx                                    = -1.0f * randomDx;
    }
    
    CGFloat randomDy                                = (arc4random_uniform(8)/10 + 0.1) * LAUNCH_DY_MULTIPLIER;
    
    //    NSLog(@"Vector... dX = %0.2f | Y = %0.2f",randomDx,randomDy);
    CGVector moveScoreVector                        = CGVectorMake(randomDx, randomDy);
    [moveLabelNode.physicsBody applyImpulse:moveScoreVector];
    
}


#pragma mark -
#pragma mark - Touch Methods
- (void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    CGPoint touchPoint                              = [[touches anyObject] locationInNode:self.scene];
//    SKNode *node        = [self nodeAtPoint:touchPoint];
    
    HLEmitterStore *emitterStore                    = [HLEmitterStore sharedStore];
    SKEmitterNode *explosionEmitter                 = [emitterStore emitterCopyForKey:kSIEmitterExplosionTouch];
    
    explosionEmitter.position                       = touchPoint;
    
    
    explosionEmitter.zPosition                      = [SIGameController floatZPositionGameForContent:SIZPositionGameContentMoveScoreEmitter];
    
    if (explosionEmitter) {
        [self addChild:explosionEmitter];
    }
    
}

#pragma mark -
#pragma mark - Delegate Methods
#pragma mark SIGameNode
- (void)gestureEnded:(SIMove *)move {
    if ([_sceneDelegate respondsToSelector:@selector(sceneGameDidRecieveMove:)]) {
        [_sceneDelegate sceneGameDidRecieveMove:move];
    }
}


@end