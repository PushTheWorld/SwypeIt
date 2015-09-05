//  SIPowerUp.h
//  Swype It
//
//  Created by Andrew Keller on 9/4/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Game.h"

@interface SIPowerUp : NSObject

/**
 Used for clean up... indicated that the time expired
 */
@property (nonatomic, assign) BOOL isExpired;

@property (nonatomic, assign) SIPowerUpType type;

/**
 The duration of the powerup in seconds... this is the main one
 */
@property (nonatomic, assign) SIPowerUpDuration duration;

/**
 The percent remaining of the power up...
 */
@property (nonatomic, assign) float percentRemaining;

/**
 The time (in world game time) that the power up was started
 Unit of time is milli seconds
 */
@property (nonatomic, assign) float startTimeMS;



/**
 Your run at the mill initializer
 */
- (instancetype)initWithPowerUp:(SIPowerUpType)powerUp atTime:(float)powerUpStartTime;


+ (BOOL)                canStartPowerUp:(SIPowerUpType)powerUp powerUpArray:(NSArray *)powerUpArray;
+ (BOOL)                isPowerUpActive:(SIPowerUpType)powerUp powerUpArray:(NSArray *)powerUpArray;
+ (BOOL)                isPowerUpArrayEmpty:(NSArray *)powerUpArray;
+ (float)               maxDurationPercentOfPowerUpArray:(NSArray *)powerUpArray;
+ (float)               powerUpPercentRemaining:(NSArray *)powerUpArray compositeTime:(float)compositeTime withCallback:(void (^)(PowerUp *powerUpToDeactivate))callback;

/**
 Gets the SIPowerUp given a string...
 
 Returns SIPowerUpTypeNone for unrecognized...
 */
+ (SIPowerUpType)powerUpForString:(NSString *)powerUpString;

/**
 Simply gets the cost
 */
+ (SIPowerUpCost)costForPowerUp:(SIPowerUpType)powerUp;

/**
 Gets the duration of the powerup
 */
+ (SIPowerUpDuration)durationForPowerUp:(SIPowerUpType)powerUp;

/**
 Gets the string for the powerup
 */
+ (NSString *)stringForPowerUp:(SIPowerUpType)powerUp;
/**
 Consumes the cost a power up...
 
 DANGER: Accesses the MKStoreKit
 */
+ (void)consumePowerUp:(SIPowerUpType)powerUp;

@end
