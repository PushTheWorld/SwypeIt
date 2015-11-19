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
#import "SIStoreButtonNode.h"
#import "SIPopupGameOverDetailsNode.h"
#import "SIMenuNode.h"
#import "SIGameModel.h"
#import "SIPowerUpToolbarNode.h"
#import "SIPopupContentNode.h"
#import "SIGameController.h"
// Scene Import
#import "SIFallingMonkeyScene.h"
#import "SILoadingScene.h"
#import "SIMenuScene.h"
#import "SIPopupTestScene.h"
#import "SettingsScene.h"
#import "StoreScene.h"
// Framework Import
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMotion/CoreMotion.h>
#import <GameKit/GameKit.h>
#import <iAd/iAd.h>
#import <Instabug/Instabug.h>
#import <MessageUI/MessageUI.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "DSMultilineLabelNode.h"
#import "FXReachability.h"
#import "JCNotificationCenter.h"
#import "MBProgressHud.h"
#import "MKStoreKit.h"
#import "MSSAlertViewController.h"
//#import "SoundManager.h"
#import "TransitionKit.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIGame.h"
#import "SIPowerUp.h"
#import "SIIAPUtility.h"
// Other Imports

@interface SIGameController () <ADBannerViewDelegate, ADInterstitialAdDelegate, GKGameCenterControllerDelegate, SIGameSceneDelegate, SISingletonAchievementDelegate, SIMenuSceneDelegate, SIFallingMonkeySceneDelegate, HLMenuNodeDelegate, HLGridNodeDelegate, HLRingNodeDelegate, HLToolbarNodeDelegate, SIPopupNodeDelegate, SIAdBannerNodeDelegate, SIGameModelDelegate, SIMenuNodeDelegate, INSKButtonNodeDelegate>

@property (strong, nonatomic) UIButton          *closeButton;
@end

@implementation SIGameController {
    __weak SKScene                           *_currentScene;
    
    ADBannerView                             *_adBannerView;
    
    ADInterstitialAd                         *_interstitialAd;
    
    BOOL                                     _loadComplete;
    BOOL                                     _interstitialAdPresentationIsLive;
    
    /**
     Premium User or not... for quick reference and shit
     */
    BOOL                                     _premiumUser;
    
    /**
     Set this true if you want a ton of print statements
     */
    BOOL                                     _verbose;
    BOOL                                     _highScoreShowing;
    BOOL                                     _isPurchaseInProgress;
    BOOL                                     _sceneGameShakeIsActive;
    BOOL                                     _testMode;

    
    CGFloat                                  _sceneGameSpacingHorizontalToolbar;
    
    CGSize                                   _sceneSize;
    CGSize                                   _sceneGameToolbarSize;
    CGSize                                   _sceneGameToolbarNodeSize;
    
    CMMotionManager                         *_motionManager;

    DSMultilineLabelNode                    *_sceneGamePopupGameOverUserMessageLabelNode;
    DSMultilineLabelNode                    *_sceneMenuHelpMultilineNode;
    
    INSKButtonNode                          *_sceneMenuPopupFreePrizeButton;
    INSKButtonNode                          *_sceneMenuStartOneHandModeButton;
    INSKButtonNode                          *_sceneMenuStartShopButton;
    INSKButtonNode                          *_sceneGamePopupGameOverEndGameButton;
    
    int                                      _loadingPointsCurrent;
    int                                      _loadingPointsTotal;
    int                                      _numberOfAdsToWatch;
    int                                      _sceneGameShakeRestCount;
    
    /**
     in mS
     */
//    float                                    _gameTimeComposite;
    /**
     0.0 to 1.0 for the amount of the scene that is loaded
     */
    float                                    _percentLoaded;
    float                                    _timeFreezeMultiplier;

    
    HLGridNode                              *_sceneMenuEndGridNode;
//    HLGridNode                              *_sceneMenuStartGridNode;
    
    HLMenuNode                              *_sceneGamePopupContinueMenuNode;
    HLMenuNode                              *_sceneMenuStoreMenuNode;
    HLMenuNode                              *_sceneMenuSettingsMenuNode;

    HLRingNode                              *_sceneGameRingNodePause;
    
    HLToolbarNode                           *_sceneGameToolbarPowerUp;
    HLToolbarNode                           *_sceneMenuStartToolbarNode;
    
    MBProgressHUD                           *_hud;
    
    NSArray                                 *_products;
    
    NSString                                *_sceneGamePopupMenuItemTextContinueWithAd;
    NSString                                *_sceneGamePopupMenuItemTextContinueWithCoin;
    NSString                                *_sceneSettingsMenuItemTextSoundBackground;
    NSString                                *_sceneSettingsMenuItemTextSoundFX;
    
    NSTimeInterval                           _gameTimePauseStart;
    NSTimeInterval                           _gameTimeStart;
    NSTimeInterval                           _gameTimeTotal;
    NSTimeInterval                           _loadTimeStart;

    NSTimer                                 *_continueGameTimer;
    NSTimer                                 *_gameTimer;
    NSTimer                                 *_loadTimer;
    
    SIAdBannerNode                          *_adBannerNode;
    
    SIFallingMonkeyScene                    *_sceneFallingMonkey;
        
    SIGameControllerScene                    _currentSceneType;
    
    SIGameModel                             *_gameModel;
    
    SIGameScene                             *_sceneGame;
    
    SILoadingScene                          *_sceneLoading;
    
//    SIMenuNode                              *_menuNodeEnd;
    SIMenuNode                              *_menuNodeHelp;
    SIMenuNode                              *_menuNodeSettings;
    SIMenuNode                              *_menuNodeStart;
    SIMenuNode                              *_menuNodeStore;
    SIMenuNode                              *_sceneGamePopupContinueSIMenuNodeStore;
    
    SIMenuScene                             *_sceneMenu;
    
    SIMove                                  *_currentMove;

    SIPopupNode                             *_sceneGamePopupContinue;
    SIPopupNode                             *_sceneMenuPopupFreePrize;
    
//    SIPopupContentNode                      *_sceneMenuPopupContentFreePrize;
    
    SIPopupGameOverDetailsNode              *_sceneGamePopupGameOverDetailsNode;
    
    SKLabelNode                             *_sceneMenuLabelEnd;
    SKLabelNode                             *_sceneGamePopupContinueCountdownLabel;
    SKLabelNode                             *_sceneMenuPopupFreePrizeCountLabel;
    
    SKSpriteNode                            *_sceneGamePopupContinueButtonsNode;
    SKSpriteNode                            *_sceneGamePopupGameOverEndNode;
    SKSpriteNode                            *_sceneGamePopupGameOverBottomNode;
    
    SKTexture                               *_monkeyFaceTexture;
    
    TKStateMachine                          *_timerStateMachine;
    
    TKEvent                                 *_timerEventPause;
    TKEvent                                 *_timerEventResume;
    TKEvent                                 *_timerEventStart;
    TKEvent                                 *_timerEventStop;
    TKEvent                                 *_timerEventStopCriticalFailure;

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

- (void)applicationDidBecomeActive {
    //TODO: Implement Did Become Active Logic
    NSLog(@"Resuming Active State");
}

- (void)applicationWillResignActive {
    //TODO: Implement Will Resign Active Logic
    NSLog(@"Resiging active state");
}

- (void)applicationDidReceiveMemoryWarning {
    //TODO: Implement Memory Warning Logic
    NSLog(@"Recieved memory warning");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     LOAD REAL GAME!
     */
    [self setupUserInterface];
    
    /*
     LOAD TEST SCENE!
     */
//    SIFallingMonkeyScene *testScene = [self loadFallingMonkeyScene];
//    SIPopupTestScene *testScene = [[SIPopupTestScene alloc] initWithSize:self.view.frame.size];
//    [self presentScene:SIGameControllerSceneFallingMonkey];
//    [SIGameController viewController:[self fastSKView] transisitionToSKScene:testScene duration:0];
}

/**This is an attempt to force view to be an skview*/
- (void)loadView {
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    SKView *skView = [[SKView alloc] initWithFrame:applicationFrame];
    self.view = skView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForNotifications];
    
    //TODO: Uncomment for non test environment
//    [self configureBannerAds];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    _adBannerView.delegate  = nil;
    [_adBannerView removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
    [self gameFireEvent:kSITKStateMachineEventGameMenuStart userInfo:nil];

//    [self mainSceneInitializationMethod];
}
- (void)createConstants {
    _isPurchaseInProgress               = NO;
    _highScoreShowing                   = NO;
    _loadComplete                       = NO;
    _sceneSize                          = self.view.frame.size;
    _interstitialAdPresentationIsLive   = NO;
    _monkeyFaceTexture                  = [[SIConstants buttonAtlas] textureNamed:kSIImageFallingMonkeys];
    _loadingPointsCurrent               = 0;
    _verbose                            = YES;
    _premiumUser                        = [SIGameController premiumUser];
    _testMode                           = YES;
    _sceneGameShakeIsActive             = NO;
    _sceneGameShakeRestCount            = 0;
    
    _sceneGameSpacingHorizontalToolbar  = 10.0f;
    CGFloat toolBarNodeWidth            = (SCREEN_WIDTH - (4.0f * _sceneGameSpacingHorizontalToolbar)) / 5.0f;
    _sceneGameToolbarNodeSize           = CGSizeMake(toolBarNodeWidth, toolBarNodeWidth);
    _sceneGameToolbarSize               = CGSizeMake(_sceneSize.width, _sceneGameToolbarNodeSize.height + VERTICAL_SPACING_8);

}
- (void)setupControls {

    [self authenticateLocalPlayer];
    
    _currentMove                                        = [[SIMove alloc] init];

    
    _gameModel                                          = [[SIGameModel alloc] init];
    _gameModel.delegate                                 = self;
    
    _timerStateMachine                                  = [self createTimeStateMachine];
    
    /*Start your singletons*/
    [SISingletonAchievement singleton].delegate         = self;;
    
    /*Start Sounds*/
    [SIGame initalizeSoundManager];
    
    /*Give those interstitial ads a cycle to get em going*/
    [self interstitialAdCycle];
    
    if (![SIGameController premiumUser]) {
        _adBannerNode                                       = [[SIAdBannerNode alloc] initWithSize:CGSizeMake(_sceneSize.width, [SIGameController SIAdBannerViewHeight])];
        _adBannerNode.position                              = CGPointMake(0.0f, 0.0f);
        _adBannerNode.delegate                              = self;
    }
    
}
#pragma mark -
#pragma mark - Scene Loading
- (void)presentScene:(SIGameControllerScene)sceneType {
//    NSNumber *highScore;
    if (_adBannerNode) {
        [_adBannerNode removeFromParent];
    }
    switch (sceneType) {
        // LOADING
        case SIGameControllerSceneLoading:
            _currentScene = [SIGameController viewController:[self fastSKView] transisitionToSKScene:_sceneLoading duration:SCENE_TRANSISTION_DURATION_FAST];
            break;
            
        // FALLING MONKEY
        case SIGameControllerSceneFallingMonkey:
            _sceneFallingMonkey.adBannerNode = [SIGameController premiumUser] ? nil : _adBannerNode;
            _currentScene = [SIGameController viewController:[self fastSKView] transisitionToSKScene:_sceneFallingMonkey duration:SCENE_TRANSISTION_DURATION_FAST];

            break;
            
        // GAME
        case SIGameControllerSceneGame:
            _sceneGame.adBannerNode = [SIGameController premiumUser] ? nil : _adBannerNode;
            switch (_currentSceneType) {
                case SIGameControllerSceneFallingMonkey:
                    _currentScene = [SIGameController viewController:[self fastSKView] transisitionToSKScene:_sceneGame duration:SCENE_TRANSISTION_DURATION_NOW];
                    break;
                case SIGameControllerSceneLoading:
                    _currentScene = [SIGameController transisitionToSKScene:_sceneGame toSKView:[self fastSKView] DoorsOpen:YES pausesIncomingScene:NO pausesOutgoingScene:NO duration:SCENE_TRANSISTION_DURATION_NORMAL];
//                    [self controllerSceneMenuShowMenu:_menuNodeStart menuNodeAnimiation:SIMenuNodeAnimationSlideOut delay:SCENE_TRANSISTION_DURATION_NORMAL];
                    break;
                default:
                    _currentScene = [SIGameController viewController:[self fastSKView] transisitionToSKScene:_sceneGame duration:SCENE_TRANSISTION_DURATION_NOW];
                    break;
            }
            break;
        
        // MENU
        case SIGameControllerSceneMenu:
            _sceneMenu.adBannerNode = [SIGameController premiumUser] ? nil : _adBannerNode;
            switch (_currentSceneType) {
                case SIGameControllerSceneGame:
                    _currentScene = [SIGameController transisitionNormalOpenToSKScene:_sceneMenu toSKView:[self fastSKView]];
//                    _sceneGamePopupGameOverDetailsNode.game = _gameModel.game;
                    [self controllerSceneMenuShowMenu:_menuNodeStart menuNodeAnimiation:SIMenuNodeAnimationStaticVisible delay:SCENE_TRANSISTION_DURATION_NORMAL];
                    break;
                case SIGameControllerSceneLoading:
                    _currentScene = [SIGameController transisitionNormalOpenToSKScene:_sceneMenu toSKView:[self fastSKView]];
                    [self controllerSceneMenuShowMenu:_menuNodeStart menuNodeAnimiation:SIMenuNodeAnimationGrowIn delay:SCENE_TRANSISTION_DURATION_NORMAL];
                    break;
                default:
                    _currentScene = [SIGameController transisitionNormalOpenToSKScene:_sceneMenu toSKView:[self fastSKView]];
                    [self controllerSceneMenuShowMenu:_menuNodeStart menuNodeAnimiation:SIMenuNodeAnimationGrowIn delay:SCENE_TRANSISTION_DURATION_NORMAL];
                    break;
            }
            break;
            
        default:
            break;
    }
    _currentSceneType = sceneType;
}


- (void)controllerSceneMenuShowMenu:(SIMenuNode *)menuNode menuNodeAnimiation:(SIMenuNodeAnimation)menuNodeAnimation delay:(float)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        switch (menuNode.type) {
            case SISceneMenuTypeStart:
                _sceneMenuStartToolbarNode.delegate = self;
                if (_menuNodeStart.bottomNode) {
                    _menuNodeStart.bottomNode         = nil;
                    [_sceneMenuStartToolbarNode removeFromParent];
                }
                _menuNodeStart.bottomNode           = _sceneMenuStartToolbarNode;
//                _sceneMenuStartGridNode.delegate    = self;
                break;
                
            case SISceneMenuTypeSettings:
                _sceneMenuSettingsMenuNode.delegate = self;
                break;
                
            case SISceneMenuTypeStore:
                _sceneMenuStoreMenuNode.delegate    = self;
                break;
            default:
                break;
        }
        [_sceneMenu showMenuNode:menuNode menuNodeAnimation:menuNodeAnimation];
    });
}

- (void)loadAllScenes {
    
    _loadTimer                                              = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(loadSmoothSynch) userInfo:nil repeats:YES];
    _loadTimeStart                                          = [NSDate timeIntervalSinceReferenceDate];

    /*Start loading Menu Scene*/
    _sceneMenu                                              = [self loadMenuScene];
    [self loadingIncrementWillOverrideAndKill:NO];
    
    /*Load the game sceen*/
    _sceneGame                                              = [self loadGameScene];
    [self loadingIncrementWillOverrideAndKill:NO];

    /*Load the falling monkey sceen*/
    _sceneFallingMonkey                                     = [self loadFallingMonkeyScene];
    [self loadingIncrementWillOverrideAndKill:YES];

}

- (void)loadingIncrementWillOverrideAndKill:(BOOL)overrideAndKillLoadingScreen {
    _loadingPointsCurrent                                   = _loadingPointsCurrent + 1;
    if (_loadingPointsCurrent == (int)SIGameControllerSceneCount || overrideAndKillLoadingScreen) {
        _loadComplete                                       = YES;
    }
}

- (void)loadSmoothSynch {
    NSTimeInterval currentTime                              = [NSDate timeIntervalSinceReferenceDate];
    
    NSTimeInterval totalTimePassed                          = currentTime - _loadTimeStart;
    
    if (totalTimePassed > 1 && _loadComplete == YES) {
        [self gameFireEvent:kSITKStateMachineEventGameMenuStart userInfo:nil];
    } else {
        [_sceneLoading sceneLoadingSetProgressPercent:totalTimePassed];
    }
}

