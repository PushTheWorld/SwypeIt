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
#import "TCProgressBarNode.h"
#import "EndGameScene.h"
#import "GameScene.h"
// Framework Import
#import <CoreMotion/CoreMotion.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "MKStoreKit.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "Game.h"
// Other Imports

@interface GameScene () {
    
}
#pragma mark - Private Primiatives
@property (assign, nonatomic) BOOL               isButtonTouched;
@property (assign, nonatomic) BOOL               isGameActive;
@property (assign, nonatomic) BOOL               isShakeActive;
@property (assign, nonatomic) CGSize             fallingMonkeySize;
@property (assign, nonatomic) CGFloat            progressBarCornerRadius;
@property (assign, nonatomic) CGSize             progressBarSize;
@property (assign, nonatomic) CGSize             progressBarSizeFreeCoin;
@property (assign, nonatomic) CGSize             buttonSize;
@property (assign, nonatomic) CGFloat            fontSize;
@property (assign, nonatomic) CGFloat            monkeySpeed;
@property (assign, nonatomic) CGPoint            leftButtonCenterPoint;
@property (assign, nonatomic) int                gameMode;


#pragma mark - Private Properties
@property (assign, nonatomic) NSInteger          restCount;

#pragma mark - Constraints

#pragma mark - UI Controls
@property (strong, nonatomic) TCProgressBarNode *progressBarFreeCoin;
@property (strong, nonatomic) TCProgressBarNode *progressBarMove;
@property (strong, nonatomic) TCProgressBarNode *progressBarPowerUp;
@property (strong, nonatomic) SKLabelNode       *itCoinsLabel;
@property (strong, nonatomic) SKLabelNode       *moveCommandLabel;
@property (strong, nonatomic) SKLabelNode       *totalScoreLabel;
@property (strong, nonatomic) SKSpriteNode      *pauseNode;
@property (strong, nonatomic) SKSpriteNode      *playNode;
@property (strong, nonatomic) SKSpriteNode      *pauseScreenNode;
@property (strong, nonatomic) SKSpriteNode      *rapidFireNode;
@property (strong, nonatomic) SKSpriteNode      *fallingMonkeysNode;
@property (strong, nonatomic) SKSpriteNode      *timeFreezeNode;
@property (strong, nonatomic) UIFont            *powerUpButtonFont;
@property (strong, nonatomic) UIFont            *nextMoveCommandFont;
@property (strong, nonatomic) UIFont            *moveCommandFont;
@property (strong, nonatomic) UIFont            *totalScoreFont;
@property (strong, nonatomic) UILabel           *currentLevelLabel;

#pragma mark - Gesture Recognizers
@property (nonatomic) UITapGestureRecognizer    *tap;
@property (nonatomic) UISwipeGestureRecognizer  *swypeTopBottom;
@property (nonatomic) UISwipeGestureRecognizer  *swypeLeft;
@property (nonatomic) UISwipeGestureRecognizer  *swypeRight;
@property (nonatomic) UIPinchGestureRecognizer  *pinch;

@end

static const uint32_t monkeyCategory        = 0x1;      // 00000000000000000000000000000001
static const uint32_t uiControlCategory     = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t bottomEdgeCategory    = 0x1 << 2; // 00000000000000000000000000000100
static const uint32_t sideEdgeCategory      = 0x1 << 3; // 00000000000000000000000000001000

@implementation GameScene

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
    self.gameMode                       = gameMode;
    self.isButtonTouched                = NO;
    
    self.physicsWorld.contactDelegate   = self;
    
    [self setupUserInterfaceWithSize:size];
}

