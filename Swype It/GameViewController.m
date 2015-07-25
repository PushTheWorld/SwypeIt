//  GameViewController.m
//  Swype It
//  Created by Andrew Keller on 6/21/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is the game view controller
//
// Defines
#define ACCELEROMETER_UPDATE_INTERVAL   0.05
#define REST_COUNT_THRESHOLD            2
#define SHAKE_THRESHOLD                 0.5
// Local Controller Import
#import "AppSingleton.h"
#import "IAPViewController.h"
#import "GameViewController.h"
#import "FallingMonkeyView.h"
// Framework Import
#import <CoreMotion/CoreMotion.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "MKStoreKit.h"
#import "YLProgressBar.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "Game.h"
// Other Imports

@interface GameViewController () <FallingMonkeyViewDelegate> {
    
}
#pragma mark - Private Primiatives
@property (assign, nonatomic) BOOL               isGameActive;
@property (assign, nonatomic) BOOL               isShakeActive;
@property (assign, nonatomic) CGSize             fallingMonkeySize;
@property (assign, nonatomic) CGFloat            fontSize;
@property (assign, nonatomic) CGFloat            progressViewBoarderWidth;
@property (assign, nonatomic) CGFloat            progressViewHeight;
@property (assign, nonatomic) int                gameMode;
@property (assign, nonatomic) int                monkeyDestroyedCount;


#pragma mark - Private Properties
@property (assign, nonatomic) NSInteger          restCount;

#pragma mark - Constraints

#pragma mark - UI Controls
@property (strong, nonatomic) UIButton          *rapidFireButton;
@property (strong, nonatomic) UIButton          *replayGameButton;
@property (strong, nonatomic) UIButton          *fallingMonkeysButton;
@property (strong, nonatomic) UIButton          *storeButton;
@property (strong, nonatomic) UIButton          *timeFreezeButton;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIFont            *nextMoveCommandFont;
@property (strong, nonatomic) UIFont            *moveCommandFont;
@property (strong, nonatomic) UIFont            *totalScoreFont;
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UILabel           *currentLevelLabel;
@property (strong, nonatomic) UILabel           *moveCommandLabel;
@property (strong, nonatomic) UILabel           *moveScoreLabel;
@property (strong, nonatomic) UILabel           *powerUpLabel;
@property (strong, nonatomic) UILabel           *totalScoreLabel;
@property (strong, nonatomic) YLProgressBar     *currentMoveProgressView;
@property (strong, nonatomic) YLProgressBar     *powerUpProgressView;



@end

@implementation GameViewController

+ (CGFloat)powerUpButtonHeight {
    if (IS_IPHONE_4) {
        return 30.0f;
    } else if (IS_IPHONE_5) {
        return 45.0f;
    } else if (IS_IPHONE_6) {
        return 55.0f;
    } else if (IS_IPHONE_6_PLUS) {
        return 60.0f;
    } else {
        return 70.0f;
    }
}

