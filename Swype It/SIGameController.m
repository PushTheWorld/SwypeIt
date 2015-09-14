//  SIGameController.m
//  Swype It
//
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: This is the main game view controller... has HUD
//
// Local Controller Import
#import "SISingletonAchievement.h"
#import "SISingletonGame.h"
#import "SIStoreButtonNode.h"
#import "SIMenuNode.h"
#import "SIPowerUpToolbarNode.h"
#import "SIPopupContentNode.h"
#import "SIGameController.h"
// Scene Import
#import "SIFallingMonkeyScene.h"
#import "SIGameScene.h"
#import "SILoadingScene.h"
#import "SIMenuScene.h"
#import "SITestScene.h"
#import "SettingsScene.h"
#import "StoreScene.h"
// Framework Import
#import <GameKit/GameKit.h>
#import <iAd/iAd.h>
#import <Instabug/Instabug.h>
#import <MessageUI/MessageUI.h>
#import "MSSAlertViewController.h"
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "BMGlyphFont.h"
#import "BMGlyphLabel.h"
#import "DSMultilineLabelNode.h"
#import "FXReachability.h"
#import "JCNotificationCenter.h"
#import "MBProgressHud.h"
#import "MKStoreKit.h"
#import "SoundManager.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIGame.h"
// Other Imports

@interface SIGameController () <ADBannerViewDelegate, ADInterstitialAdDelegate, GKGameCenterControllerDelegate, SISingletonGameDelegate, SIGameSceneDelegate, SISingletonAchievementDelegate, SIMenuSceneDelegate, SIFallingMonkeySceneDelegate, HLMenuNodeDelegate, HLGridNodeDelegate, HLRingNodeDelegate, HLToolbarNodeDelegate, SIPopUpNodeDelegate, SIAdBannerNodeDelegate>

@property (strong, nonatomic) UIButton          *closeButton;
@end

@implementation SIGameController {
    __weak SKScene                           *_currentScene;
    
    ADBannerView                             *_adBannerView;
    
    ADInterstitialAd                         *_interstitialAd;
    
    BOOL                                     _interstitialAdPresentationIsLive;
    
    /**
     Premium User or not... for quick reference and shit
     */
    BOOL                                     _premiumUser;
    
    /**
     Set this true if you want a ton of print statements
     */
    BOOL                                     _verbose;
    
    CGFloat                                  _sceneGameSpacingHorizontalToolbar;
    
    CGSize                                   _sceneSize;
    CGSize                                   _sceneGameToolbarSize;
    CGSize                                   _sceneGameToolbarNodeSize;


    int                                      _loadingPointsCurrent;
    int                                      _loadingPointsTotal;
    int                                      _numberOfAdsToWatch;
    
    /**
     0.0 to 1.0 for the amount of the scene that is loaded
     */
    float                                    _percentLoaded;
    
    HLGridNode                              *_sceneMenuStartGridNode;
    
    HLMenuNode                              *_sceneGamePopupContinueMenuNode;
    HLMenuNode                              *_sceneMenuStoreMenuNode;
    HLMenuNode                              *_sceneMenuSettingsMenuNode;
    
    HLRingNode                              *_sceneGameRingNodePause;
    
    HLToolbarNode                           *_sceneGameToolbarPowerUp;
    HLToolbarNode                           *_sceneMenuToolbarStart;
    
    MBProgressHUD                           *_hud;
    
    NSString                                *_sceneGamePopupMenuItemTextContinueWithAd;
    NSString                                *_sceneGamePopupMenuItemTextContinueWithCoin;
    NSString                                *_sceneSettingsMenuItemTextSoundBackground;
    NSString                                *_sceneSettingsMenuItemTextSoundFX;
    
    SIAdBannerNode                          *_adBannerNode;
    
    SIFallingMonkeyScene                    *_sceneFallingMonkey;
    
    SIGameControllerScene                    _currentSceneType;
    
    SIGameScene                             *_sceneGame;
    
    SILoadingScene                          *_sceneLoading;
    
    SIMenuNode                              *_menuNodeEnd;
    SIMenuNode                              *_menuNodeSettings;
    SIMenuNode                              *_menuNodeStart;
    SIMenuNode                              *_menuNodeStore;
    
    SIMenuScene                             *_sceneMenu;
    
    SIPopupNode                             *_sceneGamePopupContinue;
    SIPopupNode                             *_sceneMenuPopupFreePrize;
    
    SIPopupContentNode                      *_sceneMenuPopupContentFreePrize;
    
    SKSpriteNode                            *_backButtonNode;
    
    SKTexture                               *_monkeyFaceTexture;
    
    UIView                                  *_placeHolderView;

}



#pragma mark - UI Life Cycle Methods
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.restorationIdentifier = @"SIGameController";
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActive)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidReceiveMemoryWarning)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUserInterface];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self configureBannerAds];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    _adBannerView.delegate  = nil;
    [_adBannerView removeFromSuperview];
    
    [super viewWillDisappear:animated];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)setupUserInterface {
    [self createConstants];
    [self setupControls];
    [self mainSceneInitializationMethod];
}
- (void)createConstants {

    _sceneSize                          = self.view.frame.size;
    _interstitialAdPresentationIsLive   = NO;
    _monkeyFaceTexture                  = [[SIConstants buttonAtlas] textureNamed:kSIImageFallingMonkeys];
    _loadingPointsCurrent               = 0;
    _verbose                            = YES;
    _premiumUser                        = [SIGameController premiumUser];
    
    _sceneGameSpacingHorizontalToolbar  = 10.0f;
    CGFloat toolBarNodeWidth            = (SCREEN_WIDTH - (4.0f * _sceneGameSpacingHorizontalToolbar)) / 5.0f;
    _sceneGameToolbarNodeSize           = CGSizeMake(toolBarNodeWidth, toolBarNodeWidth);
    _sceneGameToolbarSize               = CGSizeMake(_sceneSize.width, _sceneGameToolbarNodeSize.height + VERTICAL_SPACING_8);

}
- (void)setupControls {

    [self authenticateLocalPlayer];

    /*Start your singletons*/
    [SISingletonGame singleton];
    [SISingletonAchievement singleton];
    
    /*Start Sounds*/
    [SoundManager sharedManager].allowsBackgroundMusic  = YES;
    [SoundManager sharedManager].soundFadeDuration      = 1.0f;
    [SoundManager sharedManager].musicFadeDuration      = 2.0f;
    [[SoundManager sharedManager] prepareToPlayWithSound:[Sound soundNamed:kSISoundFXInitalize]];
    
    /*Give those interstitial ads a cycle to get em going*/
    [self interstitialAdCycle];
    
    _adBannerNode                                       = [[SIAdBannerNode alloc] initWithSize:CGSizeMake(_sceneSize.width, [SIGameController SIAdBannerViewHeight])];
    _adBannerNode.position                              = CGPointMake(0.0f, 0.0f);
    _adBannerNode.delegate                              = self;
}

- (void)loadingIncrementWillOverrideAndKill:(BOOL)overrideAndKillLoadingScreen {
    _loadingPointsCurrent = _loadingPointsCurrent + 1;
    if (_loadingPointsCurrent == (int)SIGameControllerSceneCount || overrideAndKillLoadingScreen) {
        [self presentScene:SIGameControllerSceneMenu];
    }
    [_sceneLoading sceneLoadingSetProgressPercent:(float)_loadingPointsCurrent / (float)SIGameControllerSceneCount];
}

- (void)presentScene:(SIGameControllerScene)sceneType {
    
    switch (sceneType) {
        // LOADING
        case SIGameControllerSceneLoading:
            _currentScene = [SIGameController viewController:[self fastSKView] transisitionToSKScene:_sceneLoading duration:SCENE_TRANSISTION_DURATION_FAST];
            break;
            
        // FALLING MONKEY
        case SIGameControllerSceneFallingMonkey:
            _currentScene = [SIGameController viewController:[self fastSKView] transisitionToSKScene:_sceneFallingMonkey duration:SCENE_TRANSISTION_DURATION_FAST];
            break;
            
        // GAME
        case SIGameControllerSceneGame:
            switch (_currentSceneType) {
                case SIGameControllerSceneFallingMonkey:
                    _currentScene = [SIGameController viewController:[self fastSKView] transisitionToSKScene:_sceneGame duration:SCENE_TRANSISTION_DURATION_NORMAL];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SCENE_TRANSISTION_DURATION_NORMAL * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[SISingletonGame singleton] singletonGameWillResumeAndContinue:YES];
                    });
                    break;
                    
                default:
                    break;
            }
            break;
        
        // MENU
        case SIGameControllerSceneMenu:
            _sceneMenu.type = SISceneMenuTypeNone;

            switch (_currentSceneType) {
                case SIGameControllerSceneGame:
                    _currentScene = [SIGameController transisitionFastOpenToSKScene:_sceneMenu toSKView:[self fastSKView]];
                    [self presentSceneMenuType:SISceneMenuTypeEnd inDelay:SCENE_TRANSISTION_DURATION_FAST];
                    break;
                case SIGameControllerSceneLoading:
                    _currentScene = [SIGameController transisitionZeroOpenToSKScene:_sceneMenu toSKView:[self fastSKView]];
                    [self presentSceneMenuType:SISceneMenuTypeStart inDelay:0.0f];
                    break;
                default:
                    _currentScene = [SIGameController transisitionNormalOpenToSKScene:_sceneMenu toSKView:[self fastSKView]];
                    [self presentSceneMenuType:SISceneMenuTypeStart inDelay:0.0f];
                    break;
            }
            break;
            
        default:
            break;
    }
    _currentSceneType = SIGameControllerSceneLoading;
}

- (void)presentSceneMenuType:(SISceneMenuType)type inDelay:(float)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        switch (type) {
            case SISceneMenuTypeStart:
                _sceneMenu.menuNode = _menuNodeStart;
                break;
                
            case SISceneMenuTypeStore:
                _sceneMenu.menuNode = _menuNodeStore;
                break;
                
            case SISceneMenuTypeSettings:
                _sceneMenu.menuNode = _menuNodeSettings;
                break;

            default:
                break;
        }
        
    });
}


