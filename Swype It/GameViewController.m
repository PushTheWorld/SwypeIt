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
#import "GameViewController.h"
// Framework Import
#import <CoreMotion/CoreMotion.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "YLProgressBar.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "Game.h"
// Other Imports

@interface GameViewController () {
    
}
#pragma mark - Private Primiatives
@property (assign, nonatomic) BOOL               isGameActive;
@property (assign, nonatomic) BOOL               isShakeActive;
@property (assign, nonatomic) CGFloat            fontSize;
@property (assign, nonatomic) CGFloat            progressViewBoarderWidth;
@property (assign, nonatomic) CGFloat            progressViewHeight;
@property (assign, nonatomic) int                gameMode;


#pragma mark - Private Properties
@property (assign, nonatomic) NSInteger          restCount;

#pragma mark - Constraints

#pragma mark - UI Controls
@property (strong, nonatomic) YLProgressBar     *currentMoveProgressView;
@property (strong, nonatomic) YLProgressBar     *powerUpProgressView;
@property (strong, nonatomic) UIButton          *doublePointsButton;
@property (strong, nonatomic) UIButton          *rapidFireButton;
@property (strong, nonatomic) UIButton          *replayGameButton;
@property (strong, nonatomic) UIButton          *slowMotionButton;
@property (strong, nonatomic) UIFont            *nextMoveCommandFont;
@property (strong, nonatomic) UIFont            *moveCommandFont;
@property (strong, nonatomic) UIFont            *totalScoreFont;
@property (strong, nonatomic) UILabel           *currentLevelLabel;
@property (strong, nonatomic) UILabel           *moveCommandLabel;
@property (strong, nonatomic) UILabel           *moveScoreLabel;
@property (strong, nonatomic) UILabel           *powerUpLabel;
@property (strong, nonatomic) UILabel           *totalScoreLabel;


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
    [[AppSingleton singleton] runFirstGame];
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
        
    } else if (IS_IPHONE_5) {
        self.fontSize                   = 24.0f;
        self.progressViewHeight         = 36.0f;
        self.progressViewBoarderWidth   = 3.0f;
        
    } else if (IS_IPHONE_6) {
        self.fontSize                   = 28.0f;
        self.progressViewHeight         = 44.0f;
        self.progressViewBoarderWidth   = 3.0f;
        
    } else if (IS_IPHONE_6_PLUS) {
        self.fontSize                   = 32.0f;
        self.progressViewHeight         = 50.0f;
        self.progressViewBoarderWidth   = 3.0f;
        
    } else {
        self.fontSize                   = 36.0f;
        self.progressViewHeight         = 60.0f;
        self.progressViewBoarderWidth   = 4.0f;
        
    }
    
    /*Init Fonts*/
    self.nextMoveCommandFont            = [UIFont fontWithName:@"HelveticaNeue-Medium" size:self.fontSize - 4.0f];
    self.moveCommandFont                = [UIFont fontWithName:@"HelveticaNeue-Medium" size:self.fontSize];
    self.totalScoreFont                 = [UIFont fontWithName:@"HelveticaNeue-Medium" size:self.fontSize * 2.0f];
    
}
- (void)createControls {
    self.currentLevelLabel              = [[UILabel alloc] init];
    self.moveScoreLabel                 = [[UILabel alloc] init];
    self.powerUpLabel                   = [[UILabel alloc] init];
    self.currentMoveProgressView        = [[YLProgressBar alloc] init];
    self.moveCommandLabel               = [[UILabel alloc] init];
    self.totalScoreLabel                = [[UILabel alloc] init];
    self.powerUpProgressView            = [[YLProgressBar alloc] init];
    
    /*Game over controls*/
    self.replayGameButton               = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doublePointsButton             = [UIButton buttonWithType:UIButtonTypeCustom];
    self.slowMotionButton               = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rapidFireButton                = [UIButton buttonWithType:UIButtonTypeCustom];
}
- (void)setupControls {
    /*Current Level Label*/
    self.currentLevelLabel.textColor                    = [UIColor whiteColor];
    self.currentLevelLabel.font                         = self.totalScoreFont;
    self.currentLevelLabel.text                         = @"Level 1";
    self.currentLevelLabel.adjustsFontSizeToFitWidth    = YES;
    [self.currentLevelLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Power Up Label*/
    self.powerUpLabel.textColor                         = [UIColor whiteColor];
    self.powerUpLabel.font                              = self.totalScoreFont;
    self.powerUpLabel.text                              = @"NONE";
    self.powerUpLabel.adjustsFontSizeToFitWidth         = YES;
    [self.powerUpLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Score remaining progress view*/
    self.currentMoveProgressView.type                   = YLProgressBarTypeRounded;
    self.currentMoveProgressView.progressTintColor      = [UIColor sandColor];
    self.currentMoveProgressView.hideGloss              = YES;
    self.currentMoveProgressView.hideStripes            = YES;
    [self.currentMoveProgressView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Move Instruction Label*/
    self.moveCommandLabel.textColor                     = [UIColor whiteColor];
    self.moveCommandLabel.font                          = self.moveCommandFont;
    self.moveCommandLabel.text                          = [Game stringForMove:[AppSingleton singleton].currentGame.currentMove];
    [self.moveCommandLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    /*Total Score Label*/
    self.totalScoreLabel.textColor                      = [UIColor whiteColor];
    self.totalScoreLabel.font                           = self.totalScoreFont;
    self.totalScoreLabel.text                           = @"0.0";
    self.totalScoreLabel.adjustsFontSizeToFitWidth      = YES;
    [self.totalScoreLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Move Score Label*/
    self.moveScoreLabel.alpha                           = 0.0f;
    self.moveScoreLabel.textColor                       = [UIColor whiteColor];
    self.moveScoreLabel.font                            = self.totalScoreFont;
    self.moveScoreLabel.text                            = @"0.00";
    self.moveScoreLabel.adjustsFontSizeToFitWidth       = YES;
    [self.moveScoreLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Power Up Progress View*/
    self.powerUpProgressView.type                       = YLProgressBarTypeRounded;
    self.powerUpProgressView.progressTintColor          = [UIColor redColor];
    self.powerUpProgressView.hideGloss                  = YES;
    self.powerUpProgressView.hideStripes                = YES;
    self.powerUpProgressView.alpha                      = 0.0f;
    [self.powerUpProgressView setTranslatesAutoresizingMaskIntoConstraints:NO];

    /*Replay Button*/
    self.replayGameButton.hidden                        = YES;
    self.replayGameButton.layer.cornerRadius            = 4.0f;
    self.replayGameButton.layer.masksToBounds           = YES;
    self.replayGameButton.layer.backgroundColor         = [UIColor whiteColor].CGColor;
    [self.replayGameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.replayGameButton addTarget:self action:@selector(replayGame) forControlEvents:UIControlEventTouchUpInside];
    [self.replayGameButton setTitle:@"Replay" forState:UIControlStateNormal];
    [self.replayGameButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Foresight Button*/
    self.doublePointsButton.tag                         = SIPowerUpDoublePoints;
    self.doublePointsButton.hidden                      = NO;
    self.doublePointsButton.layer.cornerRadius          = 4.0f;
    self.doublePointsButton.layer.masksToBounds         = YES;
    self.doublePointsButton.layer.backgroundColor       = [UIColor whiteColor].CGColor;
    [self.doublePointsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.doublePointsButton addTarget:self action:@selector(powerUpTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.doublePointsButton setTitle:@"DP" forState:UIControlStateNormal];
    [self.doublePointsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Slow Motion Button*/
    self.slowMotionButton.tag                           = SIPowerUpTimeFreeze;
    self.slowMotionButton.hidden                        = NO;
    self.slowMotionButton.layer.cornerRadius            = 4.0f;
    self.slowMotionButton.layer.masksToBounds           = YES;
    self.slowMotionButton.layer.backgroundColor         = [UIColor whiteColor].CGColor;
    [self.slowMotionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.slowMotionButton addTarget:self action:@selector(powerUpTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.slowMotionButton setTitle:@"SM" forState:UIControlStateNormal];
    [self.slowMotionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Rapid Fire Button*/
    self.rapidFireButton.tag                            = SIPowerUpRapidFire;
    self.rapidFireButton.hidden                         = NO;
    self.rapidFireButton.layer.cornerRadius             = 4.0f;
    self.rapidFireButton.layer.masksToBounds            = YES;
    self.rapidFireButton.layer.backgroundColor          = [UIColor whiteColor].CGColor;
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
    [self.view addSubview:self.powerUpProgressView];
    [self.view addSubview:self.doublePointsButton];
    [self.view addSubview:self.rapidFireButton];
    [self.view addSubview:self.slowMotionButton];

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
                               toItem                : self.slowMotionButton
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
    /*Foresight Button*/
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.doublePointsButton
                               attribute             : NSLayoutAttributeCenterX
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterX
                               multiplier            : 1.0f
                               constant              : -1.0f * SCREEN_WIDTH/4.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.doublePointsButton
                               attribute             : NSLayoutAttributeBottom
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeBottom
                               multiplier            : 1.0f
                               constant              : -1.0f * VERTICAL_SPACING_8]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.doublePointsButton
                               attribute             : NSLayoutAttributeWidth
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : [GameViewController powerUpButtonHeight]]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.doublePointsButton
                               attribute             : NSLayoutAttributeHeight
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : [GameViewController powerUpButtonHeight]]];
    /*Slow Motion Button*/
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.slowMotionButton
                               attribute             : NSLayoutAttributeCenterX
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterX
                               multiplier            : 1.0f
                               constant              : 0.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.slowMotionButton
                               attribute             : NSLayoutAttributeBottom
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeBottom
                               multiplier            : 1.0f
                               constant              : -1.0f * VERTICAL_SPACING_8]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.slowMotionButton
                               attribute             : NSLayoutAttributeWidth
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : [GameViewController powerUpButtonHeight]]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.slowMotionButton
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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = [UIColor mainColor];
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
    [[AppSingleton singleton] moveEnterForType:SIMoveTap];
}
- (void)swypeRegistered:(UISwipeGestureRecognizer *)swipeGestrureRecognizer {
    [[AppSingleton singleton] moveEnterForType:SIMoveSwype];
}
- (void)pinchRegistered:(UIPinchGestureRecognizer *)pinchGestrureRecognizer {
    if (pinchGestrureRecognizer.state == UIGestureRecognizerStateEnded) {
        [[AppSingleton singleton] moveEnterForType:SIMovePinch];
    }
}
- (void)shakeRegistered {
    [[AppSingleton singleton] moveEnterForType:SIMoveShake];
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
    self.doublePointsButton.hidden          = NO;
    self.slowMotionButton.hidden            = NO;
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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.moveCommandLabel.text              = @"Game Over!";
    
    self.currentMoveProgressView.hidden     = YES;
    self.replayGameButton.hidden            = NO;
    self.doublePointsButton.hidden          = YES;
    self.slowMotionButton.hidden            = YES;
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
            NSLog(@"Power up percent remainging: %0.2f",[AppSingleton singleton].currentGame.powerUpPercentRemaining);
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
            [self startPowerUpDoublePoints];
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
            [self endPowerUpDoublePoints];
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

#pragma mark - Double Points
/*This is the fith step.*/
- (void)startPowerUpDoublePoints {
    /*Do any UI Set U[ for Slow Motion*/
    
    /*Generic Start Power Up*/
    [self startPowerUpAllWithDuration:SIPowerUpDurationDoublePoints withButton:self.doublePointsButton withPowerUpText:[Game stringForPowerUp:SIPowerUpDoublePoints]];
}
/*This is the 7th step, called by game controller to end powerup*/
- (void)endPowerUpDoublePoints {
    /*Do any UI break down for Rapid Fire*/
    
    /*Generica End Power Up*/
    [self endPowerUpAll];
}

#pragma mark - Time Freeze
- (void)startPowerUpTimeFreeze {
    /*Do any UI Set U[ for Time Freeze*/

    /*Generic Start Power Up*/
    [self startPowerUpAllWithDuration:SIPowerUpDurationTimeFreeze withButton:self.slowMotionButton withPowerUpText:[Game stringForPowerUp:SIPowerUpTimeFreeze]];
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
@end