#pragma mark - Initialization Methods
- (instancetype)initWithGameMode:(SIGameMode)gameMode {
    self = [super init];
    if (self) {
        self.gameMode = gameMode;
    }
    return self;
}
#pragma mark - UI Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUserInterface];
//    [[AppSingleton singleton] runFirstGame];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForNotifications];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scoreUpdate)              name:kSINotificationScoreUpdate         object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameStarted)              name:kSINotificationGameStarted         object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameEnded)                name:kSINotificationGameEnded           object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(correctMoveEntered:)      name:kSINotificationCorrectMove         object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(powerUpActivated)         name:kSINotificationPowerUpActive       object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(levelDidChange)           name:kSINotificationLevelDidChange      object:nil];

}
- (void)setupUserInterface {
    [self createConstants];
    [self createControls];
    [self setupControls];
    [self layoutControls];
    [self setupNav];
    [self setupGestureRecognizers];
}
- (void)createConstants {
    if (IS_IPHONE_4) {
        self.fontSize                   = 20.0f;
        self.progressViewHeight         = 30.0f;
        self.progressViewBoarderWidth   = 2.0f;
        self.fallingMonkeySize          = CGSizeMake(100.0, 100.0);
        
    } else if (IS_IPHONE_5) {
        self.fontSize                   = 24.0f;
        self.progressViewHeight         = 36.0f;
        self.progressViewBoarderWidth   = 3.0f;
        self.fallingMonkeySize          = CGSizeMake(130.0, 130.0);

        
    } else if (IS_IPHONE_6) {
        self.fontSize                   = 28.0f;
        self.progressViewHeight         = 44.0f;
        self.progressViewBoarderWidth   = 3.0f;
        self.fallingMonkeySize          = CGSizeMake(150.0, 150.0);

        
    } else if (IS_IPHONE_6_PLUS) {
        self.fontSize                   = 32.0f;
        self.progressViewHeight         = 50.0f;
        self.progressViewBoarderWidth   = 3.0f;
        self.fallingMonkeySize          = CGSizeMake(180.0, 180.0);

        
    } else {
        self.fontSize                   = 36.0f;
        self.progressViewHeight         = 60.0f;
        self.progressViewBoarderWidth   = 4.0f;
        self.fallingMonkeySize          = CGSizeMake(200.0, 200.0);
        
    }
    
    /*Init Fonts*/
    self.nextMoveCommandFont            = [UIFont fontWithName:@"HelveticaNeue-Medium" size:self.fontSize - 4.0f];
    self.moveCommandFont                = [UIFont fontWithName:@"HelveticaNeue-Medium" size:self.fontSize];
    self.totalScoreFont                 = [UIFont fontWithName:@"HelveticaNeue-Medium" size:self.fontSize * 2.0f];
    
}
- (void)createControls {
    self.animator                       = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.gravity                        = [[UIGravityBehavior alloc] init];
    
    self.currentLevelLabel              = [[UILabel         alloc] init];
    self.moveScoreLabel                 = [[UILabel         alloc] init];
    self.powerUpLabel                   = [[UILabel         alloc] init];
    self.currentMoveProgressView        = [[YLProgressBar   alloc] init];
    self.moveCommandLabel               = [[UILabel         alloc] init];
    self.totalScoreLabel                = [[UILabel         alloc] init];
    self.powerUpProgressView            = [[YLProgressBar   alloc] init];
    
    /*Game over controls*/
    self.storeButton                    = [UIButton buttonWithType:UIButtonTypeCustom];
    self.replayGameButton               = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fallingMonkeysButton           = [UIButton buttonWithType:UIButtonTypeCustom];
    self.timeFreezeButton               = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rapidFireButton                = [UIButton buttonWithType:UIButtonTypeCustom];
}
- (void)setupControls {
    /*Current Level Label*/
    self.currentLevelLabel.textColor                        = [UIColor whiteColor];
    self.currentLevelLabel.font                             = self.totalScoreFont;
    self.currentLevelLabel.text                             = @"Level 1";
    self.currentLevelLabel.adjustsFontSizeToFitWidth        = YES;
    [self.currentLevelLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    /*Power Up Label*/
    self.powerUpLabel.textColor                             = [UIColor whiteColor];
    self.powerUpLabel.font                                  = self.totalScoreFont;
    self.powerUpLabel.text                                  = @"NONE";
    self.powerUpLabel.adjustsFontSizeToFitWidth             = YES;
    [self.powerUpLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Score remaining progress view*/
    self.currentMoveProgressView.type                       = YLProgressBarTypeRounded;
    self.currentMoveProgressView.progressTintColor          = [UIColor sandColor];
    self.currentMoveProgressView.hideGloss                  = YES;
    self.currentMoveProgressView.hideStripes                = YES;
    [self.currentMoveProgressView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Move Instruction Label*/
    self.moveCommandLabel.textColor                         = [UIColor whiteColor];
    self.moveCommandLabel.font                              = self.moveCommandFont;
    self.moveCommandLabel.text                              = [Game stringForMove:[AppSingleton singleton].currentGame.currentMove];
    [self.moveCommandLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    /*Total Score Label*/
    self.totalScoreLabel.textColor                          = [UIColor whiteColor];
    self.totalScoreLabel.font                               = self.totalScoreFont;
    self.totalScoreLabel.text                               = @"0.0";
    self.totalScoreLabel.adjustsFontSizeToFitWidth          = YES;
    [self.totalScoreLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Move Score Label*/
    self.moveScoreLabel.alpha                               = 0.0f;
    self.moveScoreLabel.textColor                           = [UIColor whiteColor];
    self.moveScoreLabel.font                                = self.totalScoreFont;
    self.moveScoreLabel.text                                = @"0.00";
    self.moveScoreLabel.adjustsFontSizeToFitWidth           = YES;
    [self.moveScoreLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Power Up Progress View*/
    self.powerUpProgressView.type                           = YLProgressBarTypeRounded;
    self.powerUpProgressView.progressTintColor              = [UIColor redColor];
    self.powerUpProgressView.hideGloss                      = YES;
    self.powerUpProgressView.hideStripes                    = YES;
    self.powerUpProgressView.alpha                          = 0.0f;
    [self.powerUpProgressView setTranslatesAutoresizingMaskIntoConstraints:NO];

    /*Replay Button*/
    self.replayGameButton.hidden                            = YES;
    self.replayGameButton.layer.borderColor                 = [UIColor blackColor].CGColor;
    self.replayGameButton.layer.borderWidth                 = 1.0f;
    self.replayGameButton.layer.cornerRadius                = 4.0f;
    self.replayGameButton.layer.masksToBounds               = YES;
    self.replayGameButton.layer.backgroundColor             = [UIColor whiteColor].CGColor;
    [self.replayGameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.replayGameButton addTarget:self action:@selector(replayGame) forControlEvents:UIControlEventTouchUpInside];
    [self.replayGameButton setTitle:@"Replay" forState:UIControlStateNormal];
    [self.replayGameButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Store Button*/
    self.storeButton.hidden                                 = YES;
    self.storeButton.layer.borderColor                      = [UIColor blackColor].CGColor;
    self.storeButton.layer.borderWidth                      = 1.0f;
    self.storeButton.layer.cornerRadius                     = 4.0f;
    self.storeButton.layer.masksToBounds                    = YES;
    self.storeButton.layer.backgroundColor                  = [UIColor whiteColor].CGColor;
    [self.storeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.storeButton addTarget:self action:@selector(launchStore) forControlEvents:UIControlEventTouchUpInside];
    [self.storeButton setTitle:@"Store" forState:UIControlStateNormal];
    [self.storeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Foresight Button*/
    self.fallingMonkeysButton.tag                              = SIPowerUpFallingMonkeys;
    self.fallingMonkeysButton.hidden                           = NO;
    self.fallingMonkeysButton.layer.cornerRadius               = 4.0f;
    self.fallingMonkeysButton.layer.masksToBounds              = YES;
    self.fallingMonkeysButton.layer.backgroundColor            = [UIColor whiteColor].CGColor;
    [self.fallingMonkeysButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.fallingMonkeysButton addTarget:self action:@selector(powerUpTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.fallingMonkeysButton setTitle:@"SM" forState:UIControlStateNormal];
    [self.fallingMonkeysButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Time Freeze Button*/
    self.timeFreezeButton.tag                               = SIPowerUpTimeFreeze;
    self.timeFreezeButton.hidden                            = NO;
    self.timeFreezeButton.layer.cornerRadius                = 4.0f;
    self.timeFreezeButton.layer.masksToBounds               = YES;
    self.timeFreezeButton.layer.backgroundColor             = [UIColor whiteColor].CGColor;
    [self.timeFreezeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.timeFreezeButton addTarget:self action:@selector(powerUpTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.timeFreezeButton setTitle:@"TF" forState:UIControlStateNormal];
    [self.timeFreezeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Rapid Fire Button*/
    self.rapidFireButton.tag                                = SIPowerUpRapidFire;
    self.rapidFireButton.hidden                             = NO;
    self.rapidFireButton.layer.cornerRadius                 = 4.0f;
    self.rapidFireButton.layer.masksToBounds                = YES;
    self.rapidFireButton.layer.backgroundColor              = [UIColor whiteColor].CGColor;
    [self.rapidFireButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rapidFireButton addTarget:self action:@selector(powerUpTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.rapidFireButton setTitle:@"RF" forState:UIControlStateNormal];
    [self.rapidFireButton setTranslatesAutoresizingMaskIntoConstraints:NO];

}
- (void)layoutControls {
    /*Add the subviews to the view*/
    [self.view addSubview:self.currentLevelLabel];
    [self.view addSubview:self.powerUpLabel];
    [self.view addSubview:self.moveScoreLabel];
    [self.view addSubview:self.currentMoveProgressView];
    [self.view addSubview:self.moveCommandLabel];
    [self.view addSubview:self.totalScoreLabel];
    [self.view addSubview:self.replayGameButton];
    [self.view addSubview:self.storeButton];
    [self.view addSubview:self.powerUpProgressView];
    [self.view addSubview:self.fallingMonkeysButton];
    [self.view addSubview:self.rapidFireButton];
    [self.view addSubview:self.timeFreezeButton];

    /*Current Level Label*/
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.currentLevelLabel
                               attribute             : NSLayoutAttributeCenterX
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterX
                               multiplier            : 1.0f
                               constant              : 0.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.currentLevelLabel
                               attribute             : NSLayoutAttributeTop
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeTop
                               multiplier            : 1.0f
                               constant              : VERTICAL_SPACING_16]];

    /*Power Up Label*/
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.powerUpLabel
                               attribute             : NSLayoutAttributeCenterX
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterX
                               multiplier            : 1.0f
                               constant              : 0.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.powerUpLabel
                               attribute             : NSLayoutAttributeBottom
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.currentMoveProgressView
                               attribute             : NSLayoutAttributeTop
                               multiplier            : 1.0f
                               constant              : 0.0f]];
    
    /*Current Move Progress View*/
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.currentMoveProgressView
                               attribute             : NSLayoutAttributeCenterX
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.moveCommandLabel
                               attribute             : NSLayoutAttributeCenterX
                               multiplier            : 1.0f
                               constant              : 0.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.currentMoveProgressView
                               attribute             : NSLayoutAttributeBottom
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.moveCommandLabel
                               attribute             : NSLayoutAttributeTop
                               multiplier            : 1.0f
                               constant              : -1.0f * VERTICAL_SPACING_8]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.currentMoveProgressView
                               attribute             : NSLayoutAttributeHeight
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : self.progressViewHeight]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.currentMoveProgressView
                               attribute             : NSLayoutAttributeWidth
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeWidth
                               multiplier            : 0.5f
                               constant              : 0.0f]];
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
    /*Move Score Label*/
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.moveScoreLabel
                               attribute             : NSLayoutAttributeCenterY
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.moveCommandLabel
                               attribute             : NSLayoutAttributeCenterY
                               multiplier            : 1.0f
                               constant              : 0.0f]];
    
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.moveScoreLabel
                               attribute             : NSLayoutAttributeLeading
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.moveCommandLabel
                               attribute             : NSLayoutAttributeTrailing
                               multiplier            : 1.0f
                               constant              : VERTICAL_SPACING_8]];
    /*Total Score Label*/
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.totalScoreLabel
                               attribute             : NSLayoutAttributeCenterX
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterX
                               multiplier            : 1.0f
                               constant              : 0.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.totalScoreLabel
                               attribute             : NSLayoutAttributeTop
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.moveCommandLabel
                               attribute             : NSLayoutAttributeBottom
                               multiplier            : 1.0f
                               constant              : VERTICAL_SPACING_8]];
    /*Replay Button*/
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.replayGameButton
                               attribute             : NSLayoutAttributeCenterX
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterX
                               multiplier            : 1.0f
                               constant              : 0.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.replayGameButton
                               attribute             : NSLayoutAttributeTop
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.totalScoreLabel
                               attribute             : NSLayoutAttributeBottom
                               multiplier            : 1.0f
                               constant              : VERTICAL_SPACING_8]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.replayGameButton
                               attribute             : NSLayoutAttributeHeight
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : self.progressViewHeight]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.replayGameButton
                               attribute             : NSLayoutAttributeWidth
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeWidth
                               multiplier            : 0.33f
                               constant              : 0.0f]];
    /*Store Button*/
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.storeButton
                               attribute             : NSLayoutAttributeCenterX
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterX
                               multiplier            : 1.0f
                               constant              : 0.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.storeButton
                               attribute             : NSLayoutAttributeTop
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.replayGameButton
                               attribute             : NSLayoutAttributeBottom
                               multiplier            : 1.0f
                               constant              : VERTICAL_SPACING_8]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.storeButton
                               attribute             : NSLayoutAttributeHeight
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : self.progressViewHeight]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.storeButton
                               attribute             : NSLayoutAttributeWidth
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeWidth
                               multiplier            : 0.33f
                               constant              : 0.0f]];
    /*Power Up Progress View*/
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.powerUpProgressView
                               attribute             : NSLayoutAttributeCenterX
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterX
                               multiplier            : 1.0f
                               constant              : 0.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.powerUpProgressView
                               attribute             : NSLayoutAttributeBottom
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.timeFreezeButton
                               attribute             : NSLayoutAttributeTop
                               multiplier            : 1.0f
                               constant              : VERTICAL_SPACING_8]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.powerUpProgressView
                               attribute             : NSLayoutAttributeHeight
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : self.progressViewHeight]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.powerUpProgressView
                               attribute             : NSLayoutAttributeWidth
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeWidth
                               multiplier            : 0.5f
                               constant              : 0.0f]];
    /*Falling Monkeys Button*/
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.fallingMonkeysButton
                               attribute             : NSLayoutAttributeCenterX
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterX
                               multiplier            : 1.0f
                               constant              : -1.0f * SCREEN_WIDTH/4.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.fallingMonkeysButton
                               attribute             : NSLayoutAttributeBottom
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeBottom
                               multiplier            : 1.0f
                               constant              : -1.0f * VERTICAL_SPACING_8]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.fallingMonkeysButton
                               attribute             : NSLayoutAttributeWidth
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : [GameViewController powerUpButtonHeight]]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.fallingMonkeysButton
                               attribute             : NSLayoutAttributeHeight
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : [GameViewController powerUpButtonHeight]]];
    /*Time Freeze Button*/
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.timeFreezeButton
                               attribute             : NSLayoutAttributeCenterX
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterX
                               multiplier            : 1.0f
                               constant              : 0.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.timeFreezeButton
                               attribute             : NSLayoutAttributeBottom
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeBottom
                               multiplier            : 1.0f
                               constant              : -1.0f * VERTICAL_SPACING_8]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.timeFreezeButton
                               attribute             : NSLayoutAttributeWidth
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : [GameViewController powerUpButtonHeight]]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.timeFreezeButton
                               attribute             : NSLayoutAttributeHeight
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : [GameViewController powerUpButtonHeight]]];
    /*Rapid Fire Button*/
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.rapidFireButton
                               attribute             : NSLayoutAttributeCenterX
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterX
                               multiplier            : 1.0f
                               constant              : SCREEN_WIDTH/4.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.rapidFireButton
                               attribute             : NSLayoutAttributeBottom
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeBottom
                               multiplier            : 1.0f
                               constant              : -1.0f * VERTICAL_SPACING_8]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.rapidFireButton
                               attribute             : NSLayoutAttributeWidth
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : [GameViewController powerUpButtonHeight]]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.rapidFireButton
                               attribute             : NSLayoutAttributeHeight
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : [GameViewController powerUpButtonHeight]]];

}
- (void)setupNav {
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = [UIColor mainColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
}
- (void)setupGestureRecognizers {
    /*Both Game modes get tap*/
    UITapGestureRecognizer *tapGR                       = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRegistered:)];
    tapGR.numberOfTapsRequired                          = 1;
    [self.view addGestureRecognizer:tapGR];
    
    /*Both Game modes get swype*/
    /*Right swype*/
    UISwipeGestureRecognizer *swypeRightGR              = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swypeRegistered:)];
    swypeRightGR.direction                              = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swypeRightGR];
    /*Left swype*/
    UISwipeGestureRecognizer *swypeLeftGR               = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swypeRegistered:)];
    swypeLeftGR.direction                               = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swypeLeftGR];
    /*Up/Down swype*/
    UISwipeGestureRecognizer *swypeTopBottomGR          = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swypeRegistered:)];
    swypeTopBottomGR.direction                          = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swypeTopBottomGR];
    
    if (self.gameMode == SIGameModeOneHand) {
        /*Setup Shake recognizer*/
        self.restCount                                      = 0;
        self.isShakeActive                                  = NO;
        [self startAccelerometerForShake];
    } else {
        /*Setup up pinch recognizer*/
        UIPinchGestureRecognizer *pinchGR                   = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchRegistered:)];
        [self.view addGestureRecognizer:pinchGR];
    }
}

