//  GameScene.m
//  Swype It
//
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is the main game scene
//
// Defines
#define ACCELEROMETER_UPDATE_INTERVAL   0.05
#define REST_COUNT_THRESHOLD            2
#define SHAKE_THRESHOLD                 0.5
#define LAUNCH_DX_VECTOR_MAX            25
#define LAUNCH_DX_VECTOR_MIX            10
#define LAUNCH_DY_MULTIPLIER            50
#define MONKEY_SPEED_INCREASE           0.1
// Local Controller Import
#import "AppSingleton.h"
#import "EndGameScene.h"
#import "GameScene.h"
#import "MainViewController.h"
#import "SIGameNode.h"
#import "TCProgressBarNode.h"
// Framework Import
#import <CoreMotion/CoreMotion.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "HLGestureTarget.h"
#import "MKStoreKit.h"
// Category Import
#import "SKNode+HLGestureTarget.h"
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "Game.h"
// Other Imports

@interface GameScene () <HLToolbarNodeDelegate, SIGameNodeDelegate> {
    
}
#pragma mark - Private Properties

#pragma mark - Constraints

#pragma mark - UI Controls
@property (strong, nonatomic) TCProgressBarNode *progressBarFreeCoin;
@property (strong, nonatomic) TCProgressBarNode *progressBarMove;
@property (strong, nonatomic) TCProgressBarNode *progressBarPowerUp;
@property (strong, nonatomic) HLLabelButtonNode *itCoinsButtonLabel;
@property (strong, nonatomic) SKLabelNode       *moveCommandLabel;
@property (strong, nonatomic) SKLabelNode       *totalScoreLabel;
@property (strong, nonatomic) SKSpriteNode      *pauseNode;
@property (strong, nonatomic) SKSpriteNode      *playNode;
@property (strong, nonatomic) SKSpriteNode      *pauseScreenNode;
//@property (strong, nonatomic) SKSpriteNode      *rapidFireNode;
//@property (strong, nonatomic) SKSpriteNode      *fallingMonkeysNode;
//@property (strong, nonatomic) SKSpriteNode      *timeFreezeNode;
@property (strong, nonatomic) UIFont            *powerUpButtonFont;
@property (strong, nonatomic) UIFont            *nextMoveCommandFont;
@property (strong, nonatomic) UIFont            *moveCommandFont;
@property (strong, nonatomic) UIFont            *totalScoreFont;
@property (strong, nonatomic) UILabel           *currentLevelLabel;


@end

static const uint32_t monkeyCategory        = 0x1;      // 00000000000000000000000000000001
static const uint32_t uiControlCategory     = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t bottomEdgeCategory    = 0x1 << 2; // 00000000000000000000000000000100
static const uint32_t sideEdgeCategory      = 0x1 << 3; // 00000000000000000000000000001000

enum {
    SIGameNodeZPositionLayerBackground = 0,
    SIGameNodeZPositionLayerCoinBar,
    SIGameNodeZPositionLayerCoinBarDetail
};

@implementation GameScene {
    BOOL                                     _isButtonTouched;
    BOOL                                     _isGameActive;
    BOOL                                     _isShakeActive;
    BOOL                                     _isHighScoreShowing;

    CGFloat                                  _progressBarCornerRadius;
    CGFloat                                  _fontSizeProgessView;
    CGFloat                                  _fontSize;
    CGFloat                                  _menuBarHeight;
    CGFloat                                  _monkeySpeed;

    CGSize                                   _backgroundSize;
    CGSize                                   _buttonSize;
    CGSize                                   _coinSize;
    CGSize                                   _fallingMonkeySize;
    CGSize                                   _progressBarSize;
    CGSize                                   _progressBarSizeFreeCoin;

    CGPoint                                  _leftButtonCenterPoint;

    int                                      _gameMode;

    NSInteger                                _restCount;
    
    SKSpriteNode                            *_coin;
    SIGameNode                              *_backgroundNode;
    HLTiledNode                             *_menuBackground;
    HLToolbarNode                           *_powerUpToolBar;
    
}

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self setupDefaults:size gameMode:SIGameModeTwoHand];
    }
    return self;
}
- (instancetype)initWithSize:(CGSize)size gameMode:(SIGameMode)gameMode {
    if (self = [super initWithSize:size]) {
        [self setupDefaults:size gameMode:gameMode];
    }
    return self;
}
- (void)setupDefaults:(CGSize)size gameMode:(SIGameMode)gameMode {
    _gameMode                       = gameMode;
    _isButtonTouched                = NO;
    
    self.physicsWorld.contactDelegate   = self;
    
    
}

- (void)didMoveToView:(nonnull SKView *)view {
//    [self setupGestureRecognizersWithView:view];
//    self.backgroundColor                = [[AppSingleton singleton] newBackgroundColor];
    [self setupUserInterfaceWithSize:view.frame.size];
    [_powerUpToolBar layoutToolsAnimation:HLToolbarNodeAnimationNone];
}
- (void)willMoveFromView:(nonnull SKView *)view {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super willMoveFromView:view];
}

