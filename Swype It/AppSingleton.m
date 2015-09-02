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
#import "SoundManager.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports

// Other Imports
@interface AppSingleton () {
    
}
#pragma mark - BOOLS
@property (assign, nonatomic) BOOL               isPaused;
@property (assign, nonatomic) BOOL               willIgnoreShake;

#pragma mark - Private CGFloats & Numbers
@property (assign, nonatomic) CGFloat            timerInterval;
@property (assign, nonatomic) float              compositeTimeInMiliSeconds;
@property (assign, nonatomic) float              timeFreezeMultiplyer;
@property (assign, nonatomic) float              levelSpeedDivider;
@property (assign, nonatomic) float              moveStartTimeInMiliSeconds;
@property (assign, nonatomic) float              pauseStartTimeInMiliSeconds;
@property (assign, nonatomic) float              powerUpTimeInMiliSeconds;


#pragma mark - Private Properties
@property (assign, nonatomic) NSTimeInterval     startTime;

#pragma mark - Private
@property (strong, nonatomic) NSTimer           *timer;
@property (strong, nonatomic) NSString          *previousLevel;


@end

@implementation AppSingleton {
    CGFloat epsilonLimit;
}

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
    epsilonLimit                                    = 0.01f;
    
    self.willResume                                 = NO;
    self.previousLevel                              = [Game currentLevelStringForScore:0.0f];
    self.timerInterval                              = TIMER_INTERVAL;
    self.currentGame.isStarted                      = NO;
    self.currentGame.isHighScore                    = NO;
    self.currentGame.currentNumberOfTimesContinued  = SIContinueLifeCost1;
    self.currentGame.currentBackgroundSound         = SIBackgroundSoundMenu;
    self.currentGame.currentLevel                   = [Game currentLevelStringForScore:0.0f];
    self.currentGame.currentPowerUp                 = SIPowerUpNone;
    self.currentGame.totalScore                     = 0.0f;
    self.currentGame.gameMode                       = gameMode;
    self.currentGame.currentMove                    = [Game getRandomMoveForGameMode:gameMode isRapidFireActiviated:NO];
    self.currentGame.currentBackgroundColorNumber   = arc4random_uniform(NUMBER_OF_MOVES);
    
    [self initalizeObjects];
}
- (void)initalizeObjects {
    if (self.manager == nil) {
        self.manager                = [[CMMotionManager alloc] init];
    } else {
        NSLog(@"Manager already going");
    }
    if (self.timer == nil) {
        self.timer                  = [[NSTimer alloc] init];
    } else {
        NSLog(@"Time already going");
    }
}
#pragma mark - Game Functions
- (void)startGame {
    self.currentGame.freeCoinsEarned                = 0;
    self.levelSpeedDivider                          = 1.0f;
    self.timeFreezeMultiplyer                       = 1.0f;
    self.currentGame.totalScore                     = 0.0f;
    self.currentGame.isPaused                       = NO;
    self.moveStartTimeInMiliSeconds                 = 0;
    self.compositeTimeInMiliSeconds                 = 0;
    self.currentGame.moveScorePercentRemaining      = 1.0f;
    self.currentGame.currentNumberOfTimesContinued  = SIContinueLifeCost1;
    
    if (self.currentGame.gameMode == SIGameModeOneHand) {
        [self.manager startAccelerometerUpdates];
    }
    
    /*Start The Timer*/
    [self startTimer];
    
    /*Start Sound*/
    if ([SIConstants isBackgroundSoundAllowed]) {
        SIBackgroundSound soundForScore = [Game backgroundSoundForScore:self.currentGame.totalScore];
        if (soundForScore != self.currentGame.currentBackgroundSound) {
            self.currentGame.currentBackgroundSound = soundForScore;
            [[SoundManager sharedManager] playMusic:[Game soundNameForSIBackgroundSound:soundForScore] looping:YES fadeIn:YES];
        }
    }
    
    /*Send Notification that Game has STARTED*/
    NSNotification *notification        = [[NSNotification alloc] initWithName:kSINotificationGameStarted object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
- (void)pause {
    self.currentGame.isPaused           = YES;
    self.pauseStartTimeInMiliSeconds    = self.compositeTimeInMiliSeconds;
//    [[SoundManager sharedManager] st]
}
- (void)play {
    if (self.currentGame.isPaused) {
        self.currentGame.isPaused           = NO;
        NSLog(@"Play... Comp Time: %0.2f || PauseStart: %0.2f || MoveStart: %0.2f",self.compositeTimeInMiliSeconds,self.pauseStartTimeInMiliSeconds,self.moveStartTimeInMiliSeconds);
        self.moveStartTimeInMiliSeconds     = (self.compositeTimeInMiliSeconds - self.pauseStartTimeInMiliSeconds) + self.moveStartTimeInMiliSeconds;
    }
}
- (void)endGame {
    self.currentGame.isStarted  = NO;
    [self.manager stopAccelerometerUpdates];
    [self.timer invalidate];
//    
//    /*Send Notification that Game has ENDED*/
//    NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationGameEnded object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(powerUpDidEnd) object:nil];
}
- (void)stopGame {
    [self pause];
    /*Send Notification that Game has ENDED*/
    NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationGameEnded object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(powerUpDidEnd) object:nil];
    
    /*Stop all sound, vibrate phone, play game over sound*/
    if ([SIConstants isBackgroundSoundAllowed]) {
        [[SoundManager sharedManager] stopMusic];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[SoundManager sharedManager] playMusic:kSISoundBackgroundMenu looping:YES fadeIn:YES];
        });
        self.currentGame.currentBackgroundSound = SIBackgroundSoundMenu;
    }
    if ([SIConstants isFXAllowed]) {
        [[SoundManager sharedManager] stopAllSounds];
        [[SoundManager sharedManager] playSound:kSISoundFXGameOver];
    }
    


}
- (void)moveEnterForType:(SIMove)move {
    if (move == self.currentGame.currentMove) {
        [self willPrepareToShowNewMove];
    } else {
        [self stopGame];
    }
}
- (void)willPrepareToShowNewMove {
    NSDictionary *userInfo                      = [NSDictionary dictionaryWithObject:@(self.currentGame.moveScore) forKey:kSINSDictionaryKeyMoveScore];
    
    [self captureTime];     /*Capture the time for the next move*/
    
    if (self.isPaused == NO) {
//        NSLog(@"Move score: %0.2f and Total score: %0.2f",self.currentGame.moveScore,self.currentGame.totalScore);
        if (self.currentGame.totalScore < epsilonLimit) {
            CGFloat randomNumber = arc4random_uniform(10) / 10;
            self.currentGame.moveScore = MAX_MOVE_SCORE - randomNumber;
            userInfo = [NSDictionary dictionaryWithObject:@(self.currentGame.moveScore) forKey:kSINSDictionaryKeyMoveScore];
            self.currentGame.totalScore = self.currentGame.moveScore;
        } else {
            self.currentGame.totalScore                 = self.currentGame.totalScore + self.currentGame.moveScore; /*Add moveScore to total score*/
        }
        
        [self setAndCheckDefaults:self.currentGame.moveScore];
        
        
        [self didLevelStringChange:self.previousLevel newLevelString:[Game currentLevelStringForScore:self.currentGame.totalScore]];
        
        BOOL isRapidFireActive                      = (self.currentGame.currentPowerUp == SIPowerUpRapidFire) ? YES : NO;
        
        self.currentGame.currentMove                = [Game getRandomMoveForGameMode:self.currentGame.gameMode isRapidFireActiviated:isRapidFireActive]; /*Return Tap for if Rapid Fire*/
        
        /*See if you should load new sound*/
        if ([SIConstants isBackgroundSoundAllowed]) {
            SIBackgroundSound soundForScore = [Game backgroundSoundForScore:self.currentGame.totalScore];
            if (soundForScore != self.currentGame.currentBackgroundSound) {
                self.currentGame.currentBackgroundSound = soundForScore;
                [[SoundManager sharedManager] playMusic:[Game soundNameForSIBackgroundSound:soundForScore] looping:YES fadeIn:YES];
            }
        }
    }
    
    
    NSNotification *notification                = [[NSNotification alloc] initWithName:kSINotificationCorrectMove object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}
- (void)setAndCheckDefaults:(float)score {
    NSNumber *lifeTimeHighScore                 = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultLifetimeHighScore];
    if (lifeTimeHighScore == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:0.0f] forKey:kSINSUserDefaultLifetimeHighScore];
    } else {
        if (self.currentGame.totalScore > [lifeTimeHighScore floatValue]) {
            self.currentGame.isHighScore        = YES;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:self.currentGame.totalScore] forKey:kSINSUserDefaultLifetimeHighScore];
            NSNotification *notification        = [[NSNotification alloc] initWithName:kSINotificationNewHighScore object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    }

    
    NSNumber *lifeTimePointsEarned              = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultLifetimePointsEarned];
    if (lifeTimePointsEarned == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:0.0f] forKey:kSINSUserDefaultLifetimePointsEarned];
    } else {
        lifeTimePointsEarned                    = [NSNumber numberWithFloat: [lifeTimePointsEarned floatValue] + score];
        [[NSUserDefaults standardUserDefaults] setObject:lifeTimePointsEarned forKey:kSINSUserDefaultLifetimePointsEarned];
    }
    
    
    NSNumber *pointsTillFreeCoinNumber          = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultPointsTowardsFreeCoin];
    if (pointsTillFreeCoinNumber == nil) {
        pointsTillFreeCoinNumber = [NSNumber numberWithFloat:0.0f];
        [[NSUserDefaults standardUserDefaults] setObject:pointsTillFreeCoinNumber forKey:kSINSUserDefaultPointsTowardsFreeCoin];
    }
    float pointsTillFreeCoin                    = [pointsTillFreeCoinNumber floatValue];