- (SIGameScene *)loadGameScene {
    NSDate *startDate                                       = [NSDate date];
    
    SIGameScene *sceneGame                                  = [[SIGameScene alloc] initWithSize:_sceneSize];
    
    sceneGame.sceneDelegate                                 = self;
    
    _sceneGamePopupContinue                                 = [SIGameController SIPopupSceneGameContinueSize:_sceneSize];
    
    _sceneGamePopupContinueButtonsNode                      = [SIGameController SISpriteNodePopupContinueCenterNode];

    _sceneGamePopupContinueMenuNode                         = [SIGameController SIHLMenuNodeSceneGamePopupContinue];
    
    _sceneGamePopupContinueSIMenuNodeStore                  = [self SIMenuNodeStoreSize:CGSizeMake(_sceneSize.width - [SIGameController xPaddingPopupContinue], _sceneSize.height - ([SIGameController yPaddingPopupContinue] * 2.0f))];

    _sceneGamePopupGameOverEndNode                          = [SIGameController SISpriteNodePopupGameOverEndNode];
    
    _sceneGamePopupGameOverBottomNode                       = [self SISpriteNodePopupGameOverBottomNode];
    
    _sceneGamePopupContinueCountdownLabel                   = [SIGameController SILabelSceneGamePopupCountdown];
    
    _sceneGamePopupGameOverUserMessageLabelNode             = [SIGameController SIMultilineLabelNodePopupSceneSize:_sceneGamePopupContinue.backgroundSize];

    _sceneGamePopupGameOverEndGameButton                    = [SIGameController SIINButtonNamed:kSIAssestPopupButtonEndGame label:[SIGameController SILabelParagraph:NSLocalizedString(kSITextPopupContinueEnd, nil)]];
    _sceneGamePopupGameOverEndGameButton.name               = kSINodeButtonEndGame;
    
    _sceneGameRingNodePause                                 = [SIGameController SIHLRingNodeSceneGamePause];
    [_sceneGameRingNodePause hlSetGestureTarget:_sceneGameRingNodePause];
    [sceneGame registerDescendant:_sceneGameRingNodePause withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];

    
    _sceneGameToolbarPowerUp                                = [SIGameController SIHLToolbarGamePowerUpToolbarSize:_sceneGameToolbarSize toolbarNodeSize:_sceneGameToolbarNodeSize horizontalSpacing:_sceneGameSpacingHorizontalToolbar];
    _sceneGameToolbarPowerUp.delegate                       = self;
    
    [_sceneGameToolbarPowerUp hlSetGestureTarget:_sceneGameToolbarPowerUp];
    [sceneGame registerDescendant:_sceneGameToolbarPowerUp withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    sceneGame.powerUpToolbarNode                            = _sceneGameToolbarPowerUp;
    
    
    sceneGame.progressBarFreeCoin                           = [SIGameController SIProgressBarSceneGameFreeCoinSceneSize:_sceneSize];
    sceneGame.progressBarFreeCoin.userInteractionEnabled    = YES;
    
//    sceneGame.scoreMoveLabel                                = [SIGameController SILabelSceneGameMoveCommand];
//    sceneGame.scoreMoveLabel.userInteractionEnabled         = YES;
    
    sceneGame.progressBarPowerUp                            = [SIGameController SIProgressBarSceneGamePowerUpSceneSize:_sceneSize];
    sceneGame.progressBarPowerUp.colorDoesChange            = YES;
    sceneGame.progressBarPowerUp.hidden                     = YES;
    sceneGame.progressBarPowerUp.userInteractionEnabled     = YES;
    
    _timeFreezeMultiplier                                   = 1.0f;

    [SIGameController SILoaderEmitters];
    
    if (_verbose) {
        NSLog(@"SIGameScene Initialized: loaded in %0.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
    }
    
    _motionManager                                          = [[CMMotionManager alloc] init];
    
    return sceneGame;
}

- (SIMenuScene *)loadMenuScene {
    NSDate *startDate                                       = [NSDate date];
    
    SIMenuScene *menuScene                                  = [[SIMenuScene alloc] initWithSize:_sceneSize];
    
    menuScene.sceneDelegate                                 = self;
    
    _sceneMenuPopupFreePrize                                = [self initalizePopupFreePrize];

    
    menuScene.adBannerNode                                  = _adBannerNode;

    CGSize menuNodeSize                                     = CGSizeMake(_sceneSize.width, _sceneSize.height - _adBannerNode.size.height);
    
//    _menuNodeEnd                                            = [self SIMenuNodeEndSize:menuNodeSize];
    
    _menuNodeStart                                          = [self SIMenuNodeStartSize:menuNodeSize];

    _menuNodeStore                                          = [self SIMenuNodeStoreSize:menuNodeSize];
    
    _menuNodeSettings                                       = [self SIMenuNodeSettingsSize:menuNodeSize];
    
    _menuNodeHelp                                           = [self SIMenuNodeHelpSceneSize:menuNodeSize];
    
    if (_verbose) {
        NSLog(@"SIMenuScene Initialized: loaded in %0.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
    }
    
    return menuScene;
}

- (SIFallingMonkeyScene *)loadFallingMonkeyScene {
    NSDate *startDate                                       = [NSDate date];
    
    SIFallingMonkeyScene *newScene                          = [[SIFallingMonkeyScene alloc] initWithSize:_sceneSize];
    
    /*This will init the first monkey node!*/
    [SIGameController SISpriteNodeBananaBunch];
    [SIGameController SISpriteNodeFallingMonkey];
    [SIGameController SISpriteNodeTarget];
    
    if (_verbose) {
        NSLog(@"SIFallingMonkeyScene Initialized: loaded in %0.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
    }
    
    newScene.sceneDelegate                                  = self;
    
    return newScene;
}

#pragma mark -
#pragma mark - Accessors Methods
#pragma mark Visual Help
- (void)showFPS:(BOOL)showFPS {
    SKView * skView         = (SKView *)self.view;
    skView.showsFPS         = showFPS;
    skView.showsNodeCount   = showFPS;
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

- (void)gameCenterSubmitScore {
    if (_gameModel.game.totalScore > EPSILON_NUMBER) {
        if ([[GKLocalPlayer localPlayer] isAuthenticated]) {
            GKScore *score;
            
            if (_gameModel.game.gameMode == SIGameModeOneHand) {
                score = [[GKScore alloc] initWithLeaderboardIdentifier:kSIGameCenterLeaderBoardIDHandOne];
            } else {
                score = [[GKScore alloc] initWithLeaderboardIdentifier:kSIGameCenterLeaderBoardIDHandTwo];
            }
            
            score.value = (int64_t)(_gameModel.game.totalScore * 100);
            
            NSArray *scoreArray = @[score];
            
            [GKScore reportScores:scoreArray withCompletionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    NSLog(@"Error [Sending High Score]: %@",error.localizedDescription);
                } else {
                    NSLog(@"Sent high score to game center");
                }
            }];
            
        }
    }
}

#pragma mark Sound
- (void)updateBackgroundSound {
    _gameModel.game.currentBackgroundSound = [SIGame checkBackgroundSound:_gameModel.game.currentBackgroundSound forTotalScore:_gameModel.game.totalScore withCallback:^(BOOL updatedBackgroundSound, SIBackgroundSound backgroundSoundNew) {
        if (updatedBackgroundSound) {
            [SIGame playMusic:[SIGame soundNameForSIBackgroundSound:backgroundSoundNew] looping:YES fadeIn:YES];
        }
    }];
}
#pragma mark Banner Ads

- (void)configureBannerAds {


    if (_verbose) {
        NSLog(@"User is premium: %@",_premiumUser ? @"YES" : @"NO");
    }
    
    if ([SIGameController premiumUser]) {
        self.canDisplayBannerAds    = NO;
        _adBannerNode               = nil;
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
    _sceneMenuStartToolbarNode          = [SIGameController SIHLToolbarMenuStartScene:[SIGameController SIToolbarSceneMenuSize:_sceneSize] isPremiumUser:_premiumUser];
    _sceneMenuStartToolbarNode.delegate = self;
    _menuNodeStart.bottomNode           = _sceneMenuStartToolbarNode;
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
            BOOL success = [self gameFireEvent:kSITKStateMachineEventGameWaitForMove userInfo:nil];
            NSLog(@"When back to idle from ad watching state: %@",success ? @"YES" : @"NO");
            if (!success) {
                [self gameFireEvent:kSITKStateMachineEventGameMenuEnd userInfo:nil];
            }
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

- (void)hudFlashDuration:(float)duration title:(NSString *)title info:(NSString *)info {
    [self hudWillShowWithTitle:title info:info dimBackground:YES animate:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_hud hide:YES];
    });
}

#pragma mark Daily Free Prize
/**
 Compares a time from the internet to determine if should give a daily prize
 */
- (SIFreePrizeType)checkForDailyPrize {
    
    NSDate *currentDate = [SIIAPUtility getDateFromInternet];
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
        [SIGame playSound:kSISoundFXCoinNoise];
        _sceneMenuPopupFreePrizeCountLabel.text = [NSString stringWithFormat:@"%d",totalCoins - coinsLaunched];
        [_sceneMenuPopupFreePrize launchNode:[[SIGameController SISpriteNodeCoinLargeFront] copy]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(((CGFloat)(totalCoins - coinsLaunched) / (CGFloat)totalCoins) / 2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self launchCoins:totalCoins coinsLaunched:coinsLaunched + 1];
        });
    }
}

- (void)finishPrize {
    [SIGame playSound:kSISoundFXChaChing];
    _sceneMenuPopupFreePrizeCountLabel.text = @"0";
    
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

#pragma mark Popup Setups
- (SIPopupNode *)initalizePopupFreePrize {
    SIPopupNode *popupNode                                  = [SIGameController SIPopupSceneMenuFreePrize];
    
//    _sceneMenuPopupContentFreePrize                         = [SIGameController SIPopupContentSceneMenuFreePrizeSize:_sceneSize];

    SKSpriteNode *chest                                     =[SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageIAPExtraLarge] size:[SIGameController SIChestSize]]; //_sceneMenuPopupContentFreePrize;
    popupNode.centerNode                                    =chest;

    _sceneMenuPopupFreePrizeCountLabel                      = [SIGameController SILabelSceneGamePopupCountdown];
    [chest addChild:_sceneMenuPopupFreePrizeCountLabel];
    
    _sceneMenuPopupFreePrizeButton                          = [SIGameController SIINButtonNamed:kSIAssestPopupButtonClaim label:[SIGameController SILabelHeader:[NSString stringWithFormat:@"%@!",NSLocalizedString(kSITextPopupFreePrizeClaim, nil)]]];

    popupNode.bottomNode                                    = _sceneMenuPopupFreePrizeButton;
    popupNode.bottomNodeBottomSpacing                       = (_sceneMenuPopupFreePrizeButton.size.height / 2.0f) + VERTICAL_SPACING_8;
    _sceneMenuPopupFreePrizeButton.inskButtonNodeDelegate   = self;
    [_sceneMenuPopupFreePrizeButton setTouchUpInsideTarget:self selector:@selector(launchCoinsForDailyFreePrize)];
    
    popupNode.delegate = self;
    
//    popupNode.lightNodeEdge.enabled = YES;
    
    return popupNode;
}

#pragma mark IIAPMethods
- (void)requestPurchaseForPack:(SIIAPPack)siiapPack {
    if (_isPurchaseInProgress == NO) {
        _isPurchaseInProgress = YES;
        [self packPurchaseRequest:siiapPack attemptNumber:0];
    }
}
- (BOOL)isMKStoreKitAvailableAttempt:(NSUInteger)attemptNumber {
    NSArray *productsArray  = [MKStoreKit sharedKit].availableProducts;
    
    if (productsArray) {
        /*MKStoreKit is up and running*/
        _products       = productsArray;
        return YES;
    } else {
        /*MKStoreKit is loading*/
        if (attemptNumber == MAX_NUMBER_OF_ATTEMPTS) {
            NSLog(@"Hit max reload attemps");
            return NO;
        } else {
            NSLog(@"Trying to load from MKStoreKit attempt: %lu",(unsigned long)attemptNumber);
            return [self isMKStoreKitAvailableAttempt:attemptNumber + 1];
        }
    }
}
- (void)packPurchaseRequest:(SIIAPPack)siiapPack attemptNumber:(int)attemptNumber {
    if (attemptNumber == 6) {
        if (_verbose) {
            NSLog(@"Failed after 3 seconds.... ");
        }
        /*TODO: Throw error message about not being able to connect*/
        // blah blah
        _isPurchaseInProgress                   = NO;
        return;
    }
    
    NSArray *productArray = [MKStoreKit sharedKit].availableProducts;
    
    if (productArray.count > 0) {
        [SIIAPUtility productForSIIAPPack:siiapPack inPackArray:productArray withBlock:^(BOOL succeeded, SKProduct *product) {
            if (succeeded) {
                [self hudWillShowWithTitle:@"Purchasing!" info:@"In Progress..." dimBackground:YES animate:YES];
                [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:product.productIdentifier];
            } else {
                NSLog(@"Error: Could not find the SIIAPPack (%ld) after button touch for purchase",(long)siiapPack);
                _isPurchaseInProgress = NO;
            }
        }];
    } else {
        NSLog(@"Trying Request Again....");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self packPurchaseRequest:siiapPack attemptNumber:attemptNumber + 1];
        });
    }
}

#pragma mark Settings Method
- (void)resetHighScore {
    /*Reset the user defaults*/
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:0.0f] forKey:kSINSUserDefaultLifetimeHighScore];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self hudFlashDuration:1.0f title:@"Success" info:@"Reset Device High Score"];
}
- (void)changeBackgroundSoundIsAllowed:(HLMenuItem *)menuItem {
    if ([menuItem.text isEqualToString:kSITextMenuSettingsToggleSoundOffBackground]) {
        /*Turn Background Sound Off*/
        _sceneSettingsMenuItemTextSoundBackground = kSITextMenuSettingsToggleSoundOnBackground;
        [SIGame setBackgroundSoundActive:NO];
        [SIGame stopAllMusic];
        
    } else {
        /*Turn Sound On*/
        _sceneSettingsMenuItemTextSoundBackground = kSITextMenuSettingsToggleSoundOffBackground;
        [SIGame setBackgroundSoundActive:YES];
        [SIGame playMusic:kSISoundBackgroundMenu looping:YES fadeIn:YES];
    }
    menuItem.text = _sceneSettingsMenuItemTextSoundBackground;
    [_sceneMenuSettingsMenuNode redisplayMenuAnimation:HLMenuNodeAnimationNone];
}
- (void)changeFXSoundIsAllowed:(HLMenuItem *)menuItem {
    if ([menuItem.text isEqualToString:kSITextMenuSettingsToggleSoundOffFX]) {
        /*Turn Background Sound Off*/
        _sceneSettingsMenuItemTextSoundFX = kSITextMenuSettingsToggleSoundOnFX;
        [SIGame setFXSoundActive:NO];
        [SIGame stopAllSounds];
    } else {
        /*Turn Sound On*/
        _sceneSettingsMenuItemTextSoundFX = kSITextMenuSettingsToggleSoundOffFX;
        menuItem.text = kSITextMenuSettingsToggleSoundOffFX;
        [SIGame setFXSoundActive:YES];
    }
    menuItem.text = _sceneSettingsMenuItemTextSoundFX;
    [_sceneMenuSettingsMenuNode redisplayMenuAnimation:HLMenuNodeAnimationNone];
}

#pragma mark SIMenuNode
- (SIMenuNode *)SIMenuNodeEndSize:(CGSize)size {
    SIMenuNode *menuNode                            = [[SIMenuNode alloc] initWithSize:size type:SISceneMenuTypeStart];
    
    _sceneMenuEndGridNode                           = [SIGameController SIHLGridNodeMenuSceneEndSize:size];
    _sceneMenuEndGridNode.delegate                  = self;
    menuNode.centerNode                             = _sceneMenuEndGridNode;
    menuNode.menuContentPosition                    = SIMenuNodeContentPositionBottom;
    [_sceneMenuEndGridNode hlSetGestureTarget:_sceneMenuEndGridNode];
    [_sceneMenu registerDescendant:_sceneMenuEndGridNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    
    
    _sceneGamePopupGameOverDetailsNode              = [[SIPopupGameOverDetailsNode alloc] initWithSize:_sceneMenuEndGridNode.size];
    
    menuNode.topNode                                = _sceneGamePopupGameOverDetailsNode;

    
    return menuNode;
}
- (SIMenuNode *)SIMenuNodeStartSize:(CGSize)size {
    SIMenuNode *menuNode                            = [[SIMenuNode alloc] initWithSize:size type:SISceneMenuTypeStart];
    
    SKAction *moveY                                 = [SKAction moveByX:0.0f y:10.0f duration:1.0f];
    SKAction *oppositeY                             = [moveY reversedAction];
    SKAction *sequence                              = [SKAction sequence:@[moveY, oppositeY]];
    
    SKSpriteNode *monkeyFace                        = [SKSpriteNode spriteNodeWithTexture:[SIGameController SITextureMonkeyFaceLarge]];
    monkeyFace.name                                 = @"b";
    [monkeyFace runAction:[SKAction repeatActionForever:sequence]];
    menuNode.topNode                                = monkeyFace;
    
    _sceneMenuStartOneHandModeButton                = [SIGameController SIINButtonOneHandMode];
    if (_gameModel.game.gameMode == SIGameModeOneHand) {
        _sceneMenuStartOneHandModeButton.selected   = true;
    }
    [_sceneMenuStartOneHandModeButton setTouchUpInsideTarget:self selector:@selector(oneHandGameModeButtonTouchedUpInside:)];
    
    menuNode.bottomCenterNodeYPadding               = (_sceneMenuStartOneHandModeButton.size.height / 2.0f) + VERTICAL_SPACING_8;
    
    if (menuNode.centerNode.parent) {
        [NSException raise:NSInvalidArgumentException format:@"Center node cannot have a parent here"];
    }
    
    SKSpriteNode *centerSpriteNode                  = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(_sceneMenuStartOneHandModeButton.size.width, (_sceneMenuStartOneHandModeButton.size.height * 2.0f) + VERTICAL_SPACING_8)];
    
    SKLabelNode *tapToPlay                          = [SIGameController SILabelHeader:NSLocalizedString(kSITextMenuStartScreenTapToPlay, nil)];
    tapToPlay.verticalAlignmentMode                 = SKLabelVerticalAlignmentModeBottom;
    tapToPlay.horizontalAlignmentMode               = SKLabelHorizontalAlignmentModeCenter;
    tapToPlay.fontColor                             = [SKColor whiteColor];
    tapToPlay.name                                  = @"b";
    
    _sceneMenuStartOneHandModeButton.position       = CGPointMake(0.0f, 0.0f);

    _sceneMenuStartShopButton                       = [SIGameController SIINButtonNamed:kSIImageButtonStore label:[SIGameController SILabelHeader:[NSString stringWithFormat:@"%@",NSLocalizedString(kSITextMenuStartScreenStore, nil)]]];
    _sceneMenuStartShopButton.position              = CGPointMake(0.0f, 2.0f * (_sceneMenuStartOneHandModeButton.size.height / 2.0f) + VERTICAL_SPACING_8);
    [_sceneMenuStartShopButton setTouchUpInsideTarget:self selector:@selector(sceneMenuStartShopButtonTouchedUpInside:)];

    
//    tapToPlay.position                              = CGPointMake(0.0f, 4.0f * (_sceneMenuStartOneHandModeButton.size.height / 2.0f) + VERTICAL_SPACING_8 + VERTICAL_SPACING_8);
    
    [centerSpriteNode addChild:_sceneMenuStartOneHandModeButton];
    [centerSpriteNode addChild:_sceneMenuStartShopButton];
//    [centerSpriteNode addChild:tapToPlay];
    
    
    menuNode.centerNode                             = centerSpriteNode;
    menuNode.menuContentPosition                    = SIMenuNodeContentPositionBottom;

    _sceneMenuStartToolbarNode                      = [SIGameController SIHLToolbarMenuStartScene:[SIGameController SIToolbarSceneMenuSize:size] isPremiumUser:[SIGameController premiumUser]];
    _sceneMenuStartToolbarNode.delegate             = self;
    menuNode.bottomNode                             = _sceneMenuStartToolbarNode;
    [_sceneMenuStartToolbarNode hlSetGestureTarget:_sceneMenuStartToolbarNode];
    [_sceneMenu registerDescendant:_sceneMenuStartToolbarNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];

//    menuNode.shopNode                               = [SKSpriteNode spriteNodeWithTexture:[[SIConstants atlasSceneMenu] textureNamed:kSIAtlasSceneMenuShop] size:CGSizeMake(_sceneMenuStartOneHandModeButton.size.width / 2.0f, (_sceneMenuStartOneHandModeButton.size.width / 2.0f) * 0.25)];
//    INSKButtonNode *button                          =[SIGameController SIINButtonPopupButtonImageNamed:kSIImageButtonStore text:[NSString stringWithFormat:@"%@!",NSLocalizedString(kSITextMenuStartScreenStore, nil)] withFontSize:[SIGameController SIFontSizeHeader]];
    
    menuNode.freeNode                               = (SKSpriteNode *)tapToPlay;

    
    return menuNode;
}



