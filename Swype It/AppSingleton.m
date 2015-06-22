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
#import <CoreMotion/CoreMotion.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "FXReachability.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIConstants.h"
// Other Imports
@interface AppSingleton () {
    
}
#pragma mark - BOOLS
@property (assign, nonatomic) BOOL               willIgnoreShake;

#pragma mark - Private CGFloats
@property (assign, nonatomic) CGFloat            compositeTimeInMiliSeconds;
@property (assign, nonatomic) CGFloat            timerInterval;

#pragma mark - Private Properties
@property (assign, nonatomic) NSTimeInterval     startTime;

@property (strong, nonatomic) CMMotionManager   *manager;
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
    self.manager        = [[CMMotionManager alloc] init];
    self.timer          = [[NSTimer alloc] init];
    
    self.timerInterval  = 1.0f / 3.0f;
}
#pragma mark - Game Functions
- (void)startGame {
    /*Start The Timer*/
    [self startTimer];
}
- (void)endGame {
    NSLog(@"Game Ended");
}
#pragma mark - Timer Methods
- (void)startTimer {
    if (self.timer.valid) {
        /*Start Timer*/
        self.timer      = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        self.startTime  = [NSDate timeIntervalSinceReferenceDate];
    }
}
- (void)updateScore {
    
}
@end