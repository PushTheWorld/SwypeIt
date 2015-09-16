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
#import "SISingletonAchievement.h"
// Framework Import
#import <GameKit/GameKit.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "FXReachability.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports


@implementation SISingletonAchievement {
    NSArray                     *_remoteGKAchievementArray;
    
    NSMutableDictionary         *_localMutableAchievementDictionary;
    
    NSMutableDictionary         *_localRemoteGKAchievementDictionary;
    
    SIAchievementSkillLevel      _currentAchievementSkillLevel;
    
    NSArray                     *_currentAchievementKeys;
}

#pragma mark - Singleton
+ (instancetype)singleton {
    static SISingletonAchievement *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[SISingletonAchievement alloc] init];
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
    Pull from disk and if that's not there then it even reads from plist
    and stores to nsuerdefaults for later use. This methods goes as far to pull achievements 
    from remote and sync the local with the remote info pulled
     
    If you will imagine this could potentially update the remote to match the progress a player
        made offline or this could fast forward the progress a player has made based off the 
        Achievement percentCompletes pulled from remote... powerful stuff here
 */
- (void)singletonAchievementDictionaryInitialization {
    /*Try to sink with the internet from */
    _localMutableAchievementDictionary  = [SISingletonAchievement getAchievementDictionaryFromDisk];
    
    [SISingletonAchievement singletonAchievementFetchAchievementRemoteWithCallback:^(NSArray *remoteArray, NSError *error) {
        if (error) {
            if ([_delegate respondsToSelector:@selector(controllerSingletonAchievementFailedToReachGameCenterWithError:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_delegate controllerSingletonAchievementFailedToReachGameCenterWithError:error];
                });
            }
        } else {
            /*Assign remote for later use*/
            _remoteGKAchievementArray = remoteArray;
            //TODO: make this acutally do something
            [SISingletonAchievement singletonAchievementSyncRemoteGKAchievementArray:remoteArray withMutableDictionary:_localMutableAchievementDictionary];
        }
        [self singletonAchievementSetup];
    }];
}

/**
 Assumptions: That `_localMutableAchievementDictionary` is not nil, that it has keys matching our shit, 
    and that it has been updated by remote achievements if internet is available
 */
- (void)singletonAchievementSetup {
    _currentAchievementSkillLevel = [SISingletonAchievement getCurrentAchievementLevelFromAchievementDictionary:[_localMutableAchievementDictionary copy]];
    _currentAchievementKeys = [SISingletonAchievement getCurrentAchievementsForSkillLevel:_currentAchievementSkillLevel];
}




#pragma mark - Public Methods
/**
 This is the only input to the achievement singleton... it's what makes the engine move ya dig
 */
- (void)singletonAchievementWillProcessMove:(SIMove *)move {
    for (NSString *achievementKey in _currentAchievementKeys) {
        SIAchievement *achievement = [_localMutableAchievementDictionary objectForKey:achievementKey];
        if (achievement.details.completed == NO) {
            /*Mark achievement done if it's on the done level and not marked completed...*/
            if (achievement.currentLevel == SIAchievementLevelDone) {
                [self completedAchievement:achievement];
            } else {
                [self processAchievementTypeMoveForMove:move forAchievement:achievement];
                [self processAchievementTypeMoveSequenceForMove:move forAchievement:achievement];
                [self processAchievementTypeScoreForMove:move forAchievement:achievement];
                [_localMutableAchievementDictionary setObject:achievement forKey:achievementKey];
                [SISingletonAchievement storeAchievement:achievement];
            }
        }
    }
}


/**
 Called to process the move sequence achievement
 */
- (void)processAchievementTypeMoveSequenceForMove:(SIMove *)move forAchievement:(SIAchievement *)achievement {
    // GTFO if not a moveSequence
    if (achievement.details.type != SIAchievementTypeMoveSequence) {
        return;
    }
    
    // Get the move command for this achievement where ever it is
    SIMoveCommand currentMoveCommand = [SISingletonAchievement moveCommandForString:(NSString *)achievement.details.moveSequenceArray[achievement.currentIndexOfMoveSequence]];
    if (currentMoveCommand == move.moveCommand) {
        achievement.currentIndexOfMoveSequence = achievement.currentIndexOfMoveSequence + 1;
        if ([SISingletonAchievement moveCommandForString:(NSString *)achievement.details.moveSequenceArray[achievement.currentIndexOfMoveSequence]] == SIMoveCommandStop) {
            achievement.currentAmount = achievement.currentAmount + 1;
            /*Check if this increase pushed you over into a new level*/
            [self checkIfNewLevelAndNotifyUserForAchievement:achievement];
        }
    }
}

