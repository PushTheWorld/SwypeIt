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
#import "MainViewController.h"
#import "StartScreenScene.h"
// Framework Import
#import <MessageUI/MessageUI.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "Aardvark.h"
#import "ARKBugReporter.h"
#import "ARKIndividualLogViewController.h"
#import "ARKLogDistributor.h"
#import "ARKLogMessage.h"
#import "ARKLogStore.h"
#import "MBProgressHud.h"
#import "SoundManager.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "Game.h"
// Other Imports

@interface MainViewController () <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*Start Sounds*/
    [SoundManager sharedManager].allowsBackgroundMusic = YES;
    [[SoundManager sharedManager] prepareToPlayWithSound:[Sound soundNamed:kSISoundBackgroundMenu]];
    
    // Configure the view.
    SKView * skView         = (SKView *)self.view;
    skView.showsFPS         = YES;
    skView.showsNodeCount   = YES;
    
    // Create and configure the scene.
    SKScene * scene = [StartScreenScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    [self registerForNotifications];
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

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudWillHide:)     name:kSINotificationHudHide object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudWillShow:)     name:kSINotificationHudShow object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchBugReport:) name:kSINotificationSettingsLaunchBugReport object:nil];
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
    
    NSDictionary *userInfo = notification.userInfo;
    
    NSString *titleString   = [userInfo objectForKey:kSINSDictionaryKeyHudMessagePresentTitle];
    NSString *infoString    = [userInfo objectForKey:kSINSDictionaryKeyHudMessagePresentInfo];
    
    NSNumber *dimBackground = (NSNumber *)[userInfo objectForKey:kSINSDictionaryKeyHudWillDimBackground];
    if (dimBackground) {
        willDimBackground   = [dimBackground boolValue];
    } else { /*By Default Dim Background*/
        willDimBackground   = YES;
    }
    
    NSNumber *animate       = (NSNumber *)[userInfo objectForKey:kSINSDictionaryKeyHudWillAnimate];
    if (animate) {
        willAnimate   = [animate boolValue];
    } else { /*By Default Animate*/
        willAnimate   = YES;
    }
    
    MBProgressHUD *hud      = [MBProgressHUD showHUDAddedTo:self.view animated:willAnimate];
    hud.detailsLabelText    = titleString;
    hud.dimBackground       = willDimBackground;
    hud.labelText           = infoString;
    hud.mode                = MBProgressHUDModeIndeterminate;
    self.hud                = hud;
}
- (void)hudWillHide:(NSNotification *)notification {
    BOOL willAnimate;
    BOOL willShowCheckMark;
    
    NSDictionary *userInfo      = notification.userInfo;
    
    NSString *titleString       = [userInfo objectForKey:kSINSDictionaryKeyHudMessagePresentTitle];
    NSString *infoString        = [userInfo objectForKey:kSINSDictionaryKeyHudMessagePresentInfo];
    
    NSNumber *showCheckMark     = (NSNumber *)[userInfo objectForKey:kSINSDictionaryKeyHudWillShowCheckmark];
    if (showCheckMark) {
        willShowCheckMark       = [showCheckMark boolValue];
    } else { /*By Default Dim Background*/
        willShowCheckMark       = YES;
    }
    
    NSNumber *animate           = (NSNumber *)[userInfo objectForKey:kSINSDictionaryKeyHudWillAnimate];
    if (animate) {
        willAnimate             = [animate boolValue];
    } else { /*By Default Animate*/
        willAnimate             = YES;
    }
    
    NSNumber *holdDuration      = (NSNumber *)[userInfo objectForKey:kSINSDictionaryKeyHudWillAnimate];
    if (holdDuration) {
        /*Do Nothing*/
    } else { /*By Default Don't Hold*/
        holdDuration            = [NSNumber numberWithFloat:0.0];
    }
    
    if (willShowCheckMark) {
        self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud-checkmark"]];
    }
    self.hud.detailsLabelText            = titleString;
    self.hud.labelText                   = infoString;
    self.hud.mode                        = MBProgressHUDModeCustomView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([holdDuration floatValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.hud hide:willAnimate];
    });

}
+ (HLLabelButtonNode *)SI_sharedMenuButtonPrototypeBasic:(CGSize)size {
    static HLLabelButtonNode *buttonPrototype = nil;
    if (!buttonPrototype) {
        buttonPrototype                         = [[MainViewController SIInterfaceLabelButton:size] copy];
        buttonPrototype.verticalAlignmentMode   = HLLabelNodeVerticalAlignFontAscenderBias;
    }
    return buttonPrototype;
}
+ (HLLabelButtonNode *)SI_sharedMenuButtonPrototypeBack:(CGSize)size {
    static HLLabelButtonNode *buttonPrototype = nil;
    if (!buttonPrototype) {
        buttonPrototype                     = [[MainViewController SI_sharedMenuButtonPrototypeBasic:size] copy];
        buttonPrototype.color               = [UIColor blueColor];
        buttonPrototype.colorBlendFactor    = 1.0f;
    }
    return buttonPrototype;
}
+ (HLLabelButtonNode *)SIInterfaceLabelButton:(CGSize)size {
    HLLabelButtonNode *labelButton      = [[HLLabelButtonNode alloc] initWithColor:[UIColor mainColor] size:size];
    labelButton.fontName                = kSIFontFuturaMedium;
    labelButton.fontSize                = 20.0f;
    labelButton.fontColor               = [UIColor whiteColor];
    labelButton.verticalAlignmentMode   = HLLabelNodeVerticalAlignFont; /*NOT working*/ // Neither is this: HLLabelNodeVerticalAlignText
    return labelButton;
}
#pragma mark - MFMailComposeViewContorllerDelegate
- (void)launchBugReport:(NSNotification *)notification {
    //    ARKLogStore *logStore = [ARKLogDistributor defaultDistributor].defaultLogStore;
    //    ARKEmailBugReporter *bugReporter = [[ARKEmailBugReporter alloc] initWithEmailAddress:kSIEmailBugReportReciever logStore:logStore];
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Swype It Bug Report"];
        [mail setMessageBody:@"Bug Description:\n \n\nSteps to duplicate:\n1) \n2) \n..." isHTML:NO];
        [mail setToRecipients:@[kSIEmailBugReportReciever]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    } else {
        NSLog(@"Cannot send email");
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
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
@end
