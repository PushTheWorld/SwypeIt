//
//  GameSceneTests.m
//  Swype It
//
//  Created by Andrew Keller on 9/5/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SIGame.h"
#import "SIGameModel.h"
#import "TransitionKit.h"

@interface SIGameModelTests : XCTestCase

@end

@implementation SIGameModelTests {
    SIGameModel *_gameModel;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _gameModel = [[SIGameModel alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDoesStartInCorrectState {
    BOOL success = [_gameModel.stateMachine fireEvent:kSITKStateMachineEventGameMenuStart userInfo:nil error:nil];
    XCTAssert(success);
    XCTAssert([_gameModel.stateMachine isInState:kSITKStateMachineStateGameStart]);
    
}

- (void)testCostToContinueInitial {
    XCTAssertEqual(_gameModel.game.currentNumberOfTimesContinued,0);
    XCTAssertEqual([SIGame lifeCostForNumberOfTimesContinued:_gameModel.game.currentNumberOfTimesContinued], SIContinueLifeCost1);
    XCTAssertEqual([SIGame adCountForNumberOfTimesContinued:_gameModel.game.currentNumberOfTimesContinued], SIContinueAdCount1);
}



@end
