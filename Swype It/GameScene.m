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
#import "CustomProgressBar.h"
#import "EndGameScene.h"
#import "GameScene.h"
// Framework Import
#import <CoreMotion/CoreMotion.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "AGSpriteButton.h"
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
@property (assign, nonatomic) CGSize             progressBarSize;
@property (assign, nonatomic) CGSize             buttonSize;
@property (assign, nonatomic) CGFloat            fontSize;
@property (assign, nonatomic) CGFloat            progressViewBoarderWidth;
@property (assign, nonatomic) CGFloat            progressViewHeight;
@property (assign, nonatomic) int                gameMode;
@property (assign, nonatomic) int                monkeyDestroyedCount;


#pragma mark - Private Properties
@property (assign, nonatomic) NSInteger          restCount;

#pragma mark - Constraints

#pragma mark - UI Controls
@property (strong, nonatomic) CustomProgressBar *progressBar;
@property (strong, nonatomic) CustomProgressBar *powerupProgressBar;
@property (strong, nonatomic) AGSpriteButton    *rapidFireButton;
@property (strong, nonatomic) AGSpriteButton    *fallingMonkeysButton;
@property (strong, nonatomic) AGSpriteButton    *timeFreezeButton;
@property (strong, nonatomic) UIFont            *powerupButtonFont;
@property (strong, nonatomic) UIFont            *nextMoveCommandFont;
@property (strong, nonatomic) UIFont            *moveCommandFont;
@property (strong, nonatomic) UIFont            *totalScoreFont;
@property (strong, nonatomic) UILabel           *currentLevelLabel;
@property (strong, nonatomic) SKLabelNode       *moveCommandLabel;
@property (strong, nonatomic) UILabel           *powerUpLabel;
@property (strong, nonatomic) SKLabelNode       *totalScoreLabel;

#pragma mark - Gesture Recognizers
@property (nonatomic) UITapGestureRecognizer    *tap;
@property (nonatomic) UISwipeGestureRecognizer  *swypeTopBottom;
@property (nonatomic) UISwipeGestureRecognizer  *swypeLeft;
@property (nonatomic) UISwipeGestureRecognizer  *swypeRight;
@property (nonatomic) UIPinchGestureRecognizer  *pinch;






@end

