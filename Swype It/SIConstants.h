//  SIConstants.h
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "HLSpriteKit.h"

#define IDIOM                               UI_USER_INTERFACE_IDIOM()
#define IPAD                                UIUserInterfaceIdiomPad

#define LEVEL1                              100
#define LEVEL2                              250
#define LEVEL3                              500
#define LEVEL4                              750
#define LEVEL5                              1000
#define LEVEL6                              1300
#define LEVEL7                              1600
#define LEVEL8                              2000
#define LEVEL9                              2400
#define LEVEL10                             2800
#define LEVEL11                             3300
#define LEVEL12                             3800
#define LEVEL13                             4400
#define LEVEL14                             5000
#define LEVEL15                             5700
#define LEVEL16                             6400
#define LEVEL17                             7200
#define LEVEL18                             8000
#define LEVEL19                             8900
#define LEVEL20                             10000
#define LEVEL21                             11000
#define LEVEL22                             12000

#define SOUNDLEVEL1                         100
#define SOUNDLEVEL2                         200
#define SOUNDLEVEL3                         300
#define SOUNDLEVEL4                         400
#define SOUNDLEVEL5                         500
#define SOUNDLEVEL6                         600
#define SOUNDLEVEL7                         700

#define VERTICAL_SPACING_4                  4
#define VERTICAL_SPACING_8                  8
#define VERTICAL_SPACING_16                 16

#define IS_IPHONE_4                         (MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width) == 480.0)
#define IS_IPHONE_5                         (MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width) == 568.0)
#define IS_IPHONE_6                         (MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width) == 667.0)
#define IS_IPHONE_6_PLUS                    (MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width) == 736.0)

#define SCREEN_WIDTH                        MIN([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                       MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)

#define MILI_SECS_IN_SEC                    1000

#pragma mark - Game Constants
#define POINTS_NEEDED_FOR_FREE_COIN         500
#define mSlope                              -7/240
#define SCORE_EXP_POWER_WEIGHT              -0.001205
#define MAX_MOVE_SCORE                      10.78457
#define SPEED_TRANSISTION_SCORE             8629.55
#define TIMER_INTERVAL                      1/30
#define SPEED_LOG_INTERCEPT                 4.418243235
#define SPEED_LOG_MULTIPLIER                -0.383625766
#define SPEED_POWER_EXPONENT                -0.22291709
#define SPEED_POWER_MULTIPLIER              7.07850289
#define LEVEL_SPEED_DIV_MULT                -0.384
#define LEVEL_SPEED_INTERCEPT               4.4182
#define VALUE_OF_MONKEY                     25

#define NUMBER_OF_MOVES                     3
#define NUMBER_OF_BACKGROUNDS               3
#define NUMBER_OF_MONKEYS_INIT              15
#define NUMBER_OF_IAP_PACKS                 4

#define IAP_PACK_PRICE_SMALL                00.99
#define IAP_PACK_PRICE_MEDIUM               04.99
#define IAP_PACK_PRICE_LARGE                09.99
#define IAP_PACK_PRICE_EXTRA_LARGE          24.99

#define SCENE_TRANSISTION_DURATION_FAST     0.25
#define SCENE_TRANSISTION_DURATION_NORMAL   1.0

#define MOVE_COMMAND_LAUNCH_DURATION        0.25

#define SECONDS_IN_DAY                      60 * 60 * 24

#define ACCELEROMETER_UPDATE_INTERVAL       0.05
#define REST_COUNT_THRESHOLD                2
#define SHAKE_THRESHOLD                     0.5
#define LAUNCH_DX_VECTOR_MAX                25
#define LAUNCH_DX_VECTOR_MIX                10
#define LAUNCH_DY_MULTIPLIER                120
#define MONKEY_SPEED_INCREASE               0.08

#define FREE_COINS_PER_DAY                  5
#define EPSILON_NUMBER                      0.01
#define ACHIEVEMENT_PERCENT_PER_LEVEL       33

