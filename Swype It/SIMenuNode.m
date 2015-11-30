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
#import "BMGlyphLabel.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports

@implementation SIMenuNode {
    CGSize                                           _backButtonSize;
    
    HLTapGestureTarget                              *_tapGestureTarget;
    
    SKLabelNode                                     *_titleContentNode;
    
    SKSpriteNode                                    *_backgroundNode;

    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@\n Type: %@\nAnimation Duration: %0.2f\n",[super description],[SIGame titleForMenuType:_type],(float)_animationDuration];
}

#pragma mark -
#pragma mark - Node Life Cycle
- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        _size = size;
        _topTitleYPadding                           = VERTICAL_SPACING_8;
        _bottomToolbarYPadding                      = VERTICAL_SPACING_8;
        _animationDuration                          = SCENE_TRANSISTION_DURATION_FAST;
        _bottomCenterNodeYPadding                   = 0.0f;
    }
    return self;
}
- (instancetype)initWithSize:(CGSize)size type:(SISceneMenuType)type {
    self = [self initWithSize:size];
    if (self) {
        _type                                       = type;
        _size                                       = size;
        [self initSetup:size];
    }
    return self;
}
- (void)initSetup:(CGSize)size {
    [self createConstantsWithSize:size];
    [self createControlsWithSize:size];
    [self setupControlsWithSize:size];
    [self layoutXYZAnimation:SIMenuNodeAnimationStaticVisible];
}
- (void)createConstantsWithSize:(CGSize)size {
    /**Configure any constants*/
    _backButtonSize                                 = CGSizeMake(size.width / 8.0f, size.width / 4.0f);

}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    _backgroundNode                                 = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:_size];
    _backgroundNode.name                            = @"b";
    
    _backButtonNode                                 = [SIGameController SIINButtonNamed:kSIAssestMenuButtonBack];
    _backButtonNode.name                            = kSINodeButtonBack;
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    _backgroundNode.anchorPoint                     = CGPointMake(0.5f, 0.5f); //CGPointMake(1.0f,1.0f);
    [self addChild:_backgroundNode];
    
    [_backgroundNode addChild:_backButtonNode];
    [self setType:_type]; //hid the back button node if necessary
    
    _titleContentNode                               = [SIGameController SILabelHeader_x3:[SIGame titleForMenuType:_type]];
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
        _titleContentNode.text = [SIGame titleForMenuType:type];
    }
    [self layoutXYZAnimation:SIMenuNodeAnimationStaticVisible];
}

- (void)setTopNode:(SKNode *)topNode {
    if (_topNode) {
        [_topNode removeFromParent];
    }
    if (topNode) {
        _topNode = topNode;
        [_backgroundNode addChild:_topNode];
    }
    [self layoutXYZAnimation:SIMenuNodeAnimationStaticVisible];
}

- (void)setCenterNode:(SKNode *)centerNode {
    if (_centerNode) {
        [_centerNode removeFromParent];
    }
    if (centerNode) {
        _centerNode = centerNode;
        [_backgroundNode addChild:_centerNode];
    }
    [self layoutXYZAnimation:SIMenuNodeAnimationStaticVisible];
}

- (void)setBottomNode:(SKNode *)bottomNode {
    if (_bottomNode) {
        [_bottomNode removeFromParent];
    }
    if (bottomNode) {
        _bottomNode = bottomNode;
        [_backgroundNode addChild:_bottomNode];
    }
    [self layoutXYZAnimation:SIMenuNodeAnimationStaticVisible];
}
- (void)setFreeNode:(SKSpriteNode *)freeNode {
    if (_freeNode) {
        [_freeNode removeFromParent];
    }
    if (freeNode) {
        _freeNode = freeNode;
        [_backgroundNode addChild:_freeNode];
    }
    [self layoutXYZAnimation:SIMenuNodeAnimationStaticVisible];
}

#pragma mark - 
#pragma mark - Scene Layout
- (void)layoutXYZAnimation:(SIMenuNodeAnimation)animation {
    [self layoutXYAnimation:animation];
    [self layoutZ];
}

