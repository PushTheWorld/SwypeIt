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
    
    BMGlyphLabel                                        *_moveCommandContentLabel;
    BMGlyphLabel                                        *_scoreTotalContentLabel;
    BMGlyphLabel                                        *_swypeItCoinsLabelNode;
    
    CGSize                                               _coinSize;
    CGSize                                               _pauseButtonSize;
    CGSize                                               _sceneSize;
    
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
    
    TCProgressBarNode                                   *_progressBarFreeCoinContent;
    TCProgressBarNode                                   *_progressBarMoveContent;
    TCProgressBarNode                                   *_progressBarPowerUpContent;
}

#pragma mark -
#pragma mark - Scene Life Cycle

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
    _coinSize                                               = CGSizeMake(size.width / 7.0f, size.width / 7.0f);
    _sceneSize                                              = size;
    _pauseButtonSize                                        = CGSizeMake(size.width / 8.0f, size.width / 8.0f);
        
}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    
    /*Create Background Node*/
    _backgroundNode                                         = [[SIGameNode alloc] initWithSize:_sceneSize gameMode:SIGameModeTwoHand];

    _edge                                                   = [SKNode node];
    
    _coinNode                                               = [SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageCoinSmallFront] size:_coinSize];

    _pauseButtonNode                                        = [[HLLabelButtonNode alloc] initWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonPause]];
    
    _swypeItCoinsLabelNode                                  = [SIGameController BMGLabelLongIslandStroked];

    _highScoreLabelNode                                     = [SIGameController SILabelParagraph_x2:@"HIGH SCORE!"];
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    _backgroundNode.anchorPoint                             = CGPointMake(0.0f, 0.0f);
//    _backgroundNode.physicsBody.categoryBitMask                 = SIFallingMonkeySceneCategoryUIControl;
    _backgroundNode.zPosition                               = [SIGameController floatZPositionGameForContent:SIZPositionGameBackground];
    _backgroundNode.backgroundColor                         = [SKColor backgroundColorForLevelOneA];
    _backgroundNode.delegate                                = self;
    [_backgroundNode hlSetGestureTarget:_backgroundNode];
    
    _edge.physicsBody.categoryBitMask                       = SIGameSceneCategoryEdge;
    _edge.physicsBody.collisionBitMask                      = SIGameSceneCategoryZero;
    
    _coinNode.anchorPoint                                   = CGPointMake(0.5f, 0.5f);
    _coinNode.physicsBody.categoryBitMask                   = SIGameSceneCategoryUIControl;
    
    _pauseButtonNode.name                                   = kSINodeButtonPause;
    _pauseButtonNode.size                                   = _pauseButtonSize;
    _pauseButtonNode.physicsBody.categoryBitMask            = SIGameSceneCategoryUIControl;
    _pauseButtonNode.userInteractionEnabled                 = YES;
    _pauseButtonNode.zPosition                              = [SIGameController floatZPositionGameForContent:SIZPositionGameContent];
    
    _swypeItCoinsLabelNode.zPosition                        = [SIGameController floatZPositionGameForContent:SIZPositionGameContent];
    _swypeItCoinsLabelNode.physicsBody.categoryBitMask      = SIGameSceneCategoryUIControl;
    _swypeItCoinsLabelNode.horizontalAlignment              = BMGlyphHorizontalAlignmentLeft;
    _swypeItCoinsLabelNode.verticalAlignment                = BMGlyphVerticalAlignmentMiddle;
    
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
    [self layoutXYAnimation:SIGameSceneContentAnimationNone];
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
    [self layoutXYZAnimation:SIGameSceneContentAnimationNone];
}

/**
 This will intercept the and override the command going to self
 and will allow us to actually change the color of the background node
 */


- (void)setMoveCommandLabel:(BMGlyphLabel *)moveCommandLabel {
    if (_moveCommandContentLabel) {
        [_moveCommandContentLabel removeFromParent];
    }
    if (moveCommandLabel) {
        SKAction *fadeActionSequenceForNewLabel         = [SKAction sequence:@[[SKAction fadeOutWithDuration:0.0f],
                                                                               [SKAction fadeInWithDuration:MOVE_COMMAND_LAUNCH_DURATION]]];
        [_moveCommandContentLabel runAction:fadeActionSequenceForNewLabel];
        _moveCommandContentLabel                            = moveCommandLabel;
        _moveCommandContentLabel.verticalAlignment          = BMGlyphVerticalAlignmentTop;
        _moveCommandContentLabel.horizontalAlignment        = BMGlyphHorizontalAlignmentLeft;
        [self addChild:_moveCommandContentLabel];
    }
    [self layoutXYZAnimation:SIGameSceneContentAnimationNone];
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
    [self layoutXYZAnimation:SIGameSceneContentAnimationNone];
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
    [self layoutXYZAnimation:SIGameSceneContentAnimationNone];
}

- (TCProgressBarNode *)progressBarFreeCoin {
    return _progressBarFreeCoinContent;
}

