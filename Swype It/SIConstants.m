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
NSString *const kSINSUserDefaultLifetimeHighScore                   = @"lifetimeHighScore";
NSString *const kSINSUserDefaultLifetimeGamesPlayed                 = @"lifetimeGamesPlayed";
NSString *const kSINSUserDefaultLifetimePointsEarned                = @"lifetimePointsEarned";
NSString *const kSINSUserDefaultGameMode                            = @"gameMode";
NSString *const kSINSUserDefaultPremiumUser                         = @"userIsPremium";
NSString *const kSINSUserDefaultPointsTowardsFreeCoin               = @"pointsTowardsFreeCoin";
NSString *const kSINSUserDefaultPowerUpReadyFallingMonkeys          = @"powerUpReadyTimeFallingMonkeys";
NSString *const kSINSUserDefaultPowerUpReadyRapidFire               = @"powerUpReadyRapidFire";
NSString *const kSINSUserDefaultPowerUpReadyTimeFreeze              = @"powerUpReadyTimeFreeze";
NSString *const kSINSUserDefaultNumberOfMonkeys                     = @"numberOfMonkeys";
NSString *const kSINSUserDefaultSoundIsAllowedBackground            = @"backgroundSoundIsAllowed";
NSString *const kSINSUserDefaultSoundIsAllowedFX                    = @"fXSoundIsAllowed";

#pragma mark - Power Ups
NSString *const kSIPowerUpFallingMonkeys                            = @"Falling Monkeys";
NSString *const kSIPowerUpNone                                      = @"None";
NSString *const kSIPowerUpTimeFreeze                                = @"Time Freeze";
NSString *const kSIPowerUpRapidFire                                 = @"Rapid Fire";

#pragma mark - NSNotification
NSString *const kSINotificationInterstitialAdFinish                 = @"com.pushtheworldllc.swipeit.interstitiialAdDidFinish";
NSString *const kSINotificationInterstitialAdShallLaunch            = @"com.pushtheworldllc.swipeit.interstitiialAdShallLaunch";
NSString *const kSINotificationFreeCoinEarned                       = @"com.pushtheworldllc.swipeit.freeCoinEarned";
NSString *const kSINotificationCorrectMove                          = @"com.pushtheworldllc.swipeit.correctMove";
NSString *const kSINotificationHudHide                              = @"com.pushtheworldllc.swipeit.hudHide";
NSString *const kSINotificationHudShow                              = @"com.pushtheworldllc.swipeit.hudShow";
NSString *const kSINotificationGameContinueUseAD                    = @"com.pushtheworldllc.swipeit.gameContinueUseAD";
NSString *const kSINotificationGameContinueUseCancel                = @"com.pushtheworldllc.swipeit.gameContinueUseCancel";
NSString *const kSINotificationGameContinueUseCoins                 = @"com.pushtheworldllc.swipeit.gameContinueUseCoins";
NSString *const kSINotificationGameContinueUseLaunchStore           = @"com.pushtheworldllc.swipeit.gameContinueUseLaunchStore";
NSString *const kSINotificationGameContinueUsePopup                 = @"com.pushtheworldllc.swipeit.gameContinueUsePopup";
NSString *const kSINotificationGameEnded                            = @"com.pushtheworldllc.swipeit.gameEnded";
NSString *const kSINotificationGameResumed                          = @"com.pushtheworldllc.swipeit.gameResumed";
NSString *const kSINotificationGameStarted                          = @"com.pushtheworldllc.swipeit.gameStarted";
NSString *const kSINotificationLevelDidChange                       = @"com.pushtheworldllc.swipeit.levelDidChange";
NSString *const kSINotificationMenuLoaded                           = @"com.pushtheworldllc.swipeit.menuLoaded";
NSString *const kSINotificationNewBackgroundReady                   = @"com.pushtheworldllc.swipeit.newBackgroundReady";
NSString *const kSINotificationNewHighScore                         = @"com.pushtheworldllc.swipeit.newHighScore";
NSString *const kSINotificationPackPurchaseRequest                  = @"com.pushtheworldllc.swipeit.purchasePack";
NSString *const kSINotificationPowerUpActive                        = @"com.pushtheworldllc.swipeit.powerUpActive";
NSString *const kSINotificationPowerUpDeactivated                   = @"com.pushtheworldllc.swipeit.powerUpDeactivated";
NSString *const kSINotificationSettingsLaunchBugReport              = @"com.pushtheworldllc.swipeit.settingsLaunchBugReport";
NSString *const kSINotificationScoreUpdate                          = @"com.pushtheworldllc.swipeit.scoreUpdate";
NSString *const kSINotificationShowAlert                            = @"com.pushtheworldllc.swipeit.showAlert";


