//  SIConstants.h
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//
#import "SIConstants.h"

SKTexture *monkeyFaceTexture() {
    return [[SIConstants buttonAtlas] textureNamed:kSIImageFallingMonkeys];
}

SKLabelNode *moveCommandLabelNode() {
    SKLabelNode *label;
    label                                                                       = [SKLabelNode labelNodeWithFontNamed:kSISFFontDisplayHeavy];
    label.fontColor                                                             = [SKColor whiteColor];
    label.userInteractionEnabled                                                = YES;
    label.name                                                                  = kSINodeGameMoveCommand;
    label.horizontalAlignmentMode                                               = SKLabelHorizontalAlignmentModeCenter;
    label.verticalAlignmentMode                                                 = SKLabelVerticalAlignmentModeCenter;
    return label;
}

HLRingNode *sceneGamePauseRingNode() {
    HLRingNode *ringNode;
    
    /*First Button - Play*/
    HLItemNode *playButtonNode                                                  = [[HLItemNode alloc] init];
    [playButtonNode setContent:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonPlay] size:[SIConstants powerUpToolbarButtonSize]]];
    
    /*Second Button - SoundFX*/
    HLItemContentFrontHighlightNode *soundFXNode                                = [[HLItemContentFrontHighlightNode alloc] initWithContentNode:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonSoundOnFX] size:[SIConstants powerUpToolbarButtonSize]]
                                                                                                    frontHighlightNode:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonCross] size:[SIConstants powerUpToolbarButtonSize]]];
    
    /*Third Button - Sound Background*/
    HLItemContentFrontHighlightNode *soundBkgrndNode                            = [[HLItemContentFrontHighlightNode alloc] initWithContentNode:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonSoundOnBackground] size:[SIConstants powerUpToolbarButtonSize]]
                                                                                                    frontHighlightNode:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonCross] size:[SIConstants powerUpToolbarButtonSize]]];
    
    /*First Button - Play*/
    HLItemNode *endGameButton                                                   = [[HLItemNode alloc] init];
    [endGameButton setContent:[SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageButtonEndGame] size:[SIConstants powerUpToolbarButtonSize]]];
    

    NSArray *arrayOfRingItems                                                   = @[playButtonNode, soundFXNode, soundBkgrndNode,endGameButton];
    ringNode                                                                    = [[HLRingNode alloc] initWithItemCount:(int)[arrayOfRingItems count]];
    [ringNode setContent:arrayOfRingItems];
    [ringNode setLayoutWithRadius:[SIConstants powerUpToolbarButtonSize].width initialTheta:M_PI];

    
    return ringNode;
}

SKSpriteNode *coinNodeLargeFront() {
    SKSpriteNode *coinNode;
    
    CGSize coinSize                         = CGSizeMake(SCREEN_WIDTH / 8.0f, SCREEN_WIDTH / 8.0f);
    
    coinNode                                = [SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageCoinLargeFront] size:coinSize];
    coinNode.anchorPoint                    = CGPointMake(0.5f, 0.5f);
    coinNode.physicsBody                    = [SKPhysicsBody bodyWithCircleOfRadius:coinSize.height/2.0f];
    coinNode.physicsBody.collisionBitMask   = 0;
    coinNode.physicsBody.linearDamping      = 0.0f;
    
    return coinNode;
}



#pragma mark - Images
NSString *const kSIImageTitleLabel                                              = @"textLabelTitle";

#pragma mark - Swype It Move Commands
NSString *const kSIMoveCommandSwype                                             = @"Swype It";
NSString *const kSIMoveCommandTap                                               = @"Tap It";
NSString *const kSIMoveCommandPinch                                             = @"Pinch It";
NSString *const kSIMoveCommandShake                                             = @"Shake It";

#pragma mark - Game Modes
NSString *const kSIGameModeTwoHand                                              = @"gameModeTwoHand";
NSString *const kSIGameModeOneHand                                              = @"gameModeOneHand";

