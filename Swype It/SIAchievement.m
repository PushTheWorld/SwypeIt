//  SIAchievement.m
//  Swype It
//
//  Created by Andrew Keller on 9/7/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is....
//
// Local Controller Import
#import "SIAchievement.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports

@implementation SIAchievement

- (instancetype)init {
    self = [super init];
    if (self) {
        _details                    = [[SIAchievementDetail alloc] init];
        _currentLevel               = SIAchievementLevelOne;
        _currentIndexOfMoveSequence = 0;
        _currentAmount              = 0;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        
        _details                            = [aDecoder                             decodeObjectForKey:kEDKeyAchievementDetails];
        _levelDictionary                    = [aDecoder                             decodeObjectForKey:kEDKeyAchievementCurrentLevels];
        _currentSequence                    = (SIAchievementMoveSequence)[aDecoder  decodeIntegerForKey:kEDKeyAchievementCurrentSequence];
        _currentLevel                       = (SIAchievementLevel)[aDecoder         decodeIntegerForKey:kEDKeyAchievementCurrentLevel];
        _currentIndexOfMoveSequence         = [[aDecoder                            decodeObjectForKey:kEDKeyAchievementCurrentIndexOfMoveSequenceCommand] unsignedIntegerValue];
        _currentAmount                      = [aDecoder                             decodeIntForKey:kEDKeyAchievementCurrentAmount];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_details                                                                   forKey:kEDKeyAchievementDetails];
    [aCoder encodeObject:_levelDictionary                                                           forKey:kEDKeyAchievementCurrentLevels];
    [aCoder encodeInteger:_currentSequence                                                          forKey:kEDKeyAchievementCurrentSequence];
    [aCoder encodeInteger:_currentLevel                                                             forKey:kEDKeyAchievementCurrentLevel];
    [aCoder encodeObject:[NSNumber numberWithUnsignedInteger:_currentIndexOfMoveSequence]    forKey:kEDKeyAchievementCurrentIndexOfMoveSequenceCommand];
    [aCoder encodeInt:_currentAmount                                                                forKey:kEDKeyAchievementCurrentAmount];

}



@end