#pragma mark - Score Constants
NSString *const kSIScoreTotalScore                                  = @"totalScore";
NSString *const kSIScoreNextMove                                    = @"nextMove";

#pragma mark - Images
NSString *const kSIImageBackgroundDiamondPlate                      = @"diamondPlate";
NSString *const kSIImageButtonCoinSmall                             = @"coinSmall";
NSString *const kSIImageButtonContinue                              = @"continueButton";
NSString *const kSIImageButtonContinueGrayed                        = @"continueGrayedButton";
NSString *const kSIImageButtonCross                                 = @"cross";
NSString *const kSIImageButtonDone                                  = @"doneButton";
NSString *const kSIImageButtonFallingMonkey                         = @"monkey";
NSString *const kSIImageButtonGameModeOneHand                       = @"oneHandRevB";
NSString *const kSIImageButtonGameModeTwoHand                       = @"twoHandRevB";
NSString *const kSIImageButtonMenu                                  = @"menuButton";
NSString *const kSIImageButtonPause                                 = @"pauseButtonRevB";
NSString *const kSIImageButtonPlay                                  = @"playButtonRevB";
NSString *const kSIImageButtonRapidFire                             = @"rapidFire";
NSString *const kSIImageButtonReplay                                = @"replayButton";
NSString *const kSIImageButtonSettings                              = @"settingsButtonRevB";
NSString *const kSIImageButtonSoundOffBackground                    = @"soundBackgroundOff";
NSString *const kSIImageButtonSoundOffFX                            = @"soundFXOff";
NSString *const kSIImageButtonSoundOnBackground                     = @"soundBackgroundOn";
NSString *const kSIImageButtonSoundOnFX                             = @"soundFXOn";
NSString *const kSIImageButtonStore                                 = @"storeButton";
NSString *const kSIImageButtonTimeFreeze                            = @"timeFreeze";
NSString *const kSIImageFallingMonkeys                              = @"monkeyFreeVector";
NSString *const kSIImageIAPSmall                                    = @"tempPile";
NSString *const kSIImageIAPMedium                                   = @"tempBucket";
NSString *const kSIImageIAPLarge                                    = @"tempBag";
NSString *const kSIImageIAPExtraLarge                               = @"tempChest";
NSString *const kSIImageProgressBarFillMove                         = @"progressBarFillMove";
NSString *const kSIImageProgressBarFillPowerUp                      = @"progressBarFillPowerUp";
NSString *const kSIImageShapePowerupCost                            = @"powerupCost";



#pragma mark - Texture Atlas
NSString *const kSIAtlasButtons                                     = @"buttons";
NSString *const kSIAtlasImages                                      = @"images";
NSString *const kSIAtlasShapes                                      = @"shapes";

#pragma mark - Button Labels
NSString *const kSIButtonLabelStringOneHand                         = @"One Hand";
NSString *const kSIButtonLabelStringTwoHand                         = @"Two Hand";

#pragma mark - NSDictionary Keys
NSString *const kSINSDictionaryKeyCanAfford                         = @"canAfford";
NSString *const kSINSDictionaryKeyCanAffordCost                     = @"canAffordCost";
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
NSString *const kSIIAPProductIDCoinPackSmall                        = @"com.pushtheworldllc.swipeit.dev.swypeItSmallPack";
NSString *const kSIIAPProductIDCoinPackMedium                       = @"com.pushtheworldllc.swipeit.dev.swypeItMediumPack";
NSString *const kSIIAPProductIDCoinPackLarge                        = @"com.pushtheworldllc.swipeit.dev.swypeItLargePack";
NSString *const kSIIAPProductIDCoinPackExtraLarge                   = @"com.pushtheworldllc.swipeit.dev.swypeItExtraLargePack";