#pragma mark - UI Life Cycle Methods
- (void)setupUserInterfaceWithSize:(CGSize)size {
    [self createConstantsWithSize:size];
    [self createControlsWithSize:size];
    [self setupControlsWithSize:size];
    [self layoutControlsWithSize:size];
    [self registerForNotifications];
    [self addBottomEdge:size];
    [self addSideEdges:size];
}
- (void)createConstantsWithSize:(CGSize)size {
    if (IS_IPHONE_4) {
        _fontSize                   = 20.0f;
        _fallingMonkeySize          = CGSizeMake(100.0, 100.0);

    } else if (IS_IPHONE_5) {
        _fontSize                   = 24.0f;
        _fallingMonkeySize          = CGSizeMake(130.0, 130.0);
        
    } else if (IS_IPHONE_6) {
        _fontSize                   = 28.0f;
        _fallingMonkeySize          = CGSizeMake(150.0, 150.0);
        
    } else if (IS_IPHONE_6_PLUS) {
        _fontSize                   = 32.0f;
        _fallingMonkeySize          = CGSizeMake(180.0, 180.0);

    } else {
        _fontSize                   = 36.0f;
        _fallingMonkeySize          = CGSizeMake(200.0, 200.0);
        
    }
    _buttonSize                     = CGSizeMake(size.width/5.0, size.width/5.0f);

    _progressBarSize                = CGSizeMake(size.width / 2.0f, (size.width / 2.0f) * 0.2);
    _progressBarSizeFreeCoin        = CGSizeMake(size.width / 2.0f, (size.width / 2.0f) * 0.2);
    _progressBarCornerRadius        = 12.0f;
    _fontSizeProgessView            = _fontSize - 6.0f;
    _coinSize                       = CGSizeMake(_progressBarSizeFreeCoin.height, _progressBarSizeFreeCoin.height);
    _menuBarHeight                  = VERTICAL_SPACING_4 +  _progressBarSizeFreeCoin.height + VERTICAL_SPACING_8 + _buttonSize.height + VERTICAL_SPACING_4;
    _backgroundSize                 = CGSizeMake(size.width, size.height - _menuBarHeight);
    
    /*Init Fonts*/
    _powerUpButtonFont              = [UIFont fontWithName:kSIFontFuturaMedium size:_fontSize - 4.0f];
    _nextMoveCommandFont            = [UIFont fontWithName:kSIFontFuturaMedium size:_fontSize - 4.0f];
    _moveCommandFont                = [UIFont fontWithName:kSIFontFuturaMedium size:_fontSize];
    _totalScoreFont                 = [UIFont fontWithName:kSIFontFuturaMedium size:_fontSize * 2.0f];

    _isHighScoreShowing             = NO;
}
- (void)createControlsWithSize:(CGSize)size {
    /**Background*/
    _backgroundNode         = [[SIGameNode alloc] initWithSize:_backgroundSize gameMode:_gameMode];
    
    /**Labels*/
    /*Total Score Label*/
    _totalScoreLabel        = [SKLabelNode labelNodeWithFontNamed:kSIFontGameScore];
    
    /*Move Command Label*/
    _moveCommandLabel       = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    
    /*It Coins Label*/
    _itCoinsButtonLabel     = [[HLLabelButtonNode alloc] initWithColor:[SKColor clearColor]
                                                                  size:CGSizeMake(_progressBarSizeFreeCoin.width - VERTICAL_SPACING_4 - _coinSize.width - VERTICAL_SPACING_4,
                                                                                  _progressBarSizeFreeCoin.height)];
    
    /**Progress Bars*/
    /*Free Coin Progress Bar Sprite*/
    _progressBarFreeCoin    = [[TCProgressBarNode alloc]
                                   initWithSize:_progressBarSizeFreeCoin
                                   backgroundColor:[UIColor lightGrayColor]
                                   fillColor:[UIColor goldColor]
                                   borderColor:[UIColor blackColor]
                                   borderWidth:2.0f
                                   cornerRadius:4.0f];
    /*Move Progress Bar Sprite*/
    _progressBarMove        = [[TCProgressBarNode alloc]
                                   initWithSize:_progressBarSize
                                   backgroundColor:[UIColor grayColor]
                                   fillColor:[UIColor redColor]
                                   borderColor:[UIColor blackColor]
                                   borderWidth:1.0f
                                   cornerRadius:4.0f];

    
    /*Power Up Progress Bar Sprite*/
    _progressBarPowerUp     = [[TCProgressBarNode alloc]
                                   initWithSize:_progressBarSize
                                   backgroundColor:[UIColor grayColor]
                                   fillColor:[UIColor greenColor]
                                   borderColor:[UIColor blackColor]
                                   borderWidth:1.0f
                                   cornerRadius:4.0f];
    
    /**Toolbar*/
    _powerUpToolBar         = [self createPowerUpToolbarNode:size];
    
    /**Images*/
    _coin                   = [SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageButtonCoinSmall] size:_coinSize];

    _menuBackground         = [HLTiledNode tiledNodeWithTexture:[SKTexture textureWithImageNamed:@"diamondPlate3"] size:CGSizeMake(size.width, _menuBarHeight)]; //[SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageBackgroundDiamondPlate] size:CGSizeMake(size.width, _menuBarHeight)];
    
    /**Buttons*/
    _pauseNode              = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonPause] size:_buttonSize];

    _playNode               = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonPlay] size:_buttonSize];

}
- (void)setupControlsWithSize:(CGSize)size {
    /**Background*/
    _backgroundNode.anchorPoint                         = CGPointMake(0.0f, 0.0f);
    _backgroundNode.physicsBody.categoryBitMask         = uiControlCategory;
    _backgroundNode.zPosition                           = SIGameNodeZPositionLayerBackground;
    _backgroundNode.backgroundColor                     = [[AppSingleton singleton] newBackgroundColor];
    _backgroundNode.delegate                            = self;
    [_backgroundNode hlSetGestureTarget:_backgroundNode];
    
    /**Labels*/
    /*Total Score Label*/
    _totalScoreLabel.text                               = @"0.00";
    _totalScoreLabel.fontColor                          = [SKColor whiteColor];
    _totalScoreLabel.fontSize                           = [MainViewController fontSizeHeader_x3]+10;
    _totalScoreLabel.physicsBody.categoryBitMask        = uiControlCategory;
    
    /*Move Command Label*/
    _moveCommandLabel.text                              = [Game stringForMove:[AppSingleton singleton].currentGame.currentMove];
    _moveCommandLabel.fontColor                         = [SKColor whiteColor];
    _moveCommandLabel.fontSize                          = [MainViewController fontSizeHeader_x3];
    _moveCommandLabel.physicsBody.categoryBitMask       = uiControlCategory;
    _moveCommandLabel.userInteractionEnabled            = NO;
    
    /*Move Progress Bar Sprite*/
    _progressBarMove.progress                           = 1.0f;
    _progressBarMove.physicsBody.categoryBitMask        = uiControlCategory;
    
    /*Power Up Progress Bar Sprite*/
    _progressBarPowerUp.progress                        = 1.0f;
    _progressBarPowerUp.titleLabelNode.fontSize         = [MainViewController fontSizeText_x2];
    _progressBarPowerUp.titleLabelNode.fontName         = kSIFontUltra;
    _progressBarPowerUp.titleLabelNode.fontColor        = [SKColor whiteColor];
    _progressBarPowerUp.physicsBody.categoryBitMask     = uiControlCategory;
    
    _pauseNode.name                                     = kSINodeButtonPause;
    _pauseNode.physicsBody.categoryBitMask              = uiControlCategory;

    _playNode.name                                      = kSINodeButtonPlay;
    _playNode.zPosition                                 = SIGameNodeZPositionLayerCoinBarDetail;
    _playNode.physicsBody.categoryBitMask               = uiControlCategory;
    
    /**Power Up Toobar*/
    _powerUpToolBar.delegate                            = self;
    _powerUpToolBar.physicsBody.categoryBitMask         = uiControlCategory;
    _powerUpToolBar.zPosition                           = SIGameNodeZPositionLayerCoinBarDetail;
    
    /**Coin Bars*/
    _menuBackground.physicsBody.categoryBitMask         = uiControlCategory;
    _menuBackground.anchorPoint                         = CGPointMake(0.0f, 0.0f);
    _menuBackground.zPosition                           = SIGameNodeZPositionLayerCoinBar;


    /*Free Coin Progress Bar Sprite*/
    NSNumber *freeCoinNumber                                = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultPointsTowardsFreeCoin];
    //    float freeCoinIn                                        = POINTS_NEEDED_FOR_FREE_COIN - [freeCoinNumber floatValue];
    _progressBarFreeCoin.titleLabelNode.text            = @"Free Coin Meter"; //[NSString stringWithFormat:@"IT Coin In %0.2f Points", freeCoinIn];
    _progressBarFreeCoin.titleLabelNode.fontSize        = [MainViewController fontSizeText];
    _progressBarFreeCoin.titleLabelNode.fontName        = kSIFontUltra;
    _progressBarFreeCoin.titleLabelNode.fontColor       = [SKColor blackColor];
    _progressBarFreeCoin.progress                       = [freeCoinNumber floatValue] / POINTS_NEEDED_FOR_FREE_COIN;
    _progressBarFreeCoin.physicsBody.categoryBitMask    = uiControlCategory;
    _progressBarFreeCoin.zPosition                      = SIGameNodeZPositionLayerCoinBarDetail;

    
    _coin.physicsBody.categoryBitMask                   = uiControlCategory;
    _coin.zPosition                                     = SIGameNodeZPositionLayerCoinBarDetail;
    _coin.anchorPoint                                   = CGPointMake(0.0f, 0.0f);
    
    /*It Coins Label*/
    _itCoinsButtonLabel.text                            = [NSString stringWithFormat:@"x%d",[[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue]];
    _itCoinsButtonLabel.fontColor                       = [SKColor blackColor];
    _itCoinsButtonLabel.fontSize                        = _coinSize.height * 0.66;
    _itCoinsButtonLabel.fontName                        = kSIFontUltra;
    _itCoinsButtonLabel.verticalAlignmentMode           = HLLabelNodeVerticalAlignFont;
    _itCoinsButtonLabel.automaticWidth                  = YES;
    _itCoinsButtonLabel.labelPadX                       = 4.0f;
    _itCoinsButtonLabel.zPosition                       = SIGameNodeZPositionLayerCoinBarDetail;
    _itCoinsButtonLabel.physicsBody.categoryBitMask     = uiControlCategory;
    _itCoinsButtonLabel.cornerRadius                    = 4.0f;
//    _itCoinsButtonLabel.borderColor                     = [SKColor blackColor];
//    _itCoinsButtonLabel.borderWidth                     = 4.0f;
    _itCoinsButtonLabel.anchorPoint                     = CGPointMake(0, 0);


    SKAction *initFadeOut = [SKAction fadeOutWithDuration:0.0f];
    if ([AppSingleton singleton].willResume == NO) {
        [_progressBarMove       runAction:initFadeOut];
        [_progressBarPowerUp    runAction:initFadeOut];
        [_pauseNode             runAction:initFadeOut];
        [_totalScoreLabel       runAction:initFadeOut];
        [_menuBackground        runAction:initFadeOut];
    } else {
        [_progressBarPowerUp    runAction:initFadeOut];
    }
}
- (void)layoutControlsWithSize:(CGSize)size {
    _backgroundNode.position                            = CGPointMake(0.0, _menuBarHeight);
    [self addChild:_backgroundNode];
    [self registerDescendant:_backgroundNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    
    /**Labels*/
    /*Total Score Label*/
    _totalScoreLabel.position       = CGPointMake((size.width / 2.0f),
                                                      size.height - (_totalScoreLabel.frame.size.height) - VERTICAL_SPACING_8);
    [self addChild:_totalScoreLabel];

    /*Move Command Label*/
    _moveCommandLabel.position      = CGPointMake((size.width / 2.0f),
                                                      size.height / 2.0f);
    [self addChild:_moveCommandLabel];
    
    
    _pauseNode.position             = CGPointMake(size.width - (_pauseNode.frame.size.width / 2.0f) - VERTICAL_SPACING_8,
                                                      size.height - (_progressBarSizeFreeCoin.height) - (_pauseNode.frame.size.height / 2.0f) - VERTICAL_SPACING_8);
    [self addChild:_pauseNode];
    HLTapGestureTarget *pauseGestureTarget = [[HLTapGestureTarget alloc] init];
    pauseGestureTarget.handleGestureBlock = ^(UIGestureRecognizer *gestureRecognizer) {
        [self pause];
    };
    [_pauseNode hlSetGestureTarget:pauseGestureTarget];
    [self registerDescendant:_pauseNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    
    _playNode.position              = CGPointMake(size.width  / 2.0f,
                                                      size.height / 2.0f);
    [_playNode runAction:[SKAction fadeAlphaTo:0.0 duration:0.0]];
    [self addChild:_playNode];
    HLTapGestureTarget *playGestureTarget = [[HLTapGestureTarget alloc] init];
    playGestureTarget.handleGestureBlock = ^(UIGestureRecognizer *gestureRecognizer) {
        [self play];
    };
    [_playNode hlSetGestureTarget:playGestureTarget];
    [self registerDescendant:_playNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    
    
    /**Progress Bars*/
    /*Move Progress Bar Sprite*/
    _progressBarMove.position       = CGPointMake(CGRectGetMidX(self.frame),
                                                      (size.height / 2.0f) - _moveCommandLabel.frame.size.height);
    [self addChild:_progressBarMove];
    
    /*Power Up Progress Bar Sprite*/
    _progressBarPowerUp.position    = CGPointMake(CGRectGetMidX(self.frame),
                                                      _moveCommandLabel.frame.size.height + _progressBarSize.height + VERTICAL_SPACING_16);
    [self addChild:_progressBarPowerUp];
    
    
    /**Coin Bar*/
    _menuBackground.position       = CGPointMake(0.0f,0.0f);
    [self addChild:_menuBackground];
    
    /**Power Up Toolbar*/
    _powerUpToolBar.position        = CGPointMake(0.0f, VERTICAL_SPACING_4 + _progressBarSizeFreeCoin.height + VERTICAL_SPACING_4 + VERTICAL_SPACING_4);
    [_menuBackground addChild:_powerUpToolBar];
    [_powerUpToolBar hlSetGestureTarget:_powerUpToolBar];
    [self registerDescendant:_powerUpToolBar withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    
    _coin.position                  = CGPointMake(VERTICAL_SPACING_4, VERTICAL_SPACING_4);
    [_menuBackground addChild:_coin];
    
    /*IT Coins Label*/
    _itCoinsButtonLabel.position          = CGPointMake(VERTICAL_SPACING_4 + _coinSize.width + VERTICAL_SPACING_4,
                                                  VERTICAL_SPACING_4);
    [_menuBackground addChild:_itCoinsButtonLabel];
    
    /*Move Progress Bar Sprite*/
    _progressBarFreeCoin.position   = CGPointMake((size.width / 4.0f) * 3.0f - VERTICAL_SPACING_4,
                                                  VERTICAL_SPACING_4 + (_progressBarSizeFreeCoin.height / 2.0f));
    [_menuBackground addChild:_progressBarFreeCoin];

    
    
}
- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scoreUpdate)              name:kSINotificationScoreUpdate             object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameStarted)              name:kSINotificationGameStarted             object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameEnded)                name:kSINotificationGameEnded               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(correctMoveEntered:)      name:kSINotificationCorrectMove             object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(powerUpActivated)         name:kSINotificationPowerUpActive           object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(levelDidChange)           name:kSINotificationLevelDidChange          object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freeCoinEarned)           name:kSINotificationFreeCoinEarned          object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newHighScore)             name:kSINotificationNewHighScore            object:nil];
    
}
//- (void)setupGestureRecognizersWithView:(SKView *)view {
//    /*Both Game modes get tap*/
//    UITapGestureRecognizer *tap         = [[UITapGestureRecognizer alloc] init];
//    tap.numberOfTapsRequired            = 1;
//
//    /*Both Game modes get swype*/
//    UISwipeGestureRecognizer *swype     = [[UISwipeGestureRecognizer alloc] init];
//    swype.direction                     = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
//
//    
//    if (_gameMode == SIGameModeOneHand) {
//        /*Setup Shake recognizer*/
//        _restCount                                  = 0;
//        _isShakeActive                              = NO;
//        [self startAccelerometerForShake];
//        
//        
//        
////        [_backgroundNode hlSetGestureTarget:_backgroundNode];
//        
//        
//        [self needSharedGestureRecognizers:@[tap,swype]];
//        
//    } else {
//        /*Setup up pinch recognizer*/
//        UIGestureRecognizer *pinch                                      = [[UIPinchGestureRecognizer alloc] init];
//        [pinch addTarget:self action:@selector(pinchRegistered:)];
////        [_view addGestureRecognizer:pinch];
//        [self needSharedGestureRecognizers:@[tap,swype,pinch]];
//    }
//}
//- (BOOL)gestureRecognizer:(nonnull UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch {
////    CGPoint viewLocation = [touch locationInView:_view];
////    CGPoint sceneLocation = [self convertPointFromView:viewLocation];
//    
//    [self checkIfGameShallStartOrResume];
//    
//    // Modal overlay layer (handled by HLScene).
//    if ([self modalNodePresented]) {
//        return [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
//    }
//    NSLog(@"GR: - %@",gestureRecognizer);
//    //World
//    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
//        [gestureRecognizer removeTarget:nil action:NULL];
//        [gestureRecognizer addTarget:self action:@selector(tapRegistered:)];
//        return YES;
//    } else if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
//        [gestureRecognizer removeTarget:nil action:NULL];
//        [gestureRecognizer addTarget:self action:@selector(pinchRegistered:)];
//        return YES;
//    } else if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
//        [gestureRecognizer removeTarget:nil action:NULL];
//        [gestureRecognizer addTarget:self action:@selector(swypeRegistered:)];
//        return YES;
//    }
//    return YES;
//}