//    NSLog(@"Points till free coin before: %0.2f",pointsTillFreeCoin);
    pointsTillFreeCoin                          = pointsTillFreeCoin + score;
    self.currentGame.freeCoinInPoints           = pointsTillFreeCoin;
    if (pointsTillFreeCoin > POINTS_NEEDED_FOR_FREE_COIN + MAX_MOVE_SCORE) {
        /*This is a critical error*/
//        [NSException raise:@"PointOverFlow" format:@"pointsTillFreeCoin is too high"];
        pointsTillFreeCoin = POINTS_NEEDED_FOR_FREE_COIN / 2;
        NSLog(@"Critical Error: Points needed wayyy to high... Resting to half of points needed.");
    } else if (pointsTillFreeCoin > POINTS_NEEDED_FOR_FREE_COIN) {
        if ([SIConstants isFXAllowed]) {
            [[SoundManager sharedManager] playSound:kSISoundFXChaChing];
        }
        pointsTillFreeCoin                      = pointsTillFreeCoin - POINTS_NEEDED_FOR_FREE_COIN;
        self.currentGame.freeCoinsEarned        = self.currentGame.freeCoinsEarned + 1;
        [[MKStoreKit sharedKit] addFreeCredits:[NSNumber numberWithInt:1] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
        NSNotification *notification            = [[NSNotification alloc] initWithName:kSINotificationFreeCoinEarned object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    self.currentGame.freeCoinPercentRemaining   = (pointsTillFreeCoin / (float)POINTS_NEEDED_FOR_FREE_COIN);
//    NSLog(@"Points till free coin after: %0.2f",pointsTillFreeCoin);
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:pointsTillFreeCoin] forKey:kSINSUserDefaultPointsTowardsFreeCoin];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
//    NSLog(@"Capture time...");
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
    
    if (self.currentGame.isPaused == NO) {
        /*Calculate new time*/
//        NSLog(@"Comp Time: %0.2f || Move Start Time: %0.2f || Difference: %0.2f",self.compositeTimeInMiliSeconds,self.moveStartTimeInMiliSeconds,(self.compositeTimeInMiliSeconds - self.moveStartTimeInMiliSeconds));
        float durationOfLastMove                    = (self.compositeTimeInMiliSeconds - self.moveStartTimeInMiliSeconds) * self.timeFreezeMultiplyer;
        
        /*Calculate Level Speed Divider*/
        self.levelSpeedDivider                      = [Game levelSpeedForScore:self.currentGame.totalScore];
        
        /*Get the new score for this time -- Always keep the time current*/
        self.currentGame.moveScore                  = [Game scoreForMoveDuration:durationOfLastMove withLevelSpeedDivider:self.levelSpeedDivider];
        
//        NSLog(@"MoveScore: %0.2f",self.currentGame.moveScore);
        
        /*Get the new percentage for score*/
        self.currentGame.moveScorePercentRemaining  = self.currentGame.moveScore / MAX_MOVE_SCORE;
        
        
        NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationScoreUpdate object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];

    }
//    NSLog(@"MovePercentRemaining: %0.2f",self.currentGame.moveScorePercentRemaining);
    
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
//        NSLog(@"Old Coin Value: %@ || New Coin Value: %@",oldCoinAmount,newCoinAmount);
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

- (BOOL)canAffordContinue {
    int continueCost = [Game lifeCostForCurrentContinueLevel:self.currentGame.currentNumberOfTimesContinued];
    int numberOfItCoins = [[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue];
    if (continueCost <= numberOfItCoins) {
        return YES;
    }
    return NO;
}
@end