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
#import "SIAchievementSingleton.h"
#import "SIGameSingleton.h"
#import "SILoadingScene.h"
#import "SIPowerUpToolbarNode.h"
#import "SIGameController.h"
#import "SITestScene.h"
#import "SIMenuScene.h"
// Scene Import
#import "EndGameScene.h"
#import "SIGameScene.h"
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

@interface SIGameController () <ADBannerViewDelegate, ADInterstitialAdDelegate, GKGameCenterControllerDelegate, SIGameSingletonDelegate, SIGameSceneDelegate, SIAchievementSingletonDelegate>

@property (strong, nonatomic) UIButton          *closeButton;
@end

@implementation SIGameController {
    __weak SKScene      *_currentScene;
    
    ADBannerView        *_adBannerView;
    
    ADInterstitialAd    *_interstitialAd;
    
    BMGlyphFont         *_moveScoreBMGlyphFont;
    
    BOOL                 _interstitialAdPresentationIsLive;
    /**
     Set this true if you want a ton of print statements
     */
    BOOL                 _verbose;

    CGFloat              _screenHeight;
    
    CGSize               _sceneSize;
    
    int                  _numberOfAdsToWatch;
    
    EndGameScene        *_sceneEndGame;
    /**
     0.0 to 1.0 for the amount of the scene that is loaded
     */
    float                _percentLoaded;
    
    HLMenuNode          *_sceneGamePopupContinueMenuNode;
    
    HLRingNode          *_sceneGameRingNodePause;
    
    HLToolbarNode       *_sceneGameToolbarPowerUp;
    HLToolbarNode       *_sceneMenuToolbarBottom;
    
    MBProgressHUD       *_hud;
    
    SIGameScene         *_sceneGame;
    
    SILoadingScene      *_sceneLoading;
    
    SIPopupNode         *_sceneGamePopupContinue;
    
    SKTexture           *_monkeyFaceTexture;
    
    SKScene             *_loadingScene;
    
    UIView              *_placeHolderView;
    

    
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
- (BMGlyphLabel *)moveScoreLabel:(float)score {
    return [BMGlyphLabel labelWithText:[NSString stringWithFormat:@"%0.2f",score] font:_moveScoreBMGlyphFont];
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



#pragma mark - UI Life Cycle Methods
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.restorationIdentifier = @"FLViewController";
        
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
    
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    _adBannerView.delegate  = nil;
    [_adBannerView removeFromSuperview];
    
    [super viewWillDisappear:animated];
}



-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}
- (void)mainInitializationMethod {
    NSDate *startDate = [NSDate date];
    /*Init The Loading Scene First and Fire It Up There!*/
    _sceneLoading = [SIGameController mainLoadSceneSILoadingSize:_sceneSize];
    [self transisitionToSKScene:_sceneLoading duration:SCENE_TRANSISTION_DURATION];
    
    /*Load the scenes*/
    [self loadAllScenes];


    /*Load any pop ups and such remaining*/
    if (_verbose) {
        NSLog(@"All data initialized in %0.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
    }

}

+ (SILoadingScene *)mainLoadSceneSILoadingSize:(CGSize)size {

    SILoadingScene *loadingScene = [[SILoadingScene alloc] initWithSize:size];
    
    [loadingScene sceneLoadingWillLoadProgressPercent:0.0f];
    
    return loadingScene;
}
- (void)loadAllScenes {
    
    /*Start loading Menu Scene*/
    
    /*Load the game sceen*/
    
    /*Load the falling monkey sceen*/
    _sceneGame = [self loadGameScene];
    
    
}

- (SIMenuScene *)loadMenuScene{
    NSDate *startDate = [NSDate date];

    SIMenuScene *menuScene = [[SIMenuScene alloc] initWithSize:_sceneSize];
    
    menuScene.toolBarBottom = [self sceneMenuToolbarNode:[SIGameController SIToolbarSceneMenuSize:_sceneSize]];
    
    if (_verbose) {
        NSLog(@"SIMenuScene Initialized: loaded in %0.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
    }

    return menuScene;
}

- (HLToolbarNode *)sceneMenuToolbarNode:(CGSize)size {
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

- (SIGameScene *)loadGameScene {
    NSDate *startDate = [NSDate date];
    
    [SIGameSingleton singleton];
    
    SIGameScene *sceneGame          = [[SIGameScene alloc] initWithSize:_sceneSize];
    
    sceneGame.sceneDelegate         = self;
    
    _sceneGamePopupContinue         = [SIGameController SIPopupSceneGameContinue];
    
    _sceneGamePopupContinueMenuNode = [SIGameController SIMenuNodeSceneGamePopup:_sceneGamePopupContinue];
    
    _sceneGameRingNodePause         = [SIGameController SIRingNodeSceneGamePause];
    
    NSLog(@"SIGameScene Initialized: loaded in %0.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
    
    return sceneGame;
}

- (BOOL)verifySceneGame {
    if (_sceneGame == nil) {
        _sceneGame = [[SIGameScene alloc] initWithSize:_sceneSize];
    }
    if (_sceneGamePopupContinue == nil) {
        _sceneGamePopupContinue = [SIGameController SIPopupSceneGameContinue];
    }
    if (_sceneGamePopupContinueMenuNode == nil) {
        _sceneGamePopupContinueMenuNode = [SIGameController SIMenuNodeSceneGamePopup:_sceneGamePopupContinue];
    }
    return YES;
}


- (void)setupUserInterface {
    [self createConstants];
    [self createControls];
    [self setupControls];
    [self layoutControls];
}
- (void)createConstants {
    _moveScoreBMGlyphFont               = [BMGlyphFont fontWithName:kSIFontUltraStroked];

    _sceneSize                          = self.view.frame.size;
    _interstitialAdPresentationIsLive   = NO;
    _screenHeight                       = [UIScreen mainScreen].bounds.size.height;
    _monkeyFaceTexture                  = [[SIConstants buttonAtlas] textureNamed:kSIImageFallingMonkeys];

}
- (void)createControls {
    
    _adBannerView               = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
}
- (void)setupControls {
    CGFloat bannerViewHeight    = _adBannerView.bounds.size.height;
    _adBannerView.delegate      = self;
    _adBannerView.frame         = CGRectMake(0.0f, _screenHeight + bannerViewHeight, 0.0f, 0.0f);
    _adBannerView.hidden        = YES;
    _adBannerView.alpha         = 0.0f;
    
    /*Start Sounds*/
    [SoundManager sharedManager].allowsBackgroundMusic  = YES;
    [SoundManager sharedManager].soundFadeDuration      = 1.0f;
    [SoundManager sharedManager].musicFadeDuration      = 2.0f;
    [[SoundManager sharedManager] prepareToPlayWithSound:[Sound soundNamed:kSISoundFXInitalize]];
    
    /*Give those interstitial ads a cycle to get em going*/
    [self interstitialAdCycle];
    
    
    [self configureBannerAds];
    
    [self authenticateLocalPlayer];

}
- (void)layoutControls {
    [self.view addSubview:_adBannerView];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

#pragma mark - HUD Methods
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
    _hud                                    = hud;
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
- (void)menuDidLoad {

}
+ (HLLabelButtonNode *)SIMenuButtonPrototypeBasic:(CGSize)size {
    HLLabelButtonNode *buttonPrototype;
    buttonPrototype                         = [[SIGameController SIHLInterfaceLabelButton:size] copy];
    buttonPrototype.verticalAlignmentMode   = HLLabelNodeVerticalAlignFontAscenderBias;
    
    return buttonPrototype;
}
+ (HLLabelButtonNode *)SIMenuButtonPrototypeBasic:(CGSize)size backgroundColor:(SKColor *)backgroundColor fontColor:(UIColor *)fontColor {
    HLLabelButtonNode *buttonPrototype;
    buttonPrototype                         = [[SIGameController SIHLInterfaceLabelButton:size backgroundColor:fontColor fontColor:fontColor] copy];
    buttonPrototype.verticalAlignmentMode   = HLLabelNodeVerticalAlignFontAscenderBias;
    
    return buttonPrototype;
}
+ (HLLabelButtonNode *)SIMenuButtonPrototypeBack:(CGSize)size {
    HLLabelButtonNode *buttonPrototype;
    buttonPrototype                         =  [[SIGameController SIHLInterfaceLabelButton:size] copy];;
    buttonPrototype.color                   = [UIColor blueColor];
    buttonPrototype.colorBlendFactor        = 1.0f;

    return buttonPrototype;
}
+ (HLLabelButtonNode *)SIMenuButtonPrototypePopUp:(CGSize)size {
    HLLabelButtonNode *buttonPrototype;
    buttonPrototype                         = [[SIGameController SIHLInterfaceLabelButton:size] copy];
    buttonPrototype.verticalAlignmentMode   = HLLabelNodeVerticalAlignFontAscenderBias;
    buttonPrototype.color                   = [UIColor whiteColor];
    buttonPrototype.fontColor               = [SKColor blackColor];
    buttonPrototype.colorBlendFactor        = 1.0f;

    return buttonPrototype;
}
+ (HLLabelButtonNode *)SIHLInterfaceLabelButton:(CGSize)size {
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
+ (HLLabelButtonNode *)SIHLInterfaceLabelButton:(CGSize)size backgroundColor:(UIColor *)backgroundColor fontColor:(SKColor *)fontColor {
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
+ (SIPopupNode *)SIPopUpNodeTitle:(NSString *)title SceneSize:(CGSize)sceneSize {
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

#pragma mark - Public Properties
+ (SKTexture *)SIMonkeyFaceTexture {
    static SKTexture *monkeyFace = nil;
    if (!monkeyFace) {
        monkeyFace = monkeyFaceTexture();
    }
    return monkeyFace;
}
+ (SKSpriteNode *)SIFallingMonkeyNode {
    static SKSpriteNode *monkey = nil;
    if (!monkey) {
        monkey                                      = [SKSpriteNode spriteNodeWithTexture:[SIGameController SIMonkeyFaceTexture]  size:[SIGameController SIFallingMonkeySize]];
        monkey.name                                 = kSINodeFallingMonkey;
        monkey.physicsBody                          = [SKPhysicsBody bodyWithCircleOfRadius:[SIGameController SIFallingMonkeySize].height / 2.0f];
        monkey.physicsBody.linearDamping            = 0.0f;
        monkey.userInteractionEnabled               = YES;
    }
    return monkey;
}

+ (SKLabelNode *)SILabelSceneGameMoveCommand {
    static SKLabelNode *moveLabel = nil;
    if (!moveLabel) {
        moveLabel = moveCommandLabelNode();
    }
    return moveLabel;
}
+ (HLRingNode *)SIRingNodeSceneGamePause {
    static HLRingNode *ringNode = nil;
    if (!ringNode) {
        ringNode = sceneGamePauseRingNode();
    }
    return ringNode;
}


+ (SIPopupNode *)SIPopupSceneGameContinue {
    
    DSMultilineLabelNode *titleNode                 = [DSMultilineLabelNode labelNodeWithFontNamed:kSIFontUltra];
    titleNode.fontColor                         = [SKColor whiteColor];
    titleNode.fontSize              = [SIGameController SIFontSizePopUp];
    
    
    SIPopupNode *popupNode          = [[SIPopupNode alloc] initWithSceneSize:[SIGameController sceneSize]];
    popupNode.titleContentNode      = titleNode;
    popupNode.backgroundSize        = CGSizeMake([SIGameController sceneSize].width - [SIGameController xPaddingPopupContinue], [SIGameController sceneSize].width - [SIGameController xPaddingPopupContinue]);
    popupNode.backgroundColor       = [SKColor mainColor];
    popupNode.cornerRadius                  = 8.0f;
    popupNode.userInteractionEnabled               = YES;
    
    return popupNode;
}
+ (HLMenuNode *)SIMenuNodeSceneGamePopup:(SIPopupNode *)popupNode {
    HLMenuNode *menuNode                = [[HLMenuNode alloc] init];
    menuNode.itemAnimation              = HLMenuNodeAnimationSlideLeft;
    menuNode.itemAnimationDuration      = 0.25;
    menuNode.itemButtonPrototype        = [SIGameController SIMenuButtonPrototypePopUp:[SIGameController SIButtonSize:popupNode.backgroundSize]];
    menuNode.backItemButtonPrototype    = [SIGameController SIMenuButtonPrototypeBack:[SIGameController SIButtonSize:popupNode.backgroundSize]];
    menuNode.itemSeparatorSize          = 20;
    
    HLMenu *menu                        = [[HLMenu alloc] init];

    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextPopUpBuyCoins]];

    
    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextPopUpWatchAd]];
    
    /*Add the Back Button... Need to change the prototype*/
    HLMenuItem *endGameItem             = [HLMenuItem menuItemWithText:kSIMenuTextPopUpEndGame];
    endGameItem.buttonPrototype         = [SIGameController SIMenuButtonPrototypeBack:[SIGameController SIButtonSize:popupNode.backgroundSize]];
    [menu addItem:endGameItem];
    
    [menuNode setMenu:menu animation:HLMenuNodeAnimationNone];
    
    menuNode.position                   = CGPointMake(0.0f, 0.0f);
    
    if (popupNode) {
        popupNode.popupContentNode      = menuNode;
    }
    
    return menuNode;
}
/**The free coin progress bar found in the game scene*/
+ (TCProgressBarNode *)SISceneGameProgressBarFreeCoinSceneSize:(CGSize)size {
    CGSize progressBarSize = CGSizeMake(size.width / 2.0f, (size.width / 2.0f) * 0.2);
    TCProgressBarNode *progressBar = [[TCProgressBarNode alloc]
                                      initWithSize:progressBarSize
                                      backgroundColor:[UIColor lightGrayColor]
                                      fillColor:[UIColor goldColor]
                                      borderColor:[UIColor blackColor]
                                      borderWidth:2.0f
                                      cornerRadius:4.0f];
    return progressBar;
}
/**Move Progress Bar Sprite*/
+ (TCProgressBarNode *)SISceneGameProgressBarMoveSceneSize:(CGSize)size {
    CGSize progressBarSize                = CGSizeMake(size.width / 1.5f, (size.width / 2.0f) * 0.3);
    TCProgressBarNode *progressBar = [[TCProgressBarNode alloc]
                                      initWithSize:progressBarSize
                                      backgroundColor:[UIColor grayColor]
                                      fillColor:[UIColor redColor]
                                      borderColor:[UIColor blackColor]
                                      borderWidth:1.0f
                                      cornerRadius:4.0f];
    return progressBar;
}

/**Power Up Progress Bar Sprite*/
+ (TCProgressBarNode *)SISceneGameProgressBarPowerUpSceneSize:(CGSize)size {
    CGSize progressBarSize             = CGSizeMake(size.width - VERTICAL_SPACING_16, (size.width / 2.0f) * 0.3);
    TCProgressBarNode *progressBar = [[TCProgressBarNode alloc]
                                      initWithSize:progressBarSize
                                      backgroundColor:[UIColor grayColor]
                                      fillColor:[UIColor greenColor]
                                      borderColor:[UIColor blackColor]
                                      borderWidth:1.0f
                                      cornerRadius:4.0f];
    return progressBar;
}

#pragma mark - iAd Methods
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
}
-(BOOL)premiumUser {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSINSUserDefaultPremiumUser];
}
- (void)configureBannerAds {
    BOOL isPremiumUser = [self premiumUser];
    
    if (_verbose) {
        NSLog(@"User is premium: %@",isPremiumUser ? @"YES" : @"NO");
    }
    
    /*Need to create on first run*/
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultPremiumUser] == nil) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kSINSUserDefaultPremiumUser];
        [[NSUserDefaults standardUserDefaults] synchronize];
        isPremiumUser = NO;
    }

    
    if (!isPremiumUser) {
        self.canDisplayBannerAds    = NO;
        _adBannerView.delegate  = self;
        _adBannerView.hidden    = YES; /*hide till loaded!*/
    } else {
        self.canDisplayBannerAds    = NO;
    }
}
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
            [[SIGameSingleton singleton] singletonGameWillResumeAndContinue:YES];
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
#pragma mark ADInterstitialViewDelegate methods