- (void)didMoveToView:(nonnull SKView *)view {
    [self setupGestureRecognizersWithView:view];
    if ([AppSingleton singleton].willResume) {
        [AppSingleton singleton].willResume = NO;
        [[AppSingleton singleton] play];
        [self gameResume];
        [[AppSingleton singleton] willPrepareToShowNewMove];
    } else {
        self.progressBarMove.progress = 1.0f;
        [[AppSingleton singleton] startGame];
        self.backgroundColor                = [[AppSingleton singleton] newBackgroundColor];

    }
    /*Get Background Color*/
}
- (void)removeGestureRecognizers {
    [self.view removeGestureRecognizer:self.tap];
    [self.view removeGestureRecognizer:self.swypeTopBottom];
    [self.view removeGestureRecognizer:self.swypeRight];
    [self.view removeGestureRecognizer:self.swypeLeft];
    [self.view removeGestureRecognizer:self.pinch];
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
        self.fontSize                   = 20.0f;
        self.fallingMonkeySize          = CGSizeMake(100.0, 100.0);

    } else if (IS_IPHONE_5) {
        self.fontSize                   = 24.0f;
        self.fallingMonkeySize          = CGSizeMake(130.0, 130.0);
        
    } else if (IS_IPHONE_6) {
        self.fontSize                   = 28.0f;
        self.fallingMonkeySize          = CGSizeMake(150.0, 150.0);
        
    } else if (IS_IPHONE_6_PLUS) {
        self.fontSize                   = 32.0f;
        self.fallingMonkeySize          = CGSizeMake(180.0, 180.0);

    } else {
        self.fontSize                   = 36.0f;
        self.fallingMonkeySize          = CGSizeMake(200.0, 200.0);
        
    }
    self.buttonSize                     = CGSizeMake(size.width/5.0, size.width/5.0f);

    self.progressBarSize                = CGSizeMake(size.width / 2.0f, (size.width / 2.0f) * 0.2);
    self.progressBarSizeFreeCoin        = CGSizeMake(size.width - VERTICAL_SPACING_16, (size.width / 1.5f) * 0.2);
    self.progressBarCornerRadius        = 12.0f;
    
    
    /*Init Fonts*/
    self.powerUpButtonFont              = [UIFont fontWithName:kSIFontFuturaMedium size:self.fontSize - 4.0f];
    self.nextMoveCommandFont            = [UIFont fontWithName:kSIFontFuturaMedium size:self.fontSize - 4.0f];
    self.moveCommandFont                = [UIFont fontWithName:kSIFontFuturaMedium size:self.fontSize];
    self.totalScoreFont                 = [UIFont fontWithName:kSIFontFuturaMedium size:self.fontSize * 2.0f];

    
}
- (void)createControlsWithSize:(CGSize)size {
    /**Labels*/
    /*Total Score Label*/
    self.totalScoreLabel        = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    
    /*Move Command Label*/
    self.moveCommandLabel       = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    
    /*It Coins Label*/
    self.itCoinsLabel           = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    
    /**Progress Bars*/
    /*Free Coin Progress Bar Sprite*/
    self.progressBarFreeCoin    = [[TCProgressBarNode alloc]
                                   initWithSize:self.progressBarSizeFreeCoin
                                   backgroundColor:[UIColor grayColor]
                                   fillColor:[UIColor goldColor]
                                   borderColor:[UIColor blackColor]
                                   borderWidth:1.0f
                                   cornerRadius:4.0f];
    /*Move Progress Bar Sprite*/
    self.progressBarMove        = [[TCProgressBarNode alloc]
                                   initWithSize:self.progressBarSize
                                   backgroundColor:[UIColor grayColor]
                                   fillColor:[UIColor redColor]
                                   borderColor:[UIColor blackColor]
                                   borderWidth:1.0f
                                   cornerRadius:4.0f];

    
    /*Power Up Progress Bar Sprite*/
    self.progressBarPowerUp     = [[TCProgressBarNode alloc]
                                   initWithSize:self.progressBarSize
                                   backgroundColor:[UIColor grayColor]
                                   fillColor:[UIColor greenColor]
                                   borderColor:[UIColor blackColor]
                                   borderWidth:1.0f
                                   cornerRadius:4.0f];
    
    /**Buttons*/
    self.timeFreezeNode         = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonTimeFreeze] size:self.buttonSize];

    self.rapidFireNode          = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonRapidFire] size:self.buttonSize];
    
    self.fallingMonkeysNode     = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonFallingMonkey] size:self.buttonSize];

    self.pauseNode              = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonPause] size:self.buttonSize];

    self.playNode               = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonPlay] size:self.buttonSize];

}
- (void)setupControlsWithSize:(CGSize)size {
    /**Labels*/
    /*Total Score Label*/
    self.totalScoreLabel.text                               = @"0.00";
    self.totalScoreLabel.fontColor                          = [SKColor whiteColor];
    self.totalScoreLabel.fontSize                           = 44;
    self.totalScoreLabel.physicsBody.categoryBitMask        = uiControlCategory;
    
    /*Move Command Label*/
    self.moveCommandLabel.text                              = [Game stringForMove:[AppSingleton singleton].currentGame.currentMove];
    self.moveCommandLabel.fontColor                         = [SKColor whiteColor];
    self.moveCommandLabel.fontSize                          = 44;
    self.moveCommandLabel.physicsBody.categoryBitMask       = uiControlCategory;
    
    /*It Coins Label*/
    self.itCoinsLabel.text                                  = [NSString stringWithFormat:@"IT Coins: %d",[[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue]];
    self.itCoinsLabel.fontColor                             = [SKColor whiteColor];
    self.itCoinsLabel.fontSize                              = 44;
    self.itCoinsLabel.horizontalAlignmentMode               = SKLabelHorizontalAlignmentModeCenter;
    self.itCoinsLabel.physicsBody.categoryBitMask           = uiControlCategory;

    
    /**Progress Bars*/
    /*Free Coin Progress Bar Sprite*/
    NSNumber *freeCoinNumber                                = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultPointsTowardsFreeCoin];
    float freeCoinIn                                        = POINTS_NEEDED_FOR_FREE_COIN - [freeCoinNumber floatValue];
    self.progressBarFreeCoin.titleLabelNode.text            = [NSString stringWithFormat:@"IT Coin In %0.2f Points", freeCoinIn];
    self.progressBarFreeCoin.titleLabelNode.fontSize        = 25;
    self.progressBarFreeCoin.progress                       = [freeCoinNumber floatValue] / POINTS_NEEDED_FOR_FREE_COIN;
    self.progressBarFreeCoin.physicsBody.categoryBitMask    = uiControlCategory;
    
    /*Move Progress Bar Sprite*/
    self.progressBarMove.progress                           = 1.0f;
    self.progressBarMove.physicsBody.categoryBitMask        = uiControlCategory;
    
    /*Power Up Progress Bar Sprite*/
    self.progressBarPowerUp.progress                        = 1.0f;
    self.progressBarPowerUp.titleLabelNode.fontSize         = 25;
    self.progressBarPowerUp.physicsBody.categoryBitMask     = uiControlCategory;
    // Fade out the progress bar initially
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.0f];
    [self.progressBarPowerUp runAction:fadeOut];
    
    /**Power Up Buttons*/
    self.timeFreezeNode.name                                = kSINodeButtonTimeFreeze;
    self.timeFreezeNode.physicsBody.categoryBitMask         = uiControlCategory;
    
    self.rapidFireNode.name                                 = kSINodeButtonRapidFire;
    self.rapidFireNode.physicsBody.categoryBitMask          = uiControlCategory;
    
    self.fallingMonkeysNode.name                            = kSINodeButtonFallingMonkey;
    self.fallingMonkeysNode.physicsBody.categoryBitMask     = uiControlCategory;
    
    self.pauseNode.name                                     = kSINodeButtonPause;
    self.pauseNode.physicsBody.categoryBitMask              = uiControlCategory;

    self.playNode.name                                      = kSINodeButtonPlay;
    self.playNode.zPosition                                 = 3;
    self.playNode.physicsBody.categoryBitMask               = uiControlCategory;
}
- (void)layoutControlsWithSize:(CGSize)size {
    /*Move Progress Bar Sprite*/
    self.progressBarFreeCoin.position   = CGPointMake(size.width / 2.0f,
                                                      size.height - (self.progressBarSizeFreeCoin.height / 2.0) - VERTICAL_SPACING_8);
    [self addChild:self.progressBarFreeCoin];
    /**Labels*/
    /*Total Score Label*/
    self.totalScoreLabel.position       = CGPointMake((size.width / 2.0f),
                                                      self.progressBarFreeCoin.frame.origin.y - self.progressBarSizeFreeCoin.height - (self.totalScoreLabel.frame.size.height / 2) - VERTICAL_SPACING_8);
    [self addChild:self.totalScoreLabel];

    /*Move Command Label*/
    self.moveCommandLabel.position      = CGPointMake((size.width / 2.0f),
                                                      size.height / 2.0f);
    [self addChild:self.moveCommandLabel];
    
    /*IT Coins Label*/
    self.itCoinsLabel.position          = CGPointMake((size.width / 2.0f),
                                                      VERTICAL_SPACING_8 + self.timeFreezeNode.frame.size.height + VERTICAL_SPACING_8);
    [self addChild:self.itCoinsLabel];
    
    /**Power Up Buttons*/
    self.timeFreezeNode.position        = CGPointMake((size.width / 2.0f) - (self.timeFreezeNode.frame.size.width) - VERTICAL_SPACING_8,
                                                      (self.timeFreezeNode.frame.size.height / 2.0f) + VERTICAL_SPACING_8);
    [self addChild:self.timeFreezeNode];
    
    self.rapidFireNode.position         = CGPointMake((size.width / 2.0f),
                                                      (self.rapidFireNode.frame.size.height / 2.0f) + VERTICAL_SPACING_8);
    [self addChild:self.rapidFireNode];
    
    self.fallingMonkeysNode.position    = CGPointMake((size.width / 2.0f) + (self.fallingMonkeysNode.frame.size.width) + VERTICAL_SPACING_8,
                                                      (self.fallingMonkeysNode.frame.size.height / 2.0f) + VERTICAL_SPACING_8);
    [self addChild:self.fallingMonkeysNode];
    
    self.pauseNode.position             = CGPointMake(size.width - (self.pauseNode.frame.size.width / 2.0f) - VERTICAL_SPACING_8,
                                                      size.height - (self.progressBarSizeFreeCoin.height) - (self.pauseNode.frame.size.height / 2.0f) - VERTICAL_SPACING_8);
    [self addChild:self.pauseNode];
    
    self.playNode.position              = CGPointMake(size.width  / 2.0f,
                                                      size.height / 2.0f);
    [self.playNode runAction:[SKAction fadeAlphaTo:0.0 duration:0.0]];
    [self addChild:self.playNode];
    
    
    
    /**Progress Bars*/
    /*Move Progress Bar Sprite*/
    self.progressBarMove.position       = CGPointMake(CGRectGetMidX(self.frame),
                                                      (size.height / 2.0f) - self.moveCommandLabel.frame.size.height);
    [self addChild:self.progressBarMove];
    
    
    /*Power Up Progress Bar Sprite*/
    self.progressBarPowerUp.position    = CGPointMake(CGRectGetMidX(self.frame),
                                                      self.rapidFireNode.frame.size.height + VERTICAL_SPACING_16 + VERTICAL_SPACING_16);
    [self addChild:self.progressBarPowerUp];
    
    
}
- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scoreUpdate)              name:kSINotificationScoreUpdate         object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameStarted)              name:kSINotificationGameStarted         object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameEnded)                name:kSINotificationGameEnded           object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(correctMoveEntered:)      name:kSINotificationCorrectMove         object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(powerUpActivated)         name:kSINotificationPowerUpActive       object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(levelDidChange)           name:kSINotificationLevelDidChange      object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freeCoinEarned)           name:kSINotificationFreeCoinEarned      object:nil];
    
}
- (void)setupGestureRecognizersWithView:(SKView *)view {
    /*Both Game modes get tap*/
    self.tap                            = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRegistered:)];
    self.tap.numberOfTapsRequired       = 1;
    [[self view] addGestureRecognizer:self.tap];
    
    /*Both Game modes get swype*/
    /*Right swype*/
    self.swypeRight                                     = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swypeRegistered:)];
    self.swypeRight.direction                           = UISwipeGestureRecognizerDirectionRight;
    [[self view] addGestureRecognizer:self.swypeRight];
    
    /*Left swype*/
    self.swypeLeft                                      = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swypeRegistered:)];
    self.swypeLeft.direction                            = UISwipeGestureRecognizerDirectionLeft;
    [[self view] addGestureRecognizer:self.swypeLeft];
    /*Up/Down swype*/
    self.swypeTopBottom                                 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swypeRegistered:)];
    self.swypeTopBottom.direction                       = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    [[self view] addGestureRecognizer:self.swypeTopBottom];
    
    if (self.gameMode == SIGameModeOneHand) {
        /*Setup Shake recognizer*/
        self.restCount                                  = 0;
        self.isShakeActive                              = NO;
        [self startAccelerometerForShake];
    } else {
        /*Setup up pinch recognizer*/
        self.pinch                                      = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchRegistered:)];
        [[self view] addGestureRecognizer:self.pinch];
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
    leftEdge.physicsBody                        = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(-1.0f * (self.fallingMonkeySize.width / 2.0f), 0)
                                                                               toPoint:CGPointMake(-1.0f * (self.fallingMonkeySize.width / 2.0f), size.height)];
    leftEdge.physicsBody.categoryBitMask        = sideEdgeCategory;
    leftEdge.physicsBody.collisionBitMask       = sideEdgeCategory;
    [self addChild:leftEdge];
    
    SKNode *rightEdge                           = [SKNode node];
    rightEdge.physicsBody                       = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(size.width + (self.fallingMonkeySize.width / 2.0f), 0)
                                                                                toPoint:CGPointMake(size.width + (self.fallingMonkeySize.width / 2.0f), size.height)];
    rightEdge.physicsBody.categoryBitMask       = sideEdgeCategory;
    rightEdge.physicsBody.collisionBitMask      = sideEdgeCategory;
    [self addChild:rightEdge];
}
#pragma mark - Gesture Recognizer Methods
- (void)tapRegistered:(UITapGestureRecognizer *)tapGestrureRecognizer {
    CGPoint locationInView = [tapGestrureRecognizer locationInView:self.view];
    CGPoint locationInScene = [self convertPointFromView:locationInView];
    SKNode *node = [self nodeAtPoint:locationInScene];
    
    if ([AppSingleton singleton].currentGame.isPaused) {
        if ([node.name isEqualToString:kSINodeButtonPlay]) {
            [self play];
        }
    } else {
        if ([node.name isEqualToString:kSINodeButtonTimeFreeze]) {
            [self powerUpTapped:SIPowerUpTimeFreeze];
            
        } else if ([node.name isEqualToString:kSINodeButtonRapidFire]) {
            [self powerUpTapped:SIPowerUpRapidFire];
            
        } else if ([node.name isEqualToString:kSINodeButtonFallingMonkey]) {
            [self powerUpTapped:SIPowerUpFallingMonkeys];
            
        } else if ([node.name isEqualToString:kSINodeButtonPause]) {
            [self pause];
            
        } else {
            if (self.isButtonTouched == NO) {
                if (tapGestrureRecognizer.state == UIGestureRecognizerStateEnded) {
                    [[AppSingleton singleton] moveEnterForType:SIMoveTap];
                }
            }
        }
    }

}
-(void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch          = [touches anyObject];
    CGPoint location        = [touch locationInNode:self];
    SKNode *node            = [self nodeAtPoint:location];
    
    if ([AppSingleton singleton].currentGame.isPaused) {
        if ([node.name isEqualToString:kSINodeFallingMonkey]) {
            [self monkeyWasTapped:node];
        }
    }
}