- (void)processAchievementTypeMoveForMove:(SIMove *)move forAchievement:(SIAchievement *)achievement {
    // GTFO if not a move type
    if (achievement.details.type != SIAchievementTypeMove) {
        return;
    }
    
    if (achievement.details.moveSequenceArray == nil) {
        return;
    }
    
    SIMoveCommand currentMoveCommand = [SISingletonAchievement moveCommandForString:(NSString *)achievement.details.moveSequenceArray[0]];
    if (currentMoveCommand == move.moveCommand) {
        achievement.currentAmount = achievement.currentAmount + 1;
        /*Check if this increase pushed you over into a new level*/
        [self checkIfNewLevelAndNotifyUserForAchievement:achievement];
    }
}

- (void)processAchievementTypeScoreForMove:(SIMove *)move forAchievement:(SIAchievement *)achievement {
    // GTFO if not a move type
    if (achievement.details.type != SIAchievementTypeScore) {
        return;
    }
    
    achievement.currentAmount = achievement.currentAmount + (int)floorf(move.totalScore);
    /*Check if this increase pushed you over into a new level*/
    [self checkIfNewLevelAndNotifyUserForAchievement:achievement];

}

- (void)checkIfNewLevelAndNotifyUserForAchievement:(SIAchievement *)achievement {
    if ([SISingletonAchievement isNewLevelAndUpdateCurrentLevelForAchievement:achievement]) {
        if (achievement.currentLevel == SIAchievementLevelDone) {
            [self completedAchievement:achievement];
            [self isSkillLevelCompletedAndNotifyUserForCurrentAchievements];
        }
    }
}

- (void)isSkillLevelCompletedAndNotifyUserForCurrentAchievements {
    BOOL allCompleted = YES;
    
    for (NSString *achievementKey in _currentAchievementKeys) {
        if (![SISingletonAchievement isAchievementKeyAll:achievementKey]) {
            SIAchievement *achievement = [_localMutableAchievementDictionary objectForKey:achievementKey];
            if (achievement.details.completed == NO) {
                allCompleted = NO;
            }
        }
    }
    if (allCompleted) {
        SIAchievement *all = [_localMutableAchievementDictionary objectForKey:_currentAchievementKeys[SIAchievementArrayIndexForAchievementTypeAll]];
        [self completedAchievement:all];
    }

}

/**
 Called when you want to notify the user that achievement was compeleted and you want to sync with Game Center
 */
- (void)completedAchievement:(SIAchievement *)achievement {
    achievement.details.completed = YES;
    [SISingletonAchievement storeAchievement:achievement];
    if ([_delegate respondsToSelector:@selector(controllerSingletonAchievementDidCompleteAchievement:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate controllerSingletonAchievementDidCompleteAchievement:achievement];
        });
    }
    [self updateGameCenterForAchievement:achievement];
}
/**
 Update the achievement with game center... 
 */
- (void)updateGameCenterForAchievement:(SIAchievement *)achievement {
    if ([FXReachability isReachable]) {
        GKAchievement *achievementToReport          = [[GKAchievement alloc] initWithIdentifier:achievement.details.dictionaryKey player:[GKLocalPlayer localPlayer]];
        achievementToReport.percentComplete         = [SISingletonAchievement percentCompleteForAchievement:achievement.currentLevel];
        achievementToReport.showsCompletionBanner   = NO;
        [GKAchievement reportAchievements:@[achievementToReport] withCompletionHandler:^(NSError * __nullable error) {
            if ([_delegate respondsToSelector:@selector(controllerSingletonAchievementFailedToReachGameCenterWithError:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_delegate controllerSingletonAchievementFailedToReachGameCenterWithError:error];
                });
            }
        }];
    }
}

#pragma mark -
#pragma mark - Private Class Methods
/*AUTO UNIT TESTED*/
+ (BOOL)isNewLevelAndUpdateCurrentLevelForAchievement:(SIAchievement *)achievement {

    SIAchievementLevel newLevel = [SISingletonAchievement getAchievementLevelForAchievement:achievement];
    
    if (newLevel > achievement.currentLevel) {
        achievement.currentLevel = newLevel;
        return YES;
    }
    
    return NO;
}

/*AUTO UNIT TESTED*/
/**
 Get the current SIAchievementLevel for an achievement
 */
