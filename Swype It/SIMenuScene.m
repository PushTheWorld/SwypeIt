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
    
    SIMenuNode                                      *_currentMenuNode;
    
    SIPopupNode                                     *_popupContentNode;
    
    SKSpriteNode                                    *_backgroundNode;

}
- (nonnull instancetype)init {
    self = [super init];
    if (self) {
        _type                                       = SISceneMenuTypeNone;
        _spacingToolbarBottom                       = VERTICAL_SPACING_4;
        _animationDuration                          = 1.0f;
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
}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    _backgroundNode                                 = [SKSpriteNode spriteNodeWithColor:[SKColor simplstMainColor] size:_sceneSize];
     
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
        [_adContentNode hlSetGestureTarget:_adBannerNode];
        [self registerDescendant:_adBannerNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];

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
            
        case SISceneMenuTypeSettings:
            [self layoutXYAnimation:SISceneContentAnimationNone];
            break;
            
        case SISceneMenuTypeStore:
            [self layoutXYAnimation:SISceneContentAnimationNone];
            break;
    
        default:
            [self layoutXYAnimation:SISceneContentAnimationNone];
            break;
    }
}

- (void)showMenuNode:(SIMenuNode *)menuNode menuNodeAnimation:(SIMenuNodeAnimation)menuNodeAnimation {
    [self addChild:menuNode];
    SKAction *blockAction;
    if (menuNodeAnimation == SIMenuNodeAnimationLeft) {
        menuNode.position = CGPointMake(menuNode.size.width, 0.0f);
        SKAction *moveLeft = [SKAction moveByX:menuNode.size.width y:0.0f duration:SCENE_TRANSISTION_DURATION_FAST];
        [menuNode runAction:moveLeft];
        blockAction = [SKAction runBlock:^{
            [_currentMenuNode removeFromParent];
            _currentMenuNode = menuNode;
        }];
        [_currentMenuNode runAction:[SKAction sequence:@[moveLeft,blockAction]]];
        if (_toolbarContentNode) {
            [_toolbarContentNode runAction:moveLeft];
        }

    } else if (menuNodeAnimation == SIMenuNodeAnimationRight) {
        menuNode.position = CGPointMake(-1.0f * menuNode.size.width, 0.0f);
        SKAction *moveRight = [SKAction moveByX:menuNode.size.width y:0.0f duration:SCENE_TRANSISTION_DURATION_FAST];
        [menuNode runAction:moveRight];
        blockAction = [SKAction runBlock:^{
            _currentMenuNode = menuNode;
        }];
        [_currentMenuNode runAction:[SKAction sequence:@[moveRight,blockAction]]];
        if (_toolbarContentNode) {
            [_toolbarContentNode runAction:moveRight];
        }


    } else {
        menuNode.position = CGPointZero;
        if (_currentMenuNode) {
            [_currentMenuNode removeFromParent];
        }
        _currentMenuNode = menuNode;
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
                                         animation:animation
                                    animationStyle:SISceneContentAnimationStyleGrow
                                 animationDuration:_animationDuration
                                   positionVisible:positionVisible
                                    positionHidden:positionHidden];
            }
            
            if (_toolbarContentNode) {
                positionHidden      = CGPointMake(sceneMidX, -1.0f * _toolbarContentNode.frame.size.height);
                positionVisible     = CGPointMake(sceneMidX,_adContentNode.size.height + _spacingToolbarBottom + ((_toolbarContentNode.frame.size.height / 2.0f)));
                [SIGameController SIControllerNode:_toolbarContentNode
                                         animation:animation
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
                                         animation:animation
                                    animationStyle:SISceneContentAnimationStyleGrow
                                 animationDuration:_animationDuration
                                   positionVisible:positionVisible
                                    positionHidden:positionHidden];
            }
            
            if (_toolbarContentNode) {
                positionHidden      = CGPointMake(sceneMidX, -1.0f * _toolbarContentNode.frame.size.height);
                positionVisible     = CGPointMake(sceneMidX,_adContentNode.size.height + _spacingToolbarBottom + ((_toolbarContentNode.frame.size.height / 2.0f)));
                [SIGameController SIControllerNode:_toolbarContentNode
                                         animation:animation
                                    animationStyle:SISceneContentAnimationStyleSlide
                                 animationDuration:_animationDuration
                                   positionVisible:positionVisible
                                    positionHidden:positionHidden];
            }
            break;
            
        case SISceneMenuTypeSettings:
            break;
            
        case SISceneMenuTypeStore:
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