- (SIMenuNode *)SIMenuNodeSettingsSize:(CGSize)size {
    SIMenuNode *menuNode                        = [[SIMenuNode alloc] initWithSize:size type:SISceneMenuTypeSettings];
    
    _sceneMenuSettingsMenuNode                  = [SIGameController SIHLMenuNodeSceneMenuSettings:size];
    _sceneMenuSettingsMenuNode.delegate         = self;
    menuNode.centerNode                         = _sceneMenuSettingsMenuNode;
    [_sceneMenuSettingsMenuNode hlSetGestureTarget:_sceneMenuSettingsMenuNode];
    [_sceneMenu registerDescendant:_sceneMenuSettingsMenuNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];

    return menuNode;
}
- (SIMenuNode *)SIMenuNodeStoreSize:(CGSize)size {
    SIMenuNode *menuNode                        = [[SIMenuNode alloc] initWithSize:size type:SISceneMenuTypeStore];
    
    _sceneMenuStoreMenuNode                     = [SIGameController SIHLMenuNodeSceneMenuStore:size];
    _sceneMenuStoreMenuNode.delegate            = self;
    _sceneMenuStoreMenuNode.name                = kSINodeMenuStore;
    menuNode.centerNode                         = _sceneMenuStoreMenuNode;
    [_sceneMenuStoreMenuNode hlSetGestureTarget:_sceneMenuStoreMenuNode];
    [_sceneMenu registerDescendant:_sceneMenuStoreMenuNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    
    return menuNode;
}
- (SIMenuNode *)SIMenuNodeHelpSceneSize:(CGSize)size {
    SIMenuNode *menuNode                        = [[SIMenuNode alloc] initWithSize:size type:SISceneMenuTypeHelp];
    
    _sceneMenuHelpMultilineNode                 = [SIGameController SIMultilineLabelNodeSceneSize:size];
    _sceneMenuHelpMultilineNode.anchorPoint     = CGPointMake(0.5f, 0.5f);
    menuNode.centerNode                         = _sceneMenuHelpMultilineNode;
    
    return menuNode;
}

#pragma mark Timer State Machine
- (TKStateMachine *)createTimeStateMachine {
    TKStateMachine *timerStateMachine                       = [TKStateMachine new];
    
    TKState *timerStatePaused                               = [TKState stateWithName:kSITKStateMachineStateTimerPaused];
    TKState *timerStateRunning                              = [TKState stateWithName:kSITKStateMachineStateTimerRunning];
    TKState *timerStateStopped                              = [TKState stateWithName:kSITKStateMachineStateTimerStopped];
    
    [timerStatePaused setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        //snapshot the current time
        _gameTimePauseStart = _gameTimeTotal;
    }];
    
    [timerStatePaused setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        //fast-forward power ups and move time
        // The amount of time that the pause took
        NSTimeInterval pauseOffSet = (_gameTimeTotal - _gameTimePauseStart);
        
        // Add the time the pause took to the move and to any and all power ups
        if (_currentMove) {
            _currentMove.timeStart = pauseOffSet + _currentMove.timeStart;
        }
        for (SIPowerUp *powerUp in _gameModel.game.powerUpArray) {
            powerUp.startTime =  pauseOffSet + powerUp.startTime;
        }

    }];
    
    [timerStateStopped setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        //deactivate the timer
        [_gameTimer invalidate];
    }];
    
    [timerStateStopped setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        //activate the timer
        if (!_gameTimer.valid) {
            //  Start Timer... returns a new nstimer object
            _gameTimer      = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(gameTimerAsyncUpdate) userInfo:nil repeats:YES];
            _gameTimeStart  = [NSDate timeIntervalSinceReferenceDate];
        } else {
            
        }
    }];
    
    
    //add
    [timerStateMachine addStates:@[ timerStatePaused,timerStateRunning,timerStateStopped]];
    
    // Set the inital state to start... this way we get fresh new data!!!
    timerStateMachine.initialState                          = timerStateStopped;
    
    _timerEventPause                                        = [TKEvent eventWithName:kSITKStateMachineEventTimerPause
                                                             transitioningFromStates:@[timerStateRunning]
                                                                             toState:timerStatePaused];
    _timerEventResume                                       = [TKEvent eventWithName:kSITKStateMachineEventTimerResume
                                                             transitioningFromStates:@[timerStatePaused]
                                                                             toState:timerStateRunning];
    _timerEventStart                                        = [TKEvent eventWithName:kSITKStateMachineEventTimerStart
                                                             transitioningFromStates:@[timerStateStopped]
                                                                             toState:timerStateRunning];
    _timerEventStop                                         = [TKEvent eventWithName:kSITKStateMachineEventTimerStop
                                                             transitioningFromStates:@[timerStatePaused]
                                                                             toState:timerStateStopped];
    _timerEventStopCriticalFailure                          = [TKEvent eventWithName:kSITKStateMachineEventTimerStopCriticalFailure
                                                             transitioningFromStates:@[timerStateRunning]
                                                                             toState:timerStateStopped];
    
    //add event rules
    [timerStateMachine addEvents:@[_timerEventPause, _timerEventResume, _timerEventStart, _timerEventStop, _timerEventStopCriticalFailure]];
    
    return timerStateMachine;
}

- (void)gameTimerAsyncUpdate {
    NSTimeInterval currentTime                              = [NSDate timeIntervalSinceReferenceDate];
    
    _gameTimeTotal                                          = currentTime - _gameTimeStart;
}

- (float)gameTimerTotalInMS {
    return _gameTimeTotal * MILI_SECS_IN_SEC;
}

- (BOOL)timerFireEvent:(NSString *)event userInfo:(NSDictionary *)userInfo {
    NSError *error                                      = nil;
    BOOL success                                        = [_timerStateMachine fireEvent:event userInfo:userInfo error:&error];
    if (!success) {
        NSLog(@"Error [unable to fire event]: %@",error.localizedFailureReason);
    }
    
    return success;
}

#pragma mark Game State Machine
- (BOOL)gameFireEvent:(NSString *)event userInfo:(NSDictionary *)userInfo {
    NSError *error                                      = nil;
    BOOL success                                        = [_gameModel.stateMachine fireEvent:event userInfo:userInfo error:&error];
    if (!success) {
        NSLog(@"Error [unable to fire event]: %@",error.localizedFailureReason);
    }
    
    return success;
}

- (void)gameFireState:(NSString *)state userInfo:(NSDictionary *)userInfo inDelay:(float)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SCENE_TRANSISTION_DURATION_NORMAL * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self gameFireEvent:state userInfo:userInfo];
    });
}



#pragma mark _ SIPowerUp Shitttt
- (void)powerUpActivatePowerUp:(SIPowerUp *)powerUp {
    [_gameModel.powerUpArray addObject:powerUp];
    [[MKStoreKit sharedKit] consumeCredits:[NSNumber numberWithInt:[SIPowerUp costForPowerUp:powerUp.type]] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
    BOOL success = YES;
    switch (powerUp.type) {
        case SIPowerUpTypeTimeFreeze:
            _timeFreezeMultiplier = 0.1f;
            _sceneGame.progressBarPowerUp.hidden = NO;
            [self powerUpAddSnowEmitter];
            break;
        case SIPowerUpTypeRapidFire:
            [self gameForceCorrectMove];
            [self powerUpAddFireEmitter];
            _sceneGame.progressBarPowerUp.hidden = NO;
            break;
        case SIPowerUpTypeFallingMonkeys:
            /*Do Falling Monkeys in Setup*/
            success = [self gameFireEvent:kSITKStateMachineEventGameFallingMonkeyStart userInfo:nil];
            if (!success) {
                [self gameFireEvent:kSITKStateMachineEventGameMenuEnd userInfo:nil];
            }
            break;
        default:
            break;
    }
}
- (void)powerUpDectivatePowerUp:(SIPowerUp *)powerUpClass {
    switch (powerUpClass.type) {
        case SIPowerUpTypeTimeFreeze:
            _timeFreezeMultiplier   = 1.0f;
            _sceneGame.progressBarPowerUp.hidden = YES;
            [self powerUpRemoveSnowEmitter];
            break;
        case SIPowerUpTypeRapidFire:
            [self powerUpRemoveFireEmitter];
            _sceneGame.progressBarPowerUp.hidden = YES;
            break;
        case SIPowerUpTypeFallingMonkeys:
            /*Do Falling Monkeys Breakdown*/
            [_gameModel.powerUpArray removeAllObjects];
            break;
        default:
            break;
    }
    [_gameModel.powerUpArray removeObject:powerUpClass];
}
- (void)powerUpAddFireEmitter {
    SKEmitterNode *emitterNode              = [[HLEmitterStore sharedStore] emitterCopyForKey:kSIEmitterFireProgressBarPowerUp];
    
    if (emitterNode == nil) {
        emitterNode                         = [[HLEmitterStore sharedStore] setEmitterWithResource:kSIEmitterFireProgressBarPowerUp forKey:kSIEmitterFireProgressBarPowerUp];
    }
    emitterNode.name                        = kSINodeEmitterFire;
    emitterNode.targetNode                  = _sceneGame.progressBarPowerUp;
    [_sceneGame.progressBarPowerUp addChild:emitterNode];
    
}
- (void)powerUpRemoveFireEmitter {
    for (SKNode *node in _sceneGame.progressBarPowerUp.children) {
        if ([node.name isEqualToString:kSINodeEmitterFire]) {
            [node removeFromParent];
        }
    }
}
- (void)powerUpAddSnowEmitter {
    SKEmitterNode *emitterNode              = [[HLEmitterStore sharedStore] emitterCopyForKey:kSIEmitterSnowTimeFreeze];
    
    if (emitterNode == nil) {
        emitterNode                         = [[HLEmitterStore sharedStore] setEmitterWithResource:kSIEmitterSnowTimeFreeze forKey:kSIEmitterSnowTimeFreeze];
    }
    emitterNode.name                        = kSINodeEmitterSnow;
//    emitterNode.position                    = CGPointMake(0.0f, _sceneSize.height);
    emitterNode.targetNode                  = _sceneGame.scoreTotalLabel;
    emitterNode.zPosition                   = [SIGameController floatZPositionGameForContent:SIZPositionGameContentMoveScoreEmitter];
    emitterNode.xScale                      = 2.0f;
    [_sceneGame.scoreTotalLabel addChild:emitterNode];

//    emitterNode.targetNode                  = _sceneGame.progressBarPowerUp;
//    [_sceneGame.progressBarPowerUp addChild:emitterNode];
    
}
- (void)powerUpRemoveSnowEmitter {
    for (SKNode *node in _sceneGame.scoreTotalLabel.children) {
        if ([node.name isEqualToString:kSINodeEmitterSnow]) {
            [node removeFromParent];
        }
    }
}

#pragma mark Accelerometer Methods
- (void)startAccelerometerForShake {
    if ([_motionManager isAccelerometerAvailable]) {
        _motionManager.accelerometerUpdateInterval = ACCELEROMETER_UPDATE_INTERVAL; /*Get reading 20 times a second*/
        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                double magnitude                        = sqrt(pow(accelerometerData.acceleration.x, 2) + pow(accelerometerData.acceleration.y, 2) + pow(accelerometerData.acceleration.z, 2));
                
                /*Adjust the magnititude*/
                double adjustedMag                      = fabs(magnitude - 1.0);
                
                if (adjustedMag > SHAKE_THRESHOLD) { /*Phone is Shaken*/
                    if (_sceneGameShakeIsActive) {
                        _sceneGameShakeRestCount        = 0;
                    } else {
                        _sceneGameShakeIsActive         = YES;
                        SIMove *move                    = [[SIMove alloc] init];
                        move.moveCommand                = SIMoveCommandShake;
                        move.moveCommandAction          = SIMoveCommandActionShake;
                        [self sceneGameDidRecieveMove:move];
                    }
                } else { /*Phone is at rest*/
                    if (_sceneGameShakeIsActive) {
                        _sceneGameShakeRestCount        = _sceneGameShakeRestCount + 1;
                        if (_sceneGameShakeRestCount > REST_COUNT_THRESHOLD) {
                            _sceneGameShakeIsActive     = NO;
                            _sceneGameShakeRestCount    = 0;
                        }
                    }
                }
            });
        }];
    } else {
        NSLog(@"Accelerometer Not Available!");
    }
}

#pragma mark SIGame Helpers
- (void)gameProcessAndApplyCorrectMove:(SIMove *)move {
    
    _gameModel.game.totalScore              = _gameModel.game.totalScore + move.moveScore;
    
    _gameModel.game.isHighScore             = [SIGame isDevieHighScore:_gameModel.game.totalScore withNSUserDefaults:[NSUserDefaults standardUserDefaults]];
    
    _gameModel.game.freeCoinInPoints        = [SIGame updatePointsTillFreeCoinMoveScore:_gameModel.game.totalScore withNSUserDefaults:[NSUserDefaults standardUserDefaults] withCallback:^(BOOL willAwardFreeCoin) {
        if (willAwardFreeCoin) {
            _gameModel.game.freeCoinsEarned = _gameModel.game.freeCoinsEarned + 1;
            if (_currentScene == _sceneGame) {
                [_sceneGame sceneGameShowFreeCoinEarned];
            }
            [SIGame playSound:kSISoundFXChaChing];
        }
    }];
    _gameModel.game.freeCoinPercentRemaining    = _gameModel.game.freeCoinInPoints / POINTS_NEEDED_FOR_FREE_COIN;
    
    [SIGame updateLifetimePointsScore:_gameModel.game.totalScore withNSUserDefaults:[NSUserDefaults standardUserDefaults]];
}

- (void)goToStartMenu {
    _sceneGame.popupNode = nil;
    [self presentScene:SIGameControllerSceneMenu];
}

- (void)gameForceCorrectMove {
    SIMove *move = [[SIMove alloc] init];
    move.moveCommand = _currentMove.moveCommand;
    NSDictionary *userInfo = @{ @"move" : move };
    NSError *error                      = nil;
    BOOL success                        = [_gameModel.stateMachine fireEvent:kSITKStateMachineEventGameMoveEntered userInfo:userInfo error:&error];
    if (!success) {
        NSLog(@"Error [unable to process move]: %@",error.localizedFailureReason);
        move                            = nil;
    }
}

- (void)startNewGame {
    
    NSLog(@"Wahoo!! Start a new game!");
    
//    [_sceneGame dismissModalNodeAnimation:HLScenePresentationAnimationFade];
    _sceneGame.popupNode = nil;
    
    BOOL success = [self gameFireEvent:kSITKStateMachineEventGameWaitForMove userInfo:nil];
    if (!success) {
        [self gameFireEvent:kSITKStateMachineEventGameMenuEnd userInfo:nil];
    }
}

- (void)sceneGamePopupGameOverShareScoreButton {
    NSString *firstPart = [NSString stringWithFormat:@"%@ %0.2f %@",@"YES! I just got ", _gameModel.game.totalScore,@" points in Swype It #SwypeIt https://itunes.apple.com/app/swypeit/id939288788"];
    NSArray *activityItems = [NSArray arrayWithObjects:firstPart, nil];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)sceneGamePopupGameOverShopButton {
    _sceneGamePopupContinue.bottomNode                              = nil;
    _sceneGamePopupContinue.centerNode                              = nil;
    _sceneGamePopupContinue.topNode                                 = nil;
    _sceneGamePopupContinueSIMenuNodeStore.delegate                 = self;
   [_sceneGamePopupContinueSIMenuNodeStore.backButtonNode setTouchUpInsideTarget:self selector:@selector(sceneGamePopupGameOver)];
    _sceneGamePopupContinue.backgroundSize                          = CGSizeMake(_sceneSize.width - [SIGameController xPaddingPopupContinue], _sceneSize.height - [SIGameController yPaddingPopupContinue]);
    _sceneGamePopupContinue.centerNode                              = _sceneGamePopupContinueSIMenuNodeStore;
    [_sceneGamePopupContinue layoutXYZ];
}

