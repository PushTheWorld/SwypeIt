//  SIMenuNode.h
//  Swype It
//
//  Created by Andrew Keller on 9/14/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is the header file for the menu nodes
//
// Local Controller Import
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
// Support/Data Class Imports
#import "SIGame.h"
// Other Imports
#import "HLComponentNode.h"

@class SIMenuNode;
@protocol SIMenuNodeDelegate <NSObject>
@optional

/// @name Managing Interaction

/**
 The delegate invoked on back button presses
 
 */
- (void)menuNodeDidTapBackButton:(SIMenuNode *)menuNode;

@end

@interface SIMenuNode : HLComponentNode

/// @name Delegate Method

/**
 Delegate methods
 */
@property (nonatomic, weak) id <SIMenuNodeDelegate> delegate;

/**
 Init the backgrond node with size
 */
- (instancetype)initWithSize:(CGSize)size Node:(SKNode *)mainNode type:(SISceneMenuType)type;

@property (nonatomic, assign) CGSize size;
/**
 Set true when you want the back button to be activated
 */
@property (nonatomic, assign) BOOL backButtonVisible;

/**
 The main node of info to be displayed
 */
@property (nonatomic, strong) SKNode *mainNode;

/**
 The type of menu
 */
@property (nonatomic, assign) SISceneMenuType type;

@end
