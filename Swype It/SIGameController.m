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
#import "SIPopTip.h"
#import "DSMultilineLabelNode.h"
#import "FXReachability.h"
#import "JCNotificationCenter.h"
#import "MBProgressHud.h"
#import "MKStoreKit.h"
#import "MSSAlertViewController.h"
#import "NHNetworkTime.h"
//#import "SoundManager.h"
#import "TransitionKit.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIGame.h"
#import "SIMove.h"
#import "SIPowerUp.h"
#import "SIIAPUtility.h"
// Other Imports

@interface SIGameController () <ADBannerViewDelegate, ADInterstitialAdDelegate, GKGameCenterControllerDelegate, SIGameSceneDelegate, SISingletonAchievementDelegate, SIMenuSceneDelegate, SIFallingMonkeySceneDelegate, HLMenuNodeDelegate, HLGridNodeDelegate, HLRingNodeDelegate, HLToolbarNodeDelegate, SIPopupNodeDelegate, SIAdBannerNodeDelegate, SIGameModelDelegate, SIMenuNodeDelegate, INSKButtonNodeDelegate, SIPopTipDelegate, SILoadingSceneDelegate>

@property (strong, nonatomic) UIButton          *closeButton;
@end

@implementation SIGameController {
    __weak SKScene                           *_currentScene;
    
    ADBannerView                             *_adBannerView;
    
    ADInterstitialAd                         *_interstitialAd;
    
    BOOL                                     _loadComplete;
    BOOL                                     _interstitialAdPresentationIsLive;
    
    /**
     Set this true if you want a ton of print statements
     */
    BOOL                                     _verbose;
    BOOL                                     _highScoreShowing;
    BOOL                                     _isPurchaseInProgress;
    BOOL                                     _mutexContinueButtonPressed;
    BOOL                                     _sceneGameShakeIsActive;
    BOOL                                     _testMode;
    BOOL                                     _tutorialActiveNoWrongMoves;

    
    CGFloat                                  _sceneGameSpacingHorizontalToolbar;
    
    CGSize                                   _sceneSize;
    CGSize                                   _sceneGameToolbarSize;
    CGSize                                   _sceneGameToolbarNodeSize;
    
    CMMotionManager                         *_motionManager;
    
    DSMultilineLabelNode                    *_sceneGamePopupGameOverUserMessageLabelNode;
    DSMultilineLabelNode                    *_sceneMenuHelpMultilineNode;
    DSMultilineLabelNode                    *_sceneMenuPopupFreePrizeComeBackLabel;

    
    INSKButtonNode                          *_sceneMenuPopupFreePrizeButton;
    INSKButtonNode                          *_sceneMenuStartOneHandModeButton;
    INSKButtonNode                          *_sceneMenuStartShopButton;
    INSKButtonNode                          *_sceneGamePopupGameOverEndGameButton;
    
    int                                      _loadingPointsCurrent;
    int                                      _loadingPointsTotal;
    int                                      _numberOfAdsToWatch;
    int                                      _sceneGameShakeRestCount;
    int                                      _numberOfMoves;
    
    /**
     in mS
     */
//    float                                    _gameTimeComposite;
    /**
     0.0 to 1.0 for the amount of the scene that is loaded
     */
    float                                    _percentLoaded;
    float                                    _timeFreezeMultiplier;
    float                                    _powerUpPercent;

    
    HLGridNode                              *_sceneMenuEndGridNode;
//    HLGridNode                              *_sceneMenuStartGridNode;
    
    HLMenuNode                              *_sceneGamePopupMenuNode;
    HLMenuNode                              *_sceneMenuStoreMenuNode;
    HLMenuNode                              *_sceneMenuSettingsMenuNode;

    HLRingNode                              *_sceneGameRingNodePause;
    
    HLToolbarNode                           *_sceneGameToolbarPowerUp;
    HLToolbarNode                           *_sceneMenuStartToolbarNode;
    
    MBProgressHUD                           *_hud;
    
    NSArray                                 *_products;
    
    NSString                                *_sceneGamePopupMenuItemTextContinueWithAd;
    NSString                                *_sceneGamePopupMenuItemTextContinueWithCoin;
    NSString                                *_sceneGamePopupContinueUserMessage;
    NSString                                *_sceneSettingsMenuItemTextSoundBackground;
    NSString                                *_sceneSettingsMenuItemTextSoundFX;
    
    NSTimeInterval                           _popupTimePauseOffset;
    NSTimeInterval                           _popupTimePauseStart;
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
    SIMenuNode                              *_sceneGamePopupSIMenuNodeStore;
    
    SIMenuScene                             *_sceneMenu;
    
    SIMove                                  *_currentMove;
    
    SIPopTip                                *_popTipNode;

    SIPopupNode                             *_sceneGamePopupContinue;
    SIPopupNode                             *_sceneGamePopupGameOver;
    SIPopupNode                             *_sceneMenuPopupFreePrize;
    
//    SIPopupContentNode                      *_sceneMenuPopupContentFreePrize;
    
    SIPopupGameOverDetailsNode              *_sceneGamePopupGameOverDetailsNode;
    
    SKAction                                *_fadeIn;
    SKAction                                *_fadeInNow;
    SKAction                                *_fadeOut;
    SKAction                                *_fadeOutNow;
    SKAction                                *_fadeAlphaIn;
    SKAction                                *_fadeAlphaOut;
    
    SKLabelNode                             *_sceneMenuLabelEnd;
    SKLabelNode                             *_sceneGamePopupContinueCountdownLabel;
    SKLabelNode                             *_sceneMenuPopupFreePrizeCountLabel;
    
    SKSpriteNode                            *_overlayNode;
    SKSpriteNode                            *_sceneGamePopupContinueButtonsNode;
    SKSpriteNode                            *_sceneGamePopupGameOverEndNode;
    SKSpriteNode                            *_sceneGamePopupGameOverBottomNode;
    
    SKTransition                            *_transitionDefaultLeft;
    SKTransition                            *_transitionDefaultRight;
    
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
    
    /*This is mission critical*/
    _sceneSize = self.view.frame.size;
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
    CGRect applicationFrame     = [[UIScreen mainScreen] applicationFrame];
    SKView *skView              = [[SKView alloc] initWithFrame:applicationFrame];
    self.view                   = skView;
    _mutexContinueButtonPressed = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForNotifications];
    
    [self configureBannerAds];
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
    return NO;
}

- (void)setupUserInterface {
    [self createConstants];
    [self setupControls];

//    [self mainSceneInitializationMethod];
}
- (void)createConstants {
    _isPurchaseInProgress               = NO;
    _highScoreShowing                   = NO;
    _loadComplete                       = NO;
    _interstitialAdPresentationIsLive   = NO;
    _tutorialActiveNoWrongMoves         = NO;
    _loadingPointsCurrent               = 0;
    _verbose                            = YES;
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
    
    if (![SIGameController premiumUser]) {
        _adBannerNode                                       = [[SIAdBannerNode alloc] initWithSize:CGSizeMake(_sceneSize.width, [SIGameController SIAdBannerViewHeight])];
        _adBannerNode.position                              = CGPointMake(0.0f, 0.0f);
        _adBannerNode.delegate                              = self;
    }
    
    [self gameFireEvent:kSITKStateMachineEventGameLoad userInfo:nil];

    _timerStateMachine                                  = [self createTimeStateMachine];
    
    /*Start your singletons*/
//    [SISingletonAchievement singleton].delegate         = self;;
    
    /*Start Sounds*/
    [SIGame initalizeSoundManager];
    
    /*Give those interstitial ads a cycle to get em going*/
    [self interstitialAdCycle];

    
    _overlayNode                                            = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(_sceneSize.width, _sceneSize.height)];
    _overlayNode.zPosition                                  = [SIGameController floatZPositionGameForContent:SIZPositionGameOverlayMax] + 1;
    _overlayNode.position                                   = CGPointMake(_sceneSize.width / 2.0f, _sceneSize.height / 2.0f);
    
    _transitionDefaultLeft                                  = [SKTransition revealWithDirection:SKTransitionDirectionLeft duration:1.0f];
    _transitionDefaultRight                                 = [SKTransition revealWithDirection:SKTransitionDirectionRight duration:1.0f];
    _transitionDefaultRight.pausesIncomingScene             = NO;
    
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
            _currentScene = [SIGameController viewController:[self fastSKView] transisitionToSKScene:_sceneLoading duration:SCENE_TRANSITION_DURATION_FAST withColor:[SKColor SIColorPrimary]];
            break;
            
        // FALLING MONKEY
        case SIGameControllerSceneFallingMonkey:
            _sceneFallingMonkey.adBannerNode = [SIGameController premiumUser] ? nil : _adBannerNode;
            _currentScene = [SIGameController viewController:[self fastSKView] transisitionToSKScene:_sceneFallingMonkey duration:SCENE_TRANSITION_DURATION_FAST];

            break;
            
        // GAME
        case SIGameControllerSceneGame:
            if (![SIGameController premiumUser]) {
                [self bannerAdShow];
                _sceneGame.adBannerNode = _adBannerNode;
            } else {
                [self bannerAdHide];
                _sceneGame.adBannerNode = nil;
            }
            switch (_currentSceneType) {
                case SIGameControllerSceneFallingMonkey:
                    _currentScene = [SIGameController viewController:[self fastSKView] transisitionToSKScene:_sceneGame duration:SCENE_TRANSITION_DURATION_NOW];
                    break;
                default:
                    _currentScene = [SIGameController viewController:[self fastSKView] transisitionToSKScene:_sceneGame withTransition:_transitionDefaultLeft]; //[SIGameController viewController:[self fastSKView] transisitionToSKScene:_sceneGame duration:SCENE_TRANSITION_DURATION_FAST];
                    break;
            }
            break;
        
        // MENU
        case SIGameControllerSceneMenu:
            if (![SIGameController premiumUser]) {
                [self bannerAdShow];
                _sceneMenu.adBannerNode = _adBannerNode;
            } else {
                [self bannerAdHide];
                _sceneMenu.adBannerNode = nil;
            }
            _gameModel.game.currentBackgroundSound = SIBackgroundSoundMenu;
            [SIGame playMusic:[SIGame soundNameForSIBackgroundSound:SIBackgroundSoundMenu] looping:YES fadeIn:YES];
            switch (_currentSceneType) {
                case SIGameControllerSceneGame:
                    _currentScene = [SIGameController viewController:[self fastSKView] transisitionToSKScene:_sceneMenu withTransition:_transitionDefaultRight]; //[SIGameController viewController:[self fastSKView] transisitionToSKScene:_sceneMenu duration:SCENE_TRANSITION_DURATION_FAST];
                    [self controllerSceneMenuShowMenu:_menuNodeStart menuNodeAnimiation:SIMenuNodeAnimationStaticVisible delay:SCENE_TRANSITION_DURATION_NORMAL];
                    break;
                case SIGameControllerSceneLoading:
                    _currentScene = [SIGameController viewController:[self fastSKView] transisitionToSKScene:_sceneMenu duration:SCENE_TRANSITION_DURATION_FAST];// [SIGameController transisitionNormalOpenToSKScene:_sceneMenu toSKView:[self fastSKView]];
                    [self controllerSceneMenuShowMenu:_menuNodeStart menuNodeAnimiation:SIMenuNodeAnimationStaticVisible delay:SCENE_TRANSITION_DURATION_FAST];
                    break;
                default:
                    _currentScene = [SIGameController viewController:[self fastSKView] transisitionToSKScene:_sceneMenu duration:SCENE_TRANSITION_DURATION_FAST];
                    [self controllerSceneMenuShowMenu:_menuNodeStart menuNodeAnimiation:SIMenuNodeAnimationStaticVisible delay:0.0f];
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
    NSTimeInterval totalWaitTime                            = 3.0f;
    NSTimeInterval currentTime                              = [NSDate timeIntervalSinceReferenceDate];
    
    NSTimeInterval totalTimePassed                          = currentTime - _loadTimeStart;
    
    if (totalTimePassed > totalWaitTime && _loadComplete == YES) {
        [self gameFireEvent:kSITKStateMachineEventGameMenuStart userInfo:nil];
    } else {
        [_sceneLoading sceneLoadingSetProgressPercent:(totalTimePassed / totalWaitTime)];
    }
}