/**
 Creates a monkey face to be reused all over the app
 */
FOUNDATION_EXPORT SKTexture                 *monkeyFaceTexture();
/**
 The move command label that is used on the gmae
 */
FOUNDATION_EXPORT SKLabelNode               *moveCommandLabelNode();
/**
 The ring node for the pause menu
 */
FOUNDATION_EXPORT HLRingNode                *sceneGamePauseRingNode();


typedef NS_ENUM(NSInteger, SIGameControllerScene) {
    SIGameControllerSceneLoading,
    SIGameControllerSceneMenu,
    SIGameControllerSceneGame,
    SIGameControllerSceneFallingMonkey,
    SIGameControllerSceneCount
};

typedef NS_ENUM(NSInteger, SIGameMode) {
    SIGameModeOneHand,
    SIGameModeTwoHand
};
typedef NS_ENUM(NSInteger, SIMoveCommand) {
    SIMoveCommandTap,
    SIMoveCommandSwype,
    SIMoveCommandPinch,
    SIMoveCommandShake,
    SIMoveCommandFallingMonkey,
    SIMoveCommandStop
};
typedef NS_ENUM(NSInteger, SIPowerUpType) {
    SIPowerUpTypeNone,
    SIPowerUpTypeFallingMonkeys,
    SIPowerUpTypeTimeFreeze,
    SIPowerUpTypeRapidFire
};
typedef NS_ENUM(NSInteger, SIPowerUpCost) {
    SIPowerUpCostNone                       = 0,
    SIPowerUpCostTimeFreeze                 = 1,
    SIPowerUpCostRapidFire                  = 3,
    SIPowerUpCostFallingMonkeys             = 5
};

typedef NS_ENUM(NSInteger, SIPowerUpDuration) {
    SIPowerUpDurationNone                   = 0,
    SIPowerUpDurationRapidFire              = 3,
    SIPowerUpDurationTimeFreeze             = 8
};

typedef NS_ENUM(NSInteger, SIIAPNumberOfCoins) {
    SIIAPNumberOfCoinsSmall                 = 30,
    SIIAPNumberOfCoinsMedium                = 200,
    SIIAPNumberOfCoinsLarge                 = 500,
    SIIAPNumberOfCoinsExtraLarge            = 1500
};
typedef NS_ENUM(NSInteger, SIIAPPack) {
    SIIAPPackSmall,
    SIIAPPackMedium,
    SIIAPPackLarge,
    SIIAPPackExtraLarge
};
typedef NS_ENUM(NSInteger, SIMoveCommandAction) {
    SIMoveCommandActionTap,
    SIMoveCommandActionShake,
    SIMoveCommandActionPinchNegative,
    SIMoveCommandActionPinchPositive,
    SIMoveCommandActionSwypeUp,
    SIMoveCommandActionSwypeDown,
    SIMoveCommandActionSwypeLeft,
    SIMoveCommandActionSwypeRight,
    SIMoveCommandActionSwypeNone
};
typedef NS_ENUM(NSInteger, SIContinueLifeCost) {
    SIContinueLifeCost0                     = 0,
    SIContinueLifeCost1                     = 5,
    SIContinueLifeCost2                     = 10,
    SIContinueLifeCost3                     = 20,
    SIContinueLifeCost4                     = 40,
    SIContinueLifeCost5                     = 60,
    SIContinueLifeCost6                     = 100,
    SIContinueLifeCost7                     = 200,
    SIContinueLifeCost8                     = 400,
    SIContinueLifeCost9                     = 600,
    SIContinueLifeCost10                    = 800,
    SIContinueLifeCost11                    = 1000,
    SIContinueLifeCost12                    = 1250,
    SIContinueLifeCost13                    = 1500,
    SIContinueLifeCost14                    = 2000,
    SIContinueLifeCost15                    = 2500,
    SIContinueLifeCost16                    = 3000,
    SIContinueLifeCost17                    = 4000,
    SIContinueLifeCost18                    = 5000,
    SIContinueLifeCost19                    = 100000,
    SIContinueLifeCost20                    = 1000000,
    SIContinueLifeCost21                    = 10000000
};
typedef NS_ENUM(NSInteger, SIContinueAdCount) {
    SIContinueAdCount0                      = 0,
    SIContinueAdCount1                      = 1,
    SIContinueAdCount2                      = 2,
    SIContinueAdCount3                      = 4,
    SIContinueAdCount4                      = 6,
    SIContinueAdCount5                      = 8,
    SIContinueAdCount6                      = 10,
    SIContinueAdCount7                      = 14,
    SIContinueAdCount8                      = 18,
    SIContinueAdCount9                      = 26,
    SIContinueAdCount10                     = 42,
    SIContinueAdCount11                     = 84,
    SIContinueAdCount12                     = 128,
    SIContinueAdCount13                     = 256,
    SIContinueAdCount14                     = 512,
    SIContinueAdCount15                     = 1024,
    SIContinueAdCount16                     = 2048,
    SIContinueAdCount17                     = 4096,
    SIContinueAdCount18                     = 10000,
    SIContinueAdCount19                     = 100000,
    SIContinueAdCount20                     = 1000000,
    SIContinueAdCount21                     = 10000000
};
typedef NS_ENUM(NSInteger, SIProgressBar) {
    SIProgressBarMove,
    SIProgressBarPowerUp
};

