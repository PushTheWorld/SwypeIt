//  SIAchievementNode.m
//  Swype It
//
//  Created by Andrew Keller on 9/14/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.

//
//  Purpose: This is....
//
// Local Controller Import
#import "SIAchievementNode.h"
#import "SIAchievement.h"
#import "SIAchievementDetail.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports

@implementation SIAchievementNode {
    TCProgressBarNode *progressContentNode;
}
#pragma mark -
#pragma mark - Node Life Cycle
- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        [self initSetup:size];
    }
    return self;
}

- (void)initSetup:(CGSize)size {
    [self createConstantsWithSize:size];
    [self createControlsWithSize:size];
    [self setupControlsWithSize:size];
}

/**
 Configure any constants
 */
- (void)createConstantsWithSize:(CGSize)size {
    
}

/**
 Preform all your alloc/init's here
 */
- (void)createControlsWithSize:(CGSize)size {
    
}

/**
 Configrue the labels, nodes and what ever else you can
 */
- (void)setupControlsWithSize:(CGSize)size {
    
}

/**
 Layout both the XY & Z
 */
- (void)layoutXYZ {
    [self layoutXY];
    [self layoutZ];
}

/**
 Layout the XY
 */
- (void)layoutXY {
    
}

/**
 Layout the Z
 */
- (void)layoutZ {
    
}

#pragma mark - 
#pragma mark - Public Accessors


#pragma mark - 
#pragma mark - CLass Functions

@end