- (void)sceneGamePopupGameOverBackButton {
    [self sceneGamePopupGameOver];
}

- (void)sceneGamePopupGameOver {
    _sceneGamePopupContinue.backgroundSize                          = CGSizeMake(_sceneSize.width - [SIGameController xPaddingPopupContinue], _sceneSize.height - [SIGameController yPaddingPopupContinue]);
    _sceneGamePopupContinue.dismissButtonVisible                    = YES;
    _sceneGamePopupContinue.delegate                                = self;
    
    _sceneGamePopupContinue.bottomNode                              = nil;
    
    _sceneGamePopupContinue.bottomNode                              = _sceneGamePopupGameOverBottomNode;
    
    ((SKLabelNode *)_sceneGamePopupContinue.titleContentNode).text  = NSLocalizedString(kSITextPopupContinueGameOver, nil);
    
    _sceneGamePopupContinue.centerNode                              = nil;
    _sceneGamePopupContinue.topNode                                 = nil;
    
    [self configureGameOverDetailsSpriteNode:_sceneGamePopupGameOverEndNode forGame:_gameModel.game];
    
    _sceneGamePopupGameOverUserMessageLabelNode.text                = [SIGame userMessageForScore:_gameModel.game.totalScore isHighScore:_gameModel.game.isHighScore highScore:[SIGame devieHighScoreNSUserDefaults:[NSUserDefaults standardUserDefaults]]];
    _sceneGamePopupContinue.centerNode                              = _sceneGamePopupGameOverUserMessageLabelNode;
    _sceneGamePopupContinue.centerNodePosition                      = CGPointMake(0.0f, 0.0f);// CGRectGetMaxY(_sceneGamePopupGameOverBottomNode.frame));// + VERTICAL_SPACING_8 + (_sceneGamePopupGameOverUserMessageLabelNode.size.height / 2.0f));
    
    _sceneGamePopupContinue.topNode                                 = _sceneGamePopupGameOverEndNode;
    _sceneGamePopupContinue.topNode.position                        = CGPointMake(0.0f, ((SKLabelNode *)_sceneGamePopupContinue.titleContentNode).frame.size.height + (_sceneGamePopupGameOverEndNode.size.height / 2.0f));
}

- (void)sceneGamePopupContinueButtonUseCoins {
    _sceneGamePopupContinue.countDownTimerState = SIPopupCountDownTimerFinished;
    if ([_sceneGamePopupMenuItemTextContinueWithCoin isEqualToString:kSITextPopupContinueBuyCoins]) {
        [self sceneGamePopupGameOverShopButton];
    } else {
        _sceneGame.popupNode = nil;
        BOOL success = [self gameFireEvent:kSITKStateMachineEventGamePayForContinue userInfo:@{kSINSDictionaryKeyPayToContinueMethod : @(SISceneGamePopupContinueMenuItemCoin)}];
        if (!success) {
            [self gameFireEvent:kSITKStateMachineEventGameMenuEnd userInfo:nil];
        }
    }
}

- (void)sceneGamePopupContinueButtonWatchAds {
    _sceneGamePopupContinue.countDownTimerState = SIPopupCountDownTimerFinished;
    _sceneGame.popupNode = nil;
    BOOL success = [self gameFireEvent:kSITKStateMachineEventGamePayForContinue userInfo:@{kSINSDictionaryKeyPayToContinueMethod : @(SISceneGamePopupContinueMenuItemAd)}];
    if (!success) {
        [self gameFireEvent:kSITKStateMachineEventGameMenuEnd userInfo:nil];
    }
}

- (void)sceneGamePopupContinueButtonEndGame {
    _sceneGamePopupContinue.countDownTimerState         = SIPopupCountDownTimerFinished;
    [_sceneGamePopupContinue.topNode runAction:[SKAction scaleTo:1.0f duration:0.0f]];
    [self gameFireEvent:kSITKStateMachineEventGameMenuEnd userInfo:nil];
}

- (void)oneHandGameModeButtonTouchedUpInside:(INSKButtonNode *)button {
    if (button.selected) {
        _gameModel.game.gameMode = SIGameModeOneHand;
    } else {
        _gameModel.game.gameMode = SIGameModeTwoHand;
    }
}
- (void)sceneMenuStartShopButtonTouchedUpInside:(INSKButtonNode *)button {
    [self controllerSceneMenuShowMenu:_menuNodeStore menuNodeAnimiation:SIMenuNodeAnimationPush delay:SCENE_TRANSISTION_DURATION_NOW];
//    [_sceneMenu pushMenuNode:_menuNodeStore];
}

/*
 This is used to configure the details for the node that comes up on the end game popup
    It has the details such as coing earcned and you know all that fun shit
 */
- (void)configureGameOverDetailsSpriteNode:(SKSpriteNode *)spriteNode forGame:(SIGame *)game {
    for (SIPopupGameOverOverDetailsRowNode *row in spriteNode.children) {
        if ([row.name isEqualToString:kSINodePopupRowTotalScore]) {
            row.scoreLabel.text                 = [NSString stringWithFormat:@"%0.2f",game.totalScore];
            row.textLabel.text                  = NSLocalizedString(kSITextMenuEndGameScore, nil);
            
        } else if ([row.name isEqualToString:kSINodePopupRowHighScore]) {
            if (game.isHighScore) {
                row.textLabel.text              = NSLocalizedString(kSITextMenuEndGameHighScoreNew, nil);
                row.scoreLabel.text             = [NSString stringWithFormat:@"%0.2f",game.totalScore];
                
            } else {
                row.textLabel.text              = NSLocalizedString(kSITextMenuEndGameHighScore, nil);
                row.scoreLabel.text             = [NSString stringWithFormat:@"%0.2f",[[NSUserDefaults standardUserDefaults] floatForKey:kSINSUserDefaultLifetimeHighScore]];
            }
            
        } else if ([row.name isEqualToString:kSINodePopupRowFreeCoins]) {
            row.scoreLabel.text                 = [NSString stringWithFormat:@"%i",game.freeCoinsEarned];
            row.textLabel.text                  = NSLocalizedString(kSITextMenuEndGameFreeCoinsEarned, nil);
            
        }
    }
}

- (SKSpriteNode *)SISpriteNodePopupGameOverBottomNode {
    INSKButtonNode *shopButton                  = [SIGameController SIINButtonNamed:kSIAssestPopupButtonShop label:[SIGameController SILabelParagraph:NSLocalizedString(kSITextMenuStartScreenStore, nil)]];
    shopButton.name                             = kSINodeButtonShop;
    [shopButton setTouchUpInsideTarget:self selector:@selector(sceneGamePopupGameOverShopButton)];
    INSKButtonNode *shareButton                 = [SIGameController SIINButtonNamed:kSIAssestPopupButtonShare label:[SIGameController SILabelParagraph:NSLocalizedString(kSITextPopupContinueShare, nil)]];
    shareButton.name                            = kSINodeButtonPlayAgain;
    [shareButton setTouchUpInsideTarget:self selector:@selector(sceneGamePopupGameOverShareScoreButton)];
    INSKButtonNode *playAgainButton             = [SIGameController SIINButtonNamed:kSIAssestPopupButtonEndGame label:[SIGameController SILabelParagraph:NSLocalizedString(kSITextPopupContinuePlayAgain, nil)]];
    playAgainButton.name                        = kSINodeButtonPlayAgain;
    [playAgainButton setTouchUpInsideTarget:self selector:@selector(startNewGame)];
    INSKButtonNode *mainMenuButton              = [SIGameController SIINButtonNamed:kSIAssestPopupButtonEndGame label:[SIGameController SILabelParagraph:NSLocalizedString(kSITextPopupContinueMainMenu, nil)]];
    mainMenuButton.name                         = kSINodeButtonEndGame;
    [mainMenuButton setTouchUpInsideTarget:self selector:@selector(goToStartMenu)];
    
    SKSpriteNode *node                          = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(mainMenuButton.size.width, (mainMenuButton.size.height * 4.0f) + VERTICAL_SPACING_8)];
    
    [node addChild:playAgainButton];
    [node addChild:shareButton];
    [node addChild:shopButton];
    [node addChild:mainMenuButton];

    shopButton.position                         = CGPointMake(0.0f, (7.0f * (playAgainButton.size.height / 2.0f)) + (VERTICAL_SPACING_8 + VERTICAL_SPACING_4));
    shareButton.position                        = CGPointMake(0.0f, (5.0f * (playAgainButton.size.height / 2.0f)) + (VERTICAL_SPACING_8));
    playAgainButton.position                    = CGPointMake(0.0f, (3.0f * (playAgainButton.size.height / 2.0f)) + (VERTICAL_SPACING_4));
    mainMenuButton.position                     = CGPointMake(0.0f, (playAgainButton.size.height / 2.0f));
    
    return node;
}
- (void)sceneGamePopupContinueGameTimerAsyncUpdate:(NSTimer *)timer {
    if (_sceneGamePopupContinue.countDownTimerState == SIPopupCountDownTimerRunning) {
        NSTimeInterval remainingTime = 4.0f - ([NSDate timeIntervalSinceReferenceDate] - _sceneGamePopupContinue.startTime);
        //        NSTimeInterval remainingTime = 11.0f - (currentTime - _popupNode.startTime);
        ((SKLabelNode *)_sceneGamePopupContinue.topNode).text = [NSString stringWithFormat:@"%i",(int)remainingTime];
        [_sceneGamePopupContinue.topNode runAction:[SKAction scaleTo:remainingTime - floorf(remainingTime) duration:0.0f]];
        if (remainingTime < (EPSILON_NUMBER + 1.0f)) {
            //Call to go to end game
            [_continueGameTimer invalidate];
            [self sceneGamePopupContinueButtonEndGame];
        }
    }
    
}


#pragma mark -
#pragma mark - Delegate Handlers
#pragma mark SISingletonGameDelegate

/**
 Called when the model is ready for a new move to be
 loaded by the controller to the view
 */
//- (void)controllerSingletonGameLoadNewMove {
//    
//    if ([SISingletonGame singleton].currentGame.moveScore > EPSILON_NUMBER) {
//        SKLabelNode *moveLabel = [SIGameController moveScoreLabel:[SISingletonGame singleton].currentGame.moveScore];
//        moveLabel.position = [SISingletonGame singleton].currentGame.currentMove.touchPoint;
//
//        [_sceneGame sceneGameWillShowMoveScore:moveLabel];
//        
//        SIMove *moveForBackground = [SISingletonGame singleton].currentGame.currentMove;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            [[SISingletonAchievement singleton] singletonAchievementWillProcessMove:moveForBackground];
//        });
//        
//        [_sceneGame sceneGameLaunchMoveCommandLabelWithCommandAction:moveForBackground.moveCommandAction];
//
//    }
//    
//    
//    
//    
//    if ([SISingletonGame singleton].currentGame.isHighScore) {
//        _sceneGame.highScore = YES;
//    }
//    
//    _sceneGame.backgroundColor              = [SISingletonGame singleton].currentGame.currentBackgroundColor;
//    _sceneGame.progressBarMove.fillColor    = [SISingletonGame singleton].currentGame.currentBackgroundColor;
//    _sceneGame.progressBarPowerUp.fillColor = [SISingletonGame singleton].currentGame.currentBackgroundColor;
//    _sceneGame.scoreTotalLabel.text         = [NSString stringWithFormat:@"%0.2f",[SISingletonGame singleton].currentGame.totalScore];
//    _sceneGame.progressBarFreeCoin.progress = [SISingletonGame singleton].currentGame.freeCoinPercentRemaining;
//    SKLabelNode *label                      = [SKLabelNode labelNodeWithFontNamed:kSISFFontDisplayHeavy];
//    label.fontSize                          = [SIGameController SIFontSizeMoveCommand];
//    label.text                              = [SIGame stringForMove:[SISingletonGame singleton].currentGame.currentMove.moveCommand];
//    label.userInteractionEnabled            = YES;
//    _sceneGame.moveCommandLabel             = label;
//
//}

/**
 Called when the user should be prompted to continue
 the game
 */
//- (void)controllerSingletonGameShowContinue {
//
//}
//
///**
// Called when a free coin is earned
// Handle the sound for this in the controller?
// */
//- (void)controllerSingletonGameShowFreeCoinEarned {
//    [_sceneGame sceneGameShowFreeCoinEarned];
//}
//
///**
// Called by model to alert controller when sound is ready to be played...
// */
//- (void)controllerSingletonGamePlayFXSoundNamed:(NSString *)soundName {
//    if ([SIConstants isFXAllowed]) {
//        [[SoundManager sharedManager] playSound:soundName];
//    }
//}

/**
 Called when the model is ready for the powerup to start
 */
//- (void)controllerSingletonGameActivatePowerUp:(SIPowerUpType)powerUp {
//    switch (powerUp) {
//        case SIPowerUpTypeFallingMonkeys:
//            /*pause the singleton*/
//            [[SISingletonGame singleton] singletonGameWillPause];
//            /*launch the other scene with no delay*/
//            [self presentScene:SIGameControllerSceneFallingMonkey];
//            break;
//        case SIPowerUpTypeRapidFire:
//            /*Bring out progress bar*/
//            
//            /*Activate Fire Emmiters*/
//            break;
//        case SIPowerUpTypeTimeFreeze:
//            /*Bring out progress bar*/
//            
//            /*Avtivate snow*/
//            break;
//        default: //SIPowerUpTypeNone
//            NSLog(@"Error");
//            break;
//    }
//}
//
///**
// Called when the powerup is deactived
// */
//- (void)controllerSingletonGameDeactivatePowerUp:(SIPowerUpType)powerUp {
//    switch (powerUp) {
//        case SIPowerUpTypeFallingMonkeys:
//            /*pause the singleton*/
//            [self presentScene:SIGameControllerSceneGame];
//            /*launch the other scene with no delay*/
//            
//            break;
//        case SIPowerUpTypeRapidFire:
//            /*Hide Progress Barr*/
//            
//            /*Remove Fire Emmiter*/
//            break;
//        case SIPowerUpTypeTimeFreeze:
//            /*Hide Progress Barr*/
//            
//            /*Deactivate Snow Emitter*/
//            break;
//        default: //SIPowerUpTypeNone
//            NSLog(@"Error");
//            break;
//    }
//}

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
    if (error.code != GKErrorNotAuthenticated) {
        [JCNotificationCenter enqueueNotificationWithTitle:@"Dang!" message:@"Can't connect to game center" tapHandler:^{
            NSLog(@"Tacos!!!!! hehe");
        }];
    }
}

#pragma mark SIGameSceneDelegate
/**
 Called when the scene recognizes a gesture
 Pinch, Tap, Swype of Shake
 */
- (void)sceneGameDidRecieveMove:(SIMove *)move {
    NSDictionary *userInfo = @{ @"move" : move };
    NSError *error                      = nil;
    BOOL success                        = [_gameModel.stateMachine fireEvent:kSITKStateMachineEventGameMoveEntered userInfo:userInfo error:&error];
    if (!success) {
        NSLog(@"Error [unable to process move]: %@",error.localizedFailureReason);
        move                            = nil;
    }
}

/**
 Fires when the pause button is pressed
 */
