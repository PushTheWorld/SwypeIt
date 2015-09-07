//  SIChallengeManager.m
//  Swype It
//
//  Created by Andrew Keller on 9/7/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is implementation file for the challenge manager for
//              Swype It...
//
// Local Controller Import
#import "SIChallengeSingleton.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports

@implementation SIChallengeSingleton

+ (instancetype)singleton {
    static SIChallengeSingleton *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[SIChallengeSingleton alloc] init];
    });
    return singleton;
}

@end