// When this method is invoked, the application should remove the view from the screen and tear it down.
// The content will be unloaded shortly after this method is called and no new content will be loaded in that view.
// This may occur either when the user dismisses the interstitial view via the dismiss button or
// if the content in the view has expired.
- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd
{
    if (_placeHolderView) {
        [self interstitialAdClose];
    }
}

// This method will be invoked when an error has occurred attempting to get advertisement content.
// The ADError enum lists the possible error codes.
- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    NSLog(@"Error [interstitialAd] (CODE: %d) : %@",(int)error.code,error.localizedDescription);
    if (error.code != ADErrorServerFailure && error.code != 7) {
        [self interstitialAdClose];
    }
    
}

//- (void)launchPopupForContinue:(NSNotification *)notification {
//    NSDictionary *userInfo = notification.userInfo;
//    NSNumber *canAfford = [userInfo objectForKey:kSINSDictionaryKeyCanAfford];
//    NSNumber *cost      = [userInfo objectForKey:kSINSDictionaryKeyCanAffordCost];
//    
//    MSSAlertViewController *alert = [MSSAlertViewController alertWithAttributedTitle: [[NSAttributedString alloc] initWithString:@"Continue!"
//                                                                                                                       attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
//                                                                                                                                    NSFontAttributeName:[UIFont fontWithName:kSIFontFuturaMedium size:[SIGameController SIFontSizeText_x2]]}]
//                                                                   attributedMessage:[[NSAttributedString alloc] initWithString:@"Pick an option to continue where you left off!"
//                                                                                                                     attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
//                                                                                                                                  NSFontAttributeName:[UIFont fontWithName:kSIFontFuturaMedium size:[SIGameController SIFontSizeText]]}]];
//    
//    
//    if ([canAfford boolValue]) {
//        [alert addButtonWithAttributedTitle:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ IT Coins",cost]
//                                                                            attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
//                                                                                         NSFontAttributeName:[UIFont fontWithName:kSIFontFuturaMedium size:[SIGameController SIFontSizeText]]}]
//                                 tapHandler:^{
//                                     NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationGameContinueUseCoins object:nil userInfo:nil];
//                                     [[NSNotificationCenter defaultCenter] postNotification:notification];
//                                 }];
//
//        
//    } else {
//        [alert addButtonWithAttributedTitle:[[NSAttributedString alloc] initWithString:@"Buy More Coins"
//                                                                            attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
//                                                                                         NSFontAttributeName:[UIFont fontWithName:kSIFontFuturaMedium size:[SIGameController SIFontSizeText]]}]
//                                 tapHandler:^{
//                                     NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationGameContinueUseLaunchStore object:nil userInfo:nil];
//                                     [[NSNotificationCenter defaultCenter] postNotification:notification];
//                                 }];
//    }
//    
//    
//    [alert addButtonWithAttributedTitle:[[NSAttributedString alloc] initWithString:@"Watch Ad"
//                                                                        attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
//                                                                                     NSFontAttributeName:[UIFont fontWithName:kSIFontFuturaMedium size:[SIGameController SIFontSizeText]]}]
//                             tapHandler:^{
//                                 [self presentInterstital];
//                             }];
//
//
//    [alert addButtonWithAttributedTitle:[[NSAttributedString alloc] initWithString:@"Cancel"
//                                                                        attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
//                                                                                     NSFontAttributeName:[UIFont fontWithName:kSIFontFuturaMedium size:[SIGameController SIFontSizeText]]}]
//                             tapHandler:^{
//                                 NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationGameContinueUseCancel object:nil userInfo:nil];
//                                 [[NSNotificationCenter defaultCenter] postNotification:notification];
//                             }];
//    
//    [self presentViewController:alert animated:YES completion:nil];
//}
#pragma mark - ADBannerViewDelegate
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
    _adBannerView.frame                 = CGRectMake(0.0f, _screenHeight - bv, 0.0f, 0.0f);
    [UIView commitAnimations];
}

