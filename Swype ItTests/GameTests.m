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
- (void)testContinueCost {
    
    XCTAssertEqual(SIContinueLifeCost1, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost0]);

    XCTAssertEqual(SIContinueLifeCost2, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost1]);

    XCTAssertEqual(SIContinueLifeCost3, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost2]);
    
    XCTAssertEqual(SIContinueLifeCost4, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost3]);
    
    XCTAssertEqual(SIContinueLifeCost5, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost4]);
    
    XCTAssertEqual(SIContinueLifeCost6, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost5]);
    
    XCTAssertEqual(SIContinueLifeCost7, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost6]);
    
    XCTAssertEqual(SIContinueLifeCost8, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost7]);
    
    XCTAssertEqual(SIContinueLifeCost9, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost8]);
    
    XCTAssertEqual(SIContinueLifeCost10, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost9]);
    
    XCTAssertEqual(SIContinueLifeCost11, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost10]);
    
    XCTAssertEqual(SIContinueLifeCost12, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost11]);
    
    XCTAssertEqual(SIContinueLifeCost13, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost12]);
    
    XCTAssertEqual(SIContinueLifeCost14, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost13]);
    
    XCTAssertEqual(SIContinueLifeCost15, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost14]);
    
    XCTAssertEqual(SIContinueLifeCost16, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost15]);
    
    XCTAssertEqual(SIContinueLifeCost17, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost16]);
    
    XCTAssertEqual(SIContinueLifeCost18, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost17]);
    
    XCTAssertEqual(SIContinueLifeCost19, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost18]);
    
    XCTAssertEqual(SIContinueLifeCost20, [SIGame lifeCostForCurrentContinueLevel:SIContinueLifeCost19]);

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
