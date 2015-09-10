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
// Category Import
// Support/Data Class Imports
#import "SIConstants.h"
// Other Imports


@interface GameTests : XCTestCase

@end

@implementation GameTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
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

- (void)testGetRandomMoveForRapidFire {
    /*Check to make the Rapid Fire Returns Tap*/
    SIMoveCommand move = [SIGame getRandomMoveForGameMode:SIGameModeOneHand];
    XCTAssertEqual(move, SIMoveCommandTap);
}
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
- (void)testIAPButtonStringForSIIAPPack {
    /*Bag of Coins*/
    XCTAssertEqualObjects(@"Pile of Coins", [SIGame buttonTextForSIIAPPack:SIIAPPackSmall]);

    /*Pile of Coins*/
    XCTAssertEqualObjects(@"Bucket of Coins", [SIGame buttonTextForSIIAPPack:SIIAPPackMedium]);

    /*Bucket of Coins*/
    XCTAssertEqualObjects(@"Bag of Coins", [SIGame buttonTextForSIIAPPack:SIIAPPackLarge]);

    /*Chest of Coins*/
    XCTAssertEqualObjects(@"Chest of Coins", [SIGame buttonTextForSIIAPPack:SIIAPPackExtraLarge]);
}
- (void)testIAPButtonNodeNameForSIIAPPack {
    /*Bag of Coins*/
    XCTAssertEqualObjects(kSINodeNodePile, [SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackSmall]);
    
    /*Pile of Coins*/
    XCTAssertEqualObjects(kSINodeNodeBucket, [SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackMedium]);
    
    /*Bucket of Coins*/
    XCTAssertEqualObjects(kSINodeNodeBag, [SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackLarge]);
    
    /*Chest of Coins*/
    XCTAssertEqualObjects(kSINodeNodeChest, [SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackExtraLarge]);
}
- (void)testIAPButtonNodeLabelDescriptionForSIIAPPack {
    /*Bag of Coins*/
    XCTAssertEqualObjects(kSINodeLabelDescriptionPile, [SIGame buttonNodeNameLabelDescriptionForSIIAPPack:SIIAPPackSmall]);
    
    /*Pile of Coins*/
    XCTAssertEqualObjects(kSINodeLabelDescriptionBucket, [SIGame buttonNodeNameLabelDescriptionForSIIAPPack:SIIAPPackMedium]);
    
    /*Bucket of Coins*/
    XCTAssertEqualObjects(kSINodeLabelDescriptionBag, [SIGame buttonNodeNameLabelDescriptionForSIIAPPack:SIIAPPackLarge]);
    
    /*Chest of Coins*/
    XCTAssertEqualObjects(kSINodeLabelDescriptionChest, [SIGame buttonNodeNameLabelDescriptionForSIIAPPack:SIIAPPackExtraLarge]);
}
- (void)testIAPButtonNodeLabelPriceForSIIAPPack {
    /*Bag of Coins*/
    XCTAssertEqualObjects(kSINodeLabelPriceBag, [SIGame buttonNodeNameLabelPriceForSIIAPPack:SIIAPPackLarge]);
    
    /*Pile of Coins*/
    XCTAssertEqualObjects(kSINodeLabelPricePile, [SIGame buttonNodeNameLabelPriceForSIIAPPack:SIIAPPackSmall]);
    
    /*Bucket of Coins*/
    XCTAssertEqualObjects(kSINodeLabelPriceBucket, [SIGame buttonNodeNameLabelPriceForSIIAPPack:SIIAPPackMedium]);
    
    /*Chest of Coins*/
    XCTAssertEqualObjects(kSINodeLabelPriceChest, [SIGame buttonNodeNameLabelPriceForSIIAPPack:SIIAPPackExtraLarge]);
}
- (void)testIAPProductIDForSIIAPPack {
    /*Bag of Coins*/
    XCTAssertEqualObjects(kSIIAPProductIDCoinPackSmall, [SIGame productIDForSIIAPPack:SIIAPPackSmall]);
    
    /*Pile of Coins*/
    XCTAssertEqualObjects(kSIIAPProductIDCoinPackMedium,[SIGame productIDForSIIAPPack:SIIAPPackMedium]);
    
    /*Bucket of Coins*/
    XCTAssertEqualObjects(kSIIAPProductIDCoinPackLarge, [SIGame productIDForSIIAPPack:SIIAPPackLarge]);
    
    /*Chest of Coins*/
    XCTAssertEqualObjects(kSIIAPProductIDCoinPackExtraLarge, [SIGame productIDForSIIAPPack:SIIAPPackExtraLarge]);
}
- (void)testLifeCostForNumberOfTimesContinued {
    XCTAssertEqual(SIContinueLifeCost0, [SIGame lifeCostForNumberOfTimesContinued:0]);
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
    XCTAssertEqual(SIContinueAdCount0, [SIGame adCountForNumberOfTimesContinued:0]);
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
    
    SIGameFreePrize freePrize  = [SIGame gamePrizeForCurrentDate:currentDate lastPrizeGivenDate:lastPrizeGivenDate];
    
    XCTAssertEqual(freePrize, SIGameFreePrizeNo);
}

