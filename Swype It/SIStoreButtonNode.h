//  SIStoreButtonNode.h
//  Swype It
//
//  Created by Andrew Keller on 8/4/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: Thie is the startign screen for the swype it game
//
// Local Controller Import
// Framework Import
#import <SpriteKit/SpriteKit.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
// Support/Data Class Imports
#import "Game.h"
// Other Imports

@interface SIStoreButtonNode : SKNode

/// @name Creating a Label Button Node

/**
 Initializes a new node with a solid color background.
 */
- (instancetype)initWithSize:(CGSize)size buttonName:(NSString *)buttonName SIIAPPack:(SIIAPPack)pack;

/**
 A HLMenuNodeItem must have property text
 
 This will be used as a button holder
 
 **Layout of the components of the label button will not be performed if the text is
 unset.** During initial configuration, then, the caller may set the text after setting
 all other layout-affecting properties, and layout will only be performed once.
 */
@property (nonatomic, copy) NSString *text;

/**
 A HLMenuNodeItem must have property size
 
 The size of node
 
 Sets or returns the overall size of the button.
 */
@property (nonatomic, assign) CGSize size;

/**
 The image to be used
 */
@property (nonatomic, strong) UIImage *nodeImage;

/**
 The title of the IAP
 */
@property (nonatomic, strong) NSString *title;

/**
 The value of the IAP in game currency
 */
@property (nonatomic, assign) NSInteger value;

/**
 The price of the IAP
 */
@property (nonatomic, assign) CGFloat price;

/**
 The color used by the background node.
 */
@property (nonatomic, strong) SKColor *color;

/**
 The SIIAP being called
 */
@property (nonatomic, assign) SIIAPPack pack;


@end
