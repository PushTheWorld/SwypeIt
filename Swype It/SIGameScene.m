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



@implementation SIGameScene {
    CGFloat                                              _moveScoreDuration;

    CGSize                                               _backgroundSize;
    CGSize                                               _coinSize;
    CGSize                                               _swypeItCoinsBackgroundNodeSize;
    CGSize                                               _pauseButtonSize;
    CGSize                                               _sceneSize;
    CGSize                                               _moveCommandLabelSize;
    
    HLLabelButtonNode                                   *_pauseButtonNode;
    
    HLRingNode                                          *_ringContentNode;
    
    HLToolbarNode                                       *_powerUpToolbarContentNode;
    
    SIAdBannerNode                                      *_adContentNode;
    
    SIPopupNode                                         *_centerNode;
    
    SKAction                                            *_actionOldMoveScore;
    SKAction                                            *_actionNewMoveScore;
    
    SKLabelNode                                         *_highScoreLabelNode;
    SKLabelNode                                         *_swypeItCoinsLabelNode;

    SKNode                                              *_edge;
    
    SKSpriteNode                                        *_backgroundNode;
    SKSpriteNode                                        *_coinNode;
    SKSpriteNode                                        *_overlayContentNode;
    SKSpriteNode                                        *_swypeItCoinsBackgroundNode;
    
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
        _animationDuration                              = 0.25f;
        _blurScreenDuration                             = 0.25f;
        _moveCommandRandomLocation                      = NO;
        _scoreTotalLabelTopPadding                      = VERTICAL_SPACING_16;
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
    self.gestureTargetHitTestMode                       = HLSceneGestureTargetHitTestModeZPositionThenParent;
    
    [self needSharedGestureRecognizers:@[[SIGameController SIGesturePinch],
                                         [SIGameController SIGestureTap],
                                         [SIGameController SIGestureSwypeDown],
                                         [SIGameController SIGestureSwypeLeft],
                                         [SIGameController SIGestureSwypeRight],
                                         [SIGameController SIGestureSwypeUp]]];
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
    _backgroundSize                                         = size;
    _pauseButtonSize                                        = CGSizeMake(size.width / 8.0f, size.width / 8.0f);
    
    _moveScoreDuration                                      = 1.0f;
//    SKAction *grow                                          = [SKAction scaleTo:2.0f duration:_moveScoreDuration / 2.0f];
    SKAction *shrink                                        = [SKAction scaleTo:0.0f duration:_moveScoreDuration];
    _actionOldMoveScore                                     = [SKAction sequence:@[shrink]];
    
    SKAction *instaShrink                                   = [SKAction scaleTo:0.0f duration:0.0f];
    SKAction *growIn                                        = [SKAction scaleTo:1.0f duration:_moveScoreDuration / 4.0f];
    _actionNewMoveScore                                     = [SKAction sequence:@[instaShrink, growIn]];
        
}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    
    /*Create Background Node*/
    _backgroundNode                                         = [SKSpriteNode spriteNodeWithColor:[SKColor SIBackgroundColorLevel1A] size:_sceneSize];  // [[SIGameNode alloc] initWithSize:_sceneSize gameMode:SIGameModeTwoHand];

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

    _pauseButtonNode                                        = [[HLLabelButtonNode alloc] initWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonPause]];
    
    _highScoreLabelNode                                     = [SIGameController SILabelParagraph_x2:@"HIGH SCORE!"];
    
    _scoreTotalLabel                                        = [SIGameController SILabelHeader_x3:@"0.00"];
    
    _scoreMoveLabel                                         = [SIGameController SILabelSceneGameMoveScoreLabel];
}

- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    
    _backgroundNode.anchorPoint                             = CGPointMake(0.0f, 0.0f);
    _backgroundNode.zPosition                               = [SIGameController floatZPositionGameForContent:SIZPositionGameBackground];
    _backgroundNode.userInteractionEnabled                  = YES;
    
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
    
    _highScoreLabelNode.zPosition                           = [SIGameController floatZPositionGameForContent:SIZPositionGameContent];
    _highScoreLabelNode.physicsBody.categoryBitMask         = SIGameSceneCategoryUIControl;
    _highScoreLabelNode.horizontalAlignmentMode             = SKLabelHorizontalAlignmentModeCenter;
    _highScoreLabelNode.verticalAlignmentMode               = SKLabelVerticalAlignmentModeCenter;
    _highScoreLabelNode.hidden                              = YES;
    
    _scoreTotalLabel.zPosition                              = [SIGameController floatZPositionGameForContent:SIZPositionGameContent];
    _scoreTotalLabel.physicsBody.categoryBitMask            = SIGameSceneCategoryUIControl;
    _scoreTotalLabel.horizontalAlignmentMode                = SKLabelHorizontalAlignmentModeCenter;
    _scoreTotalLabel.verticalAlignmentMode                  = SKLabelVerticalAlignmentModeTop;
    
    _scoreMoveLabel.zPosition                               = [SIGameController floatZPositionGameForContent:SIZPositionGameContent];
    _scoreMoveLabel.physicsBody.categoryBitMask             = SIGameSceneCategoryUIControl;
    _scoreMoveLabel.horizontalAlignmentMode                 = SKLabelHorizontalAlignmentModeCenter;
    _scoreMoveLabel.verticalAlignmentMode                   = SKLabelVerticalAlignmentModeCenter;
    _scoreMoveLabel.text                                    = [NSString stringWithFormat:@"%0.2f",MAX_MOVE_SCORE];
    
}

- (void)layoutControlsWithSize:(CGSize)size {
    /**Layout those controls*/
    _backgroundNode.position                                = CGPointMake(0.0f, 0.0f);
    [self addChild:_backgroundNode];
    
    [self addChild:_edge];
    
    [self addChild:_pauseButtonNode];
    
    [self addChild:_highScoreLabelNode];
    
    [self addChild:_scoreTotalLabel];
    
    [self addChild:_scoreMoveLabel];

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
    if (_centerNode) {
        return _centerNode;
    } else {
        return nil;
    }
}
/**
 A popup node to be displayed modally
 */
