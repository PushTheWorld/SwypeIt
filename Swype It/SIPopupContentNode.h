//  SIPopupContentNode.h
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
#import "BMGlyphLabel.h"
// Category Import
// Support/Data Class Imports
#import "SIGame.h"
// Other Imports

@interface SIPopupContentNode : HLComponentNode

/**
 Initializers
 */
- (instancetype)initWithSize:(CGSize)size;

/**
 The size of the content node
 */
@property (nonatomic, assign) CGSize size;

/**
 A label node that you can change and supply your own and stuff
 */
@property (nonatomic, strong) BMGlyphLabel *labelNode;

/**
 The background content
 */
@property (nonatomic, strong) SKSpriteNode *backgroundImageNode;


@end
