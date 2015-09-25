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

- (void)testIAPButtonStringForSIIAPPack {
    /*Bag of Coins*/
    XCTAssertEqualObjects(@"Pile of Coins", [SIIAPUtility buttonTextForSIIAPPack:SIIAPPackSmall]);
    
    /*Pile of Coins*/
    XCTAssertEqualObjects(@"Bucket of Coins", [SIIAPUtility buttonTextForSIIAPPack:SIIAPPackMedium]);
    
    /*Bucket of Coins*/
    XCTAssertEqualObjects(@"Bag of Coins", [SIIAPUtility buttonTextForSIIAPPack:SIIAPPackLarge]);
    
    /*Chest of Coins*/
    XCTAssertEqualObjects(@"Chest of Coins", [SIIAPUtility buttonTextForSIIAPPack:SIIAPPackExtraLarge]);
}

- (void)testIAPButtonNodeNameForSIIAPPack {
    /*Bag of Coins*/
    XCTAssertEqualObjects(kSINodeNodePile, [SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackSmall]);
    
    /*Pile of Coins*/
    XCTAssertEqualObjects(kSINodeNodeBucket, [SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackMedium]);
    
    /*Bucket of Coins*/
    XCTAssertEqualObjects(kSINodeNodeBag, [SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackLarge]);
    
    /*Chest of Coins*/
    XCTAssertEqualObjects(kSINodeNodeChest, [SIIAPUtility buttonNodeNameNodeForSIIAPPack:SIIAPPackExtraLarge]);
}

- (void)testIAPButtonNodeLabelDescriptionForSIIAPPack {
    /*Bag of Coins*/
    XCTAssertEqualObjects(kSINodeLabelDescriptionPile, [SIIAPUtility buttonNodeNameLabelDescriptionForSIIAPPack:SIIAPPackSmall]);
    
    /*Pile of Coins*/
    XCTAssertEqualObjects(kSINodeLabelDescriptionBucket, [SIIAPUtility buttonNodeNameLabelDescriptionForSIIAPPack:SIIAPPackMedium]);
    
    /*Bucket of Coins*/
    XCTAssertEqualObjects(kSINodeLabelDescriptionBag, [SIIAPUtility buttonNodeNameLabelDescriptionForSIIAPPack:SIIAPPackLarge]);
    
    /*Chest of Coins*/
    XCTAssertEqualObjects(kSINodeLabelDescriptionChest, [SIIAPUtility buttonNodeNameLabelDescriptionForSIIAPPack:SIIAPPackExtraLarge]);
}

- (void)testIAPButtonNodeLabelPriceForSIIAPPack {
    /*Bag of Coins*/
    XCTAssertEqualObjects(kSINodeLabelPriceBag, [SIIAPUtility buttonNodeNameLabelPriceForSIIAPPack:SIIAPPackLarge]);
    
    /*Pile of Coins*/
    XCTAssertEqualObjects(kSINodeLabelPricePile, [SIIAPUtility buttonNodeNameLabelPriceForSIIAPPack:SIIAPPackSmall]);
    
    /*Bucket of Coins*/
    XCTAssertEqualObjects(kSINodeLabelPriceBucket, [SIIAPUtility buttonNodeNameLabelPriceForSIIAPPack:SIIAPPackMedium]);
    
    /*Chest of Coins*/
    XCTAssertEqualObjects(kSINodeLabelPriceChest, [SIIAPUtility buttonNodeNameLabelPriceForSIIAPPack:SIIAPPackExtraLarge]);
}

- (void)testIAPProductIDForSIIAPPack {
    /*Bag of Coins*/
    XCTAssertEqualObjects(kSIIAPProductIDCoinPackSmall, [SIIAPUtility productIDForSIIAPPack:SIIAPPackSmall]);
    
    /*Pile of Coins*/
    XCTAssertEqualObjects(kSIIAPProductIDCoinPackMedium,[SIIAPUtility productIDForSIIAPPack:SIIAPPackMedium]);
    
    /*Bucket of Coins*/
    XCTAssertEqualObjects(kSIIAPProductIDCoinPackLarge, [SIIAPUtility productIDForSIIAPPack:SIIAPPackLarge]);
    
    /*Chest of Coins*/
    XCTAssertEqualObjects(kSIIAPProductIDCoinPackExtraLarge, [SIIAPUtility productIDForSIIAPPack:SIIAPPackExtraLarge]);
}

- (void)testProductForSIIAPPackProductFound {
    id mockSKProduct = [OCMockObject niceMockForClass:[SKProduct class]];
    [[[mockSKProduct stub] andReturn:[SIIAPUtility productIDForSIIAPPack:SIIAPPackExtraLarge]] productIdentifier];

    NSArray *array = @[mockSKProduct];
    
    [SIIAPUtility productForSIIAPPack:SIIAPPackExtraLarge inPackArray:array withBlock:^(BOOL succeeded, SKProduct *product) {
        XCTAssertEqual(succeeded, YES);
        XCTAssertEqualObjects(product.productIdentifier, [mockSKProduct productIdentifier]);
    }];
    
    [mockSKProduct verify];
    
    [mockSKProduct stopMocking];
}

- (void)testProductForSIIAPPackProductNotFound {
    id mockSKProduct = [OCMockObject niceMockForClass:[SKProduct class]];
    [[[mockSKProduct stub] andReturn:[SIIAPUtility productIDForSIIAPPack:SIIAPPackExtraLarge]] productIdentifier];
    
    NSArray *array = @[mockSKProduct];
    
    [SIIAPUtility productForSIIAPPack:SIIAPPackLarge inPackArray:array withBlock:^(BOOL succeeded, SKProduct *product) {
        XCTAssertEqual(succeeded, NO);
        XCTAssertNil(product);
    }];
    
    [mockSKProduct verify];
    
    [mockSKProduct stopMocking];
    
}
- (void)testProductForSIIAPPackNilProductArray {
    NSArray *array;
    
    [SIIAPUtility productForSIIAPPack:SIIAPPackLarge inPackArray:array withBlock:^(BOOL succeeded, SKProduct *product) {
        XCTAssertEqual(succeeded, NO);
        XCTAssertNil(product);
    }];
    
}

@end