+ (SIAchievementLevel)getAchievementLevelForAchievement:(SIAchievement *)achievement {
    if (achievement.currentAmount < [SISingletonAchievement amountForAchievementLevel:SIAchievementLevelOne forAchievement:achievement]) {
        return SIAchievementLevelOne;
    } else if (achievement.currentAmount < [SISingletonAchievement amountForAchievementLevel:SIAchievementLevelTwo forAchievement:achievement]) {
        return SIAchievementLevelTwo;
    } else if (achievement.currentAmount < [SISingletonAchievement amountForAchievementLevel:SIAchievementLevelThree forAchievement:achievement]) {
        return SIAchievementLevelThree;
    } else {
        return SIAchievementLevelDone;
    }
}

/*AUTO UNIT TESTED*/
/**
 Get the reward at a given level for an achievement
 */
+ (int)rewardForAchievementLevel:(SIAchievementLevel)achievementLevel forAchievement:(SIAchievement *)achievement {
    return [(NSNumber *)[[SISingletonAchievement levelDictionaryForAchievement:achievement atLevel:achievementLevel] objectForKey:kSINSDictionaryKeySIAchievementPlistReward] intValue];
}

/*AUTO UNIT TESTED*/
/**
 Get the amount at a given level for an achievement
 */
+ (int)amountForAchievementLevel:(SIAchievementLevel)achievementLevel forAchievement:(SIAchievement *)achievement {
    return [(NSNumber *)[[SISingletonAchievement levelDictionaryForAchievement:achievement atLevel:achievementLevel] objectForKey:kSINSDictionaryKeySIAchievementPlistAmount] intValue];
}

/*AUTO UNIT TESTED*/
/**
 Input an achievement and a desired level...
    The soft fail on dictionaryKeyForSIAchievementLevel: will prevent catastrophic failure on the input
        of SIAchievementLevelDone or SIAchievementLevelNew are entered
 */
+ (NSDictionary *)levelDictionaryForAchievement:(SIAchievement *)achievement atLevel:(SIAchievementLevel)achievementLevel {
    return [achievement.levelDictionary objectForKey:[SISingletonAchievement dictionaryKeyForSIAchievementLevel:achievementLevel]];
}

/*AUTO UNIT TESTED*/
/**
 Simply input achievement level and get the dictionary key for it!
    Soft fail with always returning level3 key when SIAchievementLevelDone or
    SIAchievementLevelNew are entered, this is planned and deliberate
 */
+ (NSString *)dictionaryKeyForSIAchievementLevel:(SIAchievementLevel)achievementLevel {
    switch (achievementLevel) {
        case SIAchievementLevelOne:
            return kSINSDictionaryKeySIAchievementPlistLevel1;
        case SIAchievementLevelTwo:
            return kSINSDictionaryKeySIAchievementPlistLevel2;
        default:
            return kSINSDictionaryKeySIAchievementPlistLevel3;
    }
}

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
/*AUTO UNIT TESTED*/
/**
 Simply checks to see if the key is equal to any of the all keys 
    found in SIConstants
 */
