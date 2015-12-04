//
//  SIPopTip.h
//  Swype It
//
//  Created by Andrew Keller on 11/27/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
// Local Controller Import
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "HLSpriteKit.h"
// Category Import
// Support/Data Class Imports
#import "SIGame.h"
// Other Imports

typedef NS_ENUM(NSInteger, SIPopTipPositionVertical) {
    SIPopTipPositionVerticalTop = 0,
    SIPopTipPositionVerticalBottom
};

typedef NS_ENUM(NSInteger, SIPopTipPositionHorizontal) {
    SIPopTipPositionHorizontalLeft = 0,
    SIPopTipPositionHorizontalCenter,
    SIPopTipPositionHorizontalRight,
};

typedef NS_ENUM(NSInteger, SIZPositionPopTip) {
    SIZPositionPopTipBackground = 0,
    SIZPositionPopTipText,
    SIZPositionPopTipCount
};

typedef NS_ENUM(NSInteger, SIPopTipEffect) {
    SIPopTipEffectBounce = 0,
    SIPopTipEffectNone
};


@class SIPopTip;
@protocol SIPopTipDelegate <NSObject>
@optional

/// @name Managing Interaction

/**
 The delegate invoked on interaction
 
 */
- (void)dismissPopTip:(SIPopTip *)popTip;

@end

@interface SIPopTip : HLComponentNode

/// @name Optional Delegate Method

/**
 Delegate methods
 */
@property (nonatomic, weak) id <SIPopTipDelegate> delegate;

/**
 The initalizer method
 */
- (instancetype)initWithSize:(CGSize)size withMessage:(NSString *)message;

/**
 SIPopTipPositionVertical
 */
@property (assign, nonatomic) SIPopTipPositionVertical positionVertical;

/**
 SIPopTipPositionHorizontal
 */
@property (assign, nonatomic) SIPopTipPositionHorizontal positionHorizontal;

/**
 Sets the message for the pop tip
 */
@property (strong, nonatomic) NSString *message;

/**
 Set for effects
 */
@property (assign, nonatomic) SIPopTipEffect effect;

/**
 The amount the pop tip bounces
 Default is `10.0`
 */
@property (assign, nonatomic) float effectDeltaY;

@end