- (SIGameScene *)loadGameScene {
    NSDate *startDate                                       = [NSDate date];
    
    SIGameScene *sceneGame                                  = [[SIGameScene alloc] initWithSize:_sceneSize];
    
    sceneGame.scaleMode                                     = SKSceneScaleModeAspectFill;
    sceneGame.sceneDelegate                                 = self;
    
    _sceneGamePopupContinue                                 = [SIGameController SIPopupSceneGameContinueSize:_sceneSize];
    _sceneGamePopupGameOver                                 = [SIGameController SIPopupSceneGameGameOverSize:_sceneSize];
    
    _sceneGamePopupContinueButtonsNode                      = [SIGameController SISpriteNodePopupContinueCenterNode];

    _sceneGamePopupMenuNode                                 = [SIGameController SIHLMenuNodeSceneGamePopupContinue];
    
    _sceneGamePopupSIMenuNodeStore                          = [self SIMenuNodePopupStoreSize:CGSizeMake(_sceneSize.width - [SIGameController xPaddingPopupContinue], _sceneSize.height - ([SIGameController yPaddingPopupContinue] * 2.0f))];

    _sceneGamePopupGameOverEndNode                          = [SIGameController SISpriteNodePopupGameOverEndNode];
    
    _sceneGamePopupGameOverBottomNode                       = [self SISpriteNodePopupGameOverBottomNode];
    
    _sceneGamePopupContinueCountdownLabel                   = [SIGameController SILabelSceneGamePopupCountdown];
    
    _sceneGamePopupGameOverUserMessageLabelNode             = [SIGameController SIMultilineLabelNodePopupSceneSize:_sceneGamePopupGameOver.backgroundSize];

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
    
    if (IDIOM == IPAD) {
        _popTipNode                                         = [SIGameController SIPopTipSize:CGSizeMake(_sceneSize.width * 0.33, (_sceneSize.width * 0.33) * 0.25)];

    } else {
        _popTipNode                                         = [SIGameController SIPopTipSize:CGSizeMake(_sceneSize.width * 0.66, (_sceneSize.width * 0.66) * 0.25)];

    }
    
    _fadeIn                                                 = [SKAction fadeInWithDuration:1.0];
    _fadeOut                                                = [SKAction fadeAlphaTo:0.0f duration:0.25];
    _fadeInNow                                              = [SKAction fadeInWithDuration:0.0];
    _fadeOutNow                                             = [SKAction fadeOutWithDuration:0.0];
    _fadeAlphaIn                                            = [SKAction fadeAlphaTo:0.7f duration:0.5];
    _fadeAlphaOut                                           = [SKAction fadeAlphaTo:0.0f duration:0.75];
    
    
    
    [SIGameController SILoaderEmitters];
    
    if (_verbose) {
        NSLog(@"SIGameScene Initialized: loaded in %0.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
    }
    
    _motionManager                                          = [[CMMotionManager alloc] init];
    
    [sceneGame layoutScene];
    
    return sceneGame;
}

- (SIMenuScene *)loadMenuScene {
    NSDate *startDate                                       = [NSDate date];
    
    SIMenuScene *menuScene                                  = [[SIMenuScene alloc] initWithSize:_sceneSize];

    menuScene.scaleMode                                     = SKSceneScaleModeAspectFill;
    menuScene.sceneDelegate                                 = self;


    _sceneMenuPopupFreePrize                                = [self initalizePopupFreePrize];

    
//    menuScene.adBannerNode                                  = _adBannerNode;

    CGSize menuNodeSize                                     = CGSizeMake(_sceneSize.width, _sceneSize.height - _adBannerNode.size.height);
    
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
    [SIGameController SISpriteNodeBanana];
    [SIGameController SISpriteNodeBananas];
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
    return (SKView *)self.originalContentView;
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
- (void)showGameCenterAchievements {
    GKGameCenterViewController *gameCenterVC    = [[GKGameCenterViewController alloc] init];
    gameCenterVC.gameCenterDelegate             = self;
    gameCenterVC.viewState                      = GKGameCenterViewControllerStateAchievements;
    
//    NSNumber *gameMode = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultGameMode];
//    if (gameMode) {
//        if ([gameMode integerValue] == 0) { /*One hand mode*/
//            gameCenterVC.leaderboardIdentifier = kSIGameCenterLeaderBoardIDHandOne;
//        } else {
//            gameCenterVC.leaderboardIdentifier = kSIGameCenterLeaderBoardIDHandTwo;
//        }
//    } else {
//        [[NSUserDefaults standardUserDefaults] setInteger:SIGameModeTwoHand forKey:kSINSUserDefaultGameMode];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
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
        NSLog(@"User is premium: %@",[SIGameController premiumUser] ? @"YES" : @"NO");
    }
    
    if ([SIGameController premiumUser]) {
        self.canDisplayBannerAds    = NO;
        _adBannerNode               = nil;
    } else {
        _adBannerView               = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        CGFloat bannerViewHeight    = _adBannerView.bounds.size.height;
        _adBannerView.frame         = CGRectMake(0.0f, _sceneSize.height + bannerViewHeight, 0.0f, 0.0f);
        _adBannerView.delegate      = self;
        [self.view addSubview:_adBannerView];
        [self.view bringSubviewToFront:_adBannerView];
//        _adBannerView.hidden        = YES; /*hide till loaded!*/
    }
}
- (void)removeBannerAds {
    if ([SIGameController premiumUser]) {
        self.canDisplayBannerAds = NO;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSINSUserDefaultPremiumUser];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (_verbose) {
            NSLog(@"Banner Ads Hidden.");
        }
    }
    _sceneMenuStartToolbarNode          = [SIGameController SIHLToolbarMenuStartScene:[SIGameController SIToolbarSceneMenuSize:_sceneSize] isPremiumUser:[SIGameController premiumUser]];
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
    hud.detailsLabelText                        = info;
    hud.dimBackground                           = dimBackground;
    hud.labelText                               = title;
    hud.mode                                    = MBProgressHUDModeIndeterminate;
    _hud                                        = hud;
}

- (void)hudTextWillShowWithTitle:(NSString *)title info:(NSString *)info dimBackground:(BOOL)dimBackground animate:(BOOL)animate {
    MBProgressHUD *hud                          = [MBProgressHUD showHUDAddedTo:self.view animated:animate];
    hud.detailsLabelText                        = info;
    hud.dimBackground                           = dimBackground;
    hud.labelText                               = title;
    hud.mode                                    = MBProgressHUDModeText;
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

- (void)hudTextFlashDuration:(float)duration title:(NSString *)title info:(NSString *)info {
    [self hudTextWillShowWithTitle:title info:info dimBackground:YES animate:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_hud hide:YES];
    });
}

#pragma mark Daily Free Prize
- (void)tryForDailyPrize {
    if (![SIGameController SIBoolFromNSUserDefaults:[NSUserDefaults standardUserDefaults] forKey:kSINSUserDefaultFreePrizeGiven]) {
        [self giveFirstPrize];
    } else {
        if ([FXReachability isReachable]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [self checkForDailyPrizeCallback:^(SIFreePrizeType prizeType) {
                    switch (prizeType) {
                        case SIFreePrizeTypeNone:
                            break;
                        default:
                            dispatch_async(dispatch_get_main_queue(), ^{
                                _sceneMenuPopupFreePrizeCountLabel.text = [NSString stringWithFormat:@"%d",[SIIAPUtility getDailyFreePrizeAmount]];
                                _sceneMenu.popupNode = _sceneMenuPopupFreePrize;
                            });
                            break;
                    }
                }];
            });
        }
    }
}

/**
 Compares a time from the internet to determine if should give a daily prize
 */
- (void)checkForDailyPrizeCallback:(void (^)(SIFreePrizeType prizeType))callback {
    
    [SIIAPUtility getDateFromInternetWithCallback:^(NSDate *currentDate) {
        if (!currentDate) {
            if (callback) {
                callback(SIFreePrizeTypeNone);
            }
        }
        
        NSDate *lastPrizeGivenDate = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultLastPrizeAwardedDate];
        //First time ever giving a prize
        if (!lastPrizeGivenDate) {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kSINSUserDefaultNumberConsecutiveAppLaunches];
            [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:kSINSUserDefaultLastPrizeAwardedDate];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (callback) {
                callback(SIFreePrizeTypeFirst);
            }
            
        } else {
            //Consecutive Launch
            NSTimeInterval timeSinceLastLaunch = [currentDate timeIntervalSince1970] - [lastPrizeGivenDate timeIntervalSince1970];
            if (timeSinceLastLaunch > SECONDS_IN_DAY && timeSinceLastLaunch < 2 * SECONDS_IN_DAY) { /*Consecutive launch!!! > 24 < 48*/ //(timeSinceLastLaunch > 60 * 2 && timeSinceLastLaunch < 2 * 60 * 2) {
                if (callback) {
                    callback(SIFreePrizeTypeConsecutive);
                }
                
                //Non consecutive launch
            } else if (timeSinceLastLaunch > 2 * SECONDS_IN_DAY) { /*Non consecutive launch.... two days have passed..*/ //(timeSinceLastLaunch > 2 * 60 * 2) {
                [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kSINSUserDefaultNumberConsecutiveAppLaunches];
                if (callback) {
                    callback(SIFreePrizeTypeNonConsecutive);
                }
                
                //no prize
            } else {
                if (callback) {
                    callback(SIFreePrizeTypeNone);
                }
            }
        }
    }];

}

- (void)launchCoinsForDailyFreePrize {
    //remove the claim button
    _sceneMenu.popupNode.bottomNode             = nil;
    
    //configure the user message
    _sceneMenuPopupFreePrizeComeBackLabel.text  = [NSString stringWithFormat:NSLocalizedString(kSITextPopupFreePrizeComeBack, nil),[SIIAPUtility getTomorrowsDailyFreePrizeAmount]];
    
    //add the user message in place of the claim button
    _sceneMenu.popupNode.bottomNode             = _sceneMenuPopupFreePrizeComeBackLabel;
    
    // Now launch those coins!!!
    if (_popTipNode.parent == _sceneMenuPopupFreePrize) { //can do this because this is a specific caser
        [self launchCoins:INITIAL_FREE_PRIZE_AMOUNT coinsLaunched:0];
        
    } else {
        [self launchCoins:[SIIAPUtility getDailyFreePrizeAmount] coinsLaunched:0];
    
    }
    if (![SIGameController SIBoolFromNSUserDefaults:[NSUserDefaults standardUserDefaults] forKey:kSINSUserDefaultFreePrizeGiven]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSINSUserDefaultFreePrizeGiven];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}

- (void)launchCoins:(int)totalCoins coinsLaunched:(int)coinsLaunched {
    if (coinsLaunched == totalCoins) {
        if (_popTipNode.parent == _sceneMenuPopupFreePrize) {
            [self finishFirstPrize];
        } else {
            [self finishPrize];
        }
    } else {
        [SIGame playSound:kSISoundFXCoinNoise];
        _sceneMenuPopupFreePrizeCountLabel.text = [NSString stringWithFormat:@"%d",totalCoins - coinsLaunched - 1];
        [_sceneMenuPopupFreePrize launchNode:[[SIGameController SISpriteNodeCoinLargeFront] copy]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self launchCoins:totalCoins coinsLaunched:coinsLaunched + 1];
        });
    }
}

- (void)finishPrize {
    [SIGame playSound:kSISoundFXChaChing];
    _sceneMenuPopupFreePrizeCountLabel.text = @"0";
    
    [SIIAPUtility getDateFromInternetWithCallback:^(NSDate *currentDate) {
        if (currentDate) {
            [[MKStoreKit sharedKit] addFreeCredits:[NSNumber numberWithInt:[SIIAPUtility getDailyFreePrizeAmount]] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
            
            [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:kSINSUserDefaultLastPrizeAwardedDate];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        [SIIAPUtility increaseConsecutiveDaysLaunched];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _sceneMenu.popupNode = nil;
        });

    }];
    
}

