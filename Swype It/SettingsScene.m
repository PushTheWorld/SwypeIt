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
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
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
    self.menuNode.position  = CGPointMake(size.width / 2.0f, size.height - VERTICAL_SPACING_16 -VERTICAL_SPACING_16);
    [self addChild:self.menuNode];
    [self.menuNode hlSetGestureTarget:self.menuNode];
    [self registerDescendant:self.menuNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    [self menuCreate];
}
- (void)viewSetup:(SKView *)view {
    /**Preform setup post-view load*/
    self.menuNode.scene.backgroundColor = [SKColor sandColor]; /*Maybe add a convience method*/
}
- (void)menuCreate {
    HLMenu *menu = [[HLMenu alloc] init];
    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextSettingsResetHighScore]];
    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextSettingsRestorePurchases]];
    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextSettingsBugReport]];
    [menu addItem:[HLMenuBackItem menuItemWithText:kSIMenuTextBack]];
    [self.menuNode setMenu:menu animation:HLMenuNodeAnimationNone];
}
#pragma mark - HLMenuNodeDelegate
- (void)menuNode:(HLMenuNode *)menuNode didTapMenuItem:(HLMenuItem *)menuItem itemIndex:(NSUInteger)itemIndex {
    NSLog(@"Tapped Menu Item [%@] at index %u",menuItem.text,(unsigned)itemIndex);
    if ([menuItem.text isEqualToString:kSIMenuTextBack]) {
        StartScreenScene *startScene = [StartScreenScene sceneWithSize:self.frame.size];
        [Game transisitionToSKScene:startScene toSKView:self.view DoorsOpen:NO pausesIncomingScene:NO pausesOutgoingScene:YES duration:0.5f];
    }
}

@end
