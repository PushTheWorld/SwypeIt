//
//  SIPowerUpTests.m
//  Swype It
//
//  Created by Andrew Keller on 9/5/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MKStoreKit.h"
#import "SIPowerUp.h"



@interface SIPowerUpTests : XCTestCase

@end

@implementation SIPowerUpTests {
    NSArray         *_powerUpArray;
    NSTimeInterval   _powerUpStartTime;
    NSTimeInterval   _gameTotalTime;
}

- (void)setUp {
    [super setUp];
    _powerUpArray           = [NSArray array];
    _powerUpStartTime       = 0.0;
    _gameTotalTime          = 1.0;
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _powerUpArray           = nil;
    _powerUpStartTime       = 0.0;
    _gameTotalTime          = 1.0;
    [super tearDown];
}

- (void)testStringForPowerUp {
    XCTAssertEqualObjects(kSIPowerUpTypeNone, [SIPowerUp stringForPowerUp:SIPowerUpTypeNone]);
    
    XCTAssertEqualObjects(kSIPowerUpTypeFallingMonkeys, [SIPowerUp stringForPowerUp:SIPowerUpTypeFallingMonkeys]);
    
    XCTAssertEqualObjects(kSIPowerUpTypeTimeFreeze, [SIPowerUp stringForPowerUp:SIPowerUpTypeTimeFreeze]);
    
    XCTAssertEqualObjects(kSIPowerUpTypeRapidFire, [SIPowerUp stringForPowerUp:SIPowerUpTypeRapidFire]);
}
- (void)testDurationForPowerUp {
    /*Power Up None*/
    XCTAssertEqual(SIPowerUpDurationNone, [SIPowerUp durationForPowerUp:SIPowerUpTypeNone]);
    
    /*Power Up Time Freeze*/
    XCTAssertEqual(SIPowerUpDurationTimeFreeze, [SIPowerUp durationForPowerUp:SIPowerUpTypeTimeFreeze]);
    
    /*Power Up Rapid Fire*/
    XCTAssertEqual(SIPowerUpDurationRapidFire, [SIPowerUp durationForPowerUp:SIPowerUpTypeRapidFire]);
}
- (void)testCostForPowerUp {
    /*Power Up None*/
    XCTAssertEqual(SIPowerUpCostNone, [SIPowerUp costForPowerUp:SIPowerUpTypeNone]);
    
    /*Power Up Falling Monkeys*/
    XCTAssertEqual(SIPowerUpCostFallingMonkeys, [SIPowerUp costForPowerUp:SIPowerUpTypeFallingMonkeys]);
    
    /*Power Up Time Freeze*/
    XCTAssertEqual(SIPowerUpCostTimeFreeze, [SIPowerUp costForPowerUp:SIPowerUpTypeTimeFreeze]);
    
    /*Power Up Rapid Fire*/
    XCTAssertEqual(SIPowerUpCostRapidFire, [SIPowerUp costForPowerUp:SIPowerUpTypeRapidFire]);
}
- (void)testPowerUpForString {
    XCTAssertEqual(SIPowerUpTypeNone, [SIPowerUp powerUpForString:kSIPowerUpTypeNone]);

    XCTAssertEqual(SIPowerUpTypeFallingMonkeys, [SIPowerUp powerUpForString:kSIPowerUpTypeFallingMonkeys]);

    XCTAssertEqual(SIPowerUpTypeTimeFreeze, [SIPowerUp powerUpForString:kSIPowerUpTypeTimeFreeze]);

    XCTAssertEqual(SIPowerUpTypeRapidFire, [SIPowerUp powerUpForString:kSIPowerUpTypeRapidFire]);
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

/**
 TEST: + (BOOL)canStartPowerUp:(SIPowerUpType)powerUp powerUpArray:(NSArray *)powerUpArray {

 As a user I want to start falling monkey power up
 if powerUpArray is empty ? Return YES : check contents of powerup array
 don't allow start if one of the power ups is rapid fire
 
 As a user I want to start rapid fire
 if powerUpArray is empty ? Return YES : check contents of powerup array
 don't allow start if one of the power ups is falling monkey
 
 As a user I want to start time freeze
 go right ahead man
 
 */
- (void)testCanStartPowerUpFallingMonkey {
    /*Test empty array condition*/
    XCTAssert([SIPowerUp canStartPowerUp:SIPowerUpTypeFallingMonkeys powerUpArray:nil]);
    
    /*Test array with rapid fire*/
    SIPowerUp *powerUpRapidFire     = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeRapidFire startTime:0];
    NSArray *powerUpArray           = [NSArray arrayWithObject:powerUpRapidFire];
    XCTAssertEqual([SIPowerUp canStartPowerUp:SIPowerUpTypeFallingMonkeys powerUpArray:powerUpArray], NO);
    
    /*Test array with slow motion*/
    SIPowerUp *powerUpSlowMotion    = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeTimeFreeze startTime:0];
    powerUpArray                    = [NSArray arrayWithObject:powerUpSlowMotion];
    XCTAssertEqual([SIPowerUp canStartPowerUp:SIPowerUpTypeFallingMonkeys powerUpArray:powerUpArray], YES);
    
    /*Test array with falling monkey it... does it prevent?*/
    SIPowerUp *powerUpFalingMonkey  = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeFallingMonkeys startTime:0];
    powerUpArray                    = [NSArray arrayWithObject:powerUpFalingMonkey];
    XCTAssertEqual([SIPowerUp canStartPowerUp:SIPowerUpTypeFallingMonkeys powerUpArray:powerUpArray], NO);
    
    /*Test array with both time freeze and rapid fire*/
    powerUpArray                    = [NSArray arrayWithObjects:powerUpRapidFire,powerUpSlowMotion, nil];
    XCTAssertEqual([SIPowerUp canStartPowerUp:SIPowerUpTypeFallingMonkeys powerUpArray:powerUpArray], NO);
}

