//  SIMove.m
//  Swype It
//
//  Created by Andrew Keller on 9/5/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
#import "SIPowerUp.h"
#import "SIMove.h"

@implementation SIMove

- (NSString *)description {
    NSString *moveType = [SIGame stringForMove:_moveCommand];
    return [NSString stringWithFormat:@"%@\n Command: %@\nStart Time: %0.2f\nEnd time: %0.2f\nMove Score:%0.2f",[super description],moveType,_timeStart,_timeEnd,_moveScore];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _moveCommand        = SIMoveCommandSwype;
        _moveCommandAction  = SIMoveCommandActionSwypeNone;
        _moveScore          = 0.0f;
    }
    return self;
}

- (instancetype)initWithRandomMoveForGameMode:(SIGameMode)gameMode powerUpArray:(NSArray *)array {
    self = [self init];
    if (self) {
        _moveCommand = [SIMove randomMoveForGameMode:gameMode withPowerUpArray:array];
    }
    return self;
}

+ (SIMoveCommand)randomMoveForGameMode:(SIGameMode)gameMode withPowerUpArray:(NSArray *)powerUpArray {
    if ([SIPowerUp isPowerUpActive:SIPowerUpTypeRapidFire powerUpArray:powerUpArray]) {
        return SIMoveCommandTap;
    } else {
        return [SIGame getRandomMoveForGameMode:gameMode];
    }
}


- (CGPoint)touchPoint {
    if (_gestureRecognizer == nil) {
        return CGPointZero;
    }
    
    CGPoint explosionPoint = CGPointZero;
    
    if ([_gestureRecognizer numberOfTouches] > 1) {
        CGPoint firstPoint                          = [_gestureRecognizer locationOfTouch:0 inView:_gestureRecognizer.view];
        CGPoint secondPoint                         = [_gestureRecognizer locationOfTouch:1 inView:_gestureRecognizer.view];
        
        explosionPoint                              = CGPointMake((firstPoint.x + secondPoint.x) / 2.0f, (firstPoint.y + secondPoint.y) / 2.0f);
    } else {
        explosionPoint                              = [_gestureRecognizer locationOfTouch:0 inView:_gestureRecognizer.view];
    }
    explosionPoint                                  = CGPointMake(explosionPoint.x, _gestureRecognizer.view.frame.size.height - explosionPoint.y);
    
    return explosionPoint;
}


@end