- (void)bannerAdHide {
    _adBannerView.hidden                = YES;
    CGFloat bv                          = _adBannerView.bounds.size.height;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSINotificationAdBannerDidUnload object:nil];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    _adBannerView.frame = CGRectMake(0.0f, _screenHeight + bv, 0.0f, 0.0f);
    [UIView commitAnimations];
}
+ (CGFloat)SIAdBannerViewHeight {
    if ([SIGameController isPremiumUser]) {
        return 0.0f;
    }
    ADBannerView *tempAdBannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    return tempAdBannerView.bounds.size.height;
}
+ (BOOL)isPremiumUser {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSINSUserDefaultPremiumUser];
}
+ (CGSize)sceneSize {
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - [SIGameController SIAdBannerViewHeight]);
}


#pragma mark - Game Center Methods
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
#pragma mark - Daily Prize Methods
+ (NSDate *)getDateFromInternet {
    NSDate *currentDate = nil;
    
    if ([FXReachability isReachable]) {
        NSURL * scriptUrl = [NSURL URLWithString: @"http://s132342840.onlinehome.us/swypeIt/date.php"];
        NSData * data = [NSData dataWithContentsOfURL: scriptUrl];
        
        if (data) {
            NSString * tempString = [NSString stringWithUTF8String: [data bytes]];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *currentDate = [df dateFromString:tempString];
//            NSDate * currDate = [NSDate dateWithTimeIntervalSince1970: [tempString doubleValue]];
//            NSLog (@ "String returned from the site is:%@ and date is:%@", tempString, [currDate description]);
            return currentDate;
        } else {
            NSLog(@"Could not resolve webpage....");
        }
    } else {
        NSLog(@"Not connected to internet");
    }
    
    return currentDate;
}
#pragma mark - SIGameSceneDelegate Functions
- (void)sceneGameDidRecieveRingNode:(HLRingNode *)ringNode Tap:(SISceneGameRingNode)gameSceneRingNode {
    switch (gameSceneRingNode) {
        case SISceneGameRingNodeEndGame:
            [[SIGameSingleton singleton] singletonGameDidEnd];
            break;
        case SISceneGameRingNodePlay:
            [[SIGameSingleton singleton] singletonGameWillResumeAndContinue:NO];
            break;
        case SISceneGameRingNodeSoundBackground:
            if ([SIConstants isBackgroundSoundAllowed]) {
                /*Turn Background Sound Off*/
                [[SoundManager sharedManager] stopMusic];
            } else {
                /*Turn Sound Background On*/
                [[SoundManager sharedManager] playMusic:kSISoundBackgroundMenu looping:YES fadeIn:YES];
            }
            [ringNode setHighlight:[SIConstants isBackgroundSoundAllowed] forItem:(int)gameSceneRingNode];
            [[NSUserDefaults standardUserDefaults] setBool:![SIConstants isBackgroundSoundAllowed] forKey:kSINSUserDefaultSoundIsAllowedBackground];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        case SISceneGameRingNodeSoundFX:
            /*Change Sound FX State*/
            if ([SIConstants isFXAllowed]) {
                /*Turn FX Sound Off*/
                [[SoundManager sharedManager] stopAllSounds];
            }
            [ringNode setHighlight:[SIConstants isFXAllowed] forItem:(int)gameSceneRingNode];
            [[NSUserDefaults standardUserDefaults] setBool:![SIConstants isFXAllowed] forKey:kSINSUserDefaultSoundIsAllowedFX];
            [[NSUserDefaults standardUserDefaults] synchronize];
            break;
        default:
            NSLog(@"Ring Node item tapped out of bounds index error :/");
            break;
    }
}
/**
 Called when the scene recognizes a gesture
 Pinch, Tap, Swype of Shake
 */
