//  SIMenuNodeContent.h
//  Swype It
//
//  Created by Andrew Keller on 9/15/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is....
//
// Local Controller Import
#import "HLSpriteKit.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
// Support/Data Class Imports
#import "SIGame.h"
// Other Imports

@interface SIMenuNodeContent : HLComponentNode

- (instancetype)initWithSize:(CGSize)size;

/**
 The size of the end content
 */
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) SISceneMenuType type;

@property (nonatomic, strong) SKNode *userMessage;

@property (nonatomic, strong) HLGridNode *gridNode;

@property (nonatomic, strong) HLMenuNode *menuNode;



@end