- (void)controllerSceneGamePauseButtonTapped {
    [self gameFireEvent:kSITKStateMachineEventGamePause userInfo:nil];
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
- (void)controllerSceneGamePowerUpToolbarTappedWithToolTag:(NSString *)toolTag {
    
    if ([_gameModel.stateMachine isInState:kSITKStateMachineStateGamePaused] == NO) {
        if ([SIPowerUp canStartPowerUp:[SIPowerUp powerUpForString:toolTag] powerUpArray:_gameModel.powerUpArray]) {
            SIPowerUp *newPowerUp = [[SIPowerUp alloc] initWithPowerUp:[SIPowerUp powerUpForString:toolTag] startTime:_gameTimeTotal];
            [self powerUpActivatePowerUp:newPowerUp];
        }
    }

}

/**
 This is called on every update... So it gets called a ton!
 */
- (SISceneGameProgressBarUpdate *)sceneGameWillUpdateProgressBars {
    SISceneGameProgressBarUpdate *progressBarUpdate = [[SISceneGameProgressBarUpdate alloc] init];
    
    float levelSpeedDivider                         = [SIGame levelSpeedForScore:_gameModel.game.totalScore];
    
    NSTimeInterval durationOfMove                   = (_gameTimeTotal - _currentMove.timeStart) * _timeFreezeMultiplier;
    
    _currentMove.moveScore                          = [SIGame scoreForMoveDuration:durationOfMove withLevelSpeedDivider:levelSpeedDivider];
    
    progressBarUpdate.percentMove                   = _currentMove.moveScore / MAX_MOVE_SCORE;
    
    progressBarUpdate.percentFreeCoin               = _gameModel.game.freeCoinPercentRemaining;
    
    progressBarUpdate.percentPowerUp = [SIPowerUp powerUpPercentRemaining:_gameModel.powerUpArray gameTimeTotal:_gameTimeTotal timeFreezeMultiplier:_timeFreezeMultiplier withCallback:^(SIPowerUp *powerUpToDeactivate) {
        [self powerUpDectivatePowerUp:powerUpToDeactivate];
    }];
        
    progressBarUpdate.pointsMove                    = _gameModel.game.currentPointsRemainingThisRound;
    progressBarUpdate.hasStarted                    = [_gameModel.stateMachine isInState:kSITKStateMachineStateGameIdle] || [_gameModel.stateMachine isInState:kSITKStateMachineStateGameProcessingMove];
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
- (void)menuSceneDidLoadMenuType:(SISceneMenuType)type {
    switch (type) {
        case SISceneMenuTypeStart:
            // TODO: SWITCH THE FUCK OUT OF TEST MODE
            if (!_testMode) {
                switch ([self checkForDailyPrize]) {
                    case SIFreePrizeTypeNone:
                        break;
                    default:
                        _sceneMenuPopupFreePrizeCountLabel.text = [NSString stringWithFormat:@"%d",[SIIAPUtility getDailyFreePrizeAmount]];
//                        _sceneMenuPopupFreePrize.delegate = self;
//                        _sceneMenuPopupFreePrize.userInteractionEnabled = YES;
                        _sceneMenu.popupNode = _sceneMenuPopupFreePrize;
                        break;
                }
                break;
            }
            
        default:
            break;
    }
}


#pragma mark SIFallingMonkeyDelegate
/**
 Called when the scene registers a monkey tap
 */
- (void)sceneFallingMonkeyWasNailed {
    //make a move to send for processing
    SIMove *moveFallingMonkey           = [[SIMove alloc] init];
    moveFallingMonkey.moveCommand       = SIMoveCommandFallingMonkey;
    moveFallingMonkey.moveScore         = VALUE_OF_MONKEY;
    
    //process the move
    [self gameProcessAndApplyCorrectMove:moveFallingMonkey];
    
    //update the falling monkey score
    _sceneFallingMonkey.totalScore      = _gameModel.game.totalScore;

}

/**
 Called when a monkey has hit the bottom of the screen
 */
- (void)sceneFallingMonkeyDidCollideWithBottomEdge {
    SIPowerUp *powerUp = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeFallingMonkeys startTime:0.0f];
    [self powerUpDectivatePowerUp:powerUp];
    [self gameFireEvent:kSITKStateMachineEventGameWaitForMove userInfo:nil];
}

- (void)menuSceneWasTappedToStart {
    if (_sceneMenuStartOneHandModeButton.selected) {
        [self launchSceneGameWithGameMode:SIGameModeOneHand];
    } else {
        [self launchSceneGameWithGameMode:SIGameModeTwoHand];
    }
}

#pragma mark HLGridNodeDelegate
- (void)gridNode:(HLGridNode *)gridNode didTapSquare:(int)squareIndex {
    if (_verbose) {
        NSLog(@"node at index %d tapped",squareIndex);
    }
    if (gridNode == _sceneMenuEndGridNode) {
        switch (squareIndex) {
            case 0: //Share Facebook
                // TODO: add facebook integration
                NSLog(@"Facebook share button activated.");
                break;
            case 1: //Share Twitter
                // TODO: add twitter integration
                NSLog(@"Twitter share button activated.");
                break;
            default:
                break;
        }
    }
}

/**Called to launch an actual game*/
- (void)launchSceneGameWithGameMode:(SIGameMode)gameMode {
    _gameModel.game.gameMode = gameMode;
    if (gameMode == SIGameModeOneHand) {
        [self startAccelerometerForShake];
    } else {
        if ([_motionManager isAccelerometerActive]) {
            [_motionManager stopAccelerometerUpdates];
        }
    }
    //pulse the game to the start
    NSError *error = nil;
    BOOL success = [_gameModel.stateMachine fireEvent:kSITKStateMachineEventGameWaitForMove userInfo:nil error:&error];
    if (success) {
//        [self controllerSceneMenuShowMenu:_menuNodeEnd menuNodeAnimiation:SIMenuNodeAnimationSlideOut delay:0.0f];
    }
    if (_verbose) {
        NSLog(@"Able to Start engine: %@", success ? @"YES" : @"NO");
    }
}

#pragma mark HLMenuNodeDelegate
- (void)menuNode:(HLMenuNode *)menuNode didTapMenuItem:(HLMenuItem *)menuItem itemIndex:(NSUInteger)itemIndex {
    if (menuNode == _sceneGamePopupContinueMenuNode) {
        if ([menuItem.text isEqualToString:_sceneGamePopupMenuItemTextContinueWithCoin]) {
            if ([menuItem.text isEqualToString:kSITextPopupContinueBuyCoins]) {
                _sceneGamePopupContinueSIMenuNodeStore.delegate = self;
                _sceneGamePopupContinue.backgroundSize = CGSizeMake(_sceneSize.width - VERTICAL_SPACING_16, _sceneSize.width - VERTICAL_SPACING_16);
                _sceneGamePopupContinue.centerNode = _sceneGamePopupContinueSIMenuNodeStore;
                [_sceneGamePopupContinue layoutXYZ];
            } else {
                BOOL success = [self gameFireEvent:kSITKStateMachineEventGamePayForContinue userInfo:@{kSINSDictionaryKeyPayToContinueMethod : @(SISceneGamePopupContinueMenuItemCoin)}];
                if (!success) {
                    [self gameFireEvent:kSITKStateMachineEventGameMenuEnd userInfo:nil];
                }
            }
            
        }  else if ([menuItem.text isEqualToString:_sceneGamePopupMenuItemTextContinueWithAd]) {
            BOOL success = [self gameFireEvent:kSITKStateMachineEventGamePayForContinue userInfo:@{kSINSDictionaryKeyPayToContinueMethod : @(SISceneGamePopupContinueMenuItemAd)}];
            if (!success) {
                [self gameFireEvent:kSITKStateMachineEventGameMenuEnd userInfo:nil];
            }
            
        } else if ([menuItem.text isEqualToString:kSITextPopupContinueEnd]) {
            BOOL success = [self gameFireEvent:kSITKStateMachineEventGameMenuEnd userInfo:nil];
            if (!success) { //this is a critical failure...
                [self presentScene:SIGameControllerSceneMenu];
            }
        }
    } else if (menuNode == _sceneMenuSettingsMenuNode) {
        if ([menuItem.text isEqualToString:kSITextMenuSettingsBugReport]) {
            [Instabug invoke];
        } else if ([menuItem.text isEqualToString:kSITextMenuSettingsResetHighScore]) {
            [self resetHighScore];
        } else if ([menuItem.text isEqualToString:kSITextMenuSettingsToggleSoundOffBackground] || [menuItem.text isEqualToString:kSITextMenuSettingsToggleSoundOnBackground]) {
            [self changeBackgroundSoundIsAllowed:menuItem];
        } else if ([menuItem.text isEqualToString:kSITextMenuSettingsToggleSoundOffFX] || [menuItem.text isEqualToString:kSITextMenuSettingsToggleSoundOnFX]) {
            [self changeFXSoundIsAllowed:menuItem];
        } else if ([menuItem.text isEqualToString:kSITextMenuSettingsRestorePurchases]) {
            [[MKStoreKit sharedKit] restorePurchases];
            [self hudWillShowWithTitle:@"Restoring!" info:@"Please wait..." dimBackground:YES animate:YES];

        }
    } else if ([menuNode.name isEqualToString:_sceneMenuStoreMenuNode.name] || menuNode == (HLMenuNode*)_sceneGamePopupContinueSIMenuNodeStore.centerNode) {
        [self requestPurchaseForPack:[SIIAPUtility siiapPackForNameNodeNode:menuItem.text]];
    }
}
- (void)menuNode:(HLMenuNode *)menuNode willDisplayButton:(SKNode *)buttonNode forMenuItem:(HLMenuItem *)menuItem itemIndex:(NSUInteger)itemIndex {
    if (menuNode == _sceneMenuStoreMenuNode) {
        SIStoreButtonNode *button   = (SIStoreButtonNode *)buttonNode;
        button.size                 = [SIGameController SIButtonSize:_sceneSize];
    }
}

#pragma mark HLToolBarNodeDelegate
- (void)toolbarNode:(HLToolbarNode *)toolbarNode didTapTool:(NSString *)toolTag {
    if (toolbarNode == _sceneMenuStartToolbarNode) {
        if ([_sceneMenu modalNodePresented]) {
            [_sceneMenu dismissModalNodeAnimation:HLScenePresentationAnimationFade];
            return;
        }
        if ([toolTag isEqualToString:kSINodeButtonLeaderBoard]) {
            if (_verbose) {
                NSLog(@"Leaderboard Toolbar Button Tapped");
            }
            [self showGameCenterLeaderBoard];
            
        } else if ([toolTag isEqualToString:kSINodeButtonNoAd]) {
            if (_verbose) {
                NSLog(@"Ad Free Toolbar Button Tapped");
            }
            [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:kSIIAPProductIDAdFree];
            [self hudWillShowWithTitle:@"Working..." info:@"Going Ad Free" dimBackground:YES animate:YES];
            
        } else if ([toolTag isEqualToString:kSINodeButtonSettings]) {
            if (_verbose) {
                NSLog(@"Settings button tapped");
            }
            [_sceneMenu pushMenuNode:_menuNodeSettings];
            
        } else if ([toolTag isEqualToString:kSINodeButtonInstructions]) {
            if (_verbose) {
                NSLog(@"Instructions Toolbar Button Tapped");
            }
            [_sceneMenu pushMenuNode:_menuNodeHelp];
            
        } else if ([toolTag isEqualToString:kSINodeButtonAchievement]) {
            NSLog(@"Achievement Toolbar item tapped");
        }
    }
}


#pragma mark HLRingNodeDelegate
- (void)ringNode:(HLRingNode *)ringNode didTapItem:(int)itemIndex {
    switch (itemIndex) {
        case SISceneGameRingNodeEndGame:
            _sceneGame.blurScreen   = NO;
            _sceneGame.ringNode     = nil;
            _sceneGame.popupNode    = _sceneGamePopupContinue;
            [self gameFireEvent:kSITKStateMachineEventGameMenuEnd userInfo:nil];
//            [[SISingletonGame singleton] singletonGameDidEnd];
//            [self presentScene:SIGameControllerSceneMenu];
            break;
        case SISceneGameRingNodePlay:
            [self gameFireEvent:kSITKStateMachineEventGameWaitForMove userInfo:nil];
//            [[SISingletonGame singleton] singletonGameWillResumeAndContinue:NO];
            break;
        case SISceneGameRingNodeSoundBackground:
            if ([SIConstants isBackgroundSoundAllowed]) {
                /*Turn Background Sound Off*/
                [SIGame setBackgroundSoundActive:NO];
                [SIGame stopAllMusic];
            } else {
                /*Turn Sound Background On*/
                [SIGame setBackgroundSoundActive:YES];
                [SIGame playMusic:kSISoundBackgroundMenu looping:YES fadeIn:YES];
            }
            [ringNode setHighlight:![SIConstants isBackgroundSoundAllowed] forItem:itemIndex];
            break;
        case SISceneGameRingNodeSoundFX:
            /*Change Sound FX State*/
            if ([SIConstants isFXAllowed]) {
                /*Turn FX Sound Off*/
                [SIGame setFXSoundActive:NO];
                [SIGame stopAllSounds];
            } else {
                [SIGame setFXSoundActive:YES];
            }
            [ringNode setHighlight:![SIConstants isFXAllowed] forItem:itemIndex];
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
        [self startNewGame];
    } else {
        HLScene *currentHLSceen                         = (HLScene *)_currentScene;
        [currentHLSceen dismissModalNodeAnimation:HLScenePresentationAnimationFade];
    }
}

#pragma mark AdBannerDelegate
- (void)adBannerWasTapped {
    NSLog(@"Ad banner was tapped");
}
////////////////////////////////////////////////////////////////////////////////////
//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//START/////////////////////////////////////////////////////////////////////////////
//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//**********************************************************************************
//**********************************************************************************
//**********************************************************************************
//**********************************************************************************
//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//START/////////////////////////////////////////////////////////////////////////////
//**********************************************************************************
//**********************************************************************************
//**********************************************************************************
//**********************************************************************************
////////////////////////////////////////////////////////////////////////////////////
//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//START/////////////////////////////////////////////////////////////////////////////
//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


#pragma mark SIGameModelDelegate

/**
 Called when the game wants to load
 */
//- (void)gameModelStateLoadingEntered {
//    _sceneLoading = [SIGameController SILoaderSceneLoadingSize:_sceneSize];
//    [self loadingIncrementWillOverrideAndKill:NO];
//    [self presentScene:SIGameControllerSceneLoading];
//    /*Load the scenes*/
//    [self loadAllScenes];
//}

/**
 Called when the game is done loading
 */
- (void)gameModelStateLoadingExited {
    NSLog(@"Load State Exited");
    _sceneLoading = [SIGameController SILoaderSceneLoadingSize:_sceneSize];
    [self loadingIncrementWillOverrideAndKill:NO];
    [self presentScene:SIGameControllerSceneLoading];
    /*Load the scenes*/
    [self loadAllScenes];
    [_loadTimer invalidate];
    _loadTimer = nil;
}
- (void)gameModelStateStartEntered {
    if (_sceneMenu == nil) {
        [NSException raise:NSInvalidArgumentException format:@"Menu Scene Cannot be nil here"];
        _sceneMenu = [self loadMenuScene];
    }
    
    [self presentScene:SIGameControllerSceneMenu];
}

/**
 update screen
 */
- (void)gameModelStateIdleEntered {
    if (_sceneGame == nil) {
        _sceneGame = [self loadGameScene];
    }
    
    if (_currentScene != _sceneGame) {
        [self presentScene:SIGameControllerSceneGame];
    }
    
    //TODO: Add a delay
    if ([_timerStateMachine isInState:kSITKStateMachineStateTimerRunning] == NO) {
        if ([_timerStateMachine isInState:kSITKStateMachineStateTimerPaused]) {
            [self timerFireEvent:kSITKStateMachineEventTimerResume userInfo:nil];
        } else {
            [self timerFireEvent:kSITKStateMachineEventTimerStart userInfo:nil];
        }
    }
    
    _gameModel.game.currentBackgroundColorNumber           = [SIGame newBackgroundColorNumberCurrentNumber:_gameModel.game.currentBackgroundColorNumber totalScore:_gameModel.game.totalScore];
    
    _gameModel.game.currentBackgroundColor                 = [SIGame backgroundColorForScore:_gameModel.game.totalScore forRandomNumber:_gameModel.game.currentBackgroundColorNumber];

    
    if (_gameModel.game.isHighScore) {
        _sceneGame.highScore = YES;
    }
    
    _sceneGame.backgroundColor                          = _gameModel.game.currentBackgroundColor;
    _sceneGame.progressBarPowerUp.backgroundColor       = [SKColor blackColor]; //_gameModel.game.currentBackgroundColor;
    _sceneGame.scoreTotalLabel.text                     = [NSString stringWithFormat:@"%0.2f",_gameModel.game.totalScore];
    SKLabelNode *label                                  = [SKLabelNode labelNodeWithFontNamed:kSISFFontDisplayHeavy];
    label.fontSize                                      = [SIGameController SIFontSizeMoveCommand];
    label.text                                          = [SIGame stringForMove:_currentMove.moveCommand];
    label.userInteractionEnabled                        = YES;
    _sceneGame.moveCommandLabel                         = label;
    
    [self updateBackgroundSound];
}

- (void)gameModelStateProcessingMoveEnteredWithMove:(SIMove *)move {
    
    //if correctMove
    if (move.moveCommand == _currentMove.moveCommand) {
        _currentMove.timeEnd                            = _gameTimeTotal;
        SIMove *moveForBackground                       = _currentMove;
        
        [self gameProcessAndApplyCorrectMove:_currentMove];
        
        //  launch the move command and such
        _sceneGame.scoreMoveLabel                       = [SIGameController SILabelSceneGameMoveScoreLabel];
        [_sceneGame sceneGameLaunchMoveCommandLabelWithCommandAction:move.moveCommandAction];
        
        //  send move to achievement
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [[SISingletonAchievement singleton] singletonAchievementWillProcessMove:moveForBackground];
        });
        //  get new move data
        _currentMove                                    = [[SIMove alloc] initWithRandomMoveForGameMode:_gameModel.game.gameMode powerUpArray:[_gameModel.powerUpArray copy]];
        _currentMove.timeStart                          = _gameTimeTotal;
        
        //  show new move data
        BOOL success = [self gameFireEvent:kSITKStateMachineEventGameWaitForMove userInfo:nil];
        if (!success) {
            [self gameFireEvent:kSITKStateMachineEventGameMenuEnd userInfo:nil];
        }
        
    } else {
        //else notCorrectMove
        _sceneGame.moveCommandLabel = nil;
        
        [self gameFireEvent:kSITKStateMachineEventGameWrongMoveEntered userInfo:nil];
        //  load start/end scene
        if (_sceneMenu == nil) {
            [NSException raise:NSInvalidArgumentException format:@"Menu Scene Cannot be nil here"];
            _sceneMenu                                  = [self loadMenuScene];
        }
    }
}

/**
 Always get new data when you leave the processing move screen, even if they enter
 the wrong move, because there is always the oppertunity the user continues with
 coins.
 */
- (void)gameModelStateProcessingMoveExited {
    //where is total score being updated?
    
    //check if high score here?
    if (_gameModel.game.isHighScore) {
        _sceneGame.highScore = YES;
    }
    
    _sceneGame.scoreTotalLabel.text                     = [NSString stringWithFormat:@"%0.2f",_gameModel.game.totalScore];
    _sceneGame.progressBarFreeCoin.progress             = _gameModel.game.freeCoinPercentRemaining;
    
}

/**
 //pause time
 
 //display blur screen
 
 //present continue popup
 
 //connect it's gesture target!
 */