#pragma mark - Gesture Recognizer Methods
- (void)tapRegistered:(UITapGestureRecognizer *)tapGestrureRecognizer {
    if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpFallingMonkeys) {
        [[AppSingleton singleton] moveEnterForType:SIMoveTap];
    }
}
- (void)swypeRegistered:(UISwipeGestureRecognizer *)swipeGestrureRecognizer {
    if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpFallingMonkeys) {
        [[AppSingleton singleton] moveEnterForType:SIMoveSwype];
    }
    
}
- (void)pinchRegistered:(UIPinchGestureRecognizer *)pinchGestrureRecognizer {
    if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpFallingMonkeys) {
        if (pinchGestrureRecognizer.state == UIGestureRecognizerStateEnded) {
            [[AppSingleton singleton] moveEnterForType:SIMovePinch];
        }
    }
}
- (void)shakeRegistered {
    if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpFallingMonkeys) {
        [[AppSingleton singleton] moveEnterForType:SIMoveShake];
    }
    
}

#pragma mark - Accelerometer Methods
- (void)startAccelerometerForShake {
    if ([[AppSingleton singleton].manager isAccelerometerAvailable]) {
        [AppSingleton singleton].manager.accelerometerUpdateInterval = ACCELEROMETER_UPDATE_INTERVAL; /*Get reading 20 times a second*/
        [[AppSingleton singleton].manager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                double magnitude                = sqrt(pow(accelerometerData.acceleration.x, 2) + pow(accelerometerData.acceleration.y, 2) + pow(accelerometerData.acceleration.z, 2));
                
                /*Adjust the magnititude*/
                double adjustedMag              = fabs(magnitude - 1.0);
                
                if (adjustedMag > SHAKE_THRESHOLD) { /*Phone is Shaken*/
                    if (self.isShakeActive) {
                        self.restCount          = 0;
                    } else {
                        self.isShakeActive      = YES;
                        [self shakeRegistered];
                    }
                } else { /*Phone is at rest*/
                    if (self.isShakeActive) {
                        self.restCount          = self.restCount + 1;
                        if (self.restCount > REST_COUNT_THRESHOLD) {
                            self.isShakeActive  = NO;
                            self.restCount      = 0;
                        }
                    }
                }
            });
        }];
    } else {
        NSLog(@"Accelerometer Not Available!");
    }
}