- (void)checkIfGameShallStartOrResume {
    if ([AppSingleton singleton].currentGame.isStarted == NO) {
        [AppSingleton singleton].currentGame.isStarted = YES;
        [[AppSingleton singleton] startGame];
        
        SKAction *fadeIn = [SKAction fadeInWithDuration:0.5f];
//        [_progressBarFreeCoin   runAction:fadeIn];
        [_progressBarMove       runAction:fadeIn];
        [_pauseNode             runAction:fadeIn];
        [_totalScoreLabel       runAction:fadeIn];
        [_menuBackground        runAction:fadeIn];
        
    } else if ([AppSingleton singleton].willResume) {
        [AppSingleton singleton].willResume = NO;
        [[AppSingleton singleton] play];
        [self gameResume];
//        [[AppSingleton singleton] willPrepareToShowNewMove];
        
//        SKAction *fadeIn = [SKAction fadeInWithDuration:0.7f];
//        [self.progressBarFreeCoin runAction:fadeIn];
//        [self.progressBarMove runAction:fadeIn];
    } else {
//        NSLog(@"Normal");
    }
}

- (void)addBottomEdge:(CGSize)size {
    SKNode *bottomEdge                          = [SKNode node];
    bottomEdge.physicsBody                      = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 1) toPoint:CGPointMake(size.width, 1)];
    bottomEdge.physicsBody.categoryBitMask      = bottomEdgeCategory;
    bottomEdge.physicsBody.collisionBitMask     = 0;
    [self addChild:bottomEdge];
}
- (void)addSideEdges:(CGSize) size {
    SKNode *leftEdge                            = [SKNode node];
    leftEdge.physicsBody                        = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(-1.0f * (_fallingMonkeySize.width / 2.0f), 0)
                                                                               toPoint:CGPointMake(-1.0f * (_fallingMonkeySize.width / 2.0f), size.height)];
    leftEdge.physicsBody.categoryBitMask        = sideEdgeCategory;
    leftEdge.physicsBody.collisionBitMask       = sideEdgeCategory;
    [self addChild:leftEdge];
    
    SKNode *rightEdge                           = [SKNode node];
    rightEdge.physicsBody                       = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(size.width + (_fallingMonkeySize.width / 2.0f), 0)
                                                                                toPoint:CGPointMake(size.width + (_fallingMonkeySize.width / 2.0f), size.height)];
    rightEdge.physicsBody.categoryBitMask       = sideEdgeCategory;
    rightEdge.physicsBody.collisionBitMask      = sideEdgeCategory;
    [self addChild:rightEdge];
}
- (HLToolbarNode *)createPowerUpToolbarNode:(CGSize)size {
    HLToolbarNode *toolbarNode          = [[HLToolbarNode alloc] init];
    toolbarNode.automaticHeight         = NO;
    toolbarNode.automaticWidth          = NO;
    toolbarNode.backgroundBorderSize    = 0.0f;
    toolbarNode.squareSeparatorSize     = 4.0f;
    toolbarNode.toolPad                 = 2.0f;
    toolbarNode.backgroundColor         = [UIColor clearColor];
    toolbarNode.anchorPoint             = CGPointMake(0.0f, 0.0f);
    toolbarNode.size                    = CGSizeMake(size.width, _buttonSize.height);
    
    NSMutableArray *toolNodes   = [NSMutableArray array];
    NSMutableArray *toolTags    = [NSMutableArray array];
    
    SKSpriteNode *timeFreeze    = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonTimeFreeze] size:_buttonSize];
    [toolNodes  addObject:timeFreeze];
    [toolTags   addObject:kSINodeButtonTimeFreeze];
    
    SKSpriteNode *rapidFire     = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonRapidFire] size:_buttonSize];
    [toolNodes addObject:rapidFire];
    [toolTags addObject:kSINodeButtonRapidFire];
    
    SKSpriteNode *fallingMonkey = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonFallingMonkey] size:_buttonSize];
    [toolNodes addObject:fallingMonkey];
    [toolTags addObject:kSINodeButtonFallingMonkey];
    
    [toolbarNode setTools:toolNodes tags:toolTags animation:HLToolbarNodeAnimationSlideUp];
    return toolbarNode;
}
#pragma mark - SIGameNode delegate
- (void)gestureEnded:(SIMove)move {
    [self checkIfGameShallStartOrResume];
    if ([AppSingleton singleton].currentGame.isPaused == NO) {
        [[AppSingleton singleton] moveEnterForType:move];
    }
}
#pragma mark - Gesture Recognizer Methods
//- (void)tapRegistered:(UITapGestureRecognizer *)tapGestrureRecognizer {
//    CGPoint locationInView = [tapGestrureRecognizer locationInView:self.view];
//    CGPoint locationInScene = [self convertPointFromView:locationInView];
//    SKNode *node = [self nodeAtPoint:locationInScene];
//    
//    if ([AppSingleton singleton].currentGame.isPaused) {
//        if ([node.name isEqualToString:kSINodeButtonPlay]) {
//            [self play];
//        }
//    } else {
//        if ([node.name isEqualToString:kSINodeButtonPause]) {
//            [self pause];
//            
//        } else {
//            if (_isButtonTouched == NO) {
//                if (tapGestrureRecognizer.state == UIGestureRecognizerStateEnded) {
//                    [[AppSingleton singleton] moveEnterForType:SIMoveTap];
//                }
//            }
//        }
//    }
//
//}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch          = [touches anyObject];
//    CGPoint location        = [touch locationInNode:self];
//    SKNode *node            = [self nodeAtPoint:location];
//    
//    if ([AppSingleton singleton].currentGame.isPaused) {
//        if ([node.name isEqualToString:kSINodeFallingMonkey]) {
//            [self monkeyWasTapped:node];
//        }
//    }
//}

