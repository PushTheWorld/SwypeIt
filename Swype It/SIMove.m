//  SIMove.m
//  Swype It
//
//  Created by Andrew Keller on 9/5/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import "SIMove.h"

@implementation SIMove

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
