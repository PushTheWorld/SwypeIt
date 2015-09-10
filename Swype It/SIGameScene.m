//  GameScene.m
//  Swype It
//
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is the main game scene
//
// Defines

// Local Controller Import
#import "EndGameScene.h"
#import "FXBlurView.h"
#import "SIGameScene.h"
#import "SIGameController.h"
#import "SIGameNode.h"
#import "TCProgressBarNode.h"
// Framework Import
#import <CoreMotion/CoreMotion.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "HLGestureTarget.h"
#import "MKStoreKit.h"
#import "SoundManager.h"
// Category Import
#import "SKNode+HLGestureTarget.h"
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SISceneGameProgressBarUpdate.h"
#import "SIPowerUp.h"
// Other Imports

@interface SIGameScene () <HLToolbarNodeDelegate, SIGameNodeDelegate, HLRingNodeDelegate, SIPopUpNodeDelegate, HLMenuNodeDelegate> {
    
}
#pragma mark - Private Properties

#pragma mark - Constraints

#pragma mark - UI Controls
@property (strong, nonatomic) TCProgressBarNode *progressBarFreeCoin;
@property (strong, nonatomic) TCProgressBarNode *progressBarMove;
@property (strong, nonatomic) TCProgressBarNode *progressBarPowerUp;
@property (strong, nonatomic) SKLabelNode       *moveCommandLabel;
@property (strong, nonatomic) SKLabelNode       *totalScoreLabel;
@property (strong, nonatomic) SKSpriteNode      *pauseScreenNode;
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
    SIGameModeZPositionLayerBackgroundDetail,
    SIGameNodeZPositionLayerGameDetail,
    SIGameNodeZPositionLayerMoveScoreEmitter,
    SIGameNodeZPositionLayerMoveScore,
    SIGameNodeZPositionLayerFallingMonkey,
    SIGameNodeZPositionLayerBar,
    SIGameNodeZPositionLayerBarDetail,
    SIGameNodeZPositionLayerPopup,
    SIGameNodeZPositionLayerPopupContent,
    SIGameNodeZPositionLayerPauseBlur,
    SIGameNodeZPositionLayerPauseMenu,
    SIGameNodeZPositionLayerCount
};

@implementation SIGameScene {
    BOOL                                     _isButtonTouched;
    BOOL                                     _isGameActive;
    BOOL                                     _isHighScoreShowing;
    BOOL                                     _isShakeActive;
    BOOL                                     _isSoundOnBackground;
    BOOL                                     _isSoundOnFX;

    CGFloat                                  _coinStuffBackgroundHeight;
    CGFloat                                  _fontSizeProgessView;
    CGFloat                                  _fontSize;
    CGFloat                                  _monkeySpeed;
    CGFloat                                  _moveFactor;
    CGFloat                                  _powerUpToolBarBackgroundHeight;
    CGFloat                                  _progressBarCornerRadius;
    CGFloat                                  _toolbarHorizontalSpacing;

    CGSize                                   _adBannderSize;
    CGSize                                   _backgroundSize;
    CGSize                                   _buttonSize;
    CGSize                                   _coinSize;
    CGSize                                   _progressBarSizeMove;
    CGSize                                   _progressBarSizeFreeCoin;
    CGSize                                   _progressBarSizePowerUp;
    CGSize                                   _sceneSize;
    CGSize                                   _toolbarNodeSize;
    CGSize                                   _toolbarSize;

    CGPoint                                  _launchMoveScorePoint;
    CGPoint                                  _leftButtonCenterPoint;
    CGPoint                                  _pauseButtonPoint;
    
    CMMotionManager                         *_motionManager;
    
    FXBlurView                              *_blurView;
    
    HLLabelButtonNode                       *_pauseButtonNode;
    HLLabelButtonNode                       *_playButtonNode;
    
    HLRingNode                              *_ringNode;
    
    
    HLToolbarNode                           *_powerUpToolBar;

    NSInteger                                _restCount;

    NSString                                *_adMenuItemText;
    NSString                                *_coinMenuItemText;
    
    SIAdBannerNode                          *_adBannerNode;
    
    SIGameNode                              *_backgroundNode;
    
    SIMoveCommandAction                      _moveScoreAction;
    
    SIPopupNode                             *_popUpNode;
    
    SKLabelNode                             *_itCoinsButtonLabel;
    
    SKSpriteNode                            *_adBackgroundNode;
    SKSpriteNode                            *_coin;
    SKSpriteNode                            *_coinStuffBackgroundNode;
    SKSpriteNode                            *_backgroundDetailNode;
    SKSpriteNode                            *_powerUpToolBarBackgroundNode;
    
    SKTexture                               *_monkeyFaceTexture;
    
}

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self setupDefaults:size gameMode:SIGameModeTwoHand];
    }
    return self;
}
- (void)setupDefaults:(CGSize)size gameMode:(SIGameMode)gameMode {
    [self sceneInitialization:size];
    

    self.physicsWorld.contactDelegate           = self;
}

- (void)didMoveToView:(nonnull SKView *)view {
    [self setupUserInterfaceWithSize:view.frame.size];

    self.gestureTargetHitTestMode               = HLSceneGestureTargetHitTestModeDeepestThenParent;
}
- (void)willMoveFromView:(nonnull SKView *)view {

    [super willMoveFromView:view];
}

#pragma mark - UI Life Cycle Methods
/*CALLED BY initWithSize...*/
- (void)sceneInitialization:(CGSize)size {
    [self createConstantsWithSize:size];
    [self createControlsWithSize:size];
    [self setupControlsWithSize:size];
    [self startAccelerometerForShake];
    [SIGameScene sceneGameWillLoadEmitters];
}
/*CALLED BY didMoveToView*/
- (void)setupUserInterfaceWithSize:(CGSize)size {
    [self layoutControlsWithSize:size];
}

- (void)createConstantsWithSize:(CGSize)size {

    _sceneSize                          = size;
    _isButtonTouched                    = NO;
    _restCount                          = 0;
    _isShakeActive                      = NO;
    
    _progressBarSizeMove                = CGSizeMake(size.width / 1.5f, (size.width / 2.0f) * 0.3);
    _progressBarSizeFreeCoin            = CGSizeMake(size.width / 2.0f, (size.width / 2.0f) * 0.2);
    _progressBarSizePowerUp             = CGSizeMake(size.width - VERTICAL_SPACING_16, (size.width / 2.0f) * 0.3);
    _progressBarCornerRadius            = 12.0f;
    _fontSizeProgessView                = _fontSize - 6.0f;
    _coinSize                           = CGSizeMake(_progressBarSizeFreeCoin.height, _progressBarSizeFreeCoin.height);
    _coinStuffBackgroundHeight          = VERTICAL_SPACING_4 + _progressBarSizeFreeCoin.height + VERTICAL_SPACING_4;
    _powerUpToolBarBackgroundHeight     = VERTICAL_SPACING_4 + _buttonSize.height + VERTICAL_SPACING_4;

    if ([SIGameController isPremiumUser]) {
        _adBannderSize                  = CGSizeZero;
        _backgroundSize                 = size;
    } else {
        _adBannderSize                  = CGSizeMake(size.width, [SIGameController bannerViewHeight]);
        _backgroundSize                 = CGSizeMake(size.width, size.height - _adBannderSize.height);
    }
    _moveFactor                         = _backgroundSize.width + (_progressBarSizePowerUp.width / 2.0f) + VERTICAL_SPACING_8;

    
    _toolbarHorizontalSpacing           = 10.0f;
    CGFloat toolBarNodeWidth            = (SCREEN_WIDTH - (4.0f * _toolbarHorizontalSpacing)) / 5.0f;
    _toolbarNodeSize                    = CGSizeMake(toolBarNodeWidth, toolBarNodeWidth);
    _toolbarSize                        = CGSizeMake(size.width, _toolbarNodeSize.height + VERTICAL_SPACING_8);
    
    /*Init Fonts*/
    _powerUpButtonFont                  = [UIFont fontWithName:kSIFontFuturaMedium size:_fontSize - 4.0f];
    _nextMoveCommandFont                = [UIFont fontWithName:kSIFontFuturaMedium size:_fontSize - 4.0f];
    _moveCommandFont                    = [UIFont fontWithName:kSIFontFuturaMedium size:_fontSize];
    _totalScoreFont                     = [UIFont fontWithName:kSIFontFuturaMedium size:_fontSize * 2.0f];

    _isHighScoreShowing                 = NO;
    
}

