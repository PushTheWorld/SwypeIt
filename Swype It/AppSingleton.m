//  AppSingleton.m
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is a singlton for managing creation and editing of Simplsts
//
// Local Controller Import
#import "AppSingleton.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "FXReachability.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "Game.h"
#import "SIConstants.h"
// Other Imports
@interface AppSingleton () {
    
}
#pragma mark - BOOLS
@property (assign, nonatomic) BOOL               willIgnoreShake;

#pragma mark - Private CGFloats & Numbers
@property (assign, nonatomic) CGFloat            timerInterval;
@property (assign, nonatomic) float              compositeTimeInMiliSeconds;
@property (assign, nonatomic) float              foresightMultiplyer;
@property (assign, nonatomic) float              levelSpeedDivider;
@property (assign, nonatomic) float              moveStartTimeInMiliSeconds;
@property (assign, nonatomic) float              powerUpTimeInMiliSeconds;


#pragma mark - Private Properties
@property (assign, nonatomic) NSTimeInterval     startTime;

#pragma mark - Private
@property (strong, nonatomic) NSTimer           *timer;


@end

@implementation AppSingleton

#pragma mark - Singleton Method
+ (instancetype)singleton {
    static AppSingleton *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[AppSingleton alloc] init];
    });
    return singleton;
}
- (void)initAppSingletonWithGameMode:(GameMode)gameMode {
    if (self.currentGame == nil) {
        self.currentGame                            = [[Game alloc] init];
    }
    self.currentGame.currentPowerUp                 = PowerUpNone;
    self.currentGame.totalScore                     = 0.0f;
    self.currentGame.gameMode                       = gameMode;
    self.currentGame.currentMove                    = [Game getRandomMoveForGameMode:gameMode];
    self.currentGame.nextMove                       = [Game getRandomMoveForGameMode:gameMode];
    self.currentGame.currentBackgroundColorNumber   = arc4random_uniform(NUMBER_OF_MOVES);
    [self initalizeObjects];
}
- (void)runFirstGame {
    [self startGame];
    self.moveStartTimeInMiliSeconds = 0.0f;
}
- (void)initalizeObjects {
    self.manager                    = [[CMMotionManager alloc] init];
    self.timer                      = [[NSTimer alloc] init];
    
    self.levelSpeedDivider          = 1.0f;
    self.timerInterval              = TIMER_INTERVAL;
}
#pragma mark - Game Functions
- (void)startGame {
    self.foresightMultiplyer        = 1.0f;
    self.currentGame.totalScore     = 0.0;
    self.moveStartTimeInMiliSeconds = 0;

    /*Send Notification that Game has STARTED*/
    NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationGameStarted object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    /*Start The Timer*/
    [self startTimer];
}
- (void)endGame {
    [self.manager stopAccelerometerUpdates];
    [self.timer invalidate];
    
    /*Send Notification that Game has ENDED*/
    NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationGameEnded object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(powerUpDidEnd) object:nil];
}
- (void)moveEnterForType:(Move)move {
    if (move == self.currentGame.currentMove) {
        [self willPrepareToShowNewMove];
    } else {
        [self endGame];
    }
}
- (void)willPrepareToShowNewMove {
    [self captureTime];     /*Capture the time for the next move*/
    
    self.currentGame.totalScore     = self.currentGame.totalScore + self.currentGame.moveScore; /*Add moveScore to total score*/
    
    self.currentGame.currentMove    = self.currentGame.nextMove;
    /*Get new move*/
    Move newMove;
    if (self.currentGame.currentPowerUp == PowerUpRapidFire) {
        newMove                     = MoveTap;
    } else {
        newMove                     = [Game getRandomMoveForGameMode:[AppSingleton singleton].currentGame.gameMode];
    }
    self.currentGame.nextMove       = newMove;
    
    NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationCorrectMove object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}
