//  SIConstants.h
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//
#import "SIConstants.h"

#pragma mark - Images
NSString *const kSIImageTitleLabel                                  = @"textLabelTitle";

#pragma mark - Swype It Move Commands
NSString *const kSIMoveCommandSwype                                 = @"Swype It";
NSString *const kSIMoveCommandTap                                   = @"Tap It";
NSString *const kSIMoveCommandPinch                                 = @"Pinch It";
NSString *const kSIMoveCommandShake                                 = @"Shake It";

#pragma mark - Game Modes
NSString *const kSIGameModeTwoHand                                  = @"gameModeTwoHand";
NSString *const kSIGameModeOneHand                                  = @"gameModeOneHand";

#pragma mark - NSUserDefaults
NSString *const kSINSUserDefaultFirstLaunch                         = @"firstLaunch";
NSString *const kSINSUserDefaultNumberOfItCoins                     = @"numberOfItCoins";
NSString *const kSINSUserDefaultGameMode                            = @"gameMode";
NSString *const kSINSUserDefaultPowerUpReadyFallingMonkeys          = @"powerUpReadyTimeFallingMonkeys";
NSString *const kSINSUserDefaultPowerUpReadyRapidFire               = @"powerUpReadyRapidFire";
NSString *const kSINSUserDefaultPowerUpReadyTimeFreeze              = @"powerUpReadyTimeFreeze";
NSString *const kSINSUserDefaultNumberOfMonkeys                     = @"numberOfMonkeys";

#pragma mark - Power Ups
NSString *const kSIPowerUpFallingMonkeys                            = @"Falling Monkeys";
NSString *const kSIPowerUpNone                                      = @"None";
NSString *const kSIPowerUpTimeFreeze                                = @"Time Freeze";
NSString *const kSIPowerUpRapidFire                                 = @"Rapid Fire";

#pragma mark - NSNotification
NSString *const kSINotificationCorrectMove                          = @"com.pushtheworldllc.swipeit.correctMove";
NSString *const kSINotificationHudHide                              = @"com.pushtheworldllc.swipeit.hudHide";
NSString *const kSINotificationHudShow                              = @"com.pushtheworldllc.swipeit.hudShow";
NSString *const kSINotificationGameEnded                            = @"com.pushtheworldllc.swipeit.gameEnded";
NSString *const kSINotificationGameResumed                          = @"com.pushtheworldllc.swipeit.gameResumed";
NSString *const kSINotificationGameStarted                          = @"com.pushtheworldllc.swipeit.gameStarted";
NSString *const kSINotificationLevelDidChange                       = @"com.pushtheworldllc.swipeit.levelDidChange";
NSString *const kSINotificationNewBackgroundReady                   = @"com.pushtheworldllc.swipeit.newBackgroundReady";
NSString *const kSINotificationPackPurchaseRequest                  = @"com.pushtheworldllc.swipeit.purchasePack";
NSString *const kSINotificationPowerUpActive                        = @"com.pushtheworldllc.swipeit.powerUpActive";
NSString *const kSINotificationPowerUpDeactivated                   = @"com.pushtheworldllc.swipeit.powerUpDeactivated";
NSString *const kSINotificationScoreUpdate                          = @"com.pushtheworldllc.swipeit.scoreUpdate";


#pragma mark - Score Constants
NSString *const kSIScoreTotalScore                                  = @"totalScore";
NSString *const kSIScoreNextMove                                    = @"nextMove";

#pragma mark - Images
NSString *const kSIImageButtonContinue                              = @"continueButton";
NSString *const kSIImageButtonContinueGrayed                        = @"continueGrayedButton";
NSString *const kSIImageButtonDone                                  = @"doneButton";
NSString *const kSIImageButtonFallingMonkey                         = @"monkey";
NSString *const kSIImageButtonGameModeOneHand                       = @"oneHandRevB";
NSString *const kSIImageButtonGameModeTwoHand                       = @"twoHandRevB";
NSString *const kSIImageButtonMenu                                  = @"menuButton";
NSString *const kSIImageButtonPause                                 = @"pauseButton";
NSString *const kSIImageButtonPlay                                  = @"playButton";
NSString *const kSIImageButtonRapidFire                             = @"rapidFire";
NSString *const kSIImageButtonReplay                                = @"replayButton";
NSString *const kSIImageButtonStore                                 = @"storeButton";
NSString *const kSIImageButtonTimeFreeze                            = @"timeFreeze";
NSString *const kSIImageFallingMonkeys                              = @"monkeyFreeVector";
NSString *const kSIImageProgressBarFill                             = @"progressBarFill";
NSString *const kSIImageProgressBarPowerUpFill                      = @"progressBarPowerUpFill";

#pragma mark - Texture Atlas
NSString *const kSIAtlasButtons                                     = @"buttons";

