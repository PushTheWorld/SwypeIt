//
//  SIPopupNodeTests.m
//  Swype It
//
//  Created by Andrew Keller on 9/29/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SpriteKit/SpriteKit.h>
//#import "SIPopupNode.h"


@interface SIPopupNodeTests : XCTestCase

@property (nonatomic) UIViewController *vc;

@end

@implementation SIPopupNodeTests {
    SKView *_skView;
    SKScene *_skScene;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.vc = [[UIViewController alloc] init];
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    _skView = [[SKView alloc] initWithFrame:applicationFrame];
    
    self.vc.view = _skView;
    
    _skScene = [[SKScene alloc] initWithSize:applicationFrame.size];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testDismissButton {
    
    [_skView presentScene:_skScene];
}


@end
