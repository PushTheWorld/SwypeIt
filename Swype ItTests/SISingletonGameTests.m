//
//  SISingletonGameTests.m
//  Swype It
//
//  Created by Andrew Keller on 9/15/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SISingletonGame.h"

@interface SISingletonGameTests : XCTestCase

@end

@implementation SISingletonGameTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testStartupOfEngineTwoHandMode {
    /**This is how i presumably start in the game*/
    [SISingletonGame singleton].currentGame.gameMode = SIGameModeTwoHand;
    
    XCTAssertEqualWithAccuracy([SISingletonGame singleton].currentGame.moveScore, 0.00f, 0.1f);
    
    XCTAssertEqual([SISingletonGame singleton].currentGame.isHighScore, NO);
    
    XCTAssertNotNil([SISingletonGame singleton].currentGame.currentBackgroundColor);

    XCTAssertEqualWithAccuracy([SISingletonGame singleton].currentGame.totalScore, 0.00f, 0.1f);
    
    XCTAssertEqualWithAccuracy([SISingletonGame singleton].currentGame.freeCoinPercentRemaining, 0.0f, 0.1f);
    
    XCTAssertEqual([SISingletonGame singleton].currentGame.currentMove.moveCommand, SIMoveCommandSwype);
}

- (void)testEngineSwitchTwoHandToOneHand {
    [SISingletonGame singleton].currentGame.gameMode = SIGameModeTwoHand;

    SIMoveCommand moveCommand = [SISingletonGame singleton].currentGame.currentMove.moveCommand;
    XCTAssert(moveCommand == SIMoveCommandTap || moveCommand == SIMoveCommandSwype || moveCommand == SIMoveCommandPinch);
    
    [SISingletonGame singleton].currentGame.gameMode = SIGameModeOneHand;
    
    moveCommand = [SISingletonGame singleton].currentGame.currentMove.moveCommand;
    XCTAssert(moveCommand == SIMoveCommandTap || moveCommand == SIMoveCommandSwype || moveCommand == SIMoveCommandShake);
}

@end