- (void)giveFirstPrize {
    
    
    _sceneMenuPopupFreePrizeCountLabel.text     = [NSString stringWithFormat:@"%d",INITIAL_FREE_PRIZE_AMOUNT];
//    _sceneMenuPopupFreePrize.dismissButtonVisible   = YES;
    
    if (_popTipNode.parent) {
        [_popTipNode removeFromParent];
    }
    
    _sceneMenu.popupNode                        = _sceneMenuPopupFreePrize;
    
    _popTipNode.message                         = NSLocalizedString(kSITextUserTipFirstFreePrize, nil);
    _popTipNode.position                        = CGPointMake(0.0f, CGRectGetMinY(_sceneMenuPopupFreePrizeButton.frame) - ([_popTipNode calculateAccumulatedFrame].size.height / 2.0) - 28.0f);
    _popTipNode.positionHorizontal              = SIPopTipPositionHorizontalCenter;
    _popTipNode.positionVertical                = SIPopTipPositionVerticalTop;
    _popTipNode.effect                          = SIPopTipEffectBounce;
    _popTipNode.effectDeltaY                    = 5.0f;
    
    [_sceneMenuPopupFreePrize addChild:_popTipNode];
    
    [SIIAPUtility getDateFromInternetWithCallback:^(NSDate *currentDate) {
        if (currentDate) {
            [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:kSINSUserDefaultLastPrizeAwardedDate];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
    
    
}

- (void)finishFirstPrize {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _sceneMenu.popupNode = nil;
        [_popTipNode removeFromParent];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (![SIGameController SIBoolFromNSUserDefaults:[NSUserDefaults standardUserDefaults] forKey:kSINSUserDefaultInstabugDemoShown]) {
                /* Tell User how to send bug reports!*/
                Class startHUDClass = NSClassFromString(@"IBGStartHUD");
                id startAlert = [startHUDClass new];
                [startAlert show];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSINSUserDefaultInstabugDemoShown];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        });

    });
    
    [[MKStoreKit sharedKit] addFreeCredits:[NSNumber numberWithInt:INITIAL_FREE_PRIZE_AMOUNT] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
    
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kSINSUserDefaultNumberConsecutiveAppLaunches];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSINSUserDefaultFreePrizeGiven];
    [[NSUserDefaults standardUserDefaults] synchronize];

    

}

#pragma mark Popup Setups
- (SIPopupNode *)initalizePopupFreePrize {
    NSDate *startDate                                       = [NSDate date];

    
    SIPopupNode *popupNode                                  = [SIGameController SIPopupSceneMenuFreePrize];
    
    SKSpriteNode *chest                                     = [SIGameController SISpriteNodeIAPChest];//[SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageIAPExtraLarge] size:[SIGameController SIChestSize]]; //_sceneMenuPopupContentFreePrize;
    popupNode.centerNode                                    = chest;

    _sceneMenuPopupFreePrizeCountLabel                      = [SIGameController SILabelSceneGamePopupCountdown];
    [chest addChild:_sceneMenuPopupFreePrizeCountLabel];

    _sceneMenuPopupFreePrizeButton                          = [SIGameController SIINButtonNamed:kSIAssestPopupButtonClaim label:[SIGameController SILabelHeader:[NSString stringWithFormat:@"%@!",NSLocalizedString(kSITextPopupFreePrizeClaim, nil)]]];

    _sceneMenuPopupFreePrizeButton.inskButtonNodeDelegate   = self;
    [_sceneMenuPopupFreePrizeButton setTouchUpInsideTarget:self selector:@selector(launchCoinsForDailyFreePrize)];
    _sceneMenuPopupFreePrizeButton.enabled                  = YES;
    popupNode.bottomNode                                    = _sceneMenuPopupFreePrizeButton;
    popupNode.bottomNodeBottomSpacing                       = (_sceneMenuPopupFreePrizeButton.size.height / 2.0f) + VERTICAL_SPACING_8;
    
    popupNode.delegate = self;
    
    popupNode.dismissButtonVisible                          = NO;
    
//    popupNode.dismissButtonVisible = YES;
    
//    popupNode.lightNodeEdge.enabled = YES;
    
    _sceneMenuPopupFreePrizeComeBackLabel                   = [[DSMultilineLabelNode alloc] initWithFontNamed:kSISFFontTextMedium];
    _sceneMenuPopupFreePrizeComeBackLabel.paragraphWidth    = _sceneMenuPopupFreePrize.backgroundSize.width - VERTICAL_SPACING_16;
    _sceneMenuPopupFreePrizeComeBackLabel.fontColor         = [SKColor whiteColor];
    _sceneMenuPopupFreePrizeComeBackLabel.fontSize          = [SIGameController SIFontSizeText_x2];
    
    popupNode.backgroundColor                               = [SKColor SIColorPrimary];
    
    if (_verbose) {
        NSLog(@"Free Prize Initialized: loaded in %0.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
    }

//    return nil;
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
    
    if (IS_IPHONE_4) {
        [monkeyFace runAction:[SKAction scaleTo:0.75f duration:0.0f]];
    } else if (IDIOM == IPAD) {
//        [monkeyFace runAction:[SKAction scaleTo:2.0f duration:0.0f]];
    }
    
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
    
    SKLabelNode *gameMode                           = [SIGameController SILabelText:NSLocalizedString(kSITextMenuStartScreenGameMode, nil)];
    gameMode.verticalAlignmentMode                  = SKLabelVerticalAlignmentModeBottom;
    gameMode.horizontalAlignmentMode                = SKLabelHorizontalAlignmentModeCenter;
    gameMode.fontColor                              = [SKColor whiteColor];
    gameMode.fontSize                               = [SIGameController SIFontSizeText];
    gameMode.name                                   = @"b";
    gameMode.position                               = CGPointMake(0.0f,  (_sceneMenuStartOneHandModeButton.size.height / 2.0f) + VERTICAL_SPACING_4);
    
    [_sceneMenuStartOneHandModeButton addChild:gameMode];
    _sceneMenuStartOneHandModeButton.position       = CGPointMake(0.0f, 0.0f);

    _sceneMenuStartShopButton                       = [SIGameController SIINButtonNamed:kSIAssestMenuButtonShop label:[SIGameController SILabelHeader:[NSString stringWithFormat:@"%@",NSLocalizedString(kSITextMenuStartScreenStore, nil)]]];
    _sceneMenuStartShopButton.position              = CGPointMake(0.0f, _sceneMenuStartOneHandModeButton.size.height + VERTICAL_SPACING_8 + VERTICAL_SPACING_4 + [SIGameController SIFontSizeText]);
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
    menuNode.menuContentPosition                = SIMenuNodeContentPositionBottom;
    menuNode.bottomCenterNodeYPadding           = [SIGameController SIMenuNodeStoreBottomSpacingWithSize:size];
    menuNode.centerNode                         = _sceneMenuStoreMenuNode;
    [_sceneMenuStoreMenuNode hlSetGestureTarget:_sceneMenuStoreMenuNode];
    [_sceneMenu registerDescendant:_sceneMenuStoreMenuNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    
    return menuNode;
}

- (SIMenuNode *)SIMenuNodePopupStoreSize:(CGSize)size {
    SIMenuNode *menuNode                        = [[SIMenuNode alloc] initWithSize:size type:SISceneMenuTypeStore];
    
    _sceneMenuStoreMenuNode                     = [SIGameController SIHLMenuNodeSceneGamePopupStore:size];
    _sceneMenuStoreMenuNode.delegate            = self;
    _sceneMenuStoreMenuNode.name                = kSINodeMenuStore;
    menuNode.menuContentPosition                = SIMenuNodeContentPositionBottom;
    menuNode.bottomCenterNodeYPadding           = [SIGameController SIMenuNodeStorePopupBottomSpacingWithSize:size];
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self powerUpCheck];
    });

}

- (void)powerUpCheck {
    _powerUpPercent                                         = [SIPowerUp powerUpPercentRemaining:_gameModel.powerUpArray gameTimeTotal:_gameTimeTotal timeFreezeMultiplier:_timeFreezeMultiplier withCallback:^(SIPowerUp *powerUpToDeactivate) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self powerUpDectivatePowerUp:powerUpToDeactivate];
        });
    }];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SCENE_TRANSITION_DURATION_NORMAL * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
            _timeFreezeMultiplier = 0.01f;
            _sceneGame.progressBarPowerUp.hidden = NO;
            [self powerUpAddSnowEmitter];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSINSUserDefaultUserTipShownPowerUpTimeFreeze];
            break;
        case SIPowerUpTypeRapidFire:
            [self gameForceCorrectMove];
            [self powerUpAddFireEmitter];
            _sceneGame.progressBarPowerUp.hidden = NO;
            [SIGame playSound:kSISoundFXFireBurning];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSINSUserDefaultUserTipShownPowerUpRapidFire];
            break;
        case SIPowerUpTypeFallingMonkeys:
            /*Do Falling Monkeys in Setup*/
            success = [self gameFireEvent:kSITKStateMachineEventGameFallingMonkeyStart userInfo:nil];
            if (!success) {
                [self gameFireEvent:kSITKStateMachineEventGameMenuEnd userInfo:nil];
            }
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSINSUserDefaultUserTipShownPowerUpFallingMonkey];
            break;
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (_sceneGame.popTip) {
        _tutorialActiveNoWrongMoves                     = NO;
        _sceneGame.blurScreen                           = NO;
        _sceneGame.powerUpToolbarUserLabel.zPosition    = [SIGameController floatZPositionGameForContent:SIZPositionGameContentBottom];
        _sceneGameToolbarPowerUp.zPosition              = [SIGameController floatZPositionGameForContent:SIZPositionGameContentBottom];
        _sceneGame.popTip                               = nil;
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
            [SIGame stopSoundNamed:kSISoundFXFireBurning];
            break;
        case SIPowerUpTypeFallingMonkeys:
            /*Do Falling Monkeys Breakdown*/
            if (_sceneFallingMonkey.userMessage.hidden == NO) {
                _sceneFallingMonkey.userMessage.hidden = YES;
            }
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
    emitterNode.position                    = CGPointMake(_sceneSize.width / 2.0f, _sceneSize.height);
    emitterNode.targetNode                  = _sceneGame.backgroundNode;
    emitterNode.zPosition                   = 100;
    emitterNode.xScale                      = 2.0f;
    emitterNode.particleLifetime            = SIPowerUpDurationTimeFreeze;
    [_sceneGame.backgroundNode addChild:emitterNode];

}

- (SKEmitterNode *)newSnowEmitter {
    NSString *snowPath = [[NSBundle mainBundle] pathForResource:kSIEmitterSnowTimeFreeze ofType:kSIEmitterFileTypeSKS];
    SKEmitterNode *snow = [NSKeyedUnarchiver unarchiveObjectWithFile:snowPath];
    return snow;
}