#pragma mark -
#pragma mark - Scene Loading
- (void)mainSceneInitializationMethod {
    NSDate *startDate = [NSDate date];
    /*Init The Loading Scene First and Fire It Up There!*/
    _sceneLoading = [SIGameController SILoaderSceneLoadingSize:_sceneSize];
    [self loadingIncrementWillOverrideAndKill:NO];
    [self presentScene:SIGameControllerSceneLoading];
    /*Load the scenes*/
    [self loadAllScenes];
    
    /*Load any pop ups and such remaining*/
    if (_verbose) {
        NSLog(@"All data initialized in %0.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
    }
}

- (void)loadAllScenes {
    
    /*Start loading Menu Scene*/
    _sceneMenu = [self loadMenuScene];
    [self loadingIncrementWillOverrideAndKill:NO];
    
    /*Load the game sceen*/
    _sceneGame = [self loadGameScene];
    [self loadingIncrementWillOverrideAndKill:NO];

    /*Load the falling monkey sceen*/
    _sceneFallingMonkey = [self loadFallingMonkeyScene];
    [self loadingIncrementWillOverrideAndKill:YES];

}

- (SIGameScene *)loadGameScene {
    NSDate *startDate = [NSDate date];
    
    [SISingletonGame singleton];
    
    SIGameScene *sceneGame              = [[SIGameScene alloc] initWithSize:_sceneSize];
    
    sceneGame.sceneDelegate             = self;
    
    _sceneGamePopupContinue             = [SIGameController SIPopupSceneGameContinue];
    
    _sceneGamePopupContinueMenuNode     = [SIGameController SIHLMenuNodeSceneGamePopup:_sceneGamePopupContinue];
    
    _sceneGameRingNodePause             = [SIGameController SIHLRingNodeSceneGamePause];
    
    _sceneGameToolbarPowerUp            = [SIGameController SIHLToolbarGamePowerUpToolbarSize:_sceneGameToolbarSize toolbarNodeSize:_sceneGameToolbarNodeSize horizontalSpacing:_sceneGameSpacingHorizontalToolbar];
    sceneGame.powerUpToolbarNode        = _sceneGameToolbarPowerUp;
    
    sceneGame.progressBarFreeCoin       = [SIGameController SIProgressBarSceneGameFreeCoinSceneSize:_sceneSize];
    
    sceneGame.progressBarMove           = [SIGameController SIProgressBarSceneGameMoveSceneSize:_sceneSize];
    
    sceneGame.progressBarPowerUp        = [SIGameController SIProgressBarSceneGamePowerUpSceneSize:_sceneSize];
    
    sceneGame.adBannerNode              = _adBannerNode;
    
    [SIGameController SILoaderEmitters];
    
    if (_verbose) {
        NSLog(@"SIGameScene Initialized: loaded in %0.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
    }
    
    return sceneGame;
}

- (SIMenuScene *)loadMenuScene {
    NSDate *startDate                           = [NSDate date];
    
    SIMenuScene *menuScene                      = [[SIMenuScene alloc] initWithSize:_sceneSize];
    
    menuScene.sceneDelegate                     = self;
    
    SKSpriteNode *startMenuNode                 = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:_sceneSize];
    
    [startMenuNode addChild:[SIGameController SIHLGridNodeMenuSceneSize:_sceneSize]];
    
    [startMenuNode addChild:[SIGameController SIHLToolbarMenuStartScene:[SIGameController SIToolbarSceneMenuSize:_sceneSize] isPremiumUser:_premiumUser]];
    
//    menuScene.gridNode                          = [SIGameController SIHLGridNodeMenuSceneSize:_sceneSize];
//    
//    menuScene.toolBarBottom                     = [SIGameController SIHLToolbarMenuStartScene:[SIGameController SIToolbarSceneMenuSize:_sceneSize] isPremiumUser:_premiumUser];

    _sceneMenuPopupFreePrize                    = [SIGameController SIPopupSceneMenuFreePrize];
    
    _sceneMenuPopupContentFreePrize             = [SIGameController SIPopupContentSceneMenuFreePrizeSize:_sceneSize];
    
    _sceneMenuPopupFreePrize.popupContentNode   = _sceneMenuPopupContentFreePrize;
    
    _menuNodeSettings                           = [[SIMenuNode alloc] initWithSize:_sceneSize Node:[self SIHLMenuNodeSceneMenuSettings:_sceneSize] type:SISceneMenuTypeSettings ];
    
    _menuNodeStore                              = [[SIMenuNode alloc] initWithSize:_sceneSize Node:[SIGameController SIHLMenuNodeSceneMenuStore:_sceneSize] type:SISceneMenuTypeStore];
    
    _menuNodeStart                              = [[SIMenuNode alloc] initWithSize:_sceneSize Node:startMenuNode type:SISceneMenuTypeStart];
    
    menuScene.adBannerNode                      = _adBannerNode;
        
    if (_verbose) {
        NSLog(@"SIMenuScene Initialized: loaded in %0.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
    }
    
    return menuScene;
}

- (SIFallingMonkeyScene *)loadFallingMonkeyScene {
    NSDate *startDate                           = [NSDate date];
    
    SIFallingMonkeyScene *newScene              = [[SIFallingMonkeyScene alloc] initWithSize:_sceneSize];
    
    /*This will init the first monkey node!*/
    [SIGameController SISpriteNodeFallingMonkey];
    
    newScene.adBannerNode                       = _adBannerNode;
    
    if (_verbose) {
        NSLog(@"SIFallingMonkeyScene Initialized: loaded in %0.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
    }
    
    return newScene;
}

- (HLMenuNode *)SIHLMenuNodeSceneMenuSettings:(CGSize)size {
    
    HLMenuNode *menuNode                            = [[HLMenuNode alloc] init];
    //    _menuNode.delegate                              = self;
    menuNode.itemAnimation                         = HLMenuNodeAnimationSlideLeft;
    menuNode.itemAnimationDuration                 = SCENE_TRANSISTION_DURATION_FAST;
    menuNode.itemButtonPrototype                   = [SIGameController SILabelButtonMenuPrototypeBasic:[SIGameController SIButtonSize:size]];
    menuNode.backItemButtonPrototype               = [SIGameController SILabelButtonMenuPrototypeBack:[SIGameController SIButtonSize:size]];
    menuNode.itemSeparatorSize                     = [SIGameController SIMenuButtonSpacing];
    
    HLMenu *menu = [[HLMenu alloc] init];
    
    /*Add the regular buttons*/
    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextSettingsResetHighScore]];
    
    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextSettingsBugReport]];
    
    _sceneSettingsMenuItemTextSoundBackground = [[NSUserDefaults standardUserDefaults] boolForKey:kSINSUserDefaultSoundIsAllowedBackground] ? kSIMenuTextSettingsToggleSoundOffBackground : kSIMenuTextSettingsToggleSoundOnBackground;
    [menu addItem:[HLMenuItem menuItemWithText:_sceneSettingsMenuItemTextSoundBackground]];
    
    _sceneSettingsMenuItemTextSoundFX = [[NSUserDefaults standardUserDefaults] boolForKey:kSINSUserDefaultSoundIsAllowedFX] ? kSIMenuTextSettingsToggleSoundOffFX : kSIMenuTextSettingsToggleSoundOnFX;
    [menu addItem:[HLMenuItem menuItemWithText:_sceneSettingsMenuItemTextSoundFX]];
    
    [menuNode setMenu:menu animation:HLMenuNodeAnimationNone];
    
    return menuNode;
}

/**
 Call when ever you want... just know that this could cause a delay in scene transistion
    Honestly it might be better to just check individual components befor animating each of them in
    That way we isolate potential screen hangups because one node had to load...
 */
//- (BOOL)verifySceneGame {
//    if (_sceneGame == nil) {
//        _sceneGame = [[SIGameScene alloc] initWithSize:_sceneSize];
//    }
//    if (_sceneGamePopupContinue == nil) {
//        _sceneGamePopupContinue = [SIGameController SIPopupSceneGameContinue];
//    }
//    if (_sceneGamePopupContinueMenuNode == nil) {
//        _sceneGamePopupContinueMenuNode = [SIGameController SIMenuNodeSceneGamePopup:_sceneGamePopupContinue];
//    }
//    if (_sceneGameToolbarPowerUp == nil) {
//        _sceneGameToolbarPowerUp = [SIGameController SIHLToolbarGamePowerUpToolbarSize:_sceneGameToolbarSize toolbarNodeSize:_sceneGameToolbarNodeSize horizontalSpacing:_sceneGameSpacingHorizontalToolbar];
//    }
//    if (_sceneGameRingNodePause == nil) {
//        _sceneGameRingNodePause = [SIGameController SIHLRingNodeSceneGamePause];
//    }
//    return YES;
//}

#pragma mark -
#pragma mark - Accessors Methods
#pragma mark Visual Help
- (void)showFPS:(BOOL)showFPS {
    SKView * skView         = (SKView *)self.view;
    skView.showsFPS         = showFPS;
    skView.showsNodeCount   = showFPS;
}

/**
 Called when you need a new move score label and such
 */
+ (BMGlyphLabel *)moveScoreLabel:(float)score {
    return [BMGlyphLabel labelWithText:[NSString stringWithFormat:@"%0.2f",score] font:[SIGameController BMGFontUltraStroked]];
}
+ (BMGlyphLabel *)moveCommandLabelWithText:(NSString *)text {
    return [BMGlyphLabel labelWithText:text font:[SIGameController BMGFontLongIslandStroked]];
}

/**
 Simply type casts the current view
 */
- (SKView *)fastSKView {
    return (SKView *)self.view;
}

#pragma mark Game Center
- (void)authenticateLocalPlayer {
    GKLocalPlayer *localPlayer = [[GKLocalPlayer alloc] init];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        } else {
            if ([GKLocalPlayer localPlayer].authenticated) {
                if (_verbose) {
                    NSLog(@"Player Authenticated with Game Center");
                }
            } else {
                if (_verbose) {
                    NSLog(@"Player Failed to Authenticate with Game Center");
                }
            }
        }
    };
    

}
- (void)gameCenterViewControllerDidFinish:(nonnull GKGameCenterViewController *)gameCenterViewController {
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)showGameCenterLeaderBoard {
    GKGameCenterViewController *gameCenterVC    = [[GKGameCenterViewController alloc] init];
    gameCenterVC.gameCenterDelegate             = self;
    gameCenterVC.viewState                      = GKGameCenterViewControllerStateLeaderboards;

    NSNumber *gameMode = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultGameMode];
    if (gameMode) {
        if ([gameMode integerValue] == 0) { /*One hand mode*/
            gameCenterVC.leaderboardIdentifier = kSIGameCenterLeaderBoardIDHandOne;
        } else {
            gameCenterVC.leaderboardIdentifier = kSIGameCenterLeaderBoardIDHandTwo;
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setInteger:SIGameModeTwoHand forKey:kSINSUserDefaultGameMode];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self presentViewController:gameCenterVC animated:YES completion:nil];
}
#pragma mark Banner Ads

- (void)configureBannerAds {


    if (_verbose) {
        NSLog(@"User is premium: %@",_premiumUser ? @"YES" : @"NO");
    }
    
    if (_premiumUser) {
        self.canDisplayBannerAds    = NO;
    } else {
        _adBannerView               = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        CGFloat bannerViewHeight    = _adBannerView.bounds.size.height;
        _adBannerView.frame         = CGRectMake(0.0f, _sceneSize.height + bannerViewHeight, 0.0f, 0.0f);
//        _adBannerView.hidden        = YES;
        _adBannerView.alpha         = 0.0f;
        [self.view addSubview:_adBannerView];
        self.canDisplayBannerAds    = NO;
        _adBannerView.delegate      = self;
        _adBannerView.hidden        = YES; /*hide till loaded!*/
    }
}
- (void)removeBannerAds {
    BOOL isPremiumUser = [[NSUserDefaults standardUserDefaults] boolForKey:kSINSUserDefaultPremiumUser];
    if (isPremiumUser == NO) {
        self.canDisplayBannerAds = NO;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSINSUserDefaultPremiumUser];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (_verbose) {
            NSLog(@"Banner Ads Hidden.");
        }
    }
    _sceneMenu.toolBarBottom = [SIGameController SIHLToolbarMenuStartScene:[SIGameController SIToolbarSceneMenuSize:_sceneSize] isPremiumUser:_premiumUser];
}