#pragma mark - In App Purchase Consumable ID
NSString *const kSIIAPConsumableIDCoins                             = @"ITCoins";

#pragma mark - In App Purchase Pack Names
NSString *const kSIIAPPackNameSmall                                 = @"Pile";
NSString *const kSIIAPPackNameMedium                                = @"Bucket";
NSString *const kSIIAPPackNameLarge                                 = @"Bag";
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
NSString *const kSINodeButtonSettings                               = @"settings";
NSString *const kSINodeButtonStore                                  = @"store";
NSString *const kSINodeButtonTwoHand                                = @"twoHand";
NSString *const kSINodeButtonTimeFreeze                             = @"timeFreeze";
NSString *const kSINodeFallingMonkey                                = @"fallingMonkey";
NSString *const kSINodeGameMoveCommand                              = @"moveCommand";
NSString *const kSINodeGameProgressBarMove                          = @"progressBarMove";
NSString *const kSINodeGameScoreTotal                               = @"scoreTotal";

#pragma mark - Fonts
NSString *const kSIFontGameScore                                    = @"LongIslandContour";
NSString *const kSIFontFuturaMedium                                 = @"Futura-Medium";
NSString *const kSIFontUltra                                        = @"Ultra";

#pragma mark - Menu Button Texts
NSString *const kSIMenuTextBack                                     = @"Back";
NSString *const kSIMenuTextEndGameContinue                          = @"Continue?";
NSString *const kSIMenuTextEndGameReplay                            = @"Replay";
NSString *const kSIMenuTextEndGameStore                             = @"Store";
NSString *const kSIMenuTextEndGameMainMenu                          = @"Main Menu";
NSString *const kSIMenuTextSettingsBugReport                        = @"Report Bug";
NSString *const kSIMenuTextSettingsResetHighScore                   = @"Reset High Score";
NSString *const kSIMenuTextSettingsRestorePurchases                 = @"Restore Purchases";
NSString *const kSIMenuTextSettingsToggleSoundOffBackground         = @"Music Off";
NSString *const kSIMenuTextSettingsToggleSoundOffFX                 = @"Sound FX Off";
NSString *const kSIMenuTextSettingsToggleSoundOnBackground          = @"Music On";
NSString *const kSIMenuTextSettingsToggleSoundOnFX                  = @"Sound FX On";
NSString *const kSIMenuTextStartScreenOneHand                       = @"Play One Hand";
NSString *const kSIMenuTextStartScreenTwoHand                       = @"Play Original";
NSString *const kSIMenuTextStartScreenSettings                      = @"Settings";
NSString *const kSIMenuTextStartScreenStore                         = @"Store";

#pragma mark - Emails
NSString *const kSIEmailBugReportReciever                           = @"buggy.bug@pushtheworld.us";

#pragma mark - Sounds
NSString *const kSISoundBackgroundMenu                              = @"menuSound";
NSString *const kSISoundBackgroundOne                               = @"swypeItSound1";
NSString *const kSISoundBackgroundTwo                               = @"swypeItSound2";
NSString *const kSISoundBackgroundThree                             = @"swypeItSound3";
NSString *const kSISoundBackgroundFour                              = @"swypeItSound4";
NSString *const kSISoundBackgroundFive                              = @"swypeItSound5";
NSString *const kSISoundBackgroundSix                               = @"swypeItSound6";
NSString *const kSISoundBackgroundSeven                             = @"swypeItSound7";
NSString *const kSISoundFXChaChing                                  = @"swypeItFXChaChing";
NSString *const kSISoundFXGameOver                                  = @"swypeItGameOver";
NSString *const kSISoundFXInitalize                                 = @"swypeItFXInitalize.caf";

@implementation SIConstants 

+ (SKTextureAtlas *)buttonAtlas {
    return [SKTextureAtlas atlasNamed:kSIAtlasButtons];
}
+ (SKTextureAtlas *)imagesAtlas {
    return [SKTextureAtlas atlasNamed:kSIAtlasImages];
}
+ (SKTextureAtlas *)shapesAtlas {
    return [SKTextureAtlas atlasNamed:kSIAtlasShapes];
}
@end

