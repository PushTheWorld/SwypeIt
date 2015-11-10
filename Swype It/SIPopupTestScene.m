
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
#import "SIPopupGameOverDetailsNode.h"
//#import "SISingletonGame.h"
#import "SIPopupTestScene.h"
// Framework Import
//#import <Instabug/Instabug.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports

@interface SIPopupTestScene ()

@end

@implementation SIPopupTestScene {
    CGFloat                                  _fontSize;
    
    CGSize                                   _sceneSize;
    
    HLMenuNode                              *_menuNodeEnd;
    HLMenuNode                              *_menuNodeStore;
    
    SIPopupNode                             *_popupNode;
    
    SKSpriteNode                            *_sceneGamePopupGameOverEndNode;
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

}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    
    /*Menu Node*/

}
- (void)layoutControlsWithSize:(CGSize)size {
    /**Layout those controls*/
    /*Title Label*/
}

- (void)viewSetup:(SKView *)view {
    /**Preform setup post-view load*/
    self.backgroundColor                    = [SKColor SIColorPrimary]; /*Maybe add a convience method*/
    
    
    
    _popupNode                              = [SIGameController SIPopupSceneGameContinueSize:_sceneSize];

    _sceneGamePopupGameOverEndNode          = [SIGameController SISpriteNodePopupGameOverEndNode];
    
    [((INSKButtonNode *)_popupNode.bottomNode) setTouchUpInsideTarget:self selector:@selector(makePopupBigger)];
    
    [self presentModalNode:_popupNode animation:HLScenePresentationAnimationFade];
}

- (void)makePopupBigger {
    _popupNode.countDownTimerState = SIPopupCountDownTimerFinished;
    
    SIGame *game = [[SIGame alloc] init];
    
    game.totalScore = 69.0f;
    game.freeCoinsEarned = 2;
    game.isHighScore = NO;
    
    _popupNode.backgroundSize = CGSizeMake(_sceneSize.width - [SIGameController xPaddingPopupContinue], _sceneSize.height - [SIGameController xPaddingPopupContinue]);
    _popupNode.dismissButtonVisible = YES;
    
    for (SKNode *node in ((INSKButtonNode *)_popupNode.bottomNode).nodeNormal.children) {
        if ([node isKindOfClass:[SKLabelNode class]]) {
            ((SKLabelNode *)node).text = NSLocalizedString(kSITextPopupContinueMainMenu, nil);
        }
    }
    for (SKNode *node in ((INSKButtonNode *)_popupNode.bottomNode).nodeHighlighted.children) {
        if ([node isKindOfClass:[SKLabelNode class]]) {
            ((SKLabelNode *)node).text = NSLocalizedString(kSITextPopupContinueMainMenu, nil);
        }
    }
    
    [((INSKButtonNode *)_popupNode.bottomNode) setTouchUpInsideTarget:self selector:@selector(goToMainMenu)];

    ((SKLabelNode *)_popupNode.titleContentNode).text = NSLocalizedString(kSITextPopupContinueGameOver, nil);
    
    _popupNode.centerNode   = nil;
    _popupNode.topNode      = nil;
    
    [self configureGameOverDetailsSpriteNode:_sceneGamePopupGameOverEndNode forGame:game];
    
    _popupNode.topNode              = _sceneGamePopupGameOverEndNode;
    _popupNode.topNode.position     = CGPointMake(0.0f, ((SKLabelNode *)_popupNode.titleContentNode).frame.size.height + (_sceneGamePopupGameOverEndNode.size.height / 2.0f));
    
}

- (void)goToMainMenu {
    NSLog(@"wahooo going to the main menu");
}

- (void)update:(NSTimeInterval)currentTime {
    if ([self modalNodePresented]) {
        if (_popupNode && _popupNode.parent && [_popupNode.topNode isKindOfClass:[SKLabelNode class]]) {
            if (_popupNode.countDownTimerState == SIPopupCountDownTimerNotStarted) {
                _popupNode.startTime = currentTime;
                _popupNode.countDownTimerState = SIPopupCountDownTimerRunning;
            } else if (_popupNode.countDownTimerState == SIPopupCountDownTimerRunning) {
                NSTimeInterval remainingTime = 11.0f - (currentTime - _popupNode.startTime);
                ((SKLabelNode *)_popupNode.topNode).text = [NSString stringWithFormat:@"%i",(int)remainingTime];
                [_popupNode.topNode runAction:[SKAction scaleTo:remainingTime - floorf(remainingTime) duration:0.0f]];
                if (remainingTime < (EPSILON_NUMBER + 1.0f)) {
                    //Call to go to end game
                    [self makePopupBigger];
                    
                }
            }
        }
    }
}

- (void)configureGameOverDetailsSpriteNode:(SKSpriteNode *)spriteNode forGame:(SIGame *)game {
    for (SIPopupGameOverOverDetailsRowNode *row in spriteNode.children) {
        if ([row.name isEqualToString:kSINodePopupRowTotalScore]) {
            row.scoreLabel.text                 = [NSString stringWithFormat:@"%0.2f",game.totalScore];
            row.textLabel.text                  = NSLocalizedString(kSITextMenuEndGameScore, nil);

        } else if ([row.name isEqualToString:kSINodePopupRowHighScore]) {
            if (game.isHighScore) {
                row.textLabel.text              = NSLocalizedString(kSITextMenuEndGameHighScoreNew, nil);
                row.scoreLabel.text             = [NSString stringWithFormat:@"%0.2f",game.totalScore];
                
            } else {
                row.textLabel.text              = NSLocalizedString(kSITextMenuEndGameHighScore, nil);
                row.scoreLabel.text             = [NSString stringWithFormat:@"%0.2f",[[NSUserDefaults standardUserDefaults] floatForKey:kSINSUserDefaultLifetimeHighScore]];
            }
            
        } else if ([row.name isEqualToString:kSINodePopupRowFreeCoins]) {
            row.scoreLabel.text                 = [NSString stringWithFormat:@"%i",game.freeCoinsEarned];
            row.textLabel.text                  = NSLocalizedString(kSITextMenuEndGameFreeCoinsEarned, nil);
            
        }
    }
}

@end