- (void)createControlsWithSize:(CGSize)size {
    /**Background*/
    _backgroundNode                     = [[SIGameNode alloc] initWithSize:_backgroundSize gameMode:SIGameModeTwoHand];
    
    /*The Banner Ad*/
    _adBackgroundNode                   = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:_adBannderSize];
    
    /**Labels*/
    /*Total Score Label*/
    _totalScoreLabel                    = [SKLabelNode labelNodeWithFontNamed:kSIFontGameScore];
    
    /*Move Command Label*/
    _moveCommandLabel                   = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    
    /*It Coins Label*/
    _itCoinsButtonLabel                 = [SKLabelNode labelNodeWithFontNamed:kSIFontUltra];// [[HLLabelButtonNode alloc] initWithColor:[SKColor clearColor]
//                                                                              size:CGSizeMake(_progressBarSizeFreeCoin.width - VERTICAL_SPACING_4 - _coinSize.width - VERTICAL_SPACING_4,
//                                                                                              _progressBarSizeFreeCoin.height)];
    
    /**Progress Bars*/
    /*Free Coin Progress Bar Sprite*/
    _progressBarFreeCoin                = [[TCProgressBarNode alloc]
                                           initWithSize:_progressBarSizeFreeCoin
                                           backgroundColor:[UIColor lightGrayColor]
                                           fillColor:[UIColor goldColor]
                                           borderColor:[UIColor blackColor]
                                           borderWidth:2.0f
                                           cornerRadius:4.0f];
    /*Move Progress Bar Sprite*/
    _progressBarMove                    = [[TCProgressBarNode alloc]
                                           initWithSize:_progressBarSizeMove
                                           backgroundColor:[UIColor grayColor]
                                           fillColor:[UIColor redColor]
                                           borderColor:[UIColor blackColor]
                                           borderWidth:1.0f
                                           cornerRadius:4.0f];
    
    
    /*Power Up Progress Bar Sprite*/
    _progressBarPowerUp                 = [[TCProgressBarNode alloc]
                                           initWithSize:_progressBarSizePowerUp
                                           backgroundColor:[UIColor grayColor]
                                           fillColor:[UIColor greenColor]
                                           borderColor:[UIColor blackColor]
                                           borderWidth:1.0f
                                           cornerRadius:4.0f];

    _coinStuffBackgroundNode            = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(size.width, _coinStuffBackgroundHeight)];// [HLTiledNode tiledNodeWithTexture:[SKTexture textureWithImageNamed:@"diamondPlate3"] size:CGSizeMake(size.width, _coinStuffBackgroundHeight)];

    /**Toolbar*/
    _powerUpToolBar                     = [self addPowerUpToolbarNode:size];
    
    /**Images*/
    _coin                               = [SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageCoinSmallFront] size:_coinSize];

    _powerUpToolBarBackgroundNode       = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(size.width, _powerUpToolBarBackgroundHeight)]; //[HLTiledNode tiledNodeWithTexture:[SKTexture textureWithImageNamed:@"diamondPlate3"] size:CGSizeMake(size.width, _powerUpToolBarBackgroundHeight)];
    
    /**Buttons*/
    _pauseButtonNode                    = [[HLLabelButtonNode alloc] initWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonPause]];
    
    _blurView                           = [[FXBlurView alloc] init];
    
    _motionManager                      = [[CMMotionManager alloc] init];

}
- (void)setupControlsWithSize:(CGSize)size {
//    self.scaleMode                          = SKSceneScaleModeAspectFill;
    
    /**Background*/
    _backgroundNode.anchorPoint                                 = CGPointMake(0.0f, 0.0f);
    _backgroundNode.physicsBody.categoryBitMask                 = uiControlCategory;
    _backgroundNode.zPosition                                   = (float)SIGameNodeZPositionLayerBackground / (float)SIGameNodeZPositionLayerCount;
    _backgroundNode.backgroundColor                             = [SKColor backgroundColorForLevelOneA];
    _backgroundNode.delegate                                    = self;
    [_backgroundNode hlSetGestureTarget:_backgroundNode];
    
    /*Background for ad banner*/
    _adBackgroundNode.anchorPoint                               = CGPointMake(0.0f, 0.0f);
    _adBackgroundNode.physicsBody.categoryBitMask               = uiControlCategory;
    _adBackgroundNode.zPosition                                 = (float)SIGameNodeZPositionLayerBackground / (float)SIGameNodeZPositionLayerCount;
    
    /**Labels*/
    /*Total Score Label*/
    _totalScoreLabel.text                                       = @"0.00";
    _totalScoreLabel.fontColor                                  = [SKColor whiteColor];
    _totalScoreLabel.fontSize                                   = [SIGameController SIFontSizeHeader_x3]+10;
    _totalScoreLabel.physicsBody.categoryBitMask                = uiControlCategory;
    _totalScoreLabel.zPosition                                  = (float)SIGameNodeZPositionLayerGameDetail / (float)SIGameNodeZPositionLayerCount;
    _totalScoreLabel.name                                       = kSINodeGameScoreTotal;
    
    /*Move Command Label*/
    _moveCommandLabel.text                                      = [SIGame stringForMove:SIMoveCommandSwype];
    _moveCommandLabel.fontColor                                 = [SKColor whiteColor];
    _moveCommandLabel.fontSize                                  = [SIGameController SIFontSizeMoveCommand];
    _moveCommandLabel.physicsBody.categoryBitMask               = uiControlCategory;
    _moveCommandLabel.zPosition                                 = (float)SIGameNodeZPositionLayerGameDetail / (float)SIGameNodeZPositionLayerCount;
    _moveCommandLabel.userInteractionEnabled                    = YES;
    _moveCommandLabel.name                                      = kSINodeGameMoveCommand;
    _moveCommandLabel.verticalAlignmentMode                     = SKLabelVerticalAlignmentModeCenter;
    _moveCommandLabel.horizontalAlignmentMode                   = SKLabelHorizontalAlignmentModeCenter;
    
    /*Move Progress Bar Sprite*/
    _progressBarMove.progress                                   = 1.0f;
    _progressBarMove.physicsBody.categoryBitMask                = uiControlCategory;
    _progressBarMove.zPosition                                  = (float)SIGameNodeZPositionLayerGameDetail / (float)SIGameNodeZPositionLayerCount;
    _progressBarMove.name                                       = kSINodeGameProgressBarMove;
    _progressBarMove.userInteractionEnabled                     = YES;
    _progressBarMove.titleLabelNode.fontSize                    = _progressBarSizeMove.height * 0.66f;
    _progressBarMove.titleLabelNode.fontName                    = kSIFontUltra;
    _progressBarMove.titleLabelNode.fontColor                   = [SKColor whiteColor];
    _progressBarMove.titleLabelNode.verticalAlignmentMode       = SKLabelVerticalAlignmentModeCenter;
    
    /*Power Up Progress Bar Sprite*/
    _progressBarPowerUp.progress                                = 1.0f;
    _progressBarPowerUp.titleLabelNode.fontSize                 = [SIGameController SIFontSizeText_x2];
    _progressBarPowerUp.titleLabelNode.fontName                 = kSIFontUltra;
    _progressBarPowerUp.titleLabelNode.fontColor                = [SKColor whiteColor];
    _progressBarPowerUp.zPosition                               = (float)SIGameNodeZPositionLayerGameDetail  / (float)SIGameNodeZPositionLayerCount;
    _progressBarPowerUp.physicsBody.categoryBitMask             = uiControlCategory;
    _progressBarPowerUp.colorDoesChange                         = YES;
    
    _pauseButtonNode.name                                       = kSINodeButtonPause;
    _pauseButtonNode.size                                       = _buttonSize;
    _pauseButtonNode.physicsBody.categoryBitMask                = uiControlCategory;
    _pauseButtonNode.userInteractionEnabled                     = YES;
    _pauseButtonNode.zPosition                                  = (float)SIGameNodeZPositionLayerGameDetail  / (float)SIGameNodeZPositionLayerCount;
    
    /**Power Up Toobar*/
    _powerUpToolBar.delegate                                    = self;
    _powerUpToolBar.physicsBody.categoryBitMask                 = uiControlCategory;
    _powerUpToolBar.zPosition                                   = (float)SIGameNodeZPositionLayerBarDetail / (float)SIGameNodeZPositionLayerCount;
    
    /**Coin Bars*/
    _coinStuffBackgroundNode.physicsBody.categoryBitMask        = uiControlCategory;
    _coinStuffBackgroundNode.anchorPoint                        = CGPointMake(0.0f, 1.0f);
    _coinStuffBackgroundNode.zPosition                          = (float)SIGameNodeZPositionLayerBar / (float)SIGameNodeZPositionLayerCount;

    
    _powerUpToolBarBackgroundNode.physicsBody.categoryBitMask   = uiControlCategory;
    _powerUpToolBarBackgroundNode.anchorPoint                   = CGPointMake(0.0f, 0.0f);
    _powerUpToolBarBackgroundNode.zPosition                     = (float)SIGameNodeZPositionLayerBar / (float)SIGameNodeZPositionLayerCount;


    /*Free Coin Progress Bar Sprite*/
    NSNumber *freeCoinNumber                                    = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultPointsTowardsFreeCoin];
    _progressBarFreeCoin.titleLabelNode.text                    = @"Free Coin Meter"; //[NSString stringWithFormat:@"IT Coin In %0.2f Points", freeCoinIn];
    _progressBarFreeCoin.titleLabelNode.fontSize                = [SIGameController SIFontSizeText];
    _progressBarFreeCoin.titleLabelNode.fontName                = kSIFontUltra;
    _progressBarFreeCoin.titleLabelNode.fontColor               = [SKColor whiteColor];
    _progressBarFreeCoin.progress                               = [freeCoinNumber floatValue] / POINTS_NEEDED_FOR_FREE_COIN;
    _progressBarFreeCoin.physicsBody.categoryBitMask            = uiControlCategory;
    _progressBarFreeCoin.zPosition                              = (float)SIGameNodeZPositionLayerBarDetail / (float)SIGameNodeZPositionLayerCount;

    
    _coin.physicsBody.categoryBitMask                           = uiControlCategory;
    _coin.zPosition                                             = (float)SIGameNodeZPositionLayerBarDetail / (float)SIGameNodeZPositionLayerCount;

    
    /*It Coins Label*/
    _itCoinsButtonLabel.text                                    = [NSString stringWithFormat:@"x%d",[[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue]];
    _itCoinsButtonLabel.fontColor                               = [SKColor whiteColor];
    _itCoinsButtonLabel.fontSize                                = _coinSize.height;// * 0.66;
    _itCoinsButtonLabel.zPosition                               = (float)SIGameNodeZPositionLayerBarDetail / (float)SIGameNodeZPositionLayerCount;
    _itCoinsButtonLabel.physicsBody.categoryBitMask             = uiControlCategory;
    [_itCoinsButtonLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
    [_itCoinsButtonLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeBottom];
    
    _blurView.dynamic                                           = NO;
    _blurView.contentMode                                       = UIViewContentModeCenter;

}
/**
 Call this class in the initialization... this will add the emitters to the store
 */
+ (void)sceneGameWillLoadEmitters {
    NSDate *startDate = [NSDate date];
    
    HLEmitterStore *emitterStore = [HLEmitterStore sharedStore];
    
    SKEmitterNode *emitterNode;
    
    emitterNode = [emitterStore setEmitterWithResource:kSIEmitterExplosionTouch forKey:kSIEmitterExplosionTouch];
    emitterNode = [emitterStore setEmitterWithResource:kSIEmitterSpark forKey:kSIEmitterSpark];
    
    NSLog(@"SIGameScene loadEmitters: loaded in %0.2f seconds", [[NSDate date] timeIntervalSinceDate:startDate]);
}
- (void)layoutControlsWithSize:(CGSize)size {

    _backgroundNode.position                                    = CGPointMake(0.0f, [SIGameController bannerViewHeight]);
    [self addChild:_backgroundNode];
    [self registerDescendant:_backgroundNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    
    _adBackgroundNode.position                                  = CGPointMake(0.0f, 0.0f);
    [self addChild:_adBackgroundNode];
    
    /**Labels*/
    /*Total Score Label*/
    _totalScoreLabel.position                                   = CGPointMake((size.width / 2.0f),
                                                                              _backgroundSize.height - _totalScoreLabel.fontSize - VERTICAL_SPACING_8 - _coinStuffBackgroundHeight);
    [_backgroundNode addChild:_totalScoreLabel];
    
    /**Pause Node*/
    _pauseButtonNode.anchorPoint                                = CGPointMake(0.0f, 1.0f);
    _pauseButtonNode.name                                       = kSINodeButtonPause;
    _pauseButtonPoint                                           = CGPointMake(VERTICAL_SPACING_8,
                                                                              _backgroundSize.height - _coinStuffBackgroundNode.frame.size.height - VERTICAL_SPACING_8);
    _pauseButtonNode.position                                   = _pauseButtonPoint;
    [_backgroundNode addChild:_pauseButtonNode];
    
    //    [_pauseButtonNode hlSetGestureTarget:_backgroundNode];
    
    HLTapGestureTarget *pauseGestureTarget                      = [[HLTapGestureTarget alloc] init];
    pauseGestureTarget.handleGestureBlock                       = ^(UIGestureRecognizer *gestureRecognizer) {
        if ([_sceneDelegate respondsToSelector:@selector(sceneGamePauseButtonTapped)]) {
            [_sceneDelegate controllerSceneGamePauseButtonTapped];
        }
    };
    [_pauseButtonNode hlSetGestureTarget:pauseGestureTarget];
    [self registerDescendant:_pauseButtonNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];

    /**Move command stuff*/
    /*Move Command Label*/
    _moveCommandLabel.position                                  = CGPointMake(_backgroundSize.width / 2.0f, (_backgroundSize.height/ 2.0f));
    [_backgroundNode addChild:_moveCommandLabel];
    
    /*Move Progress Bar Sprite*/ //Progress bar anchor point is 0.5,0.5
    _progressBarMove.position                                   = CGPointMake(_backgroundSize.width / 2.0f,
                                                                              (_backgroundSize.height / 2.0f) - _progressBarSizeMove.height - VERTICAL_SPACING_8);
    [_backgroundNode addChild:_progressBarMove];
    
    /**POWER UP PROGRESS BAR*/
    /*Power Up Progress Bar Sprite*/ //Progress bar anchor point is 0.5,0.5
    _progressBarPowerUp.position                                = CGPointMake(-1.0f * _backgroundSize.width,
                                                                              (_backgroundSize.height / 2.0f) + [SIGameController SIFontSizeMoveCommand] + _progressBarSizePowerUp.height);
    [_backgroundNode addChild:_progressBarPowerUp];
    
    
    /**Coin Bar*/
    _coinStuffBackgroundNode.position                           = CGPointMake(0.0f,size.height);
    [self addChild:_coinStuffBackgroundNode];
    
    _powerUpToolBarBackgroundNode.position                      = CGPointMake(0.0f,0.0f);
    [self addChild:_powerUpToolBarBackgroundNode];
    
    /**Power Up Toolbar*/
    _powerUpToolBar.position                                    = CGPointMake(0.0f, 0.0f);
    [self addChild:_powerUpToolBar];
    [_powerUpToolBar hlSetGestureTarget:_powerUpToolBar];
    [self registerDescendant:_powerUpToolBar withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    
    _coin.anchorPoint                                           = CGPointMake(0.0f, 1.0f);
    _coin.position                                              = CGPointMake(VERTICAL_SPACING_4,
                                                                              -1.0f * VERTICAL_SPACING_4);
    [_coinStuffBackgroundNode addChild:_coin];
    
    /*IT Coins Label*/
    _itCoinsButtonLabel.position                                = CGPointMake(VERTICAL_SPACING_4 + _coinSize.width + VERTICAL_SPACING_4,
                                                                              -1.0f * VERTICAL_SPACING_4 - _coinSize.height);
    [_coinStuffBackgroundNode addChild:_itCoinsButtonLabel];
    
    /*Move Progress Bar Sprite*/
    _progressBarFreeCoin.position                               = CGPointMake((size.width / 4.0f) * 3.0f - VERTICAL_SPACING_4,
                                                                              -1.0f * (VERTICAL_SPACING_4 + (_progressBarSizeFreeCoin.height / 2.0f)));
    [_coinStuffBackgroundNode addChild:_progressBarFreeCoin];
    
}




#pragma mark - SIGameNode delegate
- (void)gestureEnded:(SIMove *)move {
    if ([_sceneDelegate respondsToSelector:@selector(controllerSceneGameDidRecieveMove:)]) {
        [_sceneDelegate controllerSceneGameDidRecieveMove:move];
    }
}
- (void)shakeRegistered {
    if ([_sceneDelegate respondsToSelector:@selector(controllerSceneGameDidRecieveMove:)]) {
        SIMove *move = [[SIMove alloc] init];
        move.moveCommand = SIMoveCommandShake;
        move.moveCommandAction = SIMoveCommandActionShake;
        [_sceneDelegate controllerSceneGameDidRecieveMove:move];
    }
}
- (void)sceneGameFadeUIElementsInDuration:(CGFloat)duration {
    SKAction *fadeIn = [SKAction fadeInWithDuration:duration];
    [_progressBarMove               runAction:fadeIn];
    [_totalScoreLabel               runAction:fadeIn];
    [_powerUpToolBar                runAction:fadeIn];
    [_coinStuffBackgroundNode       runAction:fadeIn];
    [_pauseButtonNode               runAction:fadeIn];
}

- (void)sceneGameFadeUIElementsOutDuration:(CGFloat)duration {
    SKAction *initFadeOut = [SKAction fadeOutWithDuration:duration];
    [_progressBarMove               runAction:initFadeOut];
    [_pauseButtonNode               runAction:initFadeOut];
    [_totalScoreLabel               runAction:initFadeOut];
    [_powerUpToolBar                runAction:initFadeOut];
    [_coinStuffBackgroundNode       runAction:initFadeOut];
    [_progressBarPowerUp            runAction:initFadeOut];
}

- (void)sceneWillShowEmitterExplosion:(CGPoint)location {
    
    HLEmitterStore *emitterStore = [HLEmitterStore sharedStore];
    SKEmitterNode *explosionEmitter = [emitterStore emitterCopyForKey:kSIEmitterExplosionTouch];
    
    explosionEmitter.position                       = location;

    
    explosionEmitter.zPosition                          = (float)SIGameNodeZPositionLayerMoveScoreEmitter / (float)SIGameNodeZPositionLayerCount;

    [self addChild:explosionEmitter];
}



//
//- (void)explosionFromGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
//    
//
//    
//    _launchMoveScorePoint                           = explosionPoint;
//    SKEmitterNode *sparkEmitter                     = [NSKeyedUnarchiver unarchiveObjectWithFile:[SIConstants pathForTouchExplosionEmitter]];
//    sparkEmitter.position                           = explosionPoint;
//    [self addChild:sparkEmitter];
//
//}

#pragma mark - Accelerometer Methods
- (void)startAccelerometerForShake {
    if ([_motionManager isAccelerometerAvailable]) {
        _motionManager.accelerometerUpdateInterval = ACCELEROMETER_UPDATE_INTERVAL; /*Get reading 20 times a second*/
        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                double magnitude                = sqrt(pow(accelerometerData.acceleration.x, 2) + pow(accelerometerData.acceleration.y, 2) + pow(accelerometerData.acceleration.z, 2));
                
                /*Adjust the magnititude*/
                double adjustedMag              = fabs(magnitude - 1.0);
//                NSLog(@"Adjusted Mag: %0.3f",(float)adjustedMag);
                if (adjustedMag > SHAKE_THRESHOLD) { /*Phone is Shaken*/
                    if (_isShakeActive) {
                        _restCount              = 0;
                    } else {
                        _isShakeActive          = YES;
                        [self shakeRegistered];
                    }
                } else { /*Phone is at rest*/
                    if (_isShakeActive) {
                        _restCount              = _restCount + 1;
                        if (_restCount > REST_COUNT_THRESHOLD) {
                            _isShakeActive      = NO;
                            _restCount          = 0;
                        }
                    }
                }
            });
        }];
    } else {
        NSLog(@"Accelerometer Not Available!");
    }
}

