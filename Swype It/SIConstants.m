//  SIConstants.h
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//
#import "SIConstants.h"

#pragma mark - Images
NSString *const kSIImageTitleLabel              = @"textLabelTitle";

#pragma mark - Swype It Move Commands
NSString *const kSIMoveCommandSwype             = @"Swype It";
NSString *const kSIMoveCommandTap               = @"Tap It";
NSString *const kSIMoveCommandPinch             = @"Pinch It";
NSString *const kSIMoveCommandShake             = @"Shake It";

#pragma mark - Game Modes
NSString *const kSIGameModeOriginal             = @"gameModeOriginal";
NSString *const kSIGameModeOneHand              = @"gameModeOneHand";

#pragma mark - NSUserDefaults
NSString *const kSINSUserDefaultFirstLaunch     = @"firstLaunch";
NSString *const kSINSUserDefaultNumberOfItCoins = @"numberOfItCoins";

#pragma mark - Power Ups
NSString *const kSIPowerUpForesight             = @"foresight";
NSString *const kSIPowerUpTimeFreeze            = @"timeFreeze";
NSString *const kSIPowerUpRapidFire             = @"rapidFire";

#pragma mark - NSNotification
NSString *const kSINotificationCorrectMove      = @"com.pushtheworldllc.swipeit.correctMove";
NSString *const kSINotificationGameEnded        = @"com.pushtheworldllc.swipeit.gameEnded";
NSString *const kSINotificationGameStarted      = @"com.pushtheworldllc.swipeit.gameStarted";
NSString *const kSINotificationScoreUpdate      = @"com.pushtheworldllc.swipeit.scoreUpdate";

#pragma mark - Score Constants
NSString *const kSIScoreTotalScore              = @"totalScore";
NSString *const kSIScoreNextMove                = @"nextMove";