#pragma mark Interstitial Ads
- (void)interstitialAdCycle {
    _interstitialAd                     = [[ADInterstitialAd alloc] init];
    _interstitialAd.delegate            = self;
}
- (void)interstitialAdClose {
    
    [_placeHolderView removeFromSuperview];
    [_closeButton removeFromSuperview];
    
    _interstitialAd = nil;
    [self interstitialAdCycle];
    
    _numberOfAdsToWatch =   _numberOfAdsToWatch - 1;
    
    if (_interstitialAdPresentationIsLive) {
        if (_numberOfAdsToWatch <= 0) {
            _interstitialAdPresentationIsLive = NO;
            [[SISingletonGame singleton] singletonGameWillResumeAndContinue:YES];
        } else {
            [self interstitialAdPresent];
        }
        
    }
}
/**
 Called to present a full screen .. full screen ads!
 */
- (void)interstitialAdPresent {
    if (_interstitialAd.loaded) {
        _placeHolderView    = [[UIView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:_placeHolderView];
        
        _closeButton        = [[UIButton alloc] initWithFrame:CGRectMake(25, 25, self.view.frame.size.width / 6.0f, self.view.frame.size.width / 6.0f)];
        [_closeButton setBackgroundImage:[UIImage imageNamed:kSIImageButtonCross] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(interstitialAdClose) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_closeButton];
        
        [_interstitialAd presentInView:_placeHolderView];
    } else {
        if (_placeHolderView) {
            [self interstitialAdClose];
        }
    }
}

#pragma mark Hud Methods
- (void)hudWillShow:(NSNotification *)notification {
    BOOL willDimBackground;
    BOOL willAnimate;
    
    NSDictionary *userInfo                      = notification.userInfo;
    
    NSString *titleString                       = [userInfo objectForKey:kSINSDictionaryKeyHudMessagePresentTitle];
    NSString *infoString                        = [userInfo objectForKey:kSINSDictionaryKeyHudMessagePresentInfo];
    
    NSNumber *dimBackground                     = (NSNumber *)[userInfo objectForKey:kSINSDictionaryKeyHudWillDimBackground];
    if (dimBackground) {
        willDimBackground                       = [dimBackground boolValue];
    } else { /*By Default Dim Background*/
        willDimBackground                       = YES;
    }
    
    NSNumber *animate                           = (NSNumber *)[userInfo objectForKey:kSINSDictionaryKeyHudWillAnimate];
    if (animate) {
        willAnimate                             = [animate boolValue];
    } else { /*By Default Animate*/
        willAnimate                             = YES;
    }
    
    MBProgressHUD *hud                          = [MBProgressHUD showHUDAddedTo:self.view animated:willAnimate];
    hud.detailsLabelText                        = titleString;
    hud.dimBackground                           = willDimBackground;
    hud.labelText                               = infoString;
    hud.mode                                    = MBProgressHUDModeIndeterminate;
    _hud                                        = hud;
}
- (void)hudWillShowWithTitle:(NSString *)title info:(NSString *)info dimBackground:(BOOL)dimBackground animate:(BOOL)animate {
    MBProgressHUD *hud                          = [MBProgressHUD showHUDAddedTo:self.view animated:animate];
    hud.detailsLabelText                        = title;
    hud.dimBackground                           = dimBackground;
    hud.labelText                               = info;
    hud.mode                                    = MBProgressHUDModeIndeterminate;
    _hud                                        = hud;
}
- (void)hudWillHide:(NSNotification *)notification {
    BOOL willAnimate;
    BOOL willShowCheckMark;
    
    NSDictionary *userInfo                      = notification.userInfo;
    
    NSString *titleString                       = [userInfo objectForKey:kSINSDictionaryKeyHudMessagePresentTitle];
    NSString *infoString                        = [userInfo objectForKey:kSINSDictionaryKeyHudMessagePresentInfo];
    
    NSNumber *showCheckMark                     = (NSNumber *)[userInfo objectForKey:kSINSDictionaryKeyHudWillShowCheckmark];
    if (showCheckMark) {
        willShowCheckMark                       = [showCheckMark boolValue];
    } else { /*By Default Dim Background*/
        willShowCheckMark                       = YES;
    }
    
    NSNumber *animate                           = (NSNumber *)[userInfo objectForKey:kSINSDictionaryKeyHudWillAnimate];
    if (animate) {
        willAnimate                             = [animate boolValue];
    } else { /*By Default Animate*/
        willAnimate                             = YES;
    }
    
    NSNumber *holdDuration                      = (NSNumber *)[userInfo objectForKey:kSINSDictionaryKeyHudWillAnimate];
    if (holdDuration) {
        /*Do Nothing*/
    } else { /*By Default Don't Hold*/
        holdDuration                            = [NSNumber numberWithFloat:0.0];
    }
    
    if (willShowCheckMark) {
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud-checkmark"]];
    }
    _hud.detailsLabelText                   = titleString;
    _hud.labelText                          = infoString;
    _hud.mode                               = MBProgressHUDModeCustomView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([holdDuration floatValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_hud hide:willAnimate];
    });
}
- (void)hudWillHideWithTitle:(NSString *)title info:(NSString *)info willShowCheckMark:(BOOL)willShowCheckMark holdDuration:(float)holdDuration animate:(BOOL)animate {
    if (willShowCheckMark) {
        _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud-checkmark"]];
    }
    _hud.detailsLabelText                   = title;
    _hud.labelText                          = info;
    _hud.mode                               = MBProgressHUDModeCustomView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(holdDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_hud hide:animate];
    });
}

#pragma mark Popup Setups
- (SIPopupNode *)initalizePopupFreePrize {
    SIPopupNode *popupNode = [SIGameController SIPopupSceneMenuFreePrize];
    
    popupNode.delegate = self;
    
    HLLabelButtonNode *bottomButtonNode = [SIGameController SIHLButtonClaimFreePrizeSize:CGSizeMake(popupNode.backgroundSize.width / 2.0f, popupNode.backgroundSize.width / 4.0f)];
    
    [bottomButtonNode hlSetGestureTarget:[HLTapGestureTarget tapGestureTargetWithHandleGestureBlock:^(UIGestureRecognizer *gestureRecognizer) {
        [self launchCoinsForDailyFreePrize];
    }]];
    [_sceneMenu registerDescendant:bottomButtonNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    
    popupNode.bottomNode = bottomButtonNode;
    
    return popupNode;
}


#pragma mark Daily Free Prize
/**
 Compares a time from the internet to determine if should give a daily prize
 */
- (SIFreePrizeType)checkForDailyPrize {
    
    NSDate *currentDate = [SIGameController getDateFromInternet];
    if (!currentDate) {
        return SIFreePrizeTypeNone;
    }
    
    NSDate *lastPrizeGivenDate = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultLastPrizeAwardedDate];
    //First time ever giving a prize
    if (!lastPrizeGivenDate) {
        [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:kSINSUserDefaultLastPrizeAwardedDate];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return SIFreePrizeTypeFirst;
        
    } else {
        //Consecutive Launch
        NSTimeInterval timeSinceLastLaunch = [currentDate timeIntervalSince1970] - [lastPrizeGivenDate timeIntervalSince1970];
        if (timeSinceLastLaunch > SECONDS_IN_DAY && timeSinceLastLaunch < 2 * SECONDS_IN_DAY) { /*Consecutive launch!!! > 24 < 48*/ //(timeSinceLastLaunch > 60 * 2 && timeSinceLastLaunch < 2 * 60 * 2) {
            return SIFreePrizeTypeConsecutive;
            
        //Non consecutive launch
        } else if (timeSinceLastLaunch > 2 * SECONDS_IN_DAY) { /*Non consecutive launch.... two days have passed..*/ //(timeSinceLastLaunch > 2 * 60 * 2) {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kSINSUserDefaultNumberConsecutiveAppLaunches];
            return SIFreePrizeTypeNonConsecutive;
            
        //no prize
        } else {
            return SIFreePrizeTypeNone;
        }
    }
}

- (void)launchCoinsForDailyFreePrize {
    [self launchCoins:[SIIAPUtility getDailyFreePrizeAmount] coinsLaunched:0];
    _sceneMenu.popupNode.bottomNode = nil;
}

- (void)launchCoins:(int)totalCoins coinsLaunched:(int)coinsLaunched {
    if (coinsLaunched == totalCoins) {
        [self finishPrize];
    } else {
        if ([SIConstants isFXAllowed]) {
            [[SoundManager sharedManager] playSound:kSISoundFXChaChing];
        }
        _sceneMenuPopupContentFreePrize.labelNode.text = [NSString stringWithFormat:@"%d",totalCoins - coinsLaunched];
        [_sceneMenuPopupFreePrize launchNode:[SIGameController SISpriteNodeCoinLargeFront]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(((CGFloat)(totalCoins - coinsLaunched) / (CGFloat)totalCoins) / 2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self launchCoins:totalCoins coinsLaunched:coinsLaunched + 1];
        });
    }
}

- (void)finishPrize {
    if ([SIConstants isFXAllowed]) {
        [[SoundManager sharedManager] playSound:kSISoundFXChaChing];
    }
    _sceneMenuPopupContentFreePrize.labelNode.text = @"0";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDate *currentDate = [SIIAPUtility getDateFromInternet];
        if (currentDate) {
            [[MKStoreKit sharedKit] addFreeCredits:[NSNumber numberWithInt:[SIIAPUtility getDailyFreePrizeAmount]] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
            
            [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:kSINSUserDefaultLastPrizeAwardedDate];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        [SIIAPUtility increaseConsecutiveDaysLaunched];
        _sceneMenu.popupNode = nil;
    });
}

#pragma mark -
#pragma mark - Delegate Handlers
#pragma mark SISingletonGameDelegate

/**
 Called when the model is ready for a new move to be
 loaded by the controller to the view
 */
- (void)controllerSingletonGameLoadNewMove {
    BMGlyphLabel *moveLabel = [SIGameController moveScoreLabel:[SISingletonGame singleton].currentGame.moveScore];
    moveLabel.position = [SISingletonGame singleton].currentGame.currentMove.touchPoint;
    
    
    
    SIMove *moveForBackground = [SISingletonGame singleton].currentGame.currentMove;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[SISingletonAchievement singleton] singletonAchievementWillProcessMove:moveForBackground];
    });
    
    _sceneGame.backgroundColor = [SISingletonGame singleton].currentGame.currentBackgroundColor;
    _sceneGame.scoreTotalLabel.text = [NSString stringWithFormat:@"%0.2f",[SISingletonGame singleton].currentGame.totalScore];
    _sceneGame.progressBarFreeCoin.progress = [SISingletonGame singleton].currentGame.freeCoinPercentRemaining;
    [_sceneGame sceneGameWillShowMoveScore:moveLabel];
    [_sceneGame sceneGameLaunchMoveCommandLabelWithCommandAction:moveForBackground.moveCommandAction];
    _sceneGame.moveCommandLabel = [SIGameController moveCommandLabelWithText:[SIGame stringForMove:[SISingletonGame singleton].currentGame.currentMove.moveCommand]];

}

/**
 Called when the user should be prompted to continue
 the game
 */