#pragma mark - Scene Update Methods
/**
 Called Syncrousnly
 */
-(void)update:(NSTimeInterval)currentTime {
    if ([_sceneDelegate respondsToSelector:@selector(controllerSceneGameWillUpdateProgressBars)]) {
        SISceneGameProgressBarUpdate *progressBarUpdate = [_sceneDelegate controllerSceneGameWillUpdateProgressBars];
        
        _progressBarMove.titleLabelNode.text            = progressBarUpdate.textMove;
        _progressBarMove.progress                       = progressBarUpdate.percentMove;
        
        _progressBarPowerUp.progress                    = progressBarUpdate.percentPowerUp;
    }
}
/**
 Asyncronously
 */
- (void)updateSceneGameWithBackgroundColor:(UIColor *)backgroundColor
                            totalScore:(float)totalScore
                                  move:(SIMove *)move
                        moveScoreLabel:(BMGlyphLabel *)moveScoreLabel
            freeCoinProgressBarPercent:(float)freeCoinProgressBarPercent
                     moveCommandString:(NSString *)moveCommandString {
    
    /*Change the background color*/
    _backgroundNode.backgroundColor                     = backgroundColor;
    
    /*Handle that toal score label up at the top*/
    _totalScoreLabel.text                               = [NSString stringWithFormat:@"%0.2f",totalScore];
    
    /*Lets put a little explosion in the moveScore!!! yeah*/
    [self sceneWillShowMoveScore:moveScoreLabel];
    
    [self sceneWillShowEmitterExplosion:move.touchPoint];
    
    _progressBarFreeCoin.progress                       = freeCoinProgressBarPercent;
    
    [self moveCommandLabelWillUpdateWithNewCommand:moveCommandString];
}