@implementation GameScene

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        
        self.gameMode = SIGameModeTwoHand;
        
        [self setupUserInterfaceWithSize:size];
        
        
        [[AppSingleton singleton] runFirstGame];
    }
    return self;
}
- (void)didMoveToView:(nonnull SKView *)view {
    [self setupGestureRecognizersWithView:view];
}
-(void)dealloc {
    [self unRegisterForGestureRecognizer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)unRegisterForGestureRecognizer {
    [self.view removeGestureRecognizer:self.tap];
    [self.view removeGestureRecognizer:self.swypeTopBottom];
    [self.view removeGestureRecognizer:self.swypeRight];
    [self.view removeGestureRecognizer:self.swypeLeft];
    [self.view removeGestureRecognizer:self.pinch];
}
#pragma mark - UI Life Cycle Methods
- (void)setupUserInterfaceWithSize:(CGSize)size {
    [self createConstants];
    [self createControls];
    [self setupControlsWithSize:size];
    [self layoutControlsWithSize:size];
    [self registerForNotifications];
}
- (void)createConstants {
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
    self.buttonSize                     = CGSizeMake(SCREEN_WIDTH/4.0, SCREEN_WIDTH/4.0f);

    self.progressBarSize                = CGSizeMake(SCREEN_WIDTH / 2.0f, (SCREEN_WIDTH / 2.0f) * 0.2);
    
    /*Init Fonts*/
    self.powerupButtonFont              = [UIFont fontWithName:@"Futura Medium" size:self.fontSize - 4.0f];
    self.nextMoveCommandFont            = [UIFont fontWithName:@"Futura Medium" size:self.fontSize - 4.0f];
    self.moveCommandFont                = [UIFont fontWithName:@"Futura Medium" size:self.fontSize];
    self.totalScoreFont                 = [UIFont fontWithName:@"Futura Medium" size:self.fontSize * 2.0f];

    
}
- (void)createControls {
    /*Total Score Label*/
    self.totalScoreLabel        = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    
    /*Move Command Label*/
    self.moveCommandLabel       = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    
    /*Progress View Sprite*/
    self.progressBar            = [CustomProgressBar new];
    
    /*Time Freeze Button*/
    self.timeFreezeButton       = [AGSpriteButton buttonWithColor:[UIColor whiteColor] andSize:self.buttonSize];
    
    /*Rapid Fire Button*/
    self.rapidFireButton        = [AGSpriteButton buttonWithColor:[UIColor whiteColor] andSize:self.buttonSize];

    /*Falling Monkeys Button*/
    self.fallingMonkeysButton   = [AGSpriteButton buttonWithColor:[UIColor whiteColor] andSize:self.buttonSize];

}
- (void)setupControlsWithSize:(CGSize)size {
    /*Total Score Label*/
    self.totalScoreLabel.text       = @"0.00";
    self.totalScoreLabel.fontColor  = [SKColor whiteColor];
    self.totalScoreLabel.fontSize   = 44;
    
    /*Move Command Label*/
    self.moveCommandLabel.text      = [Game stringForMove:[AppSingleton singleton].currentGame.currentMove];
    self.moveCommandLabel.fontColor = [SKColor whiteColor];
    self.moveCommandLabel.fontSize  = 44;
    
    /*Progress View Sprite*/
    [self.progressBar configureForSize:self.progressBarSize];
    
    /*Time Freeze Button*/
    [self.timeFreezeButton setLabelWithText:@"Time Freeze" andFont:self.powerupButtonFont withColor:[SKColor blackColor]];
    self.timeFreezeButton.position = CGPointMake(size.width/4.0f, (self.timeFreezeButton.frame.size.height / 2.0f) + VERTICAL_SPACING_8);
    [self.timeFreezeButton performBlock:^{
        [self powerUpTapped:SIPowerUpTimeFreeze];
    } onEvent:AGButtonControlEventTouchUpInside];
    
    /*Rapid Fire Button*/
    [self.rapidFireButton setLabelWithText:@"Rapid Fire" andFont:self.powerupButtonFont withColor:[SKColor blackColor]];
    self.rapidFireButton.position = CGPointMake(size.width/2.0, (self.rapidFireButton.frame.size.height / 2.0f) + VERTICAL_SPACING_8);
    [self.rapidFireButton performBlock:^{
        [self powerUpTapped:SIPowerUpRapidFire];
    } onEvent:AGButtonControlEventTouchUpInside];
    
    /*Falling Monkeys Button*/
    [self.fallingMonkeysButton setLabelWithText:@"Rapid Fire" andFont:self.powerupButtonFont withColor:[SKColor blackColor]];
    self.fallingMonkeysButton.position = CGPointMake((size.width/2.0) + (size.width/ 4.0), (self.fallingMonkeysButton.frame.size.height / 2.0f) + VERTICAL_SPACING_8);
    [self.fallingMonkeysButton performBlock:^{
        [self powerUpTapped:SIPowerUpFallingMonkeys];
    } onEvent:AGButtonControlEventTouchUpInside];
    
}
- (void)layoutControlsWithSize:(CGSize)size {
    /*Total Score Label*/
    self.totalScoreLabel.position   = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMaxY(self.frame) - self.totalScoreLabel.frame.size.height - VERTICAL_SPACING_16);
    [self addChild:self.totalScoreLabel];

    /*Move Command Label*/
    self.moveCommandLabel.position  = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:self.moveCommandLabel];
    
    /*Progress View Sprite*/
    self.progressBar.position       = CGPointMake((size.width / 2.0f) - (self.progressBarSize.width / 4.0f), (size.height / 2.0f) - self.moveCommandLabel.frame.size.height);
    [self addChild:self.progressBar];
    [self.progressBar setProgress:1.0];
    
    /*Time Freeze Button*/
    self.timeFreezeButton.position = CGPointMake(size.width/4.0f, (self.timeFreezeButton.frame.size.height / 2.0f) + VERTICAL_SPACING_8);
    [self addChild:self.timeFreezeButton];
    

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
    self.tap                                            = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRegistered:)];
    self.tap.numberOfTapsRequired                       = 1;
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
    self.moveCommandLabel.fontColor         = [SKColor whiteColor];
    if (self.gameMode == SIGameModeOneHand) {
        /*Setup Shake recognizer*/
        self.restCount                      = 0;
        self.isShakeActive                  = NO;
        [self startAccelerometerForShake];
    }
}
- (void)gameEnded {
    EndGameScene *firstScene = [EndGameScene sceneWithSize:self.size];
    [self.view presentScene:firstScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.5]];

}
- (void)replayGame {
    [[AppSingleton singleton] initAppSingletonWithGameMode:self.gameMode];
    [[AppSingleton singleton] startGame];
    [self correctMoveEntered:nil];
}
- (void)scoreUpdate {
    [self.progressBar setProgress:[AppSingleton singleton].currentGame.moveScorePercentRemaining];
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
//    self.totalScoreLabel.text           = [NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.totalScore];
    
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
    
    CGFloat randomDx = arc4random_uniform(20);
    CGFloat randomDy = arc4random_uniform(50);
    CGVector moveScoreVector = CGVectorMake(randomDx, randomDy);
    
    [moveLabel.physicsBody applyImpulse:moveScoreVector];

}
#pragma mark - Scene Methods
-(void)update:(NSTimeInterval)currentTime {
    self.totalScoreLabel.text           = [NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.totalScore];
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
- (void)startPowerUpAllWithDuration:(SIPowerUpDuration)duration withButton:(AGSpriteButton *)button withPowerUpText:(NSString *)powerUpText {
//    self.powerUpProgressView.alpha  = 1.0f;
    button.alpha                    = 0.2f;
//    self.powerUpLabel.text          = powerUpText;
    [[AppSingleton singleton] powerUpDidActivate];
    [self performSelector:@selector(powerUpDeactivated) withObject:nil afterDelay:duration];
    [UIView animateWithDuration:duration animations:^{
        button.alpha  = 1.0f;
    }];
}
- (void)endPowerUpAll {
//    self.powerUpProgressView.alpha  = 0.0f;
//    self.powerUpLabel.text          = [Game stringForPowerUp:SIPowerUpNone];
    [[AppSingleton singleton] powerUpDidEnd];
}

#pragma mark - Falling Monkeys
/*This is the fith step.*/
- (void)startPowerUpFallingMonkeys {
    /*Do any UI Set U[ for Falling Monkeys*/
    self.monkeyDestroyedCount           = 0;
    [self unRegisterForGestureRecognizer];
    
    /*Generic Start Power Up*/
    NSInteger totalNumberOfMonkeysToLaunch = [[NSUserDefaults standardUserDefaults] integerForKey:kSINSUserDefaultNumberOfMonkeys];
    if (totalNumberOfMonkeysToLaunch == 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:NUMBER_OF_MONKEYS_INIT forKey:kSINSUserDefaultNumberOfMonkeys];
    }
    [self launched:0 monkeysOutOf:totalNumberOfMonkeysToLaunch];
    
    //    [self startPowerUpAllWithDuration:SIPowerUpDurationFallingMonkeys withButton:self.fallingMonkeysButton withPowerUpText:[Game stringForPowerUp:SIPowerUpFallingMonkeys]];
}
/*This is the 7th step, called by game controller to end powerup*/
- (void)endPowerUpFallingMonkeys {
    /*Do any UI break down for Falling Monkeys*/
    self.moveCommandLabel.hidden        = NO;
    [self setupGestureRecognizersWithView:self.view];
//    self.currentLevelLabel.hidden       = NO;
//    self.currentMoveProgressView.hidden = NO;
//    self.powerUpLabel.hidden            = NO;
    self.monkeyDestroyedCount           = 0;
    
    
    /*Generica End Power Up*/
    [self endPowerUpAll];
}

