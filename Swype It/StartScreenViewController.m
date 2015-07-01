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
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIConstants.h"
// Other Imports


@interface StartScreenViewController () {
    
}
#pragma mark - Private Constraint CGFloats
@property (assign, nonatomic) CGFloat        buttonHeight;
@property (assign, nonatomic) CGFloat        verticalSpacing;

#pragma mark - Private Properties

#pragma mark - Constraints

#pragma mark - UI Controls
@property (strong, nonatomic) UIImageView   *titleImageView;



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
    } else if (IS_IPHONE_5) {
        self.buttonHeight           = 32.0f;
    } else if (IS_IPHONE_6) {
        self.buttonHeight           = 36.0f;
    } else if (IS_IPHONE_6_PLUS) {
        self.buttonHeight           = 40.0f;
    } else {
        self.buttonHeight               = 40.0f;
    }

    self.verticalSpacing            = 16.0;
    
}
- (void)createControls {
    self.titleImageView             = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kSIImageTitleLabel]];
    
}
- (void)setupControls {
    
    self.titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.titleImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Tap to Start*/
    UITapGestureRecognizer *pgr     = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchGameOriginal)];
    pgr.numberOfTapsRequired        = 1;
    pgr.delegate                    = self;
    [self.view addGestureRecognizer:pgr];

    
}
- (void)layoutControls {
    /*Add the control items to the view*/
    [self.view addSubview:self.titleImageView];
    
    /*Launch Game Button*/
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
}
- (void)setupNav {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.view.backgroundColor = [UIColor mainColor];
}
- (void)launchGameOriginal {
    GameViewController *gameVC = [[GameViewController alloc] initWithGameMode:kSIGameModeOriginal];
    [self.navigationController pushViewController:gameVC animated:YES];
}

@end