- (void)controllerSingletonGameShowContinue {
    if ([SIIAPUtility canAffordContinue:[SISingletonGame singleton].currentGame.currentContinueLifeCost]) {
        _sceneGamePopupMenuItemTextContinueWithCoin     = [NSString stringWithFormat:@"Use %d Coins!",(int)[SIGame lifeCostForNumberOfTimesContinued:[SISingletonGame singleton].currentGame.currentNumberOfTimesContinued]];
        [[[_sceneGamePopupContinueMenuNode menu] itemAtIndex:SISceneGamePopupContinueMenuItemCoin] setText:_sceneGamePopupMenuItemTextContinueWithCoin];
    }
    
    _sceneGamePopupMenuItemTextContinueWithAd           = [NSString stringWithFormat:@"Watch %d Ads!",(int)(int)[SIGame adCountForNumberOfTimesContinued:[SISingletonGame singleton].currentGame.currentNumberOfTimesContinued]];
    [[[_sceneGamePopupContinueMenuNode menu] itemAtIndex:SISceneGamePopupContinueMenuItemAd] setText:_sceneGamePopupMenuItemTextContinueWithAd];
    
    [_sceneGamePopupContinueMenuNode redisplayMenuAnimation:HLMenuNodeAnimationNone];
    
    /*Configure mwnu on popup*/
    _sceneGamePopupContinueMenuNode.delegate            = self;
    [_sceneGamePopupContinueMenuNode hlSetGestureTarget:_sceneGamePopupContinueMenuNode];
    [_sceneGame registerDescendant:_sceneGamePopupContinueMenuNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    
    /*configure the popup*/
    _sceneGamePopupContinue.delegate                    = self;
    _sceneGamePopupContinue.popupContentNode            = _sceneGamePopupContinueMenuNode;
    [_sceneGamePopupContinue hlSetGestureTarget:_sceneGamePopupContinue];
    [_sceneGame registerDescendant:_sceneGamePopupContinue withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    
    /*This is all you need to set to make the game scene display a popup because it will relayout the z*/
    _sceneGame.popupNode                                = _sceneGamePopupContinue;
}

/**
 Called when there is a high score
 */
- (void)controllerSingletonGameShowIsHighScore {
    [_sceneGame sceneGameShowHighScore];
}

/**
 Called when a free coin is earned
 Handle the sound for this in the controller?
 */
- (void)controllerSingletonGameShowFreeCoinEarned {
    [_sceneGame sceneGameShowFreeCoinEarned];
}

/**
 Called by model to alert controller when sound is ready to be played...
 */
- (void)controllerSingletonGamePlayFXSoundNamed:(NSString *)soundName {
    if ([SIConstants isFXAllowed]) {
        [[SoundManager sharedManager] playSound:soundName];
    }
}

/**
 Called when the model is ready for the powerup to start
 */
- (void)controllerSingletonGameActivatePowerUp:(SIPowerUpType)powerUp {
    switch (powerUp) {
        case SIPowerUpTypeFallingMonkeys:
            /*pause the singleton*/
            [[SISingletonGame singleton] singletonGameWillPause];
            /*launch the other scene with no delay*/
            [self presentScene:SIGameControllerSceneFallingMonkey];
            break;
        case SIPowerUpTypeRapidFire:
            /*Bring out progress bar*/
            
            /*Activate Fire Emmiters*/
            break;
        case SIPowerUpTypeTimeFreeze:
            /*Bring out progress bar*/
            
            /*Avtivate snow*/
            break;
        default: //SIPowerUpTypeNone
            NSLog(@"Error");
            break;
    }
}

/**
 Called when the powerup is deactived
 */
- (void)controllerSingletonGameDeactivatePowerUp:(SIPowerUpType)powerUp {
    switch (powerUp) {
        case SIPowerUpTypeFallingMonkeys:
            /*pause the singleton*/
            [self presentScene:SIGameControllerSceneGame];
            /*launch the other scene with no delay*/
            
            break;
        case SIPowerUpTypeRapidFire:
            /*Hide Progress Barr*/
            
            /*Remove Fire Emmiter*/
            break;
        case SIPowerUpTypeTimeFreeze:
            /*Hide Progress Barr*/
            
            /*Deactivate Snow Emitter*/
            break;
        default: //SIPowerUpTypeNone
            NSLog(@"Error");
            break;
    }
}

#pragma mark SISingletonAchievement
/**
 Called when challenge was complete
 */
- (void)controllerSingletonAchievementDidCompleteAchievement:(SIAchievement *)achievement {
    NSString *message = [NSString stringWithFormat:@"%@ %d %@",achievement.details.prefixString,[SISingletonAchievement amountForAchievementLevel:achievement.currentLevel forAchievement:achievement],achievement.details.postfixString];
    [JCNotificationCenter enqueueNotificationWithTitle:@"Achievement Completed" message:message tapHandler:^{
        NSLog(@"Tacos!!!!!");
    }];
}

/**
 Called when singleton is unable to pull from internet for sync
 */
- (void)controllerSingletonAchievementFailedToReachGameCenterWithError:(NSError *)error {
    [JCNotificationCenter enqueueNotificationWithTitle:@"Dang!" message:@"Can't connect to game center" tapHandler:^{
        NSLog(@"Tacos!!!!! hehe");
    }];
}

#pragma mark SIGameSceneDelegate
/**
 Called when the scene recognizes a gesture
 Pinch, Tap, Swype of Shake
 */
- (void)controllerSceneGameDidRecieveMove:(SIMove *)move {
    [[SISingletonGame singleton] singletonGameDidEnterMove:move];
}

/**
 Fires when the pause button is pressed
 */
- (void)controllerSceneGamePauseButtonTapped {
    [[SISingletonGame singleton] singletonGameWillPause];
    _sceneGame.blurScreen = YES;
    _sceneGame.ringNode = _sceneGameRingNodePause;
}

///**
// Fires after the continue meny node has been pressed...
// If coins -> PayMethod - Coin
// If ads   -> PayMethod - Ads
// If no    -> PayMethod - User is not going to pay for this shit...
// */
//- (void)controllerSceneGameWillDismissPopupContinueWithPayMethod:(SISceneGamePopupContinueMenuItem)continuePayMethod {
//    switch (continuePayMethod) {
//        case SISceneGamePopupContinueMenuItemCoin:
//            if ([SIIAPUtility canAffordContinue:[SISingletonGame singleton].currentGame.currentContinueLifeCost]) {
//                [[MKStoreKit sharedKit] consumeCredits:[NSNumber numberWithInt:[SISingletonGame singleton].currentGame.currentContinueLifeCost] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
//            } else {
//                [[SISingletonGame singleton] singletonGameWillResumeAndContinue:YES];
//            }
//            break;
//        case SISceneGamePopupContinueMenuItemAd:
//            _interstitialAdPresentationIsLive = YES;
//            [self interstitialAdPresent];
//            break;
//        default: //SIPowerUpPayMethodNo
//            [[SISingletonGame singleton] singletonGameDidEnd];
//            break;
//    }
//}



/**
 Powerup tool bar was tapped
 */
- (void)controllerSceneGameToolbar:(HLToolbarNode *)toolbar powerUpWasTapped:(SIPowerUpType)powerUp {
    if ([SISingletonGame singleton].currentGame.isPaused == NO) {
        [[SISingletonGame singleton] singletonGameWillActivatePowerUp:powerUp];
    }
}

/**
 This is called on every update... So it gets called a ton!
 */
- (SISceneGameProgressBarUpdate *)controllerSceneGameWillUpdateProgressBars {
    SISceneGameProgressBarUpdate *progressBarUpdate = [[SISceneGameProgressBarUpdate alloc] init];
    
    progressBarUpdate.percentMove                   = [SISingletonGame singleton].currentGame.moveScorePercentRemaining;
    progressBarUpdate.percentPowerUp                = [SISingletonGame singleton].currentGame.powerUpPercentRemaining;
    progressBarUpdate.pointsMove                    = [SISingletonGame singleton].currentGame.currentPointsRemainingThisRound;
    
    return progressBarUpdate;
}

#pragma mark ADBannerViewDelegate
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (_verbose) {
        NSLog(@"Error [loading bannder ad]: %@",error.localizedDescription);
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    _adBannerView.alpha                 = 0.0f;
    [UIView commitAnimations];
}
-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (_verbose) {
        NSLog(@"Banner Hidden?: %@",_adBannerView.hidden ? @"YES" : @"NO");
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    _adBannerView.alpha                 = 1.0f;
    [UIView commitAnimations];
}
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    if (willLeave) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSINotificationAdActionShouldBegin object:nil];
    }
    return YES;
}
- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    [[NSNotificationCenter defaultCenter] postNotificationName:kSINotificationAdActionDidFinish object:nil];
}
- (void)bannerAdShow {
    _adBannerView.hidden                = NO;
    CGFloat bv                          = _adBannerView.bounds.size.height;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSINotificationAdBannerDidLoad object:nil];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    _adBannerView.frame                 = CGRectMake(0.0f, _sceneSize.height - bv, 0.0f, 0.0f);
    [UIView commitAnimations];
}

- (void)bannerAdHide {
    _adBannerView.hidden                = YES;
    CGFloat bv                          = _adBannerView.bounds.size.height;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSINotificationAdBannerDidUnload object:nil];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    _adBannerView.frame = CGRectMake(0.0f, _sceneSize.height + bv, 0.0f, 0.0f);
    [UIView commitAnimations];
}

#pragma mark ADInterstitialViewDelegate methods

/**
 When this method is invoked, the application should remove the view from the screen and tear it down.
 The content will be unloaded shortly after this method is called and no new content will be loaded in that view.
 This may occur either when the user dismisses the interstitial view via the dismiss button or
 if the content in the view has expired.
 */
- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd
{
    if (_placeHolderView) {
        [self interstitialAdClose];
    }
}

/**
 This method will be invoked when an error has occurred attempting to get advertisement content.
 The ADError enum lists the possible error codes.
 */
- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    NSLog(@"Error [interstitialAd] (CODE: %d) : %@",(int)error.code,error.localizedDescription);
    if (error.code != ADErrorServerFailure && error.code != 7) {
        [self interstitialAdClose];
    }
    
}

#pragma mark SIMenuSceneDelegate
/**
 Called right after a new scene has been loaded... essentially
 notifies that the scene is ready to animate in the buttons and
 such
 */
- (void)sceneMenuDidLoadType:(SISceneMenuType)type {
    switch (type) {
        case SISceneMenuTypeStart:
            switch ([self checkForDailyPrize]) {
                case SIFreePrizeTypeNone:
                    break;
                default:
                    _sceneMenuPopupContentFreePrize.labelNode.text = [NSString stringWithFormat:@"%d",[SIIAPUtility getDailyFreePrizeAmount]];
                    _sceneMenu.popupNode = _sceneMenuPopupFreePrize;
                    _sceneMenuPopupFreePrize.delegate = self;
                    break;
            }
            break;
            
        default:
            break;
    }
}

#pragma mark SIFallingMonkeyDelegate
/**
 Called when the scene registers a monkey tap
 */
- (void)sceneFallingMonkeyWasTappedMonkey:(SKNode *)monkey {
    SIMove *moveFallingMonkey        = [[SIMove alloc] init];
    
    moveFallingMonkey.moveCommand    = SIMoveCommandFallingMonkey;
    
    [[SISingletonGame singleton] singletonGameDidEnterMove:moveFallingMonkey];
}

