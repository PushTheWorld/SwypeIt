//  SIPowerUpToolbarNode.h
//  Swype It
//
//  Created by Andrew Keller on 8/17/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is a node for popups
//
// Local Controller Import
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "HLSpriteKit.h"
// Category Import
// Support/Data Class Imports
#import "Game.h"
// Other Imports
@interface SIPowerUpToolbarNode : HLComponentNode

/**
 The Ultimate convience method
 */
- (instancetype)initWithSIPowerUp:(SIPowerUpType)siPowerUp size:(CGSize)size;

/**
 Required `size` property
 */
@property (nonatomic, assign)CGSize size;

@end
