//
//  SIGameModel.m
//  Swype It
//
//  Created by Andrew Keller on 9/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import "SIGameModel.h"

@implementation SIGameModel

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

    TKState *gameStateDefault                               = [TKState stateWithName:kSITKStateMachineStateGameDefault];
    TKState *gameStateIdle                                  = [TKState stateWithName:kSITKStateMachineStateGameIdle];
    TKState *gameStateEnd                                   = [TKState stateWithName:kSITKStateMachineStateGameEnd];
    TKState *gameStateFallingMonkey                         = [TKState stateWithName:kSITKStateMachineStateGameFallingMonkey];
    TKState *gameStateLoading                               = [TKState stateWithName:kSITKStateMachineStateGameLoading];
    TKState *gameStatePaused                                = [TKState stateWithName:kSITKStateMachineStateGamePaused];
    TKState *gameStatePayingForContinue                     = [TKState stateWithName:kSITKStateMachineStateGamePayingForContinue];
    TKState *gameStatePopupContinue                         = [TKState stateWithName:kSITKStateMachineStateGamePopupContinue];
    TKState *gameStateProcessingMove                        = [TKState stateWithName:kSITKStateMachineStateGameProcessingMove];
    TKState *gameStateStart                                 = [TKState stateWithName:kSITKStateMachineStateGameStart];
    
    //enters
    [gameStateIdle setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [self didEnterState:SIGameStateIdle];
    }];
    
    [gameStateEnd setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [self didEnterState:SIGameStateEnd];
    }];
    
    [gameStateFallingMonkey setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [self didEnterState:SIGameStateFallingMonkey];
    }];
    
    [gameStateLoading setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        if ([_delegate respondsToSelector:@selector(gameModelStateLoadingExited)]) {
            [_delegate gameModelStateLoadingEntered];
        }
    }];
    [gameStateLoading setDidExitStateBlock:^(TKState *state, TKTransition *transition) {
        if ([_delegate respondsToSelector:@selector(gameModelStateLoadingExited)]) {
            [_delegate gameModelStateLoadingExited];
        }
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
    
    [gameStateStart setDidEnterStateBlock:^(TKState *state, TKTransition *transition) {
        [self didEnterState:SIGameStateStart];
    }];
    
    //add
    [stateMachine addStates:@[ gameStateDefault,gameStateIdle,gameStateEnd,gameStateFallingMonkey,gameStateLoading,gameStatePaused,gameStatePayingForContinue,gameStatePopupContinue,gameStateProcessingMove, gameStateStart]];
    
    // Set the inital state to start... this way we get fresh new data!!!
    stateMachine.initialState               = gameStateDefault;
    
    //transition rules
    TKEvent *gameEventFallingMonkeyStart    = [TKEvent eventWithName:kSITKStateMachineEventGameFallingMonkeyStart
                                             transitioningFromStates:@[gameStateIdle]
                                                             toState:gameStateFallingMonkey];
    
    TKEvent *gameEventMoveEntered           = [TKEvent eventWithName:kSITKStateMachineEventGameMoveEntered
                                             transitioningFromStates:@[gameStateIdle]
                                                             toState:gameStateProcessingMove];
    
    TKEvent *gameEventPause                 = [TKEvent eventWithName:kSITKStateMachineEventGamePause
                                             transitioningFromStates:@[gameStateIdle]
                                                             toState:gameStatePaused];

    TKEvent *gameEventPayForContinue        = [TKEvent eventWithName:kSITKStateMachineEventGamePayForContinue
                                             transitioningFromStates:@[gameStatePopupContinue]
                                                             toState:gameStatePayingForContinue];

    TKEvent *gameEventMenuEnd               = [TKEvent eventWithName:kSITKStateMachineEventGameMenuEnd
                                             transitioningFromStates:@[gameStateIdle,gameStatePaused,gameStatePayingForContinue,gameStatePopupContinue,gameStateProcessingMove,gameStateFallingMonkey,gameStateLoading, gameStateStart, gameStateEnd]
                                                             toState:gameStateEnd];
    TKEvent *gameEventMenuStart             = [TKEvent eventWithName:kSITKStateMachineEventGameMenuStart
                                             transitioningFromStates:@[gameStateLoading,gameStateEnd]
                                                             toState:gameStateStart];
    
    TKEvent *gameEventStartLoad             = [TKEvent eventWithName:kSITKStateMachineEventGameLoad
                                             transitioningFromStates:@[gameStateDefault]
                                                             toState:gameStateLoading];

    TKEvent *gameEventWaitForMove           = [TKEvent eventWithName:kSITKStateMachineEventGameWaitForMove
                                             transitioningFromStates:@[gameStateFallingMonkey, gameStatePaused, gameStateStart, gameStateEnd,gameStatePayingForContinue, gameStateProcessingMove]
                                                             toState:gameStateIdle];
    
    TKEvent *gameEventWrongMoveEntered      = [TKEvent eventWithName:kSITKStateMachineEventGameWrongMoveEntered
                                             transitioningFromStates:@[gameStateProcessingMove]
                                                             toState:gameStatePopupContinue];
    
    
    //add event rules
    [stateMachine addEvents:@[gameEventStartLoad,gameEventFallingMonkeyStart, gameEventMoveEntered, gameEventPause, gameEventPayForContinue, gameEventMenuEnd, gameEventMenuStart, gameEventWaitForMove, gameEventWrongMoveEntered]];
    
    
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
        case SIGameStateStart:
            if ([_delegate respondsToSelector:@selector(gameModelStateStartEntered)]) {
                [_delegate gameModelStateStartEntered];
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
