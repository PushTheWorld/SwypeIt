//  SIGameNode.m
//  Swype It
//
//  Created by Andrew Keller on 8/10/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//      NOTE: Implementation loosely based of `HLScrollNode`
//
//
//  Purpose: This is....
//
// Local Controller Import
#import "AppSingleton.h"
#import "MainViewController.h"
#import "SIGameNode.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports

enum {
    SIGameNodeZPositionLayerBackground = 0,
    SIGameNodeZPositionLayerContent,
    SIGameNodeZPositionLayerCount
};

@implementation SIGameNode {
    CGFloat                      _pinchDirection;
    
    SIGameMode                   _gameMode;
    
    SKSpriteNode                *_backgroundNode;
}

- (instancetype) init {
    return [self initWithSize:CGSizeZero gameMode:SIGameModeTwoHand];
}

- (instancetype) initWithSize:(CGSize)size gameMode:(SIGameMode)gameMode {
    self = [super init];
    if (self) {
        _gameMode                   = gameMode;
        _pinchDirection             = 0.0f;
        
        _backgroundNode             = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithWhite:0.0f alpha:1.0f] size:size];
        _backgroundNode.anchorPoint = CGPointMake(0.5f, 0.5f);
        [self addChild:_backgroundNode];
        
        [self SI_layout];
    }
    return self;
}

- (void)setBackgroundColor:(SKColor *)backgroundColor
{
    _backgroundNode.color = backgroundColor;
    [self SI_layout];
}

- (SKColor *)backgroundColor
{
    return _backgroundNode.color;
}

- (void)setSize:(CGSize)size {
    _backgroundNode.size = size;
    [self SI_layout];
}

- (CGSize)size {
    return _backgroundNode.size;
}

- (void)setAnchorPoint:(CGPoint)anchorPoint
{
    _backgroundNode.anchorPoint = anchorPoint;
    [self SI_layout];
}

- (CGPoint)anchorPoint
{
    return _backgroundNode.anchorPoint;
}

- (void)layoutToolsAnimation {
    [self SI_layout];
}

#pragma mark - HLGestureTarget
- (NSArray *)addsToGestureRecognizers {

    switch (_gameMode) {
        case SIGameModeOneHand:
            return @[[[UITapGestureRecognizer       alloc] init],
                     [SIGameNode swypeGesture]];
        default: /*SIGameModeTwoHand*/
            return @[[[UITapGestureRecognizer       alloc] init],
                     [[UIPinchGestureRecognizer     alloc] init],
                     [SIGameNode swypeGestureUp],
                     [SIGameNode swypeGestureDown],
                     [SIGameNode swypeGestureLeft],
                     [SIGameNode swypeGestureRight]];
    }
}

