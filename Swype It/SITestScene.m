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
#import "SIGameController.h"
#import "SIPopupNode.h"
#import "SITestScene.h"
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
    _buttonSpacing                  = [SIGameController SIButtonSize:size].height * 0.25;
    _buttonAnimationDuration        = 0.25f;
    
    _shouldRespondToTap             = YES;
}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    _titleLabel = [SIGameController SILabelHeader:kSIMenuTextStartScreenSettings];
    
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    
    /*Menu Node*/

}
- (void)layoutControlsWithSize:(CGSize)size {
    /**Layout those controls*/
    /*Title Label*/
    _titleLabel.position       = CGPointMake((size.width / 2.0f),
                                             size.height - _titleLabel.frame.size.height - VERTICAL_SPACING_8);
    [self addChild:_titleLabel];
    
    
    /*Menu Node*/

    [self menuCreate:size];
}

- (void)viewSetup:(SKView *)view {
    /**Preform setup post-view load*/
    self.backgroundColor                    = [SKColor sandColor]; /*Maybe add a convience method*/
    
    SKLabelNode *label                      = [SIGameController SILabelHeader:@"Test Scene"];
    label.position                          = CGPointMake(self.view.frame.size.width / 2.0f, self.view.frame.size.height / 2.0f);
    [self addChild:label];
    
    CGSize sceneSize                        = self.size;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SIPopupNode *popUpNode              = [SIGameController SIPopUpNodeTitle:@"Continue?" SceneSize:sceneSize];
        
        HLMenuNode *menuNode                = [self menuCreate:popUpNode.backgroundSize];
        popUpNode.popupContentNode          = menuNode;
        [self registerDescendant:menuNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
        
        popUpNode.delegate                  = self;
        popUpNode.userInteractionEnabled    = YES;
        [popUpNode hlSetGestureTarget:popUpNode];
        [self registerDescendant:popUpNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
        [self presentModalNode:popUpNode animation:HLScenePresentationAnimationFade];
    });


}
- (HLMenuNode *)menuCreate:(CGSize)size {
    HLMenuNode *menuNode                    = [[HLMenuNode alloc] init];
    menuNode.delegate                       = self;
    menuNode.itemAnimation                  = HLMenuNodeAnimationSlideLeft;
    menuNode.itemAnimationDuration          = self.buttonAnimationDuration;
//    menuNode.itemButtonPrototype            = [SIGameController  SILabelButtonMenuPrototypePopUp:[SIGameController SIButtonSize:size]];
//    menuNode.backItemButtonPrototype        = [SIGameController SILabelButtonMenuPrototypeBack:[SIGameController SIButtonSize:size]];
    menuNode.itemSeparatorSize              = 20;
    
    HLMenu *menu                            = [[HLMenu alloc] init];
    
    /*Add the regular buttons*/
    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextPopUpBuyCoins]];

    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextPopUpWatchAd]];

    /*Add the Back Button... Need to change the prototype*/
    HLMenuItem *endGameItem                 = [HLMenuItem menuItemWithText:kSIMenuTextPopUpEndGame];
//    endGameItem.buttonPrototype             = [SIGameController SILabelButtonMenuPrototypeBack:[SIGameController SIButtonSize:size]];
    [menu addItem:endGameItem];

    
    [menuNode setMenu:menu animation:HLMenuNodeAnimationNone];
    
    menuNode.position                   = CGPointMake(0.0f, 0.0f);
    
    return menuNode;
}
#pragma mark - HLMenuNodeDelegate
- (void)menuNode:(HLMenuNode *)menuNode didTapMenuItem:(HLMenuItem *)menuItem itemIndex:(NSUInteger)itemIndex {
    NSLog(@"Tapped Menu Item [%@] at index %u",menuItem.text,(unsigned)itemIndex);
    if ([menuItem.text isEqualToString:kSIMenuTextPopUpBuyCoins]) {
        NSLog(@"Launch Store!");
    } else if ([menuItem.text isEqualToString:kSIMenuTextPopUpWatchAd]) {
        NSLog(@"Watch an ad");
    } else if ([menuItem.text isEqualToString:kSIMenuTextSettingsResetHighScore]) {
        NSLog(@"Launch End Scene");
    }
}

#pragma mark - Private Methods

- (void)dismissPopUp:(SIPopupNode *)popUpNode {
    [self dismissModalNodeAnimation:HLScenePresentationAnimationFade];
}
@end