- (void)powerUpRemoveSnowEmitter {
    for (SKNode *node in _sceneGame.backgroundNode.children) {
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
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [SIGame playSound:kSISoundFXChaChing];
            });
            [[MKStoreKit sharedKit] addFreeCredits:[NSNumber numberWithInt:1] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
            _sceneGame.swypeItCoins         = [[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue];
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
    if (_overlayNode.parent) {
        [_overlayNode removeFromParent];
    }
    [_sceneGame addChild:_overlayNode];
    [_overlayNode runAction:[SKAction sequence:@[[SKAction group:@[_fadeAlphaIn,[SKAction runBlock:^{
        /*Fade out what you know you don't need*/
        [_sceneGamePopupGameOver.titleContentNode runAction:_fadeOut];
        [_sceneGamePopupGameOver.topNode runAction:_fadeOut];
        [_sceneGamePopupGameOver.centerNode runAction:_fadeOut];
        [_sceneGamePopupGameOver.bottomNode runAction:_fadeOut];
        
    }]]], [SKAction runBlock:^{
        _sceneGamePopupSIMenuNodeStore.delegate                         = self;
        
        [_sceneGamePopupSIMenuNodeStore.backButtonNode setTouchUpInsideTarget:self selector:@selector(sceneGamePopupGameOverBackButton)];
        
        [_sceneGamePopupGameOver updateTopNode:nil
                                    centerNode:_sceneGamePopupSIMenuNodeStore
                            centerNodePosition:[SIGameController SIMenuNodeStorePopupCenterNodePoint]
                                    bottomNode:nil
                       bottomNodeBottomSpacing:VERTICAL_SPACING_8
                          dismissButtonVisible:NO
                          updateBackgroundSize:NO
                                backgroundSize:CGSizeZero];
        
        
        
    }],[SKAction group:@[_fadeAlphaOut,[SKAction runBlock:^{
        [_sceneGamePopupGameOver.titleContentNode runAction:_fadeIn];
        [_sceneGamePopupGameOver.centerNode runAction:_fadeIn];
        
    }]]],[SKAction removeFromParent]]]];

}

- (void)sceneGamePopupContinueShopButton {
    
    /*I think the timer should be stoped before the fade*/
    _popupTimePauseOffset                                           = 0.0f;
    _popupTimePauseStart                                            = [NSDate timeIntervalSinceReferenceDate];
    _sceneGamePopupContinue.countDownTimerState                     = SIPopupCountDownTimerPaused;
    
    if (_overlayNode.parent) {
        [_overlayNode removeFromParent];
    }
    [_sceneGame addChild:_overlayNode];
    [_overlayNode runAction:[SKAction sequence:@[[SKAction group:@[_fadeAlphaIn,[SKAction runBlock:^{
        /*Fade out what you know you don't need*/
        [_sceneGamePopupContinue.titleContentNode runAction:_fadeOut];
        [_sceneGamePopupContinue.topNode runAction:_fadeOut];
        [_sceneGamePopupContinue.centerNode runAction:_fadeOut];
        [_sceneGamePopupContinue.bottomNode runAction:_fadeOut];
        
    }]]], [SKAction runBlock:^{
        _sceneGamePopupSIMenuNodeStore.delegate                         = self;
//        [_sceneGamePopupSIMenuNodeStore.backButtonNode performBlock:^{
//            [self sceneGamePopupGameOverBackButton];
//        } onEvent:AGButtonControlEventTouchUpInside];

        [_sceneGamePopupSIMenuNodeStore.backButtonNode setTouchUpInsideTarget:self selector:@selector(sceneGamePopupContinue)];
        
        [_sceneGamePopupContinue updateTopNode:nil
                                    centerNode:_sceneGamePopupSIMenuNodeStore
                            centerNodePosition:[SIGameController SIMenuNodeStorePopupCenterNodePoint]
                                    bottomNode:nil
                       bottomNodeBottomSpacing:VERTICAL_SPACING_8
                          dismissButtonVisible:NO
                          updateBackgroundSize:YES
                                backgroundSize:CGSizeMake(_sceneSize.width - [SIGameController xPaddingPopupContinue], _sceneSize.height - [SIGameController yPaddingPopupContinue])];
        
        
        _sceneGamePopupContinue.position                                        = [SIGameController SIPopupSceneGamePositionPoint];

    }],[SKAction group:@[_fadeAlphaOut,[SKAction runBlock:^{
        [_sceneGamePopupContinue.titleContentNode runAction:_fadeIn];
        [_sceneGamePopupContinue.centerNode runAction:_fadeIn];
        
    }]]],[SKAction removeFromParent]]]];
    
}

- (void)sceneGamePopupGameOverBackButton {
    if (_sceneGamePopupGameOver.countDownTimerState == SIPopupCountDownTimerPaused) {
        _sceneGamePopupGameOver.countDownTimerState                         = SIPopupCountDownTimerRunning;
        [self sceneGamePopupContinue];

    } else {
        [self sceneGamePopupGameOver];
    }
}

- (void)sceneGamePopupGameOver {
    
    [self configureGameOverDetailsSpriteNode:_sceneGamePopupGameOverEndNode forGame:_gameModel.game];
    _sceneGamePopupContinueUserMessage                      = [SIGame userMessageForScore:_gameModel.game.totalScore isHighScore:_gameModel.game.isHighScore highScore:[SIGame devieHighScoreNSUserDefaults:[NSUserDefaults standardUserDefaults]]];
    _sceneGamePopupGameOverUserMessageLabelNode.text        = _sceneGamePopupContinueUserMessage;

    if (_overlayNode.parent) {
        [_overlayNode removeFromParent];
    }
    [_sceneGame addChild:_overlayNode];
    [_overlayNode runAction:[SKAction sequence:@[[SKAction group:@[_fadeAlphaIn,[SKAction runBlock:^{
        /*Fade out what you know you don't need*/
        [_sceneGamePopupGameOver.titleContentNode runAction:_fadeOut];
        [_sceneGamePopupGameOverEndNode runAction:_fadeOut];
        [_sceneGamePopupGameOverUserMessageLabelNode runAction:_fadeOut];
        [_sceneGamePopupGameOverBottomNode runAction:_fadeOut];

        
        // shop popup pre fading
        [_sceneGamePopupSIMenuNodeStore runAction:[SKAction fadeAlphaTo:0.0f duration:_fadeOut.duration]];

        
    }]]], [SKAction runBlock:^{
        
        CGFloat userMessageOffset = 0.0f;
        
        if (IS_IPHONE_4) {
            userMessageOffset = VERTICAL_SPACING_16 + (_sceneGamePopupGameOverUserMessageLabelNode.size.height / 2.0f);
        }

        [_sceneGamePopupGameOver updateTopNode:_sceneGamePopupGameOverEndNode
                                    centerNode:_sceneGamePopupGameOverUserMessageLabelNode
                            centerNodePosition:CGPointMake(0.0f, userMessageOffset)
                                    bottomNode:_sceneGamePopupGameOverBottomNode
                       bottomNodeBottomSpacing:IDIOM == IPAD ? 100 : VERTICAL_SPACING_8
                          dismissButtonVisible:NO
                          updateBackgroundSize:YES
                                backgroundSize:CGSizeMake(_sceneSize.width - [SIGameController xPaddingPopupContinue], _sceneSize.height - [SIGameController yPaddingPopupContinue])];
        _sceneGamePopupGameOver.delegate    = self;
        
//        _sceneGamePopupGameOver.topNode.position                                 = CGPointMake(0.0f, _sceneGamePopupGameOverUserMessageLabelNode.position.y + VERTICAL_SPACING_16);
        ((SKLabelNode *)_sceneGamePopupGameOver.titleContentNode).text          = NSLocalizedString(kSITextPopupContinueGameOver, nil);
        _sceneGamePopupGameOver.topNode.position                                = CGPointMake(0.0f, ((SKLabelNode *)_sceneGamePopupGameOver.titleContentNode).frame.size.height + (_sceneGamePopupGameOverEndNode.size.height / 2.0f) + VERTICAL_SPACING_16);
        
        _sceneGamePopupGameOver.position                                        = [SIGameController SIPopupSceneGamePositionPoint];
    }],[SKAction group:@[_fadeAlphaOut,[SKAction runBlock:^{
        [_sceneGamePopupGameOver.titleContentNode runAction:_fadeIn];
        [_sceneGamePopupGameOverEndNode runAction:_fadeIn];
        [_sceneGamePopupGameOverUserMessageLabelNode runAction:_fadeIn];
        [_sceneGamePopupGameOverBottomNode runAction:_fadeIn];

    }]]],[SKAction removeFromParent]]]];
    
    

}

- (void)sceneGamePopupContinue {
    _sceneGamePopupContinue.countDownTimerState = SIPopupCountDownTimerRunning;
    if (_overlayNode.parent) {
        [_overlayNode removeFromParent];
    }
    [_sceneGame addChild:_overlayNode];
    [_overlayNode runAction:[SKAction sequence:@[[SKAction group:@[_fadeAlphaIn,[SKAction runBlock:^{
        /*Fade out what you know you don't need*/
        [_sceneGamePopupContinue.titleContentNode runAction:_fadeOut];
        [_sceneGamePopupContinueCountdownLabel runAction:_fadeOut];
        [_sceneGamePopupContinueButtonsNode runAction:_fadeOut];
        [_sceneGamePopupGameOverEndGameButton runAction:_fadeOut];
        
        
        // shop popup pre fading
        [_sceneGamePopupSIMenuNodeStore runAction:[SKAction fadeAlphaTo:0.0f duration:_fadeOut.duration]];
        
        
    }]]], [SKAction runBlock:^{
        _sceneGamePopupContinue.delegate = self;
        
        [self sceneGamePopupContinueConfigureButtons];
        
        [_sceneGamePopupGameOverEndGameButton setTouchUpInsideTarget:self selector:@selector(sceneGamePopupContinueButtonEndGame)];

        [_sceneGamePopupContinue updateTopNode:_sceneGamePopupContinueButtonsNode
                                    centerNode:_sceneGamePopupContinueCountdownLabel
                            centerNodePosition:CGPointMake(0.0f, (-1.0f * ((_sceneSize.width - [SIGameController xPaddingPopupContinue]) / 2.0f)) + VERTICAL_SPACING_4 + _sceneGamePopupGameOverEndGameButton.size.height + (VERTICAL_SPACING_4 / 2.0f) + ([SIGameController SISpriteNodePopupContinueCenterNode].size.height / 2.0f))
                                    bottomNode:_sceneGamePopupGameOverEndGameButton
                       bottomNodeBottomSpacing:(((INSKButtonNode *)_sceneGamePopupContinue.bottomNode).size.height / 2.0f) + VERTICAL_SPACING_4
                          dismissButtonVisible:NO
                          updateBackgroundSize:YES
                                backgroundSize:CGSizeMake(_sceneSize.width - [SIGameController xPaddingPopupContinue], _sceneSize.width - [SIGameController xPaddingPopupContinue])];
        
        ((SKLabelNode *)_sceneGamePopupContinue.titleContentNode).text          = NSLocalizedString(kSITextPopupContinueContinue, nil);
        _sceneGamePopupContinue.topNode.position                                = CGPointMake(0.0f, CGRectGetMinY(_sceneGamePopupContinue.titleContentNode.frame) - ((CGRectGetMinY(_sceneGamePopupContinue.titleContentNode.frame) - CGRectGetMaxY(_sceneGamePopupContinue.centerNode.frame))/2.0f));
        

    }],[SKAction group:@[_fadeAlphaOut,[SKAction runBlock:^{
        [_sceneGamePopupContinue.titleContentNode runAction:_fadeIn];
        [_sceneGamePopupContinueCountdownLabel runAction:_fadeIn];
        [_sceneGamePopupContinueButtonsNode runAction:_fadeIn];
        [_sceneGamePopupGameOverEndGameButton runAction:_fadeIn];
        
    }]]],[SKAction removeFromParent]]]];

}

- (void)sceneGamePopupContinueInital {
//    [self sceneGamePopupContinueConfigureButtons];
    
    [_sceneGame addChild:_overlayNode];
    [_overlayNode runAction:[SKAction sequence:@[[SKAction group:@[_fadeAlphaIn,[SKAction runBlock:^{
        /*Fade out what you know you don't need*/
        [_sceneGamePopupContinue.titleContentNode runAction:_fadeOut];
        [_sceneGamePopupContinueCountdownLabel runAction:_fadeOut];
        [_sceneGamePopupContinueButtonsNode runAction:_fadeOut];
        [_sceneGamePopupGameOverEndGameButton runAction:_fadeOut];
        
        
        // shop popup pre fading
        [_sceneGamePopupSIMenuNodeStore runAction:[SKAction fadeAlphaTo:0.0f duration:_fadeOut.duration]];
        
        
    }]]], [SKAction runBlock:^{
        _sceneGamePopupContinue.delegate = self;
        
        [self sceneGamePopupContinueConfigureButtons];
        
        [_sceneGamePopupGameOverEndGameButton setTouchUpInsideTarget:self selector:@selector(sceneGamePopupContinueButtonEndGame)];
        
        CGSize endGameButtonSize = [_sceneGamePopupGameOverEndGameButton calculateAccumulatedFrame].size;
        [_sceneGamePopupContinue updateTopNode:_sceneGamePopupContinueButtonsNode
                                    centerNode:_sceneGamePopupContinueCountdownLabel
                            centerNodePosition:CGPointMake(0.0f, (-1.0f * (_sceneGamePopupContinue.backgroundSize.height / 2.0f)) + VERTICAL_SPACING_4 + _sceneGamePopupGameOverEndGameButton.size.height + (VERTICAL_SPACING_4 / 2.0f) + ([SIGameController SISpriteNodePopupContinueCenterNode].size.height / 2.0f))
                                    bottomNode:_sceneGamePopupGameOverEndGameButton
                       bottomNodeBottomSpacing:(endGameButtonSize.height / 2.0f) + VERTICAL_SPACING_8
                          dismissButtonVisible:NO
                          updateBackgroundSize:YES
                                backgroundSize:CGSizeMake(_sceneSize.width - [SIGameController xPaddingPopupContinue], _sceneSize.width - [SIGameController xPaddingPopupContinue])];
        
        ((SKLabelNode *)_sceneGamePopupContinue.titleContentNode).text          = NSLocalizedString(kSITextPopupContinueContinue, nil);
        _sceneGamePopupContinue.topNode.position                                = CGPointMake(0.0f, CGRectGetMinY(_sceneGamePopupContinue.titleContentNode.frame) - ((CGRectGetMinY(_sceneGamePopupContinue.titleContentNode.frame) - CGRectGetMaxY(_sceneGamePopupContinue.centerNode.frame))/2.0f));
        
    }],[SKAction group:@[_fadeAlphaOut,[SKAction runBlock:^{
        [_sceneGamePopupContinue.titleContentNode runAction:_fadeIn];
        [_sceneGamePopupContinueCountdownLabel runAction:_fadeIn];
        [_sceneGamePopupContinueButtonsNode runAction:_fadeIn];
        [_sceneGamePopupGameOverEndGameButton runAction:_fadeIn];
        
    }]]],[SKAction removeFromParent]]]];
    
//    _sceneGamePopupContinue.backgroundSize                          = CGSizeMake(_sceneSize.width - [SIGameController xPaddingPopupContinue], _sceneSize.width - [SIGameController xPaddingPopupContinue]);
//    _sceneGamePopupContinue.dismissButtonVisible                    = NO;
    
    
//    _sceneGamePopupContinue.topNode                                 = _sceneGamePopupContinueButtonsNode;
//    _sceneGamePopupContinue.centerNode                              = _sceneGamePopupContinueCountdownLabel;
//    _sceneGamePopupContinue.bottomNode                              = _sceneGamePopupGameOverEndGameButton;
//    
//    
//    _sceneGamePopupContinue.topNode.position                        = CGPointMake(0.0f, CGRectGetMinY(_sceneGamePopupContinue.titleContentNode.frame) - ((CGRectGetMinY(_sceneGamePopupContinue.titleContentNode.frame))) + [SIGameController SIFontSizeHeader]);// - CGRectGetMaxY(_sceneGamePopupContinue.centerNode.frame))/2.0f));
//    _sceneGamePopupContinue.centerNodePosition                      = CGPointMake(0.0f, (-1.0f * (_sceneGamePopupContinue.backgroundSize.height / 2.0f)) + VERTICAL_SPACING_4 + _sceneGamePopupGameOverEndGameButton.size.height + (VERTICAL_SPACING_4 / 2.0f) + ([SIGameController SISpriteNodePopupContinueCenterNode].size.height / 2.0f));
//    _sceneGamePopupContinue.bottomNodeBottomSpacing                 = (((INSKButtonNode *)_sceneGamePopupContinue.bottomNode).size.height / 2.0f) + VERTICAL_SPACING_4;
//    
//    
//    [_sceneGamePopupGameOverEndGameButton setTouchUpInsideTarget:self selector:@selector(sceneGamePopupContinueButtonEndGame)];
    

}

- (void)sceneGamePopupContinueConfigureButtons {
    for (SKNode *node in _sceneGamePopupContinueButtonsNode.children) {
        if ([node.name isEqualToString:kSINodeButtonUseCoins]) {
            if ([SIIAPUtility canAffordContinueNumberOfTimesContinued:_gameModel.game.currentNumberOfTimesContinued]) {
                _sceneGamePopupMenuItemTextContinueWithCoin     = [NSString stringWithFormat:@"Use %d Coins!",(int)[SIGame lifeCostForNumberOfTimesContinued:_gameModel.game.currentNumberOfTimesContinued]];
            } else {
                _sceneGamePopupMenuItemTextContinueWithCoin     = NSLocalizedString(kSITextPopupContinueBuyCoins, nil);
            }
            ((SKLabelNode *)[((INSKButtonNode *)node).nodeHighlighted childNodeWithName:kSINodeButtonText]).text    = _sceneGamePopupMenuItemTextContinueWithCoin;
            ((SKLabelNode *)[((INSKButtonNode *)node).nodeNormal childNodeWithName:kSINodeButtonText]).text         = _sceneGamePopupMenuItemTextContinueWithCoin;
            ((INSKButtonNode *)node).inskButtonNodeDelegate                                                         = self;
            [((INSKButtonNode *)node) setTouchUpInsideTarget:self selector:@selector(sceneGamePopupContinueButtonUseCoins)];
            
        } else if ([node.name isEqualToString:kSINodeButtonWatchAds]) {
            if ([FXReachability isReachable]) {
                node.hidden = NO;
                _sceneGamePopupMenuItemTextContinueWithAd           = [NSString stringWithFormat:@"Watch %d Ads!",(int)[SIGame adCountForNumberOfTimesContinued:_gameModel.game.currentNumberOfTimesContinued]];
                ((SKLabelNode *)[((INSKButtonNode *)node).nodeHighlighted childNodeWithName:kSINodeButtonText]).text    = _sceneGamePopupMenuItemTextContinueWithAd;
                ((SKLabelNode *)[((INSKButtonNode *)node).nodeNormal childNodeWithName:kSINodeButtonText]).text         = _sceneGamePopupMenuItemTextContinueWithAd;
                ((INSKButtonNode *)node).inskButtonNodeDelegate                                                         = self;
                [((INSKButtonNode *)node) setTouchUpInsideTarget:self selector:@selector(sceneGamePopupContinueButtonWatchAds)];
            } else {
                node.hidden = YES;
            }
            
        }
    }
}
- (void)sceneGamePopupContinueButtonUseCoins {
    _sceneGamePopupContinue.countDownTimerState = SIPopupCountDownTimerFinished;
    if ([_sceneGamePopupMenuItemTextContinueWithCoin isEqualToString:NSLocalizedString(kSITextPopupContinueBuyCoins, nil)]) {
        [self sceneGamePopupContinueShopButton];
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
    [self controllerSceneMenuShowMenu:_menuNodeStore menuNodeAnimiation:SIMenuNodeAnimationPush delay:SCENE_TRANSITION_DURATION_NOW];
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
        NSTimeInterval remainingTime = (COUNTDOWN_TIME + 1) - ([NSDate timeIntervalSinceReferenceDate] - _sceneGamePopupContinue.startTime) + _popupTimePauseOffset;
        _sceneGamePopupContinueCountdownLabel.text = [NSString stringWithFormat:@"%i",(int)remainingTime];
        [_sceneGamePopupContinueCountdownLabel runAction:[SKAction scaleTo:remainingTime - floorf(remainingTime) duration:0.0f]];
        if (remainingTime < (EPSILON_NUMBER + 1.0f)) {
            //Call to go to end game
            
            [_continueGameTimer invalidate];
            [self sceneGamePopupContinueButtonEndGame];
            _sceneGamePopupContinueCountdownLabel.text = [NSString stringWithFormat:@"%d",COUNTDOWN_TIME];
        }
    } else if (_sceneGamePopupContinue.countDownTimerState == SIPopupCountDownTimerPaused) {
        NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
        NSLog(@"Start Time: %0.2f | Offset = %0.2f | New Start Time: %0.2f",_sceneGamePopupContinue.startTime,currentTime - _popupTimePauseStart, _sceneGamePopupContinue.startTime + (currentTime - _popupTimePauseStart));
        _popupTimePauseOffset = (currentTime - _popupTimePauseStart);
    }
}


#pragma mark User Tips
- (void)checkUserTipPowerUps {
    //Check to see if the Time Freeze user tip has been shown before
    BOOL willShowPopTip = NO;
    float xOffset = 22.0f;
//    float yOffset = 20.0f;
    if (IDIOM == IPAD) {
        xOffset = 100.0f;
    }
    
//    if (![SIGameController premiumUser]) {
//        yOffset = yOffset + [SIGameController SIAdBannerViewHeight];
//    }
    float xPosition = _sceneSize.width / 2.0f;
    if (_gameModel.game.numberOfMoves > 3) {
    
        if (![SIGameController SIBoolFromNSUserDefaults:[NSUserDefaults standardUserDefaults] forKey:kSINSUserDefaultFirstGame]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSINSUserDefaultFirstGame];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
            
        if (![SIGameController SIBoolFromNSUserDefaults:[NSUserDefaults standardUserDefaults] forKey:kSINSUserDefaultUserTipShownPowerUpTimeFreeze]) {
            _popTipNode.message                                 = NSLocalizedString(kSITextUserTipPowerUpTimeFreeze, nil);
            xPosition                                           = xPosition - xOffset;
            _popTipNode.positionHorizontal                      = SIPopTipPositionHorizontalLeft;
            willShowPopTip                                      = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _sceneGame.userMessage.hidden                   = NO;
                _sceneGame.userMessage.text                     = NSLocalizedString(kSITextUserTipPowerUpExplainTimeFreeze, nil);
            });
        } else if (![SIGameController SIBoolFromNSUserDefaults:[NSUserDefaults standardUserDefaults] forKey:kSINSUserDefaultUserTipShownPowerUpRapidFire]) {
            _popTipNode.message                                 = NSLocalizedString(kSITextUserTipPowerUpRapidFire, nil);
            _popTipNode.positionHorizontal                      = SIPopTipPositionHorizontalCenter;
            willShowPopTip                                      = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _sceneGame.userMessage.hidden                   = NO;
                _sceneGame.userMessage.text                     = NSLocalizedString(kSITextUserTipPowerUpExplainRapidFire, nil);
            });
        } else if (![SIGameController SIBoolFromNSUserDefaults:[NSUserDefaults standardUserDefaults] forKey:kSINSUserDefaultUserTipShownPowerUpFallingMonkey]) {
            _popTipNode.message                                 = NSLocalizedString(kSITextUserTipPowerUpFallingMonkey, nil);
            xPosition                                           = xPosition + xOffset;
            _popTipNode.positionHorizontal                      = SIPopTipPositionHorizontalRight;
            willShowPopTip                                      = YES;
            _sceneGame.userMessage.hidden                       = YES;
            _sceneFallingMonkey.userMessage.hidden              = NO;
            _sceneFallingMonkey.userMessage.text                = NSLocalizedString(kSITextUserTipPowerUpExplainFallingMonkey, nil);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _sceneFallingMonkey.userMessage.hidden          = YES;
            });
        }
    }
    
    if (willShowPopTip) {
        if (_popTipNode.parent) {
            [_popTipNode removeFromParent];
        }
        _tutorialActiveNoWrongMoves                         = YES;
        float yPosition = _sceneSize.height - _sceneGameToolbarPowerUp.size.height - ([_popTipNode calculateAccumulatedFrame].size.height / 2.0) - [_sceneGame.powerUpToolbarUserLabel calculateAccumulatedFrame].size.height - ([SIGameController SIGameSceneHorizontalDividerHeight] * 2.0f) - 20.0f;
        _popTipNode.position                                = CGPointMake(xPosition, yPosition);
        _sceneGame.powerUpToolbarUserLabel.zPosition        = [SIGameController floatZPositionGameForContent:SIZPositionGameTutorial];
//        SKNode *tempNode                                    = [_sceneGameToolbarPowerUp squareNodeForTool:kSIPowerUpTypeTimeFreeze];
//        tempNode.zPosition                                  = [SIGameController floatZPositionGameForContent:SIZPositionGameTutorial];
        _sceneGameToolbarPowerUp.zPosition                  = [SIGameController floatZPositionGameForContent:SIZPositionGameTutorial];
        _popTipNode.zPosition                               = [SIGameController floatZPositionGameForContent:SIZPositionGameTutorial];
        _popTipNode.positionVertical                        = SIPopTipPositionVerticalTop;
        _popTipNode.effect                                  = SIPopTipEffectBounce;
        _popTipNode.effectDeltaY                            = 5.0;
        dispatch_async(dispatch_get_main_queue(), ^{
            _sceneGame.blurScreen                           = YES;
            _sceneGame.popTip                               = _popTipNode;
        });

    } else {
        
    }
}