#pragma mark - Notification Methods
//- (void)gameResume {
//    _moveCommandLabel.fontColor                 = [SKColor whiteColor];
//    if ([AppSingleton singleton].currentGame.gameMode == SIGameModeOneHand) {
//        /*Setup Shake recognizer*/
//        _restCount                              = 0;
//        _isShakeActive                          = NO;
//        [self startAccelerometerForShake];
//    }
//}
//- (void)gameStarted {
//    _moveCommandLabel.fontColor                 = [SKColor whiteColor];
////    if ([AppSingleton singleton].currentGame.gameMode == SIGameModeOneHand) {
////        /*Setup Shake recognizer*/
////        _restCount                              = 0;
////        _isShakeActive                          = NO;
////        [self startAccelerometerForShake];
////    }
//}
    
//- (void)gameEnded {
//    if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpTypeNone) {
//        [self powerUpDeactivated];
//    }
//    [self presentModalNode:_popUpNode animation:HLScenePresentationAnimationFade];
//
//}

- (void)sceneGameWillDisplayPopup:(SIPopupNode *)popupNode {
    popupNode.delegate                             = self;
    [self presentModalNode:_popUpNode animation:HLScenePresentationAnimationFade];
}

//- (void)createPopup {
//    _popUpNode                                      = [SIGameController SISharedPopUpNodeTitle:@"Continue?" SceneSize:self.size];
//    _popupNode.delegate                             = self;
//
//    HLMenuNode *menuNode                            = [self menuCreate:_popUpNode.backgroundSize];
//    _popUpNode.popupContentNode                     = menuNode;
//    [menuNode hlSetGestureTarget:menuNode];
//    [self registerDescendant:menuNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
//    
//    _popUpNode.userInteractionEnabled               = YES;
//    [_popUpNode hlSetGestureTarget:_popUpNode];
//    [self registerDescendant:_popUpNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
//}


//
//- (void)adDidFinish {
//    
//
//
//}
//- (void)replayGame {
//    [[AppSingleton singleton] initAppSingletonWithGameMode:_gameMode];
//    [[AppSingleton singleton] startGame];
//    [self correctMoveEntered:nil];
//}
//- (void)scoreUpdate {
////    [self.progressBarMove setProgress:[AppSingleton singleton].currentGame.moveScorePercentRemaining];
////    if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpTypeNone) {
////        [self.progressBarPowerUp setProgress:[AppSingleton singleton].currentGame.powerUpPercentRemaining];
////    }
//}

/**
 Called by the singleton to notify the view that the correct move was entered
 */
