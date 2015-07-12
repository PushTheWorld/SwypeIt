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
#import "SVSegmentedControl.h"
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
@property (assign, nonatomic) CGFloat                segmentControlHeight;
@property (assign, nonatomic) CGFloat                verticalSpacing;

#pragma mark - Private Properties

#pragma mark - Constraints

#pragma mark - UI Controls
@property (strong, nonatomic) SVSegmentedControl    *gameModeSegmentedControl;
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
        self.buttonHeight           = 28.0f;
        self.segmentControlHeight   = 30.0f;
    } else if (IS_IPHONE_5) {
        self.buttonHeight           = 32.0f;
        self.segmentControlHeight   = 36.0f;
    } else if (IS_IPHONE_6) {
        self.buttonHeight           = 36.0f;
        self.segmentControlHeight   = 42.0f;
    } else if (IS_IPHONE_6_PLUS) {
        self.buttonHeight           = 40.0f;
        self.segmentControlHeight   = 48.0f;
    } else {
        self.buttonHeight           = 40.0f;
        self.segmentControlHeight   = 54.0f;
    }

    self.verticalSpacing            = 16.0;
    
}
- (void)createControls {
    self.titleImageView             = [[UIImageView         alloc] initWithImage:[UIImage imageNamed:kSIImageTitleLabel]];
    self.gameModeSegmentedControl   = [[SVSegmentedControl  alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"One Hand",@"Two Hand", nil]];
}
- (void)setupControls {
    
    /*Get the app singleton up and running*/
    [[AppSingleton singleton] initAppSingletonWithGameMode:kSIGameModeOneHand];
    
    self.titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.titleImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    [self.gameModeSegmentedControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.gameModeSegmentedControl.changeHandler = ^(NSUInteger newIndex) {
        /*Respond to changes here*/
        [[NSUserDefaults standardUserDefaults] setInteger:newIndex forKey:kSINSUserDefaultGameMode];
        [[NSUserDefaults standardUserDefaults] synchronize];
    };
    
    /*Tap to Start*/
    UITapGestureRecognizer *pgr     = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchGame)];
    pgr.numberOfTapsRequired        = 1;
    pgr.delegate                    = self;
    [self.view addGestureRecognizer:pgr];

    
}
- (void)layoutControls {
    /*Add the control items to the view*/
    [self.view addSubview:self.titleImageView];
    [self.view addSubview:self.gameModeSegmentedControl];
    
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
                               constant              : self.verticalSpacing]];
    /*Segment Controler*/
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.gameModeSegmentedControl
                               attribute             : NSLayoutAttributeHeight
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : self.segmentControlHeight]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.gameModeSegmentedControl
                               attribute             : NSLayoutAttributeWidth
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeWidth
                               multiplier            : 0.5f
                               constant              : 0.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.gameModeSegmentedControl
                               attribute             : NSLayoutAttributeCenterX
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterX
                               multiplier            : 1.0f
                               constant              : 0.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.gameModeSegmentedControl
                               attribute             : NSLayoutAttributeBottom
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeBottom
                               multiplier            : 1.0f
                               constant              : -self.verticalSpacing]];
    

}
- (void)setupNav {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.view.backgroundColor = [UIColor mainColor];
}
- (void)launchGame {
    NSInteger gameMode = [[NSUserDefaults standardUserDefaults] integerForKey:kSINSUserDefaultGameMode];
    NSString *gameModeString;
    switch (gameMode) {
        case GameModeOneHand:
            gameModeString = kSIGameModeOneHand;
            break;
            
        default:
            gameModeString = kSIGameModeTwoHand;
            break;
    }

    GameViewController *gameVC = [[GameViewController alloc] initWithGameMode:gameModeString];
    [self.navigationController pushViewController:gameVC animated:YES];
}

@end
