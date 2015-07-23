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
#define MONKEY_SPEED_INCREASE           0.5
// Local Controller Import
#import "AppSingleton.h"
#import "CustomProgressBar.h"
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
@property (assign, nonatomic) CGSize             progressBarSize;
@property (assign, nonatomic) CGSize             buttonSize;
@property (assign, nonatomic) CGFloat            fontSize;
@property (assign, nonatomic) CGFloat            monkeySpeed;
@property (assign, nonatomic) CGPoint            leftButtonCenterPoint;
@property (assign, nonatomic) int                gameMode;


#pragma mark - Private Properties
@property (assign, nonatomic) NSInteger          restCount;

#pragma mark - Constraints

#pragma mark - UI Controls
@property (strong, nonatomic) CustomProgressBar *progressBarMove;
@property (strong, nonatomic) CustomProgressBar *progressBarPowerUp;
@property (strong, nonatomic) SKLabelNode       *itCoinsLabel;
@property (strong, nonatomic) SKLabelNode       *moveCommandLabel;
@property (strong, nonatomic) SKLabelNode       *totalScoreLabel;
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

@implementation GameScene

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
//        self.backgroundColor = [SKColor blackColor];
        
        self.gameMode                       = SIGameModeTwoHand;
        self.isButtonTouched                = NO;
        
        self.physicsWorld.contactDelegate   = self;
        
        [self setupUserInterfaceWithSize:size];
    }
    return self;
}
- (void)didMoveToView:(nonnull SKView *)view {
    [self setupGestureRecognizersWithView:view];
    [[AppSingleton singleton] startGame];
    /*Get Background Color*/
    self.backgroundColor                = [[AppSingleton singleton] newBackgroundColor];
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
    [self createControls];
    [self setupControlsWithSize:size];
    [self layoutControlsWithSize:size];
    [self registerForNotifications];
    [self addBottomEdge:size];
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
    
    
    /*Init Fonts*/
    self.powerUpButtonFont              = [UIFont fontWithName:kSIFontFuturaMedium size:self.fontSize - 4.0f];
    self.nextMoveCommandFont            = [UIFont fontWithName:kSIFontFuturaMedium size:self.fontSize - 4.0f];
    self.moveCommandFont                = [UIFont fontWithName:kSIFontFuturaMedium size:self.fontSize];
    self.totalScoreFont                 = [UIFont fontWithName:kSIFontFuturaMedium size:self.fontSize * 2.0f];

    
}
- (void)createControls {
    /**Labels*/
    /*Total Score Label*/
    self.totalScoreLabel        = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    
    /*Move Command Label*/
    self.moveCommandLabel       = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    
    /*It Coins Label*/
    self.itCoinsLabel           = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    
    /**Progress Bars*/
    /*Move Progress Bar Sprite*/
    self.progressBarMove        = [CustomProgressBar new];
    
    /*Power Up Progress Bar Sprite*/
    self.progressBarPowerUp     = [CustomProgressBar new];
    
    /**Power Up Buttons*/
    self.timeFreezeNode         = [SKSpriteNode spriteNodeWithImageNamed:kSIImageButtonTimeFreeze];
    
    self.rapidFireNode          = [SKSpriteNode spriteNodeWithImageNamed:kSIImageButtonRapidFire];
    
    self.fallingMonkeysNode     = [SKSpriteNode spriteNodeWithImageNamed:kSIImageButtonFallingMonkey];

}
- (void)setupControlsWithSize:(CGSize)size {
    /**Labels*/
    /*Total Score Label*/
    self.totalScoreLabel.text                           = @"0.00";
    self.totalScoreLabel.fontColor                      = [SKColor whiteColor];
    self.totalScoreLabel.fontSize                       = 44;
    self.totalScoreLabel.physicsBody.categoryBitMask    = uiControlCategory;
    
    /*Move Command Label*/
    self.moveCommandLabel.text                          = [Game stringForMove:[AppSingleton singleton].currentGame.currentMove];
    self.moveCommandLabel.fontColor                     = [SKColor whiteColor];
    self.moveCommandLabel.fontSize                      = 44;
    self.moveCommandLabel.physicsBody.categoryBitMask   = uiControlCategory;
    
    /*It Coins Label*/
    self.itCoinsLabel.text                              = [NSString stringWithFormat:@"IT Coins: %d",[[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue]];
    self.itCoinsLabel.fontColor                         = [SKColor whiteColor];
    self.itCoinsLabel.fontSize                          = 44;
    self.itCoinsLabel.horizontalAlignmentMode           = SKLabelHorizontalAlignmentModeCenter;
    self.itCoinsLabel.physicsBody.categoryBitMask       = uiControlCategory;

    
    /**Progress Bars*/
    /*Move Progress Bar Sprite*/
    self.progressBarMove.physicsBody.categoryBitMask    = uiControlCategory;
    [self.progressBarMove configureForSize:self.progressBarSize withType:SIProgressBarMove];
    [self.progressBarMove setProgress:1.0];
    
    /*Power Up Progress Bar Sprite*/
    self.progressBarPowerUp.physicsBody.categoryBitMask = uiControlCategory;
    [self.progressBarPowerUp configureForSize:self.progressBarSize withType:SIProgressBarPowerUp];
    [self.progressBarPowerUp setProgress:1.0];
    // Fade out the progress bar initially
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0];
    [self.progressBarPowerUp runAction:fadeOut];
    
    /**Power Up Buttons*/
    CGFloat scaleFactor                                 = 0.33;
    
    self.timeFreezeNode.name                            = kSINodeButtonTimeFreeze;
    self.timeFreezeNode.physicsBody.categoryBitMask     = uiControlCategory;
    [self.timeFreezeNode setScale:scaleFactor];
    
    self.rapidFireNode.name                             = kSINodeButtonRapidFire;
    self.rapidFireNode.physicsBody.categoryBitMask      = uiControlCategory;
    [self.rapidFireNode setScale:scaleFactor];
    
    self.fallingMonkeysNode.name                        = kSINodeButtonFallingMonkey;
    self.fallingMonkeysNode.physicsBody.categoryBitMask = uiControlCategory;
    [self.fallingMonkeysNode setScale:scaleFactor];

    
}
- (void)layoutControlsWithSize:(CGSize)size {
    /**Labels*/
    /*Total Score Label*/
    self.totalScoreLabel.position       = CGPointMake(CGRectGetMidX(self.frame),
                                                      CGRectGetMaxY(self.frame) - self.totalScoreLabel.frame.size.height - VERTICAL_SPACING_16);
    [self addChild:self.totalScoreLabel];

    /*Move Command Label*/
    self.moveCommandLabel.position      = CGPointMake(CGRectGetMidX(self.frame),
                                                      CGRectGetMidY(self.frame));
    [self addChild:self.moveCommandLabel];
    
    /*IT Coins Label*/
    self.itCoinsLabel.position          = CGPointMake(CGRectGetMidX(self.frame),
                                                      VERTICAL_SPACING_8 + self.timeFreezeNode.frame.size.height + VERTICAL_SPACING_8);
    [self addChild:self.itCoinsLabel];
    
    /**Power Up Buttons*/
    self.timeFreezeNode.position        = CGPointMake(CGRectGetMidX(self.frame) - (self.timeFreezeNode.frame.size.width) - VERTICAL_SPACING_8,
                                                      (self.timeFreezeNode.frame.size.height / 2.0f) + VERTICAL_SPACING_8);
    [self addChild:self.timeFreezeNode];
    
    self.rapidFireNode.position         = CGPointMake(CGRectGetMidX(self.frame),
                                                      (self.rapidFireNode.frame.size.height / 2.0f) + VERTICAL_SPACING_8);
    [self addChild:self.rapidFireNode];
    
    self.fallingMonkeysNode.position    = CGPointMake(CGRectGetMidX(self.frame) + (self.fallingMonkeysNode.frame.size.width) + VERTICAL_SPACING_8,
                                                      (self.fallingMonkeysNode.frame.size.height / 2.0f) + VERTICAL_SPACING_8);
    [self addChild:self.fallingMonkeysNode];
    
    /**Progress Bars*/
    /*Move Progress Bar Sprite*/
    self.progressBarMove.position       = CGPointMake((size.width / 2.0f) - (self.progressBarSize.width / 4.0f),
                                                      (size.height / 2.0f) - self.moveCommandLabel.frame.size.height);
    [self addChild:self.progressBarMove];
    
    
    /*Power Up Progress Bar Sprite*/
    self.progressBarPowerUp.position    = CGPointMake((size.width / 2.0f) - (self.progressBarSize.width / 4.0f),
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
-(void) addBottomEdge:(CGSize) size {
    SKNode *bottomEdge                          = [SKNode node];
    bottomEdge.physicsBody                      = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 1) toPoint:CGPointMake(size.width, 1)];
    bottomEdge.physicsBody.categoryBitMask      = bottomEdgeCategory;
    bottomEdge.physicsBody.collisionBitMask     = 0;
    [self addChild:bottomEdge];
    
}
#pragma mark - Gesture Recognizer Methods
- (void)tapRegistered:(UITapGestureRecognizer *)tapGestrureRecognizer {
    CGPoint locationInView = [tapGestrureRecognizer locationInView:self.view];
    CGPoint locationInScene = [self convertPointFromView:locationInView];
    SKNode *node = [self nodeAtPoint:locationInScene];
    
    if ([node.name isEqualToString:kSINodeButtonTimeFreeze]) {
        [self powerUpTapped:SIPowerUpTimeFreeze];
        
    } else if ([node.name isEqualToString:kSINodeButtonRapidFire]) {
        [self powerUpTapped:SIPowerUpRapidFire];
        
    } else if ([node.name isEqualToString:kSINodeButtonFallingMonkey]) {
        [self powerUpTapped:SIPowerUpFallingMonkeys];
        
    } else if ([node.name isEqualToString:kSINodeFallingMonkey]) {
        [self monkeyWasTapped:node];
    } else {
        if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpFallingMonkeys) {
            if (self.isButtonTouched == NO) {
                if (tapGestrureRecognizer.state == UIGestureRecognizerStateEnded) {
                    [[AppSingleton singleton] moveEnterForType:SIMoveTap];
                }
            }
        }
    }
}
- (void)swypeRegistered:(UISwipeGestureRecognizer *)swypeGestrureRecognizer {
    if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpFallingMonkeys) {
        if (swypeGestrureRecognizer.state == UIGestureRecognizerStateEnded) {
            [[AppSingleton singleton] moveEnterForType:SIMoveSwype];
        }
    }
    
}
- (void)pinchRegistered:(UIPinchGestureRecognizer *)pinchGestrureRecognizer {
    if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpFallingMonkeys) {
        if (pinchGestrureRecognizer.state == UIGestureRecognizerStateEnded) {
            [[AppSingleton singleton] moveEnterForType:SIMovePinch];
        }
    }
}
- (void)shakeRegistered {
    if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpFallingMonkeys) {
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
- (void)gameStarted {
    self.moveCommandLabel.fontColor         = [SKColor whiteColor];
    if (self.gameMode == SIGameModeOneHand) {
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
    EndGameScene *endScene = [EndGameScene sceneWithSize:self.size];
    [self.view presentScene:endScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.5]];

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
#pragma mark - Scene Methods
-(void)update:(NSTimeInterval)currentTime {
    self.totalScoreLabel.text   = [NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.totalScore];

    self.itCoinsLabel.text      = [NSString stringWithFormat:@"IT Coins: %d",[[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue]];
    
//    if (![newText isEqualToString:self.itCoinsLabel.text]) {
//        self.itCoinsLabel.text  = newText;
//        SKAction *moveItCoins   = [SKAction moveToX:VERTICAL_SPACING_8 + (self.itCoinsLabel.frame.size.width / 2.0f) duration:0.2];
//        [self.itCoinsLabel runAction:moveItCoins];
//    }

    [self.progressBarMove setProgress:[AppSingleton singleton].currentGame.moveScorePercentRemaining];
    if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpNone) {
        [self.progressBarPowerUp setProgress:[AppSingleton singleton].currentGame.powerUpPercentRemaining];
    }
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
    [AppSingleton singleton].currentGame.currentPowerUp = SIPowerUpNone;
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
    
}

#pragma mark - Falling Monkeys
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
    
    SKAction *fadeIn = [SKAction fadeInWithDuration:1.0];
    [self.progressBarMove       runAction:fadeIn];
    [self.moveCommandLabel      runAction:fadeIn];
    [self.itCoinsLabel          runAction:fadeIn];
    [self.timeFreezeNode        runAction:fadeIn];
    [self.rapidFireNode         runAction:fadeIn];
    [self.fallingMonkeysNode    runAction:fadeIn];
    
    [self correctMoveEntered:nil];
    
    /*Generica End Power Up*/
    [self endPowerUpAll];
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
    SKSpriteNode *monkey                    = [SKSpriteNode spriteNodeWithImageNamed:kSIImageFallingMonkeys];
    monkey.position                         = CGPointMake(xLocation, yLocation);
    monkey.size                             = self.fallingMonkeySize;
    monkey.name                             = kSINodeFallingMonkey;
    monkey.physicsBody                      = [SKPhysicsBody bodyWithCircleOfRadius:monkey.frame.size.width/2];
    monkey.physicsBody.linearDamping        = 0.0f;
    monkey.physicsBody.categoryBitMask      = monkeyCategory;
    monkey.physicsBody.contactTestBitMask   = bottomEdgeCategory;
    monkey.physicsBody.collisionBitMask     = 1;
    self.physicsWorld.gravity               = CGVectorMake(0, -1);
    
    [self addChild:monkey];
    
    
    //create the vector
    NSLog(@"Launching Monkey with speed of: %0.1f",self.monkeySpeed);
    CGVector monkeyVector                   = CGVectorMake(0, -self.monkeySpeed);
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
    
    [AppSingleton singleton].currentGame.totalScore = [AppSingleton singleton].currentGame.totalScore + VALUE_OF_MONKEY;
    
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


@end
