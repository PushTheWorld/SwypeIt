//  SIAchievementManager.m
//  Swype It
//
//  Created by Andrew Keller on 9/7/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is implementation file for the challenge manager for
//              Swype It...
//      We need to try to load progress from the progress made with game center...
//      So may i suggest this...
//          1. Load from local storage
//              a. If nil
//                  i.  load from plist
//                  ii. store to memory
//          2. Load from Game Center
//          3. Sync local with game center
//
// Local Controller Import
#import "SIAchievementSingleton.h"
// Framework Import
#import <GameKit/GameKit.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports

@implementation SIAchievementSingleton {
    NSArray                     *_remoteGKAchievementArray;
    
    NSMutableDictionary         *_localMutableAchievementDictionary;
    
    SIAchievementSkillLevel      _currentAchievementSkillLevel;
    
    NSArray                     *_currentAchievementKeys;
    
    
}

#pragma mark - Singleton
+ (instancetype)singleton {
    static SIAchievementSingleton *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[SIAchievementSingleton alloc] init];
    });
    return singleton;
}

#pragma mark - Initializers/Setup
- (instancetype)init {
    self = [super init];
    if (self) {
        [self singletonAchievementDictionaryInitialization];
    }
    return self;
}

/**
 Run to completely initialize the singleton... this does everything from
    Pull from nsuserdefaults and if that's not there then it even reads from plist
    and stores to nsuerdefaults for later use. This methods goes as far to pull achievements 
    from remote and sync the local with the remote info pulled
     
    If you will imagine this could potentially update the remote to match the progress a player
        made offline or this could fast forward the progress a player has made based off the 
        Achievement percentCompletes pulled from remote... powerful stuff here
 */
- (void)singletonAchievementDictionaryInitialization {
    /*Try to sink with the internet from */
    _localMutableAchievementDictionary  = [self getAchievementDictionaryFromNSUserDefaults];
    
    [SIAchievementSingleton singletonAchievementFetchAchievementRemoteWithCallback:^(NSArray *remoteArray, NSError *error) {
        if (error) {
            if ([_delegate respondsToSelector:@selector(singletonAchievementFailedToReachGameCenterWithError:)]) {
                [_delegate singletonAchievementFailedToReachGameCenterWithError:error];
            }
        } else {
            /*Assign remote for later use*/
            _remoteGKAchievementArray = remoteArray;
            //TODO: make this acutally do something
            [SIAchievementSingleton singletonAchievementSyncRemoteGKAchievementArray:remoteArray withMutableDictionary:_localMutableAchievementDictionary];
        }
        [self singletonAchievementSetup];
    }];
}

/**
 Assumptions: That `_localMutableAchievementDictionary` is not nil, that it has keys matching our shit, 
    and that it has been updated by remote achievements if internet is available
 */
- (void)singletonAchievementSetup {
    _currentAchievementSkillLevel = [SIAchievementSingleton getCurrentAchievementLevelFromAchievementDictionary:[_localMutableAchievementDictionary copy]];
    _currentAchievementKeys = [SIAchievementSingleton getCurrentAchievementsForSkillLevel:_currentAchievementSkillLevel];
}




/**
 Actually pulls from user defaults also reads from plist if the achievement is not in user defaults
    I think the question of this working is if nsuerdefaults is powerful enought to save a whole
    objective c class too... this may be a bad idea idk im not an expert...
 */
- (NSMutableDictionary *)getAchievementDictionaryFromNSUserDefaults {
    NSMutableDictionary *newDictionary = [NSMutableDictionary dictionary];
    for (NSString *achievementKey in [SIAchievementSingleton arrayOfDictionaryKeyNames]) {
        SIAchievement *siAchievement = [[NSUserDefaults standardUserDefaults] objectForKey:achievementKey];
        // TODO load from plist & store to userDefualts
        if (siAchievement == nil) {
            NSDictionary *plistDictionary = [SIAchievementSingleton singletonAchievementLoadFromPlist];
            siAchievement = [SIAchievementSingleton configureAchievementFromDictionary:[plistDictionary objectForKey:achievementKey]];
            [SIAchievementSingleton storeSIAchievement:siAchievement toMemoryWithKey:achievementKey];
        }
        [newDictionary setObject:siAchievement forKey:achievementKey];
    }
    return newDictionary;
}


#pragma mark - Public Methods
- (void)singletonAchievementWillProcessMove:(SIMove *)move {
    
}

#pragma mark - Private Class Methods

/**
 Creates and returns a array with the achiement keys we are trying to complete at the current skill level
 */