#pragma mark -
#pragma mark - Delegate Handlers

#pragma mark SISingletonAchievement
/**
 Called when challenge was complete
 */
- (void)controllerSingletonAchievementDidCompleteAchievement:(SIAchievement *)achievement {
    NSString *message = [NSString stringWithFormat:@"%@ %d %@",achievement.details.prefixString,[SISingletonAchievement amountForAchievementLevel:achievement.currentLevel forAchievement:achievement],achievement.details.postfixString];
    [GKNotificationBanner showBannerWithTitle:@"Achievement Completed!" message:message completionHandler:^{
        NSLog(@"Achievement Completed: %@",message);
    }];
}

/**
 Called when singleton is unable to pull from internet for sync
 */
- (void)controllerSingletonAchievementFailedToReachGameCenterWithError:(NSError *)error {
    if (error.code != GKErrorNotAuthenticated) {
        [GKNotificationBanner showBannerWithTitle:@"Error" message:@"Can't report achievement progress to game center" completionHandler:nil];
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
 Check to see if the power ups are still available
 */
- (void)checkIfCanStartAPowerUp {
    NSNumber *numberOfCoins = [[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins];
    
    if ([numberOfCoins intValue] < SIPowerUpCostTimeFreeze) { //This is the cheapest
        [_sceneGameToolbarPowerUp setEnabled:NO forTool:kSIPowerUpTypeTimeFreeze];
        [_sceneGameToolbarPowerUp setEnabled:NO forTool:kSIPowerUpTypeRapidFire];
        [_sceneGameToolbarPowerUp setEnabled:NO forTool:kSIPowerUpTypeFallingMonkeys];
    } else if ([numberOfCoins intValue] < SIPowerUpCostRapidFire) {
        [_sceneGameToolbarPowerUp setEnabled:YES forTool:kSIPowerUpTypeTimeFreeze];
        [_sceneGameToolbarPowerUp setEnabled:NO forTool:kSIPowerUpTypeRapidFire];
        [_sceneGameToolbarPowerUp setEnabled:NO forTool:kSIPowerUpTypeFallingMonkeys];
    } else if ([numberOfCoins intValue] < SIPowerUpCostFallingMonkeys) {
        [_sceneGameToolbarPowerUp setEnabled:YES forTool:kSIPowerUpTypeTimeFreeze];
        [_sceneGameToolbarPowerUp setEnabled:YES forTool:kSIPowerUpTypeRapidFire];
        [_sceneGameToolbarPowerUp setEnabled:NO forTool:kSIPowerUpTypeFallingMonkeys];
    } else {
        [_sceneGameToolbarPowerUp setEnabled:YES forTool:kSIPowerUpTypeTimeFreeze];
        [_sceneGameToolbarPowerUp setEnabled:YES forTool:kSIPowerUpTypeRapidFire];
        [_sceneGameToolbarPowerUp setEnabled:YES forTool:kSIPowerUpTypeFallingMonkeys];

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
    
    progressBarUpdate.percentPowerUp                = _powerUpPercent;
    
//    progressBarUpdate.percentPowerUp = [SIPowerUp powerUpPercentRemaining:_gameModel.powerUpArray gameTimeTotal:_gameTimeTotal timeFreezeMultiplier:_timeFreezeMultiplier withCallback:^(SIPowerUp *powerUpToDeactivate) {
//        [self powerUpDectivatePowerUp:powerUpToDeactivate];
//    }];
    
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

//
//    
//    if (![SIGameController premiumUser]) {
//        _adBannerView.hidden            = NO;
//        self.canDisplayBannerAds        = YES;
//    }
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:1.0f];
//    _adBannerView.alpha                 = 1.0f;
//    [UIView commitAnimations];
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
    if (type == SISceneMenuTypeStart) {
        [self tryForDailyPrize];
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
    
    //update the background music
    [self updateBackgroundSound];

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
    _currentMove.moveCommand = SIMoveCommandSwype;
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
    if (menuNode == _sceneGamePopupMenuNode) {
        if ([menuItem.text isEqualToString:_sceneGamePopupMenuItemTextContinueWithCoin]) {
            if ([menuItem.text isEqualToString:kSITextPopupContinueBuyCoins]) {
                _sceneGamePopupSIMenuNodeStore.delegate = self;
                _sceneGamePopupContinue.backgroundSize = CGSizeMake(_sceneSize.width - VERTICAL_SPACING_16, _sceneSize.width - VERTICAL_SPACING_16);
                _sceneGamePopupContinue.centerNode = _sceneGamePopupSIMenuNodeStore;
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
    } else if ([menuNode.name isEqualToString:_sceneMenuStoreMenuNode.name] || menuNode == (HLMenuNode*)_sceneGamePopupSIMenuNodeStore.centerNode) {
        if ([FXReachability isReachable]) {
            [self requestPurchaseForPack:[SIIAPUtility siiapPackForNameNodeNode:menuItem.text]];
        } else {
            [self hudTextFlashDuration:3.0f title:NSLocalizedString(kSITextHudSorry, nil) info:NSLocalizedString(kSITextHudInternetMustHave, nil)];
        }
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
//            [_sceneMenu dismissModalNodeAnimation:HLScenePresentationAnimationFade];
            NSLog(@"Tool bar tapped with modal node presented");
            return;
        }
        if ([toolTag isEqualToString:kSINodeButtonLeaderboard]) {
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
            [self showGameCenterAchievements];
        }
    }
}


#pragma mark HLRingNodeDelegate
- (void)ringNode:(HLRingNode *)ringNode didTapItem:(int)itemIndex {
    switch (itemIndex) {
        case SISceneGameRingNodeEndGame:
            _sceneGame.blurScreen   = NO;
            _sceneGame.ringNode     = nil;
            _sceneGame.popupNode    = _sceneGamePopupGameOver;
            [self sceneGamePopupContinueConfigureButtons];
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
    } else if (popupNode == _sceneGamePopupGameOver) {
        [self startNewGame];
    } else {
        HLScene *currentHLSceen                         = (HLScene *)_currentScene;
        [currentHLSceen dismissModalNodeAnimation:HLScenePresentationAnimationFade];
    }
}

#pragma mark AdBannerDelegate
- (void)adBannerWasTapped {
//    NSLog(@"Ad banner was tapped");
    if (_currentScene == _sceneMenu) {
        if (_sceneMenu.currentMenuNode == _menuNodeStart) { //show the menu node
            [self controllerSceneMenuShowMenu:_menuNodeStore menuNodeAnimiation:SIMenuNodeAnimationPush delay:SCENE_TRANSITION_DURATION_NOW];
        }
    } 
}

#pragma mark SILoadingSceneDelegate
- (void)loadingSceneDidLoad {
    _loadTimer                                              = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(loadSmoothSynch) userInfo:nil repeats:YES];
    _loadTimeStart                                          = [NSDate timeIntervalSinceReferenceDate];
    [self loadAllScenes];
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
- (void)gameModelStateLoadingEntered {
    _sceneLoading                                           = [SIGameController SILoaderSceneLoadingSize:_sceneSize];
    _sceneLoading.sceneDelegate                             = self;
    [self loadingIncrementWillOverrideAndKill:NO];
    [self presentScene:SIGameControllerSceneLoading];
    /*Load the scenes*/
//    [self loadAllScenes];
}

/**
 Called when the game is done loading
 */

- (void)gameModelStateLoadingExited {
    NSLog(@"Load State Exited");
//    _sceneLoading = [SIGameController SILoaderSceneLoadingSize:_sceneSize];
//    [self loadingIncrementWillOverrideAndKill:NO];
//    [self presentScene:SIGameControllerSceneLoading];
//    SKView *skView = (SKView *)self.originalContentView;
//    [skView presentScene:SIGameControllerSceneLoading];
    /*Load the scenes*/
//    [self loadAllScenes];
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
    
    if (_sceneGame.popTip == nil) {
        _sceneGame.blurScreen = NO;
    }
    
    if (_currentScene != _sceneGame) {
        [self presentScene:SIGameControllerSceneGame];
    }
    
    if ([_timerStateMachine isInState:kSITKStateMachineStateTimerRunning] == NO) {
        if ([_timerStateMachine isInState:kSITKStateMachineStateTimerPaused]) {
            [self timerFireEvent:kSITKStateMachineEventTimerResume userInfo:nil];
        } else {
            [self timerFireEvent:kSITKStateMachineEventTimerStart userInfo:nil];
        }
    }
    
    if (![SIGameController SIBoolFromNSUserDefaults:[NSUserDefaults standardUserDefaults] forKey:kSINSUserDefaultFirstGame]) {
        _sceneGame.userMessage.text                     = NSLocalizedString(kSITextUserTipFirstGame, nil);
        _sceneGame.userMessage.hidden                   = NO;
        _tutorialActiveNoWrongMoves                     = YES;
    }
    
    _gameModel.game.currentBackgroundColorNumber        = [SIGame newBackgroundColorNumberCurrentNumber:_gameModel.game.currentBackgroundColorNumber totalScore:_gameModel.game.totalScore];
    
    _gameModel.game.currentBackgroundColor              = [SIGame backgroundColorForScore:_gameModel.game.totalScore forRandomNumber:_gameModel.game.currentBackgroundColorNumber];

    
    if (_gameModel.game.isHighScore) {
        _sceneGame.highScore = YES;
    }
    
    _sceneGame.backgroundColor                          = _gameModel.game.currentBackgroundColor;
//    _sceneGame.progressBarPowerUp.backgroundColor       = [SKColor blackColor]; //_gameModel.game.currentBackgroundColor;
    _sceneGame.scoreTotalLabel.text                     = [NSString stringWithFormat:@"%0.2f",_gameModel.game.totalScore];
    
    _sceneGame.moveCommandNode                          = [SIGameController SISpriteForMove:_currentMove.moveCommand];
    _sceneGame.scoreMoveLabel                           = [[SIGameController SILabelSceneGameMoveScoreLabel] copy];
    
    [self updateBackgroundSound];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self checkIfCanStartAPowerUp];
    });
    
}

- (void)gameModelStateProcessingMoveEnteredWithMove:(SIMove *)move {
    
    
    //if correctMove
    if (move.moveCommand == _currentMove.moveCommand || _tutorialActiveNoWrongMoves) {
        _currentMove.timeEnd                            = _gameTimeTotal;
        
        
        [self gameProcessAndApplyCorrectMove:_currentMove];
        
        //  launch the move command and such
        /*DISABLING MOVE EFFECTS FOR 2.0.0 Release*/
//        [_sceneGame sceneGameLaunchMoveScore:_sceneGame.scoreMoveLabel];
//        [_sceneGame sceneGameLaunchMoveCommand:_sceneGame.moveCommandNode WithCommandAction:move.moveCommandAction];

        
        //  send move to achievement
        /*DISABLING ACHIEVEMENTS for 2.0.0 Release*/
//        SIMove *moveForBackground                       = _currentMove;
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            [[SISingletonAchievement singleton] singletonAchievementWillProcessMove:moveForBackground];
//        });
        
        //Add the move to the move count
        _gameModel.game.numberOfMoves                   = _gameModel.game.numberOfMoves + 1;
        
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
//        _sceneGame.moveCommandNode = nil;
        [self sceneGameEndGameProtocal];
    }
}

- (void)sceneGameEndGameProtocal {
    _sceneGame.blurScreen = YES;
    
    [SIGame playSound:kSISoundFXGameOver];
    /*Vibrate the phone*/
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    _timeFreezeMultiplier                           = 1.0f;
    
    _sceneGame.userMessage.hidden                   = YES;
    _sceneFallingMonkey.userMessage.hidden          = YES;
    
    [self gameFireEvent:kSITKStateMachineEventGameWrongMoveEntered userInfo:nil];
    //  load start/end scene
    if (_sceneMenu == nil) {
        [NSException raise:NSInvalidArgumentException format:@"Menu Scene Cannot be nil here"];
        _sceneMenu                                  = [self loadMenuScene];
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
    
//    _sceneGame.scoreTotalLabel.text                     = @"99999.99";//[NSString stringWithFormat:@"%0.2f",_gameModel.game.totalScore];
    _sceneGame.progressBarFreeCoin.progress             = _gameModel.game.freeCoinPercentRemaining;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (_sceneGame.popTip == nil && [SIPowerUp isPowerUpArrayEmpty:_gameModel.powerUpArray]) {
            [self checkUserTipPowerUps];
        }
    });
}

/**
 //pause time
 
 //display blur screen
 
 //present continue popup
 
 //connect it's gesture target!
 */
- (void)gameModelStatePopupContinueEntered {
    [self timerFireEvent:kSITKStateMachineEventTimerPause userInfo:nil];
    
    [self sceneGamePopupContinueInital];
    
    if (_sceneGame.popTip) {
        _sceneGame.popTip = nil;
    }
    /*This is all you need to set to make the game scene display a popup because it will relayout the z*/
    _sceneGamePopupContinue.startTime                           = [NSDate timeIntervalSinceReferenceDate];
    _sceneGamePopupContinue.countDownTimerState                 = SIPopupCountDownTimerRunning;
    _popupTimePauseOffset                                       = 0.0f;
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
    BOOL success = YES;
    switch (paymentMethod) {
        case SISceneGamePopupContinueMenuItemAd:
            _sceneGame.blurScreen                       = NO;
            _interstitialAdPresentationIsLive           = YES;
            _numberOfAdsToWatch = [SIGame adCountForNumberOfTimesContinued:_gameModel.game.currentNumberOfTimesContinued];
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
    _gameModel.game.currentNumberOfTimesContinued++;

    
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
    _sceneGame.popupNode = _sceneGamePopupGameOver;
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
    
    _gameModel.game.currentBackgroundSound = SIBackgroundSoundMenu;
    [SIGame playMusic:[SIGame soundNameForSIBackgroundSound:SIBackgroundSoundMenu] looping:YES fadeIn:YES];

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
            _sceneGamePopupContinue.countDownTimerState = SIPopupCountDownTimerRunning;
        }
    } else {
        NSLog(@"'%@' touched down", button.name);
        _popupTimePauseOffset                       = 0.0f;
        _popupTimePauseStart                        = [NSDate timeIntervalSinceReferenceDate];
        NSLog(@"Popup started at: %0.2f", _popupTimePauseStart);
        _sceneGamePopupContinue.countDownTimerState = SIPopupCountDownTimerPaused;
    }
}