#pragma mark - Class Methods
- (void)gameStarted {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.currentMoveProgressView.hidden     = NO;
    self.replayGameButton.hidden            = YES;
    self.storeButton.hidden                 = YES;
    self.fallingMonkeysButton.hidden           = NO;
    self.timeFreezeButton.hidden            = NO;
    self.rapidFireButton.hidden             = NO;
    self.powerUpLabel.hidden                = NO;
    self.moveCommandLabel.textColor         = [UIColor whiteColor];
    self.totalScoreLabel.textColor          = [UIColor whiteColor];
    if (self.gameMode == SIGameModeOneHand) {
        /*Setup Shake recognizer*/
        self.restCount                      = 0;
        self.isShakeActive                  = NO;
        [self startAccelerometerForShake];
    }
}
- (void)gameEnded {
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.moveCommandLabel.text              = @"Game Over!";
    
    self.currentMoveProgressView.hidden     = YES;
    self.replayGameButton.hidden            = NO;
    self.storeButton.hidden                 = NO;
    self.fallingMonkeysButton.hidden           = YES;
    self.timeFreezeButton.hidden            = YES;
    self.rapidFireButton.hidden             = YES;
    self.powerUpLabel.hidden                = YES;
    self.moveCommandLabel.textColor         = [UIColor blackColor];
    self.totalScoreLabel.textColor          = [UIColor blackColor];
    self.powerUpProgressView.alpha          = 0.0f;
    
    self.view.backgroundColor               = [UIColor sandColor];
}
- (void)replayGame {
    [[AppSingleton singleton] initAppSingletonWithGameMode:self.gameMode];
    [[AppSingleton singleton] startGame];
    [self correctMoveEntered:nil];
}
- (void)scoreUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.currentMoveProgressView setProgress:[AppSingleton singleton].currentGame.moveScorePercentRemaining];
        if ([AppSingleton singleton].currentGame.currentPowerUp != SIPowerUpNone) {
//            NSLog(@"Power up percent remainging: %0.2f",[AppSingleton singleton].currentGame.powerUpPercentRemaining);
            [self.powerUpProgressView setProgress:[AppSingleton singleton].currentGame.powerUpPercentRemaining];
        }
    });
}
- (void)correctMoveEntered:(NSNotification *)notification {
    if (notification) {
        NSDictionary *userInfo          = notification.userInfo;
        NSNumber *moveScore             = userInfo[kSINSDictionaryKeyMoveScore];
        [self presentMoveScore:moveScore];
    }
    /*Set Current Move*/
    self.moveCommandLabel.text          = [Game stringForMove:[AppSingleton singleton].currentGame.currentMove];
    
    /*Update the total score label*/
    self.totalScoreLabel.text           = [NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.totalScore];
    
    /*Get Next Background Color*/
    self.view.backgroundColor           = [[AppSingleton singleton] newBackgroundColor];
}
- (void)levelDidChange {
    self.currentLevelLabel.text         = [AppSingleton singleton].currentGame.currentLevel;
}
#pragma mark - Power Up Generic Methods
/*This is the first step of a power up, this passed a message to the App Singlton to*/
/*  determine if this powerup should be called*/
- (void)powerUpTapped:(UIButton *)button {
    [[AppSingleton singleton] powerUpDidLoad:(SIPowerUp)button.tag];
}
/*This is the forth step. Activated by the Singleton*/
- (void)powerUpActivated {
    switch ([AppSingleton singleton].currentGame.currentPowerUp) {
        case SIPowerUpTimeFreeze:
            [self startPowerUpTimeFreeze];
            break;
        case SIPowerUpRapidFire:
            [self startPowerUpRapidFire];
            break;
        default:
            [self startPowerUpFallingMonkeys];
            break;
    }
}
- (void)powerUpDeactivated {
    switch ([AppSingleton singleton].currentGame.currentPowerUp) {
        case SIPowerUpTimeFreeze:
            [self endPowerUpTimeFreeze];
            break;
        case SIPowerUpRapidFire:
            [self endPowerUpRapidFire];
            break;
        default:
            [self endPowerUpFallingMonkeys];
            break;
    }
    [AppSingleton singleton].currentGame.currentPowerUp = SIPowerUpNone;
}
- (void)startPowerUpAllWithDuration:(SIPowerUpDuration)duration withButton:(UIButton *)button withPowerUpText:(NSString *)powerUpText {
    self.powerUpProgressView.alpha  = 1.0f;
    button.alpha                    = 0.2f;
    self.powerUpLabel.text          = powerUpText;
    [[AppSingleton singleton] powerUpDidActivate];
    [self performSelector:@selector(powerUpDeactivated) withObject:nil afterDelay:duration];
    [UIView animateWithDuration:duration animations:^{
        button.alpha  = 1.0f;
    }];
}
- (void)endPowerUpAll {
    self.powerUpProgressView.alpha  = 0.0f;
    self.powerUpLabel.text          = [Game stringForPowerUp:SIPowerUpNone];
    [[AppSingleton singleton] powerUpDidEnd];
}

