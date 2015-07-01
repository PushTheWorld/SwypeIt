//  Game.h
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
// Framework Import
#import <UIKit/UIKit.h>
// Other Imports

@interface Game : NSObject {
    
}
#pragma mark - Public Objects

#pragma mark - Public Properties
@property (assign, nonatomic) NSInteger          currentPointsRemainingThisRound;
@property (assign, nonatomic) float              moveScore;
@property (assign, nonatomic) float              moveScorePercentRemaining;
@property (assign, nonatomic) float              totalScore;

@property (strong, nonatomic) NSString          *currentMove;
@property (strong, nonatomic) NSString          *currentLevel;
@property (strong, nonatomic) NSString          *gameMode;

#pragma mark - Public Class Methods
- (NSNumber *)getLevelScore;
+ (NSString *)getRandomLevelMoveForGameMode:(NSString *)gameMode;
- (void)setCurrentLevelString;

@end
