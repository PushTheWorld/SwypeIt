//  SIAchievementManager.h
//  Swype It
//
//  Created by Andrew Keller on 9/7/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is header file for the challenge singleton
//
// Local Controller Import
// Framework Import
#import <Foundation/Foundation.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
// Support/Data Class Imports
#import "SIAchievement.h"
#import "SIGame.h"
// Other Imports

@protocol SISingletonAchievementDelegate <NSObject>
/**
 Called when challenge was complete
 */
- (void)controllerSingletonAchievementDidCompleteAchievement:(SIAchievement *)achievement;

/**
 Called when singleton is unable to pull from internet for sync
 */
- (void)controllerSingletonAchievementFailedToReachGameCenterWithError:(NSError *)error;

@end

@interface SISingletonAchievement : NSObject

/// @name Delegate Methods

/**
 Delegate methods
 */
@property (nonatomic, weak) id <SISingletonAchievementDelegate> delegate;

#pragma mark - Singleton Method
+ (instancetype)singleton;

#pragma mark - Public Methods
/**
 Enters a move into the singlton
 */
- (void)singletonAchievementWillProcessMove:(SIMove *)move;

#pragma mark - Public Class Methods

/**
 Checks wiht current amoutn against the levelDictionary to see if the user has reached a new level
 */
+ (BOOL)isNewLevelAndUpdateCurrentLevelForAchievement:(SIAchievement *)achievement;

/**
 Get the current SIAchievementLevel for an achievement
 */
+ (SIAchievementLevel)getAchievementLevelForAchievement:(SIAchievement *)achievement;

/**
 Get the reward at a given level for an achievement
 */
+ (int)rewardForAchievementLevel:(SIAchievementLevel)achievementLevel forAchievement:(SIAchievement *)achievement;

/**
 Get the amount at a given level for an achievement
 */
+ (int)amountForAchievementLevel:(SIAchievementLevel)achievementLevel forAchievement:(SIAchievement *)achievement;

/**
 Input an achievement and a desired level...
 The soft fail on dictionaryKeyForSIAchievementLevel: will prevent catastrophic failure on the input
 of SIAchievementLevelDone or SIAchievementLevelNew are entered
 */
+ (NSDictionary *)levelDictionaryForAchievement:(SIAchievement *)achievement atLevel:(SIAchievementLevel)achievementLevel;

/**
 Simply input achievement level and get the dictionary key for it!
 Soft fail with always returning level3 key when SIAchievementLevelDone or
 SIAchievementLevelNew are entered, this is planned and deliberate
 */
+ (NSString *)dictionaryKeyForSIAchievementLevel:(SIAchievementLevel)achievementLevel;

/**
 Creates and returns a array with the achiement keys we are trying to complete at the current skill level
 */
+ (NSArray *)getCurrentAchievementsForSkillLevel:(SIAchievementSkillLevel)skillLevel;

/**
 Simply checks to see if the key is equal to any of the all keys
 found in SIConstants
 */
+ (BOOL)isAchievementKeyAll:(NSString *)achievementKey;

/**
 Get the current skill level using the local dictionary
 */
+ (SIAchievementSkillLevel)getCurrentAchievementLevelFromAchievementDictionary:(NSDictionary *)dictionary;

/**
 Called to sync the local with the remote dictionary
 */
+ (void)singletonAchievementSyncRemoteGKAchievementArray:(NSArray *)gkAchievementArray withMutableDictionary:(NSMutableDictionary *)dictionaryToSync;

/**
 Called to load from game center
 error == nil if successfull....
 */
+ (void)singletonAchievementFetchAchievementRemoteWithCallback:(void (^)(NSArray *remoteArray, NSError *error))callback;

/**
 Used to convert remote achievement progress to local achievement progress
 percent 0 to 100 from gamecenter... ACHIEVEMENT_PERCENT_PER_LEVEL == 33
 */
+ (SIAchievementLevel)achievementLevelForPercentComplete:(float)percent;

/**
 Get the percent complete for a given level
 */
+ (float)percentCompleteForAchievement:(SIAchievementLevel)achievementLevel;

/**
 This will extract and configure the achievement given a dictionary that is the enrty itself in the plist file
 NOT the whole plist dictionary, just the corrent entry like `challengeBeginner2`
 
 Also note it is extremely important that the type is set before!
 */
+ (SIAchievement *)configureAchievementFromDictionary:(NSDictionary *)dictionary withKeyName:(NSString *)key;

/**
 Returns a dictionary with all the achievements from the plist file...
 */
+ (NSDictionary *)singletonAchievementLoadFromPlist;

/**
 Called to convert array from remote to dictionary like we use locally...
 */
+ (NSDictionary *)convertGameCenterArray:(NSArray *)gameCenterArray;

+ (NSArray *)arrayOfDictionaryKeyNames;

/**
 Get SIAchievement from string
 
 1. Use this when converting plist to SIAchievement class
 */
+ (SIAchievementType)achievementTypeForTypeString:(NSString *)typeString;

/**
 Returns SIMoveCommand for a string
 */
+ (SIMoveCommand)moveCommandForString:(NSString *)stringCommand;

#pragma mark Storage Methods
/**
 Actually pulls from disk also reads from plist if the achievement is not in user defaults
 I think the question of this working is if nsuerdefaults is powerful enought to save a whole
 objective c class too... this may be a bad idea idk im not an expert...
 */
+ (NSMutableDictionary *)getAchievementDictionaryFromDisk;

/**
 Path to store achievements with key `dictionaryKey`
 */
+ (NSString *)filePathForArchiveKey:(NSString *)acievementKey;
/**
 Store the achievement to disk
 */
+ (void)storeAchievement:(SIAchievement *)achievement;
/**
 Fetch achievement from disk
 */
+ (SIAchievement *)fetchAchievementWithKey:(NSString *)achievementKey;

@end