//- (void)correctMoveEntered:(NSNotification *)notification {
//    if (notification) {
//        NSDictionary *userInfo                  = notification.userInfo;
//        NSNumber *moveScore                     = userInfo[kSINSDictionaryKeyMoveScore];
//        [self presentMoveScore:moveScore];
//    }
//    /*Set Current Move*/
//    _moveCommandLabel                           = [self launchMoveCommand];
//    
//
////    _moveCommandLabel.text                      = SIGame stringForMove:[AppSingleton singleton].currentGame.currentMove];
//    
//    /*Get Next Background Color*/
//    _backgroundNode.backgroundColor             = [[AppSingleton singleton] newBackgroundColor];
//}
//- (void)levelDidChange {
//    _currentLevelLabel.text                     = [AppSingleton singleton].currentGame.currentLevel;
//}
//- (void)pause {
//    [[AppSingleton singleton] pause];
//    
//    
//    _pauseScreenNode                            = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:SIGame getBluredScreenshot:self.view]]];
//    _pauseScreenNode.position                   = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
//    _pauseScreenNode.alpha                      = 0;
//    _pauseScreenNode.zPosition                  = SIGameNodeZPositionLayerPauseBlur / SIGameNodeZPositionLayerCount;
//    [_pauseScreenNode runAction:[SKAction fadeAlphaTo:1 duration:0.01]];
//    [self addChild:_pauseScreenNode];
//    
//    [self addRingNode:self.frame.size];
//}
//- (void)play {
//    [_pauseScreenNode removeFromParent];
//    
//    [[AppSingleton singleton] play];
//}
//- (void)addPlayButton:(CGSize)size {
//    _playButtonNode                             = [[HLLabelButtonNode alloc] initWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonPlay]];
//    _playButtonNode.name                        = kSINodeButtonPlay;
//    _playButtonNode.size                        = _buttonSize;
//    _playButtonNode.physicsBody.categoryBitMask = uiControlCategory;
//    _playButtonNode.zPosition                   = SIGameNodeZPositionLayerPauseMenu  / SIGameNodeZPositionLayerCount;
//    _playButtonNode.anchorPoint                 = CGPointMake(0.5, 0.5);
//    _playButtonNode.position                    = CGPointMake(size.width / 2.0f,
//                                                                      size.height / 2.0f);
//    [self addChild:_playButtonNode];
//    HLTapGestureTarget *playGestureTarget       = [[HLTapGestureTarget alloc] init];
//    playGestureTarget.handleGestureBlock        = ^(UIGestureRecognizer *gestureRecognizer) {
//        [self play];
//        [_playButtonNode removeFromParent];
//    };
//    [_playButtonNode hlSetGestureTarget:playGestureTarget];
//    [self registerDescendant:_playButtonNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
//}

#pragma mark - Pause Screen
- (void)sceneGameBlurDisplayRingNode:(HLRingNode *)ringNode {
    _pauseScreenNode                                    = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[SIGame getBluredScreenshot:self.view]]];
    _pauseScreenNode.position                           = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    _pauseScreenNode.alpha                              = 0;
    _pauseScreenNode.zPosition                          = (float)SIGameNodeZPositionLayerPauseBlur / (float)SIGameNodeZPositionLayerCount;
    [_pauseScreenNode runAction:[SKAction fadeAlphaTo:1 duration:0.01]];
    [self addChild:_pauseScreenNode];
    
    
    /*Configre the Ring */
    _ringNode                                           = ringNode;
    _ringNode.delegate                                  = self;
    _ringNode.zPosition                                 = (float)SIGameNodeZPositionLayerPauseMenu / (float)SIGameNodeZPositionLayerCount;
    _ringNode.position                                  = CGPointMake(_sceneSize.width / 2.0f, _sceneSize.height / 2.0f);
    [_ringNode setHighlight:![SIConstants isFXAllowed] forItem:SISceneGameRingNodeSoundFX];
    [_ringNode setHighlight:![SIConstants isBackgroundSoundAllowed] forItem:SISceneGameRingNodeSoundBackground];
    [self addChild:_ringNode];
    [_ringNode hlSetGestureTarget:_ringNode];
    [self registerDescendant:_ringNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
}

#pragma mark - Popup Node
- (void)sceneGameModallyPresentPopup:(SIPopupNode *)popupNode withMenuNode:(HLMenuNode *)menuNode {
    popupNode.delegate                              = self;

    menuNode.delegate                               = self;
    
    _coinMenuItemText = [[menuNode menu] itemAtIndex:SISceneGamePopupContinueMenuItemCoin].text;
    
    _adMenuItemText = [[menuNode menu] itemAtIndex:SISceneGamePopupContinueMenuItemAd].text;
    
    _popUpNode.popupContentNode                     = menuNode;
    [menuNode hlSetGestureTarget:menuNode];
    [self registerDescendant:menuNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    
    [_popUpNode hlSetGestureTarget:_popUpNode];
    [self registerDescendant:_popUpNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    
    CGFloat zPositionMin = (float)SIGameNodeZPositionLayerPopup / (float)SIGameNodeZPositionLayerPopupContent;
    CGFloat zPositionMax = (float)SIGameNodeZPositionLayerPopupContent / (float)SIGameNodeZPositionLayerPopupContent;
    
    [self presentModalNode:popupNode animation:HLScenePresentationAnimationFade zPositionMin:zPositionMin zPositionMax:zPositionMax];
}

//
//- (HLRingNode *)gamePauseRingNode {
//    HLRingNode *ringNode;
//    
//    /*First Button - Play*/
//    HLItemNode *playButtonNode                          = [[HLItemNode alloc] init];
//    [playButtonNode setContent:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonPlay] size:_buttonSize]];
//
//    /*Second Button - SoundFX*/
//    HLItemContentFrontHighlightNode *soundFXNode        = [[HLItemContentFrontHighlightNode alloc] initWithContentNode:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonSoundOnFX] size:_buttonSize]
//                                                                                            frontHighlightNode:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonCross] size:_buttonSize]];
//
//    /*Third Button - Sound Background*/
//    HLItemContentFrontHighlightNode *soundBkgrndNode    = [[HLItemContentFrontHighlightNode alloc] initWithContentNode:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonSoundOnBackground] size:_buttonSize]
//                                                                                            frontHighlightNode:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonCross] size:_buttonSize]];
//    
//    /*First Button - Play*/
//    HLItemNode *endGameButton                           = [[HLItemNode alloc] init];
//    [endGameButton setContent:[SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageButtonEndGame] size:_buttonSize]];
//
//    NSArray *arrayOfRingItems                           = @[playButtonNode, soundFXNode, soundBkgrndNode,endGameButton];
//    ringNode                                           = [[HLRingNode alloc] initWithItemCount:(int)[arrayOfRingItems count]];
//    [ringNode setContent:arrayOfRingItems];
//    [ringNode setHighlight:!_isSoundOnBackground forItem:(int)[arrayOfRingItems indexOfObject:soundBkgrndNode]];
//    [ringNode setHighlight:!_isSoundOnFX forItem:(int)[arrayOfRingItems indexOfObject:soundFXNode]];
//    [ringNode setLayoutWithRadius:_buttonSize.width initialTheta:M_PI];
//    
//    return ringNode;
//}

- (void)sceneGameWillShowHighScore {
    if (_isHighScoreShowing == NO) {
        _isHighScoreShowing                     = YES;
        SKLabelNode *newHighScore               = [[SKLabelNode alloc] initWithFontNamed:kSIFontFuturaMedium];
        newHighScore.text                       = @"High Score!";
        newHighScore.userInteractionEnabled     = YES;
        newHighScore.fontSize                   = 40;
        newHighScore.fontColor                  = [SKColor whiteColor];
        newHighScore.position                   = CGPointMake(self.frame.size.width / 2.0f, _moveCommandLabel.frame.origin.y + _moveCommandLabel.frame.size.height + VERTICAL_SPACING_16);
        
        SKAction *increaseSize                  = [SKAction scaleTo:1.3 duration:1.0];
        SKAction *decreaseSize                  = [SKAction scaleTo:0.9 duration:1.0];
        SKAction *scaleSequence                 = [SKAction sequence:@[increaseSize, decreaseSize]];
        [newHighScore runAction:[SKAction repeatActionForever:scaleSequence]];
        
        [_backgroundNode addChild:newHighScore];
    }
}

#pragma mark - GUI Functions
- (SKLabelNode *)moveCommandLabelWillUpdateWithNewCommand:(NSString *)newMoveCommand {
    SKLabelNode *newMoveCommandLabel                = [SIGameController SILabelSceneGameMoveCommand];
    newMoveCommandLabel.text                        = newMoveCommand;
    newMoveCommandLabel.position                    = CGPointMake(_backgroundSize.width / 2.0f, (_backgroundSize.height/ 2.0f));
    [_backgroundNode addChild:newMoveCommandLabel];
    
    SKAction *fadeActionSequenceForNewLabel         = [SKAction sequence:@[[SKAction fadeOutWithDuration:0.0f],
                                                                           [SKAction fadeInWithDuration:MOVE_COMMAND_LAUNCH_DURATION]]];
    [newMoveCommandLabel runAction:fadeActionSequenceForNewLabel];
    
    SKLabelNode *oldMoveLabel                       = _moveCommandLabel;
    [oldMoveLabel runAction:[SIGame actionForSIMoveCommandAction:_moveScoreAction]];
    
    return newMoveCommandLabel;
//    label.fontSize                      = [SIGameController fontSizeMoveCommand];

}
//+ (SKLabelNode *)moveCommandLabelNode {
////    SKLabelNode *label;
////    label                               = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
////    label.fontColor                     = [SKColor whiteColor];
//    label.fontSize                      = [SIGameController fontSizeMoveCommand];
//    label.physicsBody.categoryBitMask   = uiControlCategory;
//    label.zPosition                     = SIGameNodeZPositionLayerGameDetail / SIGameNodeZPositionLayerCount;
////    label.userInteractionEnabled        = YES;
////    label.name                          = kSINodeGameMoveCommand;
////    label.horizontalAlignmentMode       = SKLabelHorizontalAlignmentModeCenter;
////    label.verticalAlignmentMode         = SKLabelVerticalAlignmentModeCenter;
////    return label;
//}
- (void)sceneGameWillShowMoveScore:(BMGlyphLabel *)moveLabel {
    
    

//    SKLabelNode *moveLabel                      = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
//    moveLabel.text                              = [NSString stringWithFormat:@"%0.2f",[score floatValue]];
//    moveLabel.fontName                          = kSIFontGameScore;
//    moveLabel.fontSize                          = [SIGameController fontSizeHeader];

    
    SKSpriteNode *moveLabelNode = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(200.0f, 100.0f)];

    
//    [moveLabel setVerticalAlignment:BMGlyphVerticalAlignmentMiddle];
//    [moveLabel setHorizontalAlignment:BMGlyphHorizontalAlignmentCentered];
    
    
//    moveLabelNode.position                          = launchPoint; //CGPointMake(self.frame.size.width / 2.0f, (self.frame.size.height / 2.0f) - _moveCommandLabel.frame.size.height);
    moveLabelNode.physicsBody                       = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50.0f, 50.0f)];  //CGSizeMake(moveLabel.frame.size.width, moveLabel.frame.size.height)];
    moveLabelNode.physicsBody.categoryBitMask       = uiControlCategory;
    moveLabelNode.physicsBody.contactTestBitMask    = bottomEdgeCategory;
    moveLabelNode.physicsBody.collisionBitMask      = 0;
    moveLabelNode.physicsBody.linearDamping         = 0.0f;
    moveLabelNode.zPosition                         = SIGameNodeZPositionLayerMoveScore / SIGameNodeZPositionLayerCount;
    moveLabelNode.userInteractionEnabled            = YES;
    
    SKAction *animateIn                             = [SKAction fadeInWithDuration:0.5];
    [moveLabelNode runAction:animateIn];
    
    // add the sprite node to the scene

    [_backgroundNode addChild:moveLabelNode];

    SKAction *scale;
    if (IDIOM == IPAD) {
       scale = [SKAction scaleBy:3.0 duration:0.0f];
    } else {
        scale = [SKAction scaleBy:2.0 duration:0.0f];
    }
    
    [moveLabel runAction:scale];

    [moveLabelNode addChild:moveLabel];
    
    HLEmitterStore *emitterStore = [HLEmitterStore sharedStore];
    SKEmitterNode *sparkEmitter = [emitterStore emitterCopyForKey:kSIEmitterSpark];

    sparkEmitter.position                       = CGPointMake(0.0f, 0.0f);
    sparkEmitter.zPosition                      = SIGameNodeZPositionLayerMoveScoreEmitter / SIGameNodeZPositionLayerCount;
    [moveLabelNode addChild:sparkEmitter];
    
    CGFloat randomDx                            = arc4random_uniform(LAUNCH_DX_VECTOR_MAX);
    while (randomDx < LAUNCH_DX_VECTOR_MIX) {
        randomDx                                = arc4random_uniform(LAUNCH_DX_VECTOR_MAX);
    }
    int randomDirection                         = arc4random_uniform(2);
    if (randomDirection == 1) { /*Negative Direction*/
        randomDx                                = -1.0f * randomDx;
    }
    
    CGFloat randomDy                            = (arc4random_uniform(8)/10 + 0.1) * LAUNCH_DY_MULTIPLIER;

