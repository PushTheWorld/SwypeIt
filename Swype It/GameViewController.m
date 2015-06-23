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
#import "MSSProgressView.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "Game.h"
#import "SIConstants.h"
// Other Imports

@interface GameViewController () {
    
}
#pragma mark - Private CGFloats
@property (assign, nonatomic) CGFloat            progressViewBoarderWidth;
@property (assign, nonatomic) CGFloat            fontSize;
@property (assign, nonatomic) CGFloat            progressViewHeight;

#pragma mark - Private Bools
@property (assign, nonatomic) BOOL               isGameActive;
@property (assign, nonatomic) BOOL               isShakeActive;

#pragma mark - Private Properties
@property (assign, nonatomic) NSInteger          restCount;

#pragma mark - Constraints

#pragma mark - UI Controls
@property (strong, nonatomic) MSSProgressView   *currentMoveProgressView;
@property (strong, nonatomic) NSString          *gameMode;
@property (strong, nonatomic) UIFont            *moveCommandFont;
@property (strong, nonatomic) UIFont            *totalScoreFont;
@property (strong, nonatomic) UILabel           *moveCommandLabel;
@property (strong, nonatomic) UILabel           *totalScoreLabel;


@end

@implementation GameViewController

#pragma mark - Initialization Methods
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
    [AppSingleton singleton].currentGame.currentMove    = [Game getRandomLevelMoveForGameMode:self.gameMode];
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

    /*Setup up pinch recognizer*/
    UIPinchGestureRecognizer *pinchGR                   = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchRegistered:)];
    [self.view addGestureRecognizer:pinchGR];
    
    /*Setup Shake recognizer*/
    self.restCount                                      = 0;
    self.isShakeActive                                  = NO;

}

#pragma mark - UI Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUserInterface];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshScore)         name:kSINotificationCorrectMove object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameStarted)          name:kSINotificationGameStarted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameEnded)            name:kSINotificationGameEnded   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(correctMoveEntered)   name:kSINotificationScoreUpdate object:nil];
}
- (void)setupUserInterface {
    [self createConstants];
    [self createControls];
    [self setupControls];
    [self layoutControls];
    [self setupNav];
}
- (void)createConstants {
    self.currentMoveProgressView        = [[MSSProgressView alloc] init];
    self.moveCommandLabel               = [[UILabel alloc] init];
    self.totalScoreLabel                = [[UILabel alloc] init];
    
}
- (void)createControls {
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
    self.moveCommandFont                = [UIFont fontWithName:@"HelveticaNeue-Medium" size:self.fontSize];;
    self.totalScoreFont                 = [UIFont fontWithName:@"HelveticaNeue-Heavy" size:self.fontSize * 2.0f];;

}
- (void)setupControls {
    
    /*Total Score Label*/
    self.totalScoreLabel.textColor                  = [UIColor whiteColor];
    self.totalScoreLabel.font                       = self.totalScoreFont;
    self.totalScoreLabel.text                       = @"0.0";
    self.totalScoreLabel.adjustsFontSizeToFitWidth  = YES;
    self.totalScoreLabel.numberOfLines              = 1;
    [self.totalScoreLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    /*Score remaining progress view*/
    [self.currentMoveProgressView setBackgroundColor:[UIColor darkGrayColor]];
    [self.currentMoveProgressView setBorderColor:[UIColor blackColor]];
    [self.currentMoveProgressView setBorderWidth:self.progressViewBoarderWidth];
    [self.currentMoveProgressView setCornerRadius:self.progressViewHeight / 2.0f];
    [self.currentMoveProgressView setProgressColor:[UIColor sandColor]];
    
    /*Move Instruction Label*/
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

#pragma mark - Gesture Recognizer Methods
- (void)tapRegistered:(UITapGestureRecognizer *)tapGestrureRecognizer {
    [[AppSingleton singleton] moveEnterForType:kSIMoveCommandTap];
}
- (void)pinchRegistered:(UIPinchGestureRecognizer *)pinchGestrureRecognizer {
    [[AppSingleton singleton] moveEnterForType:kSIMoveCommandPinch];
}
- (void)swypeRegistered:(UISwipeGestureRecognizer *)swipeGestrureRecognizer {
    [[AppSingleton singleton] moveEnterForType:kSIMoveCommandSwype];
}
- (void)shakeRegistered {
    [[AppSingleton singleton] moveEnterForType:kSIMoveCommandShake];
}

#pragma mark - Accelerometer Methods
- (void)startAccelerometerForShake {
    if ([self.gameMode isEqualToString:kSIGameModeOneHand]) {
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
}

#pragma mark - Class Methods
- (void)gameStarted {
    self.currentMoveProgressView.hidden = NO;
}
- (void)gameEnded {
    self.moveCommandLabel.text          = @"Game Over!";
    self.currentMoveProgressView.hidden = YES;
}
- (void)refreshScore {
    [self.currentMoveProgressView setProgress:(CGFloat)[AppSingleton singleton].currentGame.currentPoints];
    
}
- (void)correctMoveEntered {
    /*Set next move*/
    self.moveCommandLabel.text          = [AppSingleton singleton].currentGame.currentMove;
    
    /*Update the total score label*/
    self.totalScoreLabel.text           = [NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.totalScore];
}

@end