#pragma mark - NSUserDefaults
NSString *const kSINSUserDefaultNumberConsecutiveAppLaunches                    = @"numberConsecutiveAppLaunches";
NSString *const kSINSUserDefaultFirstLaunch                                     = @"firstLaunch";
NSString *const kSINSUserDefaultLastLaunchDate                                  = @"lastLaunchDate";
NSString *const kSINSUserDefaultLastPrizeAwardedDate                            = @"lastPrizeAwardedDate";
NSString *const kSINSUserDefaultLifetimeHighScore                               = @"lifetimeHighScore";
NSString *const kSINSUserDefaultLifetimeGamesPlayed                             = @"lifetimeGamesPlayed";
NSString *const kSINSUserDefaultLifetimePointsEarned                            = @"lifetimePointsEarned";
NSString *const kSINSUserDefaultGameMode                                        = @"gameMode";
NSString *const kSINSUserDefaultPremiumUser                                     = @"proUser";
NSString *const kSINSUserDefaultPointsTowardsFreeCoin                           = @"pointsTowardsFreeCoin";
NSString *const kSINSUserDefaultPowerUpReadyFallingMonkeys                      = @"powerUpReadyTimeFallingMonkeys";
NSString *const kSINSUserDefaultPowerUpReadyRapidFire                           = @"powerUpReadyRapidFire";
NSString *const kSINSUserDefaultPowerUpReadyTimeFreeze                          = @"powerUpReadyTimeFreeze";
NSString *const kSINSUserDefaultNumberOfMonkeys                                 = @"numberOfMonkeys";
NSString *const kSINSUserDefaultSoundIsAllowedBackground                        = @"backgroundSoundIsAllowed";
NSString *const kSINSUserDefaultSoundIsAllowedFX                                = @"fXSoundIsAllowed";

#pragma mark - Power Ups
NSString *const kSIPowerUpTypeFallingMonkeys                                    = @"Falling Monkeys";
NSString *const kSIPowerUpTypeNone                                              = @"None";
NSString *const kSIPowerUpTypeTimeFreeze                                        = @"Time Freeze";
NSString *const kSIPowerUpTypeRapidFire                                         = @"Rapid Fire";

#pragma mark - Achievements
NSString *const kSIAchievementIDChallengeBeginner1                              = @"challengeBeginner1";
NSString *const kSIAchievementIDChallengeBeginner2                              = @"challengeBeginner2";
NSString *const kSIAchievementIDChallengeBeginner3                              = @"challengeBeginner3";
NSString *const kSIAchievementIDChallengeBeginnerAll                            = @"challengeBeginnerAll";
NSString *const kSIAchievementIDChallengeIntermediate1                          = @"challengeIntermediate1";
NSString *const kSIAchievementIDChallengeIntermediate2                          = @"challengeIntermediate2";
NSString *const kSIAchievementIDChallengeIntermediate3                          = @"challengeIntermediate3";
NSString *const kSIAchievementIDChallengeIntermediateAll                        = @"challengeIntermediateAll";
NSString *const kSIAchievementIDChallengePro1                                   = @"challengePro1";
NSString *const kSIAchievementIDChallengePro2                                   = @"challengePro2";
NSString *const kSIAchievementIDChallengePro3                                   = @"challengePro3";
NSString *const kSIAchievementIDChallengeProAll                                 = @"challengeProAll";
NSString *const kSIAchievementIDChallengeMaster1                                = @"challengeMaster1";
NSString *const kSIAchievementIDChallengeMaster2                                = @"challengeMaster2";
NSString *const kSIAchievementIDChallengeMaster3                                = @"challengeMaster3";
NSString *const kSIAchievementIDChallengeMasterAll                              = @"challengeMasterAll";
NSString *const kSIAchievementPlistPathForResource                              = @"SIAchievements";
NSString *const kSIAchievementPlistType                                         = @"plist";