typedef NS_ENUM(NSInteger, SIBackgroundSound) {
    SIBackgroundSoundMenu,
    SIBackgroundSoundOne,
    SIBackgroundSoundTwo,
    SIBackgroundSoundThree,
    SIBackgroundSoundFour,
    SIBackgroundSoundFive,
    SIBackgroundSoundSix,
    SIBackgroundSoundSeven
};

typedef NS_ENUM(NSInteger, SISceneGameRingNode) {
    SISceneGameRingNodePlay                 = 0,
    SISceneGameRingNodeSoundFX,
    SISceneGameRingNodeSoundBackground,
    SISceneGameRingNodeEndGame
};

typedef NS_ENUM(NSInteger, SIGameFreePrize) {
    SIGameFreePrizeNo                       = 0,
    SIGameFreePrizeYesConsecutive,
    SIGameFreePrizeYes
};

typedef NS_ENUM(NSInteger, SISceneGamePopupContinueMenuItem) {
    SISceneGamePopupContinueMenuItemCoin    = 0,
    SISceneGamePopupContinueMenuItemAd,
    SISceneGamePopupContinueMenuItemNo
};

typedef NS_ENUM(NSInteger, SISceneStartToolBarNode) {
    SISceneStartToolBarNodeNoAds            = 0,
    SISceneStartToolBarNodeLeaderboard,
    SISceneStartToolBarNodeSettings,
    SISceneStartToolBarNodeHelp
};

typedef NS_ENUM(NSInteger, SISceneMenuType) {
    SISceneMenuTypeStart                    = 0,
    SISceneMenuTypeEnd,
    SISceneMenuTypeChallenges
};

typedef NS_ENUM(NSInteger, SIAchievementSkillLevel) {
    SIAchievementSkillLevelBeginner         = 0,
    SIAchievementSkillLevelIntermediate,
    SIAchievementSkillLevelPro,
    SIAchievementSkillLevelMaster
};

typedef NS_ENUM(NSInteger, SIAchievementType) {
    SIAchievementTypeMove                   = 0,
    SIAchievementTypeMoveSequence,
    SIAchievementTypeScore,
    SIAchievementTypeAll
};

typedef NS_ENUM(NSInteger, SIAchievementLevel) {
    SIAchievementLevelNew                   = 0,
    SIAchievementLevelOne,
    SIAchievementLevelTwo,
    SIAchievementLevelThree,
    SIAchievementLevelDone
};

typedef NS_ENUM(NSInteger, SIAchievementMoveSequence) {
    SIAchievementMoveSequenceOne            = 0,
    SIAchievementMoveSequenceTwo,
    SIAchievementMoveSequenceThree,
    SIAchievementMoveSequenceFour,
    SIAchievementMoveSequenceDone
};

