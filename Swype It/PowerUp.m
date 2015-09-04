//  PowerUp.m
//  Swype It
//
//  Created by Andrew Keller on 9/4/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
#import "PowerUp.h"
#import "MKStoreKit.h"

@implementation PowerUp {

}

- (instancetype)initWithPowerUp:(SIPowerUp)powerUp atTime:(float)powerUpStartTime {
    self = [super init];
    if (self) {
        _type               = powerUp;
        _duration           = [PowerUp durationForPowerUp:powerUp];
        _percentRemaining   = 1.0f;
        _isExpired          = NO;
        _startTimeMS        = powerUpStartTime;
    }
    return self;
}

+ (void)consumePowerUp:(SIPowerUp)powerUp {
    [[MKStoreKit sharedKit] consumeCredits:[NSNumber numberWithInt:[PowerUp costForPowerUp:powerUp]] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
}
/**
 As a user I want to start falling monkey power up
 if powerUpArray is empty ? Return YES : check contents of powerup array
 don't allow start if one of the power ups is rapid fire
 
 As a user I want to start rapid fire
 if powerUpArray is empty ? Return YES : check contents of powerup array
 don't allow start if one of the power ups is falling monkey
 
 As a user I want to start time freeze
 go right ahead man
 
 */
+ (BOOL)canStartPowerUp:(SIPowerUp)powerUp powerUpArray:(NSArray *)powerUpArray {
    if ([PowerUp isPowerUpArrayEmpty:powerUpArray]) {
        return YES;
    }
    switch (powerUp) {
        case SIPowerUpFallingMonkeys:
            for (PowerUp *powerUpClass in powerUpArray) {
                if (powerUpClass.type == SIPowerUpRapidFire) {
                    return NO;
                }
            }
        case SIPowerUpRapidFire:
            for (PowerUp *powerUpClass in powerUpArray) {
                if (powerUpClass.type == SIPowerUpFallingMonkeys) {
                    return NO;
                }
            }
        case SIPowerUpTimeFreeze:
            return YES;
        default:
            return NO;
    }
}

+ (BOOL)isPowerUpActive:(SIPowerUp)powerUp powerUpArray:(NSArray *)powerUpArray {
    for (PowerUp *powerUpClass in powerUpArray) {
        if (powerUp == powerUpClass.type) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isPowerUpArrayEmpty:(NSArray *)powerUpArray {
    if (powerUpArray == nil) {
        return YES;
    }
    
    if ([powerUpArray count] == 0) {
        return YES;
    }
    
    return NO;
}

+ (float)maxDurationPercentOfPowerUpArray:(NSArray *)powerUpArray {
    if (powerUpArray == nil) {
        return 0.0f;
    }
    
    if ([powerUpArray count] == 0) {
        return 0.0f;
    }
    
    float maxRemainingDuraion = 0.0f;
    
    float maxPercentRemaining = 0.0f;
    
    for (PowerUp *powerUp in powerUpArray) {
        if (powerUp.durationRemaining > maxRemainingDuraion) {
            maxPercentRemaining = powerUp.durationRemaining / (float)powerUp.duration;
            maxRemainingDuraion = powerUp.durationRemaining;
        }
    }
    
    return maxPercentRemaining;
}


+ (SIPowerUpCost)costForPowerUp:(SIPowerUp)powerUp {
    switch (powerUp) {
        case SIPowerUpTimeFreeze:
            return SIPowerUpCostTimeFreeze;
        case SIPowerUpRapidFire:
            return SIPowerUpCostRapidFire;
        case SIPowerUpFallingMonkeys:
            return SIPowerUpCostFallingMonkeys;
        default: /*Power Up None*/
            return SIPowerUpCostNone;
    }
}

+ (SIPowerUpDuration)durationForPowerUp:(SIPowerUp)powerUp {
    switch (powerUp) {
        case SIPowerUpTimeFreeze:
            return SIPowerUpDurationTimeFreeze;
        case SIPowerUpRapidFire:
            return SIPowerUpDurationRapidFire;
        default: /*None*/
            return SIPowerUpDurationNone;
    }
}

+ (float)powerUpPercentRemaining:(NSArray *)powerUpArray compositeTime:(float)compositeTime withCallback:(void (^)(PowerUp *powerUpToDeactivate))callback {
    float maxPercent = 0.0f;
    
    for (PowerUp *powerUp in powerUpArray) {
        powerUp.percentRemaining = ((powerUp.duration * MILI_SECS_IN_SEC) - (compositeTime - powerUp.startTimeMS)) / (powerUp.duration * MILI_SECS_IN_SEC);
        if (powerUp.percentRemaining < EPSILON_NUMBER) { /*This deactivates powerups... it's sooo powerful muwahahahha*/
            /*Can one class function handle all that power?!?!*/
            if (callback) {
                callback(powerUp);
            }
        }
        if (powerUp.percentRemaining > maxPercent) {
            maxPercent = powerUp.percentRemaining;
        }
    }
    return maxPercent;
}


@end
