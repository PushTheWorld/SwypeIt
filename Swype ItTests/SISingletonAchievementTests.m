//
//  SISingletonAchievementTests.m
//  Swype It
//
//  Created by Andrew Keller on 9/10/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SISingletonAchievement.h"

@interface SISingletonAchievementTests : XCTestCase

@end

@implementation SISingletonAchievementTests {

    int              _achievementCompletionReward;
    int              _achievementLevel1Amount;
    int              _achievementLevel1Reward;
    int              _achievementLevel2Amount;
    int              _achievementLevel2Reward;
    int              _achievementLevel3Amount;
    int              _achievementLevel3Reward;
    
    NSArray         *_achievementMoveSequenceArray;
    
    NSDictionary    *_achievementDictionary;
    NSDictionary    *_achievementLevelDictionary;
    
    NSString        *_achievementDicKey;
    NSString        *_achievementHelpString;
    NSString        *_achievementPostfix;
    NSString        *_achievementPrefix;
    NSString        *_achievementTitle;
    NSString        *_achievementTypeString;
    
    SIAchievement   *_achievement;
    
    SIMoveCommand    _achievementMoveCommand;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)setConstantsForAchievementType:(SIAchievementType)achievementType {
    switch (achievementType) {
        case SIAchievementTypeAll:
            /*Do `all` Initalization*/
            _achievementCompletionReward    = 2;
            _achievementTypeString          = @"all";
            _achievementTitle               = @"Beginner";
            
            break;
        case SIAchievementTypeMove:
            /*Do Move Initalization*/
            _achievementMoveSequenceArray   = nil;
            
            _achievementDicKey              = @"testAchievementMove";
            _achievementHelpString          = @"Perform enough of these moves to finish the challenge.";
            _achievementPostfix             = @"Perform ";
            _achievementPrefix              = @" moves";
            _achievementTitle               = nil;
            _achievementTypeString          = @"move";
            
            _achievementCompletionReward    = 0;
            _achievementLevel1Amount        = 10;
            _achievementLevel1Reward        = 1;
            _achievementLevel2Amount        = 20;
            _achievementLevel2Reward        = 1;
            _achievementLevel3Amount        = 30;
            _achievementLevel3Reward        = 1;
            
            break;
        case SIAchievementTypeMoveSequence:
            /*Do Move Sequence Initalization*/
            _achievementMoveSequenceArray   = @[@"swype",@"swype",@"stop"];
            
            _achievementDicKey              = @"testAchievementMoveSequence";
            _achievementHelpString          = @"Every time one of these sequences are performed you will get credit for it";
            _achievementPostfix             = @"Do ";
            _achievementPrefix              = nil;
            _achievementTitle               = nil;
            _achievementTypeString          = @"moveSequence";
            
            _achievementCompletionReward    = 0;
            _achievementLevel1Amount        = 10;
            _achievementLevel1Reward        = 1;
            _achievementLevel2Amount        = 20;
            _achievementLevel2Reward        = 1;
            _achievementLevel3Amount        = 30;
            _achievementLevel3Reward        = 1;

            break;
        case SIAchievementTypeScore:
            /*Do Score Initalization*/
            _achievementMoveSequenceArray   = nil;
            
            _achievementDicKey              = @"testAchievementScore";
            _achievementHelpString          = @"Score more than the amount of points listed for the challenge in a single game round.";
            _achievementPostfix             = @"Score over ";
            _achievementPrefix              = @" points";
            _achievementTitle               = nil;
            _achievementTypeString          = @"score";
            
            _achievementCompletionReward    = 0;
            _achievementLevel1Amount        = 100;
            _achievementLevel1Reward        = 1;
            _achievementLevel2Amount        = 200;
            _achievementLevel2Reward        = 1;
            _achievementLevel3Amount        = 300;
            _achievementLevel3Reward        = 1;
            
            break;
        default:
            NSLog(@"What the fuck happened to make this happen??");
            break;
    }
    _achievementLevelDictionary     = [SISingletonAchievementTests createLevelsDictionaryLevel1Amount:_achievementLevel1Amount
                                                                                         level1Reward:_achievementLevel1Amount
                                                                                         level2Amount:_achievementLevel2Amount
                                                                                         level2Reward:_achievementLevel2Reward
                                                                                         level3Amount:_achievementLevel3Amount
                                                                                         level3Reward:_achievementLevel3Reward];
    
    _achievementDictionary          = [SISingletonAchievementTests createAchievementDictionaryHelp:_achievementHelpString
                                                                                            prefix:_achievementPrefix
                                                                                           postfix:_achievementPostfix
                                                                                        typeString:_achievementTypeString
                                                                                   levelDictionary:_achievementLevelDictionary];
    
    _achievement                    = [SISingletonAchievementTests createAchievementType:SIAchievementTypeScore
                                                                                  dicKey:_achievementDicKey
                                                                                   title:_achievementTitle
                                                                                 postfix:_achievementPostfix
                                                                                  prefix:_achievementPrefix
                                                                              helpString:_achievementHelpString
                                                                        completionReward:_achievementCompletionReward
                                                                         levelDictionary:_achievementLevelDictionary
                                                                             moveCommand:_achievementMoveCommand
                                                                       moveSequenceArray:_achievementMoveSequenceArray];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testAchievementScore {
    /*Setup Constants for Score Type*/
    [self setConstantsForAchievementType:SIAchievementTypeScore];
    
    
}


#pragma mark - Private Class Functions for Testing
+ (SIAchievement *)createAchievementType:(SIAchievementType)type dicKey:(NSString *)dicKey title:(NSString *)title postfix:(NSString *)postfixString prefix:(NSString *)prefixString helpString:(NSString *)helpString completionReward:(int)completionReward levelDictionary:(NSDictionary *)levelDictionary moveCommand:(SIMoveCommand)moveCommand moveSequenceArray:(NSArray *)moveSequenceArray {
    SIAchievement *achievement = [[SIAchievement alloc] init];
    
    achievement.currentLevel                            = SIAchievementLevelNew;
    achievement.currentAmount                           = 0;
    achievement.details.completed                       = NO;
    achievement.details.type                            = type;
    achievement.details.dictionaryKey                   = dicKey;
    
    if (achievement.details.type == SIAchievementTypeAll) {
        achievement.title                               = title;
        achievement.details.completionReward            = completionReward;
        return achievement;
    }
    
    achievement.details.helpString                      = helpString;
    achievement.details.postfixString                   = postfixString;
    achievement.details.prefixString                    = prefixString;
    achievement.levelDictionary                         = levelDictionary;
    
    if (achievement.details.type == SIAchievementTypeMove) {
        achievement.currentMoveCommand                  = moveCommand;
    }
    
    if (achievement.details.type == SIAchievementTypeMoveSequence) {
        achievement.details.moveSequenceArray           = moveSequenceArray;
        achievement.currentIndexOfMoveSequenceCommand   = 0;
    }
    
    return achievement;
}

+ (NSDictionary *)createAchievementDictionaryHelp:(NSString *)helpString prefix:(NSString *)prefixString postfix:(NSString *)postfixString typeString:(NSString *)typeString levelDictionary:(NSDictionary *)levelDictionary {
    return @{kSINSDictionaryKeySIAchievementPlistHelpString : helpString,
             kSINSDictionaryKeySIAchievementPlistPrefixString : prefixString,
             kSINSDictionaryKeySIAchievementPlistPostfixString : postfixString,
             kSINSDictionaryKeySIAchievementPlistTypeString      : typeString,
             kSINSDictionaryKeySIAchievementPlistLevelsDictionary : levelDictionary};
}

+ (NSDictionary *)createLevelsDictionaryLevel1Amount:(int)level1Amount level1Reward:(int)level1Reward level2Amount:(int)level2Amount level2Reward:(int)level2Reward level3Amount:(int)level3Amount level3Reward:(int)level3Reward {
    return @{kSINSDictionaryKeySIAchievementPlistLevel1 : @{kSINSDictionaryKeySIAchievementPlistAmount  : @(level1Amount),
                                                            kSINSDictionaryKeySIAchievementPlistReward  : @(level1Reward)},
             kSINSDictionaryKeySIAchievementPlistLevel2 : @{kSINSDictionaryKeySIAchievementPlistAmount  : @(level2Amount),
                                                            kSINSDictionaryKeySIAchievementPlistReward  : @(level2Reward)},
             kSINSDictionaryKeySIAchievementPlistLevel3 : @{kSINSDictionaryKeySIAchievementPlistAmount  : @(level3Amount),
                                                            kSINSDictionaryKeySIAchievementPlistReward  : @(level3Reward)}};
}

@end
