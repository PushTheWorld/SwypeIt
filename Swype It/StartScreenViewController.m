//  StartScreenViewController.m
//  Swype It
//  Created by Andrew Keller on 6/21/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//
//  Purpose: Thie is the startign screen for the swype it game
//
// Local Controller Import
#import "StartScreenViewController.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
// Support/Data Class Imports
// Other Imports


@interface StartScreenViewController () {
    
}
#pragma mark - Private Constraint CGFloats
@property (assign, nonatomic) CGFloat        buttonHeight;

#pragma mark - Private Properties

#pragma mark - Constraints

#pragma mark - UI Controls
@property (strong, nonatomic) UIButton      *launchGameButtom;
@property (strong, nonatomic) UILabel       *welcomeLabel;


@end

@implementation StartScreenViewController

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
}
- (void)createConstants {
    if (IS_IPHONE_4) {
        self.buttonHeight       = 28.0f;
    } else if (IS_IPHONE_5) {
        self.buttonHeight       = 32.0f;
    } else if (IS_IPHONE_6) {
        self.buttonHeight       = 36.0f;
    } else if (IS_IPHONE_6_PLUS) {
        self.buttonHeight       = 40.0f;
    } else {
        self.buttonHeight       = 40.0f;
    }
    
}
- (void)createControls {
    
}
- (void)setupControls {
    
}
- (void)layoutControls {
    
}
@end