- (void)testCanStartPowerUpRapidFire {
    NSArray *powerUpArray;
    /*Test empty array condition*/
    XCTAssert([SIPowerUp canStartPowerUp:SIPowerUpTypeRapidFire powerUpArray:nil]);
    
    /*Test array with slow motion*/
    SIPowerUp *powerUpSlowMotion    = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeTimeFreeze startTime:0];
    powerUpArray                    = [NSArray arrayWithObject:powerUpSlowMotion];
    XCTAssertEqual([SIPowerUp canStartPowerUp:SIPowerUpTypeRapidFire powerUpArray:powerUpArray], YES);
    
    /*Test array with falling monkey it... does it prevent?*/
    SIPowerUp *powerUpFalingMonkey  = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeFallingMonkeys startTime:0];
    powerUpArray                    = [NSArray arrayWithObject:powerUpFalingMonkey];
    XCTAssertEqual([SIPowerUp canStartPowerUp:SIPowerUpTypeRapidFire powerUpArray:powerUpArray], NO);
    
    /*Test array with rapid fire*/
    SIPowerUp *powerUpRapidFire     = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeRapidFire startTime:0];
    powerUpArray                    = [NSArray arrayWithObject:powerUpRapidFire];
    XCTAssertEqual([SIPowerUp canStartPowerUp:SIPowerUpTypeRapidFire powerUpArray:powerUpArray], NO);
    
    /*Test array with both time freeze and rapid fire*/
    powerUpArray                    = [NSArray arrayWithObjects:powerUpFalingMonkey,powerUpSlowMotion, nil];
    XCTAssertEqual([SIPowerUp canStartPowerUp:SIPowerUpTypeRapidFire powerUpArray:powerUpArray], NO);
}