typedef NS_ENUM(NSInteger, SIAchievementArrayIndexForAchievementType) {
    SIAchievementArrayIndexForAchievementTypeLevel1 = 0,
    SIAchievementArrayIndexForAchievementTypeLevel2,
    SIAchievementArrayIndexForAchievementTypeLevel3,
    SIAchievementArrayIndexForAchievementTypeAll
};

#pragma mark - Images
extern NSString *const kSIImageTitleLabel;

#pragma mark - Swype It Move Commands
extern NSString *const kSIMoveCommandSwype;
extern NSString *const kSIMoveCommandTap;
extern NSString *const kSIMoveCommandPinch;
extern NSString *const kSIMoveCommandShake;

#pragma mark - Game Modes
extern NSString *const kSIGameModeTwoHand;
extern NSString *const kSIGameModeOneHand;

#pragma mark - NSUserDefaults
extern NSString *const kSINSUserDefaultNumberConsecutiveAppLaunches;
extern NSString *const kSINSUserDefaultFirstLaunch;
extern NSString *const kSINSUserDefaultLastLaunchDate;
extern NSString *const kSINSUserDefaultLastPrizeAwardedDate;
extern NSString *const kSINSUserDefaultLifetimeHighScore;
extern NSString *const kSINSUserDefaultLifetimeGamesPlayed;
extern NSString *const kSINSUserDefaultLifetimePointsEarned;
extern NSString *const kSINSUserDefaultGameMode;
extern NSString *const kSINSUserDefaultPremiumUser;
extern NSString *const kSINSUserDefaultPointsTowardsFreeCoin;
extern NSString *const kSINSUserDefaultPowerUpReadyFallingMonkeys;
extern NSString *const kSINSUserDefaultPowerUpReadyRapidFire;
extern NSString *const kSINSUserDefaultPowerUpReadyTimeFreeze;
extern NSString *const kSINSUserDefaultNumberOfMonkeys;
extern NSString *const kSINSUserDefaultSoundIsAllowedBackground;
extern NSString *const kSINSUserDefaultSoundIsAllowedFX;

#pragma mark - Power Ups
extern NSString *const kSIPowerUpTypeFallingMonkeys;
extern NSString *const kSIPowerUpTypeNone;
extern NSString *const kSIPowerUpTypeTimeFreeze;
extern NSString *const kSIPowerUpTypeRapidFire;

#pragma mark - Achievements
extern NSString *const kSIAchievementIDChallengeBeginner1;
extern NSString *const kSIAchievementIDChallengeBeginner2;
extern NSString *const kSIAchievementIDChallengeBeginner3;
extern NSString *const kSIAchievementIDChallengeBeginnerAll;
extern NSString *const kSIAchievementIDChallengeIntermediate1;
extern NSString *const kSIAchievementIDChallengeIntermediate2;
extern NSString *const kSIAchievementIDChallengeIntermediate3;
extern NSString *const kSIAchievementIDChallengeIntermediateAll;
extern NSString *const kSIAchievementIDChallengePro1;
extern NSString *const kSIAchievementIDChallengePro2;
extern NSString *const kSIAchievementIDChallengePro3;
extern NSString *const kSIAchievementIDChallengeProAll;
extern NSString *const kSIAchievementIDChallengeMaster1;
extern NSString *const kSIAchievementIDChallengeMaster2;
extern NSString *const kSIAchievementIDChallengeMaster3;
extern NSString *const kSIAchievementIDChallengeMasterAll;
extern NSString *const kSIAchievementPlistPathForResource;
extern NSString *const kSIAchievementPlistType;

