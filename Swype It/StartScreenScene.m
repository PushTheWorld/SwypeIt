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
enum {
    SIStartScreenZPositionLayerBackground = 0,
    SIStartScreenZPositionLayerText,
    SIStartScreenZPositionLayerTextChild,
    SIStartScreenZPositionLayerButtons,
    SIStartScreenZPositionLayerToolbar,
    SIStartScreenZPositionLayerToolbarButtons,
    SIStartScreenZPositionLayerCount
};

@interface StartScreenScene () <HLToolbarNodeDelegate, SISegmentControlDelegate>


@end
@implementation StartScreenScene {
    BOOL                 _shouldRespondToTap;
    
    CGFloat              _buttonAnimationDuration;
    CGFloat              _buttonSpacing;
    
    SKSpriteNode        *_backgroundNode;
    SKSpriteNode        *_tapToPlayTextNode;
    SKSpriteNode        *_monkeyFace;
    
    HLLabelButtonNode   *_storeButtonNode;
    
    HLToolbarNode       *_toolbarNode;
    
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
    
    
//    [self hlSetGestureTarget:self.scene];
//    [self registerDescendant:self.scene withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
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
    self.backgroundColor    = [SKColor orangeColor];
    _shouldRespondToTap     = YES;
//    [self needSharedGestureRecognizers:@[ [[UITapGestureRecognizer alloc] init] ]];
    
}
#pragma mark Scene Setup
- (void)createConstantsWithSize:(CGSize)size {
    /**Configure any constants*/
    _buttonSpacing                          = [MainViewController buttonSize:size].height * 0.25;
    _buttonAnimationDuration                = 0.25f;
}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    _backgroundNode                         = [SKSpriteNode spriteNodeWithColor:[SKColor sandColor] size:size];
    
    _gameTitleLabelNode                     = [MainViewController SI_sharedLabelHeader_x3:@"Swype It"];
    
    _tapToPlayTextNode                      = [SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageTapToPlayText]];
    
    _monkeyFace                             = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonFallingMonkey]];
    
    /*Store Button Label*/
    _storeButtonNode                        = [[HLLabelButtonNode alloc] initWithColor:[SKColor redColor] size:[MainViewController buttonSize:size]];

    /*Segment Control*/
    _segmentControl                         = [[SISegmentControl alloc] initWithSize:[MainViewController buttonSize:size] titles:@[@"Original",@"One Hand"]];
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    /*Background*/
    _backgroundNode.anchorPoint             = CGPointMake(0.5f, 0.5f);
    _backgroundNode.zPosition               = SIStartScreenZPositionLayerBackground / SIStartScreenZPositionLayerCount;
    
    _tapToPlayTextNode.zPosition            = SIStartScreenZPositionLayerText / SIStartScreenZPositionLayerCount;
    _tapToPlayTextNode.anchorPoint          = CGPointMake(0.5f, 0.0f);
    [_tapToPlayTextNode runAction:[SKAction scaleXTo:0.75 duration:0.0f]];
    
    _monkeyFace.zPosition                   = SIStartScreenZPositionLayerTextChild / SIStartScreenZPositionLayerCount;
    _monkeyFace.anchorPoint                 = CGPointMake(0.5f, 0.5f);
    _monkeyFace.size                        = CGSizeMake(size.width / 2.0f, size.width / 2.0f);
    
    _segmentControl.zPosition               = SIStartScreenZPositionLayerButtons / SIStartScreenZPositionLayerCount;
    
    /*Store Button Label*/
    _storeButtonNode.text                   = kSIMenuTextStartScreenStore;
    _storeButtonNode.fontName               = kSIFontUltra;
    _storeButtonNode.fontSize               = [MainViewController buttonSize:size].height / 2.0f;
    _storeButtonNode.fontColor              = [SKColor whiteColor];
    _storeButtonNode.borderColor            = [SKColor blackColor];
    _storeButtonNode.borderWidth            = 12.0f;
    _storeButtonNode.cornerRadius           = 8.0f;
    _storeButtonNode.verticalAlignmentMode  = HLLabelNodeVerticalAlignFont;
    _storeButtonNode.anchorPoint            = CGPointMake(0.5f, 0.0f);
    
    /*Toolbar Node*/
    _toolbarNode                            = [self createToolbarNode:size];
    _toolbarNode.delegate                   = self;
    _toolbarNode.zPosition                  = SIStartScreenZPositionLayerToolbar / SIStartScreenZPositionLayerCount;
}
- (void)layoutControlsWithSize:(CGSize)size {
    /**Layout those controls*/
    _backgroundNode.position                = CGPointMake(size.width / 2.0f, size.height / 2.0f);
    [self addChild:_backgroundNode];
    HLTapGestureTarget *tapGestureTarget    = [[HLTapGestureTarget alloc] init];
    tapGestureTarget.handleGestureBlock     = ^(UIGestureRecognizer *gestureRecognizer){
        NSNumber *gameModeNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultGameMode];
        SIGameMode startingGameMode;
        if (!gameModeNumber) {
            [[NSUserDefaults standardUserDefaults] setInteger:SIGameModeTwoHand forKey:kSINSUserDefaultGameMode];
            [[NSUserDefaults standardUserDefaults] synchronize];
            startingGameMode   = SIGameModeTwoHand;
        } else {
            startingGameMode = [gameModeNumber integerValue];
        }
        
        [self launchGameSceneForGameMode:startingGameMode];

    };
    [_backgroundNode hlSetGestureTarget:tapGestureTarget];
    [self registerDescendant:_backgroundNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    
    _gameTitleLabelNode.position            = CGPointMake(CGRectGetMidX(self.frame),size.height - _gameTitleLabelNode.frame.size.height - VERTICAL_SPACING_16);
    [self addChild:_gameTitleLabelNode];
    
    _tapToPlayTextNode.position             = CGPointMake(size.width / 2.0f, size.height /2.0f);
    [self addChild:_tapToPlayTextNode];
    
    _monkeyFace.position                    = CGPointMake(0.0f, 0.0f);
    [_tapToPlayTextNode addChild:_monkeyFace];
    
    /*Segment Control*/
    _segmentControl.position                = CGPointMake(size.width / 2.0f,
                                                          (3.0f * [MainViewController buttonSize:size].height));
    [self addChild:_segmentControl];
    [_segmentControl hlSetGestureTarget:_segmentControl];
    [self registerDescendant:_segmentControl withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    
    /*Store Button Label*/
    _storeButtonNode.position               = CGPointMake(size.width / 2.0f,
                                                          VERTICAL_SPACING_8 + [MainViewController buttonSize:size].height + VERTICAL_SPACING_8);
    [self addChild:_storeButtonNode];
    [_storeButtonNode hlSetGestureTarget:[HLTapGestureTarget tapGestureTargetWithHandleGestureBlock:^(UIGestureRecognizer *gestureRecognizer) {
        NSLog(@"Store button tapped");
    }]];
    [self registerDescendant:_storeButtonNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    
    /*Menu Node*/
    _toolbarNode.position                   = CGPointMake(0.0f,
                                                          VERTICAL_SPACING_8);
    [self addChild:_toolbarNode];
    [_toolbarNode hlSetGestureTarget:_toolbarNode];
    [self registerDescendant:_toolbarNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
}
//- (void)menuCreate {
//    HLMenu *menu = [[HLMenu alloc] init];
//    
//    /*Add the regular buttons*/
//    
////    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextStartScreenTwoHand]];
////    
////    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextStartScreenOneHand]];
//    
//    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextStartScreenStore]];
//    
//    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextStartScreenSettings]];
//    
//    [_menuNode setMenu:menu animation:HLMenuNodeAnimationNone];
//}
//- (void)menuNode:(HLMenuNode *)menuNode didTapMenuItem:(HLMenuItem *)menuItem itemIndex:(NSUInteger)itemIndex {
//    _shouldRespondToTap             = NO;
//    
////    if ([menuItem.text isEqualToString:kSIMenuTextStartScreenTwoHand]) {
////        [self launchGameSceneForGameMode:SIGameModeTwoHand];
////        
////    } else if ([menuItem.text isEqualToString:kSIMenuTextStartScreenOneHand]) {
////        [self launchGameSceneForGameMode:SIGameModeOneHand];
////        
////    } else
//    if ([menuItem.text isEqualToString:kSIMenuTextStartScreenStore]) {
//        StoreScene *storeScene = [StoreScene sceneWithSize:self.size];
//        storeScene.wasLaunchedFromMainMenu = YES;
//        [Game transisitionToSKScene:storeScene toSKView:self.view DoorsOpen:YES pausesIncomingScene:YES pausesOutgoingScene:YES duration:SCENE_TRANSISTION_DURATION];
//        
//    } else if ([menuItem.text isEqualToString:kSIMenuTextStartScreenSettings]) {
//        SettingsScene *settingsScene    = [SettingsScene sceneWithSize:self.size];
//        [Game transisitionToSKScene:settingsScene toSKView:self.view DoorsOpen:YES pausesIncomingScene:YES pausesOutgoingScene:YES duration:SCENE_TRANSISTION_DURATION];
//        
//    }
//}
//-(BOOL)menuNode:(HLMenuNode *)menuNode shouldTapMenuItem:(HLMenuItem *)menuItem itemIndex:(NSUInteger)itemIndex {
//    return _shouldRespondToTap;
//}
#pragma mark - Toolbar Delegates
- (void)toolbarNode:(HLToolbarNode *)toolbarNode didTapTool:(NSString *)toolTag {
    if ([toolTag isEqualToString:kSINodeButtonLeaderBoard]) {
        NSLog(@"Leaderboard Toolbar Button Tapped");
    } else if ([toolTag isEqualToString:kSINodeButtonNoAd]) {
        NSLog(@"Ad Free Toolbar Button Tapped");
    } else if ([toolTag isEqualToString:kSINodeButtonSettings]) {
        NSLog(@"Settings Toolbar Button Tapped");
    } else if ([toolTag isEqualToString:kSINodeButtonInstructions]) {
        NSLog(@"Instructions Toolbar Button Tapped");
    }
}

#pragma mark - Segment Control Delegate Methods
- (void)segmentControl:(SISegmentControl *)segmentControl didTapNodeItem:(HLLabelButtonNode *)nodeItem itemIndex:(NSUInteger)itemIndex {
    if (itemIndex == 0) { /*Two Hand Mode*/
        [[NSUserDefaults standardUserDefaults] setInteger:SIGameModeTwoHand forKey:kSINSUserDefaultGameMode];
    } else { /*One Hand Mode*/
        [[NSUserDefaults standardUserDefaults] setInteger:SIGameModeOneHand forKey:kSINSUserDefaultGameMode];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (HLToolbarNode *)createToolbarNode:(CGSize)size {
    HLToolbarNode *toolbarNode                  = [[HLToolbarNode alloc] init];
    toolbarNode.automaticHeight                 = NO;
    toolbarNode.automaticWidth                  = NO;
    toolbarNode.backgroundBorderSize            = 0.0f;
    toolbarNode.squareSeparatorSize             = 10.0f;
    toolbarNode.backgroundColor                 = [UIColor clearColor];
    toolbarNode.anchorPoint                     = CGPointMake(0.0f, 0.0f);
    toolbarNode.size                            = CGSizeMake(size.width, [MainViewController buttonSize:size].height);
    toolbarNode.squareColor                     = [SKColor clearColor];
    
    NSMutableArray *toolNodes                   = [NSMutableArray array];
    NSMutableArray *toolTags                    = [NSMutableArray array];
    
    [toolNodes  addObject:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonSettings]]];
    [toolTags   addObject:kSINodeButtonSettings];
    
    [toolNodes  addObject:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonNoAd]]];
    [toolTags   addObject:kSINodeButtonNoAd];

    [toolNodes  addObject:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonInstructions]]];
    [toolTags   addObject:kSINodeButtonInstructions];

    [toolNodes  addObject:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonLeaderboard]]];
    [toolTags   addObject:kSINodeButtonLeaderBoard];
    
    [toolbarNode setTools:toolNodes tags:toolTags animation:HLToolbarNodeAnimationSlideUp];
    
    [toolbarNode layoutToolsAnimation:HLToolbarNodeAnimationNone];
    return toolbarNode;
}

#pragma mark - Private Methods
- (void)launchGameSceneForGameMode:(SIGameMode)gameMode {
    [[AppSingleton singleton] initAppSingletonWithGameMode:gameMode];
    GameScene *firstScene = [[GameScene alloc] initWithSize:self.size gameMode:gameMode];
    [Game transisitionToSKScene:firstScene toSKView:self.view DoorsOpen:YES pausesIncomingScene:NO pausesOutgoingScene:NO duration:SCENE_TRANSISTION_DURATION];
    
}

@end