#pragma mark - NSNotification
NSString *const kSINotificationAdActionShouldBegin                              = @"com.pushtheworldllc.swipeit.adActionShouldBegin";
NSString *const kSINotificationAdActionDidFinish                                = @"com.pushtheworldllc.swipeit.adActionDidFinish";
NSString *const kSINotificationAdBannerDidLoad                                  = @"com.pushtheworldllc.swipeit.adBannerDidLoad";
NSString *const kSINotificationAdBannerDidUnload                                = @"com.pushtheworldllc.swipeit.adBannerDidUnload";
NSString *const kSINotificationAdBannerHide                                     = @"com.pushtheworldllc.swipeit.adBannerHide";
NSString *const kSINotificationAdBannerShow                                     = @"com.pushtheworldllc.swipeit.adBannerShow";
NSString *const kSINotificationAdFreePurchasedFailed                            = @"com.pushtheworldllc.swipeit.adFreePurchasedFailed";
NSString *const kSINotificationAdFreePurchasedSucceded                          = @"com.pushtheworldllc.swipeit.adFreePurchasedSucceded";
NSString *const kSINotificationInterstitialAdFinish                             = @"com.pushtheworldllc.swipeit.interstitiialAdDidFinish";
NSString *const kSINotificationInterstitialAdShallLaunch                        = @"com.pushtheworldllc.swipeit.interstitiialAdShallLaunch";
NSString *const kSINotificationFreeCoinEarned                                   = @"com.pushtheworldllc.swipeit.freeCoinEarned";
NSString *const kSINotificationCorrectMove                                      = @"com.pushtheworldllc.swipeit.correctMove";
NSString *const kSINotificationHudHide                                          = @"com.pushtheworldllc.swipeit.hudHide";
NSString *const kSINotificationHudShow                                          = @"com.pushtheworldllc.swipeit.hudShow";
NSString *const kSINotificationGameContinueUseAD                                = @"com.pushtheworldllc.swipeit.gameContinueUseAD";
NSString *const kSINotificationGameContinueUseCancel                            = @"com.pushtheworldllc.swipeit.gameContinueUseCancel";
NSString *const kSINotificationGameContinueUseCoins                             = @"com.pushtheworldllc.swipeit.gameContinueUseCoins";
NSString *const kSINotificationGameContinueUseLaunchStore                       = @"com.pushtheworldllc.swipeit.gameContinueUseLaunchStore";
NSString *const kSINotificationGameContinueUsePopup                             = @"com.pushtheworldllc.swipeit.gameContinueUsePopup";
NSString *const kSINotificationGameEnded                                        = @"com.pushtheworldllc.swipeit.gameEnded";
NSString *const kSINotificationGameResumed                                      = @"com.pushtheworldllc.swipeit.gameResumed";
NSString *const kSINotificationGameStarted                                      = @"com.pushtheworldllc.swipeit.gameStarted";
NSString *const kSINotificationLevelDidChange                                   = @"com.pushtheworldllc.swipeit.levelDidChange";
NSString *const kSINotificationMenuLoaded                                       = @"com.pushtheworldllc.swipeit.menuLoaded";
NSString *const kSINotificationNewBackgroundReady                               = @"com.pushtheworldllc.swipeit.newBackgroundReady";
NSString *const kSINotificationNewHighScore                                     = @"com.pushtheworldllc.swipeit.newHighScore";
NSString *const kSINotificationPackPurchaseRequest                              = @"com.pushtheworldllc.swipeit.purchasePack";
NSString *const kSINotificationPowerUpActive                                    = @"com.pushtheworldllc.swipeit.powerUpActive";
NSString *const kSINotificationPowerUpDeactivated                               = @"com.pushtheworldllc.swipeit.powerUpDeactivated";
NSString *const kSINotificationSettingsLaunchBugReport                          = @"com.pushtheworldllc.swipeit.settingsLaunchBugReport";
NSString *const kSINotificationScoreUpdate                                      = @"com.pushtheworldllc.swipeit.scoreUpdate";
NSString *const kSINotificationShowAlert                                        = @"com.pushtheworldllc.swipeit.showAlert";
NSString *const kSINotificationShowLeaderBoard                                  = @"com.pushtheworldllc.swipeit.showLeaderBoard";

#pragma mark - Score Constants
NSString *const kSIScoreTotalScore                                              = @"totalScore";
NSString *const kSIScoreNextMove                                                = @"nextMove";

#pragma mark - Images
NSString *const kSIImageBackgroundDiamondPlate                                  = @"diamondPlate";
NSString *const kSIImageBackgroundPalmTreeBendLargeLeft                         = @"palmTreeNormal";
NSString *const kSIImageBackgroundPalmTreeBendLargeRight                        = @"palmTreeFlipped";
NSString *const kSIImageBackgroundPalmTreeBendSmallLeft                         = @"palmTreeLeftBend";
NSString *const kSIImageBackgroundPalmTreeBendSmallRight                        = @"palmTreeRightBend";
NSString *const kSIImageButtonContinue                                          = @"continueButton";
NSString *const kSIImageButtonContinueGrayed                                    = @"continueGrayedButton";
NSString *const kSIImageButtonCross                                             = @"cross";
NSString *const kSIImageButtonDismiss                                           = @"dismissButton";
NSString *const kSIImageButtonDone                                              = @"doneButton";
NSString *const kSIImageButtonEndGame                                           = @"endGame";
NSString *const kSIImageButtonFallingMonkey                                     = @"monkeyFace";
NSString *const kSIImageButtonGameModeOneHand                                   = @"oneHandRevB";
NSString *const kSIImageButtonGameModeTwoHand                                   = @"twoHandRevB";
NSString *const kSIImageButtonInstructions                                      = @"instructionsIcon";
NSString *const kSIImageButtonLeaderboard                                       = @"leaderboardButton";
NSString *const kSIImageButtonMenu                                              = @"menuButton";
NSString *const kSIImageButtonNoAd                                              = @"noAdsButton";
NSString *const kSIImageButtonPause                                             = @"pauseButtonRevB";
NSString *const kSIImageButtonPlay                                              = @"playButtonRevB";
NSString *const kSIImageButtonRapidFire                                         = @"rapidFireRevB";
NSString *const kSIImageButtonReplay                                            = @"replayButton";
NSString *const kSIImageButtonSettings                                          = @"settings";
NSString *const kSIImageButtonSoundOffBackground                                = @"soundBackgroundOff";
NSString *const kSIImageButtonSoundOffFX                                        = @"soundFXOff";
NSString *const kSIImageButtonSoundOnBackground                                 = @"soundBackgroundOn";
NSString *const kSIImageButtonSoundOnFX                                         = @"soundFXOn";
NSString *const kSIImageButtonStore                                             = @"storeButton";
NSString *const kSIImageButtonTimeFreeze                                        = @"clock";
NSString *const kSIImageCoinLargeBack                                           = @"coinLargeBack";
NSString *const kSIImageCoinLargeFront                                          = @"coinLargeFront";
NSString *const kSIImageCoinSmallBack                                           = @"coinSmallBack";
NSString *const kSIImageCoinSmallFront                                          = @"coinSmallFront";
NSString *const kSIImageFallingMonkeys                                          = @"monkeyFace";
NSString *const kSIImageGift                                                    = @"gift";
NSString *const kSIImageIAPSmall                                                = @"coinPile";
NSString *const kSIImageIAPMedium                                               = @"coinBucket";
NSString *const kSIImageIAPLarge                                                = @"coinBag";
NSString *const kSIImageIAPExtraLarge                                           = @"coinChest";
NSString *const kSIImageProgressBarFillMove                                     = @"progressBarFillMove";
NSString *const kSIImageProgressBarFillPowerUp                                  = @"progressBarFillPowerUp";
NSString *const kSIImageShapePowerupCost                                        = @"powerupCost";
NSString *const kSIImageTapToPlayText                                           = @"tapTpPlay";

