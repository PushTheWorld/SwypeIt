//  SIIAPUtility.h
//  Swype It
//
//  Created by Andrew Keller on 7/23/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: Thie is the startign screen for the swype it game
//
// Local Controller Import
// Framework Import
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIGame.h"
// Other Imports

#define NUMBER_OF_IAP_PACKS 4

@interface SIIAPUtility : NSObject

//#pragma mark - Singleton
//+ (instancetype)singleton;

/**
 Input the currentNumberOfTimesContiued and get back
    whether or not the person can afford it...
 */
+ (BOOL)canAffordContinueNumberOfTimesContinued:(int)numberOfTimesContinued;

/**
 Retuns nil if the product cannot be found
 */
+ (NSDecimalNumber *)   productPriceForSIIAPPack:(SIIAPPack)siiapPack;

+ (NSString *)          buttonNodeNameLabelDescriptionForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          buttonNodeNameLabelPriceForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          buttonNodeNameNodeForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          buttonTextForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          imageNameForSIIAPPack:(SIIAPPack)siiapPack;
+ (NSString *)          productIDForSIIAPPack:(SIIAPPack)siiapPack;



+ (void)productForSIIAPPack:(SIIAPPack)siiapPack inPackArray:(NSArray *)productArray withBlock:(void (^)(BOOL succeeded, SKProduct *product))completionBlock;

/**
 Get the date from the internet
 */
+ (NSDate *)getDateFromInternet;
/**
 Uses NSUserDefaults to get the number of coins to give for free daily prize
 */
+ (int)getDailyFreePrizeAmount;

/**
 Return the number of coins for a given power up
 */
+ (int)numberOfCoinsForSIIAPPack:(SIIAPPack)siiapPack;

/**
 Uses NSUserDefaults to increment the number of consecutive days the app has been launched
 */
+ (void)increaseConsecutiveDaysLaunched;
/**
 Returns a cool looking title node for daily free prize
 */
+ (SKSpriteNode *)createTitleNode:(CGSize)size;

/**
 Converts a given node label name into a SIIAPPack type
 */
+ (SIIAPPack)siiapPackForNameNodeLabel:(NSString *)nodeLabelName;

/**
 Converts a node node name into a SIIAPPack type
 */
+ (SIIAPPack)siiapPackForNameNodeNode:(NSString *)nodeName;

/**
 Uses MKStoreKit to get the total number of coins available
 */
+ (int)numberOfCoinsForUser;
@end