- (void)gameModelStatePopupContinueEntered {
    [self timerFireEvent:kSITKStateMachineEventTimerPause userInfo:nil];
    
    _sceneGamePopupContinue.backgroundSize                      = CGSizeMake(_sceneSize.width - [SIGameController xPaddingPopupContinue], _sceneSize.width - [SIGameController xPaddingPopupContinue]);

    _sceneGamePopupContinue.dismissButtonVisible                = NO;
    /*
     The center nod will contain the watch ads and pay to continue buttons
     */
    _sceneGamePopupContinue.centerNode                          = _sceneGamePopupContinueButtonsNode;
    _sceneGamePopupContinue.centerNodePosition                  = CGPointMake(0.0f, (-1.0f * (_sceneGamePopupContinue.backgroundSize.height / 2.0f)) + VERTICAL_SPACING_4 + _sceneGamePopupGameOverEndGameButton.size.height + (VERTICAL_SPACING_4 / 2.0f) + ([SIGameController SISpriteNodePopupContinueCenterNode].size.height / 2.0f));
    for (SKNode *node in _sceneGamePopupContinue.centerNode.children) {
        if ([node.name isEqualToString:kSINodeButtonUseCoins]) {
            if ([SIIAPUtility canAffordContinueNumberOfTimesContinued:_gameModel.game.currentNumberOfTimesContinued]) {
                _sceneGamePopupMenuItemTextContinueWithCoin     = [NSString stringWithFormat:@"Use %d Coins!",(int)[SIGame lifeCostForNumberOfTimesContinued:_gameModel.game.currentNumberOfTimesContinued]];
            } else {
                _sceneGamePopupMenuItemTextContinueWithCoin     = kSITextPopupContinueBuyCoins;
            }
            ((SKLabelNode *)[((INSKButtonNode *)node).nodeNormal childNodeWithName:kSINodeButtonText]).text = _sceneGamePopupMenuItemTextContinueWithCoin;
            [((INSKButtonNode *)node) setTouchUpInsideTarget:self selector:@selector(sceneGamePopupContinueButtonUseCoins)];

        } else if ([node.name isEqualToString:kSINodeButtonWatchAds]) {
            _sceneGamePopupMenuItemTextContinueWithAd           = [NSString stringWithFormat:@"Watch %d Ads!",(int)[SIGame adCountForNumberOfTimesContinued:_gameModel.game.currentNumberOfTimesContinued]];
            ((SKLabelNode *)[((INSKButtonNode *)node).nodeNormal childNodeWithName:kSINodeButtonText]).text = _sceneGamePopupMenuItemTextContinueWithAd;
            [((INSKButtonNode *)node) setTouchUpInsideTarget:self selector:@selector(sceneGamePopupContinueButtonWatchAds)];

        }
    }
    
    _sceneGamePopupContinue.bottomNode                          = _sceneGamePopupGameOverEndGameButton;
    [_sceneGamePopupGameOverEndGameButton setTouchUpInsideTarget:self selector:@selector(sceneGamePopupContinueButtonEndGame)];
    
    _sceneGamePopupContinue.bottomNodeBottomSpacing             = (((INSKButtonNode *)_sceneGamePopupContinue.bottomNode).size.height / 2.0f) + VERTICAL_SPACING_4;

    _sceneGamePopupContinue.topNode                             = _sceneGamePopupContinueCountdownLabel;
    CGFloat topNodeYPos                                         = CGRectGetMinY(_sceneGamePopupContinue.titleContentNode.frame) - ((CGRectGetMinY(_sceneGamePopupContinue.titleContentNode.frame) - CGRectGetMaxY(_sceneGamePopupContinue.centerNode.frame))/2.0f);
    _sceneGamePopupContinue.topNode.position                    = CGPointMake(0.0f, topNodeYPos);

    /*This is all you need to set to make the game scene display a popup because it will relayout the z*/
    _sceneGamePopupContinue.startTime                           = [NSDate timeIntervalSinceReferenceDate];
    _sceneGamePopupContinue.countDownTimerState                 = SIPopupCountDownTimerRunning;
    _continueGameTimer                                          = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(sceneGamePopupContinueGameTimerAsyncUpdate:) userInfo:nil repeats:YES];

    _sceneGame.popupNode                                        = _sceneGamePopupContinue;
}

/**
 //pause time
 
 //display blur screen
 
 //present ring node
 
 //connect it's gesture target
 */
- (void)gameModelStatePauseEntered {
    BOOL success = [self timerFireEvent:kSITKStateMachineEventTimerPause userInfo:nil];
    if (!success) {
        [self timerFireEvent:kSITKStateMachineEventTimerStopCriticalFailure userInfo:nil];
    }
    

    [_sceneGameRingNodePause setHighlight:![SIConstants isFXAllowed] forItem:1];
    [_sceneGameRingNodePause setHighlight:![SIConstants isBackgroundSoundAllowed] forItem:2];
    _sceneGame.blurScreen                               = YES;
    _sceneGameRingNodePause.delegate                    = self;
    _sceneGame.ringNode                                 = _sceneGameRingNodePause;
}

/**
 Called when the game exits the paused state, whether it be to end the game or resume it
 */
- (void)gameModelStatePauseExited {
    _sceneGame.blurScreen                               = NO;
    _sceneGame.ringNode                                 = nil;
}

/**
 //show ad or charge user
 */
- (void)gameModelStatePayingForContinueEnteredWithPayMethod:(SISceneGamePopupContinueMenuItem)paymentMethod {
    _gameModel.game.currentNumberOfTimesContinued++;
    BOOL success = YES;
    switch (paymentMethod) {
        case SISceneGamePopupContinueMenuItemAd:
            _interstitialAdPresentationIsLive           = YES;
            [self interstitialAdPresent];
            break;
            
        case SISceneGamePopupContinueMenuItemCoin:
        default:
            if ([SIIAPUtility canAffordContinueNumberOfTimesContinued:_gameModel.game.currentNumberOfTimesContinued]) {
                [[MKStoreKit sharedKit] consumeCredits:[NSNumber numberWithInteger:[SIGame lifeCostForNumberOfTimesContinued:_gameModel.game.currentNumberOfTimesContinued]] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
            }
//            _currentMove                                = [[SIMove alloc] initWithRandomMoveForGameMode:_gameModel.game.gameMode powerUpArray:[_gameModel.powerUpArray copy]];
            success                                     = [self gameFireEvent:kSITKStateMachineEventGameWaitForMove userInfo:nil];
            [self gameForceCorrectMove];
            break;
    }
    if (!success) {
        [self gameFireEvent:kSITKStateMachineEventGameMenuEnd userInfo:nil];
    }
    
}

/**
 //show menu with end configuration
 
 //send score to game center
 */
- (void)gameModelStateEndEntered {
    if (!_sceneMenu) {
        [NSException raise:NSInvalidArgumentException format:@"Menu Scene Cannot be nil here"];

        _sceneMenu                                                  = [self loadMenuScene];
    }
    
//    [self presentScene:SIGameControllerSceneMenu];
    
    //This alters the state of the popup
    
    [self sceneGamePopupGameOver];
    [self gameCenterSubmitScore];
    if ([SIPowerUp isPowerUpActive:SIPowerUpTypeRapidFire powerUpArray:_gameModel.powerUpArray]) {
        [self powerUpRemoveFireEmitter];
        _sceneGame.progressBarPowerUp.hidden = YES;
    }
    if ([SIPowerUp isPowerUpActive:SIPowerUpTypeTimeFreeze powerUpArray:_gameModel.powerUpArray]) {
        [self powerUpRemoveSnowEmitter];
        _sceneGame.progressBarPowerUp.hidden = YES;
    }
}

/**
 clear data
 */
- (void)gameModelStateEndExited {
    
    [SIGameController setGameModel:_gameModel forGame:_gameModel.game withCurrentMove:_currentMove];

}



/**
 //pause time
 
 //make sure monkey scene is ready
 //transistion to monkey scene fast!
 */
- (void)gameModelStateFallingMonkeyEntered {
    BOOL success = [self timerFireEvent:kSITKStateMachineEventTimerPause userInfo:nil];
    if (!success) {
        [self timerFireEvent:kSITKStateMachineEventTimerStopCriticalFailure userInfo:nil];
    }
    if (_sceneFallingMonkey == nil) {
        _sceneFallingMonkey             = [self loadFallingMonkeyScene];
    }
    _sceneFallingMonkey.sceneDelegate   = self;
    _sceneFallingMonkey.totalScore      = _gameModel.game.totalScore;
    [self presentScene:SIGameControllerSceneFallingMonkey];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_sceneFallingMonkey launchMonkey];
    });
}

////////////////////////////////////////////////////////////////////////////////////
//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//END///////////////////////////////////////////////////////////////////////////////
//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////////////////////////////////////////////////////////
//**********************************************************************************
//**********************************************************************************
////////////////////////////////////////////////////////////////////////////////////
//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//END///////////////////////////////////////////////////////////////////////////////
//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//**********************************************************************************
//**********************************************************************************
////////////////////////////////////////////////////////////////////////////////////
//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//END///////////////////////////////////////////////////////////////////////////////
//\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
////////////////////////////////////////////////////////////////////////////////////


#pragma mark INSpriteKitButtonDelegate
- (void)buttonNode:(INSKButtonNode *)button touchUp:(BOOL)touchUp inside:(BOOL)touchInside {
    if (touchUp) {
        if (touchInside) {
            NSLog(@"'%@' touched up inside", button.name);
        } else {
            NSLog(@"'%@' touched up outside", button.name);
        }
    } else {
        NSLog(@"'%@' touched down", button.name);
    }
}

- (void)buttonNode:(INSKButtonNode *)button touchMoveUpdatesHighlightState:(BOOL)isHighlighted {
    if (isHighlighted) {
        NSLog(@"'%@' highlights again", button.name);
    } else {
        NSLog(@"'%@' not highlighted anymore", button.name);
    }
}

