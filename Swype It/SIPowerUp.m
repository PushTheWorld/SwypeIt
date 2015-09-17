//  PowerUp.m
//  Swype It
//
//  Created by Andrew Keller on 9/4/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
#import "SIPowerUp.h"
#import "MKStoreKit.h"

@implementation SIPowerUp {

}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@\n Type: %@\nDuration: %d\nPercent Remaining: %0.2f\nPowerup Start Time:%0.2f",[super description],[SIPowerUp stringForPowerUp:_type],(int)_duration,_percentRemaining,_startTimeMS];
}

- (instancetype)initWithPowerUp:(SIPowerUpType)powerUp atTime:(float)powerUpStartTime {
    self = [super init];
    if (self) {
        _type               = powerUp;
        _duration           = [SIPowerUp durationForPowerUp:powerUp];
        _percentRemaining   = 1.0f;
        _isExpired          = NO;
        _startTimeMS        = powerUpStartTime;
    }
    return self;
}

+ (void)consumePowerUp:(SIPowerUpType)powerUp {
    [[MKStoreKit sharedKit] consumeCredits:[NSNumber numberWithInt:[SIPowerUp costForPowerUp:powerUp]] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
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
 
 AUTO TESTED
 */
+ (BOOL)canStartPowerUp:(SIPowerUpType)powerUp powerUpArray:(NSArray *)powerUpArray {
    if ([SIPowerUp isPowerUpArrayEmpty:powerUpArray]) {
        return YES;
    }
    switch (powerUp) {
        case SIPowerUpTypeFallingMonkeys:
            for (SIPowerUp *powerUpClass in powerUpArray) {
                if (powerUpClass.type == SIPowerUpTypeRapidFire || powerUpClass.type == SIPowerUpTypeFallingMonkeys) {
                    return NO;
                }
            }
            return YES;
        case SIPowerUpTypeRapidFire:
            for (SIPowerUp *powerUpClass in powerUpArray) {
                if (powerUpClass.type == SIPowerUpTypeFallingMonkeys || powerUpClass.type == SIPowerUpTypeRapidFire) {
                    return NO;
                }
            }
            return YES;
        case SIPowerUpTypeTimeFreeze:
            for (SIPowerUp *powerUpClass in powerUpArray) {
                if (powerUpClass.type == SIPowerUpTypeTimeFreeze) {
                    return NO;
                }
            }
            return YES;
        default:
            return NO;
    }
}
/*AUTO TESTED*/
+ (BOOL)isPowerUpActive:(SIPowerUpType)powerUp powerUpArray:(NSArray *)powerUpArray {
    for (SIPowerUp *powerUpClass in powerUpArray) {
        if (powerUp == powerUpClass.type) {
            return YES;
        }
    }
    return NO;
}
/*AUTO TESTED*/
+ (BOOL)isPowerUpArrayEmpty:(NSArray *)powerUpArray {
    if (powerUpArray == nil) {
        return YES;
    }
    
    if ([powerUpArray count] == 0) {
        return YES;
    }
    
    return NO;
}
/*AUTO TESTED*/
+ (float)maxPercentOfPowerUpArray:(NSArray *)powerUpArray {
    if (powerUpArray == nil) {
        return 0.0f;
    }
    
    if ([powerUpArray count] == 0) {
        return 0.0f;
    }
    
    float maxPercentRemaining   = 0.0f;
    
    for (SIPowerUp *powerUp in powerUpArray) {
        if (powerUp.percentRemaining > maxPercentRemaining) {
            maxPercentRemaining = powerUp.percentRemaining;
        }
    }
    
    return maxPercentRemaining;
}


/*AUTO TESTED*/
+ (SIPowerUpCost)costForPowerUp:(SIPowerUpType)powerUp {
    switch (powerUp) {
        case SIPowerUpTypeTimeFreeze:
            return SIPowerUpCostTimeFreeze;
        case SIPowerUpTypeRapidFire:
            return SIPowerUpCostRapidFire;
        case SIPowerUpTypeFallingMonkeys:
            return SIPowerUpCostFallingMonkeys;
        default: /*Power Up None*/
            return SIPowerUpCostNone;
    }
}
/*AUTO TESTED*/
+ (SIPowerUpDuration)durationForPowerUp:(SIPowerUpType)powerUp {
    switch (powerUp) {
        case SIPowerUpTypeTimeFreeze:
            return SIPowerUpDurationTimeFreeze;
        case SIPowerUpTypeRapidFire:
            return SIPowerUpDurationRapidFire;
        default: /*None*/
            return SIPowerUpDurationNone;
    }
}

/*AUTO TESTED*/
+ (NSString *)stringForPowerUp:(SIPowerUpType)powerUp {
    switch (powerUp) {
        case SIPowerUpTypeFallingMonkeys:
            return kSIPowerUpTypeFallingMonkeys;
        case SIPowerUpTypeTimeFreeze:
            return kSIPowerUpTypeTimeFreeze;
        case SIPowerUpTypeRapidFire:
            return kSIPowerUpTypeRapidFire;
        case SIPowerUpTypeNone:
            return kSIPowerUpTypeNone;
        default:
            return nil;
    }
}
/*AUTO TESTED*/
+ (float)powerUpPercentRemaining:(NSArray *)powerUpArray compositeTime:(float)compositeTime withCallback:(void (^)(SIPowerUp *powerUpToDeactivate))callback {
    float maxPercent = 0.0f;
    
    for (SIPowerUp *powerUp in powerUpArray) {
        if (powerUp.type != SIPowerUpTypeFallingMonkeys) {
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
    }
    return maxPercent;
}
/*AUTO TESTED*/
+ (SIPowerUpType)powerUpForString:(NSString *)powerUpString {
    if ([powerUpString isEqualToString:kSIPowerUpTypeFallingMonkeys]) {
        return SIPowerUpTypeFallingMonkeys;
    } else if ([powerUpString isEqualToString:kSIPowerUpTypeRapidFire]) {
        return SIPowerUpTypeRapidFire;
    } else if ([powerUpString isEqualToString:kSIPowerUpTypeTimeFreeze]) {
        return SIPowerUpTypeTimeFreeze;
    } else {
        return SIPowerUpTypeNone;
    }
}

@end