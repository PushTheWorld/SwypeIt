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
NSString *const kSINSUserDefaultPowerUpReadyFallingMonkeys  = @"powerUpReadyTimeFallingMonkeys";
NSString *const kSINSUserDefaultPowerUpReadyRapidFire       = @"powerUpReadyRapidFire";
NSString *const kSINSUserDefaultPowerUpReadyTimeFreeze      = @"powerUpReadyTimeFreeze";
NSString *const kSINSUserDefaultNumberOfMonkeys             = @"numberOfMonkeys";

#pragma mark - Power Ups
NSString *const kSIPowerUpFallingMonkeys                    = @"Falling Monkeys";
NSString *const kSIPowerUpNone                              = @"None";
NSString *const kSIPowerUpTimeFreeze                        = @"Time Freeze";
NSString *const kSIPowerUpRapidFire                         = @"Rapid Fire";

#pragma mark - NSNotification
NSString *const kSINotificationCorrectMove                  = @"com.pushtheworldllc.swipeit.correctMove";
NSString *const kSINotificationGameEnded                    = @"com.pushtheworldllc.swipeit.gameEnded";
NSString *const kSINotificationGameStarted                  = @"com.pushtheworldllc.swipeit.gameStarted";
NSString *const kSINotificationLevelDidChange               = @"com.pushtheworldllc.swipeit.levelDidChange";
NSString *const kSINotificationNewBackgroundReady           = @"com.pushtheworldllc.swipeit.newBackgroundReady";
NSString *const kSINotificationPowerUpActive                = @"com.pushtheworldllc.swipeit.powerUpActive";
NSString *const kSINotificationPowerUpDeactivated           = @"com.pushtheworldllc.swipeit.powerUpDeactivated";
NSString *const kSINotificationScoreUpdate                  = @"com.pushtheworldllc.swipeit.scoreUpdate";
NSString *const kSINotificationPackPurchaseRequest          = @"com.pushtheworldllc.swipeit.purchasePack";

#pragma mark - Score Constants
NSString *const kSIScoreTotalScore                          = @"totalScore";
NSString *const kSIScoreNextMove                            = @"nextMove";

#pragma mark - Images
NSString *const kSIImageFallingMonkeys                      = @"fallingMonkey";

#pragma mark - Button Labels
NSString *const kSIButtonLabelStringOneHand                 = @"One Hand";
NSString *const kSIButtonLabelStringTwoHand                 = @"Two Hand";

#pragma mark - NSDictionary Keys
NSString *const kSINSDictionaryKeyMoveScore                 = @"moveScore";
NSString *const kSINSDictionaryKeyPowerUp                   = @"powerUp";
NSString *const kSINSDictionaryKeyPackProduct               = @"packProduct";

#pragma mark - In App Purchase Product ID
NSString *const kSIIAPProductIDCoinPackSmall                = @"com.pushtheworldllc.swipeit.swypeItSmallPack";
NSString *const kSIIAPProductIDCoinPackMedium               = @"com.pushtheworldllc.swipeit.swypeItMediumPack";
NSString *const kSIIAPProductIDCoinPackLarge                = @"com.pushtheworldllc.swipeit.swypeItLargePack";
NSString *const kSIIAPProductIDCoinPackExtraLarge           = @"com.pushtheworldllc.swipeit.swypeItExtraLargePack";

#pragma mark - In App Purchase Consumable ID
NSString *const kSIIAPConsumableIDCoins                     = @"ITCoins";

#pragma mark - In App Purchase Pack Names
NSString *const kSIIAPPackNameSmall                         = @"Bag";
NSString *const kSIIAPPackNameMedium                        = @"Pile";
NSString *const kSIIAPPackNameLarge                         = @"Bucket";
NSString *const kSIIAPPackNameExtraLarge                    = @"Chest";
