//  SIAdBannerTests.m
//  Swype It
//
//  Created by Andrew Keller on 9/5/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
#import <XCTest/XCTest.h>
#import "SIAdBannerNode.h"
#import "SIConstants.h"

@interface SIAdBannerTests : XCTestCase

@end

@implementation SIAdBannerTests {
    SIAdBannerNode *_adContentNode;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSizeWhenAdContentIsNil {
    if (_adContentNode) {
        _adContentNode = nil;
    }
    
    CGSize adSize = _adContentNode.size;
    
    XCTAssertLessThan(adSize.height, EPSILON_NUMBER);
    
    XCTAssertLessThan(adSize.width, EPSILON_NUMBER);
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

@end
