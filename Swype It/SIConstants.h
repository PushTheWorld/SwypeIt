//  SIConstants.h
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#define IDIOM                       UI_USER_INTERFACE_IDIOM()
#define IPAD                        UIUserInterfaceIdiomPad

#define LEVEL1                      100
#define LEVEL2                      250
#define LEVEL3                      500
#define LEVEL4                      750
#define LEVEL5                      1000
#define LEVEL6                      1300
#define LEVEL7                      1600
#define LEVEL8                      2000
#define LEVEL9                      2400
#define LEVEL10                     2800
#define LEVEL11                     3300
#define LEVEL12                     3800
#define LEVEL13                     4400
#define LEVEL14                     5000
#define LEVEL15                     5700
#define LEVEL16                     6400
#define LEVEL17                     7200
#define LEVEL18                     8000
#define LEVEL19                     8900
#define LEVEL20                     10000
#define LEVEL21                     11000
#define LEVEL22                     12000

#define SOUNDLEVEL1                 100
#define SOUNDLEVEL2                 200
#define SOUNDLEVEL3                 300
#define SOUNDLEVEL4                 400
#define SOUNDLEVEL5                 500
#define SOUNDLEVEL6                 600
#define SOUNDLEVEL7                 700

#define VERTICAL_SPACING_4          4
#define VERTICAL_SPACING_8          8
#define VERTICAL_SPACING_16         16

#define IS_IPHONE_4                 (MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width) == 480.0)
#define IS_IPHONE_5                 (MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width) == 568.0)
#define IS_IPHONE_6                 (MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width) == 667.0)
#define IS_IPHONE_6_PLUS            (MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width) == 736.0)

#define SCREEN_WIDTH                MIN([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT               MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)

#define MILI_SECS_IN_SEC            1000

#pragma mark - Game Constants
#define POINTS_NEEDED_FOR_FREE_COIN 500
#define mSlope                      -7/240
#define SCORE_EXP_POWER_WEIGHT      -0.001205
#define MAX_MOVE_SCORE              10.78457
#define SPEED_TRANSISTION_SCORE     8629.55
#define TIMER_INTERVAL              1/30
#define SPEED_LOG_INTERCEPT         4.418243235
#define SPEED_LOG_MULTIPLIER        -0.383625766
#define SPEED_POWER_EXPONENT        -0.22291709
#define SPEED_POWER_MULTIPLIER      7.07850289
#define LEVEL_SPEED_DIV_MULT        -0.384
#define LEVEL_SPEED_INTERCEPT       4.4182
#define VALUE_OF_MONKEY             25

#define NUMBER_OF_MOVES             3
#define NUMBER_OF_BACKGROUNDS       3
#define NUMBER_OF_MONKEYS_INIT      15
#define NUMBER_OF_IAP_PACKS         4

#define IAP_PACK_PRICE_SMALL        00.99
#define IAP_PACK_PRICE_MEDIUM       04.99
#define IAP_PACK_PRICE_LARGE        09.99
#define IAP_PACK_PRICE_EXTRA_LARGE  24.99

#define SCENE_TRANSISTION_DURATION  0.5

typedef NS_ENUM(NSInteger, SIGameMode) {
    SIGameModeOneHand,
    SIGameModeTwoHand
};
typedef NS_ENUM(NSInteger, SIMove) {
    SIMoveTap,
    SIMoveSwype,
    SIMovePinch,
    SIMoveShake
};
typedef NS_ENUM(NSInteger, SIPowerUp) {
    SIPowerUpNone,
    SIPowerUpFallingMonkeys,
    SIPowerUpTimeFreeze,
    SIPowerUpRapidFire
};
typedef NS_ENUM(NSInteger, SIPowerUpCost) {
    SIPowerUpCostNone               = 0,
    SIPowerUpCostTimeFreeze         = 1,
    SIPowerUpCostRapidFire          = 3,
    SIPowerUpCostFallingMonkeys     = 5
};

typedef NS_ENUM(NSInteger, SIPowerUpDuration) {
    SIPowerUpDurationNone           = 0,
    SIPowerUpDurationRapidFire      = 3,
    SIPowerUpDurationTimeFreeze     = 8
};

typedef NS_ENUM(NSInteger, SIIAPNumberOfCoins) {
    SIIAPNumberOfCoinsSmall         = 30,
    SIIAPNumberOfCoinsMedium        = 200,
    SIIAPNumberOfCoinsLarge         = 500,
    SIIAPNumberOfCoinsExtraLarge    = 1500
};
typedef NS_ENUM(NSInteger, SIIAPPack) {
    SIIAPPackSmall,
    SIIAPPackMedium,
    SIIAPPackLarge,
    SIIAPPackExtraLarge
};
typedef NS_ENUM(NSInteger, SIContinueLifeCost) {
    SIContinueLifeCost0     = 0,
    SIContinueLifeCost1     = 5,
    SIContinueLifeCost2     = 10,
    SIContinueLifeCost3     = 20,
    SIContinueLifeCost4     = 50,
    SIContinueLifeCost5     = 100,
    SIContinueLifeCost6     = 250,
    SIContinueLifeCost7     = 500,
    SIContinueLifeCost8     = 1000,
    SIContinueLifeCost9     = 2500,
    SIContinueLifeCost10    = 5000,
    SIContinueLifeCost11    = 10000,
    SIContinueLifeCost12    = 12500,
    SIContinueLifeCost13    = 15000,
    SIContinueLifeCost14    = 20000,
    SIContinueLifeCost15    = 25000,
    SIContinueLifeCost16    = 30000,
    SIContinueLifeCost17    = 40000,
    SIContinueLifeCost18    = 50000,
    SIContinueLifeCost19    = 100000,
    SIContinueLifeCost20    = 1000000
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
extern NSString *const kSINSUserDefaultFirstLaunch;
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
extern NSString *const kSIPowerUpFallingMonkeys;
extern NSString *const kSIPowerUpNone;
extern NSString *const kSIPowerUpTimeFreeze;
extern NSString *const kSIPowerUpRapidFire;

#pragma mark - NSNotification
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
extern NSString *const kSIImageCoinSmallBack;
extern NSString *const kSIImageCoinSmallFront;
extern NSString *const kSIImageFallingMonkeys;
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
extern NSString *const kSIAtlasShapes;

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

#pragma mark - In App Purchase Product ID
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
extern NSString *const kSINodePopUpContent;

#pragma mark - Fonts
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
extern NSString *const kSISoundFXChaChing;
extern NSString *const kSISoundFXGameOver;
extern NSString *const kSISoundFXInitalize;

@interface SIConstants : NSObject

+ (SKTextureAtlas *)backgroundAtlas;
+ (SKTextureAtlas *)buttonAtlas;
+ (SKTextureAtlas *)imagesAtlas;
+ (SKTextureAtlas *)shapesAtlas;
@end