//- (void)swypeRegistered:(UISwipeGestureRecognizer *)swypeGestrureRecognizer {
//    if ([AppSingleton singleton].currentGame.isPaused == NO) {
//        if (swypeGestrureRecognizer.state == UIGestureRecognizerStateEnded) {
//            [[AppSingleton singleton] moveEnterForType:SIMoveSwype];
//        }
//    }
//    
//}
//- (void)pinchRegistered:(UIPinchGestureRecognizer *)pinchGestrureRecognizer {
//    if ([AppSingleton singleton].currentGame.isPaused == NO) {
//        if (pinchGestrureRecognizer.state == UIGestureRecognizerStateEnded) {
//            [[AppSingleton singleton] moveEnterForType:SIMovePinch];
//        }
//    }
//}
- (void)shakeRegistered {
    if ([AppSingleton singleton].currentGame.isPaused == NO) {
        [[AppSingleton singleton] moveEnterForType:SIMoveShake];
    }
}
#pragma mark - Accelerometer Methods
- (void)startAccelerometerForShake {
    if ([[AppSingleton singleton].manager isAccelerometerAvailable]) {
        [AppSingleton singleton].manager.accelerometerUpdateInterval = ACCELEROMETER_UPDATE_INTERVAL; /*Get reading 20 times a second*/
        [[AppSingleton singleton].manager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                double magnitude                = sqrt(pow(accelerometerData.acceleration.x, 2) + pow(accelerometerData.acceleration.y, 2) + pow(accelerometerData.acceleration.z, 2));
                
                /*Adjust the magnititude*/
                double adjustedMag              = fabs(magnitude - 1.0);
                
                if (adjustedMag > SHAKE_THRESHOLD) { /*Phone is Shaken*/
                    if (_isShakeActive) {
                        _restCount          = 0;
                    } else {
                        _isShakeActive      = YES;
                        [self shakeRegistered];
                    }
                } else { /*Phone is at rest*/
                    if (_isShakeActive) {
                        _restCount          = _restCount + 1;
                        if (_restCount > REST_COUNT_THRESHOLD) {
                            _isShakeActive  = NO;
                            _restCount      = 0;
                        }
                    }
                }
            });
        }];
    } else {
        NSLog(@"Accelerometer Not Available!");
    }
}
#pragma mark - Notification Methods
- (void)gameResume {
    _moveCommandLabel.fontColor         = [SKColor whiteColor];
    if ([AppSingleton singleton].currentGame.gameMode == SIGameModeOneHand) {
        /*Setup Shake recognizer*/
        _restCount                      = 0;
        _isShakeActive                  = NO;
        [self startAccelerometerForShake];
    }
//    [self setupGestureRecognizersWithView:self.view];
}
- (void)gameStarted {
    _moveCommandLabel.fontColor         = [SKColor whiteColor];
    if ([AppSingleton singleton].currentGame.gameMode == SIGameModeOneHand) {
        /*Setup Shake recognizer*/
        _restCount                      = 0;
        _isShakeActive                  = NO;
        [self startAccelerometerForShake];
    }
}
- (void)gameEnded {
//    NSArray *gestures = _sharedGestureRecognizers;
//    [self removeGestureRecognizers];
    if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpNone) {
        [self powerUpDeactivated];
    }