+ (NSArray *)getCurrentAchievementsForSkillLevel:(SIAchievementSkillLevel)skillLevel {
    switch (skillLevel) {
        case SIAchievementSkillLevelBeginner:
            return @[kSIAchievementIDChallengeBeginner1,
                     kSIAchievementIDChallengeBeginner2,
                     kSIAchievementIDChallengeBeginner3,
                     kSIAchievementIDChallengeBeginnerAll];
        case SIAchievementSkillLevelIntermediate:
            return @[kSIAchievementIDChallengeIntermediate1,
                     kSIAchievementIDChallengeIntermediate2,
                     kSIAchievementIDChallengeIntermediate3,
                     kSIAchievementIDChallengeIntermediateAll];
        case SIAchievementSkillLevelPro:
            return @[kSIAchievementIDChallengePro1,
                     kSIAchievementIDChallengePro2,
                     kSIAchievementIDChallengePro3,
                     kSIAchievementIDChallengeProAll];
        default: //SIAchievementSkillLevelMaster
            return @[kSIAchievementIDChallengeMaster1,
                     kSIAchievementIDChallengeMaster2,
                     kSIAchievementIDChallengeMaster3,
                     kSIAchievementIDChallengeMasterAll];
    }
}

/**
 Get the current skill level using the local dictionary
 */
+ (SIAchievementSkillLevel)getCurrentAchievementLevelFromAchievementDictionary:(NSDictionary *)dictionary {
    if ([(SIAchievement *)[dictionary objectForKey:kSIAchievementIDChallengeBeginnerAll] details].completed == NO) {
        return SIAchievementSkillLevelBeginner;
    } else if ([(SIAchievement *)[dictionary objectForKey:kSIAchievementIDChallengeIntermediateAll] details].completed == NO) {
        return SIAchievementSkillLevelIntermediate;
    } else if ([(SIAchievement *)[dictionary objectForKey:kSIAchievementIDChallengeProAll] details].completed == NO) {
        return SIAchievementSkillLevelPro;
    } else {
        return SIAchievementSkillLevelMaster;
    }
}

/**
 Called to sync the local with the remote dictionary
 */
+ (void)singletonAchievementSyncRemoteGKAchievementArray:(NSArray *)gkAchievementArray withMutableDictionary:(NSMutableDictionary *)dictionaryToSync {
    
}

/**
 Called to load from game center
 error == nil if successfull....
 */
+ (void)singletonAchievementFetchAchievementRemoteWithCallback:(void (^)(NSArray *remoteArray, NSError *error))callback {
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray<GKAchievement *> * __nullable achievements, NSError * __nullable error) {
        /*The operation completed successfully*/
        if (error == nil) {
            if (callback) {
                callback(achievements, nil);
            }
            
        } else {
            if (callback) {
                callback(nil, error);
            }
        }
    }];
}

/**
 Used to convert remote achievement progress to local achievement progress
    percent 0 to 100 from gamecenter... ACHIEVEMENT_PERCENT_PER_LEVEL == 33
 */
+ (SIAchievementLevel)achievementLevelForPercentComplete:(float)percent {
    if (percent < ACHIEVEMENT_PERCENT_PER_LEVEL) {
        return SIAchievementLevelNone;
    } else if (percent < 2 * ACHIEVEMENT_PERCENT_PER_LEVEL) {
        return SIAchievementLevelOne;
    } else if (percent < 3 * ACHIEVEMENT_PERCENT_PER_LEVEL) {
        return SIAchievementLevelTwo;
    } else if (percent < 100) {
        return SIAchievementLevelThree;
    } else {
        return SIAchievementLevelDone;
    }
}

/**
 This will extract and configure the achievement given a dictionary that is the enrty itself in the plist file
 NOT the whole plist dictionary, just the corrent entry like `challengeBeginner2`
 
 Also note it is extremely important that the type is set before!
 */
