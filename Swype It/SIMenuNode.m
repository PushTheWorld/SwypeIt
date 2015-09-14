//  SIMenuNode.m
//  Swype It
//
//  Created by Andrew Keller on 9/14/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is file for the
//
// Local Controller Import
#import "SIMenuNode.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports

@implementation SIMenuNode {
    CGSize               _backButtonSize;
    
    SKNode              *_mainContentNode;
    SKSpriteNode        *_backButtonNode;
    SKSpriteNode        *_backgroundNode;
    
}

- (instancetype)initWithSize:(CGSize)size Node:(SKNode *)mainNode type:(SISceneMenuType)type {
    self = [self initWithSize:size];
    if (self) {
        _mainNode   = mainNode;
        _type       = type;
    }
    return self;
}

#pragma mark - Node Life Cycle
- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        [self initSetup:size];
        _size = size;
    }
    return self;
}
- (void)initSetup:(CGSize)size {
    [self createConstantsWithSize:size];
    [self createControlsWithSize:size];
    [self setupControlsWithSize:size];
}
- (void)createConstantsWithSize:(CGSize)size {
    /**Configure any constants*/
    _backButtonSize                                 = CGSizeMake(_size.width / 8.0f, _size.width / 4.0f);

}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    _backgroundNode                                 = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:_size];
    _backButtonNode                                 = [SKSpriteNode spriteNodeWithTexture:[[SIConstants atlasSceneMenu] textureNamed:kSIAtlasSceneMenuBackButton] size:_backButtonSize];
    _backButtonNode.name                            = kSINodeButtonBack;
    
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    _backgroundNode.anchorPoint                     = CGPointMake(0.5f,0.5f);
    [self addChild:_backgroundNode];

    [_backgroundNode addChild:_backButtonNode];
    
}
- (void)layoutXY {
    /**Layout those controls*/
    if (_mainContentNode) {
        _mainContentNode.position                   = CGPointMake( _size.width / 2.0f, _size.height / 2.0f);
    }
    _backgroundNode.position                        = CGPointMake(_size.width / 2.0f, _size.height / 2.0f);
    _backButtonNode.position                        = CGPointMake((-1.0f * _size.width / 2.0f)  - VERTICAL_SPACING_8, _size.height / 2.0f - (_backButtonSize.height / 2.0f) - VERTICAL_SPACING_8);
}

- (void)setType:(SISceneMenuType)type {
    switch (type) {
        case SISceneMenuTypeStore:
            _backButtonNode.hidden                  = NO;
            break;
        case SISceneMenuTypeStart:
            _backButtonNode.hidden                  = YES;
            break;
        case SISceneMenuTypeHelp:
            _backButtonNode.hidden                  = NO;
            break;
        case SISceneMenuTypeSettings:
            _backButtonNode.hidden                  = NO;
            break;
        default:
            _backButtonNode.hidden                  = NO;
            break;
    }
}

- (void)setMainNode:(SKNode *)mainNode {
    if (_mainContentNode) {
        [_mainContentNode removeFromParent];
    }
    if (mainNode) {
        _mainContentNode                            = mainNode;
        [_backgroundNode addChild:_mainContentNode];
    }
}

- (void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    SKNode  *node    = [self nodeAtPoint:touchLocation];

    if ([node.name isEqualToString:kSINodeButtonBack]) {
        if ([_delegate respondsToSelector:@selector(menuNodeDidTapBackButton:)]) {
            [_delegate menuNodeDidTapBackButton:self];
        }
    }
}

@end