- (void)buttonNode:(INSKButtonNode *)button touchMoveUpdatesHighlightState:(BOOL)isHighlighted {
    if (isHighlighted) {
        NSLog(@"'%@' highlights again", button.name);
    } else {
        NSLog(@"'%@' not highlighted anymore", button.name);
        _sceneGamePopupContinue.countDownTimerState = SIPopupCountDownTimerRunning;
    }
}

- (void)buttonNodeTouchCancelled:(INSKButtonNode *)button {
    NSLog(@"'%@' has all touches get cancelled", button.name);
    _sceneGamePopupContinue.countDownTimerState = SIPopupCountDownTimerRunning;

}

#pragma mark SIPopTip
- (void)dismissPopTip:(SIPopTip *)popTip {
    if (_sceneGame.popTip) {
        _sceneGame.popTip       = nil;
    }
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
        return 60.0f;
    } else if (IS_IPHONE_5) {
        return [SIGameController premiumUser] ? 60.0f : 80.0f;
    } else if (IS_IPHONE_6) {
        return [SIGameController premiumUser] ? 80.0f : 90.0f;
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
+ (float)SIMenuNodeStoreBottomSpacingWithSize:(CGSize)size {
    if ([SIGameController premiumUser]) {
        if (IS_IPHONE_4) {
            return [SIGameController SIButtonStoreSize:size].height * 2.0 + VERTICAL_SPACING_16;
            
        } else if (IS_IPHONE_5) {
            return [SIGameController SIButtonStoreSize:size].height * 1.9 + VERTICAL_SPACING_16;
            
        } else if (IS_IPHONE_6) {
            return [SIGameController SIButtonStoreSize:size].height * 2.0 + VERTICAL_SPACING_16;
            
        } else if (IS_IPHONE_6_PLUS) {
            return [SIGameController SIButtonStoreSize:size].height * 1.9 + VERTICAL_SPACING_16;
            
        } else {
            return [SIGameController SIButtonStoreSize:size].height * 1.9 + VERTICAL_SPACING_16;
            
        }
    } else {
        if (IS_IPHONE_4) {
            return [SIGameController SIButtonStoreSize:size].height * 2.4 - [SIGameController SIAdBannerViewHeight];
            
        } else if (IS_IPHONE_5) {
            return [SIGameController SIButtonStoreSize:size].height * 2.3 - [SIGameController SIAdBannerViewHeight];
            
        } else if (IS_IPHONE_6) {
            return [SIGameController SIButtonStoreSize:size].height * 2.3 - [SIGameController SIAdBannerViewHeight];
            
        } else if (IS_IPHONE_6_PLUS) {
            return [SIGameController SIButtonStoreSize:size].height * 2.2 - [SIGameController SIAdBannerViewHeight];
            
        } else {
            return [SIGameController SIButtonStoreSize:size].height * 2.2 - [SIGameController SIAdBannerViewHeight];
            
        }

    }
}

+ (float)SIMenuNodeStorePopupBottomSpacingWithSize:(CGSize)size {
    if ([SIGameController premiumUser]) {
        if (IS_IPHONE_4) {
            return [SIGameController SIButtonStoreSize:size].height * 1.2 + VERTICAL_SPACING_16;
            
        } else if (IS_IPHONE_5) {
            return [SIGameController SIButtonStoreSize:size].height * 1.35 + VERTICAL_SPACING_16;
            
        } else if (IS_IPHONE_6) {
            return [SIGameController SIButtonStoreSize:size].height * 1.35 + VERTICAL_SPACING_16;
            
        } else if (IS_IPHONE_6_PLUS) {
            return [SIGameController SIButtonStoreSize:size].height * 1.3 + VERTICAL_SPACING_16;
            
        } else {
            return [SIGameController SIButtonStoreSize:size].height * 1.3 + VERTICAL_SPACING_16;
            
        }
    } else {
        if (IS_IPHONE_4) {
            return [SIGameController SIButtonStoreSize:size].height * 2.3 - [SIGameController SIAdBannerViewHeight];
            
        } else if (IS_IPHONE_5) {
            return [SIGameController SIButtonStoreSize:size].height * 1.8 - [SIGameController SIAdBannerViewHeight];
            
        } else if (IS_IPHONE_6) {
            return [SIGameController SIButtonStoreSize:size].height * 1.85 - [SIGameController SIAdBannerViewHeight];
            
        } else if (IS_IPHONE_6_PLUS) {
            return [SIGameController SIButtonStoreSize:size].height * 1.85 - [SIGameController SIAdBannerViewHeight];
            
        } else {
            return [SIGameController SIButtonStoreSize:size].height * 1.85 - [SIGameController SIAdBannerViewHeight];
            
        }
    }
}

+ (CGFloat)SIGameSceneHorizontalDividerHeight {
    if (IS_IPHONE_4) {
        return 2.0f;

    } else if (IS_IPHONE_5) {
        return 2.0f;
        
    } else if (IS_IPHONE_6) {
        return 2.0f;
        
    } else if (IS_IPHONE_6_PLUS) {
        return 2.0f;
        
    } else {
        return 4.0f;
        
    }
}

#pragma mark CGPoints
+ (CGPoint)SIMenuNodeStorePopupCenterNodePoint {
    if (IS_IPHONE_4) {
        return CGPointMake(0.0f, -VERTICAL_SPACING_8);
        
    } else if (IS_IPHONE_5) {
        return CGPointMake(0.0f, -VERTICAL_SPACING_16);
        
    } else if (IS_IPHONE_6) {
        return CGPointMake(0.0f, -VERTICAL_SPACING_4);
        
    } else if (IS_IPHONE_6_PLUS) {
        return CGPointZero;
        
    } else {
        return CGPointZero;
        
    }
}

+ (CGPoint)SIPopupSceneGamePositionPoint {
    if ([SIGameController premiumUser]) {
        return CGPointZero;
    }
    if (IS_IPHONE_4) {
        return CGPointMake(0.0f, VERTICAL_SPACING_16);
        
    } else if (IS_IPHONE_5) {
        return CGPointMake(0.0f, VERTICAL_SPACING_16);
        
    } else if (IS_IPHONE_6) {
        return CGPointMake(0.0f, VERTICAL_SPACING_8 + VERTICAL_SPACING_4);
        
    } else if (IS_IPHONE_6_PLUS) {
        return CGPointMake(0.0f, VERTICAL_SPACING_8);
        
    } else {
        return CGPointZero;
        
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

+ (CGSize)SIButtonStoreSize:(CGSize)size {
    if (IS_IPHONE_4) {
        return CGSizeMake(size.width - (VERTICAL_SPACING_8 * 2), (size.width - (VERTICAL_SPACING_8 * 2)) * 0.27f);
    } else if (IS_IPHONE_5) {
        return CGSizeMake(size.width - (VERTICAL_SPACING_16 * 2), (size.width - (VERTICAL_SPACING_16 * 2)) * 0.35f);
    } else if (IS_IPHONE_6) {
        return CGSizeMake(size.width - (VERTICAL_SPACING_16 * 2), size.width / 1.3f * 0.41f);
    } else if (IS_IPHONE_6_PLUS) {
        return CGSizeMake(size.width / 1.2f, size.width / 1.2f * 0.4f);
    } else {
        return CGSizeMake(size.width / 1.3f, size.width / 1.3f * 0.33f);
    }
}

+ (CGSize)SIButtonStorePopupSize:(CGSize)size {
    if (IS_IPHONE_4) {
        return CGSizeMake(size.width - (VERTICAL_SPACING_16 * 2), (size.width - (VERTICAL_SPACING_16 * 2)) * 0.225f);
    } else if (IS_IPHONE_5) {
        return CGSizeMake(size.width - (VERTICAL_SPACING_16 * 2), (size.width - (VERTICAL_SPACING_16 * 2)) * 0.31f);
    } else if (IS_IPHONE_6) {
        return CGSizeMake(size.width - (VERTICAL_SPACING_16 * 2), size.width / 1.3f * 0.41f);
    } else if (IS_IPHONE_6_PLUS) {
        return CGSizeMake(size.width / 1.2f, size.width / 1.2f * 0.4f);
    } else {
        return CGSizeMake(size.width / 1.3f, size.width / 1.3f * 0.33f);
    }
}
#pragma mark Scene Transistions


+ (SKScene *)viewController:(SKView *)view transisitionToSKScene:(SKScene *)scene duration:(CGFloat)duration {
    SKTransition *transistion;
    
    transistion = [SKTransition fadeWithColor:[SKColor blackColor] duration:duration];

    [view presentScene:scene transition:transistion];
    
    return scene;
}

+ (SKScene *)viewController:(SKView *)view transisitionToSKScene:(SKScene *)scene withTransition:(SKTransition *)transition {
    [view presentScene:scene transition:transition];
    
    return scene;
}

+ (SKScene *)viewController:(SKView *)view transisitionToSKScene:(SKScene *)scene duration:(CGFloat)duration withColor:(UIColor *)fadeColor {
    SKTransition *transistion;
    
    transistion = [SKTransition fadeWithColor:fadeColor duration:duration];
    
    [view presentScene:scene transition:transistion];
    
    return scene;
}

+ (SKScene *)transisitionZeroOpenToSKScene:(SKScene *)scene toSKView:(SKView *)view {
    SKTransition *transistion;
    
    transistion                     = [SKTransition doorsOpenHorizontalWithDuration:SCENE_TRANSITION_DURATION_NOW];
    
    transistion.pausesIncomingScene = NO;
    transistion.pausesOutgoingScene = NO;
    
    [view presentScene:scene transition:transistion];
    
    return scene;
}

+ (SKScene *)transisitionFastOpenToSKScene:(SKScene *)scene toSKView:(SKView *)view {
    SKTransition *transistion;
    
    transistion                     = [SKTransition doorsOpenHorizontalWithDuration:SCENE_TRANSITION_DURATION_FAST];
    
    transistion.pausesIncomingScene = NO;
    transistion.pausesOutgoingScene = NO;
    
    [view presentScene:scene transition:transistion];
    
    return scene;
}

+ (SKScene *)transisitionNormalOpenToSKScene:(SKScene *)scene toSKView:(SKView *)view {
    SKTransition *transistion;
    
    transistion                     = [SKTransition doorsOpenHorizontalWithDuration:SCENE_TRANSITION_DURATION_NORMAL];
    
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
    label.text              = [NSString stringWithFormat:@"%d",COUNTDOWN_TIME];
    
    return label;
}

+ (SKLabelNode *)SILabelSceneGameMoveScoreLabel {
    static SKLabelNode *labelNode = nil;
    if (!labelNode) {
        labelNode                           = moveCommandLabelNode();
        labelNode.fontSize                  = [SIGameController SIFontSizeMoveScore];

    }
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
    static SKSpriteNode *node = nil;
    if (!node) {
        node    = [SKSpriteNode spriteNodeWithImageNamed:kSIAssestFallingMonkeyBanana];
    }
    return node;
}

+ (SKSpriteNode *)SISpriteNodeBananas {
    static SKSpriteNode *node = nil;
    if (!node) {
        node = [SKSpriteNode spriteNodeWithImageNamed:kSIAssestFallingMonkeyBananas];
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

+ (SKSpriteNode *)SISpriteNodeFreeDailyPrize {
    static SKSpriteNode *node = nil;
    if (!node) {
        node = [SKSpriteNode spriteNodeWithImageNamed:kSIAssestPopupFreeDailyPrize];
    }
    return node;
}

+ (SKSpriteNode *)SISpriteNodeIAPChest {
    static SKSpriteNode *node = nil;
    if (!node) {
        node = [SKSpriteNode spriteNodeWithImageNamed:kSIAssestIAPChest];
    }
    return node;
}

+ (SKSpriteNode *)SISpriteNodeGameMoveSwype {
    static SKSpriteNode *node = nil;
    if (!node) {
        node =  [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:kSIAssestGameSwypeIt]]; //[SKSpriteNode spriteNodeWithImageNamed:kSIAssestGameSwypeIt];
    }
    return node;
}
+ (SKSpriteNode *)SISpriteNodeGameMoveShake {
    static SKSpriteNode *node = nil;
    if (!node) {
        node = [SKSpriteNode spriteNodeWithImageNamed:kSIAssestGameShakeIt];
    }
    return node;
}
+ (SKSpriteNode *)SISpriteNodeGameMovePinch {
    static SKSpriteNode *node = nil;
    if (!node) {
        node = [SKSpriteNode spriteNodeWithImageNamed:kSIAssestGamePinchIt];
    }
    return node;
}
+ (SKSpriteNode *)SISpriteNodeGameMoveTap {
    static SKSpriteNode *node = nil;
    if (!node) {
        node = [SKSpriteNode spriteNodeWithImageNamed:kSIAssestGameTapIt];
    }
    return node;
}

+ (SKSpriteNode *)SISpriteForMove:(SIMoveCommand)move {
    switch (move) {
        case SIMoveCommandTap:
            return [[SIGameController SISpriteNodeGameMoveTap] copy];
        case SIMoveCommandPinch:
            return [[SIGameController SISpriteNodeGameMovePinch] copy];
        case SIMoveCommandShake:
            return [[SIGameController SISpriteNodeGameMoveShake] copy];
        case SIMoveCommandSwype:
        default:
            return [[SIGameController SISpriteNodeGameMoveSwype] copy];
    }
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
    menuNode.itemAnimationDuration      = SCENE_TRANSITION_DURATION_FAST;
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
    menuNode.itemAnimationDuration      = SCENE_TRANSITION_DURATION_FAST;
    menuNode.itemButtonPrototype        = [[SIStoreButtonNode alloc] initWithSize:[SIGameController SIButtonStoreSize:size] buttonName:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackExtraLarge] SIIAPPack:SIIAPPackExtraLarge];
    menuNode.backItemButtonPrototype    = [SIGameController SIHLLabelButtonMenuPrototypeBack:[SIGameController SIButtonStoreSize:size]];
    menuNode.itemSeparatorSize          = [SIGameController SIButtonStoreSize:size].height + VERTICAL_SPACING_8;

    HLMenu *menu                        = [[HLMenu alloc] init];
    
    /*Add the regular buttons*/
    HLMenuItem *item1                   = [HLMenuItem menuItemWithText:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackExtraLarge]];
    item1.buttonPrototype               = [[SIStoreButtonNode alloc] initWithSize:[SIGameController SIButtonStoreSize:size] buttonName:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackExtraLarge] SIIAPPack:SIIAPPackExtraLarge];
    
    HLMenuItem *item2                   = [HLMenuItem menuItemWithText:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackLarge]];
    item2.buttonPrototype               = [[SIStoreButtonNode alloc] initWithSize:[SIGameController SIButtonStoreSize:size] buttonName:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackLarge] SIIAPPack:SIIAPPackLarge];
    
    HLMenuItem *item3                   = [HLMenuItem menuItemWithText:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackMedium]];
    item3.buttonPrototype               = [[SIStoreButtonNode alloc] initWithSize:[SIGameController SIButtonStoreSize:size] buttonName:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackMedium] SIIAPPack:SIIAPPackMedium];
    
    HLMenuItem *item4                   = [HLMenuItem menuItemWithText:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackSmall]];
    item4.buttonPrototype               = [[SIStoreButtonNode alloc] initWithSize:[SIGameController SIButtonStoreSize:size] buttonName:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackSmall] SIIAPPack:SIIAPPackSmall];
    
    [menu addItem:item4];
    [menu addItem:item3];
    [menu addItem:item2];
    [menu addItem:item1];
    
    [menuNode setMenu:menu animation:HLMenuNodeAnimationNone];
    
    return menuNode;
}