#pragma mark - Texture Atlas
NSString *const kSIAtlasBackground                                              = @"background";
NSString *const kSIAtlasButtons                                                 = @"buttons";
NSString *const kSIAtlasImages                                                  = @"images";
NSString *const kSIAtlasSceneMenu                                               = @"sceneMenu";
NSString *const kSIAtlasShapes                                                  = @"shapes";

#pragma mark - Images in Atlas 
NSString *const kSIAtlasSceneMenuAchievements                                   = @"achievementsRevA";
NSString *const kSIAtlasSceneMenuAdFree                                         = @"adFreeRevB";
NSString *const kSIAtlasSceneMenuBackButton                                     = @"backButton";
NSString *const kSIAtlasSceneMenuHelp                                           = @"helpRevB";
NSString *const kSIAtlasSceneMenuLeaderboard                                    = @"leaderboardRevB";
NSString *const kSIAtlasSceneMenuPlayClassic                                    = @"playClassic";
NSString *const kSIAtlasSceneMenuPlayOneHand                                    = @"playOneHand";
NSString *const kSIAtlasSceneMenuShareFacebook                                  = @"shareFacebook";
NSString *const kSIAtlasSceneMenuShareTwitter                                   = @"shareTwitter";
NSString *const kSIAtlasSceneMenuShop                                           = @"shopRevA";
NSString *const kSIAtlasSceneMenuSettings                                       = @"settingsRevB";
NSString *const kSIAtlasSceneMenuSoundBackground                                = @"startBackgroundSound";
NSString *const kSIAtlasSceneMenuSoundFX                                        = @"startFXSound";


#pragma mark - Button Labels
NSString *const kSIButtonLabelStringOneHand                                     = @"One Hand";
NSString *const kSIButtonLabelStringTwoHand                                     = @"Two Hand";

