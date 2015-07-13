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
#import "SIConstants.h"
// Other Imports

@interface GameViewController () {
    
}
#pragma mark - Private Primiatives
@property (assign, nonatomic) BOOL               isGameActive;
@property (assign, nonatomic) BOOL               isShakeActive;
@property (assign, nonatomic) CGFloat            fontSize;
@property (assign, nonatomic) CGFloat            progressViewBoarderWidth;
@property (assign, nonatomic) CGFloat            progressViewHeight;
@property (assign, nonatomic) CGFloat            verticalSpacing;
@property (assign, nonatomic) int                gameMode;


#pragma mark - Private Properties
@property (assign, nonatomic) NSInteger          restCount;

#pragma mark - Constraints

#pragma mark - UI Controls
@property (strong, nonatomic) YLProgressBar     *currentMoveProgressView;
@property (strong, nonatomic) UIButton          *foresightButton;
@property (strong, nonatomic) UIButton          *rapidFireButton;
@property (strong, nonatomic) UIButton          *replayGameButton;
@property (strong, nonatomic) UIButton          *slowMotionButton;
@property (strong, nonatomic) UIFont            *nextMoveCommandFont;
@property (strong, nonatomic) UIFont            *moveCommandFont;
@property (strong, nonatomic) UIFont            *totalScoreFont;
@property (strong, nonatomic) UILabel           *nextMoveLabel;
@property (strong, nonatomic) UILabel           *moveCommandLabel;
@property (strong, nonatomic) UILabel           *powerUpLabel;
@property (strong, nonatomic) UILabel           *totalScoreLabel;


@end

@implementation GameViewController

+ (CGFloat)powerUpButtonHeigth {
    if (IS_IPHONE_4) {
        return 30.0f;
    } else if (IS_IPHONE_5) {
        return 40.0f;
    } else if (IS_IPHONE_6) {
        return 45.0f;
    } else if (IS_IPHONE_6_PLUS) {
        return 50.0f;
    } else {
        return 55.0f;
    }
}