- (void)setProgressBarFreeCoin:(TCProgressBarNode *)progressBarFreeCoin {
    if (_progressBarFreeCoinContent) {
        [_progressBarFreeCoinContent removeFromParent];
    }
    if (progressBarFreeCoin) {
        _progressBarFreeCoinContent                             = progressBarFreeCoin;
        _progressBarFreeCoinContent.zRotation                   = M_PI_2;
        _progressBarFreeCoinContent.physicsBody.categoryBitMask = SIGameSceneCategoryUIControl;
        [self addChild:_progressBarFreeCoinContent];
        _coinNode.position                                      = CGPointMake(-1.0f * (_progressBarFreeCoinContent.size.width / 2.0f), 0.0f);
        _coinNode.zRotation                                     = M_PI + M_PI_2;
        [_progressBarFreeCoinContent addChild:_coinNode];
        [_progressBarFreeCoinContent addChild:_swypeItCoinsLabelNode];
        NSLog(@"\n\nHeight of coins label: %0.2f\n\n",_swypeItCoinsLabelNode.totalSize.height);
        _swypeItCoinsLabelNode.position                         = CGPointMake(-1.0f * ((_progressBarFreeCoinContent.size.width / 2.0f) + (_coinSize.width / 2.0f) + (_swypeItCoinsLabelNode.totalSize.height / 2.0f)+ VERTICAL_SPACING_4), _progressBarFreeCoinContent.size.height / 2.0f);
        _swypeItCoinsLabelNode.zRotation                        = M_PI + M_PI_2;
        _swypeItCoinsLabelNode.physicsBody.categoryBitMask      = SIGameSceneCategoryUIControl;
    }
    [self layoutXYZAnimation:SIGameSceneContentAnimationNone];
}

- (TCProgressBarNode *)progressBarMove {
    return _progressBarMoveContent;
}

- (void)setProgressBarMove:(TCProgressBarNode *)progressBarMove {
    if (_progressBarMoveContent) {
        [_progressBarMoveContent removeFromParent];
    }
    if (progressBarMove) {
        _progressBarMoveContent                                 = progressBarMove;
        _progressBarMoveContent.physicsBody.categoryBitMask     = SIGameSceneCategoryUIControl;
        [self addChild:_progressBarMoveContent];
    }
    [self layoutXYZAnimation:SIGameSceneContentAnimationNone];
}

- (TCProgressBarNode *)progressBarPowerUp {
    return _progressBarPowerUpContent;
}

- (void)setProgressBarPowerUp:(TCProgressBarNode *)progressBarPowerUp {
    if (_progressBarPowerUpContent) {
        [_progressBarPowerUpContent removeFromParent];
    }
    if (progressBarPowerUp) {
        _progressBarPowerUpContent                              = progressBarPowerUp;
        _progressBarPowerUpContent.physicsBody.categoryBitMask  = SIGameSceneCategoryUIControl;
        [self addChild:_progressBarPowerUpContent];
    }
    [self layoutXYZAnimation:SIGameSceneContentAnimationNone];
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
    [self layoutXYZAnimation:SIGameSceneContentAnimationNone];
}

/**
 The label for the total score
 */
- (void)setScoreTotalLabel:(BMGlyphLabel *)scoreTotalLabel {
    if (_scoreTotalContentLabel) {
        [_scoreTotalContentLabel removeFromParent];
    }
    if (scoreTotalLabel) {
        _scoreTotalContentLabel                             = scoreTotalLabel;
        _scoreTotalContentLabel.physicsBody.categoryBitMask = SIGameSceneCategoryUIControl;
        [self addChild:_scoreTotalContentLabel];
    }
    [self layoutXYAnimation:SIGameSceneContentAnimationNone];
}

/**
 The padding of the top label
 */
- (void)setScoreTotalLabelTopPadding:(CGFloat)scoreTotalLabelTopPadding {
    [self layoutXYAnimation:SIGameSceneContentAnimationNone];
}

- (void)setMoveCommandText:(NSString *)moveCommandText {
    if (_moveCommandLabel) {
        
    }
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
    [self layoutXYZAnimation:SIGameSceneContentAnimationNone];
    [self updatePhysicsEdges];
}
- (void)layoutXYZAnimation:(SIGameSceneContentAnimation)animation {
    [self layoutXYAnimation:animation];
    [self layoutZ];
}

