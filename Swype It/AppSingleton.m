//  AppSingleton.m
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is a singlton for managing creation and editing of Simplsts
//
// Defines
#define mSlope                  -7/240
#define SCORE_EXP_POWER_WEIGHT  -0.001205
#define MAX_MOVE_SCORE          10.78457
#define TIMER_INTERVAL          1/30
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
@property (assign, nonatomic) float              levelSpeedDivider;
@property (assign, nonatomic) float              moveStartTimeInMiliSeconds;


#pragma mark - Private Properties
@property (assign, nonatomic) NSTimeInterval     startTime;

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
- (void)runFirstGame {
    [self initalizeObjects];
    [self startGame];
}
- (void)initalizeObjects {
    self.manager            = [[CMMotionManager alloc] init];
    self.timer              = [[NSTimer alloc] init];
    
    self.levelSpeedDivider  = 1.0f;
    self.timerInterval      = TIMER_INTERVAL;
}
#pragma mark - Game Functions
- (void)startGame {
    self.currentGame.totalScore = 0.0;

    /*Send Notification that Game has STARTED*/
    NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationGameStarted object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    /*Start The Timer*/
    [self startTimer];
}
- (void)endGame {
    [self.manager stopAccelerometerUpdates];
    
    /*Send Notification that Game has ENDED*/
    NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationGameEnded object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}
- (void)moveEnterForType:(NSString *)move {
    if ([move isEqualToString:self.currentGame.currentMove]) {
        [self willPrepareToShowNewMove];
    } else {
        [self endGame];
    }
}
- (void)willPrepareToShowNewMove {
    [self captureTime];     /*Capture the time for the next move*/
    
    self.currentGame.totalScore = self.currentGame.totalScore + self.currentGame.moveScore; /*Add moveScore to total score*/
    
    self.currentGame.currentMove = [Game getRandomLevelMoveForGameMode:[AppSingleton singleton].currentGame.gameMode];
    
    NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationCorrectMove object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}
- (void)captureTime {
    self.moveStartTimeInMiliSeconds = self.compositeTimeInMiliSeconds;
}
#pragma mark - Timer Methods
- (void)startTimer {
    if (self.timer.valid) {
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
    float durationOfLastMove    = self.compositeTimeInMiliSeconds - self.moveStartTimeInMiliSeconds;
    
    /*Get the new score for this time -- Always keep the time current*/
    self.currentGame.moveScore  = MAX_MOVE_SCORE * exp(SCORE_EXP_POWER_WEIGHT * durationOfLastMove / self.levelSpeedDivider);
    
    /*Get the new percentage for score*/
    self.currentGame.moveScorePercentRemaining = self.currentGame.moveScore / MAX_MOVE_SCORE;
    
    NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationScoreUpdate object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
/*updateCompositeTime gets updated every time updateTimeAndScore does*/
- (void)updateCompositeTime {
    float currentTime = [NSDate timeIntervalSinceReferenceDate];
    
    NSTimeInterval elapsedTime = currentTime - self.startTime;
    
    self.compositeTimeInMiliSeconds = elapsedTime * MILI_SECS_IN_SEC;
}


@end