#pragma mark - Time Freeze
- (void)startPowerUpTimeFreeze {
    /*Do any UI Set U[ for Time Freeze*/
    
    /*Generic Start Power Up*/
    [self startPowerUpAllWithDuration:SIPowerUpDurationTimeFreeze withButton:self.timeFreezeButton withPowerUpText:[Game stringForPowerUp:SIPowerUpTimeFreeze]];
}
- (void)endPowerUpTimeFreeze {
    /*Do any UI break down for Time Freeze*/
    
    /*Generica End Power Up*/
    [self endPowerUpAll];
}

#pragma mark - Rapid Fire
- (void)startPowerUpRapidFire {
    /*Do any UI Setup for Rapid Fire*/
    
    /*Generic Start Power Up*/
    [self startPowerUpAllWithDuration:SIPowerUpDurationRapidFire withButton:self.rapidFireButton withPowerUpText:[Game stringForPowerUp:SIPowerUpRapidFire]];
}
- (void)endPowerUpRapidFire {
    /*Do any UI break down for Rapid Fire*/
    
    /*Generica End Power Up*/
    [self endPowerUpAll];
}

#pragma mark - Monkey Methods!
- (void)launched:(NSInteger)monkeysLaunched monkeysOutOf:(NSInteger)totalMonkeysToLaunch {
    /*Base Case*/
    if (monkeysLaunched == totalMonkeysToLaunch) {
        //        [self powerUpDeactivated];
        //        [self correctMoveEntered:nil];
        return;
    } else {
        /*Get Random Number Max... based of width of screen and monkey*/
        CGFloat validMax                    = SCREEN_WIDTH - (self.fallingMonkeySize.width / 2.0f);
        CGFloat xLocation                   = arc4random_uniform(validMax); /*This will be the y axis launch point*/
        CGFloat yLocation                   = -self.fallingMonkeySize.height;
        
        /*Make Monkey*/
        AGSpriteButton *monkey              = [AGSpriteButton buttonWithImageNamed:kSIImageFallingMonkeys];
//        SKSpriteNode *monkey                = [SKSpriteNode spriteNodeWithImageNamed:kSIImageFallingMonkeys];
        monkey.position                     = CGPointMake(xLocation, yLocation);
        monkey.size                         = self.fallingMonkeySize;
        
        monkey.physicsBody                  = [SKPhysicsBody bodyWithCircleOfRadius:monkey.frame.size.width/2];
        monkey.physicsBody.linearDamping    = 0.0f;
        
        [monkey performBlock:^{
            [monkey removeFromParent];
            
            self.monkeyDestroyedCount                       = self.monkeyDestroyedCount + 1;
            
            [AppSingleton singleton].currentGame.totalScore = [AppSingleton singleton].currentGame.totalScore + VALUE_OF_MONKEY;
            
            self.totalScoreLabel.text                       = [NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.totalScore];
            
            self.view.backgroundColor                       = [[AppSingleton singleton] newBackgroundColor];
        } onEvent:AGButtonControlEventAllEvents];
        
        [self addChild:monkey];
        
        //create the vector
        CGVector monkeyVector               = CGVectorMake(0, -10);
        [monkey.physicsBody applyImpulse:monkeyVector];
        
        /*Call Function again*/
        CGFloat randomDelay                 = arc4random_uniform(75);
        NSLog(@"Delay: %0.2f",randomDelay / 100);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(randomDelay /100 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self launched:monkeysLaunched + 1 monkeysOutOf:totalMonkeysToLaunch];
        });
    }
}

@end
