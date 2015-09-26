//
//  GameTests.m
//  Swype It
//
//  Created by Andrew Keller on 7/11/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is the test file for Game
//
// Local Controller Import
#import "SIGame.h"
// Framework Import
#import <OCMock/OCMock.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "CCTestingUserDefaults.h"
// Category Import
// Support/Data Class Imports
#import "SIConstants.h"
// Other Imports


@interface GameTests : XCTestCase

@end

@implementation GameTests {
    NSUserDefaults *_defaults;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _defaults    = [NSUserDefaults transientDefaults];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetCurrentScore {
    
    float score = 0.0f;
    
    while (score < 11999.0f) {
        
        float levelscore = [SIGame nextLevelForScore:score];
        
        if (score < LEVEL1) {
            XCTAssertEqual(levelscore, LEVEL1);
        
        } else if (score < LEVEL2) {
            XCTAssertEqual(levelscore, LEVEL2);
        
        } else if (score < LEVEL3) {
            XCTAssertEqual(levelscore, LEVEL3);
        
        } else if (score < LEVEL4) {
            XCTAssertEqual(levelscore, LEVEL4);
        
        } else if (score < LEVEL5) {
            XCTAssertEqual(levelscore, LEVEL5);
        
        } else if (score < LEVEL6) {
            XCTAssertEqual(levelscore, LEVEL6);

        } else if (score < LEVEL7) {
            XCTAssertEqual(levelscore, LEVEL7);

        } else if (score < LEVEL8) {
            XCTAssertEqual(levelscore, LEVEL8);

        } else if (score < LEVEL9) {
            XCTAssertEqual(levelscore, LEVEL9);

        } else if (score < LEVEL10) {
            XCTAssertEqual(levelscore, LEVEL10);

        } else if (score < LEVEL11) {
            XCTAssertEqual(levelscore, LEVEL11);

        } else if (score < LEVEL12) {
            XCTAssertEqual(levelscore, LEVEL12);

        } else if (score < LEVEL13) {
            XCTAssertEqual(levelscore, LEVEL13);

        } else if (score < LEVEL14) {
            XCTAssertEqual(levelscore, LEVEL14);

        } else if (score < LEVEL15) {
            XCTAssertEqual(levelscore, LEVEL15);

        } else if (score < LEVEL16) {
            XCTAssertEqual(levelscore, LEVEL16);

        } else if (score < LEVEL17) {
            XCTAssertEqual(levelscore, LEVEL17);

        } else if (score < LEVEL18) {
            XCTAssertEqual(levelscore, LEVEL18);

        } else if (score < LEVEL19) {
            XCTAssertEqual(levelscore, LEVEL19);

        } else if (score < LEVEL20) {
            XCTAssertEqual(levelscore, LEVEL20);
            
        } else if (score < LEVEL21) {
            XCTAssertEqual(levelscore, LEVEL21);
            
        } else if (score < LEVEL22) {
            XCTAssertEqual(levelscore, LEVEL22);
        }
        
        score = score + 25;
    }

}

- (void)testLevelString {
    float score = 0.0f;
    
    while (score < 11999.0f) {
        
        NSString *levelString = [SIGame currentLevelStringForScore:score];
        
        if (score < LEVEL1) {
            XCTAssertEqualObjects(levelString, @"Level 1");
            
        } else if (score < LEVEL2) {
            XCTAssertEqualObjects(levelString, @"Level 2");
            
        } else if (score < LEVEL3) {
            XCTAssertEqualObjects(levelString, @"Level 3");
            
        } else if (score < LEVEL4) {
            XCTAssertEqualObjects(levelString, @"Level 4");
            
        } else if (score < LEVEL5) {
            XCTAssertEqualObjects(levelString, @"Level 5");
            
        } else if (score < LEVEL6) {
            XCTAssertEqualObjects(levelString, @"Level 6");
            
        } else if (score < LEVEL7) {
            XCTAssertEqualObjects(levelString, @"Level 7");
            
        } else if (score < LEVEL8) {
            XCTAssertEqualObjects(levelString, @"Level 8");
            
        } else if (score < LEVEL9) {
            XCTAssertEqualObjects(levelString, @"Level 9");
            
        } else if (score < LEVEL10) {
            XCTAssertEqualObjects(levelString, @"Level 10");
            
        } else if (score < LEVEL11) {
            XCTAssertEqualObjects(levelString, @"Level 11");
            
        } else if (score < LEVEL12) {
            XCTAssertEqualObjects(levelString, @"Level 12");
            
        } else if (score < LEVEL13) {
            XCTAssertEqualObjects(levelString, @"Level 13");
            
        } else if (score < LEVEL14) {
            XCTAssertEqualObjects(levelString, @"Level 14");
            
        } else if (score < LEVEL15) {
            XCTAssertEqualObjects(levelString, @"Level 15");
            
        } else if (score < LEVEL16) {
            XCTAssertEqualObjects(levelString, @"Level 16");
            
        } else if (score < LEVEL17) {
            XCTAssertEqualObjects(levelString, @"Level 17");
            
        } else if (score < LEVEL18) {
            XCTAssertEqualObjects(levelString, @"Level 18");
            
        } else if (score < LEVEL19) {
            XCTAssertEqualObjects(levelString, @"Level 19");
            
        } else if (score < LEVEL20) {
            XCTAssertEqualObjects(levelString, @"Level 20");
            
        } else if (score < LEVEL21) {
            XCTAssertEqualObjects(levelString, @"Level 21");
            
        } else if (score < LEVEL22) {
            XCTAssertEqualObjects(levelString, @"Level 22");
        }
        
        score = score + 25;
    }
}
- (void)testStringForMove {
    XCTAssertEqualObjects(kSIMoveCommandPinch, [SIGame stringForMove:SIMoveCommandPinch]);
    
    XCTAssertEqualObjects(kSIMoveCommandTap, [SIGame stringForMove:SIMoveCommandTap]);
    
    XCTAssertEqualObjects(kSIMoveCommandSwype, [SIGame stringForMove:SIMoveCommandSwype]);
    
    XCTAssertEqualObjects(kSIMoveCommandShake, [SIGame stringForMove:SIMoveCommandShake]);
}

//- (void)testGetRandomMoveForRapidFire {
//    /*Check to make the Rapid Fire Returns Tap*/
//    SIMoveCommand move = [SIGame getRandomMoveForGameMode:SIGameModeOneHand];
//    XCTAssertEqual(move, SIMoveCommandTap);
//}
- (void)testGetRandomMoveForOneHandGameMode {
    for (int i = 0; i < 50; i++) {
        SIMoveCommand move = [SIGame getRandomMoveForGameMode:SIGameModeOneHand];
        XCTAssertNotEqual(move, SIMoveCommandPinch);
    }
}
- (void)testGetRandomMoveForTwoHandGameMode {
    for (int i = 0; i < 50; i++) {
        SIMoveCommand move = [SIGame getRandomMoveForGameMode:SIGameModeTwoHand];
        XCTAssertNotEqual(move, SIMoveCommandShake);
    }
}

- (void)testLifeCostForNumberOfTimesContinued {
    XCTAssertEqual(SIContinueLifeCost1, [SIGame lifeCostForNumberOfTimesContinued:1]);
    XCTAssertEqual(SIContinueLifeCost2, [SIGame lifeCostForNumberOfTimesContinued:2]);
    XCTAssertEqual(SIContinueLifeCost3, [SIGame lifeCostForNumberOfTimesContinued:3]);
    XCTAssertEqual(SIContinueLifeCost4, [SIGame lifeCostForNumberOfTimesContinued:4]);
    XCTAssertEqual(SIContinueLifeCost5, [SIGame lifeCostForNumberOfTimesContinued:5]);
    XCTAssertEqual(SIContinueLifeCost6, [SIGame lifeCostForNumberOfTimesContinued:6]);
    XCTAssertEqual(SIContinueLifeCost7, [SIGame lifeCostForNumberOfTimesContinued:7]);
    XCTAssertEqual(SIContinueLifeCost8, [SIGame lifeCostForNumberOfTimesContinued:8]);
    XCTAssertEqual(SIContinueLifeCost9, [SIGame lifeCostForNumberOfTimesContinued:9]);
    XCTAssertEqual(SIContinueLifeCost10, [SIGame lifeCostForNumberOfTimesContinued:10]);
    XCTAssertEqual(SIContinueLifeCost11, [SIGame lifeCostForNumberOfTimesContinued:11]);
    XCTAssertEqual(SIContinueLifeCost12, [SIGame lifeCostForNumberOfTimesContinued:12]);
    XCTAssertEqual(SIContinueLifeCost13, [SIGame lifeCostForNumberOfTimesContinued:13]);
    XCTAssertEqual(SIContinueLifeCost14, [SIGame lifeCostForNumberOfTimesContinued:14]);
    XCTAssertEqual(SIContinueLifeCost15, [SIGame lifeCostForNumberOfTimesContinued:15]);
    XCTAssertEqual(SIContinueLifeCost16, [SIGame lifeCostForNumberOfTimesContinued:16]);
    XCTAssertEqual(SIContinueLifeCost17, [SIGame lifeCostForNumberOfTimesContinued:17]);
    XCTAssertEqual(SIContinueLifeCost18, [SIGame lifeCostForNumberOfTimesContinued:18]);
    XCTAssertEqual(SIContinueLifeCost19, [SIGame lifeCostForNumberOfTimesContinued:19]);
    XCTAssertEqual(SIContinueLifeCost20, [SIGame lifeCostForNumberOfTimesContinued:20]);
    XCTAssertEqual(SIContinueLifeCost21, [SIGame lifeCostForNumberOfTimesContinued:21]);
}
- (void)testAdCountForNumberOfTimesContinued {
    XCTAssertEqual(SIContinueAdCount1, [SIGame adCountForNumberOfTimesContinued:1]);
    XCTAssertEqual(SIContinueAdCount2, [SIGame adCountForNumberOfTimesContinued:2]);
    XCTAssertEqual(SIContinueAdCount3, [SIGame adCountForNumberOfTimesContinued:3]);
    XCTAssertEqual(SIContinueAdCount4, [SIGame adCountForNumberOfTimesContinued:4]);
    XCTAssertEqual(SIContinueAdCount5, [SIGame adCountForNumberOfTimesContinued:5]);
    XCTAssertEqual(SIContinueAdCount6, [SIGame adCountForNumberOfTimesContinued:6]);
    XCTAssertEqual(SIContinueAdCount7, [SIGame adCountForNumberOfTimesContinued:7]);
    XCTAssertEqual(SIContinueAdCount8, [SIGame adCountForNumberOfTimesContinued:8]);
    XCTAssertEqual(SIContinueAdCount9, [SIGame adCountForNumberOfTimesContinued:9]);
    XCTAssertEqual(SIContinueAdCount10, [SIGame adCountForNumberOfTimesContinued:10]);
    XCTAssertEqual(SIContinueAdCount11, [SIGame adCountForNumberOfTimesContinued:11]);
    XCTAssertEqual(SIContinueAdCount12, [SIGame adCountForNumberOfTimesContinued:12]);
    XCTAssertEqual(SIContinueAdCount13, [SIGame adCountForNumberOfTimesContinued:13]);
    XCTAssertEqual(SIContinueAdCount14, [SIGame adCountForNumberOfTimesContinued:14]);
    XCTAssertEqual(SIContinueAdCount15, [SIGame adCountForNumberOfTimesContinued:15]);
    XCTAssertEqual(SIContinueAdCount16, [SIGame adCountForNumberOfTimesContinued:16]);
    XCTAssertEqual(SIContinueAdCount17, [SIGame adCountForNumberOfTimesContinued:17]);
    XCTAssertEqual(SIContinueAdCount18, [SIGame adCountForNumberOfTimesContinued:18]);
    XCTAssertEqual(SIContinueAdCount19, [SIGame adCountForNumberOfTimesContinued:19]);
    XCTAssertEqual(SIContinueAdCount20, [SIGame adCountForNumberOfTimesContinued:20]);
    XCTAssertEqual(SIContinueAdCount21, [SIGame adCountForNumberOfTimesContinued:21]);
}
- (void)testGameFreePrizeNoQuick {
    NSDate *currentDate = [NSDate date];
    
    NSDate *lastPrizeGivenDate = [currentDate dateByAddingTimeInterval:-1 * (1)]; //1 second ago
    
    SIFreePrizeType freePrize  = [SIGame gamePrizeForCurrentDate:currentDate lastPrizeGivenDate:lastPrizeGivenDate];
    
    XCTAssertEqual(freePrize, SIFreePrizeTypeNone);
}

- (void)testGameFreePrizeNo {
    NSDate *currentDate = [NSDate date];
    
    NSDate *lastPrizeGivenDate = [currentDate dateByAddingTimeInterval:-1 * (60 * 60 * 23)]; //23 hours ago
    
    SIFreePrizeType freePrize  = [SIGame gamePrizeForCurrentDate:currentDate lastPrizeGivenDate:lastPrizeGivenDate];
    
    XCTAssertEqual(freePrize, SIFreePrizeTypeNone);
}

- (void)testGameFreePrizeYesConsecutiveBorderFront {
    NSDate *currentDate = [NSDate date];
    
    NSDate *lastPrizeGivenDate = [currentDate dateByAddingTimeInterval:-1 * (60 * 60 * 24)]; //24 hours ago
    
    SIFreePrizeType freePrize  = [SIGame gamePrizeForCurrentDate:currentDate lastPrizeGivenDate:lastPrizeGivenDate];
    
    XCTAssertEqual(freePrize, SIFreePrizeTypeConsecutive);
}

- (void)testGameFreePrizeYesConsecutiveMiddle {
    NSDate *currentDate = [NSDate date];
    
    NSDate *lastPrizeGivenDate = [currentDate dateByAddingTimeInterval:-1 * (60 * 60 * 36)]; //36 hours ago
    
    SIFreePrizeType freePrize  = [SIGame gamePrizeForCurrentDate:currentDate lastPrizeGivenDate:lastPrizeGivenDate];
    
    XCTAssertEqual(freePrize, SIFreePrizeTypeConsecutive);
}

- (void)testGameFreePrizeYesConsecutiveBorderEnd {
    NSDate *currentDate = [NSDate date];
    
    NSDate *lastPrizeGivenDate = [currentDate dateByAddingTimeInterval:-1 * ((60 * 60 * 47) + (60 * 59))]; //47 hours 59 minutes ago
    
    SIFreePrizeType freePrize  = [SIGame gamePrizeForCurrentDate:currentDate lastPrizeGivenDate:lastPrizeGivenDate];
    
    XCTAssertEqual(freePrize, SIFreePrizeTypeConsecutive);
}

- (void)testGameFreePrizeYesBorderFront {
    NSDate *currentDate = [NSDate date];
    
    NSDate *lastPrizeGivenDate = [currentDate dateByAddingTimeInterval:-1 * (60 * 60 * 48)]; //48 hours ago
    
    SIFreePrizeType freePrize  = [SIGame gamePrizeForCurrentDate:currentDate lastPrizeGivenDate:lastPrizeGivenDate];
    
    XCTAssertEqual(freePrize, SIFreePrizeTypeNonConsecutive);
}

- (void)testGameFreePrizeYesClear {
    NSDate *currentDate = [NSDate date];
    
    NSDate *lastPrizeGivenDate = [currentDate dateByAddingTimeInterval:-1 * (60 * 60 * 100)]; //100 hours ago
    
    SIFreePrizeType freePrize  = [SIGame gamePrizeForCurrentDate:currentDate lastPrizeGivenDate:lastPrizeGivenDate];
    
    XCTAssertEqual(freePrize, SIFreePrizeTypeNonConsecutive);
}

- (void)testSecondsInDay {
    XCTAssertEqual(SECONDS_IN_DAY, 60*60*24);
}

- (void)testStateStringNameForGameState {
    /*Idle*/
    XCTAssertEqualObjects(kSITKStateMachineStateGameIdle, [SIGame stateStringNameForGameState:SIGameStateIdle]);
    
    /*Pause*/
    XCTAssertEqualObjects(kSITKStateMachineStateGamePaused, [SIGame stateStringNameForGameState:SIGameStatePause]);

    /*Paying For Life*/
    XCTAssertEqualObjects(kSITKStateMachineStateGamePayingForContinue, [SIGame stateStringNameForGameState:SIGameStatePayingForContinue]);
    
    /*Popup Continue*/
    XCTAssertEqualObjects(kSITKStateMachineStateGamePopupContinue, [SIGame stateStringNameForGameState:SIGameStatePopupContinue]);
    
    /*Processing Move*/
    XCTAssertEqualObjects(kSITKStateMachineStateGameProcessingMove, [SIGame stateStringNameForGameState:SIGameStateProcessingMove]);
    
    /*Start*/
    XCTAssertEqualObjects(kSITKStateMachineStateGameStart, [SIGame stateStringNameForGameState:SIGameStateStart]);

    /*End*/
    XCTAssertEqualObjects(kSITKStateMachineStateGameEnd, [SIGame stateStringNameForGameState:SIGameStateEnd]);
    
    /*Falling Monkey*/
    XCTAssertEqualObjects(kSITKStateMachineStateGameFallingMonkey, [SIGame stateStringNameForGameState:SIGameStateFallingMonkey]);
    
}

- (void)testGameStateForString {
    /*Idle*/
    XCTAssertEqual(SIGameStateIdle, [SIGame gameStateForStringName:kSITKStateMachineStateGameIdle]);
    
    /*Pause*/
    XCTAssertEqual(SIGameStatePause, [SIGame gameStateForStringName:kSITKStateMachineStateGamePaused]);
    
    /*Paying For Life*/
    XCTAssertEqual(SIGameStatePayingForContinue, [SIGame gameStateForStringName:kSITKStateMachineStateGamePayingForContinue]);
    
    /*Popup Continue*/
    XCTAssertEqual(SIGameStatePopupContinue, [SIGame gameStateForStringName:kSITKStateMachineStateGamePopupContinue]);
    
    /*Processing Move*/
    XCTAssertEqual(SIGameStateProcessingMove, [SIGame gameStateForStringName:kSITKStateMachineStateGameProcessingMove]);
    
    /*Start*/
    XCTAssertEqual(SIGameStateStart, [SIGame gameStateForStringName:kSITKStateMachineStateGameStart]);

    /*End*/
    XCTAssertEqual(SIGameStateEnd, [SIGame gameStateForStringName:kSITKStateMachineStateGameEnd]);
    
    /*Falling Monkey*/
    XCTAssertEqual(SIGameStateFallingMonkey, [SIGame gameStateForStringName:kSITKStateMachineStateGameFallingMonkey]);
    
}

- (void)testUpdateLifeTimeHighScore {
    float lifeTimeHighScore         = 69.0f;
    float newScore                  = 100.0f;

    [_defaults setFloat:lifeTimeHighScore forKey:kSINSUserDefaultLifetimePointsEarned];
    
    //Function under test
    [SIGame updateLifetimePointsScore:newScore withNSUserDefaults:_defaults];

    float newLifeTimeHighScore      = [_defaults floatForKey:kSINSUserDefaultLifetimePointsEarned];
    
    XCTAssertEqualWithAccuracy(newScore + lifeTimeHighScore, newLifeTimeHighScore, 0.01f);
}

- (void)testUpdateLifeTimeHighScoreNil {
    float newScore                  = 100.0f;
    
    //Function under test
    [SIGame updateLifetimePointsScore:newScore withNSUserDefaults:_defaults];
    
    float newLifeTimeHighScore      = [_defaults floatForKey:kSINSUserDefaultLifetimePointsEarned];
    
    XCTAssertEqualWithAccuracy(newScore, newLifeTimeHighScore, 0.01f);
}

- (void)testIsDeviceHighScoreYes {
    float deviceHighScore       = 1000.0f;
    float newScore              = 1001.0f;
    
    [_defaults setFloat:deviceHighScore forKey:kSINSUserDefaultLifetimeHighScore];
    
    BOOL isHighScore = [SIGame isDevieHighScore:newScore withNSUserDefaults:_defaults];
    
    XCTAssertEqual(isHighScore, YES);
    
    XCTAssertEqualWithAccuracy([_defaults floatForKey:kSINSUserDefaultLifetimeHighScore], newScore, 0.01f);
}

- (void)testIsDeviceHighScoreNoUnder {
    float deviceHighScore       = 1000.0f;
    float newScore              = 999.0f;
    
    [_defaults setFloat:deviceHighScore forKey:kSINSUserDefaultLifetimeHighScore];
    
    BOOL isHighScore = [SIGame isDevieHighScore:newScore withNSUserDefaults:_defaults];
    
    XCTAssertEqual(isHighScore, NO);
    
    XCTAssertEqualWithAccuracy([_defaults floatForKey:kSINSUserDefaultLifetimeHighScore], deviceHighScore, 0.01f);
}

- (void)testIsDeviceHighScoreNoSame {
    float deviceHighScore       = 1000.0f;
    float newScore              = 1000.0f;
    
    [_defaults setFloat:deviceHighScore forKey:kSINSUserDefaultLifetimeHighScore];
    
    BOOL isHighScore = [SIGame isDevieHighScore:newScore withNSUserDefaults:_defaults];
    
    XCTAssertEqual(isHighScore, NO);
    
    XCTAssertEqualWithAccuracy([_defaults floatForKey:kSINSUserDefaultLifetimeHighScore], deviceHighScore, 0.01f);
}

- (void)testIsDeviceHighScoreYesNil {
    float newScore              = 1000.0f;
    
    BOOL isHighScore = [SIGame isDevieHighScore:newScore withNSUserDefaults:_defaults];
    
    XCTAssertEqual(isHighScore, YES);
    
    XCTAssertEqualWithAccuracy([_defaults floatForKey:kSINSUserDefaultLifetimeHighScore], newScore, 0.01f);
}

- (void)testUpdatePointsTillFreeCoinMoveScoreNoFreeCoin {
    float moveScore             = MAX_MOVE_SCORE - 1;
    float pointsTillFreeCoin    = POINTS_NEEDED_FOR_FREE_COIN - MAX_MOVE_SCORE;
    
    [_defaults setFloat:pointsTillFreeCoin forKey:kSINSUserDefaultPointsTowardsFreeCoin];
    
    float newPointsTillFreeCoin = [SIGame updatePointsTillFreeCoinMoveScore:moveScore withNSUserDefaults:_defaults withCallback:^(BOOL willAwardFreeCoin) {
        XCTAssertEqual(willAwardFreeCoin, NO);
    }];
    
    XCTAssertEqualWithAccuracy(newPointsTillFreeCoin, moveScore + pointsTillFreeCoin, 0.01f);
    
    XCTAssertEqualWithAccuracy(newPointsTillFreeCoin, [_defaults floatForKey:kSINSUserDefaultPointsTowardsFreeCoin], 0.01f);
    
}

- (void)testUpdatePointsTillFreeCoinMoveScoreFreeCoin {
    float moveScore             = MAX_MOVE_SCORE;
    float pointsTillFreeCoin    = POINTS_NEEDED_FOR_FREE_COIN - 1;
    
    [_defaults setFloat:pointsTillFreeCoin forKey:kSINSUserDefaultPointsTowardsFreeCoin];
    
    float newPointsTillFreeCoin = [SIGame updatePointsTillFreeCoinMoveScore:moveScore withNSUserDefaults:_defaults withCallback:^(BOOL willAwardFreeCoin) {
        XCTAssertEqual(willAwardFreeCoin, YES);
    }];
    
    //we are going to erol over on this entry so lets thin kwhat shoudl this look like
    //  we know that we will take the sum of pointsTillFreeCoin & moveScore then subtract POINTS_NEEDED_FOR_FREE_COIN
    float expectedOutput = (pointsTillFreeCoin + moveScore) - POINTS_NEEDED_FOR_FREE_COIN;
    
    
    XCTAssertEqualWithAccuracy(newPointsTillFreeCoin, expectedOutput, 0.01f);
    
    XCTAssertEqualWithAccuracy(newPointsTillFreeCoin, [_defaults floatForKey:kSINSUserDefaultPointsTowardsFreeCoin], 0.01f);
    
}

- (void)testUpdatePointsTillFreeCoinMoveScoreSuperBigMoveScoreNoFreeCoin {
    float moveScore             = MAX_MOVE_SCORE * POINTS_NEEDED_FOR_FREE_COIN;
    float pointsTillFreeCoin    = POINTS_NEEDED_FOR_FREE_COIN - MAX_MOVE_SCORE - 1;
    
    [_defaults setFloat:pointsTillFreeCoin forKey:kSINSUserDefaultPointsTowardsFreeCoin];
    
    float newPointsTillFreeCoin = [SIGame updatePointsTillFreeCoinMoveScore:moveScore withNSUserDefaults:_defaults withCallback:^(BOOL willAwardFreeCoin) {
        XCTAssertEqual(willAwardFreeCoin, NO);
    }];
    
    XCTAssertEqualWithAccuracy(newPointsTillFreeCoin, MAX_MOVE_SCORE + pointsTillFreeCoin, 0.01f);
    
    XCTAssertEqualWithAccuracy(newPointsTillFreeCoin, [_defaults floatForKey:kSINSUserDefaultPointsTowardsFreeCoin], 0.01f);
}

- (void)testUpdatePointsTillFreeCoinMoveScoreSuperBigMoveScoreFreeCoin {
    float moveScore             = MAX_MOVE_SCORE * POINTS_NEEDED_FOR_FREE_COIN;
    float pointsTillFreeCoin    = POINTS_NEEDED_FOR_FREE_COIN - 1;
    
    [_defaults setFloat:pointsTillFreeCoin forKey:kSINSUserDefaultPointsTowardsFreeCoin];
    
    float newPointsTillFreeCoin = [SIGame updatePointsTillFreeCoinMoveScore:moveScore withNSUserDefaults:_defaults withCallback:^(BOOL willAwardFreeCoin) {
        XCTAssertEqual(willAwardFreeCoin, YES);
    }];
    
    //we are going to erol over on this entry so lets thin kwhat shoudl this look like
    //  we know that we will take the sum of pointsTillFreeCoin & moveScore then subtract POINTS_NEEDED_FOR_FREE_COIN
    float expectedOutput = (pointsTillFreeCoin + MAX_MOVE_SCORE) - POINTS_NEEDED_FOR_FREE_COIN;
    
    
    XCTAssertEqualWithAccuracy(newPointsTillFreeCoin, expectedOutput, 0.01f);
    
    XCTAssertEqualWithAccuracy(newPointsTillFreeCoin, [_defaults floatForKey:kSINSUserDefaultPointsTowardsFreeCoin], 0.01f);
    
}

- (void)testUpdatePointsTillFreeCoinMoveScoreNilDefault {
    float moveScore             = MAX_MOVE_SCORE;
    float pointsTillFreeCoin    = 0.0f;
    
    float newPointsTillFreeCoin = [SIGame updatePointsTillFreeCoinMoveScore:moveScore withNSUserDefaults:_defaults withCallback:^(BOOL willAwardFreeCoin) {
        XCTAssertEqual(willAwardFreeCoin, NO);
    }];
    
    XCTAssertEqualWithAccuracy(newPointsTillFreeCoin, moveScore + pointsTillFreeCoin, 0.01f);
    
    XCTAssertEqualWithAccuracy(newPointsTillFreeCoin, [_defaults floatForKey:kSINSUserDefaultPointsTowardsFreeCoin], 0.01f);
}

- (void)testIncrementGamesPlayedWithNSUserDefaults {
    
    NSInteger initalGamesPlayed = 0;
    
    [_defaults setInteger:initalGamesPlayed forKey:kSINSUserDefaultLifetimeGamesPlayed];
    
    [SIGame incrementGamesPlayedWithNSUserDefaults:_defaults];
    
    XCTAssertEqual(initalGamesPlayed + 1, [_defaults integerForKey:kSINSUserDefaultLifetimeGamesPlayed]);
    
}

- (void)testBackgroundSoundForScoreNegativeScore {
    float score = -10.0f;
    
    XCTAssertEqual(SIBackgroundSoundOne, [SIGame backgroundSoundForScore:score]);
}

- (void)testBackgroundSoundForScore {
    float score = SOUNDLEVEL1 - 1;
    XCTAssertEqual(SIBackgroundSoundOne, [SIGame backgroundSoundForScore:score]);
    
    score = SOUNDLEVEL1;
    XCTAssertEqual(SIBackgroundSoundTwo, [SIGame backgroundSoundForScore:score]);
    
    score = SOUNDLEVEL2;
    XCTAssertEqual(SIBackgroundSoundThree, [SIGame backgroundSoundForScore:score]);
    
    score = SOUNDLEVEL3;
    XCTAssertEqual(SIBackgroundSoundFour, [SIGame backgroundSoundForScore:score]);
    
    score = SOUNDLEVEL4;
    XCTAssertEqual(SIBackgroundSoundFive, [SIGame backgroundSoundForScore:score]);
    
    score = SOUNDLEVEL5;
    XCTAssertEqual(SIBackgroundSoundFour, [SIGame backgroundSoundForScore:score]);
    
    score = SOUNDLEVEL5 + (SOUNDLEVEL5 / 2);
    XCTAssertEqual(SIBackgroundSoundFive, [SIGame backgroundSoundForScore:score]);
   
}
- (void)testSoundNameForSIBackgroundSound {
    
    XCTAssertEqualObjects(kSISoundBackgroundMenu, [SIGame soundNameForSIBackgroundSound:SIBackgroundSoundMenu]);
    
    XCTAssertEqualObjects(kSISoundBackgroundOne, [SIGame soundNameForSIBackgroundSound:SIBackgroundSoundOne]);

    XCTAssertEqualObjects(kSISoundBackgroundTwo, [SIGame soundNameForSIBackgroundSound:SIBackgroundSoundTwo]);
    
    XCTAssertEqualObjects(kSISoundBackgroundThree, [SIGame soundNameForSIBackgroundSound:SIBackgroundSoundThree]);
    
    XCTAssertEqualObjects(kSISoundBackgroundFour, [SIGame soundNameForSIBackgroundSound:SIBackgroundSoundFour]);
    
    XCTAssertEqualObjects(kSISoundBackgroundFive, [SIGame soundNameForSIBackgroundSound:SIBackgroundSoundFive]);
    
}

- (void)testUserMessageForScoreBadScore {
    BOOL isHighScore        = NO;
    float score             = 1.0f;
    float highScore         = 1000.0f;
    NSString *userMessage   = @"taco";
    
    while (score < (highScore * USER_MSG_LEVEL_BAD)) {
        userMessage = [SIGame userMessageForScore:score isHighScore:isHighScore highScore:highScore];
        XCTAssert([[SIConstants userMessageHighScoreBad] containsObject:userMessage]);
        score       = score + 25.0f;
    }
}

- (void)testUserMessageForScoreMedianScore {
    BOOL isHighScore        = NO;
    float highScore         = 1000.0f;
    float score             = highScore * USER_MSG_LEVEL_BAD + 1;
    NSString *userMessage   = @"taco";
    
    while (score < (highScore * USER_MSG_LEVEL_MEDIAN)) {
        userMessage = [SIGame userMessageForScore:score isHighScore:isHighScore highScore:highScore];
        XCTAssert([[SIConstants userMessageHighScoreMedian] containsObject:userMessage]);
        score       = score + 25.0f;
    }
}

- (void)testUserMessageForScoreCloseScore {
    BOOL isHighScore        = NO;
    float highScore         = 1000.0f;
    float score             = highScore * USER_MSG_LEVEL_MEDIAN + 1;
    NSString *userMessage   = @"taco";
    
    while (score < (highScore * USER_MSG_LEVEL_CLOSE)) {
        userMessage = [SIGame userMessageForScore:score isHighScore:isHighScore highScore:highScore];
        XCTAssert([[SIConstants userMessageHighScoreClose] containsObject:userMessage]);
        score       = score + 5.0f;
    }
}

- (void)testUserMessageForScoreHighScore {
    BOOL isHighScore        = YES;
    float highScore         = 1000.0f;
    float score             = highScore * USER_MSG_LEVEL_BAD;
    NSString *userMessage   = @"taco";
    
    while (score < (highScore * USER_MSG_LEVEL_CLOSE * 1.5)) {
        userMessage = [SIGame userMessageForScore:score isHighScore:isHighScore highScore:highScore];
        XCTAssert([[SIConstants userMessageHighScore] containsObject:userMessage]);
        score       = score + 25.0f;
    }
}

- (void)testLevelScoreNewGame {
    float score             = 0.0f;
    
    float levelScore = [SIGame levelSpeedForScore:score];
    
    XCTAssertEqualWithAccuracy(levelScore, INITIAL_LEVEL_SPEED, 0.01f);
}

- (void)testLevelScoreEquationExpo {
    float score         = MAX_MOVE_SCORE + 1;
    float levelScore    = 0.0f;
    while (score < SPEED_TRANSISTION_SCORE) {
        levelScore      = [SIGame levelSpeedForScore:score];
        XCTAssertEqualWithAccuracy(levelScore, SPEED_POWER_MULTIPLIER * pow(score,SPEED_POWER_EXPONENT), 0.1f);
        score           = score + 200;
    }
}

- (void)testLevelScoreEquationLog {
    float score         = SPEED_TRANSISTION_SCORE;
    float levelScore    = 0.0f;
    float maxScore      = SPEED_TRANSISTION_SCORE * 2;
    
    while (score < maxScore) {
        levelScore      = [SIGame levelSpeedForScore:score];
        XCTAssertEqualWithAccuracy(levelScore, SPEED_LOG_MULTIPLIER * log(score) + SPEED_LOG_INTERCEPT, 0.1f);
        score           = score + 200;
    }
}

- (void)testGetBlurredScreenShot {
    SKView *dummyView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    UIImage *blurredScreen = [SIGame getBluredScreenshot:dummyView];
    
    XCTAssertNotNil(blurredScreen);
    
    XCTAssertEqual(dummyView.frame.size.height, blurredScreen.size.height);
    XCTAssertEqual(dummyView.frame.size.width, blurredScreen.size.width);
}

@end