- (void)testCanStartPowerUpTimeFreeze {
    NSArray *powerUpArray;
    /*Test empty array condition*/
    XCTAssert([SIPowerUp canStartPowerUp:SIPowerUpTypeTimeFreeze powerUpArray:nil]);
    
    /*Test array with time freeze.. should be no, duplicate check...*/
    SIPowerUp *powerUpTimeFreeze    = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeTimeFreeze startTime:0];
    powerUpArray                    = [NSArray arrayWithObject:powerUpTimeFreeze];
    XCTAssertEqual([SIPowerUp canStartPowerUp:SIPowerUpTypeTimeFreeze powerUpArray:powerUpArray], NO);
    
    /*Test array with falling monkey it... does it prevent?*/
    SIPowerUp *powerUpFalingMonkey  = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeFallingMonkeys startTime:0];
    powerUpArray                    = [NSArray arrayWithObject:powerUpFalingMonkey];
    XCTAssertEqual([SIPowerUp canStartPowerUp:SIPowerUpTypeTimeFreeze powerUpArray:powerUpArray], YES);
    
    /*Test array with rapid fire*/
    SIPowerUp *powerUpRapidFire     = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeRapidFire startTime:0];
    powerUpArray                    = [NSArray arrayWithObject:powerUpRapidFire];
    XCTAssertEqual([SIPowerUp canStartPowerUp:SIPowerUpTypeTimeFreeze powerUpArray:powerUpArray], YES);
    
    /*Test array with both time freeze and rapid fire*/
    powerUpArray                    = [NSArray arrayWithObjects:powerUpRapidFire,powerUpFalingMonkey, nil];
    XCTAssertEqual([SIPowerUp canStartPowerUp:SIPowerUpTypeTimeFreeze powerUpArray:powerUpArray], YES);
}

- (void)testCanStartPowerUpNoMoney {
    NSNumber *numberOfCoins = [NSNumber numberWithInt:0];
    //given a mock MKStoreKit
    id mockMKStoreKit = [OCMockObject niceMockForClass:[MKStoreKit class]];
    [[[mockMKStoreKit stub] andReturn:mockMKStoreKit] sharedKit];
    
    [[[mockMKStoreKit expect] andReturn:numberOfCoins] availableCreditsForConsumable:kSIIAPConsumableIDCoins];
    
    BOOL ret = [SIPowerUp canStartPowerUp:SIPowerUpTypeFallingMonkeys powerUpArray:nil];
    
    XCTAssertEqual(ret, NO);
    
    //verify the return value
    [mockMKStoreKit verify];
    
    //clean up the mock
    [mockMKStoreKit stopMocking];
}
- (void)testCanStartPowerUpPerfectAmountOfMoney {
    NSNumber *numberOfCoins = [NSNumber numberWithInt:[SIPowerUp costForPowerUp:SIPowerUpTypeFallingMonkeys]];
    //given a mock MKStoreKit
    id mockMKStoreKit = [OCMockObject niceMockForClass:[MKStoreKit class]];
    [[[mockMKStoreKit stub] andReturn:mockMKStoreKit] sharedKit];
    
    [[[mockMKStoreKit expect] andReturn:numberOfCoins] availableCreditsForConsumable:kSIIAPConsumableIDCoins];
    
    BOOL ret = [SIPowerUp canStartPowerUp:SIPowerUpTypeFallingMonkeys powerUpArray:nil];
    
    XCTAssertEqual(ret, YES);
    
    //verify the return value
    [mockMKStoreKit verify];
    
    //clean up the mock
    [mockMKStoreKit stopMocking];
}
- (void)testCanStartPowerUpExcessMoney {
    NSNumber *numberOfCoins = [NSNumber numberWithInt:100];
    //given a mock MKStoreKit
    id mockMKStoreKit = [OCMockObject niceMockForClass:[MKStoreKit class]];
    [[[mockMKStoreKit stub] andReturn:mockMKStoreKit] sharedKit];
    
    [[[mockMKStoreKit expect] andReturn:numberOfCoins] availableCreditsForConsumable:kSIIAPConsumableIDCoins];
    
    BOOL ret = [SIPowerUp canStartPowerUp:SIPowerUpTypeFallingMonkeys powerUpArray:nil];
    
    XCTAssertEqual(ret, YES);
    
    //verify the return value
    [mockMKStoreKit verify];
    
    //clean up the mock
    [mockMKStoreKit stopMocking];
}
/**
 + (BOOL)isPowerUpActive:(SIPowerUpType)powerUp powerUpArray:(NSArray *)powerUpArray {
 for (SIPowerUp *powerUpClass in powerUpArray) {
 if (powerUp == powerUpClass.type) {
 return YES;
 }
 }
 return NO;
 }
 */
