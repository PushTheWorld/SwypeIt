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
// Local Controller Import
#import "AppSingleton.h"
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
@property (assign, nonatomic) BOOL               isGameActive;
@property (assign, nonatomic) BOOL               isShakeActive;
@property (assign, nonatomic) CGSize             fallingMonkeySize;
@property (assign, nonatomic) CGFloat            fontSize;
@property (assign, nonatomic) CGFloat            progressViewBoarderWidth;
@property (assign, nonatomic) CGFloat            progressViewHeight;
@property (assign, nonatomic) int                gameMode;
@property (assign, nonatomic) int                monkeyDestroyedCount;


#pragma mark - Private Properties
@property (assign, nonatomic) NSInteger          restCount;

#pragma mark - Constraints

#pragma mark - UI Controls
@property (strong, nonatomic) UIButton          *rapidFireButton;
@property (strong, nonatomic) UIButton          *replayGameButton;
@property (strong, nonatomic) UIButton          *fallingMonkeysButton;
@property (strong, nonatomic) UIButton          *storeButton;
@property (strong, nonatomic) UIButton          *timeFreezeButton;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIFont            *nextMoveCommandFont;
@property (strong, nonatomic) UIFont            *moveCommandFont;
@property (strong, nonatomic) UIFont            *totalScoreFont;
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UILabel           *currentLevelLabel;
@property (strong, nonatomic) SKLabelNode       *moveCommandLabel;
@property (strong, nonatomic) UILabel           *powerUpLabel;
@property (strong, nonatomic) SKLabelNode       *totalScoreLabel;

@end

@implementation GameScene

-(nonnull instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        
        [self setupUserInterfaceWithSize:size];
    }
    return self;
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UI Life Cycle Methods
- (void)setupUserInterfaceWithSize:(CGSize)size {
    [self createConstants];
    [self createControls];
    [self setupControls];
    [self layoutControlsWithSize:size];
    [self registerForNotifications];
    [self setupGestureRecognizers];
}
- (void)createConstants {

}
- (void)createControls {
    /*Move Command Label*/
    self.moveCommandLabel   = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    
    /*Total Score Label*/
    self.totalScoreLabel    = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];

}
- (void)setupControls {
    /*Move Command Label*/
    self.moveCommandLabel.text      = @"Tap It";
    self.moveCommandLabel.fontColor = [SKColor whiteColor];
    self.moveCommandLabel.fontSize  = 44;

    /*Total Score Label*/
    self.totalScoreLabel.text       = @"0.00";
    self.totalScoreLabel.fontColor  = [SKColor whiteColor];
    self.totalScoreLabel.fontSize   = 44;
}
- (void)layoutControlsWithSize:(CGSize)size {
    /*Move Command Label*/
    self.moveCommandLabel.position  = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:self.moveCommandLabel];
    
    /*Total Score Label*/
    self.totalScoreLabel.position   = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:self.moveCommandLabel];

}
- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scoreUpdate)              name:kSINotificationScoreUpdate         object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameStarted)              name:kSINotificationGameStarted         object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameEnded)                name:kSINotificationGameEnded           object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(correctMoveEntered:)      name:kSINotificationCorrectMove         object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(powerUpActivated)         name:kSINotificationPowerUpActive       object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(levelDidChange)           name:kSINotificationLevelDidChange      object:nil];
    
}
- (void)setupGestureRecognizers {
    /*Both Game modes get tap*/
    UITapGestureRecognizer *tapGR                       = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRegistered:)];
    tapGR.numberOfTapsRequired                          = 1;
    [self.view addGestureRecognizer:tapGR];
    
    /*Both Game modes get swype*/
    /*Right swype*/
    UISwipeGestureRecognizer *swypeRightGR              = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swypeRegistered:)];
    swypeRightGR.direction                              = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swypeRightGR];
    /*Left swype*/
    UISwipeGestureRecognizer *swypeLeftGR               = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swypeRegistered:)];
    swypeLeftGR.direction                               = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swypeLeftGR];
    /*Up/Down swype*/
    UISwipeGestureRecognizer *swypeTopBottomGR          = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swypeRegistered:)];
    swypeTopBottomGR.direction                          = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swypeTopBottomGR];
    
    if (self.gameMode == SIGameModeOneHand) {
        /*Setup Shake recognizer*/
        self.restCount                                      = 0;
        self.isShakeActive                                  = NO;
        [self startAccelerometerForShake];
    } else {
        /*Setup up pinch recognizer*/
        UIPinchGestureRecognizer *pinchGR                   = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchRegistered:)];
        [self.view addGestureRecognizer:pinchGR];
    }
}

