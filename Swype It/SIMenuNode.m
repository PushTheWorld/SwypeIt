//  SIMenuNode.m
//  Swype It
//
//  Created by Andrew Keller on 9/14/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is file for the
//
// Local Controller Import
#import "SIGameController.h"
#import "SIMenuNode.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports

@implementation SIMenuNode {
    CGSize                                           _backButtonSize;
    
    HLToolbarNode                                   *_bottomToolbarContentNode;
    
    SKLabelNode                                     *_titleContentNode;
    
    SKNode                                          *_mainContentNode;
    
    SKSpriteNode                                    *_backButtonNode;
    SKSpriteNode                                    *_backgroundNode;

    
}
#pragma mark -
#pragma mark - Node Life Cycle
- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        [self initSetup:size];
        _size = size;
        _topTitleYPadding                           = VERTICAL_SPACING_8;
        _bottomToolbarYPadding                      = VERTICAL_SPACING_8;
        _animationDuration                          = SCENE_TRANSISTION_DURATION_NORMAL;
    }
    return self;
}
- (instancetype)initWithSize:(CGSize)size Node:(SKNode *)mainNode type:(SISceneMenuType)type {
    self = [self initWithSize:size];
    if (self) {
        _mainContentNode                            = mainNode;
        _type                                       = type;
    }
    return self;
}
- (void)initSetup:(CGSize)size {
    [self createConstantsWithSize:size];
    [self createControlsWithSize:size];
    [self setupControlsWithSize:size];
    [self layoutXYAnimation:SIMenuNodeAnimationStaticVisible];
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
    _titleContentNode                               = [SIGameController SILabelHeader:[SIGame titleForMenuType:_type]];
    
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    _backgroundNode.anchorPoint                     = CGPointMake(0.5f,0.5f);
    [self addChild:_backgroundNode];

    [_backgroundNode addChild:_backButtonNode];
    [self setType:_type]; //hid the back button node if necessary
    
    _titleContentNode.verticalAlignmentMode         = SKLabelVerticalAlignmentModeTop;
    _titleContentNode.horizontalAlignmentMode       = SKLabelHorizontalAlignmentModeCenter;
    [_backgroundNode addChild:_titleContentNode];
    
}
#pragma mark -
#pragma mark - Public Accessors
- (void)setSize:(CGSize)size {
    _backgroundNode.size    = size;
    _size                   = size;
    
    [self layoutXYAnimation:SIMenuNodeAnimationStaticVisible];
}
- (void)setType:(SISceneMenuType)type {
    _type = type;
    if (_titleContentNode) {
        _titleContentNode.text                      = [SIGame titleForMenuType:type];
    }
    [self layoutXYAnimation:SIMenuNodeAnimationStaticVisible];
}

- (void)setBottomToolBarNode:(HLToolbarNode *)bottomToolBarNode {
    if (_bottomToolbarContentNode) {
        [_bottomToolbarContentNode removeFromParent];
    }
    if (bottomToolBarNode) {
        _bottomToolbarContentNode                   = bottomToolBarNode;
        _bottomToolbarContentNode.anchorPoint       = CGPointMake(0.5f, 0.0f);
    }
    [self layoutXYAnimation:SIMenuNodeAnimationStaticVisible];
}

