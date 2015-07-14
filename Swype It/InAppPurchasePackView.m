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
@property (assign, nonatomic) SIIAPPack siiapPack;

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
    if (self = [super init]) {
        self.siiapPack = siiapPack;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frameRect
{
    if ((self = [super initWithFrame:frameRect]))
    {
        [self initializeView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self initializeView];
    }
    return self;
}

- (void)initializeView {
    /*Perform Initalization*/
}


@end