#pragma mark - Initialization Methods
- (instancetype)initWithGameMode:(GameMode)gameMode {
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scoreUpdate)          name:kSINotificationScoreUpdate         object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameStarted)          name:kSINotificationGameStarted         object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameEnded)            name:kSINotificationGameEnded           object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(correctMoveEntered)   name:kSINotificationCorrectMove         object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(powerUpActivated:)    name:kSINotificationPowerUpActive       object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(powerUpDeactivated:)  name:kSINotificationPowerUpDeactivated  object:nil];
    
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
    
    self.verticalSpacing                = 8.0f;
    
    /*Init Fonts*/
    self.nextMoveCommandFont            = [UIFont fontWithName:@"HelveticaNeue-Medium" size:self.fontSize - 4.0f];
    self.moveCommandFont                = [UIFont fontWithName:@"HelveticaNeue-Medium" size:self.fontSize];
    self.totalScoreFont                 = [UIFont fontWithName:@"HelveticaNeue-Medium" size:self.fontSize * 2.0f];
    
}
- (void)createControls {
    self.currentMoveProgressView        = [[YLProgressBar alloc] init];
    self.nextMoveLabel                  = [[UILabel alloc] init];
    self.moveCommandLabel               = [[UILabel alloc] init];
    self.powerUpLabel                   = [[UILabel alloc] init];
    self.totalScoreLabel                = [[UILabel alloc] init];
    /*Game over controls*/
    self.replayGameButton               = [UIButton buttonWithType:UIButtonTypeCustom];
    self.foresightButton                = [UIButton buttonWithType:UIButtonTypeCustom];
    self.slowMotionButton               = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rapidFireButton                = [UIButton buttonWithType:UIButtonTypeCustom];
}
- (void)setupControls {
    /*Score remaining progress view*/
    self.currentMoveProgressView.type                   = YLProgressBarTypeRounded;
    self.currentMoveProgressView.progressTintColor      = [UIColor sandColor];
//    self.currentMoveProgressView.stripesOrientation = YLProgressBarStripesOrientationVertical;
//    self.currentMoveProgressView.stripesDirection   = YLProgressBarStripesDirectionLeft;
    self.currentMoveProgressView.hideGloss              = YES;
    self.currentMoveProgressView.hideStripes            = YES;
    [self.currentMoveProgressView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Move Instruction Label*/
    self.moveCommandLabel.textColor                     = [UIColor whiteColor];
    self.moveCommandLabel.font                          = self.moveCommandFont;
    self.moveCommandLabel.text                          = [Game stringForMove:[AppSingleton singleton].currentGame.currentMove];
    [self.moveCommandLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    /*Next Move Instruction Label*/
    self.nextMoveLabel.hidden                           = YES;
    self.nextMoveLabel.alpha                            = 0.8f;
    self.nextMoveLabel.textColor                        = [UIColor whiteColor];
    self.nextMoveLabel.font                             = self.nextMoveCommandFont;
    self.nextMoveLabel.text                             = [Game stringForMove:[AppSingleton singleton].currentGame.currentMove];
    [self.nextMoveLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    /*Total Score Label*/
    self.totalScoreLabel.textColor                      = [UIColor whiteColor];
    self.totalScoreLabel.font                           = self.totalScoreFont;
    self.totalScoreLabel.text                           = @"0.0";
    self.totalScoreLabel.adjustsFontSizeToFitWidth      = YES;
    [self.totalScoreLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    /*Power Up Label*/
    self.powerUpLabel.textColor                         = [UIColor whiteColor];
    self.powerUpLabel.font                              = self.totalScoreFont;
    self.powerUpLabel.text                              = @"NONE";
    self.powerUpLabel.adjustsFontSizeToFitWidth         = YES;
    [self.powerUpLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    /*Replay Button*/
    self.replayGameButton.hidden                        = YES;
    self.replayGameButton.layer.cornerRadius            = 4.0f;
    self.replayGameButton.layer.masksToBounds           = YES;
    self.replayGameButton.layer.backgroundColor         = [UIColor sandColor].CGColor;
    [self.replayGameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.replayGameButton addTarget:self action:@selector(replayGame) forControlEvents:UIControlEventTouchUpInside];
    [self.replayGameButton setTitle:@"Replay" forState:UIControlStateNormal];
    [self.replayGameButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Foresight Button*/
    self.foresightButton.tag                            = PowerUpForesight;
    self.foresightButton.hidden                         = NO;
    self.foresightButton.layer.cornerRadius             = 4.0f;
    self.foresightButton.layer.masksToBounds            = YES;
    self.foresightButton.layer.backgroundColor          = [UIColor sandColor].CGColor;
    [self.foresightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.foresightButton addTarget:self action:@selector(powerUpTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.foresightButton setTitle:@"FS" forState:UIControlStateNormal];
    [self.foresightButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Slow Motion Button*/
    self.slowMotionButton.tag                           = PowerUpSlowMotion;
    self.slowMotionButton.hidden                        = NO;
    self.slowMotionButton.layer.cornerRadius            = 4.0f;
    self.slowMotionButton.layer.masksToBounds           = YES;
    self.slowMotionButton.layer.backgroundColor         = [UIColor sandColor].CGColor;
    [self.slowMotionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.slowMotionButton addTarget:self action:@selector(powerUpTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.slowMotionButton setTitle:@"SM" forState:UIControlStateNormal];
    [self.slowMotionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Rapid Fire Button*/
    self.rapidFireButton.tag                            = PowerUpRapidFire;
    self.rapidFireButton.hidden                         = NO;
    self.rapidFireButton.layer.cornerRadius             = 4.0f;
    self.rapidFireButton.layer.masksToBounds            = YES;
    self.rapidFireButton.layer.backgroundColor          = [UIColor sandColor].CGColor;
    [self.rapidFireButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rapidFireButton addTarget:self action:@selector(powerUpTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.rapidFireButton setTitle:@"RF" forState:UIControlStateNormal];
    [self.rapidFireButton setTranslatesAutoresizingMaskIntoConstraints:NO];

}
- (void)layoutControls {
    /*Add the subviews to the view*/
    [self.view addSubview:self.currentMoveProgressView];
    [self.view addSubview:self.nextMoveLabel];
    [self.view addSubview:self.moveCommandLabel];
    [self.view addSubview:self.totalScoreLabel];
    [self.view addSubview:self.replayGameButton];
    [self.view addSubview:self.powerUpLabel];
    [self.view addSubview:self.foresightButton];
    [self.view addSubview:self.rapidFireButton];
    [self.view addSubview:self.slowMotionButton];

    
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
    /*Next Move Command Label*/
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.nextMoveLabel
                               attribute             : NSLayoutAttributeTrailing
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeTrailing
                               multiplier            : 1.0f
                               constant              : -1.0f * VERTICAL_SPACING_8]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.nextMoveLabel
                               attribute             : NSLayoutAttributeCenterY
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterY
                               multiplier            : 1.0f
                               constant              : 0.0f]];
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
                               constant              : -1.0f * self.verticalSpacing]];
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
                               constant              : self.verticalSpacing]];
    
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
                               constant              : self.verticalSpacing]];
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
    /*Foresight Button*/
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.foresightButton
                               attribute             : NSLayoutAttributeCenterX
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeCenterX
                               multiplier            : 1.0f
                               constant              : -1.0f * SCREEN_WIDTH/4.0f]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.foresightButton
                               attribute             : NSLayoutAttributeBottom
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : self.view
                               attribute             : NSLayoutAttributeBottom
                               multiplier            : 1.0f
                               constant              : -1.0f * self.verticalSpacing]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.foresightButton
                               attribute             : NSLayoutAttributeWidth
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : [GameViewController powerUpButtonHeigth]]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.foresightButton
                               attribute             : NSLayoutAttributeHeight
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : [GameViewController powerUpButtonHeigth]]];
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
                               constant              : -1.0f * self.verticalSpacing]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.slowMotionButton
                               attribute             : NSLayoutAttributeWidth
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : [GameViewController powerUpButtonHeigth]]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.slowMotionButton
                               attribute             : NSLayoutAttributeHeight
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : [GameViewController powerUpButtonHeigth]]];
    /*Foresight Button*/
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
                               constant              : -1.0f * self.verticalSpacing]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.rapidFireButton
                               attribute             : NSLayoutAttributeWidth
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : [GameViewController powerUpButtonHeigth]]];
    [self.view addConstraint: [NSLayoutConstraint
                               constraintWithItem    : self.rapidFireButton
                               attribute             : NSLayoutAttributeHeight
                               relatedBy             : NSLayoutRelationEqual
                               toItem                : nil
                               attribute             : NSLayoutAttributeNotAnAttribute
                               multiplier            : 1.0f
                               constant              : [GameViewController powerUpButtonHeigth]]];
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
    
    if (self.gameMode == GameModeOneHand) {
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
    [[AppSingleton singleton] moveEnterForType:MoveTap];
}
- (void)swypeRegistered:(UISwipeGestureRecognizer *)swipeGestrureRecognizer {
    [[AppSingleton singleton] moveEnterForType:MoveSwype];
}
- (void)pinchRegistered:(UIPinchGestureRecognizer *)pinchGestrureRecognizer {
    if (pinchGestrureRecognizer.state == UIGestureRecognizerStateEnded) {
        [[AppSingleton singleton] moveEnterForType:MovePinch];
    }
}
- (void)shakeRegistered {
    [[AppSingleton singleton] moveEnterForType:MoveShake];
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
}
- (void)gameEnded {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.moveCommandLabel.text              = @"Game Over!";
    
    self.currentMoveProgressView.hidden     = YES;
    self.replayGameButton.hidden            = NO;
}
- (void)replayGame {
    [[AppSingleton singleton] initAppSingletonWithGameMode:self.gameMode];
    [[AppSingleton singleton] startGame];
    [self correctMoveEntered];
}
- (void)scoreUpdate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.currentMoveProgressView setProgress:[AppSingleton singleton].currentGame.moveScorePercentRemaining];
    });
}
- (void)correctMoveEntered {
    /*Set Current Move*/
    self.moveCommandLabel.text          = [Game stringForMove:[AppSingleton singleton].currentGame.currentMove];
    
    /*Set Next Move*/
    self.nextMoveLabel.text             = [Game stringForMove:[AppSingleton singleton].currentGame.nextMove];
    
    /*Update the total score label*/
    self.totalScoreLabel.text           = [NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.totalScore];
}
- (void)powerUpTapped:(UIButton *)button {
    [[AppSingleton singleton] powerUpDidLoad:(PowerUp)button.tag];
}
- (void)powerUpActivated:(NSNotification *)notification {
    switch ([AppSingleton singleton].currentGame.currentPowerUp) {
        case PowerUpSlowMotion:
            [self startPowerUpSlowMotion];
            break;
        case PowerUpRapidFire:
            [self startPowerUpRapidFire];
            break;
        default:
            [self startPowerUpForesight];
            break;
    }
}
- (void)powerUpDeactivated {
    switch ([AppSingleton singleton].currentGame.currentPowerUp) {
        case PowerUpSlowMotion:
            [self endPowerUpSlowMotion];
            break;
        case PowerUpRapidFire:
            [self endPowerUpRapidFire];
            break;
        default:
            [self endPowerUpForesight];
            break;
    }
    [AppSingleton singleton].currentGame.currentPowerUp = PowerUpNone;
}
/*Foresight*/
- (void)startPowerUpForesight {
    self.foresightButton.alpha      = 0.2;
    self.nextMoveLabel.hidden       = NO;
    self.powerUpLabel.text          = kSIPowerUpForesight;
    [[AppSingleton singleton] powerUpDidActivate];
    [self performSelector:@selector(powerUpDeactivated) withObject:nil afterDelay:DURATION_FORESIGHT_SEC];
    [UIView animateWithDuration:DURATION_FORESIGHT_SEC animations:^{
        self.foresightButton.alpha  = 1.0f;
    }];
}
- (void)endPowerUpForesight {
    self.nextMoveLabel.hidden       = YES;
    self.powerUpLabel.text          = kSIPowerUpNone;
    [[AppSingleton singleton] powerUpDidEnd];
}
/*Slow Motion*/
- (void)startPowerUpSlowMotion {
    self.slowMotionButton.alpha     = 0.2;
    self.powerUpLabel.text          = kSIPowerUpSlowMotion;
    [[AppSingleton singleton] powerUpDidActivate];
    [self performSelector:@selector(powerUpDeactivated) withObject:nil afterDelay:DURATION_SLOW_MOTION_SEC];
    [UIView animateWithDuration:DURATION_SLOW_MOTION_SEC animations:^{
        self.slowMotionButton.alpha = 1.0f;
    }];
}
- (void)endPowerUpSlowMotion {
    self.powerUpLabel.text          = kSIPowerUpNone;
    [[AppSingleton singleton] powerUpDidEnd];
}
/*Rapid Fire*/
- (void)startPowerUpRapidFire {
    self.rapidFireButton.alpha      = 0.2;
    self.powerUpLabel.text          = kSIPowerUpRapidFire;
    [[AppSingleton singleton] powerUpDidActivate];
    [self performSelector:@selector(powerUpDeactivated) withObject:nil afterDelay:DURATION_RAPID_FIRE_SEC];
    [UIView animateWithDuration:DURATION_RAPID_FIRE_SEC animations:^{
        self.rapidFireButton.alpha  = 1.0f;
    }];
}
- (void)endPowerUpRapidFire {
    self.powerUpLabel.text          = kSIPowerUpNone;
    [[AppSingleton singleton] powerUpDidEnd];
}
@end