#pragma mark - NSDictionary Keys
NSString *const kSINSDictionaryKeyCanAfford                                     = @"canAfford";
NSString *const kSINSDictionaryKeyCanAffordCost                                 = @"canAffordCost";
NSString *const kSINSDictionaryKeyHudHoldDismissForDuration                     = @"HudWillHoldDismissForDuration";
NSString *const kSINSDictionaryKeyHudMessageDismissTitle                        = @"HudDismissMessageTitle";
NSString *const kSINSDictionaryKeyHudMessageDismissInfo                         = @"HudDismissMessageInfo";
NSString *const kSINSDictionaryKeyHudMessagePresentTitle                        = @"HudPresentMessageTitle";
NSString *const kSINSDictionaryKeyHudMessagePresentInfo                         = @"HudPresentMessageInfo";
NSString *const kSINSDictionaryKeyHudWillAnimate                                = @"hudWillAnimate";
NSString *const kSINSDictionaryKeyHudWillDimBackground                          = @"hudWillAnimate";
NSString *const kSINSDictionaryKeyHudWillShowCheckmark                          = @"HudWillDimBackground";
NSString *const kSINSDictionaryKeyMoveScore                                     = @"moveScore";
NSString *const kSINSDictionaryKeyPowerUp                                       = @"powerUp";
NSString *const kSINSDictionaryKeyPackProduct                                   = @"packProduct";
NSString *const kSINSDictionaryKeyPayToContinueMethod                           = @"payToContinue";
NSString *const kSINSDictionaryKeySIAchievementPlistAmount                      = @"amount";
NSString *const kSINSDictionaryKeySIAchievementPlistLevelsDictionary            = @"levelsDictionary";
NSString *const kSINSDictionaryKeySIAchievementPlistCompletedBool               = @"completed";
NSString *const kSINSDictionaryKeySIAchievementPlistHelpString                  = @"help";
NSString *const kSINSDictionaryKeySIAchievementPlistLevel1                      = @"level1";
NSString *const kSINSDictionaryKeySIAchievementPlistLevel2                      = @"level2";
NSString *const kSINSDictionaryKeySIAchievementPlistLevel3                      = @"level3";
NSString *const kSINSDictionaryKeySIAchievementPlistMoveSequenceArray           = @"moveSequence";
NSString *const kSINSDictionaryKeySIAchievementPlistPostfixString               = @"postfix";
NSString *const kSINSDictionaryKeySIAchievementPlistPrefixString                = @"prefix";
NSString *const kSINSDictionaryKeySIAchievementPlistReward                      = @"reward";
NSString *const kSINSDictionaryKeySIAchievementPlistTypeString                  = @"type";


#pragma mark - Plist
NSString *const kSIPlistMoveCommandPinch                                        = @"pinch";
NSString *const kSIPlistMoveCommandShake                                        = @"shake";
NSString *const kSIPlistMoveCommandStop                                         = @"stop";
NSString *const kSIPlistMoveCommandSwype                                        = @"swype";
NSString *const kSIPlistMoveCommandTap                                          = @"tap";
NSString *const kSIPlistTypeAll                                                 = @"all";
NSString *const kSIPlistTypeMove                                                = @"move";
NSString *const kSIPlistTypeMoveSequence                                        = @"moveSequence";
NSString *const kSIPlistTypeScore                                               = @"score";


#pragma mark - In App Purchase Product ID
NSString *const kSIIAPProductIDAdFree                                           = @"swypeItInAppPurchases";
NSString *const kSIIAPProductIDCoinPackSmall                                    = @"com.pushtheworldllc.swipeit.dev.swypeItSmallPack";
NSString *const kSIIAPProductIDCoinPackMedium                                   = @"com.pushtheworldllc.swipeit.dev.swypeItMediumPack";
NSString *const kSIIAPProductIDCoinPackLarge                                    = @"com.pushtheworldllc.swipeit.dev.swypeItLargePack";
NSString *const kSIIAPProductIDCoinPackExtraLarge                               = @"com.pushtheworldllc.swipeit.dev.swypeItExtraLargePack";

#pragma mark - In App Purchase Consumable ID
NSString *const kSIIAPConsumableIDCoins                                         = @"ITCoins";

#pragma mark - In App Purchase Pack Names
NSString *const kSIIAPPackNameSmall                                             = @"Pile";
NSString *const kSIIAPPackNameMedium                                            = @"Bucket";
NSString *const kSIIAPPackNameLarge                                             = @"Bag";
NSString *const kSIIAPPackNameExtraLarge                                        = @"Chest";