+ (HLMenuNode *)SIHLMenuNodeSceneGamePopupStore:(CGSize)size {
    HLMenuNode *menuNode                = [[HLMenuNode alloc] init];
    menuNode.itemAnimation              = HLMenuNodeAnimationNone;
    menuNode.itemAnimationDuration      = SCENE_TRANSITION_DURATION_FAST;
    menuNode.itemButtonPrototype        = [[SIStoreButtonNode alloc] initWithSize:[SIGameController SIButtonStorePopupSize:size] buttonName:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackExtraLarge] SIIAPPack:SIIAPPackExtraLarge];
    menuNode.backItemButtonPrototype    = [SIGameController SIHLLabelButtonMenuPrototypeBack:[SIGameController SIButtonStorePopupSize:size]];
    menuNode.itemSeparatorSize          = [SIGameController SIButtonStorePopupSize:size].height + VERTICAL_SPACING_8;
    
    HLMenu *menu                        = [[HLMenu alloc] init];
    
    /*Add the regular buttons*/
    HLMenuItem *item1                   = [HLMenuItem menuItemWithText:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackExtraLarge]];
    item1.buttonPrototype               = [[SIStoreButtonNode alloc] initWithSize:[SIGameController SIButtonStorePopupSize:size] buttonName:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackExtraLarge] SIIAPPack:SIIAPPackExtraLarge];
    
    HLMenuItem *item2                   = [HLMenuItem menuItemWithText:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackLarge]];
    item2.buttonPrototype               = [[SIStoreButtonNode alloc] initWithSize:[SIGameController SIButtonStorePopupSize:size] buttonName:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackLarge] SIIAPPack:SIIAPPackLarge];
    
    HLMenuItem *item3                   = [HLMenuItem menuItemWithText:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackMedium]];
    item3.buttonPrototype               = [[SIStoreButtonNode alloc] initWithSize:[SIGameController SIButtonStorePopupSize:size] buttonName:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackMedium] SIIAPPack:SIIAPPackMedium];
    
    HLMenuItem *item4                   = [HLMenuItem menuItemWithText:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackSmall]];
    item4.buttonPrototype               = [[SIStoreButtonNode alloc] initWithSize:[SIGameController SIButtonStorePopupSize:size] buttonName:[SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackSmall] SIIAPPack:SIIAPPackSmall];
    
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
    
    [toolNodes  addObject:[SKSpriteNode spriteNodeWithImageNamed:kSIAssestMenuToolbarSettings]];
    [toolTags   addObject:kSINodeButtonSettings];
    
    if (!isPremiumUser) {
        [toolNodes  addObject:[SKSpriteNode spriteNodeWithImageNamed:kSIAssestMenuToolbarAdFree]];
        [toolTags   addObject:kSINodeButtonNoAd];
    }
    
