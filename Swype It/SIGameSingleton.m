//  AppSingleton.m
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is a singlton... the `MODEL` in MVC paradigm
//
// Local Controller Import
#import "SIGameSingleton.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "FXReachability.h"
#import "MKStoreKit.h"
#import "SoundManager.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports

@implementation SIGameSingleton {
    BOOL                         _isPaused;
    
    BOOL                         _willIgnoreShake;
    
    CGFloat                      _timerInterval;
    
    float                        _compositeTimeInMiliSeconds;
    float                        _timeFreezeMultiplyer;
    float                        _levelSpeedDivider;
    float                        _moveStartTimeInMiliSeconds;
    float                        _pauseStartTimeInMiliSeconds;
//    float                        _powerUpTimeInMiliSeconds;
    
    NSString                    *_previousLevel;
    
    NSTimeInterval               _startTime;
    
    NSTimer                     *_timer;
}

#pragma mark - Singleton Method
+ (instancetype)singleton {
    static SIGameSingleton *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[SIGameSingleton alloc] init];
    });
    return singleton;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self singletonSetup];
        
        _currentGame                    = [[Game alloc] init];
        
    }
    return self;
}

/**
 Initialize the controls for singlton
 */
- (void)singletonSetup {
    _timer                                          = [[NSTimer alloc] init];
    _timerInterval                                  = TIMER_INTERVAL;

}

#pragma mark - Singleton Game Control Functions
/**
 Called at the start of every new game
 Restarts the game... calling this will
 make you loose all current game data
 */
- (void)singletonWillStart {
    _willResume                                     = NO;
    _previousLevel                                  = [Game currentLevelStringForScore:0.0f];
    _compositeTimeInMiliSeconds                     = 0.0f;
    _levelSpeedDivider                              = 1.0f;
    _moveStartTimeInMiliSeconds                     = 0.0f;
    _timeFreezeMultiplyer                           = 1.0f;
    [Game setStartGameProperties:_currentGame];
}

/**
 Called when the user enters the first move
 */
- (void)singletonDidStart {
    /*Start The Timer*/
    [self startTimer];
    
    if ([SIConstants isBackgroundSoundAllowed]) {
        SIBackgroundSound soundForScore = [Game backgroundSoundForScore:self.currentGame.totalScore];
        if (soundForScore != self.currentGame.currentBackgroundSound) {
            self.currentGame.currentBackgroundSound = soundForScore;
            [[SoundManager sharedManager] playMusic:[Game soundNameForSIBackgroundSound:soundForScore] looping:YES fadeIn:YES];
        }
    }
    
    /*Call this to get a new move and such...*/
    [self singletonWillContinue];
}

/**
 Called when the singleton will try to end the game
 This only really "pauses" the game state to allow 
 the user to intercept and pay for a continue...
 */
- (void)singletonWillEnd {
    /*Pause the game*/
    [self singletonWillPause];
    
    /*Alert the controller that the modal is ready to end the game*/
    if ([_delegate respondsToSelector:@selector(sceneWillShowContinue)]) {
        [_delegate sceneWillShowContinue];
        // TODO: add this to the controller...
//        if ( ) {
//            [self singletonWillContinue];
//        } else {
//            [self singletonDidEnd];
//        }
    }
}

/**
 Called to really end the game, invalidates timers and such...
 */
- (void)singletonDidEnd {
    [Game updateLifetimePointsScore:_currentGame.totalScore];
}

- (void)singletonWillPause {
    _currentGame.isPaused           = YES;
    _pauseStartTimeInMiliSeconds    = _compositeTimeInMiliSeconds;
}

/**
 Called in several scenarios
 
    1. User paid for to continue the game when they died...
 
    2. User tapped pause and now wants to play...
 */
- (void)singletonWillResumeAndContinue:(BOOL)willContinue {
    _currentGame.isPaused           = NO;
    
    /*Update the moveStartTime to account for the pause duration*/
    _moveStartTimeInMiliSeconds     = (_compositeTimeInMiliSeconds - _pauseStartTimeInMiliSeconds) + _moveStartTimeInMiliSeconds;
    
    for (PowerUp *powerUp in _currentGame.powerUpArray) {
        powerUp.startTimeMS         = (_compositeTimeInMiliSeconds - _pauseStartTimeInMiliSeconds) + powerUp.startTimeMS;
    }
    
    if (willContinue) {
        [self singletonWillContinue];
    }
}

