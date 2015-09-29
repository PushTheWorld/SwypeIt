//  SIPowerUp.h
//  Swype It
//
//  Created by Andrew Keller on 9/4/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SIGame.h"

@interface SIPowerUp : NSObject

/**
 Used for clean up... indicated that the time expired
 */
@property (nonatomic, assign) BOOL isExpired;

/**
 The type (SIPowerUpType) of the power up
 */
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
@property (nonatomic, assign) NSTimeInterval startTime;



/**
 Your run at the mill initializer
 */
- (instancetype)initWithPowerUp:(SIPowerUpType)powerUp startTime:(NSTimeInterval)powerUpStartTime;

/**
 Applys Programmer defined rules for whether or not a power up can start
 */
+ (BOOL)canStartPowerUp:(SIPowerUpType)powerUp powerUpArray:(NSArray *)powerUpArray;
/**
 Checks an powerUpArray to see if the powerUp is active
 */
+ (BOOL)isPowerUpActive:(SIPowerUpType)powerUp powerUpArray:(NSArray *)powerUpArray;
/**
 Checks to see if the powerUpArray has 0 objects or is nil
 */
+ (BOOL)isPowerUpArrayEmpty:(NSArray *)powerUpArray;

/**
 Returns the maximum percent found in the powerup array
 */
+ (float)maxPercentOfPowerUpArray:(NSArray *)powerUpArray;
/**
 Traverses through powerUpArray and recaluclates all powerup percentages using the start time,
    Uses properties to do with start time too and duration of power up
    Callback returns any powerup with a percentage less than 0.01 to be deactivated
 */
+ (float)powerUpPercentRemaining:(NSArray *)powerUpArray gameTimeTotal:(NSTimeInterval)gameTimeTotal timeFreezeMultiplier:(float)timeFreezeMultiplier withCallback:(void (^)(SIPowerUp *powerUpToDeactivate))callback;

/**
 Gets the SIPowerUp given a string...
 
 Returns SIPowerUpTypeNone for unrecognized...
 */
+ (SIPowerUpType)powerUpForString:(NSString *)powerUpString;

/**
 Returns a power up type for the tool tag!
 */
+ (SIPowerUpType)powerUpForPowerUpToolTag:(NSString *)toolTag;

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
