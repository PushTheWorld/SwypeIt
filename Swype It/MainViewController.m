//  MainViewController.m
//  Swype It
//
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: This is the main game view controller... has HUD
//
// Local Controller Import
#import "SIGameSingleton.h"
#import "SIPowerUpToolbarNode.h"
#import "EndGameScene.h"
#import "MainViewController.h"
#import "SITestScene.h"
// Scene Import
#import "EndGameScene.h"
#import "GameScene.h"
#import "SettingsScene.h"
#import "StartScreenScene.h"
#import "StoreScene.h"
// Framework Import
#import <GameKit/GameKit.h>
#import <iAd/iAd.h>
#import <Instabug/Instabug.h>
#import <MessageUI/MessageUI.h>
#import "MSSAlertViewController.h"
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "DSMultilineLabelNode.h"
#import "FXReachability.h"
#import "MBProgressHud.h"
#import "MKStoreKit.h"
#import "SoundManager.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "Game.h"
// Other Imports

@interface MainViewController () <ADBannerViewDelegate, ADInterstitialAdDelegate, GKGameCenterControllerDelegate, SIGameSingletonDelegate, GameSceneDelegate>

@property (strong, nonatomic) UIButton          *closeButton;
@end

@implementation MainViewController {
    __weak SKScene      *_currentScene;
    
    ADBannerView        *_adBannerView;
    
    ADInterstitialAd    *_interstitialAd;
    
    BOOL                 _interstitialAdPresentationIsLive;

    CGFloat              _screenHeight;
    
    int                  _numberOfAdsToWatch;
    
    EndGameScene        *_sceneEndGame;
    
    GameScene           *_sceneGame;
    
    HLMenuNode          *_sceneGamePopupContinueMenuNode;
    
    HLRingNode          *_sceneGameRingNodePause;
    
    HLToolbarNode       *_sceneGameToolbarPowerUp;
    
    MBProgressHUD       *_hud;
    
    SettingsScene       *_sceneSettings;
    
    SIPopupNode         *_sceneGamePopupContinue;
    
    SKTexture           *_monkeyFaceTexture;

    StartScreenScene    *_sceneStart;
    
    StoreScene          *_sceneStore;

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
+ (CGSize)SIFuttonSize:(CGSize)size {
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
    return [MainViewController SIFontSizeHeader] + 4.0f;
}
+ (CGFloat)SIFontSizeHeader_x3 {
    return [MainViewController SIFontSizeHeader] + 8.0f;
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
    return [MainViewController SIFontSizeParagraph] + 4.0f;
}
+ (CGFloat)SIFontSizeParagraph_x3 {
    return [MainViewController SIFontSizeParagraph] + 8.0f;
}
+ (CGFloat)SIFontSizeParagraph_x4 {
    return [MainViewController SIFontSizeParagraph] + 12.0f;
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
    return [MainViewController SIFontSizeText] + 2.0f;
}
+ (CGFloat)SIFontSizeText_x3 {
    return [MainViewController SIFontSizeText] + 4.0f;
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

#pragma mark - UI Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _interstitialAdPresentationIsLive = NO;
    
    /*Start Sounds*/
    [SoundManager sharedManager].allowsBackgroundMusic  = YES;
    [SoundManager sharedManager].soundFadeDuration      = 1.0f;
    [SoundManager sharedManager].musicFadeDuration      = 2.0f;
    [[SoundManager sharedManager] prepareToPlayWithSound:[Sound soundNamed:kSISoundFXInitalize]];
    
    [self registerForNotifications];
    
    [self interstitialAdCycle];
    
    [self setupUserInterface];
    
    // Configure the view.
    SKView * skView         = (SKView *)self.view;
    skView.showsFPS         = YES;
    skView.showsNodeCount   = YES;
    
    // Create and configure the scene.
//    SKScene * scene = [SITestScene sceneWithSize:skView.bounds.size];
    SKScene * scene = [StartScreenScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFit;
    
    // Present the scene.
    [skView presentScene:scene];

    // Show me those ads!
    [self configureBannerAds];
    
    [self authenticateLocalPlayer];
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self unregisterForNotifications];
    
    _adBannerView.delegate  = nil;
    [_adBannerView removeFromSuperview];
    
    [super viewWillDisappear:animated];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}
- (void)removeAds {
    BOOL isPremiumUser = [[NSUserDefaults standardUserDefaults] boolForKey:kSINSUserDefaultPremiumUser];
    if (isPremiumUser) {
        self.canDisplayBannerAds = NO;
        NSLog(@"Banner Ads Hidden.");
    }
}


- (void)setupUserInterface {
    [self createConstants];
    [self createControls];
    [self setupControls];
    [self layoutControls];
}
- (void)createConstants {
    _screenHeight               = [UIScreen mainScreen].bounds.size.height;
    _monkeyFaceTexture          = [[SIConstants buttonAtlas] textureNamed:kSIImageFallingMonkeys];

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
    
    
}
- (void)layoutControls {
    [self.view addSubview:_adBannerView];
}
- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudWillHide:)                 name:kSINotificationHudHide                     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudWillShow:)                 name:kSINotificationHudShow                     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchBugReport:)             name:kSINotificationSettingsLaunchBugReport     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidLoad)                  name:kSINotificationMenuLoaded                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentInterstital)           name:kSINotificationInterstitialAdShallLaunch   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchPopupForContinue:)      name:kSINotificationGameContinueUsePopup        object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAds)                    name:kSINotificationAdFreePurchasedSucceded     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGameCenterLeaderBoard)    name:kSINotificationShowLeaderBoard             object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerAdHide)                 name:kSINotificationAdBannerHide                object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerAdShow)                 name:kSINotificationAdBannerShow                object:nil];

}
- (void)unregisterForNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    buttonPrototype                         = [[MainViewController SIHLInterfaceLabelButton:size] copy];
    buttonPrototype.verticalAlignmentMode   = HLLabelNodeVerticalAlignFontAscenderBias;
    
    return buttonPrototype;
}
+ (HLLabelButtonNode *)SIMenuButtonPrototypeBasic:(CGSize)size backgroundColor:(SKColor *)backgroundColor fontColor:(UIColor *)fontColor {
    HLLabelButtonNode *buttonPrototype;
    buttonPrototype                         = [[MainViewController SIHLInterfaceLabelButton:size backgroundColor:fontColor fontColor:fontColor] copy];
    buttonPrototype.verticalAlignmentMode   = HLLabelNodeVerticalAlignFontAscenderBias;
    
    return buttonPrototype;
}
+ (HLLabelButtonNode *)SIMenuButtonPrototypeBack:(CGSize)size {
    HLLabelButtonNode *buttonPrototype;
    buttonPrototype                         =  [[MainViewController SIHLInterfaceLabelButton:size] copy];;
    buttonPrototype.color                   = [UIColor blueColor];
    buttonPrototype.colorBlendFactor        = 1.0f;

    return buttonPrototype;
}
+ (HLLabelButtonNode *)SIMenuButtonPrototypePopUp:(CGSize)size {
    HLLabelButtonNode *buttonPrototype;
    buttonPrototype                         = [[MainViewController SIHLInterfaceLabelButton:size] copy];
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
    SKLabelNode *label  = [MainViewController SILabelInterfaceFontSize:[MainViewController SIFontSizeHeader]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SILabelHeader_x2:(NSString *)text {
    SKLabelNode *label  = [MainViewController SILabelInterfaceFontSize:[MainViewController SIFontSizeHeader_x2]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SILabelHeader_x3:(NSString *)text {
    SKLabelNode *label  = [MainViewController SILabelInterfaceFontSize:[MainViewController SIFontSizeHeader_x3]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SILabelParagraph:(NSString *)text {
    SKLabelNode *label  = [MainViewController SILabelInterfaceFontSize:[MainViewController SIFontSizeParagraph]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SILabelParagraph_x2:(NSString *)text {
    SKLabelNode *label  = [MainViewController SILabelInterfaceFontSize:[MainViewController SIFontSizeParagraph_x2]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SILabelParagraph_x3:(NSString *)text {
    SKLabelNode *label  = [MainViewController SILabelInterfaceFontSize:[MainViewController SIFontSizeParagraph_x3]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SILabelParagraph_x4:(NSString *)text {
    SKLabelNode *label  = [MainViewController SILabelInterfaceFontSize:[MainViewController SIFontSizeParagraph_x4]];
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
    SKLabelNode *titleNode      = [MainViewController SILabelParagraph:title];
    titleNode.fontColor         = [SKColor whiteColor];
    titleNode.fontSize          = [MainViewController SIFontSizePopUp];
    
    SIPopupNode *popUpNode      = [[SIPopupNode alloc] initWithSceneSize:sceneSize];
    popUpNode.titleContentNode  = titleNode;
    popUpNode.backgroundSize    = CGSizeMake(sceneSize.width - 100.0f, sceneSize.height - 200.0f);
    popUpNode.backgroundColor   = [SKColor mainColor];
    popUpNode.cornerRadius      = 8.0f;

    return popUpNode;
}

#pragma mark - Public Properties
+ (SKTexture *)sharedMonkeyFace {
    static SKTexture *monkeyFace = nil;
    if (!monkeyFace) {
        monkeyFace = monkeyFaceTexture();
    }
    return monkeyFace;
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
- (HLScene *)loadGameScene {
    [SIGameSingleton singleton];
    
    HLScene *sceneGame              = [[GameScene alloc] initWithSize:self.view.frame.size];

    _sceneGamePopupContinue         = [MainViewController SIPopupSceneGameContinue];
    
    _sceneGamePopupContinueMenuNode = [MainViewController SIMenuNodeSceneGamePopup:_sceneGamePopupContinue];
    
    _sceneGameRingNodePause         = [MainViewController SIRingNodeSceneGamePause];
    
    return sceneGame;
}
+ (SIPopupNode *)SIPopupSceneGameContinue {
    
    DSMultilineLabelNode *titleNode                 = [DSMultilineLabelNode labelNodeWithFontNamed:kSIFontUltra];
    titleNode.fontColor                         = [SKColor whiteColor];
    titleNode.fontSize              = [MainViewController SIFontSizePopUp];
    
    
    SIPopupNode *popupNode          = [[SIPopupNode alloc] initWithSceneSize:[MainViewController sceneSize]];
    popupNode.titleContentNode      = titleNode;
    popupNode.backgroundSize        = CGSizeMake([MainViewController sceneSize].width - [MainViewController xPaddingPopupContinue], [MainViewController sceneSize].width - [MainViewController xPaddingPopupContinue]);
    popupNode.backgroundColor       = [SKColor mainColor];
    popupNode.cornerRadius                  = 8.0f;
    popupNode.userInteractionEnabled               = YES;
    
    return popupNode;
}
+ (HLMenuNode *)SIMenuNodeSceneGamePopup:(SIPopupNode *)popupNode {
    HLMenuNode *menuNode                = [[HLMenuNode alloc] init];
    menuNode.itemAnimation              = HLMenuNodeAnimationSlideLeft;
    menuNode.itemAnimationDuration      = 0.25;
    menuNode.itemButtonPrototype        = [MainViewController SIMenuButtonPrototypePopUp:[MainViewController buttonSize:popupNode.backgroundSize]];
    menuNode.backItemButtonPrototype    = [MainViewController SIMenuButtonPrototypeBack:[MainViewController buttonSize:popupNode.backgroundSize]];
    menuNode.itemSeparatorSize          = 20;
    
    HLMenu *menu                        = [[HLMenu alloc] init];

    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextPopUpBuyCoins]];

    
    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextPopUpWatchAd]];
    
    /*Add the Back Button... Need to change the prototype*/
    HLMenuItem *endGameItem             = [HLMenuItem menuItemWithText:kSIMenuTextPopUpEndGame];
    endGameItem.buttonPrototype         = [MainViewController SIMenuButtonPrototypeBack:[MainViewController buttonSize:popupNode.backgroundSize]];
    [menu addItem:endGameItem];
    
    [menuNode setMenu:menu animation:HLMenuNodeAnimationNone];
    
    menuNode.position                   = CGPointMake(0.0f, 0.0f);
    
    if (popupNode) {
        popupNode.popupContentNode      = menuNode;
    }
    
    return menuNode;
}

- (void)createPopup {
}
#pragma mark - MFMailComposeViewContorllerDelegate
- (void)launchBugReport:(NSNotification *)notification {
    [Instabug setEmailIsRequired:NO];
    [Instabug invokeFeedbackSender];
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    /*Code to call...*/
    //    if ([MFMailComposeViewController canSendMail]) {
    //        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    //        mail.mailComposeDelegate = self;
    //        [mail setSubject:@"Swype It Bug Report"];
    //        [mail setMessageBody:@"Bug Description:\n \n\nSteps to duplicate:\n1) \n2) \n..." isHTML:NO];
    //        [mail setToRecipients:@[kSIEmailBugReportReciever]];
    //
    //        [self presentViewController:mail animated:YES completion:NULL];
    //    } else {
    //        NSLog(@"Cannot send email");
    //    }
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - iAd Methods
-(BOOL)premiumUser {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSINSUserDefaultPremiumUser];
}
- (void)configureBannerAds {
    BOOL isPremiumUser = [[NSUserDefaults standardUserDefaults] boolForKey:kSINSUserDefaultPremiumUser];
    
    NSLog(@"User is premium: %@",isPremiumUser ? @"YES" : @"NO");
    
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
            [[SIGameSingleton singleton] singletonWillResumeAndContinue:YES];
        } else {
            [self presentInterstital];
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
//                                                                                                                                    NSFontAttributeName:[UIFont fontWithName:kSIFontFuturaMedium size:[MainViewController SIFontSizeText_x2]]}]
//                                                                   attributedMessage:[[NSAttributedString alloc] initWithString:@"Pick an option to continue where you left off!"
//                                                                                                                     attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
//                                                                                                                                  NSFontAttributeName:[UIFont fontWithName:kSIFontFuturaMedium size:[MainViewController SIFontSizeText]]}]];
//    
//    
//    if ([canAfford boolValue]) {
//        [alert addButtonWithAttributedTitle:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ IT Coins",cost]
//                                                                            attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
//                                                                                         NSFontAttributeName:[UIFont fontWithName:kSIFontFuturaMedium size:[MainViewController SIFontSizeText]]}]
//                                 tapHandler:^{
//                                     NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationGameContinueUseCoins object:nil userInfo:nil];
//                                     [[NSNotificationCenter defaultCenter] postNotification:notification];
//                                 }];
//
//        
//    } else {
//        [alert addButtonWithAttributedTitle:[[NSAttributedString alloc] initWithString:@"Buy More Coins"
//                                                                            attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
//                                                                                         NSFontAttributeName:[UIFont fontWithName:kSIFontFuturaMedium size:[MainViewController SIFontSizeText]]}]
//                                 tapHandler:^{
//                                     NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationGameContinueUseLaunchStore object:nil userInfo:nil];
//                                     [[NSNotificationCenter defaultCenter] postNotification:notification];
//                                 }];
//    }
//    
//    
//    [alert addButtonWithAttributedTitle:[[NSAttributedString alloc] initWithString:@"Watch Ad"
//                                                                        attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
//                                                                                     NSFontAttributeName:[UIFont fontWithName:kSIFontFuturaMedium size:[MainViewController SIFontSizeText]]}]
//                             tapHandler:^{
//                                 [self presentInterstital];
//                             }];
//
//
//    [alert addButtonWithAttributedTitle:[[NSAttributedString alloc] initWithString:@"Cancel"
//                                                                        attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
//                                                                                     NSFontAttributeName:[UIFont fontWithName:kSIFontFuturaMedium size:[MainViewController SIFontSizeText]]}]
//                             tapHandler:^{
//                                 NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationGameContinueUseCancel object:nil userInfo:nil];
//                                 [[NSNotificationCenter defaultCenter] postNotification:notification];
//                             }];
//    
//    [self presentViewController:alert animated:YES completion:nil];
//}
#pragma mark - ADBannerViewDelegate
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Error [loading bannder ad]: %@",error.localizedDescription);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    _adBannerView.alpha                 = 0.0f;
    [UIView commitAnimations];
}
-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    NSLog(@"Banner Hidden?: %@",_adBannerView.hidden ? @"YES" : @"NO");
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
+ (CGFloat)bannerViewHeight {
    if ([MainViewController isPremiumUser]) {
        return 0.0f;
    }
    ADBannerView *tempAdBannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    return tempAdBannerView.bounds.size.height;
}
+ (BOOL)isPremiumUser {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSINSUserDefaultPremiumUser];
}
+ (CGSize)sceneSize {
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - [MainViewController bannerViewHeight]);
}


#pragma mark - Game Center Methods
- (void)authenticateLocalPlayer {
    GKLocalPlayer *localPlayer = [[GKLocalPlayer alloc] init];
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        } else {
            if ([GKLocalPlayer localPlayer].authenticated) {
                NSLog(@"Player Authenticated with Game Center");
            } else {
                NSLog(@"Player Failed to Authenticate with Game Center");

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
- (void)sceneDidRecieveRingNode:(HLRingNode *)ringNode Tap:(SISceneGameRingNode)gameSceneRingNode {
    switch (gameSceneRingNode) {
        case SISceneGameRingNodeEndGame:
            [[SIGameSingleton singleton] singletonDidEnd];
            break;
        case SISceneGameRingNodePlay:
            [[SIGameSingleton singleton] singletonWillResumeAndContinue:NO];
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
    break;
}
- (void)sceneDidRecieveMoveCommand:(SIMove)moveCommand {
    [[SIGameSingleton singleton] singletonDidEnterMove:moveCommand];
}

- (BOOL)gameIsPaused {
    return [SIGameSingleton singleton].currentGame.isPaused;
}

- (BOOL)gameIsStarted {
    return [SIGameSingleton singleton].currentGame.isStarted;
}
- (void)scenePauseButtonTapped {
    [[SIGameSingleton singleton] singletonWillPause];
    [_sceneGame sceneBlurDisplayRingNode:_sceneGameRingNodePause];
}
- (void)sceneWillDismissPopupContinueWithPayMethod:(SIPowerUpPayMethod)powerUpPayMethod {
    switch (powerUpPayMethod) {
        case SIPowerUpPayMethodCoins:
            if ([SIIAPUtility canAffordContinue:[SIGameSingleton singleton].currentGame.currentContinueLifeCost]) {
                [[MKStoreKit sharedKit] consumeCredits:[NSNumber numberWithInt:[SIGameSingleton singleton].currentGame.currentContinueLifeCost] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
            } else {
                [[SIGameSingleton singleton] singletonWillResumeAndContinue:YES];
            }
            break;
        case SIPowerUpPayMethodAds:
            _interstitialAdPresentationIsLive = YES;
            [self interstitialAdPresent];
            break;
        default: //SIPowerUpPayMethodNo
            [[SIGameSingleton singleton] singletonDidEnd];
            break;
    }
    if ([menuItem.text isEqualToString:_coinMenuItemText]) {
        NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationGameContinueUseLaunchStore object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    } else if ([menuItem.text isEqualToString:_costMenuItemText]) {
        [[MKStoreKit sharedKit] consumeCredits:[NSNumber numberWithInteger:[AppSingleton singleton].currentGame.currentContinueLifeCost] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
        [self dismissModalNodeAnimation:HLScenePresentationAnimationFade];
        [self resumePaidContinue];
        
    } else if ([menuItem.text isEqualToString:kSIMenuTextPopUpWatchAd]) {
        NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationInterstitialAdShallLaunch object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [self dismissModalNodeAnimation:HLScenePresentationAnimationFade];
        [self resumePaidContinue];
        
    } else if ([menuItem.text isEqualToString:kSIMenuTextPopUpEndGame]) {
        //        [self dismissModalNodeAnimation:HLScenePresentationAnimationFade];
        [self launchEndGameScene];
    }

}
#pragma mark - SIGameSingletonDelegate
- (void)contorllerWillPlayFXSoundNamed:(NSString *)soundName {
    if ([SIConstants isFXAllowed]) {
        [[SoundManager sharedManager] playSound:soundName];
    }
}
/**
 This is called when the model is ready to start the power
    up being sent in... all controller needs to do is tell 
    the scene (view) to load in what ever it needs to for this
    powerup
 */
- (void)sceneWillActivatePowerUp:(SIPowerUp)powerUp {
    
}

/**
 This is called when the model is deactivating the power up
    All the controller needs to do is tell the scene (view)
    to break down this powerup
 */
- (void)sceneWillDeactivatePowerUp:(SIPowerUp)powerUp {
    
}

/**
 If you want to make the view to something when a free coin 
    is earned this is where you would do it...
 */
- (void)sceneWillShowFreeCoinEarned {
    
}

/**
 This is called when the user has reached a new high score...
    Pretty exicting stuff to say the least.......
 */
- (void)sceneWillShowIsHighScore {
    
}
/**
 Prompt user for payment
 */
- (void)sceneWillShowContinue {
    if (!_sceneGamePopupContinue) {
        _sceneGamePopupContinue = [MainViewController SIPopupSceneGameContinue];
    }
    if (!_sceneGamePopupContinueMenuNode) {
        _sceneGamePopupContinueMenuNode = [MainViewController SIMenuNodeSceneGamePopup:_sceneGamePopupContinue];
    }
    
    if ([SIIAPUtility canAffordContinue:[SIGameSingleton singleton].currentGame.currentContinueLifeCost]) {
        [[[_sceneGamePopupContinueMenuNode menu] itemAtIndex:SISceneGamePopupContinueMenuItemCoin] setText:[NSString stringWithFormat:@"Use %ld Coins!",(long)[SIGameSingleton singleton].currentGame.currentContinueLifeCost]];
    }
    
    [[[_sceneGamePopupContinueMenuNode menu] itemAtIndex:SISceneGamePopupContinueMenuItemAd] setText:[NSString stringWithFormat:@"Watch %ld Ads!",(int)[SIGameSingleton singleton].currentGame.currentNumberOfTimesContinued]];
    
    [_sceneGamePopupContinueMenuNode redisplayMenuAnimation:HLMenuNodeAnimationNone];
    
    [_sceneGame sceneModallyPresentPopup:_sceneGamePopupContinue withMenuNode:_sceneGamePopupContinueMenuNode];
}
/**
 This is called when we know that the model is ready with everything 
 needed for a new move... as in we can launch the score, we can change the 
 background color we can load a new move...
 */
- (void)sceneWillLoadNewMove {
    
}
@end