- (void)swypeRegistered:(UISwipeGestureRecognizer *)swypeGestrureRecognizer {
    if ([AppSingleton singleton].currentGame.isPaused == NO) {
        if (swypeGestrureRecognizer.state == UIGestureRecognizerStateEnded) {
            [[AppSingleton singleton] moveEnterForType:SIMoveSwype];
        }
    }
    
}
- (void)pinchRegistered:(UIPinchGestureRecognizer *)pinchGestrureRecognizer {
    if ([AppSingleton singleton].currentGame.isPaused == NO) {
        if (pinchGestrureRecognizer.state == UIGestureRecognizerStateEnded) {
            [[AppSingleton singleton] moveEnterForType:SIMovePinch];
        }
    }
}
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
                    if (self.isShakeActive) {
                        self.restCount          = 0;
                    } else {
                        self.isShakeActive      = YES;
                        [self shakeRegistered];
                    }
                } else { /*Phone is at rest*/
                    if (self.isShakeActive) {
                        self.restCount          = self.restCount + 1;
                        if (self.restCount > REST_COUNT_THRESHOLD) {
                            self.isShakeActive  = NO;
                            self.restCount      = 0;
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
    self.moveCommandLabel.fontColor         = [SKColor whiteColor];
    if ([AppSingleton singleton].currentGame.gameMode == SIGameModeOneHand) {
        /*Setup Shake recognizer*/
        self.restCount                      = 0;
        self.isShakeActive                  = NO;
        [self startAccelerometerForShake];
    }
    [self setupGestureRecognizersWithView:self.view];
}
- (void)gameStarted {
    self.moveCommandLabel.fontColor         = [SKColor whiteColor];
    if ([AppSingleton singleton].currentGame.gameMode == SIGameModeOneHand) {
        /*Setup Shake recognizer*/
        self.restCount                      = 0;
        self.isShakeActive                  = NO;
        [self startAccelerometerForShake];
    }
}
- (void)gameEnded {
    [self removeGestureRecognizers];
    if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpNone) {
        [self powerUpDeactivated];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    EndGameScene *endScene      = [EndGameScene sceneWithSize:self.size];
    [Game transisitionToSKScene:endScene toSKView:self.view DoorsOpen:NO pausesIncomingScene:NO pausesOutgoingScene:NO duration:1.0];


}
- (void)replayGame {
    [[AppSingleton singleton] initAppSingletonWithGameMode:self.gameMode];
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
        NSDictionary *userInfo              = notification.userInfo;
        NSNumber *moveScore                 = userInfo[kSINSDictionaryKeyMoveScore];
        [self presentMoveScore:moveScore];
    }
    /*Set Current Move*/
    self.moveCommandLabel.text              = [Game stringForMove:[AppSingleton singleton].currentGame.currentMove];
    
    /*Update the total score label*/
//    self.totalScoreLabel.text           = [NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.totalScore];
    
    /*Get Next Background Color*/
    self.backgroundColor                    = [[AppSingleton singleton] newBackgroundColor];
}
- (void)levelDidChange {
    self.currentLevelLabel.text             = [AppSingleton singleton].currentGame.currentLevel;
}
- (void)pause {
    [[AppSingleton singleton] pause];
    
    [self.playNode runAction:[SKAction fadeAlphaTo:1.0 duration:0.7]];
    
    self.pauseScreenNode            = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[self getBluredScreenshot]]];
    self.pauseScreenNode.position   = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.pauseScreenNode.alpha      = 0;
    self.pauseScreenNode.zPosition  = 1;
    [self.pauseScreenNode runAction:[SKAction fadeAlphaTo:1 duration:0.4]];
    [self addChild:self.pauseScreenNode];
}
- (void)play {
    [self.pauseScreenNode removeFromParent];
    
    [self.playNode runAction:[SKAction fadeAlphaTo:0.0 duration:0.0]];
    
    [[AppSingleton singleton] play];
}