//    NSLog(@"Vector... dX = %0.2f | Y = %0.2f",randomDx,randomDy);
    CGVector moveScoreVector                    = CGVectorMake(randomDx, randomDy);
    [moveLabelNode.physicsBody applyImpulse:moveScoreVector];

}
//#pragma mark - Power Up Generic Methods
///*This is the first step of a power up, this passed a message to the App Singlton to*/
///*  determine if this powerup should be called*/
//- (void)powerUpTapped:(SIPowerUp)powerUp {
//    [[AppSingleton singleton] powerUpDidLoad:powerUp];
//}
///*This is the forth step. Activated by the Singleton*/
//- (void)powerUpActivated {
//    switch ([AppSingleton singleton].currentGame.currentPowerUp) {
//        case SIPowerUpTypeTimeFreeze:
//            [self startPowerUpTimeFreeze];
//            break;
//        case SIPowerUpTypeRapidFire:
//            [self startPowerUpRapidFire];
//            break;
//        default:
//            [self startPowerUpFallingMonkeys];
//            break;
//    }
//}
//- (void)powerUpDeactivated {
//    switch ([AppSingleton singleton].currentGame.currentPowerUp) {
//        case SIPowerUpTypeTimeFreeze:
//            [self endPowerUpTimeFreeze];
//            break;
//        case SIPowerUpTypeRapidFire:
//            [self endPowerUpRapidFire];
//            break;
//        default:
//            [self endPowerUpFallingMonkeys];
//            break;
//    }
//}
//- (void)startPowerUpAllWithDuration:(SIPowerUpDuration)duration withNode:(SKSpriteNode *)node {
//    SKAction *fadeOutAlpha  = [SKAction fadeAlphaTo:0.0 duration:duration - (duration * 0.9)];
//    SKAction *fadeInAlpha = [SKAction fadeAlphaTo:1.0 duration:duration - (duration * 0.1)];
//    SKAction *fadeSequence = [SKAction sequence:@[fadeOutAlpha,fadeInAlpha]];
//    
//    if (node) {
//        [node runAction:fadeSequence];
//    }
//    
//    [[AppSingleton singleton] powerUpDidActivate];
//    
//    [self performSelector:@selector(powerUpDeactivated) withObject:nil afterDelay:duration];
//}
//- (void)endPowerUpAll {
//    [[AppSingleton singleton] powerUpDidEnd];
//    [AppSingleton singleton].currentGame.currentPowerUp = SIPowerUpTypeNone;
//    
//}
- (void)sceneGameMovePowerUpProgressBarOnScreen:(BOOL)willMoveOnScreen {
    if (willMoveOnScreen) {
        [_progressBarPowerUp runAction:[SKAction fadeInWithDuration:0.3]];
        
        SKAction *moveAction = [SKAction moveByX:_moveFactor y:0.0f duration:0.3f];
        [_progressBarPowerUp runAction:moveAction];

    } else {
        [_progressBarPowerUp runAction:[SKAction fadeOutWithDuration:0.3]];
        
        SKAction *moveAction = [SKAction moveByX:-1.0f * _moveFactor y:0.0f duration:0.3f];
        [_progressBarPowerUp runAction:moveAction];

    }
}
#pragma mark - Time Freeze
//- (void)startPowerUpTimeFreeze {
//    /*Do any UI Set U[ for Time Freeze*/
//    [self movePowerUpProgressBarOnScreen:YES];
//    /*Generic Start Power Up*/
////    [self startPowerUpAllWithDuration:SIPowerUpDurationTimeFreeze withNode:nil];
//}
//- (void)endPowerUpTimeFreeze {
//    /*Do any UI break down for Time Freeze*/
//    [self movePowerUpProgressBarOnScreen:NO];
//
//    /*Generica End Power Up*/
////    [self endPowerUpAll];
//}
//
//#pragma mark - Rapid Fire
//- (void)startPowerUpRapidFire {
//    /*Do any UI Setup for Rapid Fire*/
//    [self movePowerUpProgressBarOnScreen:YES];
//
//    /*Generic Start Power Up*/
////    [self startPowerUpAllWithDuration:SIPowerUpDurationRapidFire withNode:nil];
//}
//- (void)endPowerUpRapidFire {
//    /*Do any UI break down for Rapid Fire*/
//    [self movePowerUpProgressBarOnScreen:NO];
//
//    /*Generica End Power Up*/
////    [self endPowerUpAll];
//}

