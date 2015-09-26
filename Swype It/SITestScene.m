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
#import "SIGameScene.h"
//#import "SISingletonGame.h"
#import "SITestScene.h"
// Framework Import
//#import <Instabug/Instabug.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports

@interface SITestScene ()

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
    CGFloat                     _sceneGameSpacingHorizontalToolbar;
    
    CGSize                                   _sceneSize;
    CGSize                                   _sceneGameToolbarSize;
    CGSize                                   _sceneGameToolbarNodeSize;

    NSString    *_buttonSoundBackgroundText;
    NSString    *_buttonSoundFXText;
    
    SIGameScene                             *_sceneGame;
    HLMenuNode                              *_sceneGamePopupContinueMenuNode;
    HLRingNode                              *_sceneGameRingNodePause;
    HLToolbarNode                           *_sceneGameToolbarPowerUp;
    SIPopupNode                             *_sceneGamePopupContinue;

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
    _sceneSize = size;
    //    _buttonSize                     = CGSizeMake(size.width / buttonSizeDivder, (size.width / buttonSizeDivder) * 0.25);
    _buttonSpacing                  = [SIGameController SIButtonSize:size].height * 0.25;
    _buttonAnimationDuration        = 0.25f;
    
    _shouldRespondToTap             = YES;
    
    _sceneGameSpacingHorizontalToolbar  = 10.0f;
    CGFloat toolBarNodeWidth            = (SCREEN_WIDTH - (4.0f * _sceneGameSpacingHorizontalToolbar)) / 5.0f;
    _sceneGameToolbarNodeSize           = CGSizeMake(toolBarNodeWidth, toolBarNodeWidth);
    _sceneGameToolbarSize               = CGSizeMake(_sceneSize.width, _sceneGameToolbarNodeSize.height + VERTICAL_SPACING_8);

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
}

- (void)viewSetup:(SKView *)view {
    /**Preform setup post-view load*/
    self.backgroundColor                    = [SKColor sandColor]; /*Maybe add a convience method*/
    
    
    
    SIGameScene *gameScene;
    [view presentScene:gameScene];
    
    

}



@end