- (UIImage *)getBluredScreenshot {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 1);
    [self.view drawViewHierarchyInRect:self.view.frame afterScreenUpdates:YES];
    UIImage *ss = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setDefaults];
    [gaussianBlurFilter setValue:[CIImage imageWithCGImage:[ss CGImage]] forKey:kCIInputImageKey];
    [gaussianBlurFilter setValue:@10 forKey:kCIInputRadiusKey];
    
    CIImage *outputImage = [gaussianBlurFilter outputImage];
    CIContext *context   = [CIContext contextWithOptions:nil];
    CGRect rect          = [outputImage extent];
    rect.origin.x        += (rect.size.width  - ss.size.width ) / 2;
    rect.origin.y        += (rect.size.height - ss.size.height) / 2;
    rect.size            = ss.size;
    CGImageRef cgimg     = [context createCGImage:outputImage fromRect:rect];
    UIImage *image       = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    return image;
}
#pragma mark - GUI Functions
- (void)presentMoveScore:(NSNumber *)score {
    SKLabelNode *moveLabel                      = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    moveLabel.text                              = [NSString stringWithFormat:@"%0.2f",[score floatValue]];
    moveLabel.position                          = CGPointMake(self.frame.size.width / 2.0f, (self.frame.size.height / 2.0f) - self.moveCommandLabel.frame.size.height);
    moveLabel.physicsBody                       = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(moveLabel.frame.size.width, moveLabel.frame.size.height)];
    moveLabel.physicsBody.categoryBitMask       = uiControlCategory;
    moveLabel.physicsBody.contactTestBitMask    = bottomEdgeCategory;
    moveLabel.physicsBody.collisionBitMask      = 0;
    moveLabel.physicsBody.linearDamping         = 0.0f;
    
    SKAction *animateIn                         = [SKAction fadeInWithDuration:0.5];
    
    [moveLabel runAction:animateIn];
    
    // add the sprite node to the scene
    [self addChild:moveLabel];
    
    
    CGFloat randomDx = arc4random_uniform(LAUNCH_DX_VECTOR_MAX);
    while (randomDx < LAUNCH_DX_VECTOR_MIX) {
        randomDx = arc4random_uniform(LAUNCH_DX_VECTOR_MAX);
    }
    int randomDirection = arc4random_uniform(2);
    if (randomDirection == 1) { /*Negative Direction*/
        randomDx = -1.0f * randomDx;
    }
    
    CGFloat randomDy = ([score floatValue]/MAX_MOVE_SCORE) * LAUNCH_DY_MULTIPLIER;

