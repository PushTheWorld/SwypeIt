//
//  SIIAPUtilityTests.m
//  Swype It
//
//  Created by Andrew Keller on 7/23/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
// Local Controller Import
#import "SIIAPUtility.h"
// Framework Import
#import <OCMock/OCMock.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
// Support/Data Class Imports
#import "SIConstants.h"
// Other Imports
@interface SIIAPUtilityTests : XCTestCase

@end

@implementation SIIAPUtilityTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testProductPriceForSIIAPPack {
    /*Bag of Coins*/
    XCTAssertEqual([[NSDecimalNumber decimalNumberWithString:@"0.99"] floatValue], [[SIIAPUtility productPriceForSIIAPPack:SIIAPPackSmall] floatValue]);
    
    /*Pile of Coins*/
    XCTAssertEqual([[NSDecimalNumber decimalNumberWithString:@"4.99"] floatValue], [[SIIAPUtility productPriceForSIIAPPack:SIIAPPackMedium] floatValue]);
    
    /*Bucket of Coins*/
    XCTAssertEqual([[NSDecimalNumber decimalNumberWithString:@"9.99"] floatValue], [[SIIAPUtility productPriceForSIIAPPack:SIIAPPackLarge] floatValue]);
    
    /*Chest of Coins*/
    XCTAssertEqual([[NSDecimalNumber decimalNumberWithString:@"24.99"] floatValue], [[SIIAPUtility productPriceForSIIAPPack:SIIAPPackExtraLarge] floatValue]);
}

@end