//    [toolNodes  addObject:[SKSpriteNode spriteNodeWithImageNamed:kSIAssestMenuToolbarAchievements]];
//    [toolTags   addObject:kSINodeButtonAchievement];
    
    [toolNodes  addObject:[SKSpriteNode spriteNodeWithImageNamed:kSIAssestMenuToolbarHelp]];
    [toolTags   addObject:kSINodeButtonInstructions];
    
    [toolNodes  addObject:[SKSpriteNode spriteNodeWithImageNamed:kSIAssestMenuToolbarLeaderboard]];
    [toolTags   addObject:kSINodeButtonLeaderboard];
    
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
    menuNode.itemAnimationDuration                 = SCENE_TRANSITION_DURATION_FAST;
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

+ (SIPopupNode *)SIPopupSceneGameGameOverSize:(CGSize)size {
    SKLabelNode *titleLabel                 = [SIGameController SILabelSceneGamePopupTitle];
    titleLabel.text                         = NSLocalizedString(kSITextPopupContinueGameOver, nil);
    
    SIPopupNode *popupNode                  = [[SIPopupNode alloc] initWithSceneSize:size];
    
    popupNode.backgroundSize                = CGSizeMake(size.width - [SIGameController xPaddingPopupContinue], size.height - [SIGameController yPaddingPopupContinue]);
    popupNode.backgroundColor               = [UIColor SIColorPrimary];
    popupNode.titleContentNode              = titleLabel;
    popupNode.cornerRadius                  = 8.0f;
    popupNode.userInteractionEnabled        = YES;
    popupNode.dismissButtonVisible          = NO;
    popupNode.position                      = [SIGameController SIPopupSceneGamePositionPoint];
    
    
    return popupNode;
}

+ (SIPopupNode *)SIPopupSceneMenuFreePrize {
//    SIPopupNode *popupNode                  = [[SIPopupNode alloc] initWithSceneSize:[SIGameController sceneSize]];
//    popupNode.backgroundSize                = CGSizeMake([SIGameController sceneSize].width - [SIGameController xPaddingPopupContinue], [SIGameController sceneSize].width - [SIGameController xPaddingPopupContinue]);
//    popupNode.titleContentNode              = [SIGameController SISpriteNodeFreeDailyPrize];//[SIIAPUtility createTitleNode:CGSizeMake(popupNode.backgroundSize.width - VERTICAL_SPACING_16, (popupNode.backgroundSize.height / 2.0f) - ([SIGameController SIChestSize].height / 2.0f))];
//    popupNode.backgroundColor               = [SKColor SIColorPrimary];
//    popupNode.cornerRadius                  = 8.0f;
//    popupNode.userInteractionEnabled        = NO;
//    popupNode.dismissButtonVisible          = YES;
//    return popupNode;

    
    SIPopupNode *popupNode = [[SIPopupNode alloc] initWithSceneSize:[SIGameController sceneSize]
                                                      popUpSize:CGSizeMake([SIGameController sceneSize].width - [SIGameController xPaddingPopupContinue], [SIGameController sceneSize].width - [SIGameController xPaddingPopupContinue])
                                                          title:@"Daily Free Prize"
                                                     titleFontColor:[UIColor whiteColor]
                                                  titleFontSize:10
                                                  titleYPadding:8.0
                                                backgroundColor:[SKColor SIColorPrimary]
                                                   cornerRadius:8.0f
                                                    borderWidth:0.0f
                                                    borderColor:[UIColor blackColor]];
    popupNode.backgroundColor                   = [SKColor SIColorPrimary];
    popupNode.titleContentNode                  = [SIGameController SISpriteNodeFreeDailyPrize]; //[SIIAPUtility createTitleNode:CGSizeMake(popupNode.backgroundSize.width - VERTICAL_SPACING_16, (popupNode.backgroundSize.height / 2.0f) - ([SIGameController SIChestSize].height / 2.0f))];
    popupNode.dismissButtonVisible          = YES;
    

    return popupNode;
   
}

+ (SIPopupContentNode *)SIPopupContentSceneMenuFreePrizeSize:(CGSize)size {
    SIPopupContentNode *centerNode        = [[SIPopupContentNode alloc] initWithSize:size];
    centerNode.labelNode                  = [SIGameController SILabelHeader_x3:@""];
    centerNode.backgroundImageNode        = [SKSpriteNode spriteNodeWithImageNamed:kSIAssestIAPChest];
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
    multilineNode.fontSize                  = [SIGameController SIFontSizeText_x3];
    multilineNode.text                      = NSLocalizedString(kSITextMenuHelpText, nil);
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
        gesture.cancelsTouchesInView = YES;
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
        
        
        SKLabelNode *oneHandModeOn1                                         = [SIGameController SILabelButtonWithText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(kSITextMenuStartScreenGameModeConst, nil), NSLocalizedString(kSITextMenuStartScreenGameModeShake, nil)]];
        SKLabelNode *oneHandModeOn2                                         = [SIGameController SILabelButtonWithText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(kSITextMenuStartScreenGameModeConst, nil), NSLocalizedString(kSITextMenuStartScreenGameModeShake, nil)]];
        SKLabelNode *oneHandModeOff1                                        = [SIGameController SILabelButtonWithText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(kSITextMenuStartScreenGameModeConst, nil), NSLocalizedString(kSITextMenuStartScreenGameModePinch, nil)]];
        SKLabelNode *oneHandModeOff2                                        = [SIGameController SILabelButtonWithText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(kSITextMenuStartScreenGameModeConst, nil), NSLocalizedString(kSITextMenuStartScreenGameModePinch, nil)]];

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

#pragma mark NSUserDefault
/**
 This safely checks for a user default that has a BOOL
 */
+ (BOOL)SIBoolFromNSUserDefaults:(NSUserDefaults *)defaults forKey:(NSString *)key {
    NSNumber *entry = [defaults objectForKey:key];
    
    if (entry == nil) { //never ben set
        entry = [NSNumber numberWithBool:NO];
        [defaults setObject:entry forKey:key];
        [defaults synchronize];
    }
    return [entry boolValue];
}

#pragma mark SIPopTip
+ (SIPopTip *)SIPopTipSize:(CGSize)size {
    static SIPopTip *popTip = nil;
    if (!popTip) {
        popTip = [[SIPopTip alloc] initWithSize:size withMessage:@"Swype It!"];
    }
    return popTip;
}

#pragma mark -
#pragma mark - IAP Stuff
- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerAdShow) name:kSINotificationAdBannerShow object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerAdHide) name:kSINotificationAdBannerHide object:nil];
    
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
    move.moveCommand = SIMoveCommandSwype;
}
@end