//#pragma mark - Falling Monkeys
///**Falling Monkey - When the user taps execute button for monkey power up this is the fifth step in the cycle
//        The game will enter a pause state from the singleton perspective, this leads to all controls on the user's side
//        being disabled for the time being...*/
///*This is the fith step.*/
//- (void)startPowerUpFallingMonkeys {
//    /*Do any control setup for Falling Monkeys*/
//    _monkeySpeed        = 1.0;
//    
//    [_moveCommandLabel removeFromParent];
//    
//    /*Do any UI Set UI for Falling Monkeys*/
//    SKAction *fadeOut       = [SKAction fadeOutWithDuration:1.0];
//    [_progressBarMove               runAction:fadeOut];
//    [_moveCommandLabel              runAction:fadeOut];
//    [_pauseButtonNode               runAction:fadeOut];
//    [_powerUpToolBar                runAction:fadeOut];
////    [_powerUpToolBar                runAction:fadeOut];
//    
//    /*Start Power Up*/
//    [self launchMonkey];
//}
///*This is the 7th step, called by game controller to end powerup*/
//- (void)endPowerUpFallingMonkeys {
//    /*Do any UI break down for Falling Monkeys*/
//    
//    for (SKNode *unknownNode in self.children) {
//        if (unknownNode.physicsBody.categoryBitMask == monkeyCategory) {
//            SKNode *foundMonkeyNode = unknownNode;
//            
//            SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3];
//            SKAction *removeMonkey = [SKAction removeFromParent];
//            
//            SKAction *removeMonkeySequence = [SKAction sequence:@[fadeOut, removeMonkey]];
//            
//            [foundMonkeyNode runAction:removeMonkeySequence];
//        }
//    }
//    SKAction *fadeIn = [SKAction fadeInWithDuration:0.5];
//    [_progressBarMove               runAction:fadeIn];
//    [_moveCommandLabel              runAction:fadeIn];
//    [_pauseButtonNode               runAction:fadeIn];
//    [_powerUpToolBar                runAction:fadeIn];
//
//    SKAction *resumeGameBlock = [SKAction runBlock:^{
//        /*Resume Game Play*/
//        [[AppSingleton singleton] play];
//    }];
//    SKAction *resumeSequence = [SKAction sequence:@[fadeIn, resumeGameBlock]];
//    [_progressBarMove       runAction:resumeSequence];
//
//
//    /*Generica End Power Up*/
////    [self endPowerUpAll]; //this will disable the powerup
//}
//#pragma mark - Monkey Methods!
//- (void)launchMonkey {
//    /*Get Random Number Max... based of width of screen and monkey*/
//    CGFloat validMax                            = self.frame.size.width - (SIGameScene fallingMonkeySize].width / 2.0f);
//    CGFloat xLocation                           = arc4random_uniform(validMax); /*This will be the y axis launch point*/
//    while (xLocation < SIGameScene fallingMonkeySize].width / 2.0) {
//        xLocation                               = arc4random_uniform(validMax);
//    }
//    CGFloat yLocation                           = self.frame.size.height + SIGameScene fallingMonkeySize].height;
//    
//    /*Make Monkey*/
//
//    SKSpriteNode *monkey                        = SIGameScene newMonkey];
//    
//    monkey.position                             = CGPointMake(xLocation, yLocation);
//    
//    HLTapGestureTarget *tapGestureTarget       = [[HLTapGestureTarget alloc] init];
//    tapGestureTarget.handleGestureBlock        = ^(UIGestureRecognizer *gestureRecognizer) {
//        CGPoint viewLocation = [gestureRecognizer locationInView:self.scene.view];
//        CGPoint sceneLocation = [self.scene convertPointFromView:viewLocation];
//        CGPoint monkeyLocation = [self convertPoint:sceneLocation fromNode:self.scene];
//
//        SKNode *monkey = [self nodeAtPoint:monkeyLocation];
//        if ([monkey.name isEqualToString:kSINodeFallingMonkey]) { //make sure what you are tapping on is actually a monkey....
//            if ([_sceneDelegate respondsToSelector:@selector(sceneDidRecieveMoveCommand:)]) {
//                [_sceneDelegate sceneDidRecieveMoveCommand:SIMoveFallingMonkey];
//            }
//        }
//    };
//    [monkey hlSetGestureTarget:tapGestureTarget];
//    [self registerDescendant:monkey withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
//    
//
//    self.physicsWorld.gravity                   = CGVectorMake(0, -_monkeySpeed);
//    
//    [_backgroundNode addChild:monkey];
//    
//    //create the vector
//    NSLog(@"Launching Monkey with speed of: %0.1f",_monkeySpeed);
//    CGVector monkeyVector                       = CGVectorMake(0, -1.0);
//    [monkey.physicsBody applyImpulse:monkeyVector];
//    
//    /*Call Function again*/
//    
//    CGFloat randomDelay                         = (float)arc4random_uniform(75) / 100.0f;
//    
//    _monkeySpeed                                = _monkeySpeed + MONKEY_SPEED_INCREASE;
//    
//    [self performSelector:@selector(launchMonkey) withObject:nil afterDelay:randomDelay];
//
//}
//+ (SKSpriteNode *)newMonkey {
//    SKSpriteNode *monkey                        = [SKSpriteNode spriteNodeWithTexture:[SIGameController sharedMonkeyFace]  size:SIGameScene fallingMonkeySize]];
//    monkey.name                                 = kSINodeFallingMonkey;
//    monkey.physicsBody                          = [SKPhysicsBody bodyWithRectangleOfSize:SIGameScene fallingMonkeySize]];
//    monkey.physicsBody.linearDamping            = 0.0f;
//    monkey.physicsBody.categoryBitMask          = monkeyCategory;
//    monkey.physicsBody.contactTestBitMask       = bottomEdgeCategory;
//    monkey.physicsBody.collisionBitMask         = sideEdgeCategory;
//    monkey.zPosition                            = SIGameNodeZPositionLayerFallingMonkey / SIGameNodeZPositionLayerCount;
//    monkey.userInteractionEnabled               = YES;
//    return monkey;
//}
///**Called when a monkey is tapped...*/
//- (void)monkeyWasTapped:(SKNode *)monkey {
//    /*Remove that monkey*/
//    if ([monkey.name isEqualToString:kSINodeFallingMonkey]) {
//        [monkey removeFromParent];
//        [AppSingleton singleton].currentGame.totalScore = [AppSingleton singleton].currentGame.totalScore + VALUE_OF_MONKEY;
//        
//        [[AppSingleton singleton] setAndCheckDefaults:VALUE_OF_MONKEY];
//        
//        _totalScoreLabel.text                       = [NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.totalScore];
//        
//        self.view.backgroundColor                       = [[AppSingleton singleton] newBackgroundColor];
//
//    }
//}
//
//-(void)didBeginContact:(SKPhysicsContact *)contact {
//
//    SKPhysicsBody *notTheBottomEdge;
//    
//    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
//        notTheBottomEdge                = contact.bodyA;
//    } else {
//        notTheBottomEdge                = contact.bodyB;
//    }
//    
//    if (notTheBottomEdge.categoryBitMask == uiControlCategory) { /*Label*/
//        /*Remove the label*/
//        SKNode *moveLabelNode = notTheBottomEdge.node;
//        
//        SKAction *fadeOut               = [SKAction fadeOutWithDuration:0.3];
//        SKAction *removeNode            = [SKAction removeFromParent];
//        
//        SKAction *removeNodeSequence    = [SKAction sequence:@[fadeOut, removeNode]];
//        
//        [moveLabelNode runAction:removeNodeSequence];
//        
//    }
//    
//    if (notTheBottomEdge.categoryBitMask == monkeyCategory) {
//        /*Remove the Monkey*/
//        for (SKNode *node in _backgroundNode.children) {
//            if ([node.name isEqualToString:kSINodeFallingMonkey]) {
//                [node removeFromParent];
//            }
//        }
//        
//        /**End The Powerup*/
//        /*Cancel any monkeys that */
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(launchMonkey) object:nil];
//
//        [self powerUpDeactivated];
//        [self correctMoveEntered:nil];
//        self.physicsWorld.gravity       = CGVectorMake(0, -9.8);
//
//    }
//
//}

#pragma mark - Scene Methods
- (void)sceneWillShowFreeCoinEarned {
    SKAction *increaseSize1 = [SKAction scaleTo:1.2f duration:0.5f];
    SKAction *wait          = [SKAction waitForDuration:0.1f];
    SKAction *decreaseSize  = [SKAction scaleTo:0.9f duration:0.5f];
    SKAction *increaseSize2 = [SKAction scaleTo:1.0f duration:0.25f];
    SKAction *sequence      = [SKAction sequence:@[increaseSize1,wait,decreaseSize,increaseSize2]];
    
    [_itCoinsButtonLabel runAction:sequence];
}

