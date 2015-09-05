//
//  SIPowerUpTests.m
//  Swype It
//
//  Created by Andrew Keller on 9/5/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PowerUp.h"

@interface SIPowerUpTests : XCTestCase

@end

@implementation SIPowerUpTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testStringForPowerUp {
    XCTAssertEqualObjects(kSIPowerUpTypeNone, [PowerUp stringForPowerUp:SIPowerUpTypeNone]);
    
    XCTAssertEqualObjects(kSIPowerUpTypeFallingMonkeys, [PowerUp stringForPowerUp:SIPowerUpTypeFallingMonkeys]);
    
    XCTAssertEqualObjects(kSIPowerUpTypeTimeFreeze, [PowerUp stringForPowerUp:SIPowerUpTypeTimeFreeze]);
    
    XCTAssertEqualObjects(kSIPowerUpTypeRapidFire, [PowerUp stringForPowerUp:SIPowerUpTypeRapidFire]);
}
- (void)testDurationForPowerUp {
    /*Power Up None*/
    XCTAssertEqual(SIPowerUpDurationNone, [PowerUp durationForPowerUp:SIPowerUpTypeNone]);
    
    /*Power Up Time Freeze*/
    XCTAssertEqual(SIPowerUpDurationTimeFreeze, [PowerUp durationForPowerUp:SIPowerUpTypeTimeFreeze]);
    
    /*Power Up Rapid Fire*/
    XCTAssertEqual(SIPowerUpDurationRapidFire, [PowerUp durationForPowerUp:SIPowerUpTypeRapidFire]);
}
- (void)testCostForPowerUp {
    /*Power Up None*/
    XCTAssertEqual(SIPowerUpCostNone, [PowerUp costForPowerUp:SIPowerUpTypeNone]);
    
    /*Power Up Falling Monkeys*/
    XCTAssertEqual(SIPowerUpCostFallingMonkeys, [PowerUp costForPowerUp:SIPowerUpTypeFallingMonkeys]);
    
    /*Power Up Time Freeze*/
    XCTAssertEqual(SIPowerUpCostTimeFreeze, [PowerUp costForPowerUp:SIPowerUpTypeTimeFreeze]);
    
    /*Power Up Rapid Fire*/
    XCTAssertEqual(SIPowerUpCostRapidFire, [PowerUp costForPowerUp:SIPowerUpTypeRapidFire]);
}
- (void)testPowerUpForString {
    XCTAssertEqual(SIPowerUpTypeNone, [PowerUp powerUpForString:kSIPowerUpTypeNone]);

    XCTAssertEqual(SIPowerUpTypeFallingMonkeys, [PowerUp powerUpForString:kSIPowerUpTypeFallingMonkeys]);

    XCTAssertEqual(SIPowerUpTypeTimeFreeze, [PowerUp powerUpForString:kSIPowerUpTypeTimeFreeze]);

    XCTAssertEqual(SIPowerUpTypeRapidFire, [PowerUp powerUpForString:kSIPowerUpTypeRapidFire]);
}
- (void)testTypeDefForPowerUpDuration {
    /*Power Up None*/
    XCTAssertEqual(0, SIPowerUpDurationNone);
    /*Power Up Time Freeze*/
    XCTAssertEqual(8, SIPowerUpDurationTimeFreeze);
    /*Power Up Rapid Fire*/
    XCTAssertEqual(3, SIPowerUpDurationRapidFire);
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

@end
