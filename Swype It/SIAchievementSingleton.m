//  SIAchievementManager.m
//  Swype It
//
//  Created by Andrew Keller on 9/7/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is implementation file for the challenge manager for
//              Swype It...
//
// Local Controller Import
#import "SIAchievementSingleton.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIAchievement.h"
// Other Imports

@implementation SIAchievementSingleton {
    SIA *_currentChallenge;
}

#pragma mark - Singleton
+ (instancetype)singleton {
    static SIAchievementSingleton *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[SIAchievementSingleton alloc] init];
    });
    return singleton;
}

#pragma mark - Initializers/Setup
- (instancetype)init {
    self = [super init];
    if (self) {
        [self singletonChallengeSetup];
    }
    return self;
}

- (void)singletonChallengeSetup {
    
}

- (NSDictionary *)readChallengesFromPlist {
    NSDictionary *challenges;
    
    return challenges;
}

- (void)singletonChallengeEnterMove:(SIMove *)move {
    if (_currentChallenge) {
        <#statements#>
    }
}



@end
