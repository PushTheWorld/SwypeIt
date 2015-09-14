//  SIMenuScene.m
//  Swype It
//
//  Created by Andrew Keller on 9/6/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is the main m file for the start/end screen for swype it
//
// Local Controller Import
#import "SIGameController.h"
#import "SIMenuScene.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports
@implementation SIMenuScene {
    CGSize                                           _backButtonSize;
    CGSize                                           _sceneSize;
    
    HLGridNode                                      *_gridContentNode;
    
    HLToolbarNode                                   *_toolbarContentNode;
    
    SIAdBannerNode                                  *_adContentNode;
    
    SIPopupNode                                     *_popupContentNode;
    
    SKSpriteNode                                    *_backgroundNode;
    
    SKSpriteNode                                    *_backButtonNode;

}
- (nonnull instancetype)init {
    self = [super init];
    if (self) {
        _type                                       = SISceneMenuTypeNone;
        _spacingToolbarBottom                       = VERTICAL_SPACING_4;
        _animationDuration                          = 1.0f;
        _backButtonVisible                          = NO;
    }
    return self;
}

#pragma mark - Scene Life Cycle
- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /**Do any setup before self.view is loaded*/
        [self initSetup:size];
        _sceneSize                                  = size;
        

    }
    return self;
}
- (void)didMoveToView:(nonnull SKView *)view {
    [super didMoveToView:view];
    /**Do any setup post self.view creation*/
    [self viewSetup:view];
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
}
- (void)viewSetup:(SKView *)view {
    /**Preform setup post-view load*/
    
}
#pragma mark Scene Setup
- (void)createConstantsWithSize:(CGSize)size {
    /**Configure any constants*/
    _backButtonSize                                 = CGSizeMake(_sceneSize.width / 8.0f, _sceneSize.width / 4.0f);
}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    _backgroundNode                                 = [SKSpriteNode spriteNodeWithColor:[SKColor simplstMainColor] size:_sceneSize];
    
    _backButtonNode                                 = [SKSpriteNode spriteNodeWithTexture:[[SIConstants atlasSceneMenu] textureNamed:kSIAtlasSceneMenuBackButton] size:_backButtonSize];
    
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    /*Create Background Node*/
    _backgroundNode.anchorPoint                     = CGPointMake(0.0f, 0.0f);
}

#pragma mark -
#pragma mark - Public Accessors
- (void)setAdBannerNode:(SIAdBannerNode *)adBannerNode {
    if (_adContentNode) {
        [_adContentNode removeFromParent];
    }
    if (adBannerNode) {
        _adContentNode                              = adBannerNode;
        _adContentNode.name                         = kSINodeAdBannerNode;
        _adContentNode.position                     = CGPointMake(0.0f, 0.0f);
        [self addChild:_adContentNode];
    }
    [self layoutXYAnimation:SISceneContentAnimationNone];
}

- (void)setGridNode:(HLGridNode *)gridNode {
    if (_gridContentNode) {
        [_gridContentNode removeFromParent];
    }
    if (gridNode) {
        _gridContentNode = gridNode;
        [self addChild:_gridContentNode];
    }
    [self layoutXYAnimation:SISceneContentAnimationNone];
}
-(void)setType:(SISceneMenuType)type {
    switch (type) {
        case SISceneMenuTypeStart:
            [self layoutXYAnimation:SISceneContentAnimationIn];
            break;
        
        case SISceneMenuTypeNone:
            [self layoutXYAnimation:SISceneContentAnimationOut];
            break;
            
        default:
            [self layoutXYAnimation:SISceneContentAnimationNone];
            break;
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

#pragma mark - Layout Functions
/**
 Called when ever you may need to layout the end scene
 */
#pragma mark Layout
- (void)layoutXYZAnimation:(SISceneContentAnimation)animation {
    [self layoutXYAnimation:animation];
    [self layoutZ];
    if ([_sceneDelegate respondsToSelector:@selector(controllerSceneMenuDidLoadType:)]) {
        [_sceneDelegate controllerSceneMenuDidLoadType:_type];
    }
}

- (void)layoutXYAnimation:(SISceneContentAnimation)animation {
    if (!_backgroundNode) {
        return;
    }
    CGFloat sceneMidX                               = _sceneSize.width /2.0f;
    CGFloat sceneMidY                               = _sceneSize.height /2.0f;
    CGPoint sceneMidPoint = CGPointMake(sceneMidX, sceneMidY);
    
    CGPoint positionHidden = CGPointZero;
    CGPoint positionVisible = CGPointZero;
    
    switch (_type) {
        case SISceneMenuTypeStart:
            if (_gridContentNode) {
                positionHidden      = sceneMidPoint;
                positionVisible     = sceneMidPoint;
                [SIGameController SIControllerNode:_toolbarContentNode
                                         animation:SISceneContentAnimationIn
                                    animationStyle:SISceneContentAnimationStyleGrow
                                 animationDuration:_animationDuration
                                   positionVisible:positionVisible
                                    positionHidden:positionHidden];
            }
            
            if (_toolbarContentNode) {
                positionHidden      = CGPointMake(sceneMidX, -1.0f * _toolbarContentNode.frame.size.height);
                positionVisible     = CGPointMake(sceneMidX,_adContentNode.size.height + _spacingToolbarBottom + ((_toolbarContentNode.frame.size.height / 2.0f)));
                [SIGameController SIControllerNode:_toolbarContentNode
                                         animation:SISceneContentAnimationIn
                                    animationStyle:SISceneContentAnimationStyleSlide
                                 animationDuration:_animationDuration
                                   positionVisible:positionVisible
                                    positionHidden:positionHidden];
            }
            break;
        case SISceneMenuTypeNone:
            if (_gridContentNode) {
                positionHidden      = sceneMidPoint;
                positionVisible     = sceneMidPoint;
                [SIGameController SIControllerNode:_toolbarContentNode
                                         animation:SISceneContentAnimationOut
                                    animationStyle:SISceneContentAnimationStyleGrow
                                 animationDuration:_animationDuration
                                   positionVisible:positionVisible
                                    positionHidden:positionHidden];
            }
            
            if (_toolbarContentNode) {
                positionHidden      = CGPointMake(sceneMidX, -1.0f * _toolbarContentNode.frame.size.height);
                positionVisible     = CGPointMake(sceneMidX,_adContentNode.size.height + _spacingToolbarBottom + ((_toolbarContentNode.frame.size.height / 2.0f)));
                [SIGameController SIControllerNode:_toolbarContentNode
                                         animation:SISceneContentAnimationOut
                                    animationStyle:SISceneContentAnimationStyleSlide
                                 animationDuration:_animationDuration
                                   positionVisible:positionVisible
                                    positionHidden:positionHidden];
            }
            break;
        default:
            break;
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
}
#pragma mark -
#pragma mark - Public Functions


@end
