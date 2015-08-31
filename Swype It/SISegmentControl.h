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

@protocol SISegmentControlDelegate;

@interface SISegmentControl : HLComponentNode <HLGestureTarget>

/// @name Creating a Label Button Node

/**
 Initializes a new segment control with an array of titles.
 */
- (instancetype)initWithSize:(CGSize)size titles:(NSArray *)titles;

/// @name Setting the Delegate

/**
 The delegate that will respond to menu interaction.
 
 See `SISegmentControlDelegate`.
 */
@property (nonatomic, weak) id <SISegmentControlDelegate> delegate;

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

/**
 The anchorPoint of the node
 
 Sets or returns the anchor point
 Default it `(0.5,0.5)`
 */
@property (nonatomic, assign) CGPoint anchorPoint;

@end

/**
 A delegate for `SISegmentNode`.
 
 The delegate is (currently) concerned mostly with handling user interaction.  It's
 worth noting that the `SISegmentNode` only receives gestures if it is configured as its
 own gesture target (using `[SKNode+HLGestureTarget hlSetGestureTarget]`).
 */
@protocol SISegmentControlDelegate <NSObject>

/**
 Called when the user has tapped on a segment item and the segment node has taken any
 navigation actions that would normally result from the tap.
 */
@required
- (void)segmentControl:(SISegmentControl *)segmentControl didTapNodeItem:(HLLabelButtonNode *)nodeItem itemIndex:(NSUInteger)itemIndex;


@end
