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
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "MBProgressHud.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "Game.h"
#import "SIConstants.h"
// Other Imports

@interface MainViewController ()

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudWillHide:) name:kSINotificationHudHide object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hudWillShow:) name:kSINotificationHudShow object:nil];
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
@end