#pragma mark - Button Labels
NSString *const kSIButtonLabelStringOneHand                         = @"One Hand";
NSString *const kSIButtonLabelStringTwoHand                         = @"Two Hand";

#pragma mark - NSDictionary Keys
NSString *const kSINSDictionaryKeyHudHoldDismissForDuration         = @"HudWillHoldDismissForDuration";
NSString *const kSINSDictionaryKeyHudMessageDismissTitle            = @"HudDismissMessageTitle";
NSString *const kSINSDictionaryKeyHudMessageDismissInfo             = @"HudDismissMessageInfo";
NSString *const kSINSDictionaryKeyHudMessagePresentTitle            = @"HudPresentMessageTitle";
NSString *const kSINSDictionaryKeyHudMessagePresentInfo             = @"HudPresentMessageInfo";
NSString *const kSINSDictionaryKeyHudWillAnimate                    = @"hudWillAnimate";
NSString *const kSINSDictionaryKeyHudWillDimBackground              = @"hudWillAnimate";
NSString *const kSINSDictionaryKeyHudWillShowCheckmark              = @"HudWillDimBackground";
NSString *const kSINSDictionaryKeyMoveScore                         = @"moveScore";
NSString *const kSINSDictionaryKeyPowerUp                           = @"powerUp";
NSString *const kSINSDictionaryKeyPackProduct                       = @"packProduct";

#pragma mark - In App Purchase Product ID
NSString *const kSIIAPProductIDCoinPackSmall                        = @"com.pushtheworldllc.swipeit.swypeItSmallPack";
NSString *const kSIIAPProductIDCoinPackMedium                       = @"com.pushtheworldllc.swipeit.swypeItMediumPack";
NSString *const kSIIAPProductIDCoinPackLarge                        = @"com.pushtheworldllc.swipeit.swypeItLargePack";
NSString *const kSIIAPProductIDCoinPackExtraLarge                   = @"com.pushtheworldllc.swipeit.swypeItExtraLargePack";

#pragma mark - In App Purchase Consumable ID
NSString *const kSIIAPConsumableIDCoins                             = @"ITCoins";

#pragma mark - In App Purchase Pack Names
NSString *const kSIIAPPackNameSmall                                 = @"Bag";
NSString *const kSIIAPPackNameMedium                                = @"Pile";
NSString *const kSIIAPPackNameLarge                                 = @"Bucket";
NSString *const kSIIAPPackNameExtraLarge                            = @"Chest";

#pragma mark - Node Names
NSString *const kSINodeLabelDescriptionChest                        = @"chestOfCoinsLabelDescription";
NSString *const kSINodeLabelDescriptionBag                          = @"bagOfCoinsLabelDescription";
NSString *const kSINodeLabelDescriptionBucket                       = @"bucketOfCoinsLabelDescription";
NSString *const kSINodeLabelDescriptionPile                         = @"pileOfCoinsLabelDescription";
NSString *const kSINodeLabelPriceChest                              = @"chestOfCoinsLabelPrice";
NSString *const kSINodeLabelPriceBag                                = @"bagOfCoinsLabelPrice";
NSString *const kSINodeLabelPriceBucket                             = @"bucketOfCoinsLabelPrice";
NSString *const kSINodeLabelPricePile                               = @"pileOfCoinsLabelPrice";
NSString *const kSINodeNodeChest                                    = @"chestOfCoinsNode";
NSString *const kSINodeNodeBag                                      = @"bagOfCoinsNode";
NSString *const kSINodeNodeBucket                                   = @"bucketOfCoinsNode";
NSString *const kSINodeNodePile                                     = @"pileOfCoinsNode";
NSString *const kSINodeButtonContinue                               = @"continueButton";
NSString *const kSINodeButtonDone                                   = @"doneButton";
NSString *const kSINodeButtonFallingMonkey                          = @"fallingMonkeyButton";
NSString *const kSINodeButtonMenu                                   = @"menuButton";
NSString *const kSINodeButtonOneHand                                = @"oneHand";
NSString *const kSINodeButtonPause                                  = @"pause";
NSString *const kSINodeButtonPlay                                   = @"play";
NSString *const kSINodeButtonRapidFire                              = @"rapidFire";
NSString *const kSINodeButtonReplay                                 = @"replay";
NSString *const kSINodeButtonStore                                  = @"store";
NSString *const kSINodeButtonTwoHand                                = @"twoHand";
NSString *const kSINodeButtonTimeFreeze                             = @"timeFreeze";
NSString *const kSINodeFallingMonkey                                = @"fallingMonkey";

#pragma mark - Fonts
NSString *const kSIFontFuturaMedium                                 = @"Futura Medium";

@implementation SIConstants 

+ (SKTextureAtlas *)buttonAtlas {
    return [SKTextureAtlas atlasNamed:kSIAtlasButtons];
}

@end