- (SKNode *)mainNode {
    if (_mainContentNode) {
        return _mainContentNode;
    } else {
        return nil;
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
    [self layoutXYAnimation:SIMenuNodeAnimationStaticVisible];
}

#pragma mark - 
#pragma mark - Scene Layout
- (void)layoutXYAnimation:(SIMenuNodeAnimation)animation {
    /**Layout those controls*/
    CGFloat sceneMidX                               = _size.width /2.0f;
    CGFloat sceneMidY                               = _size.height /2.0f;
    CGPoint sceneMidPoint = CGPointMake(sceneMidX, sceneMidY);
    
    CGPoint positionHidden = CGPointZero;
    CGPoint positionVisible = CGPointZero;
    
    if (_mainContentNode) {
        //      _mainContentNode.position                   = CGPointMake(0.0f,0.0f);
        positionHidden                              = CGPointZero;
        positionVisible                             = CGPointZero;
        [SIMenuNode animateMenuContentNode:_mainContentNode
                                 animation:animation
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    if (_bottomToolbarContentNode) {
        //        _bottomToolbarContentNode.position          = CGPointMake(0.0f, (-1.0f * sceneMidY) + _bottomToolbarYPadding);
        positionHidden                              = CGPointMake(0.0f, (-1.0f * sceneMidY) - _bottomToolbarContentNode.size.height);
        positionVisible                             = CGPointMake(0.0f, (-1.0f * sceneMidY) + _bottomToolbarYPadding);
        [SIMenuNode animateMenuContentNode:_bottomToolbarContentNode
                                 animation:animation
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    if (_titleContentNode) {
        //        _titleContentNode.position                  = CGPointMake(0.0f, sceneMidY - _topTitleYPadding);
        positionHidden                              = CGPointMake(0.0f, sceneMidY + _titleContentNode.fontSize + _topTitleYPadding);
        positionVisible                             = CGPointMake(0.0f, sceneMidY - _topTitleYPadding);;
        [SIMenuNode animateMenuContentNode:_titleContentNode
                                 animation:animation
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    _backgroundNode.position                        = sceneMidPoint;
    
    positionHidden                                  = CGPointMake((-1.0f * sceneMidX) - _backButtonSize.width, sceneMidY - (_backButtonSize.height / 2.0f) - VERTICAL_SPACING_8);
    positionVisible                                 = CGPointMake((-1.0f * sceneMidX)  - VERTICAL_SPACING_8, sceneMidY - (_backButtonSize.height / 2.0f) - VERTICAL_SPACING_8);
    [SIMenuNode animateMenuContentNode:_backButtonNode
                             animation:animation
                     animationDuration:_animationDuration
                       positionVisible:positionVisible
                        positionHidden:positionHidden];
    
    switch (_type) {
        case SISceneMenuTypeStart:
            _backgroundNode.hidden                  = YES;
            break;
        case SISceneMenuTypeEnd:
            _backButtonNode.hidden                  = YES;
        default:
            _backButtonNode.hidden                  = NO;
            break;
    }
}

#pragma mark -
#pragma mark - Private UI Methods
- (void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch                                  = [touches anyObject];
    CGPoint touchLocation                           = [touch locationInNode:self];
    SKNode  *node                                   = [self nodeAtPoint:touchLocation];

    if ([node.name isEqualToString:kSINodeButtonBack]) {
        if ([_delegate respondsToSelector:@selector(menuNodeDidTapBackButton:)]) {
            [_delegate menuNodeDidTapBackButton:self];
        }
    }
}

#pragma mark -
#pragma mark - Private Class Functions
+ (void)animateMenuContentNode:(SKNode *)node animation:(SIMenuNodeAnimation)animation animationDuration:(float)animationDuration positionVisible:(CGPoint)positionVisible positionHidden:(CGPoint)positionHidden {
    
    SKAction *actionAnimateSlideIn                  = [SKAction sequence:@[[SKAction moveTo:positionHidden duration:0.0f],[SKAction moveTo:positionVisible duration:animationDuration]]];
    SKAction *actionAnimateSlideOut                 = [SKAction sequence:@[[SKAction moveTo:positionVisible duration:0.0f],[SKAction moveTo:positionHidden duration:animationDuration]]];
    
    SKAction *actionAnimateGrowIn                   = [SKAction sequence:@[[SKAction scaleTo:0.0f duration:0.0f], [SKAction scaleTo:1.0f duration:animationDuration]]];
    SKAction *actionAnimateGrowOut                  = [SKAction scaleTo:0.0f duration:animationDuration];
    
    switch (animation) {
        case SIMenuNodeAnimationStaticVisible:
            node.position                           = positionVisible;
            
        case SIMenuNodeAnimationStaticHidden:
            node.position                           = positionHidden;
            
        case SIMenuNodeAnimationGrowIn:
            [node runAction:actionAnimateGrowIn];
            
        case SIMenuNodeAnimationGrowOut:
            [node runAction:actionAnimateGrowOut];
            
        case SIMenuNodeAnimationSlideIn:
            [node runAction:actionAnimateSlideIn];
            
        case SIMenuNodeAnimationSlideOut:
            [node runAction:actionAnimateSlideOut];
            
        default: //default to visible state if all else fails
            node.position = positionVisible;
            break;
    }
}

@end
