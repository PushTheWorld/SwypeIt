//
//  SISingletonGameTests.m
//  Swype It
//
//  Created by Andrew Keller on 9/15/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <UIKit/UIKit.h>
#import "SISingletonGame.h"
#import "SIGameController.h"

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
    XCTAssert(moveCommand == SIMoveCommandSwype);
    
    [SISingletonGame singleton].currentGame.gameMode = SIGameModeOneHand;
    
    moveCommand = [SISingletonGame singleton].currentGame.currentMove.moveCommand;
    XCTAssert(moveCommand == SIMoveCommandSwype);
}

- (void)testFirstMove {
    //given a mock SISingletonGame
    id mockGame = [OCMockObject niceMockForClass:[SISingletonGame class]];
    [[[mockGame stub] andReturn:mockGame] singleton];
    
    SIGameController *gameController = [[SIGameController alloc] init];
//    [gameController view];
    
    [gameController launchSceneGameWithGameMode:SIGameModeOneHand];
    
    SIMove *move = [[SIMove alloc] init];
    move.moveCommand = SIMoveCommandSwype;
    
    [gameController controllerSceneGameDidRecieveMove:move];
    
    OCMVerify([mockGame singletonGameDidEnterMove:move]);
    
    OCMVerify([mockGame controllerSingletonGameLoadNewMove]);
        
    // Stop mocking!
    [mockGame stopMocking];
}

@end