/**
 Called when a monkey has hit the bottom of the screen
 */
- (void)sceneFallingMonkeyDidCollideWithBottomEdge {
    SIPowerUp *powerUp = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeFallingMonkeys atTime:0.0f];
    [[SISingletonGame singleton] singletonGameWillDectivatePowerUp:powerUp];
}

#pragma mark HLGridNodeDelegate
- (void)gridNode:(HLGridNode *)gridNode didTapSquare:(int)squareIndex {
    NSLog(@"node at index %d tapped",squareIndex);
    switch (squareIndex) {
        case 0: //Launch Classic `SIGameModeTwoHand`
            [self presentSceneMenuType:SISceneMenuTypeNone inDelay:0.0f];
            [SISingletonGame singleton].currentGame.gameMode = SIGameModeTwoHand;
            [self controllerSingletonGameLoadNewMove];
            [self presentScene:SIGameControllerSceneGame];
            break;
        case 1: //Launch One Hand `SIGameModeOneHand`
            [self presentSceneMenuType:SISceneMenuTypeNone inDelay:0.0f];
            [SISingletonGame singleton].currentGame.gameMode = SIGameModeOneHand;
            [self controllerSingletonGameLoadNewMove];
            [self presentScene:SIGameControllerSceneGame];
            break;
        default:
            [self presentSceneMenuType:SISceneMenuTypeStore inDelay:0.0f];
            break;
    }
}

#pragma mark HLMenuNodeDelegate
- (void)menuNode:(HLMenuNode *)menuNode didTapMenuItem:(HLMenuItem *)menuItem itemIndex:(NSUInteger)itemIndex {
    if (menuNode == _sceneGamePopupContinueMenuNode) {
        if ([menuItem.text isEqualToString:_sceneGamePopupMenuItemTextContinueWithCoin]) {
            if ([SIIAPUtility canAffordContinue:[SISingletonGame singleton].currentGame.currentContinueLifeCost]) {
                [[MKStoreKit sharedKit] consumeCredits:[NSNumber numberWithInt:[SISingletonGame singleton].currentGame.currentContinueLifeCost] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
            } else {
                [[SISingletonGame singleton] singletonGameWillResumeAndContinue:YES];
            }
            
        }  else if ([menuItem.text isEqualToString:_sceneGamePopupMenuItemTextContinueWithAd]) {
            _interstitialAdPresentationIsLive = YES;
            [self interstitialAdPresent];
            
        } else if ([menuItem.text isEqualToString:kSIMenuTextPopUpEndGame]) {
            [[SISingletonGame singleton] singletonGameDidEnd];
        }
    }
}

#pragma mark HLToolBarNodeDelegate
- (void)toolbarNode:(HLToolbarNode *)toolbarNode didTapTool:(NSString *)toolTag {
    if (toolbarNode == _sceneGameToolbarPowerUp) {
        if ([SISingletonGame singleton].currentGame.isPaused == NO) {
            [[SISingletonGame singleton] singletonGameWillActivatePowerUp:[SIPowerUp powerUpForString:toolTag]];
        }
    } else if (toolbarNode == _sceneMenuToolbarStart) {
        if ([_sceneMenu modalNodePresented]) {
            [_sceneMenu dismissModalNodeAnimation:HLScenePresentationAnimationFade];
            return;
        }
        if ([toolTag isEqualToString:kSINodeButtonLeaderBoard]) {
            NSLog(@"Leaderboard Toolbar Button Tapped");
            NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationShowLeaderBoard object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
        } else if ([toolTag isEqualToString:kSINodeButtonNoAd]) {
            [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:kSIIAPProductIDAdFree];
            NSLog(@"Ad Free Toolbar Button Tapped");
            
        } else if ([toolTag isEqualToString:kSINodeButtonSettings]) {
            SettingsScene *settingsScene    = [SettingsScene sceneWithSize:self.size];
            SIGame transisitionToSKScene:settingsScene toSKView:self.view DoorsOpen:YES pausesIncomingScene:YES pausesOutgoingScene:YES duration:SCENE_TRANSISTION_DURATION];
            
        } else if ([toolTag isEqualToString:kSINodeButtonInstructions]) {
            NSLog(@"Instructions Toolbar Button Tapped");
            [self launchHelp];
        } else if ([toolTag isEqualToString:kSINodeButtonAchievement]) {
            NSLog(@"Achievement Toolbar item tapped");
        }
    }
}


#pragma mark HLRingNodeDelegate
- (void)ringNode:(HLRingNode *)ringNode didTapItem:(int)itemIndex {
    switch (itemIndex) {
        case SISceneGameRingNodeEndGame:
            [[SISingletonGame singleton] singletonGameDidEnd];
            break;
        case SISceneGameRingNodePlay:
            [[SISingletonGame singleton] singletonGameWillResumeAndContinue:NO];
            break;
        case SISceneGameRingNodeSoundBackground:
            if ([SIConstants isBackgroundSoundAllowed]) {
                /*Turn Background Sound Off*/
                [[SoundManager sharedManager] stopMusic];
            } else {
                /*Turn Sound Background On*/
                [[SoundManager sharedManager] playMusic:kSISoundBackgroundMenu looping:YES fadeIn:YES];
            }
            [ringNode setHighlight:[SIConstants isBackgroundSoundAllowed] forItem:itemIndex];
            [[NSUserDefaults standardUserDefaults] setBool:![SIConstants isBackgroundSoundAllowed] forKey:kSINSUserDefaultSoundIsAllowedBackground];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case SISceneGameRingNodeSoundFX:
            /*Change Sound FX State*/
            if ([SIConstants isFXAllowed]) {
                /*Turn FX Sound Off*/
                [[SoundManager sharedManager] stopAllSounds];
            }
            [ringNode setHighlight:[SIConstants isFXAllowed] forItem:itemIndex];
            [[NSUserDefaults standardUserDefaults] setBool:![SIConstants isFXAllowed] forKey:kSINSUserDefaultSoundIsAllowedFX];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        default:
            NSLog(@"Ring Node item tapped out of bounds index error :/");
            break;
    }
}

#pragma mark SIPopupNodeDelegate
- (void)dismissPopup:(SIPopupNode *)popupNode {
    if (popupNode == _sceneMenuPopupFreePrize) {
        [_sceneMenu dismissModalNodeAnimation:HLScenePresentationAnimationFade];
    } else if (popupNode == _sceneGamePopupContinue) {
        [self presentScene:SIGameControllerSceneMenu];
    } else {
        HLScene *currentHLSceen = (HLScene *)_currentScene;
        [currentHLSceen dismissModalNodeAnimation:HLScenePresentationAnimationFade];
    }
}

#pragma mark AdBannerDelegate
- (void)adBannerWasTapped {
    NSLog(@"Ad banner was tapped");
}


#pragma mark -
#pragma mark - Class Functions
#pragma mark Floats
+ (CGFloat)SIAdBannerViewHeight {
    if ([SIGameController premiumUser]) {
        return 0.0f;
    }
    ADBannerView *tempAdBannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    return tempAdBannerView.bounds.size.height;
}
+ (CGFloat)SIFontSizeButton {
    if (IS_IPHONE_4) {
        return 22.0f;
    } else if (IS_IPHONE_5) {
        return 24.0f;
    } else if (IS_IPHONE_6) {
        return 28.0f;
    } else if (IS_IPHONE_6_PLUS) {
        return 32.0f;
    } else {
        return 36.0f;
    }
}

+ (CGFloat)SIFontSizeMoveCommand {
    if (IS_IPHONE_4) {
        return 40.0f;
    } else if (IS_IPHONE_5) {
        return 50.0f;
    } else if (IS_IPHONE_6) {
        return 60.0f;
    } else if (IS_IPHONE_6_PLUS) {
        return 70.0f;
    } else {
        return 100.0f;
    }
}
+ (CGFloat)SIFontSizeHeader {
    if (IS_IPHONE_4) {
        return 36.0f;
    } else if (IS_IPHONE_5) {
        return 40.0f;
    } else if (IS_IPHONE_6) {
        return 44.0f;
    } else if (IS_IPHONE_6_PLUS) {
        return 48.0f;
    } else {
        return 52.0f;
    }
}
+ (CGFloat)SIFontSizeHeader_x2 {
    return [SIGameController SIFontSizeHeader] + 4.0f;
}
+ (CGFloat)SIFontSizeHeader_x3 {
    return [SIGameController SIFontSizeHeader] + 8.0f;
}
+ (CGFloat)SIFontSizeParagraph {
    if (IS_IPHONE_4) {
        return 20.0f;
    } else if (IS_IPHONE_5) {
        return 24.0f;
    } else if (IS_IPHONE_6) {
        return 28.0f;
    } else if (IS_IPHONE_6_PLUS) {
        return 32.0f;
    } else {
        return 36.0f;
    }
}
+ (CGFloat)SIFontSizeParagraph_x2 {
    return [SIGameController SIFontSizeParagraph] + 4.0f;
}
+ (CGFloat)SIFontSizeParagraph_x3 {
    return [SIGameController SIFontSizeParagraph] + 8.0f;
}
+ (CGFloat)SIFontSizeParagraph_x4 {
    return [SIGameController SIFontSizeParagraph] + 12.0f;
}
+ (CGFloat)SIFontSizePopUp {
    if (IS_IPHONE_4) {
        return 26.0f;
    } else if (IS_IPHONE_5) {
        return 30.0f;
    } else if (IS_IPHONE_6) {
        return 32.0f;
    } else if (IS_IPHONE_6_PLUS) {
        return 36.0f;
    } else {
        return 42.0f;
    }
}
+ (CGFloat)SIFontSizeText {
    if (IS_IPHONE_4) {
        return 12.0f;
    } else if (IS_IPHONE_5) {
        return 13.0f;
    } else if (IS_IPHONE_6) {
        return 14.0f;
    } else if (IS_IPHONE_6_PLUS) {
        return 15.0f;
    } else {
        return 16.0f;
    }
}
+ (CGFloat)SIFontSizeText_x2 {
    return [SIGameController SIFontSizeText] + 2.0f;
}
+ (CGFloat)SIFontSizeText_x3 {
    return [SIGameController SIFontSizeText] + 4.0f;
}
+ (CGFloat)xPaddingPopupContinue {
    if (IS_IPHONE_4) {
        return 24.0f;
    } else if (IS_IPHONE_5) {
        return 28.0f;
    } else if (IS_IPHONE_6) {
        return 48.0f;
    } else if (IS_IPHONE_6_PLUS) {
        return 80.0f;
    } else {
        return 150.0f;
    }
}
+ (CGFloat)SIMenuButtonSpacing {
    if (IS_IPHONE_4) {
        return 16.0f;
        
    } else if (IS_IPHONE_5) {
        return 20.0f;
        
    } else if (IS_IPHONE_6) {
        return 24.0f;
        
    } else if (IS_IPHONE_6_PLUS) {
        return 28.0f;
        
    } else {
        return 30.0f;
        
    }
}
#pragma mark CGSizes
+ (CGSize)sceneSize {
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - [SIGameController SIAdBannerViewHeight]);
}
+ (CGSize)SIFallingMonkeySize {
    if (IS_IPHONE_4) {
        return CGSizeMake(100.0, 100.0);
        
    } else if (IS_IPHONE_5) {
        return CGSizeMake(130.0, 130.0);
        
    } else if (IS_IPHONE_6) {
        return CGSizeMake(150.0, 150.0);
        
    } else if (IS_IPHONE_6_PLUS) {
        return CGSizeMake(180.0, 180.0);
        
    } else {
        return CGSizeMake(200.0, 200.0);
        
    }
}
+ (CGSize)SIChestSize {
    return SCREEN_WIDTH > SCREEN_HEIGHT ? CGSizeMake(SCREEN_HEIGHT * 0.2f, SCREEN_HEIGHT * 0.2f) : CGSizeMake(SCREEN_WIDTH * 0.2f, SCREEN_WIDTH * 0.2f);
}
+ (CGSize)SIToolbarSceneMenuSize:(CGSize)size {
    if (IS_IPHONE_4) {
        return CGSizeMake(size.width, size.height * 0.15);
        
    } else if (IS_IPHONE_5) {
        return CGSizeMake(size.width, size.height * 0.15);
        
    } else if (IS_IPHONE_6) {
        return CGSizeMake(size.width, size.height * 0.15);
        
    } else if (IS_IPHONE_6_PLUS) {
        return CGSizeMake(size.width, size.height * 0.15);
        
    } else {
        return CGSizeMake(size.width, size.height * 0.15);
        
    }
}
+ (CGSize)SIProgressBarGameFreeCoinSize:(CGSize)size {
    return CGSizeMake(size.width / 8.0f, size.height / 4.0f);
}

