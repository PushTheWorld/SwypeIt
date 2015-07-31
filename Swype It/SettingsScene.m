//  SettingsScene.m
//  Swype It
//
//  Created by Andrew Keller on 7/29/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: This is for the settings menu
//
// Local Controller Import
#import "MainViewController.h"
#import "SettingsScene.h"
#import "StartScreenScene.h"
// Framework Import
//#import <Instabug/Instabug.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "SoundManager.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports

@interface SettingsScene () <HLMenuNodeDelegate>

#pragma mark - Private Constraints
@property (assign, nonatomic) CGFloat        buttonSpacing;
@property (assign, nonatomic) CGFloat        buttonAnimationDuration;
@property (assign, nonatomic) CGSize         buttonSize;

#pragma mark - Private Properties
@property (strong, nonatomic) HLMenuNode    *menuNode;

@end

@implementation SettingsScene {
    BOOL _contentCreated;
    NSString *_buttonSoundBackgroundText;
    NSString *_buttonSoundFXText;
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
#pragma mark Scene Setup
- (void)createConstantsWithSize:(CGSize)size {
    /**Configure any constants*/
    if (IS_IPHONE_4) {
//        self.buttonSpacing              = 36.0f;
        
    } else if (IS_IPHONE_5) {
//        self.buttonSpacing              = 40.0f;
        
    } else if (IS_IPHONE_6) {
//        self.buttonSpacing              = 80.0f;
        
    } else if (IS_IPHONE_6_PLUS) {
//        self.buttonSpacing              = 48.0f;

    } else {
//        self.buttonSpacing              = 52.0f;
        
    }
    self.buttonSpacing                  = (size.width / 2.0f) * 0.5;
    self.buttonSize                     = CGSizeMake(size.width / 2.0f, (size.width / 2.0f) * 0.25);
    self.buttonAnimationDuration        = 0.25f;
}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    
    /*Menu Node*/
    self.menuNode = [[HLMenuNode alloc] init];
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    
    /*Menu Node*/
    self.menuNode.delegate                  = self;
    self.menuNode.itemAnimation             = HLMenuNodeAnimationSlideLeft;
    self.menuNode.itemAnimationDuration     = self.buttonAnimationDuration;
    self.menuNode.itemButtonPrototype       = [MainViewController SI_sharedMenuButtonPrototypeBasic:self.buttonSize];
    self.menuNode.backItemButtonPrototype   = [MainViewController SI_sharedMenuButtonPrototypeBack:self.buttonSize];
    self.menuNode.itemSpacing               = self.buttonSpacing;
}
- (void)layoutControlsWithSize:(CGSize)size {
    /**Layout those controls*/
    
    /*Menu Node*/
    self.menuNode.position  = CGPointMake(size.width / 2.0f,
                                          (size.height / 2.0f) +
                                          (self.buttonSpacing / 2.0f) +
                                          self.buttonSize.height +
                                          self.buttonSpacing +
                                          self.buttonSize.height);
    [self addChild:self.menuNode];
    [self.menuNode hlSetGestureTarget:self.menuNode];
    [self registerDescendant:self.menuNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    [self menuCreate];
}
- (void)viewSetup:(SKView *)view {
    /**Preform setup post-view load*/
    self.backgroundColor = [SKColor sandColor]; /*Maybe add a convience method*/
}
- (void)menuCreate {
    HLMenu *menu = [[HLMenu alloc] init];
    
    /*Add the regular buttons*/
    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextSettingsResetHighScore]];
    
    _buttonSoundBackgroundText = [[NSUserDefaults standardUserDefaults] boolForKey:kSINSUserDefaultSoundIsAllowedBackground] ? kSIMenuTextSettingsToggleSoundOffBackground : kSIMenuTextSettingsToggleSoundOnBackground;
    [menu addItem:[HLMenuItem menuItemWithText:_buttonSoundBackgroundText]];
    
    _buttonSoundFXText = [[NSUserDefaults standardUserDefaults] boolForKey:kSINSUserDefaultSoundIsAllowedFX] ? kSIMenuTextSettingsToggleSoundOffFX : kSIMenuTextSettingsToggleSoundOnFX;
    [menu addItem:[HLMenuItem menuItemWithText:_buttonSoundFXText]];
    
    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextSettingsBugReport]];
    
    /*Add the Back Button... Need to change the prototype*/
    HLMenuItem *resumeItem = [HLMenuItem menuItemWithText:kSIMenuTextBack];
    resumeItem.buttonPrototype = [MainViewController SI_sharedMenuButtonPrototypeBack:self.buttonSize];
    [menu addItem:resumeItem];
    
    [self.menuNode setMenu:menu animation:HLMenuNodeAnimationNone];
}
#pragma mark - HLMenuNodeDelegate
- (void)menuNode:(HLMenuNode *)menuNode didTapMenuItem:(HLMenuItem *)menuItem itemIndex:(NSUInteger)itemIndex {
    NSLog(@"Tapped Menu Item [%@] at index %u",menuItem.text,(unsigned)itemIndex);
    if ([menuItem.text isEqualToString:kSIMenuTextBack]) {
        [self goBack];
    } else if ([menuItem.text isEqualToString:kSIMenuTextSettingsBugReport]) {
        NSNotification *notification        = [[NSNotification alloc] initWithName:kSINotificationSettingsLaunchBugReport object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    } else if ([menuItem.text isEqualToString:kSIMenuTextSettingsResetHighScore]) {
        [self resetHighScore];
    } else if ([menuItem.text isEqualToString:_buttonSoundBackgroundText]) {
        [self changeBackgroundSoundIsAllowed:menuItem];
    } else if ([menuItem.text isEqualToString:_buttonSoundFXText]) {
        [self changeFXSoundIsAllowed:menuItem];
    }
}
#pragma mark - Private Methods
- (void)goBack {
    StartScreenScene *startScene = [StartScreenScene sceneWithSize:self.frame.size];
    [Game transisitionToSKScene:startScene toSKView:self.view DoorsOpen:NO pausesIncomingScene:NO pausesOutgoingScene:YES duration:0.5f];
}
- (void)resetHighScore {
    NSDictionary *userInfo          = @{kSINSDictionaryKeyHudWillAnimate            : @YES,
                                        kSINSDictionaryKeyHudWillDimBackground      : @YES,
                                        kSINSDictionaryKeyHudMessagePresentTitle    : @"High Score",
                                        kSINSDictionaryKeyHudMessagePresentInfo     : @"Resettings..."};
    NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationHudShow object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    /*Reset the user defaults*/
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:0.0f] forKey:kSINSUserDefaultLifetimeHighScore];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    /*Hide the hud*/
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDictionary *userInfo          = @{kSINSDictionaryKeyHudWillAnimate            : @YES,
                                            kSINSDictionaryKeyHudWillShowCheckmark      : @YES,
                                            kSINSDictionaryKeyHudHoldDismissForDuration : [NSNumber numberWithFloat:1.75],
                                            kSINSDictionaryKeyHudMessagePresentTitle    : @"High Score",
                                            kSINSDictionaryKeyHudMessagePresentInfo     : @"Reset!"};
        NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationHudHide object:nil userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    });

}
- (void)changeBackgroundSoundIsAllowed:(HLMenuItem *)menuItem {
    if ([menuItem.text isEqualToString:kSIMenuTextSettingsToggleSoundOffBackground]) {
        /*Turn Background Sound Off*/
//        menuItem.buttonPrototype.text = kSIMenuTextSettingsToggleSoundOnBackground;
        menuItem.text = kSIMenuTextSettingsToggleSoundOnBackground;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kSINSUserDefaultSoundIsAllowedBackground];
        [[SoundManager sharedManager] stopMusic];
    } else {
        /*Turn Sound On*/
        menuItem.text = kSIMenuTextSettingsToggleSoundOffBackground;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSINSUserDefaultSoundIsAllowedBackground];
        [[SoundManager sharedManager] playMusic:kSISoundBackgroundMenu looping:YES fadeIn:YES];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)changeFXSoundIsAllowed:(HLMenuItem *)menuItem {
    if ([menuItem.text isEqualToString:kSIMenuTextSettingsToggleSoundOffFX]) {
        /*Turn Background Sound Off*/
        menuItem.text = kSIMenuTextSettingsToggleSoundOnFX;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kSINSUserDefaultSoundIsAllowedFX];
        [[SoundManager sharedManager] stopAllSounds];
    } else {
        /*Turn Sound On*/
        menuItem.text = kSIMenuTextSettingsToggleSoundOffFX;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSINSUserDefaultSoundIsAllowedFX];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
