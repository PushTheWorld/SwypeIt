//  SIMenuContentTests.m
//  Swype It
//
//  Created by Andrew Keller on 9/7/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
#import <XCTest/XCTest.h>
#import "SIMenuContent.h"

@interface SIMenuContentTests : XCTestCase

@end

@implementation SIMenuContentTests {

}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUserMessageHighScore {
    SIMenuContent *endMenu = [[SIMenuContent alloc] initEndMenuGameScore:100.0f lifetimeHighScore:100.0f isHighScore:YES coinsEarned:0];
    
    XCTAssert([[SIConstants userMessageHighScore] containsObject:endMenu.userMessageString]);
}
- (void)testUserMessageHighScoreClose {
    SIMenuContent *endMenu = [[SIMenuContent alloc] initEndMenuGameScore:90.0f lifetimeHighScore:100.0f isHighScore:NO coinsEarned:0];
    
    XCTAssert([[SIConstants userMessageHighScoreClose] containsObject:endMenu.userMessageString]);
}
- (void)testUserMessageHighScoreMedian {
    SIMenuContent *endMenu = [[SIMenuContent alloc] initEndMenuGameScore:50.0f lifetimeHighScore:100.0f isHighScore:NO coinsEarned:0];
    
    XCTAssert([[SIConstants userMessageHighScoreMedian] containsObject:endMenu.userMessageString]);
}
- (void)testUserMessageHighScoreBad {
    SIMenuContent *endMenu = [[SIMenuContent alloc] initEndMenuGameScore:10.0f lifetimeHighScore:100.0f isHighScore:NO coinsEarned:0];
    
    XCTAssert([[SIConstants userMessageHighScoreBad] containsObject:endMenu.userMessageString]);
}

- (void)testMenuTypeEnd {
    SIMenuContent *endMenu = [[SIMenuContent alloc] initEndMenuGameScore:10.0f lifetimeHighScore:100.0f isHighScore:NO coinsEarned:0];

    XCTAssertEqual(endMenu.type, SISceneMenuTypeEnd);
}

- (void)testMenuTypeStartInit {
    SIMenuContent *startMenu    = [[SIMenuContent alloc] initStartMenuUserIsPremium:YES];
    
    XCTAssert(startMenu.userIsPremium);
    
    XCTAssertEqual(startMenu.type, SISceneMenuTypeStart);
}
@end