+ (CGSize)SIProgressBarGameMoveSize:(CGSize)size {
    return CGSizeMake(size.width, size.height / 6.0f);
}

+ (CGSize)SIProgressBarGamePowerUpSize:(CGSize)size {
    return CGSizeMake([SIGameController SIProgressBarGameMoveSize:size].width, [SIGameController SIProgressBarGameMoveSize:size].height / 2.0f);
}
+ (CGSize)SIButtonSize:(CGSize)size {
    if (IS_IPHONE_4) {
        return CGSizeMake(size.width / 1.5f, size.width / 1.5f * 0.25f);
    } else if (IS_IPHONE_5) {
        return CGSizeMake(size.width / 1.4f, size.width / 1.4f * 0.25f);
    } else if (IS_IPHONE_6) {
        return CGSizeMake(size.width / 1.3f, size.width / 1.3f * 0.25f);
    } else if (IS_IPHONE_6_PLUS) {
        return CGSizeMake(size.width / 1.2f, size.width / 1.2f * 0.25f);
    } else {
        return CGSizeMake(size.width / 1.3f, size.width / 8.0f);
    }
}
#pragma mark Scene Transistions

+ (SKScene *)viewController:(SKView *)view transisitionToSKScene:(SKScene *)scene duration:(CGFloat)duration {
    SKTransition *transistion;
    
    transistion = [SKTransition fadeWithColor:[SKColor blackColor] duration:duration];
    
    [view presentScene:scene transition:transistion];
    
    return scene;
}

+ (SKScene *)transisitionZeroOpenToSKScene:(SKScene *)scene toSKView:(SKView *)view {
    SKTransition *transistion;
    
    transistion                     = [SKTransition doorsOpenHorizontalWithDuration:SCENE_TRANSISTION_DURATION_ZERO];
    
    transistion.pausesIncomingScene = NO;
    transistion.pausesOutgoingScene = NO;
    
    [view presentScene:scene transition:transistion];
    
    return scene;
}

+ (SKScene *)transisitionFastOpenToSKScene:(SKScene *)scene toSKView:(SKView *)view {
    SKTransition *transistion;
    
    transistion                     = [SKTransition doorsOpenHorizontalWithDuration:SCENE_TRANSISTION_DURATION_FAST];
    
    transistion.pausesIncomingScene = NO;
    transistion.pausesOutgoingScene = NO;
    
    [view presentScene:scene transition:transistion];
    
    return scene;
}

+ (SKScene *)transisitionNormalOpenToSKScene:(SKScene *)scene toSKView:(SKView *)view {
    SKTransition *transistion;
    
    transistion                     = [SKTransition doorsOpenHorizontalWithDuration:SCENE_TRANSISTION_DURATION_NORMAL];
    
    transistion.pausesIncomingScene = NO;
    transistion.pausesOutgoingScene = NO;
    
    [view presentScene:scene transition:transistion];
    
    return scene;
}

+ (SKScene *)transisitionToSKScene:(SKScene *)scene toSKView:(SKView *)view DoorsOpen:(BOOL)doorsOpen pausesIncomingScene:(BOOL)pausesIncomingScene pausesOutgoingScene:(BOOL)pausesOutgoingScene duration:(CGFloat)duration {
    SKTransition *transistion;
    
    if (doorsOpen) {
        transistion = [SKTransition doorsOpenHorizontalWithDuration:duration];
    } else {
        transistion = [SKTransition doorsCloseHorizontalWithDuration:duration];
    }
    
    transistion.pausesIncomingScene = pausesIncomingScene;
    transistion.pausesOutgoingScene = pausesOutgoingScene;
    
    [view presentScene:scene transition:transistion];
    
    return scene;
}
#pragma mark Ads
/**
 Reads from NSUserDefaults to see if user is premium
 There is nil return protection via setter
 */
+ (BOOL)premiumUser {
    NSNumber *premiumUserNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultPremiumUser];
    
    if (premiumUserNumber == nil) { //never ben set
        premiumUserNumber = [NSNumber numberWithBool:NO];
        [[NSUserDefaults standardUserDefaults] setObject:premiumUserNumber forKey:kSINSUserDefaultPremiumUser];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return [premiumUserNumber boolValue];
}

