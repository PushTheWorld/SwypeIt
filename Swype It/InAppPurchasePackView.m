//
//  InAppPurchasePack.m
//  Swype It
//
//  Created by Andrew Keller on 7/14/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: Thie is the startign screen for the swype it game
//
// Local Import
#import "InAppPurchasePackView.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIConstants.h"
// Other Imports

@interface InAppPurchasePackView () {
    
}
#pragma mark - Private Properties
@property (assign, nonatomic) SIIAPPack siiapPack;

#pragma mark - Private Objects
@property (strong, nonatomic) UIImageView   *packImage;
@property (strong, nonatomic) UILabel       *packLabel;
@property (strong, nonatomic) UILabel       *priceLabel;

@end

@implementation InAppPurchasePackView 
    

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithPack:(SIIAPPack)siiapPack {
    self = [super initWithFrame:CGRectZero];
    if (self != nil) {
        [self initializeViewWithPack:siiapPack];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frameRect
{
    if ((self = [super initWithFrame:frameRect]))
    {
        [self initializeViewWithPack:SIIAPPackSmall];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self initializeViewWithPack:SIIAPPackSmall];
    }
    return self;
}

- (void)initializeViewWithPack:(SIIAPPack)siiapPack {
    /*Perform Initalization*/
    if (siiapPack) {
        self.siiapPack = siiapPack;
    }
}


@end