/**
 Trys the move entered on view to see if it was correct one
 
 Public function called by view.. takes SIMove as input
 
    If correct -> calls singletonGameWillShowNewMove
    If incorrect -> calls singletonGameWillEnd
 */
- (void)singletonDidEnterMove:(SIMove)move {
    if (move == self.currentGame.currentMove) {
        /*
         If the game is not started we need to do a little extra, like
            start the timers and such
         */
        if (self.currentGame.isStarted) {
            [self singletonWillContinue];
        } else {
            [self singletonDidStart];
        }
    } else {
        [self singletonWillEnd];
    }
}

/**
 Indicates: 
    1. The correct move was entered
    2. View should react to correct move
    3. A new move should be loaded
    4. View should update 
 */
- (void)singletonWillContinue {
    /*Save the start of this new move*/
    _moveStartTimeInMiliSeconds         = _compositeTimeInMiliSeconds;
    
    if ([PowerUp isPowerUpActive:SIPowerUpFallingMonkeys powerUpArray:_currentGame.powerUpArray]) {
        _currentGame.totalScore         = _currentGame.totalScore + VALUE_OF_MONKEY;
        
        _currentGame.currentMove        = SIMoveFallingMonkey;
    } else {
        /**NORMAL*/
        /*Update the total score*/
        _currentGame.totalScore         = _currentGame.totalScore + _currentGame.moveScore;
        
        /*Get a new move... (considers rapid fire power up)*/
        _currentGame.currentMove        = [self updateMove];

    }
    
    
    /*Get a new background color*/
    _currentGame.currentBackgroundColor = [self singletonNewBackgroundColor];
    
    /*Update Background Sound*/
    [self updateBackgroundSound];
    
    /*Determine if Device High Score*/
    [self updateDeviceHighScore];
    
    /*Update the Free coin meter*/
    [self updatePointsTillFreeCoin];
    
    /*Alert that the model is ready for a new move*/
    if ([_delegate respondsToSelector:@selector(sceneWillLoadNewMove)]) {
        [_delegate sceneWillLoadNewMove];
    }
}

#pragma mark - Private Update Functions
- (SIMove)updateMove {
    if ([PowerUp isPowerUpActive:SIPowerUpRapidFire powerUpArray:_currentGame.powerUpArray]) {
        return SIMoveTap;
    } else {
        return [Game getRandomMoveForGameMode:_currentGame.gameMode];
    }
}

- (void)updateBackgroundSound {
    if ([SIConstants isBackgroundSoundAllowed]) {
        _currentGame.currentBackgroundSound = [Game checkBackgroundSound:_currentGame.currentBackgroundSound forTotalScore:_currentGame.totalScore withCallback:^(BOOL updatedBackgroundSound, SIBackgroundSound backgroundSoundNew) {
            if (updatedBackgroundSound) {
                [[SoundManager sharedManager] playMusic:[Game soundNameForSIBackgroundSound:backgroundSoundNew] looping:YES fadeIn:YES];
            }
        }];
    }
}

- (void)updateDeviceHighScore {
    if ([Game isDevieHighScore:_currentGame.totalScore]) {
        if ([_delegate respondsToSelector:@selector(sceneWillShowIsHighScore)]) {
            [self.delegate sceneWillShowIsHighScore];
        }
    }
}

