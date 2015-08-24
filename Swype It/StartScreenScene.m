//  StartScreenScene.m
//  Swype It
//
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: Thie is the startign screen for the swype it game
//
// Local Controller Import
#import "AppSingleton.h"
#import "GameScene.h"
#import "MainViewController.h"
#import "SettingsScene.h"
#import "SISegmentControl.h"
#import "StartScreenScene.h"
#import "StoreScene.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "HLSpriteKit.h"
#import "SoundManager.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "Game.h"
// Other Imports

@interface StartScreenScene () <HLMenuNodeDelegate>


@end
@implementation StartScreenScene {
    BOOL                 _shouldRespondToTap;
    
    CGFloat              _buttonAnimationDuration;
    CGFloat              _buttonSpacing;
    
    HLMenuNode          *_menuNode;
    
    SISegmentControl    *_segmentControl;
    
    SKLabelNode         *_gameTitleLabelNode;
}

#pragma mark - Scene Life Cycle
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
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kSINSUserDefaultSoundIsAllowedBackground]) {
        [[SoundManager sharedManager] playMusic:kSISoundBackgroundMenu looping:YES fadeIn:YES];
    }
    NSNotification *notification        = [[NSNotification alloc] initWithName:kSINotificationMenuLoaded object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
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
    self.backgroundColor    = [SKColor sandColor];
    _shouldRespondToTap     = YES;
    
}
#pragma mark Scene Setup
- (void)createConstantsWithSize:(CGSize)size {
    /**Configure any constants*/
    _buttonSpacing                          = [MainViewController buttonSize:size].height * 0.25;
    _buttonAnimationDuration                = 0.25f;
}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    _gameTitleLabelNode                     = [MainViewController SI_sharedLabelParagraph:@"Swype It"];
    
    /*Segment Control*/
    _segmentControl                         = [[SISegmentControl alloc] initWithSize:[MainViewController buttonSize:size] titles:@[@"Original",@"One Hand"]];

    /*Menu Node*/
    _menuNode                               = [[HLMenuNode alloc] init];
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    
    /*Menu Node*/
    _menuNode.delegate                      = self;
    _menuNode.itemAnimation                 = HLMenuNodeAnimationSlideLeft;
    _menuNode.itemAnimationDuration         = _buttonAnimationDuration;
    _menuNode.itemButtonPrototype           = [MainViewController SI_sharedMenuButtonPrototypeBasic:[MainViewController buttonSize:size]];
    _menuNode.backItemButtonPrototype       = [MainViewController SI_sharedMenuButtonPrototypeBack:[MainViewController buttonSize:size]];
    _menuNode.itemSeparatorSize             = _buttonSpacing;
    _menuNode.anchorPoint                   = CGPointMake(0.5, 0);


}
- (void)layoutControlsWithSize:(CGSize)size {
    /**Layout those controls*/
    _gameTitleLabelNode.position            = CGPointMake(CGRectGetMidX(self.frame),size.height - _gameTitleLabelNode.frame.size.height - VERTICAL_SPACING_16);
    [self addChild:_gameTitleLabelNode];
    
    /*Segment Control*/
    _segmentControl.position                = CGPointMake(CGRectGetMinX(self.frame), _gameTitleLabelNode.frame.origin.y - _gameTitleLabelNode.frame.size.height - VERTICAL_SPACING_8);
    [self addChild:_segmentControl];
    
    /*Menu Node*/
    _menuNode.position                      = CGPointMake(size.width / 2.0f,
                                                          VERTICAL_SPACING_16);
    [self addChild:_menuNode];
    [_menuNode hlSetGestureTarget:_menuNode];
    [self registerDescendant:_menuNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    [self menuCreate];
}
- (void)menuCreate {
    HLMenu *menu = [[HLMenu alloc] init];
    
    /*Add the regular buttons*/
    
    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextStartScreenTwoHand]];
    
    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextStartScreenOneHand]];
    
    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextStartScreenStore]];
    
    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextStartScreenSettings]];
    
    [_menuNode setMenu:menu animation:HLMenuNodeAnimationNone];
}
- (void)menuNode:(HLMenuNode *)menuNode didTapMenuItem:(HLMenuItem *)menuItem itemIndex:(NSUInteger)itemIndex {
    _shouldRespondToTap             = NO;
    
    if ([menuItem.text isEqualToString:kSIMenuTextStartScreenTwoHand]) {
        [self launchGameSceneForGameMode:SIGameModeTwoHand];
        
    } else if ([menuItem.text isEqualToString:kSIMenuTextStartScreenOneHand]) {
        [self launchGameSceneForGameMode:SIGameModeOneHand];
        
    } else if ([menuItem.text isEqualToString:kSIMenuTextStartScreenStore]) {
        StoreScene *storeScene = [StoreScene sceneWithSize:self.size];
        storeScene.wasLaunchedFromMainMenu = YES;
        [Game transisitionToSKScene:storeScene toSKView:self.view DoorsOpen:YES pausesIncomingScene:YES pausesOutgoingScene:YES duration:SCENE_TRANSISTION_DURATION];
        
    } else if ([menuItem.text isEqualToString:kSIMenuTextStartScreenSettings]) {
        SettingsScene *settingsScene    = [SettingsScene sceneWithSize:self.size];
        [Game transisitionToSKScene:settingsScene toSKView:self.view DoorsOpen:YES pausesIncomingScene:YES pausesOutgoingScene:YES duration:SCENE_TRANSISTION_DURATION];
        
    }
}
-(BOOL)menuNode:(HLMenuNode *)menuNode shouldTapMenuItem:(HLMenuItem *)menuItem itemIndex:(NSUInteger)itemIndex {
    return _shouldRespondToTap;
}
- (void)launchGameSceneForGameMode:(SIGameMode)gameMode {
    [[AppSingleton singleton] initAppSingletonWithGameMode:gameMode];
    GameScene *firstScene = [[GameScene alloc] initWithSize:self.size gameMode:gameMode];
    [Game transisitionToSKScene:firstScene toSKView:self.view DoorsOpen:YES pausesIncomingScene:NO pausesOutgoingScene:NO duration:SCENE_TRANSISTION_DURATION];

}

@end