- (void)testIsPowerUpActive {
    NSArray *powerUpArray;
    
    SIPowerUp *powerUpTimeFreeze    = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeTimeFreeze startTime:0];
    powerUpArray                    = [NSArray arrayWithObject:powerUpTimeFreeze];
    XCTAssert([SIPowerUp isPowerUpActive:SIPowerUpTypeTimeFreeze powerUpArray:powerUpArray]);
    XCTAssertEqual([SIPowerUp isPowerUpActive:SIPowerUpTypeRapidFire powerUpArray:powerUpArray], NO);
    XCTAssertEqual([SIPowerUp isPowerUpActive:SIPowerUpTypeFallingMonkeys powerUpArray:powerUpArray], NO);

    SIPowerUp *powerUpRapidFire     = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeRapidFire startTime:0];
    powerUpArray                    = [NSArray arrayWithObject:powerUpRapidFire];
    XCTAssert([SIPowerUp isPowerUpActive:SIPowerUpTypeRapidFire powerUpArray:powerUpArray]);
    XCTAssertEqual([SIPowerUp isPowerUpActive:SIPowerUpTypeTimeFreeze powerUpArray:powerUpArray], NO);
    XCTAssertEqual([SIPowerUp isPowerUpActive:SIPowerUpTypeFallingMonkeys powerUpArray:powerUpArray], NO);
    
    SIPowerUp *powerUpFallingMonkey = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeFallingMonkeys startTime:0];
    powerUpArray                    = [NSArray arrayWithObject:powerUpFallingMonkey];
    XCTAssert([SIPowerUp isPowerUpActive:SIPowerUpTypeFallingMonkeys powerUpArray:powerUpArray]);
    XCTAssertEqual([SIPowerUp isPowerUpActive:SIPowerUpTypeRapidFire powerUpArray:powerUpArray], NO);
    XCTAssertEqual([SIPowerUp isPowerUpActive:SIPowerUpTypeTimeFreeze powerUpArray:powerUpArray], NO);
    
    powerUpArray                    = [NSArray arrayWithObjects:powerUpFallingMonkey, powerUpRapidFire, powerUpTimeFreeze,nil];
    XCTAssert([SIPowerUp isPowerUpActive:SIPowerUpTypeFallingMonkeys powerUpArray:powerUpArray]);
    XCTAssert([SIPowerUp isPowerUpActive:SIPowerUpTypeRapidFire powerUpArray:powerUpArray]);
    XCTAssert([SIPowerUp isPowerUpActive:SIPowerUpTypeTimeFreeze powerUpArray:powerUpArray]);

    powerUpArray                    = [NSArray arrayWithObjects:powerUpFallingMonkey, powerUpTimeFreeze,nil];
    XCTAssertEqual([SIPowerUp isPowerUpActive:SIPowerUpTypeRapidFire powerUpArray:powerUpArray], NO);

}

/**
 + (BOOL)isPowerUpArrayEmpty:(NSArray *)powerUpArray {
 if (powerUpArray == nil) {
 return YES;
 }
 
 if ([powerUpArray count] == 0) {
 return YES;
 }
 
 return NO;
 }
 */
- (void)testIsPowerUpArrayEmpty {
    NSArray *powerUpArray;
    
    XCTAssert([SIPowerUp isPowerUpArrayEmpty:powerUpArray]);
    
    powerUpArray                    = [NSArray array];
    XCTAssert([SIPowerUp isPowerUpArrayEmpty:powerUpArray]);
    
    SIPowerUp *powerUpFallingMonkey = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeFallingMonkeys startTime:0];
    powerUpArray                    = [NSArray arrayWithObject:powerUpFallingMonkey];
    XCTAssertEqual([SIPowerUp isPowerUpArrayEmpty:powerUpArray], NO);
}

/**
 Returns the maximum percent found in the powerup array
 + (float)maxDurationPercentOfPowerUpArray:(NSArray *)powerUpArray;
 */
