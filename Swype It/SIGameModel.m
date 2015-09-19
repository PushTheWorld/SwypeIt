//
//  SIGameModel.m
//  Swype It
//
//  Created by Andrew Keller on 9/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import "SIGameModel.h"

@implementation SIGameModel {
    TKEvent                                 *_gameEventEndGame;
    TKEvent                                 *_gameEventFallingMonkeyEnd;
    TKEvent                                 *_gameEventFallingMonkeyStart;
    TKEvent                                 *_gameEventMoveEntered;
    TKEvent                                 *_gameEventPause;
    TKEvent                                 *_gameEventPayForContinue;
    TKEvent                                 *_gameEventStartGame;
    TKEvent                                 *_gameEventWaitForMove;
    TKEvent                                 *_gameEventWrongMoveEntered;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _stateMachine = [self createGameStateMachine];
    }
    return self;
}


#pragma mark - State Machine Methods
- (TKStateMachine *)createGameStateMachine {
    TKStateMachine *stateMachine                            = [TKStateMachine new];
    
    TKState *gameStateIdle                                  = [TKState stateWithName:kSITKStateMachineStateGameIdle];
    TKState *gameStatePause                                 = [TKState stateWithName:kSITKStateMachineStateGamePause];
    TKState *gameStatePayingForContinue                     = [TKState stateWithName:kSITKStateMachineStateGamePayingForContinue];
    TKState *gameStatePopupContinue                         = [TKState stateWithName:kSITKStateMachineStateGamePopupContinue];
    TKState *gameStateProcessingMove                        = [TKState stateWithName:kSITKStateMachineStateGameProcessingMove];
    TKState *gameStateEnd                                   = [TKState stateWithName:kSITKStateMachineStateGameEnd];
    TKState *gameStateFallingMonkey                         = [TKState stateWithName:kSITKStateMachineStateGameFallingMonkey];
    
    //enters
    [gameStateIdle setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [self didEnterState:SIGameStateIdle];
    }];
    
    [gameStatePause setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [self didEnterState:SIGameStatePause];
    }];
    
    [gameStatePayingForContinue setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [self didEnterState:SIGameStatePayingForContinue];
    }];
    
    [gameStatePopupContinue setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [self didEnterState:SIGameStatePopupContinue];
    }];
    
    [gameStateProcessingMove setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        NSDictionary *userInfo = transition.userInfo;
        
        if ([_delegate respondsToSelector:@selector(gameModelGameStateExitedEnd)]) {
            [_delegate gameModelEnteredStateProcessingMove:[userInfo objectForKey:@"move"]];
        }
    }];
    
    [gameStateEnd setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [self didEnterState:SIGameStateEnd];
    }];
    
    [gameStateFallingMonkey setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [self didEnterState:SIGameStateFallingMonkey];
    }];
    
    //exits
    [gameStateEnd setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        if ([_delegate respondsToSelector:@selector(gameModelGameStateExitedEnd)]) {
            [_delegate gameModelGameStateExitedEnd];
        }
    }];
    
    //add
    [stateMachine addStates:@[ gameStateIdle,gameStatePause,gameStatePayingForContinue,gameStatePopupContinue,gameStateProcessingMove,gameStateEnd,gameStateFallingMonkey]];
    
    // Set the inital state to start... this way we get fresh new data!!!
    stateMachine.initialState       = gameStateEnd;
    
    //transition rules
    _gameEventEndGame               = [TKEvent eventWithName:kSITKStateMachineEventGameEndGame
                                     transitioningFromStates:@[gameStateIdle,gameStatePause,gameStatePayingForContinue,gameStatePopupContinue,gameStateProcessingMove,gameStateFallingMonkey]
                                                     toState:gameStateEnd];
    
    _gameEventFallingMonkeyEnd      = [TKEvent eventWithName:kSITKStateMachineEventGameFallingMonkeyEnd
                                     transitioningFromStates:@[gameStateFallingMonkey]
                                                     toState:gameStateIdle];
    
    _gameEventFallingMonkeyStart    = [TKEvent eventWithName:kSITKStateMachineEventGameFallingMonkeyStart
                                     transitioningFromStates:@[gameStateProcessingMove]
                                                     toState:gameStateFallingMonkey];
    
    _gameEventMoveEntered           = [TKEvent eventWithName:kSITKStateMachineEventGameMoveEntered
                                     transitioningFromStates:@[gameStateIdle]
                                                     toState:gameStateProcessingMove];
    
    _gameEventPause                 = [TKEvent eventWithName:kSITKStateMachineEventGamePause
                                     transitioningFromStates:@[gameStateIdle]
                                                     toState:gameStatePause];
    
    _gameEventPayForContinue        = [TKEvent eventWithName:kSITKStateMachineEventGamePayForContinue
                                     transitioningFromStates:@[gameStatePayingForContinue]
                                                     toState:gameStatePayingForContinue];
    
    _gameEventStartGame             = [TKEvent eventWithName:kSITKStateMachineEventGameStartGame
                                     transitioningFromStates:@[gameStateEnd]
                                                     toState:gameStateIdle];
    
    
    _gameEventWaitForMove           = [TKEvent eventWithName:kSITKStateMachineEventGameWaitForMove
                                     transitioningFromStates:@[gameStatePayingForContinue, gameStateEnd, gameStatePause, gameStateProcessingMove]
                                                     toState:gameStateIdle];
    
    _gameEventWrongMoveEntered      = [TKEvent eventWithName:kSITKStateMachineEventGameWrongMoveEntered
                                     transitioningFromStates:@[gameStateProcessingMove]
                                                     toState:gameStatePopupContinue];
    
    //add event rules
    [stateMachine addEvents:@[_gameEventEndGame, _gameEventFallingMonkeyEnd, _gameEventFallingMonkeyStart, _gameEventMoveEntered, _gameEventPause, _gameEventPayForContinue, _gameEventStartGame, _gameEventWaitForMove, _gameEventWrongMoveEntered]];
    
    
    return stateMachine;
}

- (void)didEnterState:(SIGameState)gameState {
    switch (gameState) {
        case SIGameStateIdle:
            if ([_delegate respondsToSelector:@selector(gameModelEnteredStateIdle)]) {
                [_delegate gameModelEnteredStateIdle];
            }
            break;
        case SIGameStatePause:
            if ([_delegate respondsToSelector:@selector(gameModelEnteredStatePause)]) {
                [_delegate gameModelEnteredStatePause];
            }
            break;
        case SIGameStatePayingForContinue:
            if ([_delegate respondsToSelector:@selector(gameModelEnteredStatePayingForContinue)]) {
                [_delegate gameModelEnteredStatePayingForContinue];
            }
            break;
        case SIGameStatePopupContinue:
            if ([_delegate respondsToSelector:@selector(gameModelEnteredStatePopupContinue)]) {
                [_delegate gameModelEnteredStatePopupContinue];
            }
            break;
        case SIGameStateFallingMonkey:
            if ([_delegate respondsToSelector:@selector(gameModelEnteredStateFallingMonkey)]) {
                [_delegate gameModelEnteredStateFallingMonkey];
            }
            break;
        case SIGameStateEnd:
        default:
            if ([_delegate respondsToSelector:@selector(gameModelEnteredStateEnd)]) {
                [_delegate gameModelEnteredStateEnd];
            }
            break;
    }
}


@end