#pragma mark - Falling Monkeys
/*This is the fith step.*/
- (void)startPowerUpFallingMonkeys {
    /*Do any UI Set U[ for Falling Monkeys*/
    self.moveCommandLabel.hidden        = YES;
    self.currentLevelLabel.hidden       = YES;
    self.currentMoveProgressView.hidden = YES;
    self.powerUpLabel.hidden            = YES;
    self.monkeyDestroyedCount           = 0;
    
    /*Generic Start Power Up*/
    NSInteger totalNumberOfMonkeysToLaunch = [[NSUserDefaults standardUserDefaults] integerForKey:kSINSUserDefaultNumberOfMonkeys];
    if (totalNumberOfMonkeysToLaunch == 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:NUMBER_OF_MONKEYS_INIT forKey:kSINSUserDefaultNumberOfMonkeys];
    }
    [self launched:0 monkeysOutOf:totalNumberOfMonkeysToLaunch];

//    [self startPowerUpAllWithDuration:SIPowerUpDurationFallingMonkeys withButton:self.fallingMonkeysButton withPowerUpText:[Game stringForPowerUp:SIPowerUpFallingMonkeys]];
}
/*This is the 7th step, called by game controller to end powerup*/
- (void)endPowerUpFallingMonkeys {
    /*Do any UI break down for Falling Monkeys*/
    self.moveCommandLabel.hidden        = NO;
    self.currentLevelLabel.hidden       = NO;
    self.currentMoveProgressView.hidden = NO;
    self.powerUpLabel.hidden            = NO;
    self.monkeyDestroyedCount           = 0;

    
    /*Generica End Power Up*/
    [self endPowerUpAll];
}