- (void)updatePointsTillFreeCoin {
    _currentGame.freeCoinInPoints   = [Game updatePointsTillFreeCoinMoveScore:_currentGame.moveScore withCallback:^(BOOL willAwardFreeCoin) {
        if (willAwardFreeCoin) {
            [[MKStoreKit sharedKit] addFreeCredits:[NSNumber numberWithInt:1] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
            _currentGame.freeCoinsEarned = _currentGame.freeCoinsEarned + 1;
            
            /*Play sound for free coin*/
            if ([_delegate respondsToSelector:@selector(contorllerWillPlayFXSoundNamed:)]) {
                [_delegate contorllerWillPlayFXSoundNamed:kSISoundFXChaChing];
            }
            
            /*Alert the controller that a free coin has been earned*/
            if ([_delegate respondsToSelector:@selector(sceneWillShowFreeCoinEarned)]) {
                [self.delegate sceneWillShowFreeCoinEarned];
            }
        }
    }];
    
    /*Update the freeCoinPercentRemaining... this is for the free coin meter*/
    _currentGame.freeCoinPercentRemaining   = _currentGame.freeCoinInPoints / (float)POINTS_NEEDED_FOR_FREE_COIN;
}

- (UIColor *)singletonNewBackgroundColor {
    NSInteger randomNumber;
    if (self.currentGame.totalScore >= LEVEL12) {
        randomNumber = arc4random_uniform(NUMBER_OF_MOVES * 3);
        while (randomNumber == _currentGame.currentBackgroundColorNumber) {
            randomNumber = arc4random_uniform(NUMBER_OF_MOVES * 3);
        }

    } else {
        randomNumber = arc4random_uniform(NUMBER_OF_MOVES);
        while (randomNumber == _currentGame.currentBackgroundColorNumber) {
            randomNumber = arc4random_uniform(NUMBER_OF_MOVES);
        }

    }
    _currentGame.currentBackgroundColorNumber = randomNumber;
    return [Game backgroundColorForScore:_currentGame.totalScore forRandomNumber:randomNumber];
}
- (void)didLevelStringChange:(NSString *)oldLevelString newLevelString:(NSString *)newLevelString {
    if ([oldLevelString isEqualToString:newLevelString] == NO) {
        self.currentGame.currentLevel   = newLevelString;
        NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationLevelDidChange object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}
#pragma mark - Timer Methods
- (void)startTimer {
    if (!_timer.valid) {
        /*Start Timer*/
        _timer      = [NSTimer scheduledTimerWithTimeInterval:_timerInterval target:self selector:@selector(updateTimeAndScore) userInfo:nil repeats:YES];
        _startTime  = [NSDate timeIntervalSinceReferenceDate];
    }
}
/*updateTimeAndScore gets updated every 1/30 seconds*/
- (void)updateTimeAndScore {
    /*Update the master timer*/
    [self updateCompositeTime];
    
    if (_currentGame.isPaused == NO) {
        /*Calculate new time*/
        float durationOfLastMove                = (_compositeTimeInMiliSeconds - _moveStartTimeInMiliSeconds) * _timeFreezeMultiplyer;
        
        /*Calculate Level Speed Divider*/
        _levelSpeedDivider                      = [Game levelSpeedForScore:self.currentGame.totalScore];
        
        /*Get the new score for this time -- Always keep the time current*/
        _currentGame.moveScore                  = [Game scoreForMoveDuration:durationOfLastMove withLevelSpeedDivider:_levelSpeedDivider];
        
        /*Get the new percentage for score*/
        _currentGame.moveScorePercentRemaining  = _currentGame.moveScore / MAX_MOVE_SCORE;
        
        
        
        /*Get the powerup percent remaining*/
        _currentGame.powerUpPercentRemaining    = [PowerUp powerUpPercentRemaining:_currentGame.powerUpArray compositeTime:_compositeTimeInMiliSeconds withCallback:^(PowerUp *powerUpToDeactivate) {
            if (powerUpToDeactivate) {
                [self singletonWillDectivatePowerUp:powerUpToDeactivate];
            }
        }];
    }
}
/*updateCompositeTime gets updated every time updateTimeAndScore does*/
- (void)updateCompositeTime {
    NSTimeInterval currentTime      = [NSDate timeIntervalSinceReferenceDate];
    
    NSTimeInterval elapsedTime      = currentTime - _startTime;
    
    _compositeTimeInMiliSeconds     = elapsedTime * MILI_SECS_IN_SEC;
}

#pragma mark - Power Up Methods
/**
 This will be called by the controller when asking to start
 */
- (void)singletonWillActivatePowerUp:(SIPowerUp)powerUp {
    if ([PowerUp canStartPowerUp:powerUp powerUpArray:_currentGame.powerUpArray]) {
        /*We the know the power up can start...*/
        PowerUp *newPowerUp = [[PowerUp alloc] initWithPowerUp:powerUp atTime:_compositeTimeInMiliSeconds];
        [_currentGame.powerUpArray addObject:newPowerUp];
        if ([_delegate respondsToSelector:@selector(sceneWillActivatePowerUp:)]) {
            [_delegate sceneWillActivatePowerUp:newPowerUp.type];
        }
        [self singletonDidActivatePowerUp:newPowerUp.type];
    }
}
/**
 Called internally to apply any singleton changing settings
 the powerup might effect
 */
- (void)singletonDidActivatePowerUp:(SIPowerUp)powerUp {
    switch (powerUp) {
        case SIPowerUpRapidFire:
            [self singletonWillContinue];
            break;
        case SIPowerUpTimeFreeze:
            _timeFreezeMultiplyer   = 0.2f;
            break;
        case SIPowerUpFallingMonkeys:
            /*Do Falling Monkeys in Setup*/
            break;
        default:
            break;
    }
}
/**
 Called internally by the timer functions when a powerup's
    percent remaining value drops below the epsilon value
 */
- (void)singletonWillDectivatePowerUp:(PowerUp *)powerUpClass {
    if ([_delegate respondsToSelector:@selector(sceneWillDeactivatePowerUp:)]) {
        [_delegate sceneWillDeactivatePowerUp:powerUpClass.type];
    }
    [self singletonDidDectivatePowerUp:powerUpClass];
}
/**
 Called internally to remove anything setup by the powerup
    This is the class responible for removing the powerup from the 
    `powerUpArray`
 */
- (void)singletonDidDectivatePowerUp:(PowerUp *)powerUpClass {
    switch (powerUpClass.type) {
        case SIPowerUpTimeFreeze:
            _timeFreezeMultiplyer   = 1.0f;
            break;
        case SIPowerUpFallingMonkeys:
            /*Do Falling Monkeys Breakdown*/
            break;
        default:
            break;
    }
    [_currentGame.powerUpArray removeObject:powerUpClass];
}

///*This is the second step. This checks to see if we are currently using a powerup*/
//- (void)powerUpDidLoad:(SIPowerUp)powerUp {
//    if (self.currentGame.currentPowerUp == SIPowerUpNone) { /*Don't allow more then one power up at one time*/
//        [self powerUpWillActivate:powerUp withPowerUpCost:[Game costForPowerUp:powerUp]];
//    }
//}
///*This is the third step in powerup acitivation. This checks to see if the User has enough coins*/
//- (void)powerUpWillActivate:(SIPowerUp)powerUp withPowerUpCost:(SIPowerUpCost)powerUpCost {
//    
//    NSNumber *numberOfItCoins = [[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins];
//    if ([numberOfItCoins integerValue] >= powerUpCost) {
//        self.currentGame.currentPowerUp = powerUp;
//        
//        /*Post Notification... GameViewController is listening*/
//        NSDictionary *userInfo          = [NSDictionary dictionaryWithObject:@(powerUp) forKey:kSINSDictionaryKeyPowerUp];
//        NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationPowerUpActive object:nil userInfo:userInfo];
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//        
//        NSNumber *oldCoinAmount = [[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins];
//        /*Spend the Consumable*/
//        [[MKStoreKit sharedKit] consumeCredits:[NSNumber numberWithInt:powerUpCost] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
//        
//        /*DEBUG Print the new value*/
//        NSNumber *newCoinAmount = [[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins];
////        NSLog(@"Old Coin Value: %@ || New Coin Value: %@",oldCoinAmount,newCoinAmount);
//    }
//}
/*This is the 6th step. The UI View controller did react to the powerup*/
/*This is for the new one...*/

/*This is the 8th step*/
/*Called After Powerup has ended on Singleton*/
//- (void)powerUpDidEnd {
//    switch (self.currentGame.currentPowerUp) {
//        case SIPowerUpTimeFreeze:
//            _timeFreezeMultiplyer   = 1.0f;
//            break;
//        case SIPowerUpFallingMonkeys:
//            /*Do Falling Monkeys Breakdown*/
//            break;
//        default:
//            break;
//    }
//}

//- (BOOL)canAffordContinue {
//    int continueCost = [Game lifeCostForCurrentContinueLevel:self.currentGame.currentContinueLifeCost];
//    int numberOfItCoins = [[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue];
//    if (continueCost <= numberOfItCoins) {
//        return YES;
//    }
//    return NO;
//}

#pragma mark - Old Singleton Methods
//- (void)pause {
//    self.currentGame.isPaused           = YES;
//    self.pauseStartTimeInMiliSeconds    = self.compositeTimeInMiliSeconds;
//}
//- (void)play {
//    if (self.currentGame.isPaused) {
//        self.currentGame.isPaused           = NO;
//        NSLog(@"Play... Comp Time: %0.2f || PauseStart: %0.2f || MoveStart: %0.2f",self.compositeTimeInMiliSeconds,self.pauseStartTimeInMiliSeconds,self.moveStartTimeInMiliSeconds);
//        self.moveStartTimeInMiliSeconds     = (self.compositeTimeInMiliSeconds - self.pauseStartTimeInMiliSeconds) + self.moveStartTimeInMiliSeconds;
//    }
//}
//- (void)endGame {
//    self.currentGame.isStarted  = NO;
//    [self.manager stopAccelerometerUpdates];
//    [self.timer invalidate];
//    //
//    //    /*Send Notification that Game has ENDED*/
//    //    NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationGameEnded object:nil userInfo:nil];
//    //    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    //
//    //    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(powerUpDidEnd) object:nil];
//}
//- (void)stopGame {
//    [self pause];
//    /*Send Notification that Game has ENDED*/
//    NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationGameEnded object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(powerUpDidEnd) object:nil];
//    
//    /*Stop all sound, vibrate phone, play game over sound*/
//    if ([SIConstants isBackgroundSoundAllowed]) {
//        [[SoundManager sharedManager] stopMusic];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [[SoundManager sharedManager] playMusic:kSISoundBackgroundMenu looping:YES fadeIn:YES];
//        });
//        self.currentGame.currentBackgroundSound = SIBackgroundSoundMenu;
//    }
//    if ([SIConstants isFXAllowed]) {
//        [[SoundManager sharedManager] stopAllSounds];
//        [[SoundManager sharedManager] playSound:kSISoundFXGameOver];
//    }
//    
//    
//    
//}
//- (void)moveEnterForType:(SIMove)move {
//    if (move == self.currentGame.currentMove) {
//        [self willPrepareToShowNewMove];
//    } else {
//        [self stopGame];
//    }
//}
//- (void)willPrepareToShowNewMove {
//    NSDictionary *userInfo                          = [NSDictionary dictionaryWithObject:@(self.currentGame.moveScore) forKey:kSINSDictionaryKeyMoveScore];
//    
//    [self captureTime];     /*Capture the time for the next move*/
//    
//    if (self.isPaused == NO) {
//        //        NSLog(@"Move score: %0.2f and Total score: %0.2f",self.currentGame.moveScore,self.currentGame.totalScore);
//        if (self.currentGame.totalScore < epsilonLimit) {
//            CGFloat randomNumber                    = arc4random_uniform(10) / 10;
//            self.currentGame.moveScore = MAX_MOVE_SCORE - randomNumber;
//            userInfo                                = [NSDictionary dictionaryWithObject:@(self.currentGame.moveScore) forKey:kSINSDictionaryKeyMoveScore];
//            self.currentGame.totalScore = self.currentGame.moveScore;
//        } else {
//            self.currentGame.totalScore             = self.currentGame.totalScore + self.currentGame.moveScore; /*Add moveScore to total score*/
//        }
//        
//        [self setAndCheckDefaults:self.currentGame.moveScore];
//        
//        
//        [self didLevelStringChange:self.previousLevel newLevelString:[Game currentLevelStringForScore:self.currentGame.totalScore]];
//        
//        BOOL isRapidFireActive                      = (self.currentGame.currentPowerUp == SIPowerUpRapidFire) ? YES : NO;
//        
//        self.currentGame.currentMove                = [Game getRandomMoveForGameMode:self.currentGame.gameMode isRapidFireActiviated:isRapidFireActive]; /*Return Tap for if Rapid Fire*/
//        
//        /*See if you should load new sound*/
//        if ([SIConstants isBackgroundSoundAllowed]) {
//            SIBackgroundSound soundForScore = [Game backgroundSoundForScore:self.currentGame.totalScore];
//            if (soundForScore != self.currentGame.currentBackgroundSound) {
//                self.currentGame.currentBackgroundSound = soundForScore;
//                [[SoundManager sharedManager] playMusic:[Game soundNameForSIBackgroundSound:soundForScore] looping:YES fadeIn:YES];
//            }
//        }
//    }
//    
//    
//    NSNotification *notification                = [[NSNotification alloc] initWithName:kSINotificationCorrectMove object:nil userInfo:userInfo];
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    
//}
//- (void)setAndCheckDefaults:(float)score {
//    NSNumber *lifeTimeHighScore                 = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultLifetimeHighScore];
//    if (lifeTimeHighScore == nil) {
//        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:0.0f] forKey:kSINSUserDefaultLifetimeHighScore];
//    } else {
//        if (self.currentGame.totalScore > [lifeTimeHighScore floatValue]) {
//            self.currentGame.isHighScore        = YES;
//            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:self.currentGame.totalScore] forKey:kSINSUserDefaultLifetimeHighScore];
//            NSNotification *notification        = [[NSNotification alloc] initWithName:kSINotificationNewHighScore object:nil userInfo:nil];
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
//        }
//    }
//    
//    
//    NSNumber *lifeTimePointsEarned              = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultLifetimePointsEarned];
//    if (lifeTimePointsEarned == nil) {
//        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:0.0f] forKey:kSINSUserDefaultLifetimePointsEarned];
//    } else {
//        lifeTimePointsEarned                    = [NSNumber numberWithFloat: [lifeTimePointsEarned floatValue] + score];
//        [[NSUserDefaults standardUserDefaults] setObject:lifeTimePointsEarned forKey:kSINSUserDefaultLifetimePointsEarned];
//    }
//    
//    
//    NSNumber *pointsTillFreeCoinNumber          = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultPointsTowardsFreeCoin];
//    if (pointsTillFreeCoinNumber == nil) {
//        pointsTillFreeCoinNumber = [NSNumber numberWithFloat:0.0f];
//        [[NSUserDefaults standardUserDefaults] setObject:pointsTillFreeCoinNumber forKey:kSINSUserDefaultPointsTowardsFreeCoin];
//    }
//    float pointsTillFreeCoin                    = [pointsTillFreeCoinNumber floatValue];
//    //    NSLog(@"Points till free coin before: %0.2f",pointsTillFreeCoin);
//    pointsTillFreeCoin                          = pointsTillFreeCoin + score;
//    self.currentGame.freeCoinInPoints           = pointsTillFreeCoin;
//    if (pointsTillFreeCoin > POINTS_NEEDED_FOR_FREE_COIN + MAX_MOVE_SCORE) {
//        /*This is a critical error*/
//        //        [NSException raise:@"PointOverFlow" format:@"pointsTillFreeCoin is too high"];
//        pointsTillFreeCoin = POINTS_NEEDED_FOR_FREE_COIN / 2;
//        NSLog(@"Critical Error: Points needed wayyy to high... Resting to half of points needed.");
//    } else if (pointsTillFreeCoin > POINTS_NEEDED_FOR_FREE_COIN) {
//        if ([SIConstants isFXAllowed]) {
//            [[SoundManager sharedManager] playSound:kSISoundFXChaChing];
//        }
//        pointsTillFreeCoin                      = pointsTillFreeCoin - POINTS_NEEDED_FOR_FREE_COIN;
//        self.currentGame.freeCoinsEarned        = self.currentGame.freeCoinsEarned + 1;
//        [[MKStoreKit sharedKit] addFreeCredits:[NSNumber numberWithInt:1] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
//        NSNotification *notification            = [[NSNotification alloc] initWithName:kSINotificationFreeCoinEarned object:nil userInfo:nil];
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//    }
//    self.currentGame.freeCoinPercentRemaining   = (pointsTillFreeCoin / (float)POINTS_NEEDED_FOR_FREE_COIN);
//    //    NSLog(@"Points till free coin after: %0.2f",pointsTillFreeCoin);
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:pointsTillFreeCoin] forKey:kSINSUserDefaultPointsTowardsFreeCoin];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

//REMOVED FROM UPDATECOMPOSITETIME
/*Set the new percentage for Power UP*/
//        if (![PowerUp isPowerUpArrayEmpty:_currentGame.powerUpArray]) {
//
//            float powerUpTotalDuration = [PowerUp maxDurationPercentOfPowerUpArray:_currentGame.powerUpArray];
//
//            float powerUpPercent = ((powerUpTotalDuration * MILI_SECS_IN_SEC) - (_compositeTimeInMiliSeconds - _powerUpTimeInMiliSeconds)) / (powerUpTotalDuration * MILI_SECS_IN_SEC);
//            if (powerUpPercent < 0.0) {
//                _currentGame.powerUpPercentRemaining    = 0.0f;
//            } else {
//                _currentGame.powerUpPercentRemaining    = powerUpPercent;
//            }
//        }
@end