+ (SIAchievement *)configureAchievementFromDictionary:(NSDictionary *)dictionary {
    
    SIAchievement *achievement                  = [[SIAchievement alloc] init];
    
    achievement.details.completed               = NO;
    achievement.details.type                    = [SIAchievementSingleton achievementTypeForTypeString:[dictionary objectForKey:kSINSDictionaryKeySIAchievementPlistTypeString]];
    
    
    if (achievement.details.type == SIAchievementTypeAll) {
        achievement.title                       = [dictionary objectForKey:kSINSDictionaryKeySIAchievementPlistTitleString];
        achievement.details.completionReward    = [(NSNumber *)[dictionary objectForKey:kSINSDictionaryKeySIAchievementPlistCompletionRewardInt] intValue];
        return achievement;
    }
    
    achievement.details.helpString              = [dictionary objectForKey:kSINSDictionaryKeySIAchievementPlistHelpString];
    achievement.details.postfixString           = [dictionary objectForKey:kSINSDictionaryKeySIAchievementPlistPostfixString];
    achievement.details.prefixString            = [dictionary objectForKey:kSINSDictionaryKeySIAchievementPlistPrefixString];
    achievement.challengeLevels                 = [(NSDictionary *)[dictionary objectForKey:kSINSDictionaryKeySIAchievementPlistChallengeLevelsDictionary] mutableCopy];
    
    if (achievement.details.type == SIAchievementTypeMove) {
        achievement.currentMove                 = [SIAchievementSingleton moveCommandForString:kSINSDictionaryKeySIAchievementPlistMoveString];
    }
    
    if (achievement.details.type == SIAchievementTypeMoveSequence) {
        achievement.details.moveSequenceArray   = [dictionary objectForKey:kSINSDictionaryKeySIAchievementPlistMoveSequenceArray];
    }
    
    return achievement;
}

/**
 Returns a dictionary with all the achievements from the plist file...
 */
+ (NSDictionary *)singletonAchievementLoadFromPlist {
    NSDictionary *plistDictionary;
    
    /*The plist is located in teh `Resources` folder so we load with this method... */
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:kSIAchievementPlistPathForResource ofType:kSIAchievementPlistType];
    
    /*Read the file.
     We think this will produce a dictionary with keys matching the kSIAchievementIDs... */
    plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    return plistDictionary;
}

/**
 Called to convert array from remote to dictionary like we use locally...
 */
+ (NSDictionary *)convertGameCenterArray:(NSArray *)gameCenterArray {
    return [NSDictionary dictionaryWithObjects:gameCenterArray forKeys:[SIAchievementSingleton arrayOfDictionaryKeyNames]];
}

+ (NSArray *)arrayOfDictionaryKeyNames {
    return @[kSIAchievementIDChallengeBeginner1,
             kSIAchievementIDChallengeBeginner2,
             kSIAchievementIDChallengeBeginner3,
             kSIAchievementIDChallengeBeginnerAll,
             kSIAchievementIDChallengeIntermediate1,
             kSIAchievementIDChallengeIntermediate2,
             kSIAchievementIDChallengeIntermediate3,
             kSIAchievementIDChallengeIntermediateAll,
             kSIAchievementIDChallengePro1,
             kSIAchievementIDChallengePro2,
             kSIAchievementIDChallengePro3,
             kSIAchievementIDChallengeProAll,
             kSIAchievementIDChallengeMaster1,
             kSIAchievementIDChallengeMaster2,
             kSIAchievementIDChallengeMaster3,
             kSIAchievementIDChallengeMasterAll];
}

/**
 Get SIAchievement from string
 
    1. Use this when converting plist to SIAchievement class
 */
+ (SIAchievementType)achievementTypeForTypeString:(NSString *)typeString {
    if ([typeString isEqualToString:kSIPlistTypeAll]) {
        return SIAchievementTypeAll;
    } else if ([typeString isEqualToString:kSIPlistTypeMove]) {
        return SIAchievementTypeMove;
    } else if ([typeString isEqualToString:kSIPlistTypeMoveSequence]) {
        return SIAchievementTypeMoveSequence;
    } else { //if ([typeString isEqualToString:kSIPlistTypeScore]) {
        return SIAchievementTypeScore;
    }
}

/**
 Returns SIMoveCommand for a string
 */
+ (SIMoveCommand)moveCommandForString:(NSString *)stringCommand {
    if ([stringCommand isEqualToString:kSIPlistMoveCommandPinch]) {
        return SIMoveCommandPinch;
    } else if ([stringCommand isEqualToString:kSIPlistMoveCommandShake]) {
        return SIMoveCommandShake;
    } else if ([stringCommand isEqualToString:kSIPlistMoveCommandSwype]) {
        return SIMoveCommandSwype;
    } if ([stringCommand isEqualToString:kSIPlistMoveCommandTap]) {
        return SIMoveCommandTap;
    } else {
        return SIMoveCommandFallingMonkey;
    }
}

/**
 Just sets and syncronizes achievement with nsuserdefaults
 */
+ (void)storeSIAchievement:(SIAchievement *)achievement toMemoryWithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:achievement forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end