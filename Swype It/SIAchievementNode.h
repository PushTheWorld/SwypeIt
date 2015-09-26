//  SIAchievementNode.h
//  Swype It
//
//  Created by Andrew Keller on 9/14/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is....
//
// Local Controller Import
#import "HLComponentNode.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "TCProgressBarNode.h"
// Category Import
// Support/Data Class Imports
#import "SIGame.h"
// Other Imports

@interface SIAchievementNode : HLComponentNode

- (instancetype)initWithSize:(CGSize)size withProgressBarColor:(SKColor *)progressBarBackgroundColor withPercentComplete:(float)percentComplete;

/**
 The size of the whole shubang
 */
@property (nonatomic, assign) CGSize size;
/**
 Setting the percent complete 0.0f-1.0f
    Value protected
 */
@property (nonatomic, assign) CGFloat percentComplete;

@end
