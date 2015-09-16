//  SIMenuNodeContent.m
//  Swype It
//
//  Created by Andrew Keller on 9/15/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is....
//
// Local Controller Import
#import "SIMenuNodeContent.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports

@implementation SIMenuNodeContent {
    SKSpriteNode        *_backgroundNode;
    
    SKNode              *_userMessageContentNode;
    SKNode              *_bottomContentNode;
    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@\nTitle: %@\nUser Message: %@\nGrid Node: %@\nMenu Node: %@\n",[super description],[SIGame titleForMenuType:_type],_userMessage.text,_gridNode,_menuNode];
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
    _backgroundNode = [SKSpriteNode spriteNodeWithColor:[SKColor mainColor] size:size];
    
}

/**
 Configrue the labels, nodes and what ever else you can
 */
- (void)setupControlsWithSize:(CGSize)size {
    _backgroundNode.anchorPoint = CGPointMake(0.5f, 0.5f);
    
    [self addChild:_backgroundNode];
}

#pragma mark -
#pragma mark - Public Accessors
- (CGSize)size {
    return _backgroundNode.size;
}

- (void)setSize:(CGSize)size {
    _backgroundNode.size = size;
    [self layoutXY];
}

- (void)setGridNode:(HLGridNode *)gridNode {
    if (_bottomContentNode) {
        [_bottomContentNode removeFromParent];
    }
    if (gridNode) {
        _bottomContentNode = gridNode;
        [_backgroundNode addChild:_bottomContentNode];
    }
    _gridNode = gridNode;
    [self layoutXYZ];
}

- (void)setMenuNode:(HLMenuNode *)menuNode {
    if (_bottomContentNode) {
        [_bottomContentNode removeFromParent];
    }
    if (menuNode) {
        menuNode.anchorPoint = CGPointMake(0.5f, 1.0f);
        _bottomContentNode = menuNode;
        [_backgroundNode addChild:_bottomContentNode];
    }
    _menuNode = menuNode;
    [self layoutXYZ];
}

- (void)setUserMessage:(SKLabelNode *)userMessage {
    if (_userMessageContentNode) {
        [_userMessageContentNode removeFromParent];
    }
    if (userMessage) {
        _userMessageContentNode = userMessage;
        [_backgroundNode addChild:_userMessageContentNode];
    }
    _userMessage = userMessage;
    [self layoutXYZ];
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
    if (_userMessageContentNode) {
        _userMessageContentNode.position    = CGPointMake(0.0f, (_backgroundNode.size.height / 4.0f));
    }
    if (_bottomContentNode) {
        _bottomContentNode.position         = CGPointZero;
    }
    _backgroundNode.position                = CGPointZero;
}

/**
 Layout the Z
 */
- (void)layoutZ {

}

#pragma mark -
#pragma mark - Class Functions

@end