- (void)sceneGameDidRecieveMove:(SIMove *)move {
    [[SIGameSingleton singleton] singletonGameDidEnterMove:move];
}

- (void)sceneGamePauseButtonTapped {
    [[SIGameSingleton singleton] singletonGameWillPause];
    [_sceneGame sceneBlurDisplayRingNode:_sceneGameRingNodePause];
}
- (void)sceneGameWillDismissPopupContinueWithPayMethod:(SISceneGamePopupContinueMenuItem)continuePayMethod {
    switch (continuePayMethod) {
        case SISceneGamePopupContinueMenuItemCoin:
            if ([SIIAPUtility canAffordContinue:[SIGameSingleton singleton].currentGame.currentContinueLifeCost]) {
                [[MKStoreKit sharedKit] consumeCredits:[NSNumber numberWithInt:[SIGameSingleton singleton].currentGame.currentContinueLifeCost] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
            } else {
                [[SIGameSingleton singleton] singletonGameWillResumeAndContinue:YES];
            }
            break;
        case SISceneGamePopupContinueMenuItemAd:
            _interstitialAdPresentationIsLive = YES;
            [self interstitialAdPresent];
            break;
        default: //SIPowerUpPayMethodNo
            [[SIGameSingleton singleton] singletonGameDidEnd];
            break;
    }


}
#pragma mark - SIGameSingletonDelegate


/**
 Called when the model is ready for a new move to be
 loaded by the controller to the view
 */
- (void)controllerSingletonGameLoadNewMove {
    BMGlyphLabel *moveLabel = [self moveScoreLabel:[SIGameSingleton singleton].currentGame.moveScore];
    moveLabel.position = [SIGameSingleton singleton].currentGame.currentMove.touchPoint;
    
    
    [_sceneGame updateSceneWithBackgroundColor:[SIGameSingleton singleton].currentGame.currentBackgroundColor
                                    totalScore:[SIGameSingleton singleton].currentGame.totalScore
                                          move:[SIGameSingleton singleton].currentGame.currentMove
                                moveScoreLabel:moveLabel
                    freeCoinProgressBarPercent:[SIGameSingleton singleton].currentGame.moveScorePercentRemaining
                             moveCommandString:[SIGame stringForMove:[SIGameSingleton singleton].currentGame.currentMove.moveCommand]];

}

/**
 Called when the user should be prompted to continue
 the game
 */
- (void)controllerSingletonGameShowContinue {
    [self verifySceneGame];
    
    if ([SIIAPUtility canAffordContinue:[SIGameSingleton singleton].currentGame.currentContinueLifeCost]) {
        [[[_sceneGamePopupContinueMenuNode menu] itemAtIndex:SISceneGamePopupContinueMenuItemCoin] setText:[NSString stringWithFormat:@"Use %ld Coins!",(long)[SIGameSingleton singleton].currentGame.currentContinueLifeCost]];
    }
    
    [[[_sceneGamePopupContinueMenuNode menu] itemAtIndex:SISceneGamePopupContinueMenuItemAd] setText:[NSString stringWithFormat:@"Watch %d Ads!",(int)[SIGameSingleton singleton].currentGame.currentNumberOfTimesContinued]];
    
    [_sceneGamePopupContinueMenuNode redisplayMenuAnimation:HLMenuNodeAnimationNone];
    
    [_sceneGame sceneModallyPresentPopup:_sceneGamePopupContinue withMenuNode:_sceneGamePopupContinueMenuNode];

}

/**
 Called when there is a high score
 */
- (void)controllerSingletonGameShowIsHighScore {
    [_sceneGame sceneWillShowHighScore];
}

/**
 Called when a free coin is earned
 Handle the sound for this in the controller?
 */
- (void)controllerSingletonGameShowFreeCoinEarned {
    [_sceneGame sceneWillShowFreeCoinEarned];
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
            [[SIGameSingleton singleton] singletonGameWillPause];
            /*launch the other scene with no delay*/
            
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
            [[SIGameSingleton singleton] singletonGameWillResumeAndContinue:YES];
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

#pragma mark - SIAchievementSingleton
/**
 Called when challenge was complete
 */
- (void)controllerSingletonAchievementDidCompleteAchievement:(SIAchievement *)achievement {
    [JCNotificationCenter enqueueNotificationWithTitle:@"Achievement Completed" message:achievement.title tapHandler:^{
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

#pragma mark - SIGameSceneDelegate
/**
 Called when the scene recognizes a gesture
 Pinch, Tap, Swype of Shake
 */
- (void)controllerSceneGameDidRecieveMove:(SIMove *)move {
    [[SIGameSingleton singleton] singletonGameDidEnterMove:move];
}

/**
 Fires when the pause button is pressed
 */
- (void)controllerSceneGamePauseButtonTapped {
    [[SIGameSingleton singleton] singletonGameWillPause];
}

/**
 Fires after the continue meny node has been pressed...
 If coins -> PayMethod - Coin
 If ads   -> PayMethod - Ads
 If no    -> PayMethod - User is not going to pay for this shit...
 */
- (void)controllerSceneGameWillDismissPopupContinueWithPayMethod:(SISceneGamePopupContinueMenuItem)continuePayMethod {
    
}

/**
 Called when the ring node is tapped and the result
 needs to be sent to the controller
 */
- (void)controllerSceneGameDidRecieveRingNode:(HLRingNode *)ringNode tap:(SISceneGameRingNode)gameSceneRingNode {
    
}

/**
 Powerup tool bar was tapped
 */
- (void)controllerSceneGameToolbar:(HLToolbarNode *)toolbar powerUpWasTapped:(SIPowerUpType)powerUp {
    
}

/**
 This is called on every update... So it gets called a ton!
 */
- (SISceneGameProgressBarUpdate *)controllerSceneGameWillUpdateProgressBars {
    SISceneGameProgressBarUpdate *progressBarUpdate = [[SISceneGameProgressBarUpdate alloc] init];
    
    progressBarUpdate.percentMove                   = [SIGameSingleton singleton].currentGame.moveScorePercentRemaining;
    progressBarUpdate.percentPowerUp                = [SIGameSingleton singleton].currentGame.powerUpPercentRemaining;
    progressBarUpdate.pointsMove                    = [SIGameSingleton singleton].currentGame.currentPointsRemainingThisRound;
    
    return progressBarUpdate;
}



#pragma mark - Transistion Methods
- (void)transisitionToSKScene:(SKScene *)scene duration:(CGFloat)duration {
    SKTransition *transistion;
    
    transistion = [SKTransition fadeWithColor:[SKColor blackColor] duration:duration];
    
    SKView *skView = (SKView *)self.view;
    
    [skView presentScene:scene transition:transistion];
}

+ (void)transisitionToSKScene:(SKScene *)scene toSKView:(SKView *)view DoorsOpen:(BOOL)doorsOpen pausesIncomingScene:(BOOL)pausesIncomingScene pausesOutgoingScene:(BOOL)pausesOutgoingScene duration:(CGFloat)duration {
    SKTransition *transistion;
    
    if (doorsOpen) {
        transistion = [SKTransition doorsOpenHorizontalWithDuration:duration];
    } else {
        transistion = [SKTransition doorsCloseHorizontalWithDuration:duration];
    }
    
    transistion.pausesIncomingScene = pausesIncomingScene;
    transistion.pausesOutgoingScene = pausesOutgoingScene;
    
    [view presentScene:scene transition:transistion];
}

#pragma mark - Class Methods
- (void)showFPS:(BOOL)showFPS {
    SKView * skView         = (SKView *)self.view;
    skView.showsFPS         = showFPS;
    skView.showsNodeCount   = showFPS;
}

@end