//    NSLog(@"Vector... dX = %0.2f | Y = %0.2f",randomDx,randomDy);
    CGVector moveScoreVector = CGVectorMake(randomDx, randomDy);
    
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
    
    [node runAction:fadeSequence];
    
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
    [self.progressBarPowerUp runAction:fadeIn];
    SKAction *moveItCoinLabel = [SKAction moveByX:0 y:self.progressBarSize.height + VERTICAL_SPACING_8 duration:0.5];
    [self.itCoinsLabel runAction:moveItCoinLabel];

    
    /*Generic Start Power Up*/
    [self startPowerUpAllWithDuration:SIPowerUpDurationTimeFreeze withNode:self.timeFreezeNode];
}
- (void)endPowerUpTimeFreeze {
    /*Do any UI break down for Time Freeze*/
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3];
    [self.progressBarPowerUp runAction:fadeOut];
    SKAction *moveItCoinLabel = [SKAction moveByX:0 y:-1.0f * (self.progressBarSize.height + VERTICAL_SPACING_8) duration:0.5];
    [self.itCoinsLabel runAction:moveItCoinLabel];

    
    /*Generica End Power Up*/
    [self endPowerUpAll];
}

#pragma mark - Rapid Fire
- (void)startPowerUpRapidFire {
    /*Do any UI Setup for Rapid Fire*/
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.3];
    [self.progressBarPowerUp runAction:fadeIn];
    SKAction *moveItCoinLabel = [SKAction moveByX:0 y:self.progressBarSize.height + VERTICAL_SPACING_8 duration:0.5];
    [self.itCoinsLabel runAction:moveItCoinLabel];

    
    /*Generic Start Power Up*/
    [self startPowerUpAllWithDuration:SIPowerUpDurationRapidFire withNode:self.rapidFireNode];
}
- (void)endPowerUpRapidFire {
    /*Do any UI break down for Rapid Fire*/
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3];
    [self.progressBarPowerUp runAction:fadeOut];
    SKAction *moveItCoinLabel = [SKAction moveByX:0 y:-1.0f * (self.progressBarSize.height + VERTICAL_SPACING_8) duration:0.5];
    [self.itCoinsLabel runAction:moveItCoinLabel];

    
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
    self.monkeySpeed        = 1.0;
    
    /*Do any UI Set UI for Falling Monkeys*/
    SKAction *fadeOut       = [SKAction fadeOutWithDuration:1.0];
    [self.progressBarMove       runAction:fadeOut];
    [self.moveCommandLabel      runAction:fadeOut];
    [self.itCoinsLabel          runAction:fadeOut];
    [self.timeFreezeNode        runAction:fadeOut];
    [self.rapidFireNode         runAction:fadeOut];
    [self.fallingMonkeysNode    runAction:fadeOut];
    [self.pauseNode             runAction:fadeOut];
    
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
    [self.moveCommandLabel      runAction:fadeIn];
    [self.itCoinsLabel          runAction:fadeIn];
    [self.timeFreezeNode        runAction:fadeIn];
    [self.rapidFireNode         runAction:fadeIn];
    [self.fallingMonkeysNode    runAction:fadeIn];
    [self.pauseNode             runAction:fadeIn];
    SKAction *resumeGameBlock = [SKAction runBlock:^{
        /*Resume Game Play*/
        [[AppSingleton singleton] play];
    }];
    SKAction *resumeSequence = [SKAction sequence:@[fadeIn, resumeGameBlock]];
    [self.progressBarMove       runAction:resumeSequence];


    /*Generica End Power Up*/
    [self endPowerUpAll]; //this will disable the powerup
}
#pragma mark - Monkey Methods!
- (void)launchMonkey {
    /*Get Random Number Max... based of width of screen and monkey*/
    CGFloat validMax                        = self.frame.size.width - (self.fallingMonkeySize.width / 2.0f);
    CGFloat xLocation                       = arc4random_uniform(validMax); /*This will be the y axis launch point*/
    while (xLocation < self.fallingMonkeySize.width / 2.0) {
        xLocation                           = arc4random_uniform(validMax);
    }
    CGFloat yLocation                       = self.frame.size.height + self.fallingMonkeySize.height;
    
    /*Make Monkey*/
    SKSpriteNode *monkey = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageFallingMonkeys] size:self.fallingMonkeySize];
    monkey.position                         = CGPointMake(xLocation, yLocation);
    monkey.name                             = kSINodeFallingMonkey;
    monkey.physicsBody                      = [SKPhysicsBody bodyWithRectangleOfSize:self.fallingMonkeySize];
    monkey.physicsBody.linearDamping        = 0.0f;
    monkey.physicsBody.categoryBitMask      = monkeyCategory;
    monkey.physicsBody.contactTestBitMask   = bottomEdgeCategory;
    monkey.physicsBody.collisionBitMask     = sideEdgeCategory;
    self.physicsWorld.gravity               = CGVectorMake(0, -self.monkeySpeed);
    
    [self addChild:monkey];
    
    
    //create the vector
    NSLog(@"Launching Monkey with speed of: %0.1f",self.monkeySpeed);
    CGVector monkeyVector                   = CGVectorMake(0, -1.0);
    [monkey.physicsBody applyImpulse:monkeyVector];
    
    /*Call Function again*/
    
    CGFloat randomDelay                     = (float)arc4random_uniform(75) / 100.0f;
    
    self.monkeySpeed                        = self.monkeySpeed + MONKEY_SPEED_INCREASE;
    
    [self performSelector:@selector(launchMonkey) withObject:nil afterDelay:randomDelay];

}
/**Called when a monkey is tapped...*/
- (void)monkeyWasTapped:(SKNode *)monkey {
    /*Remove that monkey*/
    [monkey removeFromParent];
    
    NSLog(@"Before Monkey tapped total score is: %0.2f",[AppSingleton singleton].currentGame.totalScore);
    
    [AppSingleton singleton].currentGame.totalScore = [AppSingleton singleton].currentGame.totalScore + VALUE_OF_MONKEY;
    
    NSLog(@"After adding VALUE_OF_MONKEY score to tapped Monkey the total score is: %0.2f",[AppSingleton singleton].currentGame.totalScore);

    [[AppSingleton singleton] setAndCheckDefaults:VALUE_OF_MONKEY];
    
    NSLog(@"After setAndCheckDefaults total score is: %0.2f",[AppSingleton singleton].currentGame.totalScore);
    
    self.totalScoreLabel.text                       = [NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.totalScore];
    
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
    [self.itCoinsLabel runAction:[SKAction rotateByAngle:M_PI * 2 duration:1.0]];
//    self.itCoinsLabel.zRotation = M_PI * 2;
}
-(void)update:(NSTimeInterval)currentTime {
    self.totalScoreLabel.text                       = [NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.totalScore];
    
    self.itCoinsLabel.text                          = [NSString stringWithFormat:@"IT Coins: %d",[[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue]];
    
    
    self.progressBarFreeCoin.progress               = [AppSingleton singleton].currentGame.freeCoinPercentRemaining;
    if (POINTS_NEEDED_FOR_FREE_COIN - [AppSingleton singleton].currentGame.freeCoinInPoints > 0.0f) {
        self.progressBarFreeCoin.titleLabelNode.text    = [NSString stringWithFormat:@"IT Coin in %0.2f points",POINTS_NEEDED_FOR_FREE_COIN - [AppSingleton singleton].currentGame.freeCoinInPoints];
    }
    
    if ([AppSingleton singleton].currentGame.isPaused == NO) {
        [self.progressBarMove setProgress:[AppSingleton singleton].currentGame.moveScorePercentRemaining];
        if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpNone) {
            [self.progressBarPowerUp setProgress:[AppSingleton singleton].currentGame.powerUpPercentRemaining];
            self.progressBarPowerUp.titleLabelNode.text = [NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.powerUpPercentRemaining * MAX_MOVE_SCORE];
        }
    }
}
@end
