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
#import "AppSingleton.h"
#import "EndGameScene.h"
#import "MainViewController.h"
#import "StartScreenScene.h"
#import "SITestScene.h"
// Framework Import
#import <GameKit/GameKit.h>
#import <iAd/iAd.h>
#import <Instabug/Instabug.h>
#import <MessageUI/MessageUI.h>
#import "MSSAlertViewController.h"
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "MBProgressHud.h"
#import "SoundManager.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "Game.h"
// Other Imports

@interface MainViewController () <MFMailComposeViewControllerDelegate, ADBannerViewDelegate, ADInterstitialAdDelegate, GKGameCenterControllerDelegate>

@property (strong, nonatomic) ADBannerView      *adBannerView;
@property (strong, nonatomic) ADInterstitialAd  *interstitialAd;
@property (strong, nonatomic) MBProgressHUD     *hud;
@property (strong, nonatomic) UIButton          *closeButton;
@property (strong, nonatomic) UIView            *placeHolderView;

@end

@implementation MainViewController {
    CGFloat _screenHeight;
}
+ (CGFloat)fontSizeButton {
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
+ (CGSize)buttonSize:(CGSize)size {
    if (IS_IPHONE_4) {
        return CGSizeMake(size.width / 1.5, size.width / 1.5 * 0.25);
    } else if (IS_IPHONE_5) {
        return CGSizeMake(size.width / 1.4, size.width / 1.4 * 0.25);
    } else if (IS_IPHONE_6) {
        return CGSizeMake(size.width / 1.3, size.width / 1.3 * 0.25);
    } else if (IS_IPHONE_6_PLUS) {
        return CGSizeMake(size.width / 1.2, size.width / 1.2 * 0.25);
    } else {
        return CGSizeMake(size.width / 1.1, size.width / 1.1 * 0.25);
    }
}
+ (CGFloat)fontSizeHeader {
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
+ (CGFloat)fontSizeHeader_x2 {
    return [MainViewController fontSizeHeader] + 4.0f;
}
+ (CGFloat)fontSizeHeader_x3 {
    return [MainViewController fontSizeHeader] + 8.0f;
}
+ (CGFloat)fontSizeParagraph {
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
+ (CGFloat)fontSizeParagraph_x2 {
    return [MainViewController fontSizeHeader] + 4.0f;
}
+ (CGFloat)fontSizeParagraph_x3 {
    return [MainViewController fontSizeHeader] + 8.0f;
}
+ (CGFloat)fontSizeParagraph_x4 {
    return [MainViewController fontSizeHeader] + 12.0f;
}
+ (CGFloat)fontSizePopUp {
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
+ (CGFloat)fontSizeText {
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
+ (CGFloat)fontSizeText_x2 {
    return [MainViewController fontSizeText] + 2.0f;
}
+ (CGFloat)fontSizeText_x3 {
    return [MainViewController fontSizeText] + 4.0f;
}


#pragma mark - UI Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*Start Sounds*/
    [SoundManager sharedManager].allowsBackgroundMusic  = YES;
    [SoundManager sharedManager].soundFadeDuration      = 1.0f;
    [SoundManager sharedManager].musicFadeDuration      = 2.0f;
    [[SoundManager sharedManager] prepareToPlayWithSound:[Sound soundNamed:kSISoundFXInitalize]];
    
    [self registerForNotifications];
    
    [self cycleInterstitial];
    
    [self setupUserInterface];
    
    // Configure the view.
    SKView * skView         = (SKView *)self.view;
//    skView.showsFPS         = YES;
//    skView.showsNodeCount   = YES;
    
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
    self.hud                                    = hud;
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
        self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud-checkmark"]];
    }
    self.hud.detailsLabelText                   = titleString;
    self.hud.labelText                          = infoString;
    self.hud.mode                               = MBProgressHUDModeCustomView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([holdDuration floatValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.hud hide:willAnimate];
    });

}
- (void)menuDidLoad {

}
+ (HLLabelButtonNode *)SI_sharedMenuButtonPrototypeBasic:(CGSize)size {
    HLLabelButtonNode *buttonPrototype;
    buttonPrototype                         = [[MainViewController SIHLInterfaceLabelButton:size] copy];
    buttonPrototype.verticalAlignmentMode   = HLLabelNodeVerticalAlignFontAscenderBias;
    
    return buttonPrototype;
}
+ (HLLabelButtonNode *)SI_sharedMenuButtonPrototypeBasic:(CGSize)size backgroundColor:(SKColor *)backgroundColor fontColor:(UIColor *)fontColor {
    HLLabelButtonNode *buttonPrototype;
    buttonPrototype                         = [[MainViewController SIHLInterfaceLabelButton:size backgroundColor:fontColor fontColor:fontColor] copy];
    buttonPrototype.verticalAlignmentMode   = HLLabelNodeVerticalAlignFontAscenderBias;
    
    return buttonPrototype;
}
+ (HLLabelButtonNode *)SI_sharedMenuButtonPrototypeBack:(CGSize)size {
    HLLabelButtonNode *buttonPrototype;
    buttonPrototype                         =  [[MainViewController SIHLInterfaceLabelButton:size] copy];;
    buttonPrototype.color                   = [UIColor blueColor];
    buttonPrototype.colorBlendFactor        = 1.0f;

    return buttonPrototype;
}
+ (HLLabelButtonNode *)SI_sharedMenuButtonPrototypePopUp:(CGSize)size {
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
+ (SKLabelNode *)SI_sharedLabelHeader:(NSString *)text {
    SKLabelNode *label  = [MainViewController SIInterfaceLabelFontSize:[MainViewController fontSizeHeader]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SI_sharedLabelHeader_x2:(NSString *)text {
    SKLabelNode *label  = [MainViewController SIInterfaceLabelFontSize:[MainViewController fontSizeHeader_x2]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SI_sharedLabelHeader_x3:(NSString *)text {
    SKLabelNode *label  = [MainViewController SIInterfaceLabelFontSize:[MainViewController fontSizeHeader_x3]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SI_sharedLabelParagraph:(NSString *)text {
    SKLabelNode *label  = [MainViewController SIInterfaceLabelFontSize:[MainViewController fontSizeParagraph]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SI_sharedLabelParagraph_x2:(NSString *)text {
    SKLabelNode *label  = [MainViewController SIInterfaceLabelFontSize:[MainViewController fontSizeParagraph_x2]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SI_sharedLabelParagraph_x3:(NSString *)text {
    SKLabelNode *label  = [MainViewController SIInterfaceLabelFontSize:[MainViewController fontSizeParagraph_x3]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SI_sharedLabelParagraph_x4:(NSString *)text {
    SKLabelNode *label  = [MainViewController SIInterfaceLabelFontSize:[MainViewController fontSizeParagraph_x4]];
    label.text          = text;
    return label;
}
+ (SKLabelNode *)SIInterfaceLabelFontSize:(CGFloat)fontSize {
    SKLabelNode *label                          = [SKLabelNode labelNodeWithFontNamed:kSIFontUltra];
    label.fontColor                             = [SKColor blackColor];
    label.fontSize                              = fontSize;
    label.horizontalAlignmentMode               = SKLabelHorizontalAlignmentModeCenter;
    label.verticalAlignmentMode                 = SKLabelVerticalAlignmentModeCenter;
    return label;
}
+ (SIPopupNode *)SISharedPopUpNodeTitle:(NSString *)title SceneSize:(CGSize)sceneSize {
    SKLabelNode *titleNode      = [MainViewController SI_sharedLabelParagraph:title];
    titleNode.fontColor         = [SKColor whiteColor];
    titleNode.fontSize          = [MainViewController fontSizePopUp];
    
    SIPopupNode *popUpNode      = [[SIPopupNode alloc] initWithSceneSize:sceneSize titleLabelNode:titleNode];
    popUpNode.backgroundSize    = CGSizeMake(sceneSize.width - 100.0f, sceneSize.height - 200.0f);
    popUpNode.backgroundColor   = [SKColor mainColor];
    popUpNode.cornerRadius      = 8.0f;
    
//    SIPopupNode *popUpNode = [[SIPopupNode alloc] initWithSceneSize:sceneSize
//                                                          popUpSize:CGSizeMake(sceneSize.width - 100.0f, sceneSize.height - 200.0f)
//                                                              title:titleNode.text
//                                                     titleFontColor:titleNode.fontColor
//                                                      titleFontSize:titleNode.fontSize
//                                                      titleYPadding:VERTICAL_SPACING_16 * 2
//                                                    backgroundColor:[SKColor mainColor]
//                                                       cornerRadius:8.0f
//                                                        borderWidth:8.0f
//                                                        borderColor:[SKColor simplstMainColor]];
    
    
    
    return popUpNode;
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
        self.canDisplayBannerAds = YES;
        self.adBannerView.delegate  = self;
        self.adBannerView.hidden    = YES; /*hide till loaded!*/
    } else {
        self.canDisplayBannerAds    = NO;
    }
}
- (void)cycleInterstitial {
    _interstitialAd                     = [[ADInterstitialAd alloc] init];
    _interstitialAd.delegate            = self;
}
- (void)closeAd {

    [self.placeHolderView removeFromSuperview];
    [self.closeButton removeFromSuperview];
    
    self.interstitialAd = nil;
    [self cycleInterstitial];
    
    [self bannerAdShow];
    
    NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationInterstitialAdFinish object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    
}
- (void)presentInterstital {
    if (_interstitialAd.loaded) {
        [self bannerAdHide];
        self.placeHolderView    = [[UIView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:self.placeHolderView];
        
        self.closeButton        = [[UIButton alloc] initWithFrame:CGRectMake(25, 25, self.view.frame.size.width / 6.0f, self.view.frame.size.width / 6.0f)];
        [self.closeButton setBackgroundImage:[UIImage imageNamed:kSIImageButtonCross] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(closeAd) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.closeButton];
        
        [_interstitialAd presentInView:self.placeHolderView];
    } else {
        if (self.placeHolderView) {
            [self closeAd];
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
    if (self.placeHolderView) {
        [self closeAd];
    }
}

// This method will be invoked when an error has occurred attempting to get advertisement content.
// The ADError enum lists the possible error codes.
- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error
{
    NSLog(@"Error [interstitialAd] (CODE: %d) : %@",(int)error.code,error.localizedDescription);
    if (error.code != ADErrorServerFailure && error.code != 7) {
        [self closeAd];
    }
    
}

- (void)launchPopupForContinue:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *canAfford = [userInfo objectForKey:kSINSDictionaryKeyCanAfford];
    NSNumber *cost      = [userInfo objectForKey:kSINSDictionaryKeyCanAffordCost];
    
    MSSAlertViewController *alert = [MSSAlertViewController alertWithAttributedTitle: [[NSAttributedString alloc] initWithString:@"Continue!"
                                                                                                                       attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                                                                                                                                    NSFontAttributeName:[UIFont fontWithName:kSIFontFuturaMedium size:[MainViewController fontSizeText_x2]]}]
                                                                   attributedMessage:[[NSAttributedString alloc] initWithString:@"Pick an option to continue where you left off!"
                                                                                                                     attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                                                                                                                                  NSFontAttributeName:[UIFont fontWithName:kSIFontFuturaMedium size:[MainViewController fontSizeText]]}]];
    
    
    if ([canAfford boolValue]) {
        [alert addButtonWithAttributedTitle:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ IT Coins",cost]
                                                                            attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                                                                                         NSFontAttributeName:[UIFont fontWithName:kSIFontFuturaMedium size:[MainViewController fontSizeText]]}]
                                 tapHandler:^{
                                     NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationGameContinueUseCoins object:nil userInfo:nil];
                                     [[NSNotificationCenter defaultCenter] postNotification:notification];
                                 }];

        
    } else {
        [alert addButtonWithAttributedTitle:[[NSAttributedString alloc] initWithString:@"Buy More Coins"
                                                                            attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                                                                                         NSFontAttributeName:[UIFont fontWithName:kSIFontFuturaMedium size:[MainViewController fontSizeText]]}]
                                 tapHandler:^{
                                     NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationGameContinueUseLaunchStore object:nil userInfo:nil];
                                     [[NSNotificationCenter defaultCenter] postNotification:notification];
                                 }];
    }
    
    
    [alert addButtonWithAttributedTitle:[[NSAttributedString alloc] initWithString:@"Watch Ad"
                                                                        attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                                                                                     NSFontAttributeName:[UIFont fontWithName:kSIFontFuturaMedium size:[MainViewController fontSizeText]]}]
                             tapHandler:^{
                                 [self presentInterstital];
                             }];


    [alert addButtonWithAttributedTitle:[[NSAttributedString alloc] initWithString:@"Cancel"
                                                                        attributes:@{NSForegroundColorAttributeName: [UIColor blackColor],
                                                                                     NSFontAttributeName:[UIFont fontWithName:kSIFontFuturaMedium size:[MainViewController fontSizeText]]}]
                             tapHandler:^{
                                 NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationGameContinueUseCancel object:nil userInfo:nil];
                                 [[NSNotificationCenter defaultCenter] postNotification:notification];
                             }];
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - ADBannerViewDelegate
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Error [loading bannder ad]: %@",error.localizedDescription);
//    [self bannerAdHide];
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
    return willLeave;
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
    gameCenterVC.delegate                       = self;
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
@end
