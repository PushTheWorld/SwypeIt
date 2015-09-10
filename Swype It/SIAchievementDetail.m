//
//  SIAchievementDetail.m
//  Swype It
//
//  Created by Andrew Keller on 9/8/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import "SIAchievementDetail.h"

@implementation SIAchievementDetail

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {

        _helpString         = [aDecoder decodeObjectForKey:kEDKeyAchievementDetailsHelpString];
        
        _prefixString       = [aDecoder decodeObjectForKey:kEDKeyAchievementDetailsPrefixString];
        
        _postfixString      = [aDecoder decodeObjectForKey:kEDKeyAchievementDetailsPostfixString];
        
        _type               = (SIAchievementType)[aDecoder decodeIntegerForKey:kEDKeyAchievementDetailsType];
        
        _completed          = [aDecoder decodeBoolForKey:kEDKeyAchievementDetailsCompleted];

        _completionReward   = [aDecoder decodeIntForKey:kEDKeyAchievementDetailsCompletionReward];
        
        _moveSequenceArray  = [aDecoder decodeObjectForKey:kEDKeyAchievementDetailsMoveSequenceArray];
        
        _dictionaryKey      = [aDecoder decodeObjectForKey:kEDKeyAchievementDetailsDictionaryKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:_helpString        forKey:kEDKeyAchievementDetailsHelpString];
    [aCoder encodeObject:_prefixString      forKey:kEDKeyAchievementDetailsPrefixString];
    [aCoder encodeObject:_postfixString     forKey:kEDKeyAchievementDetailsHelpString];
    [aCoder encodeInteger:_type             forKey:kEDKeyAchievementDetailsType];
    [aCoder encodeBool:_completed           forKey:kEDKeyAchievementDetailsCompleted];
    [aCoder encodeInt:_completionReward     forKey:kEDKeyAchievementDetailsCompletionReward];
    [aCoder encodeObject:_moveSequenceArray forKey:kEDKeyAchievementDetailsMoveSequenceArray];
    [aCoder encodeObject:_dictionaryKey     forKey:kEDKeyAchievementDetailsDictionaryKey];
}

@end
