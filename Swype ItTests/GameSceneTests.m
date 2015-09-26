//
//  GameSceneTests.m
//  Swype It
//
//  Created by Andrew Keller on 9/5/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SIGameModel.h"
#import "TransitionKit.h"

@interface GameSceneTests : XCTestCase

@end

@implementation GameSceneTests {
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
    BOOL success = [_gameModel.stateMachine fireEvent:kSITKStateMachineEventGameLoad userInfo:nil error:nil];
    XCTAssert(success);
    XCTAssert([_gameModel.stateMachine isInState:kSITKStateMachineStateGameLoading]);
}



@end
