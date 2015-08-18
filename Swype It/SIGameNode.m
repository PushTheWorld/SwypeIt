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
                     [self swypeGesture]];
        default: /*SIGameModeTwoHand*/
            return @[[[UITapGestureRecognizer       alloc] init],
                     [[UIPinchGestureRecognizer     alloc] init],
                     [self swypeGesture]];
    }
}

- (BOOL)addToGesture:(UIGestureRecognizer *)gestureRecognizer firstTouch:(UITouch *)touch isInside:(BOOL *)isInside {
    BOOL handleGesture = NO;
    if (HLGestureTarget_areEquivalentGestureRecognizers(gestureRecognizer, [self swypeGesture])) {
        [gestureRecognizer addTarget:self action:@selector(handleSwipe:)];
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
            if ([AppSingleton singleton].currentGame.currentPowerUp == SIPowerUpFallingMonkeys) {
                CGPoint location    = [touch locationInNode:self];
                NSArray *nodes      = [self nodesAtPoint:location];
                for (SKNode *node in nodes) {
                    if ([node.name isEqualToString:kSINodeFallingMonkey]) {
                        [self.delegate monkeyTapped:node];
                    }
                }
            }
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
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.delegate gestureEnded:SIMovePinch];
    }
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    if (!_backgroundNode) {
        return;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.delegate gestureEnded:SIMoveSwype];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.delegate gestureEnded:SIMoveSwype];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer {
    if (!_backgroundNode) {
        return;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.delegate gestureEnded:SIMoveTap];
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.delegate gestureEnded:SIMoveTap];
    }
}

#pragma mark - Private
- (void)SI_layout {
    /*Do layout stuff...*/
    
}

- (UISwipeGestureRecognizer *)swypeGesture {
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] init];
    swipe.direction                 = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
    return swipe;
}




@end