- (void)layoutXYAnimation:(SIGameSceneContentAnimation)animation {
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
    
    if (_scoreTotalContentLabel) {
        positionHidden      = CGPointMake(sceneMidX, _sceneSize.height + _scoreTotalContentLabel.frame.size.height + VERTICAL_SPACING_4);
        positionVisible     = CGPointMake(_sceneSize.width / 2.0f, _sceneSize.height - _scoreTotalLabelTopPadding);
        [SIGameController SIControllerNode:_scoreTotalContentLabel
                                 animation:SISceneContentAnimationIn
                            animationStyle:SISceneContentAnimationStyleSlide
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    if (_moveCommandContentLabel) {
        CGFloat progressBarYOffset                  = _scoreTotalContentLabel.frame.origin.y + (_scoreTotalContentLabel.frame.size.height / 2.0f) + VERTICAL_SPACING_8;
        _progressBarPowerUpContent.position = CGPointMake(_sceneSize.width / 2.0f, progressBarYOffset + (_progressBarMoveContent.size.height / 2.0f));
        [SIGameController SIControllerNode:_moveCommandContentLabel
                                 animation:SISceneContentAnimationIn
                            animationStyle:SISceneContentAnimationStyleGrow
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    if (_progressBarFreeCoinContent) {
        positionVisible = CGPointMake(VERTICAL_SPACING_8 + (_progressBarFreeCoinContent.size.height / 2.0f), _sceneSize.height - VERTICAL_SPACING_8 - (_progressBarFreeCoinContent.size.width / 2.0f));
        positionHidden = CGPointMake(-1.0f * _progressBarFreeCoinContent.frame.size.width, positionVisible.y);
        [SIGameController SIControllerNode:_progressBarFreeCoinContent
                                 animation:SISceneContentAnimationIn
                            animationStyle:SISceneContentAnimationStyleSlide
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    if (_powerUpToolbarContentNode) {
        positionHidden      = CGPointMake(sceneMidX, -1.0f * _powerUpToolbarContentNode.frame.size.height);
        positionVisible     = CGPointMake(0.0f,_adContentNode.size.height + VERTICAL_SPACING_4 + ((_powerUpToolbarContentNode.frame.size.height / 2.0f)));
        [SIGameController SIControllerNode:_powerUpToolbarContentNode
                                 animation:SISceneContentAnimationIn
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

        positionVisible = CGPointMake(_sceneSize.width - VERTICAL_SPACING_4 - (_pauseButtonSize.width / 2.0f), _sceneSize.height - VERTICAL_SPACING_4 - (_pauseButtonSize.width / 2.0f));
        positionHidden = CGPointMake(_sceneSize.width + positionVisible.x, positionVisible.y);
        [SIGameController SIControllerNode:_pauseButtonNode
                                 animation:SISceneContentAnimationIn
                            animationStyle:SISceneContentAnimationStyleSlide
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    if (_highScoreLabelNode) {
        positionVisible     = CGPointMake(_sceneSize.width / 2.0f, _sceneSize.height - _scoreTotalLabelTopPadding - _moveCommandContentLabel.frame.size.height);
        [SIGameController SIControllerNode:_highScoreLabelNode
                                 animation:SISceneContentAnimationIn
                            animationStyle:SISceneContentAnimationStyleGrow
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    if (_swypeItCoinsLabelNode) {
        _swypeItCoinsLabelNode.text = [NSString stringWithFormat:@"%d",[SIIAPUtility numberOfCoinsForUser]];
    }

    _backgroundNode.size                            = CGSizeMake(_sceneSize.width, _sceneSize.height - _adContentNode.size.height);
    _backgroundNode.position                        = CGPointMake(0.0f, _adContentNode.size.height);
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
        _overlayContentNode.zPosition               = [SIGameController floatZPositionGameForContent:SIZPositionGameOverlayMin];
    }
    
    if (_scoreTotalContentLabel) {
        _scoreTotalContentLabel.zPosition           = [SIGameController floatZPositionGameForContent:SIZPositionGameContent];
    }
    
    if (_progressBarFreeCoinContent) {
        _progressBarFreeCoinContent.zPosition       = [SIGameController floatZPositionGameForContent:SIZPositionGameContent];
        _coinNode.zPosition                         = [SIGameController floatZPositionGameForContent:SIZPositionGameContentMoveScore];
    }
    
    if (_progressBarMoveContent) {
        _progressBarMoveContent.zPosition           = [SIGameController floatZPositionGameForContent:SIZPositionGameContent];
    }
    
    if (_progressBarPowerUpContent) {
        _progressBarPowerUpContent.zPosition        = [SIGameController floatZPositionGameForContent:SIZPositionGameContent];
    }
}
- (void)update:(NSTimeInterval)currentTime {
    if ([_sceneDelegate respondsToSelector:@selector(controllerSceneGameWillUpdateProgressBars)]) {
        SISceneGameProgressBarUpdate *progressBarUpdate = [_sceneDelegate controllerSceneGameWillUpdateProgressBars];
        if (_progressBarMoveContent) {
            _progressBarMoveContent.titleLabelNode.text     = progressBarUpdate.textMove;
            _progressBarMoveContent.progress                = progressBarUpdate.percentMove;
        }
        if (_progressBarPowerUpContent) {
            _progressBarPowerUpContent.progress             = progressBarUpdate.percentPowerUp;
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
    [_moveCommandContentLabel runAction:[SIGame actionForSIMoveCommandAction:commandAction]];
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
- (void)sceneGameWillShowMoveScore:(BMGlyphLabel *)moveLabel {
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
    if ([_sceneDelegate respondsToSelector:@selector(controllerSceneGameDidRecieveMove:)]) {
        [_sceneDelegate controllerSceneGameDidRecieveMove:move];
    }
}


@end