#pragma mark - Node Names
NSString *const kSINodeAdBannerNode                                             = @"adBannerNode";
NSString *const kSINodeButtonAchievement                                        = @"achievementButton";
NSString *const kSINodeButtonBack                                               = @"backButtonNode";
NSString *const kSINodeButtonContinue                                           = @"continueButton";
NSString *const kSINodeButtonDone                                               = @"doneButton";
NSString *const kSINodeButtonFallingMonkey                                      = @"fallingMonkeyButton";
NSString *const kSINodeButtonInstructions                                       = @"instructionsButton";
NSString *const kSINodeButtonLeaderBoard                                        = @"leaderBoardButton";
NSString *const kSINodeButtonMenu                                               = @"menuButton";
NSString *const kSINodeButtonNoAd                                               = @"noAdButton";
NSString *const kSINodeButtonOneHand                                            = @"oneHand";
NSString *const kSINodeButtonPause                                              = @"pause";
NSString *const kSINodeButtonPlay                                               = @"play";
NSString *const kSINodeButtonRapidFire                                          = @"rapidFire";
NSString *const kSINodeButtonReplay                                             = @"replay";
NSString *const kSINodeButtonSettings                                           = @"settings";
NSString *const kSINodeButtonStore                                              = @"store";
NSString *const kSINodeButtonTwoHand                                            = @"twoHand";
NSString *const kSINodeButtonTimeFreeze                                         = @"timeFreeze";
NSString *const kSINodeEmitterFire                                              = @"fireEmitterNode";
NSString *const kSINodeEmitterSnow                                              = @"snowEmitterNode";
NSString *const kSINodeFallingMonkey                                            = @"fallingMonkey";
NSString *const kSINodeGameMoveCommand                                          = @"moveCommand";
NSString *const kSINodeGameProgressBarMove                                      = @"progressBarMove";
NSString *const kSINodeGameScoreTotal                                           = @"scoreTotal";
NSString *const kSINodeLabelDescriptionChest                                    = @"chestOfCoinsLabelDescription";
NSString *const kSINodeLabelDescriptionBag                                      = @"bagOfCoinsLabelDescription";
NSString *const kSINodeLabelDescriptionBucket                                   = @"bucketOfCoinsLabelDescription";
NSString *const kSINodeLabelDescriptionPile                                     = @"pileOfCoinsLabelDescription";
NSString *const kSINodeLabelPriceChest                                          = @"chestOfCoinsLabelPrice";
NSString *const kSINodeLabelPriceBag                                            = @"bagOfCoinsLabelPrice";
NSString *const kSINodeLabelPriceBucket                                         = @"bucketOfCoinsLabelPrice";
NSString *const kSINodeLabelPricePile                                           = @"pileOfCoinsLabelPrice";
NSString *const kSINodeNodeChest                                                = @"chestOfCoinsNode";
NSString *const kSINodeNodeBag                                                  = @"bagOfCoinsNode";
NSString *const kSINodeNodeBucket                                               = @"bucketOfCoinsNode";
NSString *const kSINodeNodePile                                                 = @"pileOfCoinsNode";
NSString *const kSINodePopupContent                                             = @"content";
NSString *const kSINodePopupTitle                                               = @"title";

#pragma mark - San Fran Fonts
NSString *const kSISFFontDisplayLight                                           = @"SFUIDisplay-Light";
NSString *const kSISFFontDisplayHeavy                                           = @"SFUIDisplay-Heavy";
NSString *const kSISFFontDisplayRegular                                         = @"SFUIDisplay-Regular";
NSString *const kSISFFontDisplayMedium                                          = @"SFUIDisplay-Medium";
NSString *const kSISFFontDisplayBold                                            = @"SFUIDisplay-Bold";
NSString *const kSISFFontDisplayBlack                                           = @"SFUIDisplay-Black";
NSString *const kSISFFontDisplayUltralight                                      = @"SFUIDisplay-Ultralight";
NSString *const kSISFFontDisplayThin                                            = @"SFUIDisplay-Thin";
NSString *const kSISFFontDisplaySemibold                                        = @"SFUIDisplay-Semibold";
NSString *const kSISFFontTextLightItalic                                        = @"SFUIText-LightItalic";
NSString *const kSISFFontTextHeavyItalic                                        = @"SFUIText-HeavyItalic";
NSString *const kSISFFontTextBold                                               = @"SFUIText-Bold";
NSString *const kSISFFontTextRegular                                            = @"SFUIText-Regular";
NSString *const kSISFFontTextItalic                                             = @"SFUIText-Italic";
NSString *const kSISFFontTextLight                                              = @"SFUIText-Light";
NSString *const kSISFFontTextMediumItalic                                       = @"SFUIText-MediumItalic";
NSString *const kSISFFontTextSemibold                                           = @"SFUIText-Semibold";
NSString *const kSISFFontTextBoldItalic                                         = @"SFUIText-BoldItalic";
NSString *const kSISFFontTextSemiboldItalic                                     = @"SFUIText-SemiboldItalic";
NSString *const kSISFFontTextMedium                                             = @"SFUIText-Medium";
NSString *const kSISFFontTextHeavy                                              = @"SFUIText-Heavy";