#pragma mark SKLabelNodes
+ (SKLabelNode *)SILabelHeader:(NSString *)text {
    SKLabelNode *label  = [SIGameController SILabelInterfaceFontSize:[SIGameController SIFontSizeHeader]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SILabelHeader_x2:(NSString *)text {
    SKLabelNode *label  = [SIGameController SILabelInterfaceFontSize:[SIGameController SIFontSizeHeader_x2]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SILabelHeader_x3:(NSString *)text {
    SKLabelNode *label  = [SIGameController SILabelInterfaceFontSize:[SIGameController SIFontSizeHeader_x3]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SILabelParagraph:(NSString *)text {
    SKLabelNode *label  = [SIGameController SILabelInterfaceFontSize:[SIGameController SIFontSizeParagraph]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SILabelParagraph_x2:(NSString *)text {
    SKLabelNode *label  = [SIGameController SILabelInterfaceFontSize:[SIGameController SIFontSizeParagraph_x2]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SILabelParagraph_x3:(NSString *)text {
    SKLabelNode *label  = [SIGameController SILabelInterfaceFontSize:[SIGameController SIFontSizeParagraph_x3]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SILabelParagraph_x4:(NSString *)text {
    SKLabelNode *label  = [SIGameController SILabelInterfaceFontSize:[SIGameController SIFontSizeParagraph_x4]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SILabelInterfaceFontSize:(CGFloat)fontSize {
    SKLabelNode *label                          = [SKLabelNode labelNodeWithFontNamed:kSIFontUltra];
    label.fontColor                             = [SKColor blackColor];
    label.fontSize                              = fontSize;
    label.horizontalAlignmentMode               = SKLabelHorizontalAlignmentModeCenter;
    label.verticalAlignmentMode                 = SKLabelVerticalAlignmentModeCenter;
    return label;
}
+ (SKLabelNode *)SILabelSceneGameMoveCommand {
    static SKLabelNode *moveLabel = nil;
    if (!moveLabel) {
        moveLabel = moveCommandLabelNode();
    }
    return moveLabel;
}
#pragma mark SKSpriteNodes
+ (SKSpriteNode *)SISpriteNodeFallingMonkey {
    static SKSpriteNode *monkey = nil;
    if (!monkey) {
        monkey                                      = [SKSpriteNode spriteNodeWithTexture:[SIGameController SITextureMonkeyFace]  size:[SIGameController SIFallingMonkeySize]];
        monkey.name                                 = kSINodeFallingMonkey;
        monkey.physicsBody                          = [SKPhysicsBody bodyWithCircleOfRadius:[SIGameController SIFallingMonkeySize].height / 2.0f];
        monkey.physicsBody.linearDamping            = 0.0f;
        monkey.userInteractionEnabled               = YES;
    }
    return monkey;
}
+ (SKSpriteNode *)SISpriteNodeCoinLargeFront {
    static SKSpriteNode *coinNode = nil;
    if (!coinNode) {
        coinNode                                    = coinNodeLargeFront();
    }
    return coinNode;
}
#pragma mark SKTextures
+ (SKTexture *)SITextureMonkeyFace {
    static SKTexture *monkeyFace = nil;
    if (!monkeyFace) {
        monkeyFace = monkeyFaceTexture();
    }
    return monkeyFace;
}

#pragma mark HLLabelButtons
+ (HLLabelButtonNode *)SILabelButtonMenuPrototypeBasic:(CGSize)size {
    HLLabelButtonNode *buttonPrototype;
    buttonPrototype                         = [[SIGameController SIHLLabelButtonInterface:size] copy];
    buttonPrototype.verticalAlignmentMode   = HLLabelNodeVerticalAlignFontAscenderBias;
    
    return buttonPrototype;
}
+ (HLLabelButtonNode *)SILabelButtonMenuPrototypeBasic:(CGSize)size backgroundColor:(SKColor *)backgroundColor fontColor:(UIColor *)fontColor {
    HLLabelButtonNode *buttonPrototype;
    buttonPrototype                         = [[SIGameController SIHLLabelButtonInterface:size backgroundColor:fontColor fontColor:fontColor] copy];
    buttonPrototype.verticalAlignmentMode   = HLLabelNodeVerticalAlignFontAscenderBias;
    
    return buttonPrototype;
}
+ (HLLabelButtonNode *)SIHLLabelButtonMenuPrototypeBack:(CGSize)size {
    HLLabelButtonNode *buttonPrototype;
    buttonPrototype                         =  [[SIGameController SIHLLabelButtonInterface:size] copy];;
    buttonPrototype.color                   = [UIColor blueColor];
    buttonPrototype.colorBlendFactor        = 1.0f;
    
    return buttonPrototype;
}
+ (HLLabelButtonNode *)SIHLLabelButtonMenuPopup:(CGSize)size {
    HLLabelButtonNode *buttonPrototype;
    buttonPrototype                         = [[SIGameController SIHLLabelButtonInterface:size] copy];
    buttonPrototype.verticalAlignmentMode   = HLLabelNodeVerticalAlignFontAscenderBias;
    buttonPrototype.color                   = [UIColor whiteColor];
    buttonPrototype.fontColor               = [SKColor blackColor];
    buttonPrototype.colorBlendFactor        = 1.0f;
    
    return buttonPrototype;
}
+ (HLLabelButtonNode *)SIHLLabelButtonInterface:(CGSize)size {
    HLLabelButtonNode *labelButton              = [[HLLabelButtonNode alloc] initWithColor:[UIColor mainColor] size:size];
    labelButton.cornerRadius                    = 12.0f;
    labelButton.fontName                        = kSIFontUltra; // kSIFontFuturaMedium;
    labelButton.fontSize                        = size.height * 0.33f;
    labelButton.borderWidth                     = 8.0f;
    labelButton.borderColor                     = [SKColor blackColor];
    labelButton.fontColor                       = [UIColor whiteColor];
    labelButton.verticalAlignmentMode           = HLLabelNodeVerticalAlignFont;
    return labelButton;
}
+ (HLLabelButtonNode *)SIHLLabelButtonInterface:(CGSize)size backgroundColor:(UIColor *)backgroundColor fontColor:(SKColor *)fontColor {
    HLLabelButtonNode *labelButton              = [[HLLabelButtonNode alloc] initWithColor:[SKColor orangeColor] size:size];
    labelButton.fontName                        = kSIFontUltra;
    labelButton.cornerRadius                    = 12.0f;
    labelButton.borderWidth                     = 8.0f;
    labelButton.borderColor                     = [SKColor blackColor];
    labelButton.fontSize                        = size.height * 0.33f;
    labelButton.fontColor                       = fontColor;
    labelButton.verticalAlignmentMode           = HLLabelNodeVerticalAlignFont;
    return labelButton;
}
+ (HLLabelButtonNode *)SIHLButtonClaimFreePrizeSize:(CGSize)buttonSize {
    HLLabelButtonNode *claimButton              = [[HLLabelButtonNode alloc] initWithColor:[SKColor redColor] size:buttonSize];
    claimButton.cornerRadius                    = 8.0f;
    claimButton.borderWidth                     = 8.0f;
    claimButton.borderColor                     = [SKColor blackColor];
    claimButton.text                            = @"CLAIM!";
    claimButton.fontColor                       = [SKColor whiteColor];
    claimButton.verticalAlignmentMode           = HLLabelNodeVerticalAlignFont;
    
}

#pragma mark HLMenuNodes
+ (HLMenuNode *)SIHLMenuNodeSceneGamePopup:(SIPopupNode *)popupNode {
    HLMenuNode *menuNode                = [[HLMenuNode alloc] init];
    menuNode.itemAnimation              = HLMenuNodeAnimationSlideLeft;
    menuNode.itemAnimationDuration      = SCENE_TRANSISTION_DURATION_FAST;
    menuNode.itemButtonPrototype        = [SIGameController SILabelButtonMenuPrototypePopUp:[SIGameController SIButtonSize:popupNode.backgroundSize]];
    menuNode.backItemButtonPrototype    = [SIGameController SILabelButtonMenuPrototypeBack:[SIGameController SIButtonSize:popupNode.backgroundSize]];
    menuNode.itemSeparatorSize          = 20;
    
    HLMenu *menu                        = [[HLMenu alloc] init];
    
//    if ([[AppSingleton singleton] canAffordContinue]) {
//        _costMenuItemText               = [NSString stringWithFormat:@"Use %ld Coins!",(long)[AppSingleton singleton].currentGame.currentContinueLifeCost];
//        [menu addItem:[HLMenuItem menuItemWithText:_costMenuItemText]];
//    } else {
//        [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextPopUpBuyCoins]];
//    }
    
    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextPopUpBuyCoins]];
    
    
    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextPopUpWatchAd]];
    
    /*Add the Back Button... Need to change the prototype*/
    HLMenuItem *endGameItem             = [HLMenuItem menuItemWithText:kSIMenuTextPopUpEndGame];
    endGameItem.buttonPrototype         = [SIGameController SILabelButtonMenuPrototypeBack:[SIGameController SIButtonSize:popupNode.backgroundSize]];
    [menu addItem:endGameItem];
    
    [menuNode setMenu:menu animation:HLMenuNodeAnimationNone];
    
    menuNode.position                   = CGPointMake(0.0f, 0.0f);
    
    if (popupNode) {
        popupNode.popupContentNode      = menuNode;
    }
    
    return menuNode;
}

+ (HLMenuNode *)SIHLMenuNodeSceneMenuStore:(CGSize)size {
    HLMenuNode *menuNode                = [[HLMenuNode alloc] init];
    menuNode.itemAnimation              = HLMenuNodeAnimationSlideLeft;
    menuNode.itemAnimationDuration      = SCENE_TRANSISTION_DURATION_FAST;
    menuNode.itemButtonPrototype        = [SIGameController SILabelButtonMenuPrototypePopUp:[SIGameController SIButtonSize:size]];
    menuNode.backItemButtonPrototype    = [SIGameController SILabelButtonMenuPrototypeBack:[SIGameController SIButtonSize:size]];
    menuNode.itemSeparatorSize          = 20;

    
    HLMenu *menu                        = [[HLMenu alloc] init];
    
    /*Add the regular buttons*/
    HLMenuItem *item1                   = [HLMenuItem menuItemWithText:[SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackExtraLarge]];
    item1.buttonPrototype               = [[SIStoreButtonNode alloc] initWithSize:[SIGameController SIButtonSize:size] buttonName:[SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackExtraLarge] SIIAPPack:SIIAPPackExtraLarge];
    
    HLMenuItem *item2                   = [HLMenuItem menuItemWithText:[SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackLarge]];
    item2.buttonPrototype               = [[SIStoreButtonNode alloc] initWithSize:[SIGameController SIButtonSize:size] buttonName:[SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackLarge] SIIAPPack:SIIAPPackLarge];
    
    HLMenuItem *item3                   = [HLMenuItem menuItemWithText:[SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackMedium]];
    item3.buttonPrototype               = [[SIStoreButtonNode alloc] initWithSize:[SIGameController SIButtonSize:size] buttonName:[SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackMedium] SIIAPPack:SIIAPPackMedium];
    
    HLMenuItem *item4                   = [HLMenuItem menuItemWithText:[SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackSmall]];
    item4.buttonPrototype               = [[SIStoreButtonNode alloc] initWithSize:[SIGameController SIButtonSize:size] buttonName:[SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackSmall] SIIAPPack:SIIAPPackSmall];
    
    [menu addItem:item4];
    [menu addItem:item3];
    [menu addItem:item2];
    [menu addItem:item1];
    
    [menuNode setMenu:menu animation:HLMenuNodeAnimationNone];
    
    return menuNode;
}
#pragma mark HLToolbars
+ (HLToolbarNode *)SIHLToolbarMenuStartScene:(CGSize)size isPremiumUser:(BOOL)isPremiumUser {
    HLToolbarNode *toolbarNode                  = [[HLToolbarNode alloc] init];
    toolbarNode.automaticHeight                 = NO;
    toolbarNode.automaticWidth                  = NO;
    toolbarNode.backgroundBorderSize            = 0.0f;
    toolbarNode.squareSeparatorSize             = 10.0f;
    toolbarNode.backgroundColor                 = [UIColor clearColor];
    toolbarNode.anchorPoint                     = CGPointMake(0.0f, 0.0f);
    toolbarNode.size                            = CGSizeMake(size.width, [SIGameController SIButtonSize:size].height);
    toolbarNode.squareColor                     = [SKColor clearColor];
    
    
    NSMutableArray *toolNodes                   = [NSMutableArray array];
    NSMutableArray *toolTags                    = [NSMutableArray array];
    
    [toolNodes  addObject:[SKSpriteNode spriteNodeWithTexture:[[SIConstants atlasSceneMenu] textureNamed:kSIAtlasSceneMenuSettings]]];
    [toolTags   addObject:kSINodeButtonSettings];
    
    if (!isPremiumUser) {
        [toolNodes  addObject:[SKSpriteNode spriteNodeWithTexture:[[SIConstants atlasSceneMenu] textureNamed:kSIAtlasSceneMenuAdFree]]];
        [toolTags   addObject:kSINodeButtonNoAd];
    }
    
    [toolNodes  addObject:[SKSpriteNode spriteNodeWithTexture:[[SIConstants atlasSceneMenu] textureNamed:kSIAtlasSceneMenuAchievements]]];
    [toolTags   addObject:kSINodeButtonAchievement];
    
    [toolNodes  addObject:[SKSpriteNode spriteNodeWithTexture:[[SIConstants atlasSceneMenu] textureNamed:kSIAtlasSceneMenuHelp]]];
    [toolTags   addObject:kSINodeButtonInstructions];
    
    [toolNodes  addObject:[SKSpriteNode spriteNodeWithTexture:[[SIConstants atlasSceneMenu] textureNamed:kSIAtlasSceneMenuLeaderboard]]];
    [toolTags   addObject:kSINodeButtonLeaderBoard];
    
    [toolbarNode setTools:toolNodes tags:toolTags animation:HLToolbarNodeAnimationNone];
    
    [toolbarNode layoutToolsAnimation:HLToolbarNodeAnimationNone];
    return toolbarNode;
}
/**Power up toolbar*/
+ (HLToolbarNode *)SIHLToolbarGamePowerUpToolbarSize:(CGSize)toolbarSize toolbarNodeSize:(CGSize)toolbarNodeSize horizontalSpacing:(CGFloat)horizontalSpacing {
    HLToolbarNode *toolbarNode                  = [[HLToolbarNode alloc] init];
    toolbarNode.automaticHeight                 = NO;
    toolbarNode.automaticWidth                  = NO;
    toolbarNode.backgroundBorderSize            = 0.0f;
    toolbarNode.squareSeparatorSize             = horizontalSpacing;
    toolbarNode.backgroundColor                 = [UIColor clearColor];
    toolbarNode.anchorPoint                     = CGPointMake(0.0f, 0.0f);
    toolbarNode.size                            = toolbarSize;
    toolbarNode.squareColor                     = [SKColor clearColor];
    
    NSMutableArray *toolNodes                   = [NSMutableArray array];
    NSMutableArray *toolTags                    = [NSMutableArray array];
    
    SIPowerUpToolbarNode *timeFreezeNode        = [[SIPowerUpToolbarNode alloc] initWithSIPowerUp:SIPowerUpTypeTimeFreeze size:toolbarNodeSize];
    [toolNodes  addObject:timeFreezeNode];
    [toolTags   addObject:kSINodeButtonTimeFreeze];
    
    SIPowerUpToolbarNode *rapidFireNode         = [[SIPowerUpToolbarNode alloc] initWithSIPowerUp:SIPowerUpTypeRapidFire size:toolbarNodeSize];
    [toolNodes addObject:rapidFireNode];
    [toolTags addObject:kSINodeButtonRapidFire];
    
    SIPowerUpToolbarNode *fallingMonkeyNode     = [[SIPowerUpToolbarNode alloc] initWithSIPowerUp:SIPowerUpTypeFallingMonkeys size:toolbarNodeSize];
    [toolNodes addObject:fallingMonkeyNode];
    [toolTags addObject:kSINodeButtonFallingMonkey];
    
    [toolbarNode setTools:toolNodes tags:toolTags animation:HLToolbarNodeAnimationSlideUp];
    
    [toolbarNode layoutToolsAnimation:HLToolbarNodeAnimationNone];
    return toolbarNode;
}

#pragma mark HLRingNodes
+ (HLRingNode *)SIHLRingNodeSceneGamePause {
    static HLRingNode *ringNode = nil;
    if (!ringNode) {
        ringNode = sceneGamePauseRingNode();
    }
    return ringNode;
}

#pragma mark HLGridNodes
/**
 Creates a grid node for menu
 */
+ (HLGridNode *)SIHLGridNodeMenuSceneSize:(CGSize)size {
    int gridWidth                       = 2;
    int squareCount                     = 6;
    
    CGFloat squareSeparatorSize         = VERTICAL_SPACING_8;
    
    CGFloat squareWidth                 = (size.width - (squareSeparatorSize * 3)) / 2.0f;
    CGFloat squareHeight                = squareWidth * 0.25f;
    
    SKSpriteNode *node1                 = [SKSpriteNode spriteNodeWithTexture:[[SIConstants atlasSceneMenu] textureNamed:kSIAtlasSceneMenuPlayClassic] size:CGSizeMake(squareWidth, squareHeight * 2)];
    SKSpriteNode *node2                 = [SKSpriteNode spriteNodeWithTexture:[[SIConstants atlasSceneMenu] textureNamed:kSIAtlasSceneMenuPlayOneHand] size:CGSizeMake(squareWidth, squareHeight * 2)];
    SKSpriteNode *node3                 = [SKSpriteNode spriteNodeWithTexture:[[SIConstants atlasSceneMenu] textureNamed:kSIAtlasSceneMenuShop] size:CGSizeMake(squareWidth, squareHeight)];
    
    HLGridNode *gridNode                = [[HLGridNode alloc] initWithGridWidth:gridWidth
                                                                    squareCount:squareCount
                                                                    anchorPoint:CGPointMake(0.5f, 0.0f)
                                                                     layoutMode:HLGridNodeLayoutModeAlignLeft
                                                                     squareSize:CGSizeMake(squareWidth, squareHeight)
                                                           backgroundBorderSize:0.0f
                                                            squareSeparatorSize:squareSeparatorSize];
    
    gridNode.backgroundColor            = [SKColor clearColor]; //[SKColor blackColor];
    gridNode.squareColor                = [SKColor colorWithWhite:0.2f alpha:1.0f];
    gridNode.highlightColor             = [SKColor colorWithWhite:0.8f alpha:1.0f];
    gridNode.content = @[node1,node2,[SKNode node],[SKNode node],node3,[SKNode node]];
    
    return gridNode;
}
#pragma mark SIPopups
+ (SIPopupNode *)SIPopupNodeTitle:(NSString *)title SceneSize:(CGSize)sceneSize {
    SKLabelNode *titleNode      = [SIGameController SILabelParagraph:title];
    titleNode.fontColor         = [SKColor whiteColor];
    titleNode.fontSize          = [SIGameController SIFontSizePopUp];
    
    SIPopupNode *popUpNode      = [[SIPopupNode alloc] initWithSceneSize:sceneSize];
    popUpNode.titleContentNode  = titleNode;
    popUpNode.backgroundSize    = CGSizeMake(sceneSize.width - 100.0f, sceneSize.height - 200.0f);
    popUpNode.backgroundColor   = [SKColor mainColor];
    popUpNode.cornerRadius      = 8.0f;
    
    return popUpNode;
}
+ (SIPopupNode *)SIPopupSceneGameContinue {
    
    DSMultilineLabelNode *titleNode                 = [DSMultilineLabelNode labelNodeWithFontNamed:kSIFontUltra];
    titleNode.fontColor                         = [SKColor whiteColor];
    titleNode.fontSize              = [SIGameController SIFontSizePopUp];
    
    
    SIPopupNode *popupNode                  = [[SIPopupNode alloc] initWithSceneSize:[SIGameController sceneSize]];
    popupNode.titleContentNode              = titleNode;
    popupNode.backgroundSize                = CGSizeMake([SIGameController sceneSize].width - [SIGameController xPaddingPopupContinue], [SIGameController sceneSize].width - [SIGameController xPaddingPopupContinue]);
    popupNode.backgroundColor               = [SKColor mainColor];
    popupNode.cornerRadius                  = 8.0f;
    popupNode.userInteractionEnabled        = YES;
    
    return popupNode;
}
+ (SIPopupNode *)SIPopupSceneMenuFreePrize {
    SIPopupNode *popupNode                  = [[SIPopupNode alloc] initWithSceneSize:[SIGameController sceneSize]];
    popupNode.titleContentNode              = [SIIAPUtility createTitleNode:CGSizeMake([SIGameController sceneSize].width - VERTICAL_SPACING_16, (popupNode.backgroundSize.height / 2.0f) - ([SIGameController SIChestSize].height / 2.0f))];
    popupNode.backgroundSize                = CGSizeMake([SIGameController sceneSize].width - [SIGameController xPaddingPopupContinue], [SIGameController sceneSize].width - [SIGameController xPaddingPopupContinue]);
    popupNode.backgroundColor               = [SKColor mainColor];
    popupNode.cornerRadius                  = 8.0f;
    popupNode.userInteractionEnabled        = YES;

    return popupNode;
}

+ (SIPopupContentNode *)SIPopupContentSceneMenuFreePrizeSize:(CGSize)size {
    SIPopupContentNode *popupContentNode        = [[SIPopupContentNode alloc] initWithSize:size];
    popupContentNode.labelNode                  = [SIGameController BMGLabelLongIslandStroked];
    popupContentNode.backgroundImageNode        = [SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageIAPExtraLarge] size:[SIGameController SIChestSize]];
}

#pragma mark Scenes
/**
 New Loading Scene
 */
+ (SILoadingScene *)SILoaderSceneLoadingSize:(CGSize)size {
    
    SILoadingScene *loadingScene = [[SILoadingScene alloc] initWithSize:size];
    
    [loadingScene sceneLoadingSetProgressPercent:0.0f];
    
    return loadingScene;
}
/**
 Call this class in the initialization... this will add the emitters to the store
 */
+ (void)SILoaderEmitters {
    NSDate *startDate = [NSDate date];
    
    HLEmitterStore *emitterStore = [HLEmitterStore sharedStore];
    
    SKEmitterNode *emitterNode;
    
    emitterNode = [emitterStore setEmitterWithResource:kSIEmitterExplosionTouch forKey:kSIEmitterExplosionTouch];
    emitterNode = [emitterStore setEmitterWithResource:kSIEmitterSpark forKey:kSIEmitterSpark];
    
    NSLog(@"SIGameScene loadEmitters: loaded in %0.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
}

#pragma mark TCProgressBarNodes
/**Progress Bar for Free Coin*/
+ (TCProgressBarNode *)SIProgressBarSceneGameFreeCoinSceneSize:(CGSize)size {
    CGSize progressBarSize              = CGSizeMake(size.width / 2.0f, (size.width / 2.0f) * 0.2);
    TCProgressBarNode *progressBar      = [[TCProgressBarNode alloc]
                                           initWithSize:progressBarSize
                                           backgroundColor:[UIColor lightGrayColor]
                                           fillColor:[UIColor goldColor]
                                           borderColor:[UIColor blackColor]
                                           borderWidth:2.0f
                                           cornerRadius:4.0f];
    return progressBar;
}
/**Progress Bar for Move*/
+ (TCProgressBarNode *)SIProgressBarSceneGameMoveSceneSize:(CGSize)size {
    CGSize progressBarSize              = CGSizeMake(size.width, (size.width / 2.0f) * 0.3);
    TCProgressBarNode *progressBar      = [[TCProgressBarNode alloc]
                                           initWithSize:progressBarSize
                                           backgroundColor:[UIColor grayColor]
                                           fillColor:[UIColor redColor]
                                           borderColor:[UIColor clearColor]
                                           borderWidth:0.0f
                                           cornerRadius:0.0f];
    return progressBar;
}
/**Progress Bar for Power Up*/
+ (TCProgressBarNode *)SIProgressBarSceneGamePowerUpSceneSize:(CGSize)size {
    CGSize progressBarSize              = CGSizeMake(size.width, (size.width / 2.0f) * 0.3);
    TCProgressBarNode *progressBar      = [[TCProgressBarNode alloc]
                                           initWithSize:progressBarSize
                                           backgroundColor:[UIColor grayColor]
                                           fillColor:[UIColor greenColor]
                                           borderColor:[UIColor clearColor]
                                           borderWidth:0.0f
                                           cornerRadius:0.0f];
    return progressBar;
}

+ (void)SIControllerNode:(SKNode *)node animation:(SISceneContentAnimation)animation animationStyle:(SISceneContentAnimationStyle)animationStyle animationDuration:(float)animationDuration positionVisible:(CGPoint)positionVisible positionHidden:(CGPoint)positionHidden {
    
    SKAction *actionAnimateInSlide = [SKAction sequence:@[[SKAction moveTo:positionHidden duration:0.0f],[SKAction moveTo:positionVisible duration:animationDuration]]];
    SKAction *actionAnimateOutSlide = [SKAction sequence:@[[SKAction moveTo:positionVisible duration:0.0f],[SKAction moveTo:positionHidden duration:animationDuration]]];
    
    SKAction *actionAnimateInGrow           = [SKAction sequence:@[[SKAction scaleTo:0.0f duration:0.0f], [SKAction scaleTo:1.0f duration:animationDuration]]];
    SKAction *actionAnimateOutGrow          = [SKAction scaleTo:0.0f duration:animationDuration];
    
    switch (animation) {
        case SISceneContentAnimationIn:
            switch (animationStyle) {
                case SISceneContentAnimationStyleSlide:
                    [node runAction:actionAnimateInSlide];
                    break;
                case SISceneContentAnimationStyleGrow:
                    [node runAction:actionAnimateInGrow];
                default:
                    break;
            }
            break;
        case SISceneContentAnimationOut:
            switch (animationStyle) {
                case SISceneContentAnimationStyleSlide:
                    [node runAction:actionAnimateOutSlide];
                    break;
                case SISceneContentAnimationStyleGrow:
                    [node runAction:actionAnimateOutGrow];
                default:
                    break;
            }
            break;
        default:
            node.position = positionVisible;
            break;
    }
}
#pragma mark BMGlyphFonts
+ (BMGlyphFont *)BMGFontLongIslandStroked {
    static BMGlyphFont *font = nil;
    if (!font) {
        font = [BMGlyphFont fontWithName:kSIFontUltraStroked];
    }
    return font;
}
+ (BMGlyphFont *)BMGFontUltraStroked {
    static BMGlyphFont *font = nil;
    if (!font) {
        font = [BMGlyphFont fontWithName:kSIFontUltraStroked];
    }
    return font;
}
#pragma mark BMGLabels
+ (BMGlyphLabel *)BMGLabelLongIslandStroked {
    static BMGlyphLabel *label = nil;
    if (!label) {
        label                       = [BMGlyphLabel labelWithText:@"0.00" font:[SIGameController BMGFontLongIslandStroked]];
        label.horizontalAlignment   = BMGlyphHorizontalAlignmentCentered;
        label.verticalAlignment     = BMGlyphVerticalAlignmentTop;
    }
    return label;
}

#pragma mark ZPosition Convience Methods
+ (float)floatZPositionGameForContent:(SIZPositionGame)layer {
    return (float)layer / (float)SIZPositionGameCount;
}

+ (float)floatZPositionPopupForContent:(SIZPositionPopup)layer {
    return (float)layer / (float)SIZPositionPopupCount;
}
@end