- (void)layoutXYAnimation:(SIMenuNodeAnimation)animation {
    /**Layout those controls*/
    CGFloat sceneMidX                               = _size.width /2.0f;
    CGFloat sceneMidY                               = _size.height /2.0f;
    CGPoint sceneMidPoint = CGPointMake(sceneMidX, sceneMidY + [SIGameController SIAdBannerViewHeight]);
    
    CGPoint positionHidden = CGPointZero;
    CGPoint positionVisible = CGPointZero;

    

    if (_topNode) {
        positionVisible                             = CGPointMake(0.0f, (_backgroundNode.size.height / 4.0f));
        positionHidden                              = positionVisible;
        [SIMenuNode animateMenuContentNode:_topNode
                                 animation:animation
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    if (_centerNode) {
        positionVisible                             = CGPointZero;
        if (_menuContentPosition == SIMenuNodeContentPositionBottom) {
            if (_bottomNode) {
                positionVisible = CGPointMake(0.0f, (-1.0f * sceneMidY) + [SIGameController SIToolbarSceneMenuSize:_size].height + _bottomCenterNodeYPadding);
            } else {
                positionVisible = CGPointMake(0.0f, (-1.0f * sceneMidY) + _bottomCenterNodeYPadding);
            }
        }
        positionHidden                              = CGPointZero;
        [SIMenuNode animateMenuContentNode:_centerNode
                                 animation:animation
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    if (_freeNode) {
        positionVisible                             = CGPointZero;
        if (_menuContentPosition == SIMenuNodeContentPositionCenter) {
            if (_bottomNode) {
                positionVisible = CGPointMake(0.0f, (-1.0f * sceneMidY) + [SIGameController SIToolbarSceneMenuSize:_size].height);
            } else {
                positionVisible = CGPointMake(0.0f, -1.0f * sceneMidY);
            }
        }
        positionHidden                              = CGPointZero;
        [SIMenuNode animateMenuContentNode:_freeNode
                                 animation:animation
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    if (_bottomNode) {
        //        _bottomToolbarContentNode.position          = CGPointMake(0.0f, (-1.0f * sceneMidY) + _bottomToolbarYPadding);
        positionHidden                              = CGPointMake(0.0f, (-1.0f * sceneMidY) - [SIGameController SIToolbarSceneMenuSize:_size].height);
        positionVisible                             = CGPointMake(0.0f, (-1.0f * sceneMidY) + _bottomToolbarYPadding);
        [SIMenuNode animateMenuContentNode:_bottomNode
                                 animation:animation
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    if (_titleContentNode) {
        //        _titleContentNode.position                  = CGPointMake(0.0f, sceneMidY - _topTitleYPadding);
        positionHidden                              = CGPointMake(0.0f, sceneMidY + _titleContentNode.frame.size.height + _topTitleYPadding);
        positionVisible                             = CGPointMake(0.0f, sceneMidY - _topTitleYPadding);
        [SIMenuNode animateMenuContentNode:_titleContentNode
                                 animation:animation
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    _backButtonNode.anchorPoint                     = CGPointMake(0.0f,1.0f);
    positionHidden                                  = CGPointMake((-1.0f * sceneMidX) - _backButtonNode.size.width, sceneMidY - (_backButtonNode.size.height / 2.0f) - VERTICAL_SPACING_8);
    positionVisible                                 = CGPointMake((-1.0f * sceneMidX) + (_backButtonNode.size.width / 2.0f) + VERTICAL_SPACING_8, sceneMidY - (_backButtonNode.size.height / 2.0f) - VERTICAL_SPACING_8);
    [SIMenuNode animateMenuContentNode:_backButtonNode
                             animation:animation
                     animationDuration:_animationDuration
                       positionVisible:positionVisible
                        positionHidden:positionHidden];
    
    switch (_type) {
        case SISceneMenuTypeStart:
            [_backButtonNode runAction:[SKAction fadeAlphaTo:0.0f duration:0.0f]];
            break;
        default:
            [_backButtonNode runAction:[SKAction fadeAlphaTo:1.0f duration:0.0f]];
            break;
    }
}

- (void)layoutZ {
    if (_topNode) {
        _topNode.zPosition                  = [SIGameController floatZPositionMenuForContent:SIZPositionMenuContentToolbar];
    }
    
    if (_centerNode) {
        _centerNode.zPosition               = [SIGameController floatZPositionMenuForContent:SIZPositionMenuContentToolbar];
    }
    
    if (_bottomNode) {
        _bottomNode.zPosition               = [SIGameController floatZPositionMenuForContent:SIZPositionMenuContentToolbar];
    }
    
    if (_titleContentNode) {
        _titleContentNode.zPosition         = [SIGameController floatZPositionMenuForContent:SIZPositionMenuContentToolbar];
    }
    
    if (_backButtonNode) {
        _backButtonNode.zPosition           = [SIGameController floatZPositionMenuForContent:SIZPositionMenuContentToolbar];
    }
    
    if (_backgroundNode) {
        _backgroundNode.zPosition           = [SIGameController floatZPositionMenuForContent:SIZPositionMenuBackground];
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
            break;
            
        case SIMenuNodeAnimationStaticHidden:
            node.position                           = positionHidden;
            break;
            
        case SIMenuNodeAnimationGrowIn:
            [node runAction:actionAnimateGrowIn];
            break;
            
        case SIMenuNodeAnimationGrowOut:
            [node runAction:actionAnimateGrowOut];
            break;
            
        case SIMenuNodeAnimationSlideIn:
            [node runAction:actionAnimateSlideIn];
            break;
            
        case SIMenuNodeAnimationSlideOut:
            [node runAction:actionAnimateSlideOut];
            break;
            
        default: //default to visible state if all else fails
            node.position = positionVisible;
            break;
    }
}

@end