#pragma mark - NSNotification
extern NSString *const kSINotificationAdActionShouldBegin;
extern NSString *const kSINotificationAdActionDidFinish;
extern NSString *const kSINotificationAdBannerDidLoad;
extern NSString *const kSINotificationAdBannerDidUnload;
extern NSString *const kSINotificationAdBannerHide;
extern NSString *const kSINotificationAdBannerShow;
extern NSString *const kSINotificationAdFreePurchasedFailed;
extern NSString *const kSINotificationAdFreePurchasedSucceded;
extern NSString *const kSINotificationInterstitialAdFinish;
extern NSString *const kSINotificationInterstitialAdShallLaunch;
extern NSString *const kSINotificationFreeCoinEarned;
extern NSString *const kSINotificationCorrectMove;
extern NSString *const kSINotificationHudHide;
extern NSString *const kSINotificationHudShow;
extern NSString *const kSINotificationGameContinueUseAD;
extern NSString *const kSINotificationGameContinueUseCancel;
extern NSString *const kSINotificationGameContinueUseCoins;
extern NSString *const kSINotificationGameContinueUseLaunchStore;
extern NSString *const kSINotificationGameContinueUsePopup;
extern NSString *const kSINotificationGameEnded;
extern NSString *const kSINotificationGameResumed;
extern NSString *const kSINotificationGameStarted;
extern NSString *const kSINotificationLevelDidChange;
extern NSString *const kSINotificationMenuLoaded;
extern NSString *const kSINotificationNewBackgroundReady;
extern NSString *const kSINotificationNewHighScore;
extern NSString *const kSINotificationPowerUpActive;
extern NSString *const kSINotificationPowerUpDeactivated;
extern NSString *const kSINotificationScoreUpdate;
extern NSString *const kSINotificationSettingsLaunchBugReport;
extern NSString *const kSINotificationPackPurchaseRequest;
extern NSString *const kSINotificationShowLeaderBoard;

#pragma mark - Score Constants
extern NSString *const kSIScoreTotalScore;
extern NSString *const kSIScoreNextMove;

#pragma mark - Images
extern NSString *const kSIImageBackgroundDiamondPlate;
extern NSString *const kSIImageBackgroundPalmTreeBendLargeLeft;
extern NSString *const kSIImageBackgroundPalmTreeBendLargeRight;
extern NSString *const kSIImageBackgroundPalmTreeBendSmallLeft;
extern NSString *const kSIImageBackgroundPalmTreeBendSmallRight;
extern NSString *const kSIImageButtonContinue;
extern NSString *const kSIImageButtonContinueGrayed;
extern NSString *const kSIImageButtonCross;
extern NSString *const kSIImageButtonDismiss;
extern NSString *const kSIImageButtonDone;
extern NSString *const kSIImageButtonEndGame;
extern NSString *const kSIImageButtonFallingMonkey;
extern NSString *const kSIImageButtonGameModeOneHand;
extern NSString *const kSIImageButtonGameModeTwoHand;
extern NSString *const kSIImageButtonLeaderboard;
extern NSString *const kSIImageButtonInstructions;
extern NSString *const kSIImageButtonMenu;
extern NSString *const kSIImageButtonNoAd;
extern NSString *const kSIImageButtonPause;
extern NSString *const kSIImageButtonPlay;
extern NSString *const kSIImageButtonRapidFire;
extern NSString *const kSIImageButtonReplay;
extern NSString *const kSIImageButtonSettings;
extern NSString *const kSIImageButtonSoundOffBackground;
extern NSString *const kSIImageButtonSoundOffFX;
extern NSString *const kSIImageButtonSoundOnBackground;
extern NSString *const kSIImageButtonSoundOnFX;
extern NSString *const kSIImageButtonStore;
extern NSString *const kSIImageButtonTimeFreeze;
extern NSString *const kSIImageCoinLargeBack;
extern NSString *const kSIImageCoinLargeFront;
extern NSString *const kSIImageCoinSmallBack;
extern NSString *const kSIImageCoinSmallFront;
extern NSString *const kSIImageFallingMonkeys;
extern NSString *const kSIImageGift;
extern NSString *const kSIImageIAPSmall;
extern NSString *const kSIImageIAPMedium;
extern NSString *const kSIImageIAPLarge;
extern NSString *const kSIImageIAPExtraLarge;
extern NSString *const kSIImageProgressBarFillMove;
extern NSString *const kSIImageProgressBarFillPowerUp;
extern NSString *const kSIImageShapePowerupCost;
extern NSString *const kSIImageTapToPlayText;


