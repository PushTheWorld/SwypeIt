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
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports

enum {
    SISceneGameZPositionLayerBackground = 0,
    SISceneGameZPositionLayerModalMin,
    SISceneGameZPositionLayerModalMax,
    SISceneGameZPositionLayerCount
};

@implementation SIGameScene {
    
    
    CGSize                               _sceneSize;
    
    HLRingNode                          *_ringContentNode;
    
    SIAdBannerNode                      *_adContentNode;
    
    SIPopupNode                         *_popupContentNode;
    
    SKSpriteNode                        *_backgroundNode;
    
}

#pragma mark -
#pragma mark - Scene Life Cycle
- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /**Do any setup before self.view is loaded*/
        
        /*CRITICAL VARIABLES*/
        _sceneSize                              = size;
        
        [self initSetup:size];
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
    [self layoutControlsWithSize:size];
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
    
    /*Create Background Node*/
    _backgroundNode                                 = [SKSpriteNode spriteNodeWithColor:[SKColor simplstMainColor] size:_sceneSize];

    
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    _backgroundNode.anchorPoint                     = CGPointMake(0.0f, 0.0f);

    
}

- (void)layoutControlsWithSize:(CGSize)size {
    /**Layout those controls*/
    _backgroundNode.position                        = CGPointMake(0.0f, 0.0f);
    [self addChild:_backgroundNode];
    
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
    [self layoutXY];
}

/**
 This will intercept the and override the command going to self
 and will allow us to actually change the color of the background node
 */
- (void)setBackgroundColor:(UIColor * __nonnull)backgroundColor {
    if (_backgroundNode) {
        _backgroundNode.color                       = backgroundColor;
    }
}

/**
 A popup node to be displayed modally
 */
- (void)setPopupNode:(SIPopupNode *)popupNode {
    if (_popupContentNode) {
        [_popupContentNode removeFromParent];
    }
    if (popupNode) {
        _popupContentNode                           = popupNode;
        _popupContentNode.delegate                  = self;
        [self addChild:_popupContentNode];
    }
    [self layoutXY];
}

/**
 A ring node to be displayed in the center
 */
- (void)setRingNode:(HLRingNode *)ringNode {
    if (_ringContentNode) {
        [_ringContentNode removeFromParent];
    }
    if (ringNode) {
        _ringContentNode                            = ringNode;
        _ringContentNode.delegate                   = self;
        [self addChild:_ringContentNode];
    }
    [self layoutXY];
}

- (void)layoutXY {
    /**Layout those controls*/
    
    if (_popupContentNode) {
        [self presentModalNode:_popupContentNode
                     animation:HLScenePresentationAnimationFade
                  zPositionMin:(float)SISceneGameZPositionLayerModalMin / (float)SISceneGameZPositionLayerCount
                  zPositionMax:(float)SISceneGameZPositionLayerModalMax / (float)SISceneGameZPositionLayerCount];
    }
    
    if (_ringContentNode) {
        [self presentModalNode:_ringContentNode
                     animation:HLScenePresentationAnimationFade
                  zPositionMin:(float)SISceneGameZPositionLayerModalMin / (float)SISceneGameZPositionLayerCount
                  zPositionMax:(float)SISceneGameZPositionLayerModalMax / (float)SISceneGameZPositionLayerCount];
    }
    
    _backgroundNode.size                            = CGSizeMake(_sceneSize.width, _sceneSize.height - _adContentNode.size.height);
    _backgroundNode.position                        = CGPointMake(0.0f, _adContentNode.size.height);
    
}

#pragma mark -
#pragma mark - Public Methods
/**
 I guess you could use this for a pause menu... if that's something
 you're into.
 */
- (void)sceneGameBlurDisplayRingNode:(HLRingNode *)ringNode {
    
}

/**
 Present a popup without a menu node
 */
- (void)sceneGameDisplayPopup:(SIPopupNode *)popupNode {
    popupNode.delegate                             = self;
    [self presentModalNode:popupNode animation:HLScenePresentationAnimationFade];
}

/**
 Used to fade all of the UI elements in
 */
- (void)sceneGameFadeUIElementsInDuration:(CGFloat)duration {
    
}

/**
 Used to fade all of the UI elements out
 */
- (void)sceneGameFadeUIElementsOutDuration:(CGFloat)duration {
    
}

/**
 When you need to move power up progress bar on or off screen
 */
- (void)sceneGameMovePowerUpProgressBarOnScreen:(BOOL)OnScreen animate:(BOOL)animate {
    
}

/**
 Present a node modally with a pop up
 */
- (void)sceneGamePresentPopup:(SIPopupNode *)popupNode withMenuNode:(HLMenuNode *)menuNode {
    
}

/**
 Called when the scene shall show a new high score
 */
- (void)sceneGameShowHighScore {
    
}

/**
 Called when the scene shall notify the user they got a free coin
 */
- (void)sceneGameShowFreeCoinEarned {
    
}

@end