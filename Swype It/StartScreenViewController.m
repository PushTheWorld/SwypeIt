//  StartScreenViewController.m
//  Swype It
//  Created by Andrew Keller on 6/21/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//
//  Purpose: Thie is the startign screen for the swype it game
//
// Local Controller Import
#import "GameViewController.h"
#import "StartScreenViewController.h"
// Framework Import
#import <QuartzCore/QuartzCore.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "AppSingleton.h"
#import "SIConstants.h"
// Other Imports



@interface StartScreenViewController () {
    
}

#pragma mark - Private Constraint CGFloats
@property (assign, nonatomic) CGFloat                buttonHeight;

#pragma mark - Private Properties

#pragma mark - Constraints

#pragma mark - UI Controls

@property (strong, nonatomic) UIButton              *oneHandGameButton;
@property (strong, nonatomic) UIButton              *twoHandGameButton;
@property (strong, nonatomic) UIImageView           *titleImageView;



@end

@implementation StartScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUserInterface];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)setupUserInterface {
    [self createConstants];
    [self createControls];
    [self setupControls];
    [self layoutControls];
    [self setupNav];
}
- (void)createConstants {
    if (IS_IPHONE_4) {
        self.buttonHeight           = 34.0f;
    } else if (IS_IPHONE_5) {
        self.buttonHeight           = 38.0f;
    } else if (IS_IPHONE_6) {
        self.buttonHeight           = 42.0f;
    } else if (IS_IPHONE_6_PLUS) {
        self.buttonHeight           = 46.0f;
    } else {
        self.buttonHeight           = 50.0f;
    }
    
}
- (void)createControls {
    self.titleImageView             = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kSIImageTitleLabel]];
    self.oneHandGameButton          = [UIButton            buttonWithType:UIButtonTypeCustom];
    self.twoHandGameButton          = [UIButton            buttonWithType:UIButtonTypeCustom];
}
- (void)setupControls {
    /*Game Title*/
    self.titleImageView.contentMode                 = UIViewContentModeScaleAspectFit;
    [self.titleImageView setTranslatesAutoresizingMaskIntoConstraints:NO];

    /*One Hand Game Button*/
    self.oneHandGameButton.tag                      = 0;
    self.oneHandGameButton.layer.cornerRadius       = 4.0f;
    self.oneHandGameButton.layer.masksToBounds      = YES;
    self.oneHandGameButton.layer.backgroundColor    = [UIColor whiteColor].CGColor;
    [self.oneHandGameButton setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
    [self.oneHandGameButton addTarget:self action:@selector(launchGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.oneHandGameButton setTitle:kSIButtonLabelStringOneHand forState:UIControlStateNormal];
    [self.oneHandGameButton setTranslatesAutoresizingMaskIntoConstraints:NO];

    /*Two Hand Game Button*/
    self.twoHandGameButton.tag                      = 1;
    self.twoHandGameButton.layer.cornerRadius       = 4.0f;
    self.twoHandGameButton.layer.masksToBounds      = YES;
    self.twoHandGameButton.layer.backgroundColor    = [UIColor whiteColor].CGColor;
    [self.twoHandGameButton setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
    [self.twoHandGameButton addTarget:self action:@selector(launchGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.twoHandGameButton setTitle:kSIButtonLabelStringTwoHand forState:UIControlStateNormal];
    [self.twoHandGameButton setTranslatesAutoresizingMaskIntoConstraints:NO];
}
- (void)layoutControls {
    /*Add the control items to the view*/
    [self.view addSubview:self.titleImageView];
    [self.view addSubview:self.oneHandGameButton];
    [self.view addSubview:self.twoHandGameButton];
    
    /*Welcome Label*/
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[titleLabel]-|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:@{@"titleLabel"              : self.titleImageView}]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.titleImageView
                               attribute             : NSLayoutAttributeTop
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeTop
                               multiplier            : 1.0f
                               constant              : VERTICAL_SPACING_8]];
    
    /*One Hand Button*/
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.oneHandGameButton
                               attribute             : NSLayoutAttributeHeight
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : self.buttonHeight]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.oneHandGameButton
                               attribute             : NSLayoutAttributeWidth
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeWidth
                               multiplier            : 0.5f
                               constant              : 1.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.oneHandGameButton
                               attribute             : NSLayoutAttributeCenterX
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterX
                               multiplier            : 1.0f
                               constant              : 0.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.oneHandGameButton
                               attribute             : NSLayoutAttributeBottom
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterY
                               multiplier            : 1.0f
                               constant              : -1.0f * VERTICAL_SPACING_8]];
    
    /*Two Hand Button*/
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.twoHandGameButton
                               attribute             : NSLayoutAttributeHeight
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : self.buttonHeight]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.twoHandGameButton
                               attribute             : NSLayoutAttributeWidth
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeWidth
                               multiplier            : 0.5f
                               constant              : 1.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.twoHandGameButton
                               attribute             : NSLayoutAttributeCenterX
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterX
                               multiplier            : 1.0f
                               constant              : 0.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.twoHandGameButton
                               attribute             : NSLayoutAttributeTop
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterY
                               multiplier            : 1.0f
                               constant              : VERTICAL_SPACING_8]];
    

}
- (void)setupNav {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.view.backgroundColor = [UIColor mainColor];
}
- (void)launchGame:(UIButton *)button {
    [[AppSingleton singleton] initAppSingletonWithGameMode:(GameMode)button.tag];
    GameViewController *gameVC = [[GameViewController alloc] initWithGameMode:(GameMode)button.tag];
    [self.navigationController pushViewController:gameVC animated:YES];
}

@end