#pragma mark - Time Freeze
- (void)startPowerUpTimeFreeze {
    /*Do any UI Set U[ for Time Freeze*/

    /*Generic Start Power Up*/
    [self startPowerUpAllWithDuration:SIPowerUpDurationTimeFreeze withButton:self.timeFreezeButton withPowerUpText:[Game stringForPowerUp:SIPowerUpTimeFreeze]];
}
- (void)endPowerUpTimeFreeze {
    /*Do any UI break down for Time Freeze*/
    
    /*Generica End Power Up*/
    [self endPowerUpAll];
}

#pragma mark - Rapid Fire
- (void)startPowerUpRapidFire {
    /*Do any UI Setup for Rapid Fire*/

    /*Generic Start Power Up*/
    [self startPowerUpAllWithDuration:SIPowerUpDurationRapidFire withButton:self.rapidFireButton withPowerUpText:[Game stringForPowerUp:SIPowerUpRapidFire]];
}
- (void)endPowerUpRapidFire {
    /*Do any UI break down for Rapid Fire*/
    
    /*Generica End Power Up*/
    [self endPowerUpAll];
}

#pragma mark - GUI Functions
- (void)presentMoveScore:(NSNumber *)score {
    self.moveScoreLabel.text        = [NSString stringWithFormat:@"%0.2f",[score floatValue]];
    self.moveScoreLabel.alpha       = 1.0f;
    [UIView animateWithDuration:0.5f animations:^{
        self.moveScoreLabel.alpha   = 0.0f;
    }];
}