#pragma mark - Texture Atlas
extern NSString *const kSIAtlasBackground;
extern NSString *const kSIAtlasButtons;
extern NSString *const kSIAtlasImages;
extern NSString *const kSIAtlasSceneMenu;
extern NSString *const kSIAtlasShapes;

#pragma mark - Images in Atlas
extern NSString *const kSIAtlasSceneMenuAchievements;
extern NSString *const kSIAtlasSceneMenuAdFree;
extern NSString *const kSIAtlasSceneMenuHelp;
extern NSString *const kSIAtlasSceneMenuLeaderboard;
extern NSString *const kSIAtlasSceneMenuPlayClassic;
extern NSString *const kSIAtlasSceneMenuPlayOneHand;
extern NSString *const kSIAtlasSceneMenuSettings;
extern NSString *const kSIAtlasSceneMenuSoundBackground;
extern NSString *const kSIAtlasSceneMenuSoundFX;

#pragma mark - Button Labels
extern NSString *const kSIButtonLabelStringOneHand;
extern NSString *const kSIButtonLabelStringTwoHand;

#pragma mark - NSDictionary Keys
extern NSString *const kSINSDictionaryKeyCanAfford;
extern NSString *const kSINSDictionaryKeyCanAffordCost;
extern NSString *const kSINSDictionaryKeyHudHoldDismissForDuration;
extern NSString *const kSINSDictionaryKeyHudMessageDismissInfo;
extern NSString *const kSINSDictionaryKeyHudMessageDismissTitle;
extern NSString *const kSINSDictionaryKeyHudMessagePresentInfo;
extern NSString *const kSINSDictionaryKeyHudMessagePresentTitle;
extern NSString *const kSINSDictionaryKeyHudWillAnimate;
extern NSString *const kSINSDictionaryKeyHudWillDimBackground;
extern NSString *const kSINSDictionaryKeyHudWillShowCheckmark;
extern NSString *const kSINSDictionaryKeyMoveScore;
extern NSString *const kSINSDictionaryKeyPowerUp;
extern NSString *const kSINSDictionaryKeyPackProduct;
extern NSString *const kSINSDictionaryKeySIAchievementPlistAmount;
extern NSString *const kSINSDictionaryKeySIAchievementPlistLevelsDictionary;
extern NSString *const kSINSDictionaryKeySIAchievementPlistCompletedBool;
extern NSString *const kSINSDictionaryKeySIAchievementPlistCompletionRewardInt;
extern NSString *const kSINSDictionaryKeySIAchievementPlistHelpString;
extern NSString *const kSINSDictionaryKeySIAchievementPlistLevel1;
extern NSString *const kSINSDictionaryKeySIAchievementPlistLevel2;
extern NSString *const kSINSDictionaryKeySIAchievementPlistLevel3;
extern NSString *const kSINSDictionaryKeySIAchievementPlistMoveString;
extern NSString *const kSINSDictionaryKeySIAchievementPlistMoveSequenceArray;
extern NSString *const kSINSDictionaryKeySIAchievementPlistPostfixString;
extern NSString *const kSINSDictionaryKeySIAchievementPlistPrefixString;
extern NSString *const kSINSDictionaryKeySIAchievementPlistReward;
extern NSString *const kSINSDictionaryKeySIAchievementPlistTitleString;
extern NSString *const kSINSDictionaryKeySIAchievementPlistTypeString;