//    gestures = _sharedGestureRecognizers;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    EndGameScene *endScene      = [EndGameScene sceneWithSize:self.frame.size];
    [Game transisitionToSKScene:endScene toSKView:self.view DoorsOpen:NO pausesIncomingScene:NO pausesOutgoingScene:NO duration:1.0];

}
- (void)adDidFinish {
    


}
- (void)replayGame {
    [[AppSingleton singleton] initAppSingletonWithGameMode:_gameMode];
    [[AppSingleton singleton] startGame];
    [self correctMoveEntered:nil];
}
- (void)scoreUpdate {
//    [self.progressBarMove setProgress:[AppSingleton singleton].currentGame.moveScorePercentRemaining];
//    if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpNone) {
//        [self.progressBarPowerUp setProgress:[AppSingleton singleton].currentGame.powerUpPercentRemaining];
//    }
}
- (void)correctMoveEntered:(NSNotification *)notification {
    if (notification) {
        NSDictionary *userInfo                  = notification.userInfo;
        NSNumber *moveScore                     = userInfo[kSINSDictionaryKeyMoveScore];
        [self presentMoveScore:moveScore];
    }
    /*Set Current Move*/
    _moveCommandLabel.text                      = [Game stringForMove:[AppSingleton singleton].currentGame.currentMove];
    
    /*Get Next Background Color*/
    _backgroundNode.backgroundColor             = [[AppSingleton singleton] newBackgroundColor];
}
- (void)levelDidChange {
    _currentLevelLabel.text                     = [AppSingleton singleton].currentGame.currentLevel;
}
- (void)pause {
    [[AppSingleton singleton] pause];
    
    [_playNode runAction:[SKAction fadeAlphaTo:1.0 duration:0.7]];
    
    _pauseScreenNode                            = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[Game getBluredScreenshot:self.view]]];
    _pauseScreenNode.position                   = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    _pauseScreenNode.alpha                      = 0;
    _pauseScreenNode.zPosition                  = 1;
    [_pauseScreenNode runAction:[SKAction fadeAlphaTo:1 duration:0.4]];
    [self addChild:_pauseScreenNode];
}
- (void)play {
    [_pauseScreenNode removeFromParent];
    
    [_playNode runAction:[SKAction fadeAlphaTo:0.0 duration:0.0]];
    
    [[AppSingleton singleton] play];
}
- (void)newHighScore {
    if (_isHighScoreShowing == NO) {
        _isHighScoreShowing                     = YES;
        SKLabelNode *newHighScore               = [[SKLabelNode alloc] initWithFontNamed:kSIFontFuturaMedium];
        newHighScore.text                       = @"High Score!";
        newHighScore.fontSize                   = 40;
        newHighScore.fontColor                  = [SKColor whiteColor];
        newHighScore.position                   = CGPointMake(self.frame.size.width / 2.0f, _moveCommandLabel.frame.origin.y + _moveCommandLabel.frame.size.height + VERTICAL_SPACING_16);
        
        SKAction *increaseSize                  = [SKAction scaleTo:1.3 duration:1.0];
        SKAction *decreaseSize                  = [SKAction scaleTo:0.9 duration:1.0];
        SKAction *scaleSequence                 = [SKAction sequence:@[increaseSize, decreaseSize]];
        [newHighScore runAction:[SKAction repeatActionForever:scaleSequence]];
        
        [self addChild:newHighScore];
    }
}