#pragma mark - Menu Button Texts
NSString *const kSIMenuTextBack                                                 = @"Back";
NSString *const kSIMenuTextEndGameContinue                                      = @"Continue?";
NSString *const kSIMenuTextEndGameReplay                                        = @"Replay";
NSString *const kSIMenuTextEndGameStore                                         = @"IT Store";
NSString *const kSIMenuTextEndGameMainMenu                                      = @"Main Menu";
NSString *const kSIMenuTextPopUpBuyCoins                                        = @"Buy Coins!";
NSString *const kSIMenuTextPopUpEndGame                                         = @"End Game";
NSString *const kSIMenuTextPopUpWatchAd                                         = @"Watch Ad";
NSString *const kSIMenuTextSettingsBugReport                                    = @"Report Bug";
NSString *const kSIMenuTextSettingsResetHighScore                               = @"Reset High Score";
NSString *const kSIMenuTextSettingsRestorePurchases                             = @"Restore Purchases";
NSString *const kSIMenuTextSettingsToggleSoundOffBackground                     = @"Turn Music Off";
NSString *const kSIMenuTextSettingsToggleSoundOffFX                             = @"Turn Sound FX Off";
NSString *const kSIMenuTextSettingsToggleSoundOnBackground                      = @"Turn Music On";
NSString *const kSIMenuTextSettingsToggleSoundOnFX                              = @"Turn Sound FX On";
NSString *const kSIMenuTextStartScreenOneHand                                   = @"Play One Hand";
NSString *const kSIMenuTextStartScreenTwoHand                                   = @"Play Original";
NSString *const kSIMenuTextStartScreenSettings                                  = @"Settings";
NSString *const kSIMenuTextStartScreenStore                                     = @"Store";

#pragma mark - Emails
NSString *const kSIEmailBugReportReciever                                       = @"buggy.bug@pushtheworld.us";

#pragma mark - Sounds
NSString *const kSISoundBackgroundMenu                                          = @"menuSound";
NSString *const kSISoundBackgroundOne                                           = @"swypeItSound1";
NSString *const kSISoundBackgroundTwo                                           = @"swypeItSound2";
NSString *const kSISoundBackgroundThree                                         = @"swypeItSound3";
NSString *const kSISoundBackgroundFour                                          = @"swypeItSound4";
NSString *const kSISoundBackgroundFive                                          = @"swypeItSound5";
NSString *const kSISoundBackgroundSix                                           = @"swypeItSound6";
NSString *const kSISoundBackgroundSeven                                         = @"swypeItSound7";
NSString *const kSISoundFXCoinNoise                                             = @"coinNoise";
NSString *const kSISoundFXChaChing                                              = @"swypeItFXChaChing";
NSString *const kSISoundFXGameOver                                              = @"swypeItGameOver";
NSString *const kSISoundFXInitalize                                             = @"swypeItFXInitalize";
NSString *const kSISoundFXMoveTap                                               = @"tapNoise";
NSString *const kSISoundFXMoveSwype                                             = @"swypeNoise";
NSString *const kSISoundFXSceneWoosh                                            = @"wooshNoise";

#pragma mark - EmitterNodes
NSString *const kSIEmitterFileTypeSKS                                           = @"sks";
NSString *const kSIEmitterExplosionTouch                                        = @"explosionTouch";
NSString *const kSIEmitterFireProgressBarPowerUp                                = @"rapidFireRevA";
NSString *const kSIEmitterSpark                                                 = @"sparkRevA";
NSString *const kSIEmitterSnowTimeFreeze                                        = @"snowTimeFreezeRevA";

#pragma mark - Game Center Leaderboard IDs
NSString *const kSIGameCenterLeaderBoardIDHandOne                               = @"oneHandGHS";
NSString *const kSIGameCenterLeaderBoardIDHandTwo                               = @"GHS";

#pragma mark - Encode/Decode
NSString *const kEDDirectoryAchievements                                        = @"achievements";
NSString *const kEDTypeArchive                                                  = @"archive";

#pragma mark - Encode/Decode Keys
NSString *const kEDKeyAchievementCurrentAmount                                  = @"currentAmount";
NSString *const kEDKeyAchievementCurrentIndexOfMoveSequenceCommand              = @"currentIndexOfMove";
NSString *const kEDKeyAchievementCurrentLevel                                   = @"currentLevel";
NSString *const kEDKeyAchievementCurrentLevels                                  = @"levelDictionary";
NSString *const kEDKeyAchievementCurrentSequence                                = @"currentSequence";
NSString *const kEDKeyAchievementDetails                                        = @"details";
NSString *const kEDKeyAchievementDetailsCompleted                               = @"compeleted";
NSString *const kEDKeyAchievementDetailsDictionaryKey                           = @"dictionaryKey";
NSString *const kEDKeyAchievementDetailsHelpString                              = @"helpStringer";
NSString *const kEDKeyAchievementDetailsMoveSequenceArray                       = @"moveSequenceArray";
NSString *const kEDKeyAchievementDetailsPercentComplete                         = @"percentComplete";
NSString *const kEDKeyAchievementDetailsPrefixString                            = @"prefixString";
NSString *const kEDKeyAchievementDetailsPostfixString                           = @"postfixString";
NSString *const kEDKeyAchievementDetailsType                                    = @"type";