#pragma mark - Plist
extern NSString *const kSIPlistMoveCommandPinch;
extern NSString *const kSIPlistMoveCommandShake;
extern NSString *const kSIPlistMoveCommandStop;
extern NSString *const kSIPlistMoveCommandSwype;
extern NSString *const kSIPlistMoveCommandTap;
extern NSString *const kSIPlistTypeAll;
extern NSString *const kSIPlistTypeMove;
extern NSString *const kSIPlistTypeMoveSequence;
extern NSString *const kSIPlistTypeScore;


#pragma mark - In App Purchase Product ID
extern NSString *const kSIIAPProductIDAdFree;
extern NSString *const kSIIAPProductIDCoinPackSmall;
extern NSString *const kSIIAPProductIDCoinPackMedium;
extern NSString *const kSIIAPProductIDCoinPackLarge;
extern NSString *const kSIIAPProductIDCoinPackExtraLarge;

#pragma mark - In App Purchase Consumable ID
extern NSString *const kSIIAPConsumableIDCoins;

#pragma mark - In App Purchase Pack Names
extern NSString *const kSIIAPPackNameSmall;
extern NSString *const kSIIAPPackNameMedium;
extern NSString *const kSIIAPPackNameLarge;
extern NSString *const kSIIAPPackNameExtraLarge;


#pragma mark - Node Names
extern NSString *const kSINodeAdBannerNode;
extern NSString *const kSINodeLabelDescriptionChest;
extern NSString *const kSINodeLabelDescriptionBag;
extern NSString *const kSINodeLabelDescriptionBucket;
extern NSString *const kSINodeLabelDescriptionPile;
extern NSString *const kSINodeLabelPriceChest;
extern NSString *const kSINodeLabelPriceBag;
extern NSString *const kSINodeLabelPriceBucket;
extern NSString *const kSINodeLabelPricePile;
extern NSString *const kSINodeNodeChest;
extern NSString *const kSINodeNodeBag;
extern NSString *const kSINodeNodeBucket;
extern NSString *const kSINodeNodePile;
extern NSString *const kSINodeButtonAchievement;
extern NSString *const kSINodeButtonContinue;
extern NSString *const kSINodeButtonDone;
extern NSString *const kSINodeButtonFallingMonkey;
extern NSString *const kSINodeButtonInstructions;
extern NSString *const kSINodeButtonLeaderBoard;
extern NSString *const kSINodeButtonMenu;
extern NSString *const kSINodeButtonNoAd;
extern NSString *const kSINodeButtonOneHand;
extern NSString *const kSINodeButtonPause;
extern NSString *const kSINodeButtonPlay;
extern NSString *const kSINodeButtonTwoHand;
extern NSString *const kSINodeButtonTimeFreeze;
extern NSString *const kSINodeButtonRapidFire;
extern NSString *const kSINodeButtonReplay;
extern NSString *const kSINodeButtonSettings;
extern NSString *const kSINodeButtonStore;
extern NSString *const kSINodeFallingMonkey;
extern NSString *const kSINodeGameMoveCommand;
extern NSString *const kSINodeGameProgressBarMove;
extern NSString *const kSINodeGameScoreTotal;
extern NSString *const kSINodePopupContent;
extern NSString *const kSINodePopupTitle;

#pragma mark - Fonts
extern NSString *const kSIFontUltraStroked;
extern NSString *const kSIFontGameScore;
extern NSString *const kSIFontFuturaMedium;
extern NSString *const kSIFontUltra;

#pragma mark - Menu Button Texts
extern NSString *const kSIMenuTextBack;
extern NSString *const kSIMenuTextEndGameContinue;
extern NSString *const kSIMenuTextEndGameReplay;
extern NSString *const kSIMenuTextEndGameStore;
extern NSString *const kSIMenuTextEndGameMainMenu;
extern NSString *const kSIMenuTextPopUpBuyCoins;
extern NSString *const kSIMenuTextPopUpEndGame;
extern NSString *const kSIMenuTextPopUpWatchAd;
extern NSString *const kSIMenuTextSettingsBugReport;
extern NSString *const kSIMenuTextSettingsResetHighScore;
extern NSString *const kSIMenuTextSettingsRestorePurchases;
extern NSString *const kSIMenuTextSettingsToggleSoundOffBackground;
extern NSString *const kSIMenuTextSettingsToggleSoundOffFX;
extern NSString *const kSIMenuTextSettingsToggleSoundOnBackground;
extern NSString *const kSIMenuTextSettingsToggleSoundOnFX;
extern NSString *const kSIMenuTextStartScreenOneHand;
extern NSString *const kSIMenuTextStartScreenTwoHand;
extern NSString *const kSIMenuTextStartScreenSettings;
extern NSString *const kSIMenuTextStartScreenStore;