#pragma mark - GUI Functions
- (void)presentMoveScore:(NSNumber *)score {
    SKLabelNode *moveLabel                      = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    moveLabel.text                              = [NSString stringWithFormat:@"%0.2f",[score floatValue]];
    moveLabel.position                          = CGPointMake(self.frame.size.width / 2.0f, (self.frame.size.height / 2.0f) - _moveCommandLabel.frame.size.height);
    moveLabel.physicsBody                       = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(moveLabel.frame.size.width, moveLabel.frame.size.height)];
    moveLabel.physicsBody.categoryBitMask       = uiControlCategory;
    moveLabel.physicsBody.contactTestBitMask    = bottomEdgeCategory;
    moveLabel.physicsBody.collisionBitMask      = 0;
    moveLabel.physicsBody.linearDamping         = 0.0f;
    
    SKAction *animateIn                         = [SKAction fadeInWithDuration:0.5];
    
    [moveLabel runAction:animateIn];
    
    // add the sprite node to the scene
    [self addChild:moveLabel];
    
    
    CGFloat randomDx                            = arc4random_uniform(LAUNCH_DX_VECTOR_MAX);
    while (randomDx < LAUNCH_DX_VECTOR_MIX) {
        randomDx                                = arc4random_uniform(LAUNCH_DX_VECTOR_MAX);
    }
    int randomDirection                         = arc4random_uniform(2);
    if (randomDirection == 1) { /*Negative Direction*/
        randomDx                                = -1.0f * randomDx;
    }
    
    CGFloat randomDy                            = ([score floatValue]/MAX_MOVE_SCORE) * LAUNCH_DY_MULTIPLIER;

