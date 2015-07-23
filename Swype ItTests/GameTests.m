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
#import "Game.h"
#import "GameViewController.h"
// Framework Import
#import <OCMock/OCMock.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
// Support/Data Class Imports
#import "AppSingleton.h"
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
        
        float levelscore = [Game nextLevelForScore:score];
        
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
        
        NSString *levelString = [Game currentLevelStringForScore:score];
        
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
    XCTAssertEqualObjects(kSIMoveCommandPinch, [Game stringForMove:SIMovePinch]);
    
    XCTAssertEqualObjects(kSIMoveCommandTap, [Game stringForMove:SIMoveTap]);
    
    XCTAssertEqualObjects(kSIMoveCommandSwype, [Game stringForMove:SIMoveSwype]);
    
    XCTAssertEqualObjects(kSIMoveCommandShake, [Game stringForMove:SIMoveShake]);
}
- (void)testStringForPowerUp {
    XCTAssertEqualObjects(kSIPowerUpNone, [Game stringForPowerUp:SIPowerUpNone]);

    XCTAssertEqualObjects(kSIPowerUpFallingMonkeys, [Game stringForPowerUp:SIPowerUpFallingMonkeys]);

    XCTAssertEqualObjects(kSIPowerUpTimeFreeze, [Game stringForPowerUp:SIPowerUpTimeFreeze]);

    XCTAssertEqualObjects(kSIPowerUpRapidFire, [Game stringForPowerUp:SIPowerUpRapidFire]);
}
- (void)testDurationForPowerUp {
    /*Power Up None*/
    XCTAssertEqual(SIPowerUpDurationNone, [Game durationForPowerUp:SIPowerUpNone]);
    
    /*Power Up Time Freeze*/
    XCTAssertEqual(SIPowerUpDurationTimeFreeze, [Game durationForPowerUp:SIPowerUpTimeFreeze]);
    
    /*Power Up Rapid Fire*/
    XCTAssertEqual(SIPowerUpDurationRapidFire, [Game durationForPowerUp:SIPowerUpRapidFire]);
}
- (void)testCostForPowerUp {
    /*Power Up None*/
    XCTAssertEqual(SIPowerUpCostNone, [Game costForPowerUp:SIPowerUpNone]);
    
    /*Power Up Double Points*/
    XCTAssertEqual(SIPowerUpCostFallingMonkeys, [Game costForPowerUp:SIPowerUpFallingMonkeys]);
    
    /*Power Up Time Freeze*/
    XCTAssertEqual(SIPowerUpCostTimeFreeze, [Game costForPowerUp:SIPowerUpTimeFreeze]);
    
    /*Power Up Rapid Fire*/
    XCTAssertEqual(SIPowerUpCostRapidFire, [Game costForPowerUp:SIPowerUpRapidFire]);
}
- (void)testTypeDefForPowerUpDuration {
    /*Power Up None*/
    XCTAssertEqual(0, SIPowerUpDurationNone);
    /*Power Up Double Points*/
    XCTAssertEqual(5, SIPowerUpDurationFallingMonkeys);
    /*Power Up Time Freeze*/
    XCTAssertEqual(5, SIPowerUpDurationTimeFreeze);
    /*Power Up Rapid Fire*/
    XCTAssertEqual(5, SIPowerUpDurationRapidFire);
}
- (void)testTypeDefForPowerUpCost {
    /*Power Up None*/
    XCTAssertEqual(0, SIPowerUpCostNone);
    /*Power Up Double Points*/
    XCTAssertEqual(5, SIPowerUpCostFallingMonkeys);
    /*Power Up Time Freeze*/
    XCTAssertEqual(1, SIPowerUpCostTimeFreeze);
    /*Power Up Rapid Fire*/
    XCTAssertEqual(3, SIPowerUpCostRapidFire);
}
- (void)testGetRandomMoveForRapidFire {
    /*Check to make the Rapid Fire Returns Tap*/
    SIMove move = [Game getRandomMoveForGameMode:SIGameModeOneHand isRapidFireActiviated:YES];
    XCTAssertEqual(move, SIMoveTap);
}
- (void)testGetRandomMoveForOneHandGameMode {
    for (int i = 0; i < 50; i++) {
        SIMove move = [Game getRandomMoveForGameMode:SIGameModeOneHand isRapidFireActiviated:NO];
        XCTAssertNotEqual(move, SIMovePinch);
    }
}
- (void)testGetRandomMoveForTwoHandGameMode {
    for (int i = 0; i < 50; i++) {
        SIMove move = [Game getRandomMoveForGameMode:SIGameModeTwoHand isRapidFireActiviated:NO];
        XCTAssertNotEqual(move, SIMoveShake);
    }
}
- (void)testIAPButtonStringForSIIAPPack {
    /*Bag of Coins*/
    XCTAssertEqualObjects(@"Bag of Coins", [Game buttonTextForSIIAPPack:SIIAPPackSmall]);

    /*Pile of Coins*/
    XCTAssertEqualObjects(@"Pile of Coins", [Game buttonTextForSIIAPPack:SIIAPPackMedium]);

    /*Bucket of Coins*/
    XCTAssertEqualObjects(@"Bucket of Coins", [Game buttonTextForSIIAPPack:SIIAPPackLarge]);

    /*Chest of Coins*/
    XCTAssertEqualObjects(@"Chest of Coins", [Game buttonTextForSIIAPPack:SIIAPPackExtraLarge]);
}
- (void)testIAPButtonNodeNameForSIIAPPack {
    /*Bag of Coins*/
    XCTAssertEqualObjects(kSINodeNodeBag, [Game buttonNodeNameNodeForSIIAPPack:SIIAPPackSmall]);
    
    /*Pile of Coins*/
    XCTAssertEqualObjects(kSINodeNodePile, [Game buttonNodeNameNodeForSIIAPPack:SIIAPPackMedium]);
    
    /*Bucket of Coins*/
    XCTAssertEqualObjects(kSINodeNodeBucket, [Game buttonNodeNameNodeForSIIAPPack:SIIAPPackLarge]);
    
    /*Chest of Coins*/
    XCTAssertEqualObjects(kSINodeNodeChest, [Game buttonNodeNameNodeForSIIAPPack:SIIAPPackExtraLarge]);
}
- (void)testIAPButtonNodeLabelDescriptionForSIIAPPack {
    /*Bag of Coins*/
    XCTAssertEqualObjects(kSINodeLabelDescriptionBag, [Game buttonNodeNameLabelDescriptionForSIIAPPack:SIIAPPackSmall]);
    
    /*Pile of Coins*/
    XCTAssertEqualObjects(kSINodeLabelDescriptionPile, [Game buttonNodeNameLabelDescriptionForSIIAPPack:SIIAPPackMedium]);
    
    /*Bucket of Coins*/
    XCTAssertEqualObjects(kSINodeLabelDescriptionBucket, [Game buttonNodeNameLabelDescriptionForSIIAPPack:SIIAPPackLarge]);
    
    /*Chest of Coins*/
    XCTAssertEqualObjects(kSINodeLabelDescriptionChest, [Game buttonNodeNameLabelDescriptionForSIIAPPack:SIIAPPackExtraLarge]);
}
- (void)testIAPButtonNodeLabelPriceForSIIAPPack {
    /*Bag of Coins*/
    XCTAssertEqualObjects(kSINodeLabelPriceBag, [Game buttonNodeNameLabelPriceForSIIAPPack:SIIAPPackSmall]);
    
    /*Pile of Coins*/
    XCTAssertEqualObjects(kSINodeLabelPricePile, [Game buttonNodeNameLabelPriceForSIIAPPack:SIIAPPackMedium]);
    
    /*Bucket of Coins*/
    XCTAssertEqualObjects(kSINodeLabelPriceBucket, [Game buttonNodeNameLabelPriceForSIIAPPack:SIIAPPackLarge]);
    
    /*Chest of Coins*/
    XCTAssertEqualObjects(kSINodeLabelPriceChest, [Game buttonNodeNameLabelPriceForSIIAPPack:SIIAPPackExtraLarge]);
}
- (void)testIAPProductIDForSIIAPPack {
    /*Bag of Coins*/
    XCTAssertEqualObjects(kSIIAPProductIDCoinPackSmall, [Game productIDForSIIAPPack:SIIAPPackSmall]);
    
    /*Pile of Coins*/
    XCTAssertEqualObjects(kSIIAPProductIDCoinPackMedium, [Game productIDForSIIAPPack:SIIAPPackMedium]);
    
    /*Bucket of Coins*/
    XCTAssertEqualObjects(kSIIAPProductIDCoinPackLarge, [Game productIDForSIIAPPack:SIIAPPackLarge]);
    
    /*Chest of Coins*/
    XCTAssertEqualObjects(kSIIAPProductIDCoinPackExtraLarge, [Game productIDForSIIAPPack:SIIAPPackExtraLarge]);
}
@end
