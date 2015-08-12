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
// Framework Import
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

@interface MainViewController () <MFMailComposeViewControllerDelegate, ADBannerViewDelegate, ADInterstitialAdDelegate>

@property (strong, nonatomic) ADBannerView      *adBannerView;
@property (strong, nonatomic) ADInterstitialAd  *interstitialAd;
@property (strong, nonatomic) MBProgressHUD     *hud;
@property (strong, nonatomic) UIButton          *closeButton;
@property (strong, nonatomic) UILabel           *loadingLabel;
@property (strong, nonatomic) UIView            *placeHolderView;

@end

@implementation MainViewController {
    
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
    return [MainViewController fontSizeHeader] + 2.0f;
}
+ (CGFloat)fontSizeText_x3 {
    return [MainViewController fontSizeHeader] + 4.0f;
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
    SKScene * scene = [StartScreenScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];

    // Show me those ads!
    [self configureBannerAds];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self unregisterForNotifications];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}
- (void)setupUserInterface {
    [self createConstants];
    [self createControls];
    [self setupControls];
    [self layoutControls];
}
- (void)createConstants {

}
- (void)createControls {
    _loadingLabel           = [[UILabel alloc] init];
    
    _adBannerView           = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
}
- (void)setupControls {
    _loadingLabel.text      = @"Loading...";
    _loadingLabel.alpha     = 0.0f;
    [_loadingLabel setTextColor:[UIColor blackColor]];
    [_loadingLabel setFont:[UIFont fontWithName:kSIFontFuturaMedium size:[MainViewController fontSizeButton]]];
    [_loadingLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
}
- (void)layoutControls {
    [self.view addSubview:_loadingLabel];
    
    [self.view addConstraint:    [NSLayoutConstraint
                                  constraintWithItem : _loadingLabel
                                  attribute          : NSLayoutAttributeCenterX
                                  relatedBy          : NSLayoutRelationEqual
                                  toItem             : self.view
                                  attribute          : NSLayoutAttributeCenterX
                                  multiplier         : 1.0f
                                  constant           : 0.0f]];
    [self.view addConstraint:    [NSLayoutConstraint
                                  constraintWithItem : _loadingLabel
                                  attribute          : NSLayoutAttributeCenterY
                                  relatedBy          : NSLayoutRelationEqual
                                  toItem             : self.view
                                  attribute          : NSLayoutAttributeCenterY
                                  multiplier         : 1.0f
                                  constant           : 0.0f]];
    
}
- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudWillHide:)             name:kSINotificationHudHide                     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudWillShow:)             name:kSINotificationHudShow                     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchBugReport:)         name:kSINotificationSettingsLaunchBugReport     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidLoad)              name:kSINotificationMenuLoaded                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentInterstital)       name:kSINotificationInterstitialAdShallLaunch   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchPopupForContinue:)  name:kSINotificationGameContinueUsePopup        object:nil];
    
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
    [UIView animateWithDuration:0.5f animations:^{
        self.loadingLabel.alpha = 0.0f;
    }];
}
+ (HLLabelButtonNode *)SI_sharedMenuButtonPrototypeBasic:(CGSize)size fontSize:(CGFloat)fontSize {
    static HLLabelButtonNode *buttonPrototype = nil;
    if (!buttonPrototype) {
        buttonPrototype                         = [[MainViewController SIHLInterfaceLabelButton:size fontSize:fontSize] copy];
        buttonPrototype.verticalAlignmentMode   = HLLabelNodeVerticalAlignFontAscenderBias;
    }
    return buttonPrototype;
}
+ (HLLabelButtonNode *)SI_sharedMenuButtonPrototypeBasic:(CGSize)size fontSize:(CGFloat)fontSize backgroundColor:(SKColor *)backgroundColor fontColor:(UIColor *)fontColor {
    static HLLabelButtonNode *buttonPrototype = nil;
    if (!buttonPrototype) {
        buttonPrototype                         = [[MainViewController SIHLInterfaceLabelButton:size backgroundColor:fontColor fontColor:fontColor fontSize:fontSize] copy];
        buttonPrototype.verticalAlignmentMode   = HLLabelNodeVerticalAlignFontAscenderBias;
    }
    return buttonPrototype;
}
+ (HLLabelButtonNode *)SI_sharedMenuButtonPrototypeBack:(CGSize)size {
    static HLLabelButtonNode *buttonPrototype = nil;
    if (!buttonPrototype) {
        buttonPrototype                         = [[MainViewController SI_sharedMenuButtonPrototypeBasic:size fontSize:[MainViewController fontSizeButton]] copy];
        buttonPrototype.color                   = [UIColor blueColor];
        buttonPrototype.colorBlendFactor        = 1.0f;
    }
    return buttonPrototype;
}
+ (HLLabelButtonNode *)SIHLInterfaceLabelButton:(CGSize)size fontSize:(CGFloat)fontSize {
    HLLabelButtonNode *labelButton              = [[HLLabelButtonNode alloc] initWithColor:[UIColor mainColor] size:size];
    labelButton.cornerRadius                    = 12.0f;
    labelButton.fontName                        = kSIFontUltra; // kSIFontFuturaMedium;
    labelButton.fontSize                        = fontSize;
    labelButton.borderWidth                     = 8.0f;
    labelButton.borderColor                     = [SKColor blackColor];
    labelButton.fontColor                       = [UIColor whiteColor];
    labelButton.verticalAlignmentMode           = HLLabelNodeVerticalAlignFont;
    return labelButton;
}
+ (HLLabelButtonNode *)SIHLInterfaceLabelButton:(CGSize)size backgroundColor:(UIColor *)backgroundColor fontColor:(SKColor *)fontColor fontSize:(CGFloat)fontSize {
    HLLabelButtonNode *labelButton              = [[HLLabelButtonNode alloc] initWithColor:[SKColor orangeColor] size:size];
    labelButton.fontName                        = kSIFontUltra;
    labelButton.cornerRadius                    = 12.0f;
    labelButton.borderWidth                     = 8.0f;
    labelButton.borderColor                     = [SKColor blackColor];
    labelButton.fontSize                        = fontSize;
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
    if (!self.premiumUser) {
        self.canDisplayBannerAds        = NO;
        _adBannerView.delegate          = self;
    }
}
- (void)bannerAdShow {
    _adBannerView.hidden                = NO;
}
- (void)bannerAdHide {
    _adBannerView.hidden                = YES;
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
    if (error.code != ADErrorServerFailure) {
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
    [self bannerAdHide];
}
-(void)bannerViewDidLoadAd:(ADBannerView *)banner {
    [self bannerAdShow];
}
-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    return willLeave;
}
@end