- (BOOL)addToGesture:(UIGestureRecognizer *)gestureRecognizer firstTouch:(UITouch *)touch isInside:(BOOL *)isInside {
    BOOL handleGesture = NO;
//    if (HLGestureTarget_areEquivalentGestureRecognizers(gestureRecognizer, [SIGameNode swypeGesture])) {
//        [gestureRecognizer addTarget:self action:@selector(handleSwype:)];
//        *isInside = YES;
//        return YES;
//        
//    }
    if (HLGestureTarget_areEquivalentGestureRecognizers(gestureRecognizer, [SIGameNode swypeGestureUp])) {
        [gestureRecognizer addTarget:self action:@selector(handleSwypeUp:)];
        *isInside = YES;
        return YES;
    } else if (HLGestureTarget_areEquivalentGestureRecognizers(gestureRecognizer, [SIGameNode swypeGestureDown])) {
        [gestureRecognizer addTarget:self action:@selector(handleSwypeDown:)];
        *isInside = YES;
        return YES;
    } else if (HLGestureTarget_areEquivalentGestureRecognizers(gestureRecognizer, [SIGameNode swypeGestureLeft])) {
        [gestureRecognizer addTarget:self action:@selector(handleSwypeLeft:)];
        *isInside = YES;
        return YES;
    } else if (HLGestureTarget_areEquivalentGestureRecognizers(gestureRecognizer, [SIGameNode swypeGestureRight])) {
        [gestureRecognizer addTarget:self action:@selector(handleSwypeRight:)];
        *isInside = YES;
        return YES;
    } else if (HLGestureTarget_areEquivalentGestureRecognizers(gestureRecognizer, [[UIPinchGestureRecognizer alloc] init])) {
        [gestureRecognizer addTarget:self action:@selector(handlePinch:)];
        *isInside = YES;
        return YES;
    } else if (HLGestureTarget_areEquivalentGestureRecognizers(gestureRecognizer, [[UITapGestureRecognizer alloc] init])) {
        UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer *)gestureRecognizer;
        if (tapGestureRecognizer.numberOfTapsRequired == 1) {
            *isInside       = YES;
            handleGesture   = YES;
        }
        if (handleGesture) {
//            if ([AppSingleton singleton].currentGame.currentPowerUp == SIPowerUpFallingMonkeys) {
//                CGPoint location    = [touch locationInNode:self];
//                NSArray *nodes      = [self nodesAtPoint:location];
//                for (SKNode *node in nodes) {
//                    if ([node.name isEqualToString:kSINodeFallingMonkey]) {
//                        [self.delegate monkeyTapped:node];
//
//                    }
//                }
//            }
            [gestureRecognizer addTarget:self action:@selector(handleTap:)];
        }
        return handleGesture;
    }
    *isInside = NO;
    return handleGesture;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gestureRecognizer {
    if (!_backgroundNode) {
        return;
    }
    if (gestureRecognizer.state != UIGestureRecognizerStateRecognized) {
        if ([gestureRecognizer numberOfTouches] > 1) {
            CGPoint firstPoint      = [gestureRecognizer locationOfTouch:0 inView:gestureRecognizer.view];
            CGPoint secondPoint     = [gestureRecognizer locationOfTouch:1 inView:gestureRecognizer.view];
            _pinchDirection         = atan2(secondPoint.y - firstPoint.y, secondPoint.x - firstPoint.x);
            
//            NSLog(@"Angle of pinch: %0.2f",_pinchDirection);
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (_pinchDirection < 0.0f) {
            [self.delegate gestureEnded:SIMovePinch siMoveCommandAction:SIMoveCommandActionPinchNegative];
        } else {
            [self.delegate gestureEnded:SIMovePinch siMoveCommandAction:SIMoveCommandActionPinchPositive];
        }
    }
}

- (void)handleSwype:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (!_backgroundNode) {
        return;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.delegate gestureEnded:SIMoveSwype siMoveCommandAction:SIMoveCommandActionSwypeNone];
    }
}

- (void)handleSwypeUp:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (!_backgroundNode) {
        return;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.delegate gestureEnded:SIMoveSwype siMoveCommandAction:SIMoveCommandActionSwypeUp];
    }
}

- (void)handleSwypeDown:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (!_backgroundNode) {
        return;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.delegate gestureEnded:SIMoveSwype siMoveCommandAction:SIMoveCommandActionSwypeDown];
    }
}

- (void)handleSwypeLeft:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (!_backgroundNode) {
        return;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.delegate gestureEnded:SIMoveSwype siMoveCommandAction:SIMoveCommandActionSwypeLeft];
    }
}

- (void)handleSwypeRight:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (!_backgroundNode) {
        return;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.delegate gestureEnded:SIMoveSwype siMoveCommandAction:SIMoveCommandActionSwypeRight];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (!_backgroundNode) {
        return;
    }

    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.delegate gestureEnded:SIMoveTap siMoveCommandAction:SIMoveCommandActionTap];
    }
}

#pragma mark - Private
- (void)SI_layout {
    /*Do layout stuff...*/
    
}
+ (UISwipeGestureRecognizer *)swypeGesture {
    static UISwipeGestureRecognizer *swipe = nil;
    if (!swipe) {
        swipe = [[UISwipeGestureRecognizer alloc] init];
        swipe.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    }
    return swipe;
}
+ (UISwipeGestureRecognizer *)swypeGestureUp {
    static UISwipeGestureRecognizer *swipeUp = nil;
    if (!swipeUp) {
        swipeUp = [[UISwipeGestureRecognizer alloc] init];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    }
    return swipeUp;
}
+ (UISwipeGestureRecognizer *)swypeGestureDown {
    static UISwipeGestureRecognizer *swipeDown = nil;
    if (!swipeDown) {
        swipeDown = [[UISwipeGestureRecognizer alloc] init];
        swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    }
    return swipeDown;
}
+ (UISwipeGestureRecognizer *)swypeGestureLeft {
    static UISwipeGestureRecognizer *swipeLeft = nil;
    if (!swipeLeft) {
        swipeLeft = [[UISwipeGestureRecognizer alloc] init];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    return swipeLeft;
}
+ (UISwipeGestureRecognizer *)swypeGestureRight {
    static UISwipeGestureRecognizer *swipeRight = nil;
    if (!swipeRight) {
        swipeRight = [[UISwipeGestureRecognizer alloc] init];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    }
    return swipeRight;
}



@end
