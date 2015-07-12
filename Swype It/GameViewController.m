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
@property (strong, nonatomic) UIButton          *replayGameButton;
@property (strong, nonatomic) UIFont            *moveCommandFont;
@property (strong, nonatomic) UIFont            *totalScoreFont;
@property (strong, nonatomic) UILabel           *moveCommandLabel;
@property (strong, nonatomic) UILabel           *totalScoreLabel;


@end

@implementation GameViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scoreUpdate)          name:kSINotificationScoreUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameStarted)          name:kSINotificationGameStarted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameEnded)            name:kSINotificationGameEnded   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(correctMoveEntered)   name:kSINotificationCorrectMove object:nil];
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
    self.moveCommandFont                = [UIFont fontWithName:@"HelveticaNeue-Medium" size:self.fontSize];
    self.totalScoreFont                 = [UIFont fontWithName:@"HelveticaNeue-Medium" size:self.fontSize * 2.0f];
    
}
- (void)createControls {
    self.currentMoveProgressView        = [[YLProgressBar alloc] init];
    self.moveCommandLabel               = [[UILabel alloc] init];
    self.totalScoreLabel                = [[UILabel alloc] init];
    
    /*Game over controls*/
    self.replayGameButton               = [UIButton buttonWithType:UIButtonTypeCustom];
}
- (void)setupControls {
    /*Score remaining progress view*/
    self.currentMoveProgressView.type               = YLProgressBarTypeRounded;
    self.currentMoveProgressView.progressTintColor  = [UIColor sandColor];
//    self.currentMoveProgressView.stripesOrientation = YLProgressBarStripesOrientationVertical;
//    self.currentMoveProgressView.stripesDirection   = YLProgressBarStripesDirectionLeft;
    self.currentMoveProgressView.hideGloss          = YES;
    self.currentMoveProgressView.hideStripes        = YES;
    [self.currentMoveProgressView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Move Instruction Label*/
    self.moveCommandLabel.textColor = [UIColor whiteColor];
    self.moveCommandLabel.font      = self.moveCommandFont;
    self.moveCommandLabel.text      = [Game stringForMove:[AppSingleton singleton].currentGame.currentMove];
    [self.moveCommandLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Total Score Label*/
    self.totalScoreLabel.textColor                      = [UIColor whiteColor];
    self.totalScoreLabel.font                           = self.totalScoreFont;
    self.totalScoreLabel.text                           = @"0.0";
    self.totalScoreLabel.adjustsFontSizeToFitWidth      = YES;
    [self.totalScoreLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Replay Button*/
    self.replayGameButton.hidden                        = YES;
    self.replayGameButton.layer.cornerRadius            = 4.0f;
    self.replayGameButton.layer.masksToBounds           = YES;
    self.replayGameButton.layer.backgroundColor         = [UIColor sandColor].CGColor;
    [self.replayGameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.replayGameButton addTarget:self action:@selector(replayGame) forControlEvents:UIControlEventTouchUpInside];
    [self.replayGameButton setTitle:@"Replay" forState:UIControlStateNormal];
    [self.replayGameButton setTranslatesAutoresizingMaskIntoConstraints:NO];

}
- (void)layoutControls {
    /*Add the subviews to the view*/
    [self.view addSubview:self.currentMoveProgressView];
    [self.view addSubview:self.moveCommandLabel];
    [self.view addSubview:self.totalScoreLabel];
    [self.view addSubview:self.replayGameButton];

    
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
    /*Set next move*/
    self.moveCommandLabel.text          = [Game stringForMove:[AppSingleton singleton].currentGame.currentMove];
    
    /*Update the total score label*/
    self.totalScoreLabel.text           = [NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.totalScore];
    
    
}

@end