//-(void)update:(NSTimeInterval)currentTime {
//    
//    
//    
//    _totalScoreLabel.text                       = [NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.totalScore];
//    
//    _itCoinsButtonLabel.text                    = [NSString stringWithFormat:@"x%d",[[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue]];
//    
//    
//    _progressBarFreeCoin.progress               = [AppSingleton singleton].currentGame.freeCoinPercentRemaining;
//    if (POINTS_NEEDED_FOR_FREE_COIN - [AppSingleton singleton].currentGame.freeCoinInPoints > 0.0f) {
////        _progressBarFreeCoin.titleLabelNode.text    = @"Free Coin"; //[NSString stringWithFormat:@"IT Coin in %0.2f points",POINTS_NEEDED_FOR_FREE_COIN - [AppSingleton singleton].currentGame.freeCoinInPoints];
//    }
//    
//    if ([AppSingleton singleton].currentGame.isPaused == NO) {
//        _progressBarMove.titleLabelNode.text = [NSString stringWithFormat:@"%0.2f pts",[AppSingleton singleton].currentGame.moveScore];
//        [_progressBarMove setProgress:[AppSingleton singleton].currentGame.moveScorePercentRemaining];
//        if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpTypeNone) {
//            [_progressBarPowerUp setProgress:[AppSingleton singleton].currentGame.powerUpPercentRemaining];
////            _progressBarPowerUp.titleLabelNode.text = @"Free Coin"; //[NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.powerUpPercentRemaining * MAX_MOVE_SCORE];
//        }
//    }
//
//    [self checkCanAffordPowerupToolbarNodes];
//}
//- (void)checkCanAffordPowerupToolbarNodes {
//    NSNumber *numberOfItCoins = [[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins];
//    
//    if ([numberOfItCoins integerValue] < SIPowerUpCostTimeFreeze || [AppSingleton singleton].currentGame.currentPowerUp == SIPowerUpTypeTimeFreeze) {
//        [_powerUpToolBar setEnabled:NO forTool:kSINodeButtonTimeFreeze];
//    } else {
//        [_powerUpToolBar setEnabled:YES forTool:kSINodeButtonTimeFreeze];
//    }
//    
//    if ([numberOfItCoins integerValue] < SIPowerUpCostRapidFire  || [AppSingleton singleton].currentGame.currentPowerUp == SIPowerUpTypeRapidFire) {
//        [_powerUpToolBar setEnabled:NO forTool:kSINodeButtonRapidFire];
//    } else {
//        [_powerUpToolBar setEnabled:YES forTool:kSINodeButtonRapidFire];
//    }
//    
//    if ([numberOfItCoins integerValue] < SIPowerUpCostFallingMonkeys  || [AppSingleton singleton].currentGame.currentPowerUp == SIPowerUpTypeFallingMonkeys) {
//        [_powerUpToolBar setEnabled:NO forTool:kSINodeButtonFallingMonkey];
//    } else {
//        [_powerUpToolBar setEnabled:YES forTool:kSINodeButtonFallingMonkey];
//    }
//}
#pragma mark - HLToolBarNodeDelegate
- (void)toolbarNode:(HLToolbarNode *)toolbarNode didTapTool:(NSString *)toolTag {
    if ([_sceneDelegate respondsToSelector:@selector(controllerSceneGameToolbar:powerUpWasTapped:)]) {
        [_sceneDelegate controllerSceneGameToolbar:toolbarNode powerUpWasTapped:[SIPowerUp powerUpForString:toolTag]];
    }
}


#pragma mark - HLRingNodeDelegate
- (void)ringNode:(HLRingNode *)ringNode didTapItem:(int)itemIndex {
    if ([_sceneDelegate respondsToSelector:@selector(controllerSceneGameDidRecieveRingNode:tap:)]) {
        [_sceneDelegate controllerSceneGameDidRecieveRingNode:ringNode tap:(SISceneGameRingNode)itemIndex];
    }
}

#pragma mark - HLMenuNodeDelegate
- (void)menuNode:(HLMenuNode *)menuNode didTapMenuItem:(HLMenuItem *)menuItem itemIndex:(NSUInteger)itemIndex {
    if ([_sceneDelegate respondsToSelector:@selector(controllerSceneGameWillDismissPopupContinueWithPayMethod:)]) {
        if ([menuItem.text isEqualToString:_coinMenuItemText]) {
            [_sceneDelegate controllerSceneGameWillDismissPopupContinueWithPayMethod:SISceneGamePopupContinueMenuItemCoin];
            
        }  else if ([menuItem.text isEqualToString:_adMenuItemText]) {
            [_sceneDelegate controllerSceneGameWillDismissPopupContinueWithPayMethod:SISceneGamePopupContinueMenuItemAd];
            
        } else if ([menuItem.text isEqualToString:kSIMenuTextPopUpEndGame]) {
            [_sceneDelegate controllerSceneGameWillDismissPopupContinueWithPayMethod:SISceneGamePopupContinueMenuItemNo];
        }
    }
}


#pragma mark - Private Class Functions
/**Pr0gress Bar for Free Coin*/
+ (TCProgressBarNode *)SISceneGameProgressBarFreeCoinSceneSize:(CGSize)size {
    CGSize progressBarSize              = CGSizeMake(size.width / 2.0f, (size.width / 2.0f) * 0.2);
    TCProgressBarNode *progressBar      = [[TCProgressBarNode alloc]
                                           initWithSize:progressBarSize
                                           backgroundColor:[UIColor lightGrayColor]
                                           fillColor:[UIColor goldColor]
                                           borderColor:[UIColor blackColor]
                                           borderWidth:2.0f
                                           cornerRadius:4.0f];
    return progressBar;
}
/**Pr0gress Bar for Move*/
+ (TCProgressBarNode *)SISceneGameProgressBarMoveSceneSize:(CGSize)size {
    CGSize progressBarSize              = CGSizeMake(size.width / 1.5f, (size.width / 2.0f) * 0.3);
    TCProgressBarNode *progressBar      = [[TCProgressBarNode alloc]
                                           initWithSize:progressBarSize
                                           backgroundColor:[UIColor grayColor]
                                           fillColor:[UIColor redColor]
                                           borderColor:[UIColor blackColor]
                                           borderWidth:1.0f
                                           cornerRadius:4.0f];
    return progressBar;
}
/**Progress Bar for Power Up*/
+ (TCProgressBarNode *)SISceneGameProgressBarPowerUpSceneSize:(CGSize)size {
    CGSize progressBarSize              = CGSizeMake(size.width - VERTICAL_SPACING_16, (size.width / 2.0f) * 0.3);
    TCProgressBarNode *progressBar      = [[TCProgressBarNode alloc]
                                           initWithSize:progressBarSize
                                           backgroundColor:[UIColor grayColor]
                                           fillColor:[UIColor greenColor]
                                           borderColor:[UIColor blackColor]
                                           borderWidth:1.0f
                                           cornerRadius:4.0f];
    return progressBar;
}
/**Power up toolbar*/
+ (HLToolbarNode *)powerUpToolbarSize:(CGSize)toolbarSize toolbarNodeSize:(CGSize)toolbarNodeSize horizontalSpacing:(CGFloat)horizontalSpacing {
    HLToolbarNode *toolbarNode                  = [[HLToolbarNode alloc] init];
    toolbarNode.automaticHeight                 = NO;
    toolbarNode.automaticWidth                  = NO;
    toolbarNode.backgroundBorderSize            = 0.0f;
    toolbarNode.squareSeparatorSize             = horizontalSpacing;
    toolbarNode.backgroundColor                 = [UIColor clearColor];
    toolbarNode.anchorPoint                     = CGPointMake(0.0f, 0.0f);
    toolbarNode.size                            = toolbarSize;
    toolbarNode.squareColor                     = [SKColor clearColor];
    
    NSMutableArray *toolNodes                   = [NSMutableArray array];
    NSMutableArray *toolTags                    = [NSMutableArray array];
    
    SIPowerUpToolbarNode *timeFreezeNode        = [[SIPowerUpToolbarNode alloc] initWithSIPowerUp:SIPowerUpTypeTimeFreeze size:toolbarNodeSize];
    [toolNodes  addObject:timeFreezeNode];
    [toolTags   addObject:kSINodeButtonTimeFreeze];
    
    SIPowerUpToolbarNode *rapidFireNode         = [[SIPowerUpToolbarNode alloc] initWithSIPowerUp:SIPowerUpTypeRapidFire size:toolbarNodeSize];
    [toolNodes addObject:rapidFireNode];
    [toolTags addObject:kSINodeButtonRapidFire];
    
    SIPowerUpToolbarNode *fallingMonkeyNode     = [[SIPowerUpToolbarNode alloc] initWithSIPowerUp:SIPowerUpTypeFallingMonkeys size:toolbarNodeSize];
    [toolNodes addObject:fallingMonkeyNode];
    [toolTags addObject:kSINodeButtonFallingMonkey];
    
    [toolbarNode setTools:toolNodes tags:toolTags animation:HLToolbarNodeAnimationSlideUp];
    
    [toolbarNode layoutToolsAnimation:HLToolbarNodeAnimationNone];
    return toolbarNode;
}
@end
