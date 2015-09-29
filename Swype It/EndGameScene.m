////  EndGameScene.m
////  Swype It
////
////  Created by Andrew Keller on 7/19/15.
////  Copyright © 2015 Push The World LLC. All rights reserved.
////
////
////  Purpose: Thie is the startign screen for the swype it game
////
//// Local Controller Import
//#import "EndGameScene.h"
//#import "SIGameController.h"
//#import "StoreScene.h"
//// Framework Import
//// Drop-In Class Imports (CocoaPods/GitHub/Guru)
//#import "HLSpriteKit.h"
//#import "MKStoreKit.h"
//// Category Import
//#import "UIColor+Additions.h"
//// Support/Data Class Imports
//#import "SIGame.h"
////#import "SIConstants.h"
//// Other Imports
//@interface EndGameScene () <HLMenuNodeDelegate>
//
//#pragma mark - Private Properties
//@property (strong, nonatomic) HLMenuNode    *menuNode;
//@property (strong, nonatomic) SKLabelNode   *gameOverLabel;
//@property (strong, nonatomic) SKLabelNode   *gameScoreLabel;
//@property (strong, nonatomic) SKLabelNode   *highScoreLabel;
//@property (strong, nonatomic) SKLabelNode   *itCoinsLabel;
//@property (strong, nonatomic) SKLabelNode   *userMessageLabel;
//@property (strong, nonatomic) SKSpriteNode  *pauseScreenNode;
//@end
//
//@implementation EndGameScene {
//    BOOL    _shouldRespondToTap;
//    BOOL    _userCanAffordContinue;
//    BOOL    _userCanTap;
//    
//    CGFloat _buttonAnimationDuration;
//    CGFloat _buttonSpacing;
//}
//#pragma mark - Scene Life Cycle
//- (instancetype)initWithSize:(CGSize)size {
//    if (self = [super initWithSize:size]) {
//        /**Do any setup before self.view is loaded*/
//        self.backgroundColor                = [SKColor sandColor];
//        
//    }
//    return self;
//}
//- (void)didMoveToView:(nonnull SKView *)view {
//    [super didMoveToView:view];
//    /**Do any setup post self.view creation*/
//    [self initSetup:view.frame.size];
//    [self viewSetup:view];
//}
//- (void)willMoveFromView:(nonnull SKView *)view {
//    /**Do any breakdown prior to the view being unloaded*/
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    
//    /*Resume move from view*/
//    [super willMoveFromView:view];
//}
//- (void)initSetup:(CGSize)size {
//    /**Preform initalization pre-view load*/
//    [self createConstantsWithSize:size];
//    [self createControlsWithSize:size];
//    [self setupControlsWithSize:size];
//    [self layoutControlsWithSize:size];
//}
//- (void)viewSetup:(SKView *)view {
//    /**Preform setup post-view load*/
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adDidFinish)          name:kSINotificationInterstitialAdFinish        object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continueCoins)        name:kSINotificationGameContinueUseCoins        object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continueLaunchStore)  name:kSINotificationGameContinueUseLaunchStore  object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continueCancel)       name:kSINotificationGameContinueUseCancel       object:nil];
//    
//}
//#pragma mark Scene Setup
//- (void)createConstantsWithSize:(CGSize)size {
//    /**Configure any constants*/
//
////    _buttonSize                             = CGSizeMake(size.width / 1.25f, (size.width / 1.25f) * 0.25f);
//    _buttonSpacing                          = [SIGameController buttonSize:size].height * 0.25f;
//    _buttonAnimationDuration                = 0.5f;
//    
//    _shouldRespondToTap                     = YES;
//
//    
//}
//- (void)createControlsWithSize:(CGSize)size {
//    /**Preform all your alloc/init's here*/
//    _gameOverLabel                          = [SIGameController SI_sharedLabelHeader_x2:@"Game Over!"];
//    _gameScoreLabel                         = [SIGameController SI_sharedLabelParagraph:[NSString stringWithFormat:@"Score: %0.2f", [AppSingleton singleton].currentGame.totalScore]];
//    _itCoinsLabel                           = [SIGameController SI_sharedLabelParagraph:[NSString stringWithFormat:@"Total It Coins: %d",[[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins ] intValue]]];
//    
//    NSNumber *highScore                     = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultLifetimeHighScore];
//
//    if ([AppSingleton singleton].currentGame.isHighScore) {
//        _highScoreLabel                     = [SIGameController SI_sharedLabelParagraph:@"New High Score!"];
//    } else {
//        _highScoreLabel                     = [SIGameController SI_sharedLabelParagraph:[NSString stringWithFormat:@"High Score: %0.2f",[highScore floatValue]]];
//    }
//    
//    if ([AppSingleton singleton].currentGame.isHighScore) {
//        _userMessageLabel                   = [SIGameController SI_sharedLabelParagraph:SIGame userMessageForScore:[AppSingleton singleton].currentGame.totalScore isHighScore:YES    highScore:[highScore floatValue]]];
//        [AppSingleton singleton].currentGame.isHighScore = NO;
//    } else {
//        _userMessageLabel                   = [SIGameController SI_sharedLabelParagraph:SIGame userMessageForScore:[AppSingleton singleton].currentGame.totalScore isHighScore:NO     highScore:[highScore floatValue]]];
//    }
//    
//    /*Menu Node*/
//    _menuNode                               = [[HLMenuNode alloc] init];
//}
//- (void)setupControlsWithSize:(CGSize)size {
//    /**Configrue the labels, nodes and what ever else you can*/
//    
//    /*Menu Node*/
//    _menuNode.delegate                      = self;
//    _menuNode.itemAnimation                 = HLMenuNodeAnimationSlideLeft;
//    _menuNode.itemAnimationDuration         = _buttonAnimationDuration;
//    _menuNode.itemButtonPrototype           = [SIGameController SI_sharedMenuButtonPrototypeBasic:[SIGameController buttonSize:size]];
//    _menuNode.backItemButtonPrototype       = [SIGameController SI_sharedMenuButtonPrototypeBack:[SIGameController buttonSize:size]];
//    _menuNode.itemSeparatorSize             = _buttonSpacing;
//    _menuNode.anchorPoint                   = CGPointMake(0.5, 0);
//}
//- (void)layoutControlsWithSize:(CGSize)size {
//    /**Layout those controls*/
//    _gameOverLabel.position                 = CGPointMake(size.width / 2.0f,
//                                                      size.height - _gameOverLabel.frame.size.height - VERTICAL_SPACING_16);
//    [_gameOverLabel runAction:[SKAction fadeAlphaTo:1.0 duration:0.5]];
//    [self addChild:_gameOverLabel];
//    
//    _gameScoreLabel.position                = CGPointMake(size.width / 2.0f,
//                                                      _gameOverLabel.frame.origin.y - _gameScoreLabel.frame.size.height - VERTICAL_SPACING_8);
//    [_gameScoreLabel runAction:[SKAction fadeAlphaTo:1.0 duration:0.5]];
//    [self addChild:_gameScoreLabel];
//    
//    _itCoinsLabel.position                  = CGPointMake(size.width / 2.0f,
//                                                      _gameScoreLabel.frame.origin.y - (_gameScoreLabel.frame.size.height / 2.0f) - (_itCoinsLabel.frame.size.height / 2.0f) - VERTICAL_SPACING_8);
//    [_itCoinsLabel runAction:[SKAction fadeAlphaTo:1.0 duration:0.5]];
//    [self addChild:_itCoinsLabel];
//    
//    _highScoreLabel.position                = CGPointMake(size.width / 2.0f,
//                                                      _itCoinsLabel.frame.origin.y - (_itCoinsLabel.frame.size.height / 2.0f) - (_highScoreLabel.frame.size.height / 2.0f) - VERTICAL_SPACING_8);
//    [_highScoreLabel runAction:[SKAction fadeAlphaTo:1.0 duration:0.5]];
//    [self addChild:_highScoreLabel];
//
//    _userMessageLabel.position              = CGPointMake(size.width / 2.0f,
//                                                        _highScoreLabel.frame.origin.y - (_userMessageLabel.frame.size.height / 2.0f) - (_userMessageLabel.frame.size.height / 2.0f) - VERTICAL_SPACING_8);
//    [_userMessageLabel runAction:[SKAction fadeAlphaTo:1.0 duration:0.5]];
//    [self addChild:_userMessageLabel];
//    
//    /*Menu Node*/
//    _menuNode.position                      = CGPointMake(size.width / 2.0f,
//                                                          VERTICAL_SPACING_16);
//    [self addChild:_menuNode];
//    [_menuNode hlSetGestureTarget:_menuNode];
//    [self registerDescendant:_menuNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
//    [self menuCreate:size];
//}
//- (void)menuCreate:(CGSize)size {
//    HLMenu *menu                            = [[HLMenu alloc] init];
//    
//    /*Add the regular buttons*/
//    _userCanAffordContinue                  = [self userCanContinue];
//    HLMenuItem *continueGameMenuItem        = [HLMenuItem menuItemWithText:kSITextPopupEndGameContinue];
//    continueGameMenuItem.buttonPrototype    = [SIGameController SI_sharedMenuButtonPrototypeBasic:[SIGameController buttonSize:size] backgroundColor:[SKColor orangeColor] fontColor:[UIColor whiteColor]];
//    [menu addItem:continueGameMenuItem];
////    if (_userCanAffordContinue) {
////        [menu addItem:[HLMenuItem menuItemWithText:kSITextPopupEndGameContinue]];
////    } else {
////        HLMenuItem *continueGameMenuItem = [HLMenuItem menuItemWithText:kSITextPopupEndGameContinue];
////        continueGameMenuItem.buttonPrototype = [SIGameController SI_sharedMenuButtonPrototypeBasic:[SIGameController buttonSize:size] fontSize:[SIGameController fontSizeButton] backgroundColor:[SKColor grayColor] fontColor:[UIColor blackColor]];
////        [menu addItem:continueGameMenuItem];
////    }
//    
//    [menu addItem:[HLMenuItem menuItemWithText:kSITextMenuEndGameReplay]];
//    
//    [menu addItem:[HLMenuItem menuItemWithText:kSITextMenuEndGameStore]];
//    
//    HLMenuItem *mainMenuItem = [HLMenuItem menuItemWithText:kSITextMenuEndGameMainMenu];
//    mainMenuItem.buttonPrototype = [SIGameController SI_sharedMenuButtonPrototypeBack:[SIGameController buttonSize:size]];
//    [menu addItem:mainMenuItem];
//    
//    [self.menuNode setMenu:menu animation:HLMenuNodeAnimationNone];
//}
//
//#pragma mark - HLMenuNodeDelegate
//- (void)menuNode:(HLMenuNode *)menuNode didTapMenuItem:(HLMenuItem *)menuItem itemIndex:(NSUInteger)itemIndex {
//    NSLog(@"Tapped Menu Item [%@] at index %u",menuItem.text,(unsigned)itemIndex);
//    if ([menuItem.text isEqualToString:kSITextPopupEndGameContinue]) {
//        /*Continue Game Button*/
//        NSDictionary *userInfo          = @{kSINSDictionaryKeyCanAfford     : @(_userCanAffordContinue),
//                                            kSINSDictionaryKeyCanAffordCost : @([AppSingleton singleton].currentGame.currentContinueLifeCost)};
//        NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationGameContinueUsePopup object:nil userInfo:userInfo];
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
////        if (_userCanAffordContinue) {
////            [[MKStoreKit sharedKit] consumeCredits:[NSNumber numberWithInteger:[AppSingleton singleton].currentGame.currentContinueLifeCost] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
////            [AppSingleton singleton].willResume                                 = YES;
////            [AppSingleton singleton].currentGame.currentContinueLifeCost  = SIGame lifeCostForCurrentContinueLevel:[AppSingleton singleton].currentGame.currentContinueLifeCost];
////            GameScene *gameScene                                                = [SIGameScene alloc] initWithSize:self.size gameMode:[AppSingleton singleton].currentGame.gameMode];
////            SIGame transisitionToSKScene:gameScene toSKView:self.view DoorsOpen:NO pausesIncomingScene:YES pausesOutgoingScene:NO duration:SCENE_TRANSISTION_DURATION];
////        } else { /*User cannot afford the to contiue*/
////            NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationInterstitialAdShallLaunch object:nil userInfo:nil];
////            [[NSNotificationCenter defaultCenter] postNotification:notification];
////
//////            StoreScene *storeScene                                              = [StoreScene sceneWithSize:self.size];
//////            SIGame transisitionToSKScene:storeScene toSKView:self.view DoorsOpen:YES pausesIncomingScene:NO pausesOutgoingScene:NO duration:SCENE_TRANSISTION_DURATION];
////        }
//
//    } else if ([menuItem.text isEqualToString:kSITextMenuEndGameReplay]) {
//        /*Replay Button*/
//        [[AppSingleton singleton] endGame];
//        SIGame incrementGamesPlayed];
//        GameScene *firstScene               = [SIGameScene alloc] initWithSize:self.size gameMode:[AppSingleton singleton].currentGame.gameMode];
//        SIGame transisitionToSKScene:firstScene toSKView:self.view DoorsOpen:NO pausesIncomingScene:YES pausesOutgoingScene:NO duration:SCENE_TRANSISTION_DURATION];
//
//    } else if ([menuItem.text isEqualToString:kSITextMenuEndGameStore]) {
//        /*Store Button*/
//        StoreScene *storeScene              = [StoreScene sceneWithSize:self.size];
//        SIGame transisitionToSKScene:storeScene toSKView:self.view DoorsOpen:YES pausesIncomingScene:YES pausesOutgoingScene:YES duration:SCENE_TRANSISTION_DURATION];
//        
//    } else if ([menuItem.text isEqualToString:kSITextMenuEndGameMainMenu]) {
//        /*Main Menu Button*/
//        [[AppSingleton singleton] endGame];
//        [SIGame incrementGamesPlayed];
//        StartScreenScene *startScene        = [StartScreenScene sceneWithSize:self.size];
//        SIGame transisitionToSKScene:startScene toSKView:self.view DoorsOpen:NO pausesIncomingScene:YES pausesOutgoingScene:YES duration:SCENE_TRANSISTION_DURATION];
//
//    }
//}
//
//- (BOOL)userCanContinue {
//    int continueCost = SIGame lifeCostForCurrentContinueLevel:[AppSingleton singleton].currentGame.currentContinueLifeCost];
//    int numberOfItCoins = [[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue];
//    if (continueCost <= numberOfItCoins) {
//        return YES;
//    }
//    return NO;
//}
//#pragma mark - Contiue Game Methods
//
//- (void)continueCoins {
//    [[MKStoreKit sharedKit] consumeCredits:[NSNumber numberWithInteger:[AppSingleton singleton].currentGame.currentContinueLifeCost] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
//    [AppSingleton singleton].willResume                                 = YES;
//    [AppSingleton singleton].currentGame.currentContinueLifeCost  = SIGame lifeCostForCurrentContinueLevel:[AppSingleton singleton].currentGame.currentContinueLifeCost];
//    GameScene *gameScene                                                = [SIGameScene alloc] initWithSize:self.size gameMode:[AppSingleton singleton].currentGame.gameMode];
//    SIGame transisitionToSKScene:gameScene toSKView:self.view DoorsOpen:NO pausesIncomingScene:YES pausesOutgoingScene:NO duration:SCENE_TRANSISTION_DURATION];
//}
//
//- (void)continueLaunchStore {
//    StoreScene *storeScene              = [StoreScene sceneWithSize:self.size];
//    SIGame transisitionToSKScene:storeScene toSKView:self.view DoorsOpen:YES pausesIncomingScene:YES pausesOutgoingScene:YES duration:SCENE_TRANSISTION_DURATION];
//}
//
//- (void)adDidFinish {
//    [AppSingleton singleton].willResume                                 = YES;
//    [AppSingleton singleton].currentGame.currentContinueLifeCost  = SIGame lifeCostForCurrentContinueLevel:[AppSingleton singleton].currentGame.currentContinueLifeCost];
//    GameScene *gameScene                                                = [SIGameScene alloc] initWithSize:self.size gameMode:[AppSingleton singleton].currentGame.gameMode];
//    SIGame transisitionToSKScene:gameScene toSKView:self.view DoorsOpen:NO pausesIncomingScene:YES pausesOutgoingScene:NO duration:SCENE_TRANSISTION_DURATION];
//}
//- (void)continueCancel {
//    _shouldRespondToTap =   YES;
//}
//@end