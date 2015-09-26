//
//  SIPopupNode.h
//  Swype It
//
//  Created by Andrew Keller on 8/13/15.
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
#import "SIGame.h"
// Other Imports
@class SIPopupNode;
@protocol SIPopUpNodeDelegate <NSObject>
@optional

/// @name Managing Interaction

/**
 The delegate invoked on interaction
 
 */
- (void)dismissPopup:(SIPopupNode *)popupNode;

@end

@interface SIPopupNode : HLComponentNode <HLGestureTarget>

/// @name Optional Delegate Method

/**
 Delegate methods
 */
@property (nonatomic, weak) id <SIPopUpNodeDelegate> delegate;

/// @name Creating a pop up

/**
 The initalizer method
 */
- (instancetype)initWithSceneSize:(CGSize)size;

/**
 The initalizer method for duck typing label
 */
- (instancetype)initWithSceneSize:(CGSize)size titleNode:(SKNode *)titleNode;

/**
 The convience initalizer method that takes a size for the pop up size
 */
- (instancetype)initWithSceneSize:(CGSize)size
                        popUpSize:(CGSize)popUpSize
                            title:(NSString *)titleText
                   titleFontColor:(SKColor *)titleFontColor
                    titleFontSize:(CGFloat)titleFontSize
                    titleYPadding:(CGFloat)titleYPadding
                  backgroundColor:(SKColor *)backgroundColor
                     cornerRadius:(CGFloat)cornerRadius
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(SKColor *)borderColor;
    
/**
 The convience initalizer method that takes x & y padding for pop up size
 */
- (instancetype)initWithSceneSize:(CGSize)size
                            title:(NSString *)titleText
                   titleFontColor:(SKColor *)titleFontColor
                    titleFontSize:(CGFloat)titleFontSize
                         xPadding:(CGFloat)xPadding
                         yPadding:(CGFloat)yPadding
                  backgroundColor:(SKColor *)backgroundColor
                     cornerRadius:(CGFloat)cornerRadius
                      borderWidth:(CGFloat)borderWidth
                      borderColor:(SKColor *)borderColor;

/**
 The size of the background node.
 */
@property (nonatomic, assign) CGSize backgroundSize;

/**
 The spacing between the top of the background node and the bottom
 */

/**
 The backgroundColor of the spriteNode
 Default value `grayColor`.
 */
@property (nonatomic, strong) SKColor *backgroundColor;

/**
 The corner radius of the button.
 
 Default value is `0.0`.
 
 Note: property will only work for label buttons that don’t have a texture.
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/**
 The boarder width of the button.
 
 Default value is `0.0`.
 Default color is [SKColor blackColor]
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 The color of the border for the button.
 
 Default value is [SKColor blackColor]
 */
@property (nonatomic, strong) SKColor *borderColor;

/**
 Set to button you want displayed
 */
@property (nonatomic, strong) SKNode *bottomNode;

/**
 The distance between the anchor point of the node and the bottom of the popup node
 Default is `8.0f`
 */
@property (nonatomic, assign) CGFloat bottomNodeBottomSpacing;

/**
 The title of the popup
 */
@property (nonatomic, strong) NSString *titleText;

/**
 The font used by the title label.
 */
@property (nonatomic, copy) NSString *titleFontName;

/**
 The font size used by the title label.
 
 The default value is determined by `[SKLabelNode fontSize]` (currently `32` points).
 */
@property (nonatomic, assign) CGFloat titleFontSize;

/// @name Configuring Appearance

/**
 The font color used by the title label.
 
 The defualt value is determined by `[SKLabelNode fontColor]` (currently white).
 */
@property (nonatomic, strong) SKColor *titleFontColor;

/**
 The padding between the top of the _titleLabel and the top of the _background node.
 
 The default value is 16.
 */
@property (nonatomic, assign) CGFloat titleLabelTopPading;

/**
 This allows the title to "ride" on top of the popup content node. This allows the
 height to move dynimcally with the size of the content...
 
 The default value is NO.
 */
@property (nonatomic, assign) BOOL titleAutomaticYPosition;

/**
 This allows for you to insert your own custom node for a title, meaning it could be an image
 or really just about anything you could image. If the titleNode is nil then I will use the 
 titleLabelNode that is private to the class. This can be set at runtime of course...
 */
@property (nonatomic, strong) SKNode *titleContentNode;

/**
 The padding on the left and right edges.
 
 The default value is 16.
 */
@property (nonatomic, assign) CGFloat xPadding;

/**
 The padding on the top and bottom edges.
 
 The default value is 16.
 */
@property (nonatomic, assign) CGFloat yPadding;

/**
 The content that is displayed by the popup
 */
@property (nonatomic, strong) SKNode *popupContentNode;

/**
 The postion of the content node
 
 See `dissmissButtonPosition` for reference.
 Default value `(0.5, 0.5)`.
 */
@property (nonatomic, assign) CGPoint contentPostion;

/**
 The size of the dismiss button.
 
 Default size (diameter) 1/8th width.
 */
@property (nonatomic, assign) CGSize dismissButtonSize;

/**
 The position of the dismiss button within the popup.
 
 Scaled to work like anchor point (0.0-1.0,0.0-1.0)
 
 (0,1)---------(1,1)
 |                 |
 |                 |
 |                 |
 |                 |
 |    (0.5,0.5)    |
 |                 |
 |                 |
 |                 |
 |                 |
 (0,0)---------(1,0)
 
 Default value `(1, 1)`.
 */
@property (nonatomic, assign) CGPoint dismissButtonPosition;

/**
 A nice little runtime bool incase you are not feeling the dismiss button you na mean g
 */
@property (nonatomic, assign) BOOL dismissButtonVisible;

/**Use to launch a node such as a coin*/
- (void)launchNode:(SKSpriteNode *)node;

- (void)layoutXYZ;

@end
