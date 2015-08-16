//  AppSingleton.h
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is the header file for the app singleton
//
// Local Controller Import
// Framework Import
#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIKit.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
// Support/Data Class Imports
#import "SIIAPUtility.h"
// Other Imports

@class Game;
@interface AppSingleton : NSObject {
    
}

#pragma mark - Singleton Method
+ (instancetype)singleton;

#pragma mark - Public Properties
@property (assign, nonatomic) BOOL               isSaving;
@property (assign, nonatomic) BOOL               willResume;

#pragma mark - Public Objects
@property (strong, nonatomic) CMMotionManager   *manager;
@property (strong, nonatomic) Game              *currentGame;


#pragma mark - Public Instance Methods
/**
 Method to determine if the user can continue...
 */
- (BOOL)canAffordContinue;

- (void)endGame; /*Should only be used for force quit*/
- (void)initAppSingletonWithGameMode:(SIGameMode)gameMode;
- (void)moveEnterForType:(SIMove)move;
- (UIColor *)newBackgroundColor;
- (void)setAndCheckDefaults:(float)score;
- (void)startGame;
- (void)pause;
- (void)play;
- (void)powerUpDidLoad:(SIPowerUp)powerUp;
- (void)powerUpWillActivate:(SIPowerUp)powerUp withPowerUpCost:(SIPowerUpCost)powerUpCost;
- (void)powerUpDidActivate;
- (void)powerUpDidEnd;
- (void)willPrepareToShowNewMove;


@end