- (void)testMaxPercentRemainingOfPowerUpArray {
    NSArray *powerUpArray;
    
    /*Test a nil array... what happens*/
    XCTAssertEqualWithAccuracy([SIPowerUp maxPercentOfPowerUpArray:powerUpArray], 0.0f, 0.05f);

    /*Test an allocated but empty array... what happens*/
    powerUpArray                            = [NSArray array];
    XCTAssertEqualWithAccuracy([SIPowerUp maxPercentOfPowerUpArray:powerUpArray], 0.0f, 0.05f);
    
    /*Test with one power up*/
    SIPowerUp *powerUpFallingMonkey         = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeFallingMonkeys startTime:0.0f];
    powerUpFallingMonkey.percentRemaining   = 0.5f;
    powerUpArray                            = [NSArray arrayWithObject:powerUpFallingMonkey];
    XCTAssertEqualWithAccuracy([SIPowerUp maxPercentOfPowerUpArray:powerUpArray], 0.5f, 0.05f);

    SIPowerUp *powerUpRapidFire             = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeRapidFire startTime:0];
    powerUpRapidFire.percentRemaining       = 0.8f;
    powerUpArray                            = [NSArray arrayWithObjects:powerUpFallingMonkey, powerUpRapidFire,nil];
    XCTAssertEqualWithAccuracy([SIPowerUp maxPercentOfPowerUpArray:powerUpArray], 0.8f, 0.05f);

    
}

/**
 Traverses through powerUpArray and recaluclates all powerup percentages using the composite time,
 Uses properties to do with start time too and duration of power up
 Callback returns any powerup with a percentage less than 0.01 to be deactivated
 + (float)powerUpPercentRemaining:(NSArray *)powerUpArray compositeTime:(float)compositeTime withCallback:(void (^)(SIPowerUp *powerUpToDeactivate))callback;
 */
- (void)testPowerUpPercentRemainingNil {
    
    /*Test a nil array... what happens*/
    XCTAssertEqualWithAccuracy([SIPowerUp powerUpPercentRemaining:nil gameTimeTotal:0.0 timeFreezeMultiplier:1.0 withCallback:nil],0.0f,0.05f);
    
}

- (void)testPowerUpPercentRemainingNoObjects {
    /*Test an allocated but empty array... what happens*/
    XCTAssertEqualWithAccuracy([SIPowerUp powerUpPercentRemaining:_powerUpArray gameTimeTotal:0.0 timeFreezeMultiplier:1.0 withCallback:nil],0.0f,0.05f);
}

- (void)testPowerUpPercentRemainingWithOneObject {
    /*Test with one power up*/
    SIPowerUp *powerUpFallingMonkey         = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeFallingMonkeys startTime:_powerUpStartTime];
    _powerUpArray                           = [NSArray arrayWithObject:powerUpFallingMonkey];
    XCTAssertEqualWithAccuracy([SIPowerUp powerUpPercentRemaining:_powerUpArray gameTimeTotal:0.0 timeFreezeMultiplier:1.0 withCallback:nil],0.0f,0.05f);

}

- (void)testPowerUpPercentRemainingMultiplePowerUpsOneShallExpire {
    SIPowerUp *powerUpRapidFire             = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeRapidFire startTime:_powerUpStartTime];
    SIPowerUp *powerUpTimeFreeze            = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeTimeFreeze startTime:_powerUpStartTime];
    _powerUpArray                            = [NSArray arrayWithObjects:powerUpRapidFire, powerUpTimeFreeze,nil];
    // (8 - 5) / 8 = 0.0 percent remaining
    float nonZeroTest = [SIPowerUp powerUpPercentRemaining:_powerUpArray gameTimeTotal:_gameTotalTime * 5 timeFreezeMultiplier:1 withCallback:^(SIPowerUp *powerUpToDeactivate) {
        XCTAssertEqual(powerUpToDeactivate.type, SIPowerUpTypeRapidFire);
    }];
    XCTAssertEqualWithAccuracy(nonZeroTest,0.375f,0.05f);
}

