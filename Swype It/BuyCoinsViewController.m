//  BuyCoinsViewController.m
//  Swype It
//
//  Created by Andrew Keller on 7/14/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: Thie is the startign screen for the swype it game
//
// Local Controller Import
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIConstants.h"
// Other Imports

#import "BuyCoinsViewController.h"

@interface BuyCoinsViewController () {
    
}

@property (strong, nonatomic) UIButton *purchasePackSingleButton;
@property (strong, nonatomic) UIButton *purchasePackMediumButton;
@property (strong, nonatomic) UIButton *purchasePackLargeButton;
@property (strong, nonatomic) UIButton *purchasePackExtraLargeButton;

@end

@implementation BuyCoinsViewController

#pragma mark - UI Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUserInterface];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)setupUserInterface {
    [self createConstants];
    [self createControls];
    [self setupControls];
    [self layoutControls];
    [self setupNav];
}
- (void)createConstants {
    
}
- (void)createControls {
    self.purchasePackSingleButton       = [UIButton buttonWithType:UIButtonTypeSystem];
    self.purchasePackMediumButton       = [UIButton buttonWithType:UIButtonTypeSystem];
    self.purchasePackLargeButton        = [UIButton buttonWithType:UIButtonTypeSystem];
    self.purchasePackExtraLargeButton   = [UIButton buttonWithType:UIButtonTypeSystem];
}
- (void)setupControls {

    [self.purchasePackSingleButton setTranslatesAutoresizingMaskIntoConstraints:NO];
}
- (void)layoutControls {
    
}
- (void)setupNav {
    
}

@end