- (void)buttonNodeTouchCancelled:(INSKButtonNode *)button {
    NSLog(@"'%@' has all touches get cancelled", button.name);
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
+ (CGFloat)SIFontSizeMoveScore {
    return [SIGameController SIFontSizeMoveCommand] * 1.5f;
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
+ (CGFloat)SIFontSizePopup {
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
+ (CGFloat)SIFontSizeText_x4 {
    return [SIGameController SIFontSizeText] + 6.0f;
}
+ (CGFloat)SIFontSizeTextFree {
    if (IS_IPHONE_4) {
        return 12.0f;
    } else if (IS_IPHONE_5) {
        return 12.0f;
    } else if (IS_IPHONE_6) {
        return 12.0f;
    } else if (IS_IPHONE_6_PLUS) {
        return 15.0f;
    } else {
        return 16.0f;
    }
}

+ (CGFloat)xPaddingPopupContinue {
    if (IS_IPHONE_4) {
        return 8.0f;
    } else if (IS_IPHONE_5) {
        return 14.0f;
    } else if (IS_IPHONE_6) {
        return 48.0f;
    } else if (IS_IPHONE_6_PLUS) {
        return 80.0f;
    } else {
        return 150.0f;
    }
}

+ (CGFloat)yPaddingPopupContinue {
    if (IS_IPHONE_4) {
        return 40.0f;
    } else if (IS_IPHONE_5) {
        return 60.0f;
    } else if (IS_IPHONE_6) {
        return 80.0f;
    } else if (IS_IPHONE_6_PLUS) {
        return 100.0f;
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

+ (CGFloat)SIPopupGameOverDetailNodeHeight {
    if (IS_IPHONE_4) {
        return 30.0f;
        
    } else if (IS_IPHONE_5) {
        return 40.0f;
        
    } else if (IS_IPHONE_6) {
        return 50.0f;
        
    } else if (IS_IPHONE_6_PLUS) {
        return 60.0f;
        
    } else {
        return 80.0f;
        
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
+ (CGSize)SIBananaSize {
    return CGSizeMake([SIGameController SIFallingMonkeySize].width / 4.0f, [SIGameController SIFallingMonkeySize].height / 4.0f);
}
+ (CGSize)SIBananaBunchSize {
    return CGSizeMake([SIGameController SIFallingMonkeySize].width / 2.0f, [SIGameController SIFallingMonkeySize].height / 2.0f);
}
+ (CGSize)SIChestSize {
    return SCREEN_WIDTH > SCREEN_HEIGHT ? CGSizeMake(SCREEN_HEIGHT * 0.4f, SCREEN_HEIGHT * 0.4f) : CGSizeMake(SCREEN_WIDTH * 0.4f, SCREEN_WIDTH * 0.4f);
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
    return CGSizeMake(size.width / 4.0f, size.width / 8.0f);
}

+ (CGSize)SIProgressBarGameMoveSize:(CGSize)size {
    if ([SIGameController premiumUser]) {
        return CGSizeMake(size.width, (size.height / 2.0f) - [SIGameController SIButtonSize:size].height - ([SIGameController SIFontSizeMoveCommand] / 2.0f) - VERTICAL_SPACING_16);
    } else {
        return CGSizeMake(size.width, (size.height / 2.0f) - [SIGameController SIButtonSize:size].height - ([SIGameController SIFontSizeMoveCommand] / 2.0f) - VERTICAL_SPACING_16 - [SIGameController SIAdBannerViewHeight]);

    }

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
    
    transistion                     = [SKTransition doorsOpenHorizontalWithDuration:SCENE_TRANSISTION_DURATION_NOW];
    
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
    
//    return [premiumUserNumber boolValue];
    // TODO: REMOVE THIS LINE HOLY SHIT REMOVE THIS LINE
    return true;
}

#pragma mark SKLabelNodes
+ (SKLabelNode *)SILabelHeader:(NSString *)text {
    SKLabelNode *label  = [SIGameController SILabelInterfaceFontSize:[SIGameController SIFontSizeHeader]];
    label.fontName      = kSISFFontDisplayRegular;
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SILabelHeader_x2:(NSString *)text {
    SKLabelNode *label  = [SIGameController SILabelInterfaceFontSize:[SIGameController SIFontSizeHeader_x2]];
    label.fontName      = kSISFFontDisplaySemibold;
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SILabelHeader_x3:(NSString *)text {
    SKLabelNode *label  = [SIGameController SILabelInterfaceFontSize:[SIGameController SIFontSizeHeader_x3]];
    label.fontName      = kSISFFontDisplaySemibold;
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SILabelParagraph:(NSString *)text {
    SKLabelNode *label  = [SIGameController SILabelInterfaceFontSize:[SIGameController SIFontSizeParagraph]];
    label.text          = text;
    label.fontName      = kSISFFontDisplayMedium;
    return label;
}
+ (SKLabelNode *)SILabelParagraph_x2:(NSString *)text {
    SKLabelNode *label  = [SIGameController SILabelInterfaceFontSize:[SIGameController SIFontSizeParagraph_x2]];
    label.text          = text;
    label.fontName      = kSISFFontDisplayMedium;
    return label;
}
+ (SKLabelNode *)SILabelParagraph_x3:(NSString *)text {
    SKLabelNode *label  = [SIGameController SILabelInterfaceFontSize:[SIGameController SIFontSizeParagraph_x3]];
    label.text          = text;
    label.fontName      = kSISFFontDisplayMedium;
    return label;
}
+ (SKLabelNode *)SILabelText:(NSString *)text {
    SKLabelNode *label  = [SIGameController SILabelInterfaceFontSize:[SIGameController SIFontSizeText]];
    label.text          = text;
    label.fontName      = kSISFFontTextMedium;
    return label;
}
+ (SKLabelNode *)SILabelParagraph_x4:(NSString *)text {
    SKLabelNode *label  = [SIGameController SILabelInterfaceFontSize:[SIGameController SIFontSizeParagraph_x4]];
    label.text          = text;
    label.fontName      = kSISFFontDisplayMedium;
    return label;
}
+ (SKLabelNode *)SILabelInterfaceFontSize:(CGFloat)fontSize {
    SKLabelNode *label                          = [SKLabelNode labelNodeWithFontNamed:kSISFFontDisplayMedium];
    label.fontColor                             = [SKColor whiteColor];
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

+ (SKLabelNode *)SILabelSceneGamePopupTitle {
    SKLabelNode *moveLabel = moveCommandLabelNode();
    moveLabel.fontSize = [SIGameController SIFontSizeHeader];
    return moveLabel;
}

+ (SKLabelNode *)SILabelSceneGamePopupCountdown {
    SKLabelNode *label      =  moveCommandLabelNode();
    
    label.fontSize          = [SIGameController SIFontSizeHeader_x2];
    label.name              = kSINodePopupCountdown;
    label.text              = @"10";
    
    return label;
}

+ (SKLabelNode *)SILabelSceneGameMoveScoreLabel {
    SKLabelNode *labelNode              = moveCommandLabelNode();
    labelNode.fontSize                  = [SIGameController SIFontSizeMoveScore];
    return labelNode;
}

+ (SKLabelNode *)SILabelSceneGamePopupFree {
    SKLabelNode *freeLabel                  = [SKLabelNode labelNodeWithFontNamed:kSISFFontTextSemiboldItalic];
    freeLabel.text                          = NSLocalizedString(kSITextPopupContinueFree, nil);
    freeLabel.fontSize                      = [SIGameController SIFontSizeTextFree];
    freeLabel.color                         = [SKColor whiteColor];
    freeLabel.verticalAlignmentMode         = SKLabelVerticalAlignmentModeCenter;
    freeLabel.horizontalAlignmentMode       = SKLabelHorizontalAlignmentModeCenter;
    return freeLabel;
}

#pragma mark SKSpriteNodes
+ (SKSpriteNode *)SISpriteNodeFallingMonkey {
    static SKSpriteNode *monkey = nil;
    if (!monkey) {
        monkey                                      = [SKSpriteNode spriteNodeWithTexture:[SIGameController SITextureMonkeyFace]  size:[SIGameController SIFallingMonkeySize]];
        monkey.name                                 = kSINodeFallingMonkey;
        monkey.physicsBody                          = [SKPhysicsBody bodyWithCircleOfRadius:[SIGameController SIFallingMonkeySize].height / 2.0f];
        monkey.physicsBody.linearDamping            = 0.0f;
    }
    return monkey;
}
+ (SKSpriteNode *)SISpriteNodeMonkeyFaceLarge {
    static SKSpriteNode *monkey = nil;
    if (!monkey) {
        monkey                                      = [SKSpriteNode spriteNodeWithTexture:[SIGameController SITextureMonkeyFaceLarge]  size:[SIGameController SIFallingMonkeySize]];
        monkey.name                                 = kSINodeFallingMonkey;
        monkey.physicsBody                          = [SKPhysicsBody bodyWithCircleOfRadius:[SIGameController SIFallingMonkeySize].height / 2.0f];
        monkey.physicsBody.linearDamping            = 0.0f;
    }
    return monkey;
}
+ (SKSpriteNode *)SISpriteNodeBanana {
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithTexture:[[SIConstants atlasSceneFallingMonkey]
                                                              textureNamed:kSIAtlasSceneFallingMonkeyBanana]
                                                        size:[SIGameController SIBananaSize]];
    return node;
}

+ (SKSpriteNode *)SISpriteNodeBananaBunch {
    static SKSpriteNode *node = nil;
    if (!node) {
        node = [SKSpriteNode spriteNodeWithTexture:[[SIConstants atlasSceneFallingMonkey]
                                                                  textureNamed:kSIAtlasSceneFallingMonkeyBananaBunch]
                                                            size:[SIGameController SIBananaBunchSize]];
    }
    return node;
}

+ (SKSpriteNode *)SISpriteNodeCoinLargeFront {
    static SKSpriteNode *coinNode = nil;
    if (!coinNode) {
        coinNode                                    = coinNodeLargeFront();
    }
    return coinNode;
}

+ (SKSpriteNode *)SISpriteNodeTarget {
    static SKSpriteNode *node = nil;
    if (!node) {
        node                                        = [SKSpriteNode spriteNodeWithImageNamed:kSIAssestFallingMonkeyTarget];
    }
    return node;
}

+ (SKSpriteNode *)SISpriteNodePopupContinueCenterNode {
    static SKSpriteNode *centerNode = nil;
    if (!centerNode) {
        INSKButtonNode *useCoinsButton          = [SIGameController SIINButtonNamed:kSIAssestPopupButtonUseCoins label:[SIGameController SILabelParagraph:NSLocalizedString(kSITextPopupContinueBuyCoins, nil)]];
        useCoinsButton.name                     = kSINodeButtonUseCoins;
        INSKButtonNode *watchAdButton           = [SIGameController SIINButtonNamed:kSIAssestPopupButtonWatchAd label:[SIGameController SILabelParagraph:NSLocalizedString(kSITextPopupContinueWatchAdPlural, nil)]];
        watchAdButton.name                      = kSINodeButtonWatchAds;
        
        centerNode = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(watchAdButton.size.width, (watchAdButton.size.height * 2.0f) + VERTICAL_SPACING_8)];
        
        SKSpriteNode *freeBadge                 = [SKSpriteNode spriteNodeWithImageNamed:kSIAssestPopupFreeStar];
        SKLabelNode *freeLabel                  = [SIGameController SILabelSceneGamePopupFree];
        
        freeBadge.position                      = CGPointMake(watchAdButton.size.width / 2.0f - (freeBadge.size.width / 2.0f) - VERTICAL_SPACING_4, 0.0f);
        freeLabel.position                      = freeBadge.position;
        
        [watchAdButton addChild:freeBadge];
        [watchAdButton addChild:freeLabel];
        
        SKAction *grow                          = [SKAction scaleTo:1.1 duration:0.5];
        SKAction *shrink                        = [SKAction scaleTo:1.0 duration:0.5];
        SKAction *seq                           = [SKAction sequence:@[grow, shrink]];
        SKAction *rotate                        = [SKAction rotateByAngle:-M_2_PI duration:1.0f];
        SKAction *group                         = [SKAction group:@[seq,rotate]];
        
        [freeBadge runAction:[SKAction repeatActionForever:group]];
        
        
        [centerNode addChild:useCoinsButton];
        [centerNode addChild:watchAdButton];
        
        useCoinsButton.position = CGPointMake(0.0f, (useCoinsButton.size.height / 2.0f) + (VERTICAL_SPACING_4 / 2.0f));
        watchAdButton.position = CGPointMake(0.0f, -1.0f * ((useCoinsButton.size.height / 2.0f) + (VERTICAL_SPACING_4 / 2.0f)));
    }
    return centerNode;
}

+ (SKSpriteNode *)SISpriteNodePopupGameOverEndNode {
    CGSize nodeSize = CGSizeMake([SIGameController SIINButtonNamed:kSIAssestPopupButtonWatchAd label:[SIGameController SILabelParagraph:NSLocalizedString(kSITextPopupContinueWatchAdPlural, nil)]].size.width, [SIGameController SIPopupGameOverDetailNodeHeight]);
    
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(nodeSize.width, nodeSize.height * 3)];

    SIPopupGameOverOverDetailsRowNode *row1 = [SIGameController SIPopupGameOverDetailsRowNodeWithSize:nodeSize];
    row1.name                               = kSINodePopupRowTotalScore;
    SIPopupGameOverOverDetailsRowNode *row2 = [SIGameController SIPopupGameOverDetailsRowNodeWithSize:nodeSize];
    row2.name                               = kSINodePopupRowHighScore;
    SIPopupGameOverOverDetailsRowNode *row3 = [SIGameController SIPopupGameOverDetailsRowNodeWithSize:nodeSize];
    row3.name                               = kSINodePopupRowFreeCoins;
    
    CGFloat yPosInit = nodeSize.height;
    
    row1.position                           = CGPointMake(0.0f, yPosInit + VERTICAL_SPACING_4);
    row2.position                           = CGPointMake(0.0f, 0.0f);
    row3.position                           = CGPointMake(0.0f, -1.0f * (yPosInit + VERTICAL_SPACING_4));
    
    [bgNode addChild:row1];
    [bgNode addChild:row2];
    [bgNode addChild:row3];

    return bgNode;
}




#pragma mark SKTextures
+ (SKTexture *)SITextureMonkeyFace {
    static SKTexture *monkeyFace = nil;
    if (!monkeyFace) {
        monkeyFace = monkeyFaceTexture();
    }
    return monkeyFace;
}
+ (SKTexture *)SITextureMonkeyFaceLarge {
    static SKTexture *monkeyFace = nil;
    if (!monkeyFace) {
        monkeyFace = monkeyFaceTextureLarge();
    }
    return monkeyFace;
}
#pragma mark HLLabelButtons
+ (HLLabelButtonNode *)SIHLLabelButtonMenuPrototypeBasic:(CGSize)size {
    HLLabelButtonNode *buttonPrototype;
    
    buttonPrototype                         = [[SIGameController SIHLLabelButtonInterface:size] copy];
    buttonPrototype.verticalAlignmentMode   = HLLabelNodeVerticalAlignFontAscenderBias;
    
    return buttonPrototype;
}
+ (HLLabelButtonNode *)SIHLLabelButtonMenuPrototypeBasic:(CGSize)size backgroundColor:(SKColor *)backgroundColor fontColor:(UIColor *)fontColor {
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
    HLLabelButtonNode *labelButton              = [[HLLabelButtonNode alloc] initWithColor:[UIColor simplstMainColor] size:size];
    labelButton.cornerRadius                    = 12.0f;
    labelButton.fontName                        = kSISFFontDisplayRegular; // kSIFontFuturaMedium;
    labelButton.fontSize                        = size.height * 0.33f;
    labelButton.borderWidth                     = 0.0f;
    labelButton.borderColor                     = [SKColor blackColor];
    labelButton.fontColor                       = [UIColor whiteColor];
    labelButton.verticalAlignmentMode           = HLLabelNodeVerticalAlignFont;
    return labelButton;
}
+ (HLLabelButtonNode *)SIHLLabelButtonInterface:(CGSize)size backgroundColor:(UIColor *)backgroundColor fontColor:(SKColor *)fontColor {
    HLLabelButtonNode *labelButton              = [[HLLabelButtonNode alloc] initWithColor:[SKColor orangeColor] size:size];
    labelButton.fontName                        = kSISFFontDisplayRegular;
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
    return claimButton;
}

#pragma mark HLMenuNodes


+ (HLMenuNode *)SIHLMenuNodeSceneGamePopupContinue {
    HLMenuNode *menuNode                = [[HLMenuNode alloc] init];
    menuNode.itemAnimation              = HLMenuNodeAnimationSlideLeft;
    menuNode.itemAnimationDuration      = SCENE_TRANSISTION_DURATION_FAST;
    menuNode.itemButtonPrototype        = [SIGameController SIINButtonNamed:kSIAssestPopupButtonWatchAd];
    menuNode.backItemButtonPrototype    = [SIGameController SIINButtonNamed:kSIAssestPopupButtonWatchAd];
    menuNode.itemSeparatorSize          = VERTICAL_SPACING_4;
    
    HLMenu *menu                        = [[HLMenu alloc] init];
    
    HLMenuItem *item = [HLMenuItem menuItemWithText:kSITextPopupContinueBuyCoins];
    [menu addItem:item];
    
    
    [menu addItem:[HLMenuItem menuItemWithText:kSITextPopupContinueWatchAdSingular]];
    
    /*Add the Back Button... Need to change the prototype*/
    HLMenuItem *endGameItem             = [HLMenuItem menuItemWithText:kSITextPopupContinueEnd];
    endGameItem.buttonPrototype         = [SIGameController SIINButtonNamed:kSIAssestPopupButtonEndGame];
    [menu addItem:endGameItem];
    
    [menuNode setMenu:menu animation:HLMenuNodeAnimationNone];
    
    return menuNode;
}

+ (HLMenuNode *)SIHLMenuNodeSceneMenuStore:(CGSize)size {
    HLMenuNode *menuNode                = [[HLMenuNode alloc] init];
    menuNode.itemAnimation              = HLMenuNodeAnimationNone;
    menuNode.itemAnimationDuration      = SCENE_TRANSISTION_DURATION_FAST;
    menuNode.itemButtonPrototype        = [[SIStoreButtonNode alloc] initWithSize:[SIGameController SIButtonSize:size] buttonName:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackExtraLarge] SIIAPPack:SIIAPPackExtraLarge];
    menuNode.backItemButtonPrototype    = [SIGameController SIHLLabelButtonMenuPrototypeBack:[SIGameController SIButtonSize:size]];
    menuNode.itemSeparatorSize          = [SIGameController SIButtonSize:size].height + VERTICAL_SPACING_4;

    HLMenu *menu                        = [[HLMenu alloc] init];
    
    /*Add the regular buttons*/
    HLMenuItem *item1                   = [HLMenuItem menuItemWithText:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackExtraLarge]];
    item1.buttonPrototype               = [[SIStoreButtonNode alloc] initWithSize:[SIGameController SIButtonSize:size] buttonName:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackExtraLarge] SIIAPPack:SIIAPPackExtraLarge];
    
    HLMenuItem *item2                   = [HLMenuItem menuItemWithText:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackLarge]];
    item2.buttonPrototype               = [[SIStoreButtonNode alloc] initWithSize:[SIGameController SIButtonSize:size] buttonName:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackLarge] SIIAPPack:SIIAPPackLarge];
    
    HLMenuItem *item3                   = [HLMenuItem menuItemWithText:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackMedium]];
    item3.buttonPrototype               = [[SIStoreButtonNode alloc] initWithSize:[SIGameController SIButtonSize:size] buttonName:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackMedium] SIIAPPack:SIIAPPackMedium];
    
    HLMenuItem *item4                   = [HLMenuItem menuItemWithText:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackSmall]];
    item4.buttonPrototype               = [[SIStoreButtonNode alloc] initWithSize:[SIGameController SIButtonSize:size] buttonName:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackSmall] SIIAPPack:SIIAPPackSmall];
    
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
    toolbarNode.anchorPoint                     = CGPointMake(0.5f, 0.0f);
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
    [toolTags   addObject:kSIPowerUpTypeTimeFreeze];
    
    SIPowerUpToolbarNode *rapidFireNode         = [[SIPowerUpToolbarNode alloc] initWithSIPowerUp:SIPowerUpTypeRapidFire size:toolbarNodeSize];
    [toolNodes addObject:rapidFireNode];
    [toolTags addObject:kSIPowerUpTypeRapidFire];
    
    SIPowerUpToolbarNode *fallingMonkeyNode     = [[SIPowerUpToolbarNode alloc] initWithSIPowerUp:SIPowerUpTypeFallingMonkeys size:toolbarNodeSize];
    [toolNodes addObject:fallingMonkeyNode];
    [toolTags addObject:kSIPowerUpTypeFallingMonkeys];
    
    [toolbarNode setTools:toolNodes tags:toolTags animation:HLToolbarNodeAnimationSlideUp];
    
    [toolbarNode layoutToolsAnimation:HLToolbarNodeAnimationNone];
    return toolbarNode;
}

+ (HLMenuNode *)SIHLMenuNodeSceneMenuSettings:(CGSize)size {
    
    HLMenuNode *menuNode                            = [[HLMenuNode alloc] init];
    menuNode.itemAnimation                         = HLMenuNodeAnimationNone;
    menuNode.itemAnimationDuration                 = SCENE_TRANSISTION_DURATION_FAST;
    menuNode.itemButtonPrototype                   = [SIGameController SIHLLabelButtonMenuPrototypeBasic:[SIGameController SIButtonSize:size]];
    menuNode.backItemButtonPrototype               = [SIGameController SIHLLabelButtonMenuPrototypeBack:[SIGameController SIButtonSize:size]];
    menuNode.itemSeparatorSize                     = [SIGameController SIMenuButtonSpacing];
    
    HLMenu *menu = [[HLMenu alloc] init];
    
    /*Add the regular buttons*/
    [menu addItem:[HLMenuItem menuItemWithText:kSITextMenuSettingsResetHighScore]];
    
    [menu addItem:[HLMenuItem menuItemWithText:kSITextMenuSettingsBugReport]];
    
    NSString *sceneSettingsMenuItemTextSoundBackground = [SIConstants isBackgroundSoundAllowed]? kSITextMenuSettingsToggleSoundOffBackground : kSITextMenuSettingsToggleSoundOnBackground;
    [menu addItem:[HLMenuItem menuItemWithText:sceneSettingsMenuItemTextSoundBackground]];
    
    NSString *sceneSettingsMenuItemTextSoundFX = [SIConstants isFXAllowed] ? kSITextMenuSettingsToggleSoundOffFX : kSITextMenuSettingsToggleSoundOnFX;
    [menu addItem:[HLMenuItem menuItemWithText:sceneSettingsMenuItemTextSoundFX]];
    
    [menu addItem:[HLMenuItem menuItemWithText:kSITextMenuSettingsRestorePurchases]];
    
    [menuNode setMenu:menu animation:HLMenuNodeAnimationNone];
    
    return menuNode;
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
//+ (HLGridNode *)SIHLGridNodeMenuSceneStartSize:(CGSize)size {
//    int gridWidth                       = 2;
//    int squareCount                     = 2;
//    
//    CGFloat squareSeparatorSize         = VERTICAL_SPACING_16;
//    
//    CGFloat squareWidth                 = ((size.width * 0.75) - (squareSeparatorSize * 3)) / 2.0f;
//    CGFloat squareHeight                = squareWidth * 0.8f;
//    
//    INSKButtonNode *node1                 = [INSKButtonNode buttonNodeWithImageNamed:kSIAssestMenuButtonPlayClassic];
//    INSKButtonNode *node2                 = [INSKButtonNode buttonNodeWithImageNamed:kSIAssestMenuButtonPlayOneHand];
//    
//    HLGridNode *gridNode                = [[HLGridNode alloc] initWithGridWidth:gridWidth
//                                                                    squareCount:squareCount
//                                                                    anchorPoint:CGPointMake(0.5f, 0.0f)
//                                                                     layoutMode:HLGridNodeLayoutModeFill
//                                                                     squareSize:CGSizeMake(squareWidth, squareHeight)
//                                                           backgroundBorderSize:0.0f
//                                                            squareSeparatorSize:squareSeparatorSize];
//    
//    gridNode.backgroundColor            = [SKColor clearColor]; //[SKColor blackColor];
//    gridNode.squareColor                = [SKColor clearColor];
//    gridNode.highlightColor             = [SKColor clearColor];
//    gridNode.content = @[node1,node2];
//    
//    return gridNode;
//}
+ (HLGridNode *)SIHLGridNodeMenuSceneEndSize:(CGSize)size {
    int gridWidth                       = 2;
    int squareCount                     = 2;
    
    CGFloat squareSeparatorSize         = VERTICAL_SPACING_8;
    
    CGFloat squareWidth                 = (size.width - (squareSeparatorSize * 3)) / 2.0f;
    CGFloat squareHeight                = squareWidth * 0.8f;

//    INSKButtonNode *node1               = [INSKButtonNode buttonNodeWithImageNamed:kSIAssestMenuButtonPlayClassic];
//    INSKButtonNode *node2               = [INSKButtonNode buttonNodeWithImageNamed:kSIAssestMenuButtonPlayOneHand];
    INSKButtonNode *node3               = [INSKButtonNode buttonNodeWithImageNamed:kSIAssestMenuButtonShareFacebook];
    INSKButtonNode *node4               = [INSKButtonNode buttonNodeWithImageNamed:kSIAssestMenuButtonShareTwitter];

    HLGridNode *gridNode                = [[HLGridNode alloc] initWithGridWidth:gridWidth
                                                                    squareCount:squareCount
                                                                    anchorPoint:CGPointMake(0.5f, 0.0f)
                                                                     layoutMode:HLGridNodeLayoutModeFill
                                                                     squareSize:CGSizeMake(squareWidth, squareHeight)
                                                           backgroundBorderSize:0.0f
                                                            squareSeparatorSize:squareSeparatorSize];
    
    gridNode.backgroundColor            = [SKColor clearColor];
    gridNode.squareColor                = [SKColor clearColor];
    gridNode.highlightColor             = [SKColor clearColor];
    gridNode.content = @[node3,node4];
    
    return gridNode;
}

#pragma mark SIPopups
+ (SIPopupNode *)SIPopupNodeTitle:(NSString *)title SceneSize:(CGSize)sceneSize {
    SKLabelNode *titleNode      = [SIGameController SILabelParagraph:title];
    titleNode.fontColor         = [SKColor whiteColor];
    titleNode.fontSize          = [SIGameController SIFontSizePopup];
    
    SIPopupNode *popUpNode      = [[SIPopupNode alloc] initWithSceneSize:sceneSize];
    popUpNode.titleContentNode  = titleNode;
    popUpNode.backgroundSize    = CGSizeMake(sceneSize.width - 100.0f, sceneSize.height - 200.0f);
    popUpNode.backgroundColor   = [SKColor SIColorPrimary];
    popUpNode.cornerRadius      = 8.0f;
    
    return popUpNode;
}

+ (SIPopupNode *)SIPopupSceneGameContinueSize:(CGSize)size {
    SKLabelNode *titleLabel                 = [SIGameController SILabelSceneGamePopupTitle];
    titleLabel.text                         = NSLocalizedString(kSITextPopupContinueContinue, nil);

    SIPopupNode *popupNode                  = [[SIPopupNode alloc] initWithSceneSize:size];

    popupNode.backgroundSize                = CGSizeMake(size.width - [SIGameController xPaddingPopupContinue], size.width - [SIGameController xPaddingPopupContinue]);
    popupNode.backgroundColor               = [UIColor SIColorPrimary];
    popupNode.titleContentNode              = titleLabel;
    popupNode.cornerRadius                  = 8.0f;
    popupNode.userInteractionEnabled        = YES;
    popupNode.dismissButtonVisible          = NO;
    return popupNode;
}
+ (SIPopupNode *)SIPopupSceneMenuFreePrize {
    SIPopupNode *popupNode                  = [[SIPopupNode alloc] initWithSceneSize:[SIGameController sceneSize]];
    popupNode.backgroundSize                = CGSizeMake([SIGameController sceneSize].width - [SIGameController xPaddingPopupContinue], [SIGameController sceneSize].width - [SIGameController xPaddingPopupContinue]);
    popupNode.titleContentNode              = [SIIAPUtility createTitleNode:CGSizeMake(popupNode.backgroundSize.width - VERTICAL_SPACING_16, (popupNode.backgroundSize.height / 2.0f) - ([SIGameController SIChestSize].height / 2.0f))];
    popupNode.backgroundColor               = [SKColor SIColorPrimary];
    popupNode.cornerRadius                  = 8.0f;
    popupNode.userInteractionEnabled        = YES;
    
    return popupNode;
}

+ (SIPopupContentNode *)SIPopupContentSceneMenuFreePrizeSize:(CGSize)size {
    SIPopupContentNode *centerNode        = [[SIPopupContentNode alloc] initWithSize:size];
    centerNode.labelNode                  = [SIGameController SILabelHeader_x3:@""];
    centerNode.backgroundImageNode        = [SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageIAPExtraLarge] size:[SIGameController SIChestSize]];
    return centerNode;
}

