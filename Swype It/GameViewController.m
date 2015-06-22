//  GameViewController.m
//  Swype It
//  Created by Andrew Keller on 6/21/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is the game view controller
//
// Local Controller Import
#import "AppSingleton.h"
#import "GameViewController.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "Game.h"
#import "SIConstants.h"
// Other Imports

@interface GameViewController () {
    
}
#pragma mark - Private CGFloats
@property (assign, nonatomic) CGFloat    fontSize;

#pragma mark - Private Bools
@property (assign, nonatomic) BOOL       isGameActive;

#pragma mark - Private Properties

#pragma mark - Constraints

#pragma mark - UI Controls
@property (strong, nonatomic) NSString  *gameMode;
@property (strong, nonatomic) UIFont    *moveCommandFont;
@property (strong, nonatomic) UILabel   *moveCommandLabel;


@end

@implementation GameViewController

- (instancetype)initWithGameMode:(NSString *)gameMode {
    self = [super init];
    if (self) {
        self.gameMode = gameMode;
        [self configureForGameMode:gameMode];
    }
    return self;
}

- (void)configureForGameMode:(NSString *)gameMode {
    NSLog(@"%@ game starting!",gameMode);
    [AppSingleton singleton].isGameActive               = YES;
    [AppSingleton singleton].currentGame                = [[Game alloc] init];
    [AppSingleton singleton].currentGame.currentPoints  = 0.0f;
    [AppSingleton singleton].currentGame.gameMode       = gameMode;
}

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
    self.moveCommandLabel           = [[UILabel alloc] init];
    
}
- (void)createControls {
    if (IS_IPHONE_4) {
        self.fontSize               = 20.0f;
    } else if (IS_IPHONE_5) {
        self.fontSize               = 24.0f;
    } else if (IS_IPHONE_6) {
        self.fontSize               = 28.0f;
    } else if (IS_IPHONE_6_PLUS) {
        self.fontSize               = 32.0f;
    } else {
        self.fontSize               = 36.0f;
    }
    
    /*Init Fonts*/
    self.moveCommandFont            = [UIFont fontWithName:@"HelveticaNeue-Medium" size:self.fontSize];;

}
- (void)setupControls {
    self.moveCommandLabel.textColor = [UIColor whiteColor];
    self.moveCommandLabel.font      = self.moveCommandFont;
    self.moveCommandLabel.text      = kSIMoveCommandSwype;
    [self.moveCommandLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
}
- (void)layoutControls {
    /*Add the subviews to the view*/
    [self.view addSubview:self.moveCommandLabel];
    
    /*Move Command Label*/
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.moveCommandLabel
                               attribute             : NSLayoutAttributeCenterX
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterX
                               multiplier            : 1.0f
                               constant              : 0.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.moveCommandLabel
                               attribute             : NSLayoutAttributeCenterY
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterY
                               multiplier            : 1.0f
                               constant              : 0.0f]];

    
    
}
- (void)setupNav {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = [UIColor mainColor];
}



@end