- (void)setPopupNode:(SIPopupNode *)popupNode {
    if (_centerNode) {
        if ([self modalNodePresented]) {
            [self dismissModalNodeAnimation:HLScenePresentationAnimationFade];
        }
        [_centerNode removeFromParent];
    }
    if (popupNode) {
        _centerNode                                   = popupNode;
        [self addChild:_centerNode];
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

- (void)setProgressBarPowerUp:(TCProgressBarNode *)progressBarPowerUp {
    if (_progressBarPowerUp) {
        [_progressBarPowerUp removeFromParent];
    }
    if (progressBarPowerUp) {
        _progressBarPowerUp = progressBarPowerUp;
//        _progressBarPowerUp.userInteractionEnabled = YES;
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
//- (void)setScoreTotalLabel:(SKLabelNode *)scoreTotalLabel {
//    if (_scoreTotalLabel) {
//        [_scoreTotalLabel removeFromParent];
//    }
//    if (scoreTotalLabel) {
//        _scoreTotalLabel                             = scoreTotalLabel;
//        _scoreTotalLabel.physicsBody.categoryBitMask = SIGameSceneCategoryUIControl;
//        [self addChild:_scoreTotalLabel];
//    }
//    [self layoutXYAnimation:SISceneContentAnimationNone];
//}

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
- (UIColor *)backgroundColor {
    return _backgroundNode.color;
}
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundNode.color   = backgroundColor;
}
- (void)setScoreMoveLabel:(SKLabelNode *)scoreMoveLabel {
    SKLabelNode *labelHolder = _scoreMoveLabel;
    _scoreMoveLabel                                     = scoreMoveLabel;
    _scoreMoveLabel.zPosition                           = [SIGameController floatZPositionGameForContent:SIZPositionGameContent];
    _scoreMoveLabel.position                            = labelHolder.position;
    [self addChild:_scoreMoveLabel];
    [_scoreMoveLabel runAction:_actionNewMoveScore];
    
    CGMutablePathRef cgpath                             = CGPathCreateMutable();
    
    CGPoint startingPoint                               = labelHolder.position;
    
    CGPoint endingPoint                                 = _scoreTotalLabel.position;
    
    CGFloat randomDx                                    = arc4random_uniform(_sceneSize.width / 4.0f);
    
    int randomDirection                                 = arc4random_uniform(2);
    if (randomDirection == 1) { /*Negative Direction*/
        randomDx                                        = -1.0f * randomDx;
    }
    CGFloat totalDistance                               = (endingPoint.y - startingPoint.y) / 3.0f;
    CGPoint controlPoint1                               = CGPointMake((_sceneSize.width / 2.0f) + randomDx, startingPoint.y + totalDistance);
    CGPoint controlPoint2                               = CGPointMake((_sceneSize.width / 2.0f) + (randomDx / 2), startingPoint.y + (totalDistance * 2.0f));
    
    CGPathMoveToPoint(cgpath, NULL, startingPoint.x, startingPoint.y);
    CGPathAddCurveToPoint(cgpath, NULL, controlPoint1.x, controlPoint1.y,
                          controlPoint2.x, controlPoint2.y,
                          endingPoint.x, endingPoint.y);
    
    SKAction *scoreCurve                                = [SKAction followPath:cgpath asOffset:NO orientToPath:NO duration:_moveScoreDuration];
    
    SKAction *groupAction                               = [SKAction group:@[scoreCurve, [SKAction scaleTo:0.0f duration:_moveScoreDuration]]];
    
    labelHolder.zPosition                               = [SIGameController floatZPositionGameForContent:SIZPositionGameContentMoveScore];
    [labelHolder runAction:[SKAction sequence:@[groupAction,[SKAction removeFromParent],[SKAction runBlock:^{
        HLEmitterStore *emitterStore                    = [HLEmitterStore sharedStore];
        SKEmitterNode *sparkEmitter                     = [emitterStore emitterCopyForKey:kSIEmitterSpark];
        
        NSLog(@"Height of total score label: %0.2f",_scoreTotalLabel.frame.size.height);
        
        sparkEmitter.position                           = CGPointMake(0.0f, -1.0f * (_scoreTotalLabel.frame.size.height / 2.0f));
        sparkEmitter.zPosition                          = [SIGameController floatZPositionGameForContent:SIZPositionGameContentMoveScoreEmitter];
        [_scoreTotalLabel addChild:sparkEmitter];
                
    }]]]];
    
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
        positionVisible     = CGPointMake(sceneMidX, _sceneSize.height - _scoreTotalLabelTopPadding);
        [SIGameController SIControllerNode:_scoreTotalLabel
                                 animation:animation
                            animationStyle:SISceneContentAnimationStyleSlide
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    if (_progressBarPowerUp) {
        positionHidden      = CGPointMake(sceneMidX,sceneMidY + (-1.0f * ((_progressBarPowerUp.size.height / 2.0f) + (_moveCommandLabelSize.height / 2.0f) + VERTICAL_SPACING_8)));
        positionVisible     = positionHidden;
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
        [SIGameController SIControllerNode:_moveCommandLabel
                                 animation:animation
                            animationStyle:SISceneContentAnimationStyleGrow
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }

    
    if (_scoreMoveLabel) {
        _scoreMoveLabel.userInteractionEnabled  = YES;
        positionHidden      = CGPointMake(sceneMidX, sceneMidY + ([SIGameController SIFontSizeMoveCommand] / 2.0f) + VERTICAL_SPACING_8 + ([SIGameController SIFontSizeMoveScore] / 2.0f));
        positionVisible     = positionHidden;
        [SIGameController SIControllerNode:_scoreMoveLabel
                                 animation:animation
                            animationStyle:SISceneContentAnimationStyleGrow
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

    _backgroundNode.size                                = CGSizeMake(_sceneSize.width, _sceneSize.height - _adContentNode.size.height);
    _backgroundNode.position                            = CGPointMake(0.0f, _adContentNode.size.height);
}



- (void)layoutZ {
    if (_centerNode) {
        [self presentModalNode:_centerNode
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
    
    if (_scoreMoveLabel) {
        _scoreMoveLabel.zPosition                           = [SIGameController floatZPositionGameForContent:SIZPositionGameContent];
    }
    
    if (_progressBarPowerUp) {
        _progressBarPowerUp.zPosition                       = [SIGameController floatZPositionGameForContent:SIZPositionGameContent];
    }
}
- (void)update:(NSTimeInterval)currentTime {
    if ([_sceneDelegate respondsToSelector:@selector(sceneGameWillUpdateProgressBars)]) {
        SISceneGameProgressBarUpdate *progressBarUpdate     = [_sceneDelegate sceneGameWillUpdateProgressBars];
        if (progressBarUpdate.hasStarted) {
            if (_scoreMoveLabel) {
                _scoreMoveLabel.text                        = [NSString stringWithFormat:@"%0.2f",progressBarUpdate.percentMove * MAX_MOVE_SCORE];
            }
            if (_progressBarPowerUp) {
                _progressBarPowerUp.progress                = progressBarUpdate.percentPowerUp;
                NSLog(@"Power up percent: %0.2f", progressBarUpdate.percentPowerUp);
            }
        } else {
            _scoreMoveLabel.text                            = @"";
            _progressBarPowerUp.progress                    = 1.0f;
            
        }
    }
    
//    if ([self modalNodePresented]) {
//        if (_popupNode && _popupNode.parent && [_popupNode.topNode isKindOfClass:[SKLabelNode class]]) {
//            if (_popupNode.countDownTimerState == SIPopupCountDownTimerNotStarted) {
//                _popupNode.startTime = currentTime;
//                _popupNode.countDownTimerState = SIPopupCountDownTimerRunning;
//            } else if (_popupNode.countDownTimerState == SIPopupCountDownTimerRunning) {
//                NSTimeInterval remainingTime = 11.0f - (currentTime - _popupNode.startTime);
//                ((SKLabelNode *)_popupNode.topNode).text = [NSString stringWithFormat:@"%i",(int)remainingTime];
//                [_popupNode.topNode runAction:[SKAction scaleTo:remainingTime - floorf(remainingTime) duration:0.0f]];
//                if (remainingTime < (EPSILON_NUMBER + 1.0f)) {
//                    //Call to go to end game
//                    [self makePopupBigger];
//                    
//                }
//            }
//        }
//    }
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
    _moveCommandLabel.physicsBody.categoryBitMask = SIGameSceneCategoryUIControl;
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
//- (void)sceneGameWillShowMoveScore:(SKLabelNode *)moveLabel {
//    [moveLabel runAction:[SKAction scaleTo:1.0f duration:0.0f]];
////    moveLabel.position = CGPointMake(0.0f, 0.0f);
//    //Had to create a node for scaling the moveLabel
//    SKSpriteNode *moveLabelNode = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(200.0f, 100.0f)];
//
//    //    moveLabelNode.position                          = launchPoint; //CGPointMake(self.frame.size.width / 2.0f, (self.frame.size.height / 2.0f) - _moveCommandLabel.frame.size.height);
//    moveLabelNode.physicsBody                       = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50.0f, 50.0f)];  //CGSizeMake(moveLabel.frame.size.width, moveLabel.frame.size.height)];
//    moveLabelNode.physicsBody.categoryBitMask       = SIGameSceneCategoryUIControl;
//    moveLabelNode.physicsBody.contactTestBitMask    = SIGameSceneCategoryEdge;
//    moveLabelNode.physicsBody.collisionBitMask      = 0;
//    moveLabelNode.physicsBody.linearDamping         = 0.0f;
//    moveLabelNode.zPosition                         = [SIGameController floatZPositionGameForContent:SIZPositionGameContentMoveScore];
//    moveLabelNode.userInteractionEnabled            = YES;
//    
//    if (_progressBarMove) {
//        moveLabelNode.position                      = _progressBarMove.position;
//    } else {
//        moveLabelNode.position                      = CGPointMake(_sceneSize.width / 2.0f, _sceneSize.height / 2.0f);
//    }
//    
//    SKAction *animateIn                             = [SKAction fadeInWithDuration:0.5];
//    [moveLabelNode runAction:animateIn];
//    
//    // add the sprite node to the scene
//    if (_backgroundNode == nil) {
//        return;
//    }
//    [_backgroundNode addChild:moveLabelNode];
//    
//    SKAction *scale;
//    if (IDIOM == IPAD) {
//        scale                                       = [SKAction scaleBy:3.0 duration:1.0f];
//    } else {
//        scale                                       = [SKAction scaleBy:2.0 duration:1.0f];
//    }
//    
//    [moveLabel runAction:scale];
//    
//    [moveLabelNode addChild:moveLabel];
//    
//    HLEmitterStore *emitterStore = [HLEmitterStore sharedStore];
//    SKEmitterNode *sparkEmitter = [emitterStore emitterCopyForKey:kSIEmitterSpark];
//    
//    sparkEmitter.position                           = CGPointMake(0.0f, 0.0f);
//    sparkEmitter.zPosition                          = [SIGameController floatZPositionGameForContent:SIZPositionGameContentMoveScoreEmitter];
//    [moveLabelNode addChild:sparkEmitter];
//    
//    CGFloat randomDx                                = arc4random_uniform(LAUNCH_DX_VECTOR_MAX);
//    while (randomDx < LAUNCH_DX_VECTOR_MIX) {
//        randomDx                                    = arc4random_uniform(LAUNCH_DX_VECTOR_MAX);
//    }
//    int randomDirection                             = arc4random_uniform(2);
//    if (randomDirection == 1) { /*Negative Direction*/
//        randomDx                                    = -1.0f * randomDx;
//    }
//    
//    CGFloat randomDy                                = (arc4random_uniform(8)/10 + 0.1) * LAUNCH_DY_MULTIPLIER;
//    
//    //    NSLog(@"Vector... dX = %0.2f | Y = %0.2f",randomDx,randomDy);
//    CGVector moveScoreVector                        = CGVectorMake(randomDx, randomDy);
//    [moveLabelNode.physicsBody applyImpulse:moveScoreVector];
//    
//}


#pragma mark -
#pragma mark - Touch Methods
//- (void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
//    CGPoint touchPoint                              = [[touches anyObject] locationInNode:self.scene];
////    SKNode *node        = [self nodeAtPoint:touchPoint];
//    
//    HLEmitterStore *emitterStore                    = [HLEmitterStore sharedStore];
//    SKEmitterNode *explosionEmitter                 = [emitterStore emitterCopyForKey:kSIEmitterExplosionTouch];
//    
//    explosionEmitter.position                       = touchPoint;
//    
//    
//    explosionEmitter.zPosition                      = [SIGameController floatZPositionGameForContent:SIZPositionGameContentMoveScoreEmitter];
//    
//    if (explosionEmitter) {
//        [self addChild:explosionEmitter];
//    }
//    
//}

- (void)handleGamePinch:(UIPinchGestureRecognizer *)gestureRecognizer {
    float pinchDirection = 0.0f;
    if (!_backgroundNode) {
        return;
    }
    if (gestureRecognizer.state != UIGestureRecognizerStateRecognized) {
        if ([gestureRecognizer numberOfTouches] > 1) {
            CGPoint firstPoint      = [gestureRecognizer locationOfTouch:0 inView:gestureRecognizer.view];
            CGPoint secondPoint     = [gestureRecognizer locationOfTouch:1 inView:gestureRecognizer.view];
            pinchDirection    = atan2(secondPoint.y - firstPoint.y, secondPoint.x - firstPoint.x);
            
            //            NSLog(@"Angle of pinch: %0.2f",_pinchDirection);
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (pinchDirection < 0.0f) {
            [self makeAndSendMove:SIMoveCommandPinch moveCommandAction:SIMoveCommandActionPinchNegative gestureRecognizer:gestureRecognizer];
        } else {
            [self makeAndSendMove:SIMoveCommandPinch moveCommandAction:SIMoveCommandActionPinchPositive gestureRecognizer:gestureRecognizer];
        }
    }
}

- (void)handleGameSwypeUp:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (!_backgroundNode) {
        return;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self makeAndSendMove:SIMoveCommandSwype moveCommandAction:SIMoveCommandActionSwypeUp gestureRecognizer:gestureRecognizer];
    }
}

- (void)handleGameSwypeDown:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (!_backgroundNode) {
        return;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self makeAndSendMove:SIMoveCommandSwype moveCommandAction:SIMoveCommandActionSwypeDown gestureRecognizer:gestureRecognizer];
    }
}

- (void)handleGameSwypeLeft:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (!_backgroundNode) {
        return;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self makeAndSendMove:SIMoveCommandSwype moveCommandAction:SIMoveCommandActionSwypeLeft gestureRecognizer:gestureRecognizer];
    }
}

- (void)handleGameSwypeRight:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (!_backgroundNode) {
        return;
    }
    [self makeAndSendMove:SIMoveCommandSwype moveCommandAction:SIMoveCommandActionSwypeRight gestureRecognizer:gestureRecognizer];
//
//    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        [self makeAndSendMove:SIMoveCommandSwype moveCommandAction:SIMoveCommandActionSwypeRight gestureRecognizer:gestureRecognizer];
//    }
}

- (void)handleGameTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (!_backgroundNode) {
        return;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self makeAndSendMove:SIMoveCommandTap moveCommandAction:SIMoveCommandActionTap gestureRecognizer:gestureRecognizer];
    }
}
- (void)makeAndSendMove:(SIMoveCommand)moveCommand moveCommandAction:(SIMoveCommandAction)moveCommandAction gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    SIMove *move            = [[SIMove alloc] init];
    move.moveCommand        = moveCommand;
    move.moveCommandAction  = moveCommandAction;
    move.gestureRecognizer  = gestureRecognizer;
    
    if ([_sceneDelegate respondsToSelector:@selector(sceneGameDidRecieveMove:)]) {
        [_sceneDelegate sceneGameDidRecieveMove:move];
    }
}

- (void)handlePowerUpToolBarTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"Toolbar tapped");
    CGPoint viewLocation = [gestureRecognizer locationInView:self.view];
    CGPoint sceneLocation = [self convertPointFromView:viewLocation];
    CGPoint toolbarLocation = [_powerUpToolbarContentNode convertPoint:sceneLocation fromNode:self];
    NSString *toolTag = [_powerUpToolbarContentNode toolAtLocation:toolbarLocation];
    if (!toolTag) {
        return;
    }
    
    if ([_sceneDelegate respondsToSelector:@selector(controllerSceneGamePowerUpToolbarTappedWithToolTag:)]) {
        [_sceneDelegate controllerSceneGamePowerUpToolbarTappedWithToolTag:toolTag];
    }

}