- (void)testPowerUpPercentRemainingMultiplePowerUps {

    SIPowerUp *powerUpRapidFire             = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeRapidFire startTime:_powerUpStartTime];
    SIPowerUp *powerUpTimeFreeze            = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeTimeFreeze startTime:_powerUpStartTime];
    _powerUpArray                            = [NSArray arrayWithObjects:powerUpRapidFire, powerUpTimeFreeze,nil];

    // Rapid Fire:  1 - ((1 - 0)/3) == 0.667
    // Time Freeze: 1 - ((1 - 0)/8) == 0.8
    float expectedTime = 1 - ((_gameTotalTime - _powerUpStartTime) / [SIPowerUp durationForPowerUp:SIPowerUpTypeTimeFreeze]);
    XCTAssertEqualWithAccuracy([SIPowerUp powerUpPercentRemaining:_powerUpArray gameTimeTotal:_gameTotalTime timeFreezeMultiplier:1 withCallback:nil],expectedTime,0.05f);

}

- (void)testPowerUpPercentRemainingPercentGreaterThanZero {
    
    SIPowerUp *powerUpRapidFire             = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeRapidFire startTime:_powerUpStartTime];
    
    _powerUpArray                           = [NSArray arrayWithObjects:powerUpRapidFire,nil];
    // 1 - ((3 - 1) / 3)  = 0.667 percent remaining
    XCTAssertEqualWithAccuracy([SIPowerUp powerUpPercentRemaining:_powerUpArray gameTimeTotal:_gameTotalTime timeFreezeMultiplier:1.0 withCallback:nil],0.667f,0.05f);

    // 1 - ((3 - 2) / 3) = 0.333 percent remaining
    XCTAssertEqualWithAccuracy([SIPowerUp powerUpPercentRemaining:_powerUpArray gameTimeTotal:_gameTotalTime * 2 timeFreezeMultiplier:1.0 withCallback:nil],0.333f,0.05f);

}

- (void)testPowerUpPercentRemainingPercentZero {
    
    SIPowerUp *powerUpRapidFire             = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeRapidFire startTime:_powerUpStartTime];
    SIPowerUp *powerUpTimeFreeze            = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeTimeFreeze startTime:_powerUpStartTime];
    _powerUpArray                           = [NSArray arrayWithObjects:powerUpRapidFire, powerUpTimeFreeze,nil];

    _gameTotalTime                          = _gameTotalTime * 3;
    // Rapid Fire:  1 - ((3 - 0) / 3) = 0.0 percent remaining
    // Time Freeze: 1 - ((3 - 0) / 8) = 0.625 percent
    
    float expectedOutput = 1 - ((_gameTotalTime - _powerUpStartTime) / [SIPowerUp durationForPowerUp:SIPowerUpTypeTimeFreeze]);
    
    float actualOutput = [SIPowerUp powerUpPercentRemaining:_powerUpArray gameTimeTotal:_gameTotalTime timeFreezeMultiplier:1.0 withCallback:^(SIPowerUp *powerUpToDeactivate) {
        XCTAssertEqual(powerUpToDeactivate.type, SIPowerUpTypeRapidFire);
    }];
    XCTAssertEqualWithAccuracy(actualOutput,expectedOutput,0.05f);
   
}

- (void)testPowerUpPercentRemainingStartTimeLessThanGameTime {
    _powerUpStartTime = 5.0;
    
    SIPowerUp *powerUpFallingMonkey         = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeFallingMonkeys startTime:_powerUpStartTime];
    SIPowerUp *powerUpRapidFire             = [[SIPowerUp alloc] initWithPowerUp:SIPowerUpTypeRapidFire startTime:_powerUpStartTime];
    
    _powerUpArray                           = [NSArray arrayWithObjects:powerUpFallingMonkey, powerUpRapidFire,nil];

    XCTAssertEqualWithAccuracy([SIPowerUp powerUpPercentRemaining:_powerUpArray gameTimeTotal:_gameTotalTime timeFreezeMultiplier:1.0 withCallback:nil],0.0f,0.05f);

}
@end