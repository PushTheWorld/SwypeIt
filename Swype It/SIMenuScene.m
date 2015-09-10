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
    CGSize                                          _sceneSize;
    
    SIAdBannerNode                                  *_adContentNode;
    
    SKSpriteNode                                    *_backgroundNode;

}
#pragma mark - Scene Life Cycle
- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /**Do any setup before self.view is loaded*/
        _menuType                                   = SISceneMenuTypeStart;
        _sceneSize                                  = size;
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
- (HLToolbarNode *)createToolbarBottom:(CGSize)size {
    HLToolbarNode *toolbarNode                      = [[HLToolbarNode alloc] init];
    toolbarNode.automaticHeight                     = NO;
    toolbarNode.automaticWidth                      = NO;
    toolbarNode.backgroundBorderSize                = 0.0f;
    toolbarNode.squareSeparatorSize                 = 10.0f;
    toolbarNode.backgroundColor                     = [UIColor clearColor];
    toolbarNode.anchorPoint                         = CGPointMake(0.0f, 0.0f);
    toolbarNode.size                                = CGSizeMake(size.width, [SIGameController SIButtonSize:size].height);
    toolbarNode.squareColor                         = [SKColor clearColor];
    
    
    NSMutableArray *toolNodes                       = [NSMutableArray array];
    NSMutableArray *toolTags                        = [NSMutableArray array];
    
    [toolNodes  addObject:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonSettings]]];
    [toolTags   addObject:kSINodeButtonSettings];
    
    BOOL isPremiumUser = [[NSUserDefaults standardUserDefaults] boolForKey:kSINSUserDefaultPremiumUser];
    if (!isPremiumUser) {
        [toolNodes  addObject:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonNoAd]]];
        [toolTags   addObject:kSINodeButtonNoAd];
    }
    
    [toolNodes  addObject:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonInstructions]]];
    [toolTags   addObject:kSINodeButtonInstructions];
    
    [toolNodes  addObject:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonLeaderboard]]];
    [toolTags   addObject:kSINodeButtonLeaderBoard];
    
    [toolbarNode setTools:toolNodes tags:toolTags animation:HLToolbarNodeAnimationNone];
    
    [toolbarNode layoutToolsAnimation:HLToolbarNodeAnimationNone];
    return toolbarNode;
}
#pragma mark - Setters
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

- (void)setSceneMenuType:(SISceneMenuType)sceneMenuType {
    [self layoutXY];
}

#pragma mark - Layout Functions
/**
 Called when ever you may need to layout the end scene
 */
- (void)layoutXY {
    if (!_backgroundNode) {
        return;
    }
    _backgroundNode.size                            = CGSizeMake(_sceneSize.width, _sceneSize.height - _adContentNode.size.height);
    _backgroundNode.position                        = CGPointMake(0.0f, _adContentNode.size.height);
    
}
#pragma mark - Public Class Methods


@end
