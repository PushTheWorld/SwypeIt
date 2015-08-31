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
//@property (assign, nonatomic) CGSize         buttonSize;

#pragma mark - Private Properties
@property (strong, nonatomic) HLMenuNode    *menuNode;
@property (strong, nonatomic) SKLabelNode   *titleLabel;

@end

@implementation SettingsScene {
    BOOL         _contentCreated;
    BOOL         _shouldRespondToTap;
    
    CGFloat      _fontSize;
    NSString    *_buttonSoundBackgroundText;
    NSString    *_buttonSoundFXText;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kSINotificationAdBannerHide object:nil];
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
    CGFloat buttonSizeDivder;
    if (IS_IPHONE_4) {
        _fontSize                       = 36.0f;
        buttonSizeDivder                = 1.5f;
        
    } else if (IS_IPHONE_5) {
        _fontSize                       = 40.0f;
        buttonSizeDivder                = 1.5f;
        
    } else if (IS_IPHONE_6) {
        _fontSize                       = 30.0f;
        buttonSizeDivder                = 1.25f;
        
    } else if (IS_IPHONE_6_PLUS) {
        _fontSize                       = 48.0f;
        buttonSizeDivder                = 1.5f;

    } else {
        _fontSize                       = 52.0f;
        buttonSizeDivder                = 1.5f;
        
    }
//    _buttonSize                     = CGSizeMake(size.width / buttonSizeDivder, (size.width / buttonSizeDivder) * 0.25);
    _buttonSpacing                  = [MainViewController buttonSize:size].height * 0.25;
    _buttonAnimationDuration        = 0.25f;
    
    _shouldRespondToTap             = YES;
}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    _titleLabel = [MainViewController SI_sharedLabelHeader:kSIMenuTextStartScreenSettings];
    
    /*Menu Node*/
    _menuNode   = [[HLMenuNode alloc] init];
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/

    /*Menu Node*/
    _menuNode.delegate                              = self;
    _menuNode.itemAnimation                         = HLMenuNodeAnimationSlideLeft;
    _menuNode.itemAnimationDuration                 = self.buttonAnimationDuration;
    _menuNode.itemButtonPrototype                   = [MainViewController SI_sharedMenuButtonPrototypeBasic:[MainViewController buttonSize:size]];
    _menuNode.backItemButtonPrototype               = [MainViewController SI_sharedMenuButtonPrototypeBack:[MainViewController buttonSize:size]];
    _menuNode.itemSeparatorSize                     = self.buttonSpacing;
}
- (void)layoutControlsWithSize:(CGSize)size {
    /**Layout those controls*/
    /*Title Label*/
    _titleLabel.position       = CGPointMake((size.width / 2.0f),
                                                  size.height - _titleLabel.frame.size.height - VERTICAL_SPACING_8);
    [self addChild:_titleLabel];

    
    /*Menu Node*/
    _menuNode.position  = CGPointMake(size.width / 2.0f, size.height / 2.0f);
    [self addChild:_menuNode];
    [_menuNode hlSetGestureTarget:_menuNode];
    [self registerDescendant:_menuNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    [self menuCreate:size];
}
- (void)viewSetup:(SKView *)view {
    /**Preform setup post-view load*/
    self.backgroundColor = [SKColor sandColor]; /*Maybe add a convience method*/
}
- (void)menuCreate:(CGSize)size {
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
    resumeItem.buttonPrototype = [MainViewController SI_sharedMenuButtonPrototypeBack:[MainViewController buttonSize:size]];
    [menu addItem:resumeItem];
    
    [_menuNode setMenu:menu animation:HLMenuNodeAnimationNone];
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
-(BOOL)menuNode:(HLMenuNode *)menuNode shouldTapMenuItem:(HLMenuItem *)menuItem itemIndex:(NSUInteger)itemIndex {
    return _shouldRespondToTap;
}
#pragma mark - Private Methods
- (void)goBack {
    _shouldRespondToTap = NO;
    StartScreenScene *startScene = [StartScreenScene sceneWithSize:self.frame.size];
    [Game transisitionToSKScene:startScene toSKView:self.view DoorsOpen:NO pausesIncomingScene:YES pausesOutgoingScene:YES duration:SCENE_TRANSISTION_DURATION];
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
        _buttonSoundBackgroundText = kSIMenuTextSettingsToggleSoundOnBackground;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kSINSUserDefaultSoundIsAllowedBackground];
        [[SoundManager sharedManager] stopMusic];
    } else {
        /*Turn Sound On*/
        _buttonSoundBackgroundText = kSIMenuTextSettingsToggleSoundOffBackground;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSINSUserDefaultSoundIsAllowedBackground];
        [[SoundManager sharedManager] playMusic:kSISoundBackgroundMenu looping:YES fadeIn:YES];
    }
    menuItem.text = _buttonSoundBackgroundText;
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_menuNode redisplayMenuAnimation:HLMenuNodeAnimationNone];
}
- (void)changeFXSoundIsAllowed:(HLMenuItem *)menuItem {
    if ([menuItem.text isEqualToString:kSIMenuTextSettingsToggleSoundOffFX]) {
        /*Turn Background Sound Off*/
        _buttonSoundFXText = kSIMenuTextSettingsToggleSoundOnFX;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kSINSUserDefaultSoundIsAllowedFX];
        [[SoundManager sharedManager] stopAllSounds];
    } else {
        /*Turn Sound On*/
        _buttonSoundFXText = kSIMenuTextSettingsToggleSoundOffFX;
        menuItem.text = kSIMenuTextSettingsToggleSoundOffFX;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSINSUserDefaultSoundIsAllowedFX];
    }
    menuItem.text = _buttonSoundFXText;
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_menuNode redisplayMenuAnimation:HLMenuNodeAnimationNone];
}
@end