- (void)handlePauseButtonTap:(UITapGestureRecognizer *)gestureRecognizer {
    NSLog(@"Pause Button Tapped");
    if ([_sceneDelegate respondsToSelector:@selector(controllerSceneGamePauseButtonTapped)]) {
        [_sceneDelegate controllerSceneGamePauseButtonTapped];
    }
}

#pragma mark -
#pragma mark - Delegate Methods
#pragma mark UIGestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint viewLocation = [touch locationInView:self.view];
    CGPoint sceneLocation = [self convertPointFromView:viewLocation];
    
    if ([self modalNodePresented]) {
        return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
    }
    
    if (_ringContentNode && _ringContentNode.parent && [_ringContentNode containsPoint:sceneLocation]) {
        return NO;
    }
    
    if (_centerNode && _centerNode.parent && [_centerNode containsPoint:sceneLocation]) {
        return NO;
    }
    
    // Power Up Toolbar Node
    if (_powerUpToolbarContentNode && _powerUpToolbarContentNode.parent && [_powerUpToolbarContentNode containsPoint:sceneLocation]) {
        if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [gestureRecognizer removeTarget:nil action:NULL];
            [gestureRecognizer addTarget:self action:@selector(handlePowerUpToolBarTap:)];
            return YES;
        }
        return NO;
    }
    
    // Pause Button
    if (_pauseButtonNode && _pauseButtonNode.parent && [_pauseButtonNode containsPoint:sceneLocation]) {
        if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [gestureRecognizer removeTarget:nil action:NULL];
            [gestureRecognizer addTarget:self action:@selector(handlePauseButtonTap:)];
            return YES;
        }
        return NO;
    }
    
    // World Info
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        NSUInteger numberOfTapsRequired = [(UITapGestureRecognizer *)gestureRecognizer numberOfTapsRequired];
        if (numberOfTapsRequired == 1) {
            [gestureRecognizer removeTarget:nil action:NULL];
            [gestureRecognizer addTarget:self action:@selector(handleGameTap:)];
            return YES;
        }
    } else if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        [gestureRecognizer removeTarget:nil action:NULL];
        [gestureRecognizer addTarget:self action:@selector(handleGamePinch:)];
        return YES;
    } else if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        UISwipeGestureRecognizerDirection swipeDirection = [(UISwipeGestureRecognizer *)gestureRecognizer direction];
        switch (swipeDirection) {
            case UISwipeGestureRecognizerDirectionDown:
                [gestureRecognizer removeTarget:nil action:NULL];
                [gestureRecognizer addTarget:self action:@selector(handleGameSwypeDown:)];
                return YES;
            case UISwipeGestureRecognizerDirectionLeft:
                [gestureRecognizer removeTarget:nil action:NULL];
                [gestureRecognizer addTarget:self action:@selector(handleGameSwypeLeft:)];
                return YES;
            case UISwipeGestureRecognizerDirectionRight:
                [gestureRecognizer removeTarget:nil action:NULL];
                [gestureRecognizer addTarget:self action:@selector(handleGameSwypeRight:)];
                return YES;
            case UISwipeGestureRecognizerDirectionUp:
                [gestureRecognizer removeTarget:nil action:NULL];
                [gestureRecognizer addTarget:self action:@selector(handleGameSwypeUp:)];
                return YES;
            default:
                return NO;
        }
    }
    
    
    return NO;
}





@end