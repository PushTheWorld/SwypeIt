//  SIConstants.h
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
#import <Foundation/Foundation.h>

#define IDIOM               UI_USER_INTERFACE_IDIOM()
#define IPAD                UIUserInterfaceIdiomPad

#define LEVEL1              100
#define LEVEL2              250
#define LEVEL3              500
#define LEVEL4              750
#define LEVEL5              1000
#define LEVEL6              1300
#define LEVEL7              1600
#define LEVEL8              2000
#define LEVEL9              2400
#define LEVEL10             2800
#define LEVEL11             3300
#define LEVEL12             3800
#define LEVEL13             4400
#define LEVEL14             5000
#define LEVEL15             5700
#define LEVEL16             6400
#define LEVEL17             7200
#define LEVEL18             8000
#define LEVEL19             8900
#define LEVEL20             10000
#define LEVEL21             11000
#define LEVEL22             12000
#define LEVEL23             13000
#define LEVEL24             14000
#define LEVEL25             15000
#define LEVEL26             16000
#define LEVEL27             17000
#define LEVEL28             18000
#define LEVEL29             19000
#define LEVEL30             20000


#define IS_IPHONE_4         (MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width) == 480.0)
#define IS_IPHONE_5         (MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width) == 568.0)
#define IS_IPHONE_6         (MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width) == 667.0)
#define IS_IPHONE_6_PLUS    (MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width) == 736.0)


#define SCREEN_WIDTH        MIN([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT       MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)

#pragma mark - Images
extern NSString *const kSIImageTitleLabel;

#pragma mark - Swype It Move Commands
extern NSString *const kSIMoveCommandSwype;
extern NSString *const kSIMoveCommandTap;
extern NSString *const kSIMoveCommandPinch;
extern NSString *const kSIMoveCommandShake;

#pragma mark - Game Modes
extern NSString *const kSIGameModeOriginal;
extern NSString *const kSIGameModeOneHand;

#pragma mark - NSUserDefaults
extern NSString *const kSINSUserDefaultFirstLaunch;
extern NSString *const kSINSUserDefaultNumberOfItCoins;