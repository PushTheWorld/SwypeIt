//  SILoadingScene.m
//  Swype It
//
//  Created by Andrew Keller on 9/4/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is the loading scene
//
// Local Controller Import
#import "SILoadingScene.h"
#import "SIGameController.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIGame.h"
// Other Imports

@implementation SILoadingScene {
//    SKLabelNode             *_loadingLabel;
    
    SKSpriteNode            *_backgroundNode;
    SKSpriteNode            *_monkeyFace;
    
    TCProgressBarNode       *_progressBarLoading;
}

#pragma mark - Scene Life Cycle
- (void)didMoveToView:(SKView *)view {
    NSLog(@"Loading Scene Moved To View!");
}
- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /**Do any setup before self.view is loaded*/
        [self initSetup:size];
    }
    return self;
}
- (void)initSetup:(CGSize)size {
    /**Preform initalization pre-view load*/
    [self createControlsWithSize:size];
    [self setupControlsWithSize:size];
    [self layoutControlsWithSize:size];
}

#pragma mark Scene Setup
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    _progressBarLoading = [[TCProgressBarNode alloc] initWithSize:CGSizeMake(size.width - VERTICAL_SPACING_16, (size.width - VERTICAL_SPACING_16) * 0.25f)
                                                  backgroundColor:[SKColor SIColorPrimary]
                                                        fillColor:[SKColor SIColorSecondary]
                                                      borderColor:[SKColor SIColorSecondary]
                                                      borderWidth:2.0f
                                                     cornerRadius:8.0f];
    
//    _loadingLabel                           = [SKLabelNode labelNodeWithFontNamed:kSISFFontDisplayHeavy];
    
    _monkeyFace                             = [SKSpriteNode spriteNodeWithTexture:[SIGameController SITextureMonkeyFaceLarge]];

    self.backgroundColor                    = [SKColor SIColorPrimary];
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
//    _loadingLabel.fontSize                  = [SIGameController SIFontSizeHeader_x3];
//    _loadingLabel.fontColor                 = [SKColor whiteColor];
//    _loadingLabel.verticalAlignmentMode     = SKLabelVerticalAlignmentModeCenter;
//    _loadingLabel.horizontalAlignmentMode   = SKLabelHorizontalAlignmentModeCenter;
}
- (void)layoutControlsWithSize:(CGSize)size {
    /**Layout those controls*/
//    _loadingLabel.position                  = CGPointMake((size.width / 2.0f), (size.height / 2.0f) + VERTICAL_SPACING_8);
//    [self addChild:_loadingLabel];
    
    _monkeyFace.position                    = CGPointMake(size.width / 2.0f, size.height * 0.75f);
    [self addChild:_monkeyFace];
    
    _progressBarLoading.position            = CGPointMake((size.width / 2.0f),(size.width / 2.0f) - VERTICAL_SPACING_8);
    [self addChild:_progressBarLoading];
    
}
- (void)sceneLoadingSetProgressPercent:(float)percent {
    if (percent > 1.0) {
        _progressBarLoading.progress = 1.0f;
        
    } else if (percent < 0.0f) {
        _progressBarLoading.progress = 0.0f;
    } else {
        _progressBarLoading.progress = percent;
    }
}


@end
