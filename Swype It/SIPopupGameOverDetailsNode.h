//  SIPopupGameOverDetailsNode.h
//  Swype It
//
//  Created by Andrew Keller on 9/26/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose:
//
// Local Controller Import
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "HLSpriteKit.h"
// Category Import
// Support/Data Class Imports
#import "SIGame.h"
// Other Imports


@interface SIPopupGameOverDetailsNode : HLComponentNode


- (instancetype)initWithSize:(CGSize)size;

/**
 Setting this configures the node
 */
@property (nonatomic, strong) SIGame *game;

/**
 The overall size of the node
 */
@property (nonatomic, assign) CGSize size;




@end
