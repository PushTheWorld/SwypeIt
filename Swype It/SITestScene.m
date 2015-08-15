//
//  SITestScene.m
//  Swype It
//
//  Created by Andrew Keller on 8/14/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: This is testing
//
// Local Controller Import
#import "MainViewController.h"
#import "SIPopupNode.h"
#import "SITestScene.h"
#import "StartScreenScene.h"
// Framework Import
//#import <Instabug/Instabug.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports

@interface SITestScene () <HLMenuNodeDelegate, SIPopUpNodeDelegate>

#pragma mark - Private Constraints
@property (assign, nonatomic) CGFloat        buttonSpacing;
@property (assign, nonatomic) CGFloat        buttonAnimationDuration;

#pragma mark - Private Properties
@property (strong, nonatomic) HLMenuNode    *menuNode;
@property (strong, nonatomic) SKLabelNode   *titleLabel;

@end

@implementation SITestScene {
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
//        [self initSetup:size];
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
    _menuNode.itemButtonPrototype                   = [MainViewController SI_sharedMenuButtonPrototypeBasic:[MainViewController buttonSize:size] fontSize:[MainViewController fontSizeButton]];
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
    self.backgroundColor        = [SKColor sandColor]; /*Maybe add a convience method*/
    
    SKLabelNode *label          = [MainViewController SI_sharedLabelHeader:@"Test Scene"];
    label.position              = CGPointMake(self.view.frame.size.width / 2.0f, self.view.frame.size.height / 2.0f);
    [self addChild:label];
    
    CGSize sceneSize = self.size;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        SIPopupNode *popUpNode      = [[SIPopupNode alloc] initWithSceneSize:self.frame.size
//                                                                    xPadding:16.0f
//                                                                    yPadding:16.0f
//                                                             backgroundColor:[SKColor blueColor]
//                                                                cornerRadius:0.0f
//                                                                 borderWidth:0.0f
//                                                                 borderColor:[SKColor blackColor]];
        SIPopupNode *popUpNode      = [[SIPopupNode alloc] initWithSceneSize:self.frame.size];
        popUpNode.delegate          = self;
        popUpNode.userInteractionEnabled    = YES;
        [popUpNode hlSetGestureTarget:popUpNode];
        [self registerDescendant:popUpNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
        [self presentModalNode:popUpNode animation:HLScenePresentationAnimationFade];
    });


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
//        [self goBack];
    } else if ([menuItem.text isEqualToString:kSIMenuTextSettingsBugReport]) {
//        NSNotification *notification        = [[NSNotification alloc] initWithName:kSINotificationSettingsLaunchBugReport object:nil userInfo:nil];
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
    } else if ([menuItem.text isEqualToString:kSIMenuTextSettingsResetHighScore]) {
//        [self resetHighScore];
    } else if ([menuItem.text isEqualToString:_buttonSoundBackgroundText]) {
//        [self changeBackgroundSoundIsAllowed:menuItem];
    } else if ([menuItem.text isEqualToString:_buttonSoundFXText]) {
//        [self changeFXSoundIsAllowed:menuItem];
    }
}
-(BOOL)menuNode:(HLMenuNode *)menuNode shouldTapMenuItem:(HLMenuItem *)menuItem itemIndex:(NSUInteger)itemIndex {
    return _shouldRespondToTap;
}
#pragma mark - Private Methods

- (void)dismissPopUp:(SIPopupNode *)popUpNode {
    [self dismissModalNodeAnimation:HLScenePresentationAnimationFade];
}
@end
