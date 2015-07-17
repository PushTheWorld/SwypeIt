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
#import "MKStoreKit.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "Game.h"
// Other Imports
@interface AppSingleton () {
    
}
#pragma mark - BOOLS
@property (assign, nonatomic) BOOL               willIgnoreShake;

#pragma mark - Private CGFloats & Numbers
@property (assign, nonatomic) CGFloat            timerInterval;
@property (assign, nonatomic) float              compositeTimeInMiliSeconds;
@property (assign, nonatomic) float              timeFreezeMultiplyer;
@property (assign, nonatomic) float              levelSpeedDivider;
@property (assign, nonatomic) float              moveStartTimeInMiliSeconds;
@property (assign, nonatomic) float              powerUpTimeInMiliSeconds;


#pragma mark - Private Properties
@property (assign, nonatomic) NSTimeInterval     startTime;

#pragma mark - Private
@property (strong, nonatomic) NSTimer           *timer;
@property (strong, nonatomic) NSString          *previousLevel;


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
- (void)initAppSingletonWithGameMode:(SIGameMode)gameMode {
    if (self.currentGame == nil) {
        self.currentGame                            = [[Game alloc] init];
    }
    self.previousLevel                              = [Game currentLevelStringForScore:0.0f];
    self.currentGame.currentLevel                   = [Game currentLevelStringForScore:0.0f];
    self.currentGame.currentPowerUp                 = SIPowerUpNone;
    self.currentGame.totalScore                     = 0.0f;
    self.currentGame.gameMode                       = gameMode;
    self.currentGame.currentMove                    = [Game getRandomMoveForGameMode:gameMode isRapidFireActiviated:NO];
    self.currentGame.nextMove                       = [Game getRandomMoveForGameMode:gameMode isRapidFireActiviated:NO];
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
    self.timerInterval              = TIMER_INTERVAL;
}
#pragma mark - Game Functions
- (void)startGame {
    self.levelSpeedDivider          = 1.0f;
    self.timeFreezeMultiplyer       = 1.0f;
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
- (void)moveEnterForType:(SIMove)move {
    if (move == self.currentGame.currentMove) {
        [self willPrepareToShowNewMove];
    } else {
        [self endGame];
    }
}
- (void)willPrepareToShowNewMove {
    NSDictionary *userInfo          = [NSDictionary dictionaryWithObject:@(self.currentGame.moveScore) forKey:kSINSDictionaryKeyMoveScore];
    
    [self captureTime];     /*Capture the time for the next move*/
    
    self.currentGame.totalScore     = self.currentGame.totalScore + self.currentGame.moveScore; /*Add moveScore to total score*/
    
    [self didLevelStringChange:self.previousLevel newLevelString:[Game currentLevelStringForScore:self.currentGame.totalScore]];
    
    BOOL isRapidFireActive          = (self.currentGame.currentPowerUp == SIPowerUpRapidFire) ? YES : NO;
    
    self.currentGame.currentMove    = isRapidFireActive ? SIMoveTap : self.currentGame.nextMove; /*Return Tap for if Rapid Fire*/
    
    /*Get new move*/
    self.currentGame.nextMove       = [Game getRandomMoveForGameMode:self.currentGame.gameMode isRapidFireActiviated:isRapidFireActive];
    
    
    NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationCorrectMove object:nil userInfo:userInfo];
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
- (void)didLevelStringChange:(NSString *)oldLevelString newLevelString:(NSString *)newLevelString {
    if ([oldLevelString isEqualToString:newLevelString] == NO) {
        self.currentGame.currentLevel   = newLevelString;
        NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationLevelDidChange object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}
#pragma mark - Timer Methods
- (void)captureTime {
    self.moveStartTimeInMiliSeconds = self.compositeTimeInMiliSeconds;
}
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
    float durationOfLastMove                    = (self.compositeTimeInMiliSeconds - self.moveStartTimeInMiliSeconds) * self.timeFreezeMultiplyer;
    
    /*Calculate Level Speed Divider*/
    self.levelSpeedDivider                      = [Game levelSpeedForScore:self.currentGame.totalScore];

    /*Get the new score for this time -- Always keep the time current*/
    self.currentGame.moveScore                  = [Game scoreForMoveDuration:durationOfLastMove withLevelSpeedDivider:self.levelSpeedDivider];
    
    /*Get the new percentage for score*/
    self.currentGame.moveScorePercentRemaining  = self.currentGame.moveScore / MAX_MOVE_SCORE;
    
    /*Set the new percentage for Power UP*/
    if (self.currentGame.currentPowerUp != SIPowerUpNone) {
        float powerUpTotalDuration = [Game durationForPowerUp:self.currentGame.currentPowerUp];
        float powerUpPercent = ((powerUpTotalDuration * MILI_SECS_IN_SEC) - (self.compositeTimeInMiliSeconds - self.powerUpTimeInMiliSeconds)) / (powerUpTotalDuration * MILI_SECS_IN_SEC);
        if (powerUpPercent < 0.0) {
            self.currentGame.powerUpPercentRemaining    = 0.0f;
        } else {
            self.currentGame.powerUpPercentRemaining    = powerUpPercent;
        }
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
- (void)powerUpDidLoad:(SIPowerUp)powerUp {
    if (self.currentGame.currentPowerUp == SIPowerUpNone) { /*Don't allow more then one power up at one time*/
        [self powerUpWillActivate:powerUp withPowerUpCost:[Game costForPowerUp:powerUp]];
    }
}
/*This is the third step in powerup acitivation. This checks to see if the User has enough coins*/
- (void)powerUpWillActivate:(SIPowerUp)powerUp withPowerUpCost:(SIPowerUpCost)powerUpCost {
    
    NSNumber *numberOfItCoins = [[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins];
    if ([numberOfItCoins integerValue] >= powerUpCost) {
        self.currentGame.currentPowerUp = powerUp;
        
        /*Post Notification... GameViewController is listening*/
        NSDictionary *userInfo          = [NSDictionary dictionaryWithObject:@(powerUp) forKey:kSINSDictionaryKeyPowerUp];
        NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationPowerUpActive object:nil userInfo:userInfo];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        NSNumber *oldCoinAmount = [[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins];
        /*Spend the Consumable*/
        [[MKStoreKit sharedKit] consumeCredits:[NSNumber numberWithInt:powerUpCost] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
        
        /*DEBUG Print the new value*/
        NSNumber *newCoinAmount = [[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins];
        NSLog(@"Old Coin Value: %@ || New Coin Value: %@",oldCoinAmount,newCoinAmount);
    }
}
/*This is the 6th step. The UI View controller did react to the powerup*/
/*This is for the new one...*/
- (void)powerUpDidActivate {
    self.powerUpTimeInMiliSeconds = self.compositeTimeInMiliSeconds;
    switch (self.currentGame.currentPowerUp) {
        case SIPowerUpRapidFire:
            [self willPrepareToShowNewMove];
            break;
        case SIPowerUpTimeFreeze:
            self.timeFreezeMultiplyer   = 0.2f;
            break;
        case SIPowerUpFallingMonkeys:
            /*Do Falling Monkeys in Setup*/
        default:
            
            break;
    }
}
/*This is the 8th step*/
/*Called After Powerup has ended on Singleton*/
- (void)powerUpDidEnd {
    switch (self.currentGame.currentPowerUp) {
        case SIPowerUpTimeFreeze:
            self.timeFreezeMultiplyer   = 1.0f;
            break;
        case SIPowerUpFallingMonkeys:
            /*Do Falling Monkeys Breakdown*/
            break;
        default:
            break;
    }
}
@end