- (void)testGameFreePrizeNo {
    NSDate *currentDate = [NSDate date];
    
    NSDate *lastPrizeGivenDate = [currentDate dateByAddingTimeInterval:-1 * (60 * 60 * 23)]; //23 hours ago
    
    SIGameFreePrize freePrize  = [SIGame gamePrizeForCurrentDate:currentDate lastPrizeGivenDate:lastPrizeGivenDate];
    
    XCTAssertEqual(freePrize, SIGameFreePrizeNo);
}

- (void)testGameFreePrizeYesConsecutiveBorderFront {
    NSDate *currentDate = [NSDate date];
    
    NSDate *lastPrizeGivenDate = [currentDate dateByAddingTimeInterval:-1 * (60 * 60 * 24)]; //24 hours ago
    
    SIGameFreePrize freePrize  = [SIGame gamePrizeForCurrentDate:currentDate lastPrizeGivenDate:lastPrizeGivenDate];
    
    XCTAssertEqual(freePrize, SIGameFreePrizeYesConsecutive);
}

- (void)testGameFreePrizeYesConsecutiveMiddle {
    NSDate *currentDate = [NSDate date];
    
    NSDate *lastPrizeGivenDate = [currentDate dateByAddingTimeInterval:-1 * (60 * 60 * 36)]; //36 hours ago
    
    SIGameFreePrize freePrize  = [SIGame gamePrizeForCurrentDate:currentDate lastPrizeGivenDate:lastPrizeGivenDate];
    
    XCTAssertEqual(freePrize, SIGameFreePrizeYesConsecutive);
}

- (void)testGameFreePrizeYesConsecutiveBorderEnd {
    NSDate *currentDate = [NSDate date];
    
    NSDate *lastPrizeGivenDate = [currentDate dateByAddingTimeInterval:-1 * ((60 * 60 * 47) + (60 * 59))]; //47 hours 59 minutes ago
    
    SIGameFreePrize freePrize  = [SIGame gamePrizeForCurrentDate:currentDate lastPrizeGivenDate:lastPrizeGivenDate];
    
    XCTAssertEqual(freePrize, SIGameFreePrizeYesConsecutive);
}

- (void)testGameFreePrizeYesBorderFront {
    NSDate *currentDate = [NSDate date];
    
    NSDate *lastPrizeGivenDate = [currentDate dateByAddingTimeInterval:-1 * (60 * 60 * 48)]; //48 hours ago
    
    SIGameFreePrize freePrize  = [SIGame gamePrizeForCurrentDate:currentDate lastPrizeGivenDate:lastPrizeGivenDate];
    
    XCTAssertEqual(freePrize, SIGameFreePrizeYes);
}

- (void)testGameFreePrizeYesClear {
    NSDate *currentDate = [NSDate date];
    
    NSDate *lastPrizeGivenDate = [currentDate dateByAddingTimeInterval:-1 * (60 * 60 * 100)]; //100 hours ago
    
    SIGameFreePrize freePrize  = [SIGame gamePrizeForCurrentDate:currentDate lastPrizeGivenDate:lastPrizeGivenDate];
    
    XCTAssertEqual(freePrize, SIGameFreePrizeYes);
}

- (void)testSecondsInDay {
    XCTAssertEqual(SECONDS_IN_DAY, 60*60*24);
}


@end