- (UIColor *)newBackgroundColor {
    NSInteger randomNumber;
    if (self.currentGame.totalScore >= LEVEL12) {
        randomNumber = arc4random_uniform(NUMBER_OF_MOVES * 3);
        while (randomNumber == self.currentGame.currentBackgroundColorNumber) {
            randomNumber = arc4random_uniform(NUMBER_OF_MOVES * 3);
        }

    } else {
        randomNumber = arc4random_uniform(NUMBER_OF_MOVES);
        while (randomNumber == self.currentGame.currentBackgroundColorNumber) {
            randomNumber = arc4random_uniform(NUMBER_OF_MOVES);
        }

    }
    self.currentGame.currentBackgroundColorNumber = randomNumber;
    return [Game backgroundColorForScore:self.currentGame.totalScore forRandomNumber:randomNumber];
}
- (void)captureTime {
    self.moveStartTimeInMiliSeconds = self.compositeTimeInMiliSeconds;
}
#pragma mark - Timer Methods
- (void)startTimer {
    if (!self.timer.valid) {
        /*Start Timer*/
        self.timer      = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval target:self selector:@selector(updateTimeAndScore) userInfo:nil repeats:YES];
        self.startTime  = [NSDate timeIntervalSinceReferenceDate];
    }
}
/*updateTimeAndScore gets updated every 1/30 seconds*/
- (void)updateTimeAndScore {
    /*Update the master timer*/
    [self updateCompositeTime];
    
    /*Calculate new time*/
    float durationOfLastMove    = (self.compositeTimeInMiliSeconds - self.moveStartTimeInMiliSeconds) * self.foresightMultiplyer;

    /*Get the new score for this time -- Always keep the time current*/
    self.currentGame.moveScore  = [Game scoreForMoveDuration:durationOfLastMove withLevelSpeedDivider:self.levelSpeedDivider];
    
    /*Get the new percentage for score*/
    self.currentGame.moveScorePercentRemaining  = self.currentGame.moveScore / MAX_MOVE_SCORE;
    
    /*Set the new percentage for Power UP*/
    if (self.currentGame.currentPowerUp != PowerUpNone) {
        float powerUpTotalDuration = [Game durationForPowerUp:self.currentGame.currentPowerUp];
        float powerUpPercent = ((powerUpTotalDuration * MILI_SECS_IN_SEC) - (self.compositeTimeInMiliSeconds - self.powerUpTimeInMiliSeconds)) / (powerUpTotalDuration * MILI_SECS_IN_SEC);
        self.currentGame.powerUpPercentRemaining    = powerUpPercent;
    }
    
    NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationScoreUpdate object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
/*updateCompositeTime gets updated every time updateTimeAndScore does*/
- (void)updateCompositeTime {
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    
    NSTimeInterval elapsedTime = currentTime - self.startTime;
    
    self.compositeTimeInMiliSeconds = elapsedTime * MILI_SECS_IN_SEC;
}
#pragma mark - Power Up Methods
/*This is the second step. This checks to see if we are currently using a powerup*/
- (void)powerUpDidLoad:(PowerUp)powerUp {
    if (self.currentGame.currentPowerUp == PowerUpNone) { /*Don't allow more then one power up at one time*/
        [self powerUpWillActivate:powerUp withPowerUpCost:[Game powerUpCostForPowerUp:powerUp]];
    }
}
/*This is the third step in powerup acitivation. This checks to see if the User has enough coins*/
- (void)powerUpWillActivate:(PowerUp)powerUp withPowerUpCost:(PowerUpCost)powerUpCost {
    
    NSInteger numberOfItCoins = [[NSUserDefaults standardUserDefaults] integerForKey:kSINSUserDefaultNumberOfItCoins];
    if (numberOfItCoins >= powerUpCost) {
        self.currentGame.currentPowerUp = powerUp;
        
        /*Post Notification... GameViewController is listening*/
        NSDictionary *userInfo          = [NSDictionary dictionaryWithObject:@(powerUp) forKey:kSINSDictionaryKeyPowerUp];
        NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationPowerUpActive object:nil userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [[NSUserDefaults standardUserDefaults] setInteger:(numberOfItCoins - powerUpCost) forKey:kSINSUserDefaultNumberOfItCoins];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
/*This is the 6th step. The UI View controller did react to the powerup*/
/*This is for the new one...*/
- (void)powerUpDidActivate {
    self.powerUpTimeInMiliSeconds = self.compositeTimeInMiliSeconds;
    switch (self.currentGame.currentPowerUp) {
        case PowerUpRapidFire:
            [self willPrepareToShowNewMove];
            break;
        case PowerUpSlowMotion:
            self.foresightMultiplyer = 0.2;
            break;
        default: /*Foresight*/
            
            break;
    }
}
/*This is the 8th step*/
/*Called After Powerup has ended on Singleton*/
- (void)powerUpDidEnd {
    switch (self.currentGame.currentPowerUp) {
        case PowerUpSlowMotion:
            self.foresightMultiplyer = 1.0;
            break;
        default:
            break;
    }
}
@end