#pragma mark DSMultilineNode
/**
 The multiline node for the instructions page
 */
+ (DSMultilineLabelNode *)SIMultilineLabelNodeSceneSize:(CGSize)size {
    DSMultilineLabelNode *multilineNode     = [[DSMultilineLabelNode alloc] initWithFontNamed:kSISFFontTextLight];
    multilineNode.paragraphWidth            = size.width - VERTICAL_SPACING_16;
    multilineNode.fontColor                 = [SKColor whiteColor];
    multilineNode.fontSize                  = [SIGameController SIFontSizeText];
    multilineNode.text                      = @"Tap the start screen to start a game. A gesture command will appear. Perform the gesture to progress through the game. The faster you enter the next gesture, the more points you score! Points are awesome! Use power ups to get an even higher score! Power ups are purchased with IT Coins. BUY IT Coins in the Store, earn a coin every 500 points and each day you launch the app get free! Opening Swype It every day earns you more and more free coins!!! SWYPE ON!";
    return multilineNode;
}
+ (DSMultilineLabelNode *)SIMultilineLabelNodePopupSceneSize:(CGSize)size {
    DSMultilineLabelNode *multilineNode     = [[DSMultilineLabelNode alloc] initWithFontNamed:kSISFFontTextRegular];
    multilineNode.paragraphWidth            = size.width - VERTICAL_SPACING_16;
    multilineNode.fontColor                 = [SKColor whiteColor];
    multilineNode.fontSize                  = [SIGameController SIFontSizeText_x3];
    return multilineNode;
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
    
    emitterNode = [emitterStore setEmitterWithResource:kSIEmitterExplosionTouch         forKey:kSIEmitterExplosionTouch];
    emitterNode = [emitterStore setEmitterWithResource:kSIEmitterFireProgressBarPowerUp forKey:kSIEmitterFireProgressBarPowerUp];
    emitterNode = [emitterStore setEmitterWithResource:kSIEmitterSnowTimeFreeze         forKey:kSIEmitterSnowTimeFreeze];
    emitterNode = [emitterStore setEmitterWithResource:kSIEmitterSpark                  forKey:kSIEmitterSpark];
    
    NSLog(@"SIGameScene loadEmitters: loaded in %0.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
}

#pragma mark TCProgressBarNodes
/**Progress Bar for Free Coin*/
+ (TCProgressBarNode *)SIProgressBarSceneGameFreeCoinSceneSize:(CGSize)size {
    TCProgressBarNode *progressBar      = [[TCProgressBarNode alloc]
                                           initWithSize:[SIGameController SIProgressBarGameFreeCoinSize:size]
                                           backgroundColor:[UIColor lightGrayColor]
                                           fillColor:[UIColor goldColor]
                                           borderColor:[UIColor blackColor]
                                           borderWidth:2.0f
                                           cornerRadius:4.0f];
    return progressBar;
}
/**Progress Bar for Move*/
+ (TCProgressBarNode *)SIProgressBarSceneGameMoveSceneSize:(CGSize)size {
    TCProgressBarNode *progressBar      = [[TCProgressBarNode alloc]
                                           initWithSize:[SIGameController SIProgressBarGameMoveSize:size]
                                           backgroundColor:[UIColor blackColor]
                                           fillColor:[UIColor redColor]
                                           borderColor:[UIColor clearColor]
                                           borderWidth:0.0f
                                           cornerRadius:0.0f];
    progressBar.titleLabelNode.fontName = kSISFFontDisplayBold;
    progressBar.titleLabelNode.fontSize = [SIGameController SIFontSizeHeader];
    
    return progressBar;
}

/**Progress Bar for Power Up*/
+ (TCProgressBarNode *)SIProgressBarSceneGamePowerUpSceneSize:(CGSize)size {
    CGSize progressBarSize              = CGSizeMake(size.width, (size.width / 2.0f) * 0.3);
    TCProgressBarNode *progressBar      = [[TCProgressBarNode alloc]
                                           initWithSize:progressBarSize
                                           backgroundColor:[UIColor blackColor]
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

/**
 Called when you need a new move score label and such
 */
+ (SKLabelNode *)moveScoreLabel:(float)score {
    return [SIGameController SILabelHeader_x3:[NSString stringWithFormat:@"%0.2f",score]];
}
+ (SKLabelNode *)moveCommandLabelWithText:(NSString *)text {
    return [SIGameController SILabelHeader_x3:text];
}

#pragma mark ZPosition Convience Methods
+ (float)floatZPositionGameForContent:(SIZPositionGame)layer {
    return (float)layer / (float)SIZPositionGameCount;
}

+ (float)floatZPositionMenuForContent:(SIZPositionMenu)layer {
    return (float)layer / (float)SIZPositionMenuCount;
}

+ (float)floatZPositionPopupForContent:(SIZPositionPopup)layer {
    return (float)layer / (float)SIZPositionPopupCount;
}
+ (float)floatZPositionFallingMonkeyForContent:(SIZPositionFallingMonkey)layer {
    return (float)layer / (float)SIZPositionFallingMonkeyCount;
}

#pragma mark UIGestureRecognizers 
+ (UISwipeGestureRecognizer *)SIGestureSwypeUp {
    static UISwipeGestureRecognizer *swipeUp = nil;
    if (!swipeUp) {
        swipeUp = [[UISwipeGestureRecognizer alloc] init];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    }
    return swipeUp;
}
+ (UISwipeGestureRecognizer *)SIGestureSwypeDown {
    static UISwipeGestureRecognizer *swipeDown = nil;
    if (!swipeDown) {
        swipeDown = [[UISwipeGestureRecognizer alloc] init];
        swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    }
    return swipeDown;
}
+ (UISwipeGestureRecognizer *)SIGestureSwypeLeft {
    static UISwipeGestureRecognizer *swipeLeft = nil;
    if (!swipeLeft) {
        swipeLeft = [[UISwipeGestureRecognizer alloc] init];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    return swipeLeft;
}
+ (UISwipeGestureRecognizer *)SIGestureSwypeRight {
    static UISwipeGestureRecognizer *swipeRight = nil;
    if (!swipeRight) {
        swipeRight = [[UISwipeGestureRecognizer alloc] init];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    }
    return swipeRight;
}
+ (UIPinchGestureRecognizer *)SIGesturePinch {
    static UIPinchGestureRecognizer *gesture = nil;
    if (!gesture) {
        gesture = [[UIPinchGestureRecognizer alloc] init];
    }
    return gesture;
}
+ (UITapGestureRecognizer *)SIGestureTap {
    static UITapGestureRecognizer *gesture = nil;
    if (!gesture) {
        gesture                         = [[UITapGestureRecognizer alloc] init];
        gesture.numberOfTapsRequired    = 1;
    }
    return gesture;
}


#pragma mark INSKButtonNode
+ (INSKButtonNode *)SIINButtonNamed:(NSString *)name {
    INSKButtonNode *button                                                  = [INSKButtonNode buttonNodeWithImageNamed:name];
    button.nodeHighlighted                                                  = button.nodeNormal.copy;
    
    [((SKSpriteNode *)button.nodeHighlighted) setScale:0.9];
    ((SKSpriteNode *)button.nodeHighlighted).color                          = [SKColor blackColor];
    ((SKSpriteNode *)button.nodeHighlighted).colorBlendFactor               = 0.2;
    return button;
}

+ (INSKButtonNode *)SIINButtonNamed:(NSString *)name label:(SKLabelNode *)label {
    INSKButtonNode *button                                                  = [SIGameController SIINButtonNamed:name];
    
    label.name                                                              = kSINodeButtonText;
    SKLabelNode *label2                                                     = [label copy];
    
    [button.nodeNormal addChild:label];
    [button.nodeHighlighted addChild:label2];
    
    return button;
}

//+ (INSKButtonNode *)SIINButtonPopupButtonImageNamed:(NSString *)imageName text:(NSString *)text {
//    INSKButtonNode *button                                                  = [SIGameController SIINButtonNamed:imageName];
//    
//    SKLabelNode *label1                                                     = [SIGameController SILabelButtonWithText:text];
//    label1.name                                                             = kSINodeButtonText;
//    SKLabelNode *label2                                                     = [label1 copy];
//
//    [button.nodeNormal addChild:label1];
//    [button.nodeHighlighted addChild:label2];
//
//    return button;
//}

+ (INSKButtonNode *)SIINButtonOneHandMode {
    static INSKButtonNode *button = nil;
    if (!button) {
        button                                                              = [INSKButtonNode buttonNodeWithToggleImageNamed:kSIAssestMenuButtonOneHandModeOff
                                                                                                         highlightImageNamed:kSIAssestMenuButtonOneHandModeOff
                                                                                                          selectedImageNamed:kSIAssestMenuButtonOneHandModeOn
                                                                                                 selectedHighlightImageNamed:kSIAssestMenuButtonOneHandModeOn];
        button.name                                                         = kSINodeButtonOneHand;
        
        [((SKSpriteNode *)button.nodeHighlighted) setScale:0.9];
        ((SKSpriteNode *)button.nodeHighlighted).color                      = [SKColor colorWithRed:0 green:0 blue:0 alpha:1];
        ((SKSpriteNode *)button.nodeHighlighted).colorBlendFactor = 0.2;
        
        [((SKSpriteNode *)button.nodeSelectedHighlighted) setScale:0.9];
        ((SKSpriteNode *)button.nodeSelectedHighlighted).color              = [SKColor colorWithRed:0 green:0 blue:0 alpha:1];
        ((SKSpriteNode *)button.nodeSelectedHighlighted).colorBlendFactor   = 0.2;
        
        
        SKLabelNode *oneHandModeOn1                                         = [SIGameController SILabelButtonWithText:[NSString stringWithFormat:@"%@: %@",NSLocalizedString(kSITextMenuStartScreenOneHandMode, nil), NSLocalizedString(kSITextBoolON, nil)]];
        SKLabelNode *oneHandModeOn2                                         = [SIGameController SILabelButtonWithText:[NSString stringWithFormat:@"%@: %@",NSLocalizedString(kSITextMenuStartScreenOneHandMode, nil), NSLocalizedString(kSITextBoolON, nil)]];
        SKLabelNode *oneHandModeOff1                                        = [SIGameController SILabelButtonWithText:[NSString stringWithFormat:@"%@: %@",NSLocalizedString(kSITextMenuStartScreenOneHandMode, nil), NSLocalizedString(kSITextBoolOFF, nil)]];
        SKLabelNode *oneHandModeOff2                                        = [SIGameController SILabelButtonWithText:[NSString stringWithFormat:@"%@: %@",NSLocalizedString(kSITextMenuStartScreenOneHandMode, nil), NSLocalizedString(kSITextBoolOFF, nil)]];

        oneHandModeOn1.fontSize                                             = [SIGameController SIFontSizeText_x4];
        oneHandModeOn2.fontSize                                             = [SIGameController SIFontSizeText_x4];
        oneHandModeOff1.fontSize                                            = [SIGameController SIFontSizeText_x4];
        oneHandModeOff2.fontSize                                            = [SIGameController SIFontSizeText_x4];
        
        [button.nodeNormal addChild:oneHandModeOff1];
        [button.nodeHighlighted addChild:oneHandModeOff2];
        [button.nodeSelectedNormal addChild:oneHandModeOn1];
        [button.nodeSelectedHighlighted addChild:oneHandModeOn2];

    }
    return button;
}

+ (SKLabelNode *)SILabelButtonWithText:(NSString *)text {
    SKLabelNode *label              = [SKLabelNode labelNodeWithFontNamed:kSISFFontDisplayMedium];
    label.text                      = text;
    label.fontColor                 = [SKColor whiteColor];
    label.fontSize                  = [SIGameController SIFontSizeText];
    label.verticalAlignmentMode     = SKLabelVerticalAlignmentModeCenter;
    label.horizontalAlignmentMode   = SKLabelHorizontalAlignmentModeCenter;
    return label;
}

#pragma mark SIPopupGameOverOverDetailsRowNode
+ (SIPopupGameOverOverDetailsRowNode *)SIPopupGameOverDetailsRowNodeWithSize:(CGSize)size {
    return [[SIPopupGameOverOverDetailsRowNode alloc] initWithSize:size];;
}

#pragma mark -
#pragma mark - IAP Stuff
- (void)registerForNotifications {
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(packPurchaseRequest:) name:kSINotificationPackPurchaseRequest object:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {

                                                      if (_verbose) {
                                                          NSLog(@"Purchased/Subscribed to product with id: %@", [note object]);
                                                      }
                                                      [self hudWillHideWithTitle:@"Success!" info:@"" willShowCheckMark:YES holdDuration:1.0f animate:YES];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchaseFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {

                                                      if (_verbose) {
                                                          NSLog(@"Failed [kMKStoreKitProductPurchaseFailedNotification] with error: %@", [note object]);
                                                      }
                                                      [self hudWillHideWithTitle:@"Error" info:@"Purchase Failed" willShowCheckMark:NO holdDuration:1.0f animate:YES];
                                                  }];

    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchaseDeferredNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      if (_verbose) {
                                                          NSLog(@"Failed [kMKStoreKitProductPurchaseDeferredNotification] with error: %@", [note object]);
                                                      }
                                                      [self hudWillHideWithTitle:@"Error" info:@"Purchase Deferred" willShowCheckMark:NO holdDuration:1.0f animate:YES];
                                                  }];

    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoredPurchasesNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {

                                                      NSLog(@"Restored Purchases");
                                                      [self removeBannerAds];
                                                      [self hudWillHideWithTitle:@"Restored!" info:@"" willShowCheckMark:YES holdDuration:1.0f animate:YES];

                                                  }];

    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoringPurchasesFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {

                                                      if (_verbose) {
                                                          NSLog(@"Failed restoring purchases with error: %@", [note object]);
                                                      }
                                                      [self hudWillHideWithTitle:@"Error" info:@"Failed to restore" willShowCheckMark:NO holdDuration:1.0f animate:YES];

                                                  }];
}
+ (void)setGameModel:(SIGameModel *)gameModel forGame:(SIGame *)game withCurrentMove:(SIMove *)move {
    [gameModel.powerUpArray removeAllObjects];
    
    [SIGame setStartGameProperties:game];
    
    if (move) {
        move    = nil;
    }
    move        = [[SIMove alloc] init];
}
@end