+ (BOOL)isAchievementKeyAll:(NSString *)achievementKey {
    if ([achievementKey isEqualToString:kSIAchievementIDChallengeBeginnerAll] || [achievementKey isEqualToString:kSIAchievementIDChallengeIntermediateAll] || [achievementKey isEqualToString:kSIAchievementIDChallengeMasterAll] || [achievementKey isEqualToString:kSIAchievementIDChallengeProAll]) {
        return YES;
    }
    
    return NO;
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

/*AUTO TESTED*/
/**
 Used to convert remote achievement progress to local achievement progress
    percent 0 to 100 from gamecenter... ACHIEVEMENT_PERCENT_PER_LEVEL == 33
 */
+ (SIAchievementLevel)achievementLevelForPercentComplete:(float)percent {
    if (percent < ACHIEVEMENT_PERCENT_PER_LEVEL) {
        return SIAchievementLevelOne;
    } else if (percent < 2 * ACHIEVEMENT_PERCENT_PER_LEVEL) {
        return SIAchievementLevelTwo;
    } else if (percent < 3 * ACHIEVEMENT_PERCENT_PER_LEVEL) {
        return SIAchievementLevelThree;
    } else {
        return SIAchievementLevelDone;
    }
}

/*AUTO TESTED*/
/**
 Get the percent complete for a given level
 */
+ (float)percentCompleteForAchievement:(SIAchievementLevel)achievementLevel {
    switch (achievementLevel) {
        case SIAchievementLevelOne:
            return 0.0f;
        case SIAchievementLevelTwo:
            return ACHIEVEMENT_PERCENT_PER_LEVEL;
        case SIAchievementLevelThree:
            return ACHIEVEMENT_PERCENT_PER_LEVEL * 2;
        default:  //SIAchievementLevelDone
            return 100.0f;
    }
}

/*AUTO TESTED*/
/**
 This will extract and configure the achievement given a dictionary that is the enrty itself in the plist file
 NOT the whole plist dictionary, just the corrent entry like `challengeBeginner2`
 */
+ (SIAchievement *)configureAchievementFromDictionary:(NSDictionary *)dictionary withKeyName:(NSString *)key {
    
    if (dictionary == nil) {
        return nil;
    }
    
    SIAchievement *achievement                          = [[SIAchievement alloc] init];
    
    achievement.currentLevel                            = SIAchievementLevelOne;
    achievement.currentAmount                           = 0;
    achievement.details.completed                       = NO;
    achievement.details.type                            = [SISingletonAchievement achievementTypeForTypeString:[dictionary objectForKey:kSINSDictionaryKeySIAchievementPlistTypeString]];
    achievement.details.dictionaryKey                   = key;
    achievement.details.helpString                      = [dictionary objectForKey:kSINSDictionaryKeySIAchievementPlistHelpString];
    achievement.details.postfixString                   = [dictionary objectForKey:kSINSDictionaryKeySIAchievementPlistPostfixString];
    achievement.details.prefixString                    = [dictionary objectForKey:kSINSDictionaryKeySIAchievementPlistPrefixString];
    achievement.levelDictionary                         = [dictionary objectForKey:kSINSDictionaryKeySIAchievementPlistLevelsDictionary];
    achievement.details.moveSequenceArray               = [dictionary objectForKey:kSINSDictionaryKeySIAchievementPlistMoveSequenceArray];
    achievement.currentIndexOfMoveSequence              = 0;

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
    return [NSDictionary dictionaryWithObjects:gameCenterArray forKeys:[SISingletonAchievement arrayOfDictionaryKeyNames]];
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

/*AUTO UNIT TESTED*/
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

/*AUTO UNIT TESTED*/
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
    } else if ([stringCommand isEqualToString:kSIPlistMoveCommandTap]) {
        return SIMoveCommandTap;
    } else if ([stringCommand isEqualToString:kSIPlistMoveCommandStop]) {
        return SIMoveCommandStop;
    } else {
        return SIMoveCommandFallingMonkey;
    }
}

#pragma mark Storage Methods
/**
 Actually pulls from disk also reads from plist if the achievement is not in user defaults
 I think the question of this working is if nsuerdefaults is powerful enought to save a whole
 objective c class too... this may be a bad idea idk im not an expert...
 */
+ (NSMutableDictionary *)getAchievementDictionaryFromDisk {
    NSMutableDictionary *newDictionary = [NSMutableDictionary dictionary];
    for (NSString *achievementKey in [SISingletonAchievement arrayOfDictionaryKeyNames]) {
        SIAchievement *siAchievement = [SISingletonAchievement fetchAchievementWithKey:achievementKey];
        // TODO load from plist & store to userDefualts
        if (siAchievement == nil) {
            NSDictionary *plistDictionary = [SISingletonAchievement singletonAchievementLoadFromPlist];
            siAchievement = [SISingletonAchievement configureAchievementFromDictionary:[plistDictionary objectForKey:achievementKey] withKeyName:achievementKey];
            [SISingletonAchievement storeAchievement:siAchievement];
        }
        [newDictionary setObject:siAchievement forKey:achievementKey];
    }
    return newDictionary;
}

/**
 Path to store achievements with key `dictionaryKey`
 */
+ (NSString *)filePathForArchiveKey:(NSString *)acievementKey {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[acievementKey stringByAppendingPathExtension:kEDDirectoryAchievements]];
}
/**
 Store the achievement to disk
 */
+ (void)storeAchievement:(SIAchievement *)achievement {
    [NSKeyedArchiver archiveRootObject:achievement toFile:[SISingletonAchievement filePathForArchiveKey:achievement.details.dictionaryKey]];
}
/**
 Fetch achievement from disk
 */
+ (SIAchievement *)fetchAchievementWithKey:(NSString *)achievementKey {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[SISingletonAchievement filePathForArchiveKey:achievementKey]];
}

@end