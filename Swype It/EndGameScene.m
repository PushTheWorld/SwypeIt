//  EndGameScene.m
//  Swype It
//
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: Thie is the startign screen for the swype it game
//
// Local Controller Import
#import "AppSingleton.h"
#import "EndGameScene.h"
#import "GameScene.h"
#import "MainViewController.h"
#import "StartScreenScene.h"
#import "StoreScene.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "HLSpriteKit.h"
#import "MKStoreKit.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "Game.h"
//#import "SIConstants.h"
// Other Imports
@interface EndGameScene () <HLMenuNodeDelegate>

#pragma mark - Private Properties
@property (strong, nonatomic) HLMenuNode    *menuNode;
@property (strong, nonatomic) SKLabelNode   *gameOverLabel;
@property (strong, nonatomic) SKLabelNode   *gameScoreLabel;
@property (strong, nonatomic) SKLabelNode   *highScoreLabel;
@property (strong, nonatomic) SKLabelNode   *itCoinsLabel;
@property (strong, nonatomic) SKLabelNode   *userMessageLabel;
@property (strong, nonatomic) SKSpriteNode  *pauseScreenNode;
@end

@implementation EndGameScene {
    BOOL    _userCanAffordContinue;
    CGFloat _buttonAnimationDuration;
    CGFloat _buttonSpacing;
    CGFloat _fontSize;
    CGSize  _buttonSize;
}
#pragma mark - Scene Life Cycle
- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /**Do any setup before self.view is loaded*/
        self.backgroundColor                = [SKColor sandColor];
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
- (void)viewSetup:(SKView *)view {
    /**Preform setup post-view load*/
    
}
#pragma mark Scene Setup
- (void)createConstantsWithSize:(CGSize)size {
    /**Configure any constants*/
    if (IS_IPHONE_4) {
        _fontSize                           = 36.0f;

    } else if (IS_IPHONE_5) {
        _fontSize                           = 40.0f;
        
    } else if (IS_IPHONE_6) {
        _fontSize                           = 44.0f;
        
    } else if (IS_IPHONE_6_PLUS) {
        _fontSize                           = 48.0f;
        
    } else {
        _fontSize                           = 52.0f;
        
    }
    _buttonSpacing                          = (size.width / 2.0f) * 0.25;
    _buttonAnimationDuration                = 0.25f;
}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    _itCoinsLabel                           = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    _gameOverLabel                          = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    _gameScoreLabel                         = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    _highScoreLabel                         = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    _userMessageLabel                       = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    
    /*Menu Node*/
    self.menuNode                           = [[HLMenuNode alloc] init];
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    _gameOverLabel.text                     = @"Game Over!";
    _gameOverLabel.fontColor                = [SKColor blackColor];
    _gameOverLabel.fontSize                 = _fontSize;
    _gameOverLabel.alpha                    = 0.0f;
    
    _gameScoreLabel.text                        = [NSString stringWithFormat:@"Score: %0.2f", [AppSingleton singleton].currentGame.totalScore];
    _gameScoreLabel.fontColor               = [SKColor blackColor];
    _gameScoreLabel.fontSize                = _fontSize - 4.0f;
    _gameScoreLabel.alpha                   = 0.0f;
    
    _itCoinsLabel.text                      = [NSString stringWithFormat:@"Total It Coins: %d",[[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins ] intValue]];
    _itCoinsLabel.fontColor                 = [SKColor blackColor];
    _itCoinsLabel.fontSize                  = _fontSize - 4.0f;
    _itCoinsLabel.alpha                     = 0.0f;
    
    NSNumber *highScore                     = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultLifetimeHighScore];

    if ([AppSingleton singleton].currentGame.isHighScore) {
        _highScoreLabel.text                = @"New High Score!";
    } else {
        _highScoreLabel.text                = [NSString stringWithFormat:@"High Score: %0.2f",[highScore floatValue]];
    }
    _highScoreLabel.fontColor               = [SKColor blackColor];
    _highScoreLabel.fontSize                = _fontSize - 8.0f;
    _highScoreLabel.alpha                   = 0.0f;

    
    if ([AppSingleton singleton].currentGame.isHighScore) {
        _userMessageLabel.text              = [Game userMessageForScore:[AppSingleton singleton].currentGame.totalScore isHighScore:YES    highScore:[highScore floatValue]];
    } else {
        _userMessageLabel.text              = [Game userMessageForScore:[AppSingleton singleton].currentGame.totalScore isHighScore:NO     highScore:[highScore floatValue]];
    }
    _userMessageLabel.fontColor             = [SKColor blackColor];
    _userMessageLabel.fontSize              = _fontSize - 8.0f;
    _userMessageLabel.alpha                 = 0.0f;
    
    /*Menu Node*/
    self.menuNode.delegate                  = self;
    self.menuNode.itemAnimation             = HLMenuNodeAnimationSlideLeft;
    self.menuNode.itemAnimationDuration     = _buttonAnimationDuration;
    self.menuNode.itemButtonPrototype       = [MainViewController SI_sharedMenuButtonPrototypeBasic:_buttonSize fontSize:_fontSize];
    self.menuNode.backItemButtonPrototype   = [MainViewController SI_sharedMenuButtonPrototypeBack:_buttonSize];
    self.menuNode.itemSpacing               = _buttonSpacing;
}
- (void)layoutControlsWithSize:(CGSize)size {
    /**Layout those controls*/
    _gameOverLabel.position                 = CGPointMake(size.width / 2.0f,
                                                      size.height - _gameOverLabel.frame.size.height - VERTICAL_SPACING_16);
    [_gameOverLabel runAction:[SKAction fadeAlphaTo:1.0 duration:0.5]];
    [self addChild:_gameOverLabel];
    
    _gameScoreLabel.position                = CGPointMake(size.width / 2.0f,
                                                      _gameOverLabel.frame.origin.y - _gameScoreLabel.frame.size.height - VERTICAL_SPACING_8);
    [_gameScoreLabel runAction:[SKAction fadeAlphaTo:1.0 duration:0.5]];
    [self addChild:_gameScoreLabel];
    
    _itCoinsLabel.position                  = CGPointMake(size.width / 2.0f,
                                                      _gameScoreLabel.frame.origin.y - (_gameScoreLabel.frame.size.height / 2.0f) - (_itCoinsLabel.frame.size.height / 2.0f) - VERTICAL_SPACING_8);
    [_itCoinsLabel runAction:[SKAction fadeAlphaTo:1.0 duration:0.5]];
    [self addChild:_itCoinsLabel];
    
    _highScoreLabel.position                = CGPointMake(size.width / 2.0f,
                                                      _itCoinsLabel.frame.origin.y - (_itCoinsLabel.frame.size.height / 2.0f) - (_highScoreLabel.frame.size.height / 2.0f) - VERTICAL_SPACING_8);
    [_highScoreLabel runAction:[SKAction fadeAlphaTo:1.0 duration:0.5]];
    [self addChild:_highScoreLabel];

    _userMessageLabel.position              = CGPointMake(size.width / 2.0f,
                                                        _highScoreLabel.frame.origin.y - (_userMessageLabel.frame.size.height / 2.0f) - (_userMessageLabel.frame.size.height / 2.0f) - VERTICAL_SPACING_8);
    [_userMessageLabel runAction:[SKAction fadeAlphaTo:1.0 duration:0.5]];
    [self addChild:_userMessageLabel];
    
    /*Menu Node*/
    _menuNode.position                      = CGPointMake(size.width / 2.0f,
                                                          _userMessageLabel.frame.origin.y - (_userMessageLabel.frame.size.height / 2.0f) - VERTICAL_SPACING_16);
    [self addChild:_menuNode];
    [_menuNode hlSetGestureTarget:_menuNode];
    [self registerDescendant:_menuNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    [self menuCreate];
}
- (void)menuCreate {
    HLMenu *menu = [[HLMenu alloc] init];
    
    /*Add the regular buttons*/
    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextEndGameContinue]];
    
    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextEndGameReplay]];
    
    [menu addItem:[HLMenuItem menuItemWithText:kSIMenuTextEndGameStore]];
    
    HLMenuItem *mainMenuItem = [HLMenuItem menuItemWithText:kSIMenuTextEndGameMainMenu];
    mainMenuItem.buttonPrototype = [MainViewController SI_sharedMenuButtonPrototypeBasic:_buttonSize fontSize:_fontSize backgroundColor:[UIColor blueColor] fontColor:[UIColor whiteColor]];
    [menu addItem:mainMenuItem];
    
    [self.menuNode setMenu:menu animation:HLMenuNodeAnimationNone];
}
- (void)showCanNotAfford {
    HLMenuNode *menuNode                    = [[HLMenuNode alloc] init];
    
    menuNode.position                       = CGPointMake(self.frame.size.width, self.frame.size.height);
    menuNode.delegate                       = self;
    menuNode.itemSpacing                    = _buttonSpacing;
    [menuNode.menu addItem:[HLMenu menuWithText:@"Buy More Coins" items:@[] ]];
    [menuNode.menu addItem:[HLMenu menuWithText:@"Cancel" items:@[] ]];
    
    [self presentModalNode:menuNode animation:HLScenePresentationAnimationFade];
}
#pragma mark - HLMenuNodeDelegate
- (void)menuNode:(HLMenuNode *)menuNode didTapMenuItem:(HLMenuItem *)menuItem itemIndex:(NSUInteger)itemIndex {
    NSLog(@"Tapped Menu Item [%@] at index %u",menuItem.text,(unsigned)itemIndex);

    if ([menuItem.text isEqualToString:kSIMenuTextEndGameContinue]) {
        /*Continue Game Button*/
        if (_userCanAffordContinue) {
            [[MKStoreKit sharedKit] consumeCredits:[NSNumber numberWithInteger:[AppSingleton singleton].currentGame.currentNumberOfTimesContinued] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
            [AppSingleton singleton].willResume                                 = YES;
            [AppSingleton singleton].currentGame.currentNumberOfTimesContinued  = [Game lifeCostForCurrentContinueLeve:[AppSingleton singleton].currentGame.currentNumberOfTimesContinued];
            GameScene *gameScene                                                = [[GameScene alloc] initWithSize:self.size gameMode:[AppSingleton singleton].currentGame.gameMode];
            [Game transisitionToSKScene:gameScene toSKView:self.view DoorsOpen:NO pausesIncomingScene:YES pausesOutgoingScene:NO duration:1.0];
        } else { /*User cannot afford the to contiue*/
            StoreScene *storeScene                                              = [StoreScene sceneWithSize:self.size];
            [Game transisitionToSKScene:storeScene toSKView:self.view DoorsOpen:YES pausesIncomingScene:NO pausesOutgoingScene:NO duration:1.0];
        }

    } else if ([menuItem.text isEqualToString:kSIMenuTextEndGameReplay]) {
        /*Replay Button*/
        [[AppSingleton singleton] endGame];
        [Game incrementGamesPlayed];
        GameScene *firstScene               = [[GameScene alloc] initWithSize:self.size gameMode:[AppSingleton singleton].currentGame.gameMode];
        [Game transisitionToSKScene:firstScene toSKView:self.view DoorsOpen:NO pausesIncomingScene:YES pausesOutgoingScene:NO duration:1.0];

    } else if ([menuItem.text isEqualToString:kSIMenuTextEndGameStore]) {
        /*Store Button*/
        StoreScene *storeScene              = [StoreScene sceneWithSize:self.size];
        [Game transisitionToSKScene:storeScene toSKView:self.view DoorsOpen:YES pausesIncomingScene:NO pausesOutgoingScene:NO duration:1.0];
        
    } else if ([menuItem.text isEqualToString:kSIMenuTextEndGameMainMenu]) {
        /*Main Menu Button*/
        [[AppSingleton singleton] endGame];
        [Game incrementGamesPlayed];
        StartScreenScene *startScene        = [StartScreenScene sceneWithSize:self.size];
        [Game transisitionToSKScene:startScene toSKView:self.view DoorsOpen:NO pausesIncomingScene:NO pausesOutgoingScene:NO duration:1.0];

    }
}


@end