#pragma mark - IAP Store Methods
- (void)launchStore {
    NSArray *products = [[MKStoreKit sharedKit] availableProducts];
    if (products.count > 0) {
        IAPViewController *viewController = [[IAPViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        NSLog(@"No Products Found");
    }
}

#pragma mark - Launch Monkeys
- (void)launched:(NSInteger)monkeysLaunched monkeysOutOf:(NSInteger)totalMonkeysToLaunch {
    /*Base Case*/
    if (monkeysLaunched == totalMonkeysToLaunch) {
//        [self powerUpDeactivated];
//        [self correctMoveEntered:nil];
        return;
    } else {
        /*Get Random Number Max... based of width of screen and monkey*/
        CGFloat validMax                = SCREEN_WIDTH - (self.fallingMonkeySize.width / 2.0f);
        CGFloat xLocation               = arc4random_uniform(validMax); /*This will be the y axis launch point*/
        CGFloat yLocation               = -self.fallingMonkeySize.height;
        
        /*Make Monkey*/
//        CGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
//        UIButton *button                = [[UIButton alloc] initWithFrame:CGRectMake(xLocation, yLocation, self.fallingMonkeySize.width, self.fallingMonkeySize.height)];
        FallingMonkeyView *monkey       = [[FallingMonkeyView alloc] initWithFrame:CGRectMake(xLocation, yLocation, self.fallingMonkeySize.width, self.fallingMonkeySize.height)];
        monkey.delegate                 = self;
        
        [self.view addSubview:monkey];
        [self.view bringSubviewToFront:monkey];
        
        /*Add that monkey to the view*/
        [self.gravity addItem:monkey];
        [self.animator addBehavior:self.gravity];
        
        /*Call Function again*/
        CGFloat randomDelay            = arc4random_uniform(75);
        NSLog(@"Delay: %0.2f",randomDelay / 100);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(randomDelay /100 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self launched:monkeysLaunched + 1 monkeysOutOf:totalMonkeysToLaunch];
        });
    }
}

- (void)monkeyWasTapped:(FallingMonkeyView *)fallingMonkeyView {
    [fallingMonkeyView removeFromSuperview];
    
    self.monkeyDestroyedCount                       = self.monkeyDestroyedCount + 1;
    
    [AppSingleton singleton].currentGame.totalScore = [AppSingleton singleton].currentGame.totalScore + VALUE_OF_MONKEY;
    
    self.totalScoreLabel.text                       = [NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.totalScore];
    
    self.view.backgroundColor                       = [[AppSingleton singleton] newBackgroundColor];
}


@end