#pragma mark - State Machine
NSString *const kSITKStateMachineStateGameEnd                                   = @"end";
NSString *const kSITKStateMachineStateGameFallingMonkey                         = @"fallingMonkey";
NSString *const kSITKStateMachineStateGameIdle                                  = @"idle";
NSString *const kSITKStateMachineStateGamePause                                 = @"pause";
NSString *const kSITKStateMachineStateGamePayingForContinue                     = @"payingForContinue";
NSString *const kSITKStateMachineStateGamePopupContinue                         = @"popupContinue";
NSString *const kSITKStateMachineStateGameProcessingMove                        = @"processingMove";
NSString *const kSITKStateMachineStateGameStart                                 = @"start";
NSString *const kSITKStateMachineStateTimerPaused                               = @"timerPaused";
NSString *const kSITKStateMachineStateTimerRunning                              = @"timerRunning";
NSString *const kSITKStateMachineStateTimerStopped                              = @"timerStopped";

#pragma mark - State Machine Events
NSString *const kSITKStateMachineEventGameEndGame                               = @"endGame";
NSString *const kSITKStateMachineEventGameFallingMonkeyEnd                      = @"fallingMonkeyEnd";
NSString *const kSITKStateMachineEventGameFallingMonkeyStart                    = @"fallingMonkeyStart";
NSString *const kSITKStateMachineEventGameMoveEntered                           = @"moveEntered";
NSString *const kSITKStateMachineEventGamePause                                 = @"pauseEvent";
NSString *const kSITKStateMachineEventGamePayForContinue                        = @"payForContinue";
NSString *const kSITKStateMachineEventGameStartGame                             = @"startGame";
NSString *const kSITKStateMachineEventGameWaitForMove                           = @"waitForMove";
NSString *const kSITKStateMachineEventGameWrongMoveEntered                      = @"wrongMoveEntered";
NSString *const kSITKStateMachineEventTimerPause                                = @"timerPause";
NSString *const kSITKStateMachineEventTimerResume                               = @"timerResume";
NSString *const kSITKStateMachineEventTimerStart                                = @"timerStart";
NSString *const kSITKStateMachineEventTimerStop                                 = @"timerStop";
NSString *const kSITKStateMachineEventTimerStopCriticalFailure                  = @"timerStopCriticalFailure";

#pragma mark - Useful things
@implementation SIConstants
+ (CGSize)powerUpToolbarButtonSize {
    return CGSizeMake(SCREEN_WIDTH/8.0, SCREEN_WIDTH/8.0f);
}
+ (NSArray *)userMessageHighScore {
    return @[@"You did it!",
             @"Can you beat that?",
             @"You're Awesome! 👍",
             @"Siri is pumped!"];
}
+ (NSArray *)userMessageHighScoreClose {
    return @[@"Use Power Ups!",
             @"Buy IT Coins!",
             @"Nooo! You had it!",
             @"So Close!!!"];
}
+ (NSArray *)userMessageHighScoreMedian {
    return @[@"🙅 NO HIGH SCORE!",
             @"You Can Do Better",
             @"You're The Best 😊",
             @"Try Again",
             @"Swype Faster",
             @"You Are Awesome 😊",
             @"😭 Game over 😭"];
}
+ (NSArray *)userMessageHighScoreBad {
    return @[@"Are you even trying?",
             @"Um... try again",
             @"Ohhhh no"];
}
+ (NSString *)pathForSparkEmitter {
    return [[NSBundle mainBundle] pathForResource:kSIEmitterSpark ofType:kSIEmitterFileTypeSKS];
}
+ (NSString *)pathForTouchExplosionEmitter {
    return [[NSBundle mainBundle] pathForResource:kSIEmitterExplosionTouch ofType:kSIEmitterFileTypeSKS];
}
+ (SKTextureAtlas *)atlasSceneMenu {
    return [SKTextureAtlas atlasNamed:kSIAtlasSceneMenu];
}
+ (SKTextureAtlas *)backgroundAtlas {
    return [SKTextureAtlas atlasNamed:kSIAtlasBackground];
}
+ (SKTextureAtlas *)buttonAtlas {
    return [SKTextureAtlas atlasNamed:kSIAtlasButtons];
}
+ (SKTextureAtlas *)imagesAtlas {
    return [SKTextureAtlas atlasNamed:kSIAtlasImages];
}
+ (SKTextureAtlas *)shapesAtlas {
    return [SKTextureAtlas atlasNamed:kSIAtlasShapes];
}
+ (BOOL)isFXAllowed {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSINSUserDefaultSoundIsAllowedFX];
}
+ (BOOL)isBackgroundSoundAllowed {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSINSUserDefaultSoundIsAllowedBackground];
}



@end

