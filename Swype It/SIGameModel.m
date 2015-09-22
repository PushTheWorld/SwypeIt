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
        _game                                               = [[SIGame alloc] init];
        _powerUpArray                                       = [NSMutableArray array];
        _stateMachine                                       = [self createGameStateMachine];
    }
    return self;
}

#pragma mark - State Machine Methods
- (TKStateMachine *)createGameStateMachine {
    TKStateMachine *stateMachine                            = [TKStateMachine new];
    
    TKState *gameStateIdle                                  = [TKState stateWithName:kSITKStateMachineStateGameIdle];
    TKState *gameStatePaused                                = [TKState stateWithName:kSITKStateMachineStateGamePause];
    TKState *gameStatePayingForContinue                     = [TKState stateWithName:kSITKStateMachineStateGamePayingForContinue];
    TKState *gameStatePopupContinue                         = [TKState stateWithName:kSITKStateMachineStateGamePopupContinue];
    TKState *gameStateProcessingMove                        = [TKState stateWithName:kSITKStateMachineStateGameProcessingMove];
    TKState *gameStateEnd                                   = [TKState stateWithName:kSITKStateMachineStateGameEnd];
    TKState *gameStateFallingMonkey                         = [TKState stateWithName:kSITKStateMachineStateGameFallingMonkey];
    
    //enters
    [gameStateIdle setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [self didEnterState:SIGameStateIdle];
    }];
    
    [gameStatePaused setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [self didEnterState:SIGameStatePause];
    }];
    
    [gameStatePayingForContinue setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        NSDictionary *userInfo = transition.userInfo;
        
        SISceneGamePopupContinueMenuItem payMethod = [(NSNumber *)[userInfo objectForKey:kSINSDictionaryKeyPayToContinueMethod] integerValue];
        
        if ([_delegate respondsToSelector:@selector(gameModelStatePayingForContinueEnteredWithPayMethod:)]) {
            [_delegate gameModelStatePayingForContinueEnteredWithPayMethod:payMethod];
        }
    }];
    
    [gameStatePopupContinue setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [self didEnterState:SIGameStatePopupContinue];
    }];
    
    [gameStateProcessingMove setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        NSDictionary *userInfo = transition.userInfo;
        
        if ([_delegate respondsToSelector:@selector(gameModelStateEndExited)]) {
            [_delegate gameModelStateProcessingMoveEnteredWithMove:[userInfo objectForKey:@"move"]];
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
        if ([_delegate respondsToSelector:@selector(gameModelStateEndExited)]) {
            [_delegate gameModelStateEndExited];
        }
    }];
    
    [gameStatePaused setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        if ([_delegate respondsToSelector:@selector(gameModelStatePauseExited)]) {
            [_delegate gameModelStatePauseExited];
        }
    }];
    
    [gameStateProcessingMove setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        if ([_delegate respondsToSelector:@selector(gameModelStateProcessingMoveExited)]) {
            [_delegate gameModelStateProcessingMoveExited];
        }
    }];
    
    //add
    [stateMachine addStates:@[ gameStateIdle,gameStatePaused,gameStatePayingForContinue,gameStatePopupContinue,gameStateProcessingMove,gameStateEnd,gameStateFallingMonkey]];
    
    // Set the inital state to start... this way we get fresh new data!!!
    stateMachine.initialState       = gameStateEnd;
    
    //transition rules
    _gameEventEndGame               = [TKEvent eventWithName:kSITKStateMachineEventGameEndGame
                                     transitioningFromStates:@[gameStateIdle,gameStatePaused,gameStatePayingForContinue,gameStatePopupContinue,gameStateProcessingMove,gameStateFallingMonkey]
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
                                                     toState:gameStatePaused];
    
    _gameEventPayForContinue        = [TKEvent eventWithName:kSITKStateMachineEventGamePayForContinue
                                     transitioningFromStates:@[gameStatePayingForContinue]
                                                     toState:gameStatePayingForContinue];
    
    _gameEventStartGame             = [TKEvent eventWithName:kSITKStateMachineEventGameStartGame
                                     transitioningFromStates:@[gameStateEnd]
                                                     toState:gameStateIdle];
    
    
    _gameEventWaitForMove           = [TKEvent eventWithName:kSITKStateMachineEventGameWaitForMove
                                     transitioningFromStates:@[gameStatePayingForContinue, gameStateEnd, gameStatePaused, gameStateProcessingMove]
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
            if ([_delegate respondsToSelector:@selector(gameModelStateIdleEntered)]) {
                [_delegate gameModelStateIdleEntered];
            }
            break;
        case SIGameStatePause:
            if ([_delegate respondsToSelector:@selector(gameModelStatePauseEntered)]) {
                [_delegate gameModelStatePauseEntered];
            }
            break;
        case SIGameStatePayingForContinue:
            if ([_delegate respondsToSelector:@selector(gameModelStatePayingForContinueEntered)]) {
                [_delegate gameModelStatePayingForContinueEntered];
            }
            break;
        case SIGameStatePopupContinue:
            if ([_delegate respondsToSelector:@selector(gameModelStatePopupContinueEntered)]) {
                [_delegate gameModelStatePopupContinueEntered];
            }
            break;
        case SIGameStateFallingMonkey:
            if ([_delegate respondsToSelector:@selector(gameModelStateFallingMonkeyEntered)]) {
                [_delegate gameModelStateFallingMonkeyEntered];
            }
            break;
        case SIGameStateEnd:
        default:
            if ([_delegate respondsToSelector:@selector(gameModelStateEndEntered)]) {
                [_delegate gameModelStateEndEntered];
            }
            break;
    }
}


@end
