//  Move.h
//  Swype It
//
//  Created by Andrew Keller on 9/5/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SIGame.h"
@interface SIMove : NSObject

- (instancetype)initWithRandomMoveForGameMode:(SIGameMode)gameMode powerUpArray:(NSArray *)array;

/**
 This is the type of move
 */
@property (nonatomic, assign) SIMoveCommand moveCommand;

/**
 This is the move command action to be take
 */
@property (nonatomic, assign) SIMoveCommandAction moveCommandAction;

/**
 This is the gesture that triggered the move
 nil if it really wasnt a gesture that returned it...
 */
@property (nonatomic, strong) UIGestureRecognizer *gestureRecognizer;

/**
 The point to launch the explosion from...
 */
@property (nonatomic, assign) CGPoint touchPoint;

/**
 The total score at this point
 */
//@property (nonatomic, assign) float totalScore;

/**
 The time the move started at
 */
@property (nonatomic, assign) NSTimeInterval timeStart;

/**
 The time the move was acted upon at
 */
@property (nonatomic, assign) NSTimeInterval timeEnd;

/**
 The current move score
 */
@property (nonatomic, assign) float moveScore;


@end
