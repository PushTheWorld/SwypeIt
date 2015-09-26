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
    NSString        *_achievementTypeString;
    
    SIAchievement   *_achievement;
    
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}
/**
 This configures the test class for testing different achievements... this will not work
 */
- (SIAchievement *)setConstantsForAchievementType:(SIAchievementType)achievementType {
    switch (achievementType) {
        case SIAchievementTypeAll:
            /*Do `all` Initalization*/
            _achievementMoveSequenceArray   = nil;
            
            _achievementDicKey              = @"testAchievementAll";
            _achievementHelpString          = @"Finish all Beginner achievements to complete this level!";
            _achievementPostfix             = @"Beginner ";
            _achievementPrefix              = @"";
            _achievementTypeString          = @"all";
            
            _achievementLevel1Amount        = 0;
            _achievementLevel1Reward        = 2;
            _achievementLevel2Amount        = 0;
            _achievementLevel2Reward        = 0;
            _achievementLevel3Amount        = 0;
            _achievementLevel3Reward        = 0;
            
            break;
        case SIAchievementTypeMove:
            /*Do Move Initalization*/
            _achievementMoveSequenceArray   = @[@"swype"];
            
            _achievementDicKey              = @"testAchievementMove";
            _achievementHelpString          = @"Perform enough of these moves to finish the challenge.";
            _achievementPostfix             = @"Perform ";
            _achievementPrefix              = @" moves";
            _achievementTypeString          = @"move";
            
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
            _achievementTypeString          = @"moveSequence";
            
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
            _achievementTypeString          = @"score";
            
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
                                                                                         level1Reward:_achievementLevel1Reward
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
                                                                                 postfix:_achievementPostfix
                                                                                  prefix:_achievementPrefix
                                                                              helpString:_achievementHelpString
                                                                         levelDictionary:_achievementLevelDictionary
                                                                       moveSequenceArray:_achievementMoveSequenceArray];
    
    return _achievement;
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPercentCompleteForAchievementLevel {
    XCTAssertEqualWithAccuracy(0.0f, [SISingletonAchievement percentCompleteForAchievement:SIAchievementLevelOne], 0.1);

    XCTAssertEqualWithAccuracy(ACHIEVEMENT_PERCENT_PER_LEVEL, [SISingletonAchievement percentCompleteForAchievement:SIAchievementLevelTwo], 0.1);

    XCTAssertEqualWithAccuracy(ACHIEVEMENT_PERCENT_PER_LEVEL * 2, [SISingletonAchievement percentCompleteForAchievement:SIAchievementLevelThree], 0.1);
    
    XCTAssertEqualWithAccuracy(100.0f, [SISingletonAchievement percentCompleteForAchievement:SIAchievementLevelDone], 0.1);

}

- (void)testAchievementLevelForPercentComplete {
    XCTAssertEqual(SIAchievementLevelOne, [SISingletonAchievement achievementLevelForPercentComplete:0.0f]);

    XCTAssertEqual(SIAchievementLevelOne, [SISingletonAchievement achievementLevelForPercentComplete:15.0f]);

    XCTAssertEqual(SIAchievementLevelOne, [SISingletonAchievement achievementLevelForPercentComplete:ACHIEVEMENT_PERCENT_PER_LEVEL - 1]);

    XCTAssertEqual(SIAchievementLevelTwo, [SISingletonAchievement achievementLevelForPercentComplete:ACHIEVEMENT_PERCENT_PER_LEVEL]);

    XCTAssertEqual(SIAchievementLevelTwo, [SISingletonAchievement achievementLevelForPercentComplete:45.0f]);

    XCTAssertEqual(SIAchievementLevelTwo, [SISingletonAchievement achievementLevelForPercentComplete:(ACHIEVEMENT_PERCENT_PER_LEVEL * 2) - 1]);
    
    XCTAssertEqual(SIAchievementLevelThree, [SISingletonAchievement achievementLevelForPercentComplete:ACHIEVEMENT_PERCENT_PER_LEVEL * 2]);

    XCTAssertEqual(SIAchievementLevelThree, [SISingletonAchievement achievementLevelForPercentComplete:(ACHIEVEMENT_PERCENT_PER_LEVEL * 3) - 15]);
    
    XCTAssertEqual(SIAchievementLevelThree, [SISingletonAchievement achievementLevelForPercentComplete:(ACHIEVEMENT_PERCENT_PER_LEVEL * 3) - 1]);
    
    XCTAssertEqual(SIAchievementLevelDone, [SISingletonAchievement achievementLevelForPercentComplete:ACHIEVEMENT_PERCENT_PER_LEVEL * 3]);

    XCTAssertEqual(SIAchievementLevelDone, [SISingletonAchievement achievementLevelForPercentComplete:100.0f]);
    
    XCTAssertEqual(SIAchievementLevelDone, [SISingletonAchievement achievementLevelForPercentComplete:ACHIEVEMENT_PERCENT_PER_LEVEL * 100]);

}

- (void)testAchievementLevelForPercentCompleteWithPercentCompleteForAchievementLevel {
    float percentInput,percentOutput = 0.0f;
    
    /*LEVEL 1*/
    SIAchievementLevel achievementLevel = [SISingletonAchievement achievementLevelForPercentComplete:percentInput];
    
    XCTAssertEqual(achievementLevel, SIAchievementLevelOne);
    
    percentOutput = [SISingletonAchievement percentCompleteForAchievement:achievementLevel];
    
    XCTAssertEqual(percentOutput, percentInput);
    
    /*LEVEL 2*/
    percentInput = ACHIEVEMENT_PERCENT_PER_LEVEL; //33
    
    achievementLevel = [SISingletonAchievement achievementLevelForPercentComplete:percentInput];
    
    XCTAssertEqual(achievementLevel, SIAchievementLevelTwo);
    
    percentOutput = [SISingletonAchievement percentCompleteForAchievement:achievementLevel];
    
    XCTAssertEqual(percentOutput, percentInput);

    /*LEVEL 3*/
    percentInput = ACHIEVEMENT_PERCENT_PER_LEVEL * 2; //66
    
    achievementLevel = [SISingletonAchievement achievementLevelForPercentComplete:percentInput];
    
    XCTAssertEqual(achievementLevel, SIAchievementLevelThree);
    
    percentOutput = [SISingletonAchievement percentCompleteForAchievement:achievementLevel];
    
    XCTAssertEqual(percentOutput, percentInput);
    
    /*LEVEL DONE*/
    percentInput = ACHIEVEMENT_PERCENT_PER_LEVEL * 3; //99
    
    achievementLevel = [SISingletonAchievement achievementLevelForPercentComplete:percentInput];
    
    XCTAssertEqual(achievementLevel, SIAchievementLevelDone);
    
    percentOutput = [SISingletonAchievement percentCompleteForAchievement:achievementLevel];
    
    XCTAssertEqual(percentOutput, percentInput + 1);
    
    /*LEVEL Done*/
    percentInput = 100; //100
    
    achievementLevel = [SISingletonAchievement achievementLevelForPercentComplete:percentInput];
    
    XCTAssertEqual(achievementLevel, SIAchievementLevelDone);
    
    percentOutput = [SISingletonAchievement percentCompleteForAchievement:achievementLevel];
    
    XCTAssertEqual(percentOutput, percentInput);

}

- (void)testConfigureAchievementFromDictionary {
    [self setConstantsForAchievementType:SIAchievementTypeScore];

    SIAchievement *newAchievement = [SISingletonAchievement configureAchievementFromDictionary:_achievementDictionary withKeyName:_achievementDicKey];
    
    XCTAssertEqual(_achievement.currentAmount, newAchievement.currentAmount);
    
    XCTAssertEqual(_achievement.currentLevel, newAchievement.currentLevel);
    
    XCTAssertEqual(_achievement.details.completed, newAchievement.details.completed);
    
    XCTAssertEqual(_achievement.details.type, newAchievement.details.type);

    XCTAssertEqual(_achievement.currentIndexOfMoveSequence, newAchievement.currentIndexOfMoveSequence);

    XCTAssertEqualObjects(_achievement.details.dictionaryKey, newAchievement.details.dictionaryKey);

    XCTAssertEqualObjects(_achievement.details.helpString, newAchievement.details.helpString);

    XCTAssertEqualObjects(_achievement.details.prefixString, newAchievement.details.prefixString);
    
    XCTAssertEqualObjects(_achievement.details.postfixString, newAchievement.details.postfixString);

    XCTAssertEqualObjects(_achievement.levelDictionary, newAchievement.levelDictionary);
    
    XCTAssertEqualObjects(_achievement.details.moveSequenceArray, newAchievement.details.moveSequenceArray);
    
}

- (void)testConfigureAchievementFromNILDictionary {
    SIAchievement *newAchievement = [SISingletonAchievement configureAchievementFromDictionary:nil withKeyName:_achievementDicKey];
    
    XCTAssertNil(newAchievement); //better make sure that shit is nil! This is also a good way to make sure the

}

- (void)testIsNewLevelAndUpdateCurrentLevelForAchievement {
    [self setConstantsForAchievementType:SIAchievementTypeScore];
    
    XCTAssertEqual([SISingletonAchievement isNewLevelAndUpdateCurrentLevelForAchievement:_achievement], NO);
    
    int amount = [SISingletonAchievement amountForAchievementLevel:SIAchievementLevelOne forAchievement:_achievement];

    _achievement.currentAmount = amount + 1;

    XCTAssertEqual([SISingletonAchievement isNewLevelAndUpdateCurrentLevelForAchievement:_achievement], YES);
    XCTAssertEqual(_achievement.currentLevel, SIAchievementLevelTwo);
    
    amount = [SISingletonAchievement amountForAchievementLevel:SIAchievementLevelThree forAchievement:_achievement];
    
    _achievement.currentAmount = amount + 1;
    
    XCTAssertEqual([SISingletonAchievement isNewLevelAndUpdateCurrentLevelForAchievement:_achievement], YES);
    XCTAssertEqual(_achievement.currentLevel, SIAchievementLevelDone); //test to make sure the level got updated

}

- (void)testAchievementGetAchievementLevelForAchievement {
    /*Setup Constants for Score Type*/
    [self setConstantsForAchievementType:SIAchievementTypeScore];
    
    XCTAssertEqual(SIAchievementLevelOne, [SISingletonAchievement getAchievementLevelForAchievement:_achievement]);
    
    int amount = [SISingletonAchievement amountForAchievementLevel:SIAchievementLevelOne forAchievement:_achievement];
    
    _achievement.currentAmount = amount + 1;
    
    XCTAssertEqual(SIAchievementLevelTwo, [SISingletonAchievement getAchievementLevelForAchievement:_achievement]);
    
    amount = [SISingletonAchievement amountForAchievementLevel:SIAchievementLevelTwo forAchievement:_achievement];
    
    _achievement.currentAmount = amount + 1;
    
    XCTAssertEqual(SIAchievementLevelThree, [SISingletonAchievement getAchievementLevelForAchievement:_achievement]);
    
    amount = [SISingletonAchievement amountForAchievementLevel:SIAchievementLevelThree forAchievement:_achievement];
    
    _achievement.currentAmount = amount + 1;
    
    XCTAssertEqual(SIAchievementLevelDone, [SISingletonAchievement getAchievementLevelForAchievement:_achievement]);
    
}

- (void)testRewardForAchievementLevelForAchievement {
    [self setConstantsForAchievementType:SIAchievementTypeScore];

    XCTAssertEqual([SISingletonAchievement rewardForAchievementLevel:SIAchievementLevelOne forAchievement:_achievement], _achievementLevel1Reward);

    XCTAssertEqual([SISingletonAchievement rewardForAchievementLevel:SIAchievementLevelTwo forAchievement:_achievement], _achievementLevel2Reward);

    XCTAssertEqual([SISingletonAchievement rewardForAchievementLevel:SIAchievementLevelThree forAchievement:_achievement], _achievementLevel3Reward);

    XCTAssertEqual([SISingletonAchievement rewardForAchievementLevel:SIAchievementLevelDone forAchievement:_achievement], _achievementLevel3Reward);

}


- (void)testAmountForAchievementLevelForAchievement {
    [self setConstantsForAchievementType:SIAchievementTypeScore];
    
    XCTAssertEqual([SISingletonAchievement amountForAchievementLevel:SIAchievementLevelOne forAchievement:_achievement], _achievementLevel1Amount);
    
    XCTAssertEqual([SISingletonAchievement amountForAchievementLevel:SIAchievementLevelTwo forAchievement:_achievement], _achievementLevel2Amount);
    
    XCTAssertEqual([SISingletonAchievement amountForAchievementLevel:SIAchievementLevelThree forAchievement:_achievement], _achievementLevel3Amount);
    
    XCTAssertEqual([SISingletonAchievement amountForAchievementLevel:SIAchievementLevelDone forAchievement:_achievement], _achievementLevel3Amount);
    
}

- (void)testIsAchievementKeyAll {
    XCTAssertEqual(YES, [SISingletonAchievement isAchievementKeyAll:kSIAchievementIDChallengeBeginnerAll]);

    XCTAssertEqual(YES, [SISingletonAchievement isAchievementKeyAll:kSIAchievementIDChallengeIntermediateAll]);

    XCTAssertEqual(YES, [SISingletonAchievement isAchievementKeyAll:kSIAchievementIDChallengeProAll]);
    
    XCTAssertEqual(YES, [SISingletonAchievement isAchievementKeyAll:kSIAchievementIDChallengeMasterAll]);

    XCTAssertEqual(NO, [SISingletonAchievement isAchievementKeyAll:@"taco"]);

    XCTAssertEqual(NO, [SISingletonAchievement isAchievementKeyAll:kSIAchievementIDChallengeMaster1]);

    XCTAssertEqual(NO, [SISingletonAchievement isAchievementKeyAll:kSIPlistTypeMoveSequence]);
    
    XCTAssertEqual(NO, [SISingletonAchievement isAchievementKeyAll:kSIPlistTypeScore]);
}

- (void)testDictionaryKeyForSIAchievementLevel {
    XCTAssertEqualObjects(kSINSDictionaryKeySIAchievementPlistLevel1, @"level1");
    XCTAssertEqualObjects(kSINSDictionaryKeySIAchievementPlistLevel1, [SISingletonAchievement dictionaryKeyForSIAchievementLevel:SIAchievementLevelOne]);

    XCTAssertEqualObjects(kSINSDictionaryKeySIAchievementPlistLevel2, @"level2");
    XCTAssertEqualObjects(kSINSDictionaryKeySIAchievementPlistLevel2, [SISingletonAchievement dictionaryKeyForSIAchievementLevel:SIAchievementLevelTwo]);
    
    XCTAssertEqualObjects(kSINSDictionaryKeySIAchievementPlistLevel3, @"level3");
    XCTAssertEqualObjects(kSINSDictionaryKeySIAchievementPlistLevel3, [SISingletonAchievement dictionaryKeyForSIAchievementLevel:SIAchievementLevelThree]);
    
    //throw some shit at it... see what happens
    XCTAssertEqualObjects(kSINSDictionaryKeySIAchievementPlistLevel3, [SISingletonAchievement dictionaryKeyForSIAchievementLevel:SIAchievementLevelDone]);
    XCTAssertEqualObjects(kSINSDictionaryKeySIAchievementPlistLevel3, [SISingletonAchievement dictionaryKeyForSIAchievementLevel:123]);

}

- (void)testLevelDictionaryForAchievement {
    [self setConstantsForAchievementType:SIAchievementTypeScore];

    XCTAssertEqualObjects([_achievementLevelDictionary objectForKey:@"level1"], [SISingletonAchievement levelDictionaryForAchievement:_achievement atLevel:SIAchievementLevelOne]);
    XCTAssertEqualObjects([[_achievementLevelDictionary objectForKey:@"level1"] objectForKey:kSINSDictionaryKeySIAchievementPlistAmount], [[SISingletonAchievement levelDictionaryForAchievement:_achievement atLevel:SIAchievementLevelOne] objectForKey:kSINSDictionaryKeySIAchievementPlistAmount]);

    XCTAssertEqualObjects([_achievementLevelDictionary objectForKey:@"level2"], [SISingletonAchievement levelDictionaryForAchievement:_achievement atLevel:SIAchievementLevelTwo]);
    XCTAssertEqualObjects([[_achievementLevelDictionary objectForKey:@"level2"] objectForKey:kSINSDictionaryKeySIAchievementPlistAmount], [[SISingletonAchievement levelDictionaryForAchievement:_achievement atLevel:SIAchievementLevelTwo] objectForKey:kSINSDictionaryKeySIAchievementPlistAmount]);

    XCTAssertEqualObjects([_achievementLevelDictionary objectForKey:@"level3"], [SISingletonAchievement levelDictionaryForAchievement:_achievement atLevel:SIAchievementLevelThree]);
    XCTAssertEqualObjects([[_achievementLevelDictionary objectForKey:@"level3"] objectForKey:kSINSDictionaryKeySIAchievementPlistAmount], [[SISingletonAchievement levelDictionaryForAchievement:_achievement atLevel:SIAchievementLevelThree] objectForKey:kSINSDictionaryKeySIAchievementPlistAmount]);

}

- (void)testMoveCommandForString {
    XCTAssertEqual(SIMoveCommandTap, [SISingletonAchievement moveCommandForString:@"tap"]);

    XCTAssertEqual(SIMoveCommandSwype, [SISingletonAchievement moveCommandForString:@"swype"]);
    
    XCTAssertEqual(SIMoveCommandPinch, [SISingletonAchievement moveCommandForString:@"pinch"]);
    
    XCTAssertEqual(SIMoveCommandShake, [SISingletonAchievement moveCommandForString:@"shake"]);

    XCTAssertEqual(SIMoveCommandFallingMonkey, [SISingletonAchievement moveCommandForString:@"sksj;adf;n"]);

}

- (void)testAchievementTypeForTypeString {
    XCTAssertEqual(SIAchievementTypeAll, [SISingletonAchievement achievementTypeForTypeString:@"all"]);

    XCTAssertEqual(SIAchievementTypeScore, [SISingletonAchievement achievementTypeForTypeString:@"score"]);

    XCTAssertEqual(SIAchievementTypeMove, [SISingletonAchievement achievementTypeForTypeString:@"move"]);

    XCTAssertEqual(SIAchievementTypeMoveSequence, [SISingletonAchievement achievementTypeForTypeString:@"moveSequence"]);
    
    XCTAssertEqual(SIAchievementTypeScore, [SISingletonAchievement achievementTypeForTypeString:@"kdkfkfkdked"]);
}



#pragma mark - Private Class Functions for Testing
+ (SIAchievement *)createAchievementType:(SIAchievementType)type dicKey:(NSString *)dicKey postfix:(NSString *)postfixString prefix:(NSString *)prefixString helpString:(NSString *)helpString levelDictionary:(NSDictionary *)levelDictionary moveSequenceArray:(NSArray *)moveSequenceArray {
    SIAchievement *achievement = [[SIAchievement alloc] init];
    
    achievement.currentLevel                            = SIAchievementLevelOne;
    achievement.currentAmount                           = 0;
    achievement.details.completed                       = NO;
    achievement.details.type                            = type;
    achievement.details.dictionaryKey                   = dicKey;
    
    achievement.details.helpString                      = helpString;
    achievement.details.postfixString                   = postfixString;
    achievement.details.prefixString                    = prefixString;
    achievement.levelDictionary                         = levelDictionary;
    
    achievement.details.moveSequenceArray               = moveSequenceArray;
    achievement.currentIndexOfMoveSequence              = 0;
    
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
