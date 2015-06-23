//  Game.m
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//
//  Purpose: Singleton file for a game, there can only be one game played at a time.
//
// Defines
#define NUMBER_OF_MOVES 3
// Local Controller Import
#import "Game.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIConstants.h"
// Other Imports
@interface Game () {
    
}

@end

@implementation Game

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        // Do setup here for new game
    }
    return self;
}

#pragma mark - Class Methods
- (NSNumber *)getLevelScore {
    NSInteger levelScore = 0;
    
    if (self.currentPoints < LEVEL1) {
        levelScore      = LEVEL1;
    } else if (self.currentPoints < LEVEL2) {
        levelScore      = LEVEL2;
    } else if (self.currentPoints < LEVEL3) {
        levelScore      = LEVEL3;
    } else if (self.currentPoints < LEVEL4) {
        levelScore      = LEVEL4;
    } else if (self.currentPoints < LEVEL5) {
        levelScore      = LEVEL5;
    } else if (self.currentPoints < LEVEL6) {
        levelScore      = LEVEL6;
    } else if (self.currentPoints < LEVEL7) {
        levelScore      = LEVEL7;
    } else if (self.currentPoints < LEVEL8) {
        levelScore      = LEVEL8;
    } else if (self.currentPoints < LEVEL9) {
        levelScore      = LEVEL9;
    } else if (self.currentPoints < LEVEL10) {
        levelScore      = LEVEL10;
    } else if (self.currentPoints < LEVEL11) {
        levelScore      = LEVEL11;
    } else if (self.currentPoints < LEVEL12) {
        levelScore      = LEVEL12;
    } else if (self.currentPoints < LEVEL13) {
        levelScore      = LEVEL13;
    } else if (self.currentPoints < LEVEL14) {
        levelScore      = LEVEL14;
    } else if (self.currentPoints < LEVEL15) {
        levelScore      = LEVEL15;
    } else if (self.currentPoints < LEVEL16) {
        levelScore      = LEVEL16;
    } else if (self.currentPoints < LEVEL17) {
        levelScore      = LEVEL17;
    } else if (self.currentPoints < LEVEL18) {
        levelScore      = LEVEL18;
    } else if (self.currentPoints < LEVEL19) {
        levelScore      = LEVEL19;
    } else {
        int tempScore   = (int)self.currentPoints / 100;
        tempScore       = tempScore + 1 - 10;
        levelScore      = tempScore * 100;
    }
    
    return [NSNumber numberWithInteger:levelScore];
}

- (void)setCurrentLevelString {
    NSInteger numberLevel = 0;
    if (self.currentPoints < LEVEL1) {
        numberLevel      = 1;
    } else if (self.currentPoints < LEVEL2) {
        numberLevel      = 2;
    } else if (self.currentPoints < LEVEL3) {
        numberLevel      = 3;
    } else if (self.currentPoints < LEVEL4) {
        numberLevel      = 4;
    } else if (self.currentPoints < LEVEL5) {
        numberLevel      = 5;
    } else if (self.currentPoints < LEVEL6) {
        numberLevel      = 6;
    } else if (self.currentPoints < LEVEL7) {
        numberLevel      = 7;
    } else if (self.currentPoints < LEVEL8) {
        numberLevel      = 8;
    } else if (self.currentPoints < LEVEL9) {
        numberLevel      = 9;
    } else if (self.currentPoints < LEVEL10) {
        numberLevel      = 10;
    } else if (self.currentPoints < LEVEL11) {
        numberLevel      = 11;
    } else if (self.currentPoints < LEVEL12) {
        numberLevel      = 12;
    } else if (self.currentPoints < LEVEL13) {
        numberLevel      = 13;
    } else if (self.currentPoints < LEVEL14) {
        numberLevel      = 14;
    } else if (self.currentPoints < LEVEL15) {
        numberLevel      = 15;
    } else if (self.currentPoints < LEVEL16) {
        numberLevel      = 16;
    } else if (self.currentPoints < LEVEL17) {
        numberLevel      = 17;
    } else if (self.currentPoints < LEVEL18) {
        numberLevel      = 18;
    } else if (self.currentPoints < LEVEL19) {
        numberLevel      = 19;
    } else {
        int tempScore   = (int)self.currentPoints / 100;
        tempScore       = tempScore + 1;
        numberLevel     = tempScore;
    }
    
    self.currentLevel   = [NSString stringWithFormat:@"Level %ld",(long)numberLevel];
}

+ (NSString *)getRandomLevelMoveForGameMode:(NSString *)gameMode {
    NSInteger randomNumber = arc4random_uniform(NUMBER_OF_MOVES);
    NSString *returnString;
    switch (randomNumber) {
        case 0:
            returnString        = kSIMoveCommandTap;
            break;
        case 1:
            returnString        = kSIMoveCommandSwype;
            break;
        default:
            if ([gameMode isEqualToString:kSIGameModeOneHand]) {
                returnString    = kSIMoveCommandShake;
            } else {
                returnString    = kSIMoveCommandPinch;
            }
            break;
    }
    return returnString;
}

@end
