//  SISegmentControl.h
//  Swype It
//
//  Created by Andrew Keller on 8/24/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: This is....
//
// Local Controller Import
// Framework Import
#import <UIKit/UIKit.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
// Support/Data Class Imports
// Other Imports
#import "HLSpriteKit.h"
//#import "HLComponentNode.h"

@interface SISegmentControl : HLComponentNode 

/// @name Creating a Label Button Node

/**
 Initializes a new segment control with an array of titles.
 */
- (instancetype)initWithSize:(CGSize)size titles:(NSArray *)titles;

/**
 The size of node
 
 Sets or returns the overall size of the button.
 */
@property (nonatomic, assign) CGSize size;

/**
 The selected tab
 
 Sets or returns the selected.
 */
@property (nonatomic, assign) NSUInteger selectedSegment;


@end
