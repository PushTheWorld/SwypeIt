//  SIConstants.h
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//
#import "SIConstants.h"

#pragma mark - Images
NSString *const kSIImageTitleLabel                          = @"textLabelTitle";

#pragma mark - Swype It Move Commands
NSString *const kSIMoveCommandSwype                         = @"Swype It";
NSString *const kSIMoveCommandTap                           = @"Tap It";
NSString *const kSIMoveCommandPinch                         = @"Pinch It";
NSString *const kSIMoveCommandShake                         = @"Shake It";

#pragma mark - Game Modes
NSString *const kSIGameModeTwoHand                          = @"gameModeTwoHand";
NSString *const kSIGameModeOneHand                          = @"gameModeOneHand";

#pragma mark - NSUserDefaults
NSString *const kSINSUserDefaultFirstLaunch                 = @"firstLaunch";
NSString *const kSINSUserDefaultNumberOfItCoins             = @"numberOfItCoins";
NSString *const kSINSUserDefaultGameMode                    = @"gameMode";
NSString *const kSINSUserDefaultPowerUpReadyForesight       = @"powerUpReadyForesight";
NSString *const kSINSUserDefaultPowerUpReadyRapidFire       = @"powerUpReadyRapidFire";
NSString *const kSINSUserDefaultPowerUpReadySlowMotion      = @"powerUpReadySlowMotion";

#pragma mark - Power Ups
NSString *const kSIPowerUpForesight                         = @"Foresight";
NSString *const kSIPowerUpNone                              = @"None";
NSString *const kSIPowerUpSlowMotion                        = @"Slow Motion";
NSString *const kSIPowerUpRapidFire                         = @"Rapid Fire";

#pragma mark - NSNotification
NSString *const kSINotificationCorrectMove                  = @"com.pushtheworldllc.swipeit.correctMove";
NSString *const kSINotificationGameEnded                    = @"com.pushtheworldllc.swipeit.gameEnded";
NSString *const kSINotificationGameStarted                  = @"com.pushtheworldllc.swipeit.gameStarted";
NSString *const kSINotificationScoreUpdate                  = @"com.pushtheworldllc.swipeit.scoreUpdate";
NSString *const kSINotificationPowerUpActive                = @"com.pushtheworldllc.swipeit.powerUpActive";
NSString *const kSINotificationPowerUpDeactivated           = @"com.pushtheworldllc.swipeit.powerUpDeactivated";

#pragma mark - Score Constants
NSString *const kSIScoreTotalScore                          = @"totalScore";
NSString *const kSIScoreNextMove                            = @"nextMove";

#pragma mark - Images
NSString *const kSISegmentControlGameModeSelectedOneHand    = @"segmentControlGameModeSelectedOneHand";
NSString *const kSISegmentControlGameModeSelectedTwoHand    = @"segmentControlGameModeSelectedTwoHand";
NSString *const kSISegmentControlGameModeUnselectedOneHand  = @"segmentControlGameModeUnselectedOneHand";
NSString *const kSISegmentControlGameModeUnselectedTwoHand  = @"segmentControlGameModeUnselectedTwoHand";

#pragma mark - Button Labels
NSString *const kSIButtonLabelStringOneHand                 = @"One Hand";
NSString *const kSIButtonLabelStringTwoHand                 = @"Two Hand";

#pragma mark - NSDictionary Keys
NSString *const kSINSDictionaryKeyPowerUp                   = @"powerUp";