#pragma mark - Emails
extern NSString *const kSIEmailBugReportReciever;

#pragma mark - Sounds
extern NSString *const kSISoundBackgroundMenu;
extern NSString *const kSISoundBackgroundOne;
extern NSString *const kSISoundBackgroundTwo;
extern NSString *const kSISoundBackgroundThree;
extern NSString *const kSISoundBackgroundFour;
extern NSString *const kSISoundBackgroundFive;
extern NSString *const kSISoundBackgroundSix;
extern NSString *const kSISoundBackgroundSeven;
extern NSString *const kSISoundFXCoinNoise;
extern NSString *const kSISoundFXChaChing;
extern NSString *const kSISoundFXGameOver;
extern NSString *const kSISoundFXInitalize;

#pragma mark - EmitterNodes
extern NSString *const kSIEmitterFileTypeSKS;
extern NSString *const kSIEmitterExplosionTouch;
extern NSString *const kSIEmitterSpark;

#pragma mark - Game Center Leaderboard IDs
extern NSString *const kSIGameCenterLeaderBoardIDHandOne;
extern NSString *const kSIGameCenterLeaderBoardIDHandTwo;

#pragma mark - Encode/Decode 
extern NSString *const kEDDirectoryAchievements;
extern NSString *const kEDTypeArchive;

#pragma mark - Encode/Decode Keys
extern NSString *const kEDKeyAchievementCurrentAmount;
extern NSString *const kEDKeyAchievementCurrentIndexOfMoveSequenceCommand;
extern NSString *const kEDKeyAchievementCurrentLevel;
extern NSString *const kEDKeyAchievementCurrentLevels;
extern NSString *const kEDKeyAchievementCurrentMoveCommand;
extern NSString *const kEDKeyAchievementCurrentSequence;
extern NSString *const kEDKeyAchievementDetails;
extern NSString *const kEDKeyAchievementDetailsHelpString;
extern NSString *const kEDKeyAchievementDetailsPrefixString;
extern NSString *const kEDKeyAchievementDetailsPostfixString;
extern NSString *const kEDKeyAchievementDetailsType;
extern NSString *const kEDKeyAchievementDetailsCompleted;
extern NSString *const kEDKeyAchievementDetailsCompletionReward;
extern NSString *const kEDKeyAchievementDetailsMoveSequenceArray;
extern NSString *const kEDKeyAchievementDetailsDictionaryKey;
extern NSString *const kEDKeyAchievementTitle;

#pragma mark - Useful things
@interface SIConstants : NSObject
+ (BOOL)isBackgroundSoundAllowed;
+ (BOOL)isFXAllowed;
/**
 This is the height of the power up toolbar nodes
 */
+ (CGSize)powerUpToolbarButtonSize;
+ (NSArray *)userMessageHighScore;
+ (NSArray *)userMessageHighScoreClose;
+ (NSArray *)userMessageHighScoreMedian;
+ (NSArray *)userMessageHighScoreBad;
+ (NSString *)pathForSparkEmitter;
+ (NSString *)pathForTouchExplosionEmitter;
+ (SKTextureAtlas *)atlasSceneMenu;
+ (SKTextureAtlas *)backgroundAtlas;
+ (SKTextureAtlas *)buttonAtlas;
+ (SKTextureAtlas *)imagesAtlas;
+ (SKTextureAtlas *)shapesAtlas;
@end