//    NSLog(@"Vector... dX = %0.2f | Y = %0.2f",randomDx,randomDy);
    CGVector moveScoreVector                    = CGVectorMake(randomDx, randomDy);
    
    [moveLabel.physicsBody applyImpulse:moveScoreVector];

}
#pragma mark - Power Up Generic Methods
/*This is the first step of a power up, this passed a message to the App Singlton to*/
/*  determine if this powerup should be called*/
- (void)powerUpTapped:(SIPowerUp)powerUp {
    [[AppSingleton singleton] powerUpDidLoad:powerUp];
}
/*This is the forth step. Activated by the Singleton*/
- (void)powerUpActivated {
    switch ([AppSingleton singleton].currentGame.currentPowerUp) {
        case SIPowerUpTimeFreeze:
            [self startPowerUpTimeFreeze];
            break;
        case SIPowerUpRapidFire:
            [self startPowerUpRapidFire];
            break;
        default:
            [self startPowerUpFallingMonkeys];
            break;
    }
}
- (void)powerUpDeactivated {
    switch ([AppSingleton singleton].currentGame.currentPowerUp) {
        case SIPowerUpTimeFreeze:
            [self endPowerUpTimeFreeze];
            break;
        case SIPowerUpRapidFire:
            [self endPowerUpRapidFire];
            break;
        default:
            [self endPowerUpFallingMonkeys];
            break;
    }
}
- (void)startPowerUpAllWithDuration:(SIPowerUpDuration)duration withNode:(SKSpriteNode *)node {
    SKAction *fadeOutAlpha  = [SKAction fadeAlphaTo:0.0 duration:duration - (duration * 0.9)];
    SKAction *fadeInAlpha = [SKAction fadeAlphaTo:1.0 duration:duration - (duration * 0.1)];
    SKAction *fadeSequence = [SKAction sequence:@[fadeOutAlpha,fadeInAlpha]];
    
    if (node) {
        [node runAction:fadeSequence];
    }
    
    [[AppSingleton singleton] powerUpDidActivate];
    
    [self performSelector:@selector(powerUpDeactivated) withObject:nil afterDelay:duration];
}
- (void)endPowerUpAll {
    [[AppSingleton singleton] powerUpDidEnd];
    [AppSingleton singleton].currentGame.currentPowerUp = SIPowerUpNone;
    
}
#pragma mark - Time Freeze
- (void)startPowerUpTimeFreeze {
    /*Do any UI Set U[ for Time Freeze*/
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.3];
    [_progressBarPowerUp runAction:fadeIn];
//    SKAction *moveItCoinLabel = [SKAction moveByX:0 y:_progressBarSize.height + VERTICAL_SPACING_8 duration:0.5];
//    [_itCoinsLabel runAction:moveItCoinLabel];

    
    /*Generic Start Power Up*/
    [self startPowerUpAllWithDuration:SIPowerUpDurationTimeFreeze withNode:nil];
}
- (void)endPowerUpTimeFreeze {
    /*Do any UI break down for Time Freeze*/
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3];
    [_progressBarPowerUp runAction:fadeOut];
//    SKAction *moveItCoinLabel = [SKAction moveByX:0 y:-1.0f * (_progressBarSize.height + VERTICAL_SPACING_8) duration:0.5];
//    [_itCoinsLabel runAction:moveItCoinLabel];

    
    /*Generica End Power Up*/
    [self endPowerUpAll];
}

#pragma mark - Rapid Fire
- (void)startPowerUpRapidFire {
    /*Do any UI Setup for Rapid Fire*/
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.3];
    [_progressBarPowerUp runAction:fadeIn];
//    SKAction *moveItCoinLabel = [SKAction moveByX:0 y:_progressBarSize.height + VERTICAL_SPACING_8 duration:0.5];
//    [_itCoinsLabel runAction:moveItCoinLabel];

    
    /*Generic Start Power Up*/
    [self startPowerUpAllWithDuration:SIPowerUpDurationRapidFire withNode:nil];
}
- (void)endPowerUpRapidFire {
    /*Do any UI break down for Rapid Fire*/
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3];
    [_progressBarPowerUp runAction:fadeOut];
//    SKAction *moveItCoinLabel = [SKAction moveByX:0 y:-1.0f * (_progressBarSize.height + VERTICAL_SPACING_8) duration:0.5];
//    [_itCoinsLabel runAction:moveItCoinLabel];

    
    /*Generica End Power Up*/
    [self endPowerUpAll];
}
#pragma mark - Falling Monkeys
/**Falling Monkey - When the user taps execute button for monkey power up this is the fifth step in the cycle
        The game will enter a pause state from the singleton perspective, this leads to all controls on the user's side
        being disabled for the time being...*/
/*This is the fith step.*/
- (void)startPowerUpFallingMonkeys {
    /*Do any control setup for Falling Monkeys*/
    _monkeySpeed        = 1.0;
    
    /*Do any UI Set UI for Falling Monkeys*/
    SKAction *fadeOut       = [SKAction fadeOutWithDuration:1.0];
    [_progressBarMove       runAction:fadeOut];
    [_moveCommandLabel      runAction:fadeOut];
    [_pauseNode             runAction:fadeOut];
    [_menuBackground        runAction:fadeOut];
    [_powerUpToolBar        runAction:fadeOut];
    
    /*Pause Game*/
    [[AppSingleton singleton] pause];
    
    /*Start Power Up*/
    [self launchMonkey];
}
/*This is the 7th step, called by game controller to end powerup*/
- (void)endPowerUpFallingMonkeys {
    /*Do any UI break down for Falling Monkeys*/
    
    for (SKNode *unknownNode in self.children) {
        if (unknownNode.physicsBody.categoryBitMask == monkeyCategory) {
            SKNode *foundMonkeyNode = unknownNode;
            
            SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3];
            SKAction *removeMonkey = [SKAction removeFromParent];
            
            SKAction *removeMonkeySequence = [SKAction sequence:@[fadeOut, removeMonkey]];
            
            [foundMonkeyNode runAction:removeMonkeySequence];
        }
    }
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.5];
    [_progressBarMove       runAction:fadeIn];
    [_moveCommandLabel      runAction:fadeIn];
    [_pauseNode             runAction:fadeIn];
    [_menuBackground        runAction:fadeIn];
    [_powerUpToolBar        runAction:fadeIn];

    SKAction *resumeGameBlock = [SKAction runBlock:^{
        /*Resume Game Play*/
        [[AppSingleton singleton] play];
    }];
    SKAction *resumeSequence = [SKAction sequence:@[fadeIn, resumeGameBlock]];
    [_progressBarMove       runAction:resumeSequence];


    /*Generica End Power Up*/
    [self endPowerUpAll]; //this will disable the powerup
}
#pragma mark - Monkey Methods!
- (void)launchMonkey {
    /*Get Random Number Max... based of width of screen and monkey*/
    CGFloat validMax                        = self.frame.size.width - (_fallingMonkeySize.width / 2.0f);
    CGFloat xLocation                       = arc4random_uniform(validMax); /*This will be the y axis launch point*/
    while (xLocation < _fallingMonkeySize.width / 2.0) {
        xLocation                           = arc4random_uniform(validMax);
    }
    CGFloat yLocation                       = self.frame.size.height + _fallingMonkeySize.height;
    
    /*Make Monkey*/
    SKSpriteNode *monkey                    = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageFallingMonkeys] size:_fallingMonkeySize];
    monkey.position                         = CGPointMake(xLocation, yLocation);
    monkey.name                             = kSINodeFallingMonkey;
    monkey.physicsBody                      = [SKPhysicsBody bodyWithRectangleOfSize:_fallingMonkeySize];
    monkey.physicsBody.linearDamping        = 0.0f;
    monkey.physicsBody.categoryBitMask      = monkeyCategory;
    monkey.physicsBody.contactTestBitMask   = bottomEdgeCategory;
    monkey.physicsBody.collisionBitMask     = sideEdgeCategory;
    self.physicsWorld.gravity               = CGVectorMake(0, -_monkeySpeed);
    
    [self addChild:monkey];
    
    
    //create the vector
    NSLog(@"Launching Monkey with speed of: %0.1f",_monkeySpeed);
    CGVector monkeyVector                   = CGVectorMake(0, -1.0);
    [monkey.physicsBody applyImpulse:monkeyVector];
    
    /*Call Function again*/
    
    CGFloat randomDelay                     = (float)arc4random_uniform(75) / 100.0f;
    
    _monkeySpeed                        = _monkeySpeed + MONKEY_SPEED_INCREASE;
    
    [self performSelector:@selector(launchMonkey) withObject:nil afterDelay:randomDelay];

}
/**Called when a monkey is tapped...*/
- (void)monkeyWasTapped:(SKNode *)monkey {
    /*Remove that monkey*/
    [monkey removeFromParent];
    
//    NSLog(@"Before Monkey tapped total score is: %0.2f",[AppSingleton singleton].currentGame.totalScore);
    
    [AppSingleton singleton].currentGame.totalScore = [AppSingleton singleton].currentGame.totalScore + VALUE_OF_MONKEY;
    
//    NSLog(@"After adding VALUE_OF_MONKEY score to tapped Monkey the total score is: %0.2f",[AppSingleton singleton].currentGame.totalScore);

    [[AppSingleton singleton] setAndCheckDefaults:VALUE_OF_MONKEY];
    
//    NSLog(@"After setAndCheckDefaults total score is: %0.2f",[AppSingleton singleton].currentGame.totalScore);
    
    _totalScoreLabel.text                       = [NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.totalScore];
    
    self.view.backgroundColor                       = [[AppSingleton singleton] newBackgroundColor];
}

