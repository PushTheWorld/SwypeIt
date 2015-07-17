//
//  FallingMonkeyView.m
//  Swype It
//
//  Created by Andrew Keller on 7/14/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: Thie is the startign screen for the swype it game
//
// Local Import
#import "FallingMonkeyView.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIConstants.h"
// Other Imports

@interface FallingMonkeyView () {
    
}
#pragma mark - Private Properties
@property (assign, nonatomic) SIIAPPack siiapPack;

#pragma mark - Private Objects
@property (strong, nonatomic) UIImageView   *monkeyImageView;

@end

@implementation FallingMonkeyView
    

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frameRect
{
    if ((self = [super initWithFrame:frameRect]))
    {
        [self setupUserInterface];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setupUserInterface];
    }
    return self;
}
- (void)setupUserInterface {
    [self createConstants];
    [self createControls];
    [self setupControls];
    [self layoutControls];
}
- (void)createConstants {
    
}
- (void)createControls {
    self.monkeyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kSIImageFallingMonkeys]];
}
- (void)setupControls {
    self.monkeyImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.monkeyImageView.backgroundColor = [UIColor clearColor];
    [self.monkeyImageView setUserInteractionEnabled:YES];
    [self.monkeyImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(monkeyTapped:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}
- (void)layoutControls {
    [self addSubview:self.monkeyImageView];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"imageView" : self.monkeyImageView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"imageView" : self.monkeyImageView}]];
}
- (void)monkeyTapped:(UIGestureRecognizer *)gestureRecognizer {
    [self.delegate monkeyWasTapped:self];
}
@end