#pragma mark - Gesture Recognizer Methods
- (void)tapRegistered:(UITapGestureRecognizer *)tapGestrureRecognizer {
    if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpCostFallingMonkeys) {
        [[AppSingleton singleton] moveEnterForType:SIMoveTap];
    }
}
- (void)swypeRegistered:(UISwipeGestureRecognizer *)swipeGestrureRecognizer {
    if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpCostFallingMonkeys) {
        [[AppSingleton singleton] moveEnterForType:SIMoveSwype];
    }
    
}
- (void)pinchRegistered:(UIPinchGestureRecognizer *)pinchGestrureRecognizer {
    if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpCostFallingMonkeys) {
        if (pinchGestrureRecognizer.state == UIGestureRecognizerStateEnded) {
            [[AppSingleton singleton] moveEnterForType:SIMovePinch];
        }
    }
}
- (void)shakeRegistered {
    if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpCostFallingMonkeys) {
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
#pragma mark - Class Methods
- (void)gameStarted {
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.currentMoveProgressView.hidden     = NO;
//    self.replayGameButton.hidden            = YES;
//    self.storeButton.hidden                 = YES;
//    self.fallingMonkeysButton.hidden           = NO;
//    self.timeFreezeButton.hidden            = NO;
//    self.rapidFireButton.hidden             = NO;
//    self.powerUpLabel.hidden                = NO;
    self.moveCommandLabel.fontColor         = [SKColor whiteColor];
//    self.totalScoreLabel.textColor          = [UIColor whiteColor];
    if (self.gameMode == SIGameModeOneHand) {
        /*Setup Shake recognizer*/
        self.restCount                      = 0;
        self.isShakeActive                  = NO;
        [self startAccelerometerForShake];
    }
}
- (void)gameEnded {
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.moveCommandLabel.text              = @"Game Over!";
    
//    self.replayGameButton.hidden            = NO;
//    self.storeButton.hidden                 = NO;
//    self.fallingMonkeysButton.hidden           = YES;
//    self.timeFreezeButton.hidden            = YES;
//    self.rapidFireButton.hidden             = YES;
//    self.powerUpLabel.hidden                = YES;
    self.moveCommandLabel.fontColor         = [UIColor blackColor];
//    self.totalScoreLabel.textColor          = [UIColor blackColor];
//    self.powerUpProgressView.alpha          = 0.0f;
    
    self.view.backgroundColor               = [UIColor sandColor];
}
- (void)replayGame {
    [[AppSingleton singleton] initAppSingletonWithGameMode:self.gameMode];
    [[AppSingleton singleton] startGame];
    [self correctMoveEntered:nil];
}
- (void)scoreUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.currentMoveProgressView setProgress:[AppSingleton singleton].currentGame.moveScorePercentRemaining];
//        if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpNone) {
//            //            NSLog(@"Power up percent remainging: %0.2f",[AppSingleton singleton].currentGame.powerUpPercentRemaining);
//            [self.powerUpProgressView setProgress:[AppSingleton singleton].currentGame.powerUpPercentRemaining];
//        }
    });
}
- (void)correctMoveEntered:(NSNotification *)notification {
    if (notification) {
        NSDictionary *userInfo          = notification.userInfo;
        NSNumber *moveScore             = userInfo[kSINSDictionaryKeyMoveScore];
        [self presentMoveScore:moveScore];
    }
    /*Set Current Move*/
    self.moveCommandLabel.text          = [Game stringForMove:[AppSingleton singleton].currentGame.currentMove];
    
    /*Update the total score label*/
    self.totalScoreLabel.text           = [NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.totalScore];
    
    /*Get Next Background Color*/
    self.view.backgroundColor           = [[AppSingleton singleton] newBackgroundColor];
}
- (void)levelDidChange {
    self.currentLevelLabel.text         = [AppSingleton singleton].currentGame.currentLevel;
}
#pragma mark - GUI Functions
- (void)presentMoveScore:(NSNumber *)score {
    SKLabelNode *moveLabel              = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    moveLabel.text                      = [NSString stringWithFormat:@"%0.2f",[score floatValue]];
    moveLabel.position                  = CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0);
    moveLabel.physicsBody               = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(moveLabel.frame.size.width, moveLabel.frame.size.height)];
    moveLabel.physicsBody.linearDamping = 0.0f;
    
    SKAction *animateIn = [SKAction fadeInWithDuration:0.5];
    
    [moveLabel runAction:animateIn];
    
    // add the sprite node to the scene
    [self addChild:moveLabel];
    
    CGFloat randomDx = arc4random_uniform(10);
    CGFloat randomDy = arc4random_uniform(10);
    CGVector moveScoreVector = CGVectorMake(randomDx, randomDy);
    
    [moveLabel.physicsBody applyImpulse:moveScoreVector];

}
@end