-(void)didBeginContact:(SKPhysicsContact *)contact {

    SKPhysicsBody *notTheBottomEdge;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        notTheBottomEdge                = contact.bodyA;
    } else {
        notTheBottomEdge                = contact.bodyB;
    }
    
    if (notTheBottomEdge.categoryBitMask == uiControlCategory) { /*Label*/
        /*Remove the label*/
        SKNode *moveLabelNode = notTheBottomEdge.node;
        
        SKAction *fadeOut               = [SKAction fadeOutWithDuration:0.3];
        SKAction *removeNode            = [SKAction removeFromParent];
        
        SKAction *removeNodeSequence    = [SKAction sequence:@[fadeOut, removeNode]];
        
        [moveLabelNode runAction:removeNodeSequence];
        
    }
    
    if (notTheBottomEdge.categoryBitMask == monkeyCategory) {
        /*Remove the Monkey*/
        
        /**End The Powerup*/
        /*Cancel any monkeys that */
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(launchMonkey) object:nil];

        [self powerUpDeactivated];
        [self correctMoveEntered:nil];
        self.physicsWorld.gravity       = CGVectorMake(0, -9.8);

    }

}

#pragma mark - Scene Methods
- (void)freeCoinEarned {
    SKAction *increaseSize1 = [SKAction scaleTo:1.2f duration:0.5f];
    SKAction *wait          = [SKAction waitForDuration:0.1f];
    SKAction *decreaseSize  = [SKAction scaleTo:0.9f duration:0.5f];
    SKAction *increaseSize2 = [SKAction scaleTo:1.0f duration:0.25f];
    SKAction *sequence      = [SKAction sequence:@[increaseSize1,wait,decreaseSize,increaseSize2]];
    
    [_itCoinsButtonLabel runAction:sequence];
}
-(void)update:(NSTimeInterval)currentTime {
    _totalScoreLabel.text                       = [NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.totalScore];
    
    _itCoinsButtonLabel.text                    = [NSString stringWithFormat:@"x%d",[[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue]];
    
    
    _progressBarFreeCoin.progress               = [AppSingleton singleton].currentGame.freeCoinPercentRemaining;
    if (POINTS_NEEDED_FOR_FREE_COIN - [AppSingleton singleton].currentGame.freeCoinInPoints > 0.0f) {
//        _progressBarFreeCoin.titleLabelNode.text    = @"Free Coin"; //[NSString stringWithFormat:@"IT Coin in %0.2f points",POINTS_NEEDED_FOR_FREE_COIN - [AppSingleton singleton].currentGame.freeCoinInPoints];
    }
    
    if ([AppSingleton singleton].currentGame.isPaused == NO) {
        [_progressBarMove setProgress:[AppSingleton singleton].currentGame.moveScorePercentRemaining];
        if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpNone) {
            [_progressBarPowerUp setProgress:[AppSingleton singleton].currentGame.powerUpPercentRemaining];
//            _progressBarPowerUp.titleLabelNode.text = @"Free Coin"; //[NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.powerUpPercentRemaining * MAX_MOVE_SCORE];
        }
    }
}
#pragma mark - HLToolBarNode
-(void)toolbarNode:(HLToolbarNode *)toolbarNode didTapTool:(NSString *)toolTag {
    if ([toolTag isEqualToString:kSINodeButtonTimeFreeze]) {
        [self powerUpTapped:SIPowerUpTimeFreeze];
        
    } else if ([toolTag isEqualToString:kSINodeButtonRapidFire]) {
        [self powerUpTapped:SIPowerUpRapidFire];
        
    } else if ([toolTag isEqualToString:kSINodeButtonFallingMonkey]) {
        [self powerUpTapped:SIPowerUpFallingMonkeys];
    }
}
//- (SKSpriteNode *)powerupCostNode:(SIPowerUp)siPowerUp {
//    int powerupCost = [Game costForPowerUp:siPowerUp];
//    SKSpriteNode *costNode = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonTimeFreeze] size:CGSizeMake(_buttonSize.width * 0.25, _buttonSize.height * 0.25)];
//    HLLabelButtonNode *labelNode = [[HLLabelButtonNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(_buttonSize.width * 0.25, _buttonSize.height * 0.25)];
//    
//
//}
@end
