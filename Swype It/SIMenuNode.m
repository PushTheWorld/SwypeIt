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
    
    HLToolbarNode                                   *_bottomToolbarContentNode;
    
    BMGlyphLabel                                    *_titleContentNode;
    
    SKNode                                          *_mainContentNode;
    
//    SKSpriteNode                                    *_backButtonNode;
    SKSpriteNode                                    *_backgroundNode;

    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@\n Type: %@\nAnimation Duration: %0.2f\nMain Node: %@\n",[super description],[SIGame titleForMenuType:_type],(float)_animationDuration,_mainContentNode];
}

#pragma mark -
#pragma mark - Node Life Cycle
- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
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
    _backButtonNode                                 = [SKSpriteNode spriteNodeWithTexture:[[SIConstants atlasSceneMenu] textureNamed:kSIAtlasSceneMenuBackButton] size:_backButtonSize];
    _backButtonNode.name                            = kSINodeButtonBack;
 
//    [_backButtonNode runAction:[SKAction scaleTo:0.5f duration:0.0f]];
    
//    _titleContentNode                               = [SIGameController BMGLabelLongIslandStroked];
//    _titleContentNode.text                          = [SIGame titleForMenuType:_type];
    
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    _backgroundNode.anchorPoint                     = CGPointMake(1.0f,1.0f);
    [self addChild:_backgroundNode];

    
    [_backgroundNode addChild:_backButtonNode];
    [self setType:_type]; //hid the back button node if necessary
    
    _titleContentNode                           = [SIGameController BMGLabelHiraginoKakuGothicText:[SIGame titleForMenuType:_type]];;
    _titleContentNode.verticalAlignment         = BMGlyphVerticalAlignmentTop;
    _titleContentNode.horizontalAlignment       = BMGlyphHorizontalAlignmentCentered;
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
    [self layoutXYZAnimation:SIMenuNodeAnimationStaticVisible];
}

- (void)setBottomToolBarNode:(HLToolbarNode *)bottomToolBarNode {
    if (_bottomToolbarContentNode) {
        [_bottomToolbarContentNode removeFromParent];
    }
    if (bottomToolBarNode) {
        _bottomToolbarContentNode                   = bottomToolBarNode;
        _bottomToolbarContentNode.anchorPoint       = CGPointMake(0.5f, 0.0f);
        [_backgroundNode addChild:_bottomToolbarContentNode];
    }
    [self layoutXYZAnimation:SIMenuNodeAnimationStaticVisible];
    _bottomToolBarNode = bottomToolBarNode;
}


- (void)setMainNode:(SKNode *)mainNode {
    if (_mainContentNode) {
        [_mainContentNode removeFromParent];
    }
    if (mainNode) {
        _mainContentNode                            = mainNode;
        [_backgroundNode addChild:_mainContentNode];
    }
    [self layoutXYZAnimation:SIMenuNodeAnimationStaticVisible];
    _mainNode = mainNode;
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
    
    _backgroundNode.position                        = sceneMidPoint;

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
        positionHidden                              = CGPointMake(0.0f, sceneMidY + _titleContentNode.frame.size.height + _topTitleYPadding);
        positionVisible                             = CGPointMake(0.0f, sceneMidY - _topTitleYPadding);;
        [SIMenuNode animateMenuContentNode:_titleContentNode
                                 animation:animation
                         animationDuration:_animationDuration
                           positionVisible:positionVisible
                            positionHidden:positionHidden];
    }
    
    positionHidden                                  = CGPointMake((-1.0f * sceneMidX) - _backButtonSize.width, sceneMidY - (_backButtonSize.height / 2.0f) - VERTICAL_SPACING_8);
    positionVisible                                 = CGPointMake((-1.0f * sceneMidX) + _backButtonSize.width, sceneMidY - (_backButtonSize.height / 2.0f) - VERTICAL_SPACING_8);
    [SIMenuNode animateMenuContentNode:_backButtonNode
                             animation:animation
                     animationDuration:_animationDuration
                       positionVisible:positionVisible
                        positionHidden:positionHidden];
    
    switch (_type) {
        case SISceneMenuTypeStart:
            [_backButtonNode runAction:[SKAction fadeAlphaTo:0.0f duration:0.0f]];
            break;
        case SISceneMenuTypeEnd:
            [_backButtonNode runAction:[SKAction fadeAlphaTo:0.0f duration:0.0f]];
            break;
        default:
            [_backButtonNode runAction:[SKAction fadeAlphaTo:1.0f duration:0.0f]];
            break;
    }
}
- (void)layoutZ {
    if (_mainContentNode) {
        _mainContentNode.zPosition          = [SIGameController floatZPositionMenuForContent:SIZPositionMenuContent];
    }
    
    if (_bottomToolbarContentNode) {
        _bottomToolbarContentNode.zPosition = [SIGameController floatZPositionMenuForContent:SIZPositionMenuContentToolbar];
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
#pragma mark - Private UI Methods


//-(NSArray *)addsToGestureRecognizers {
//    return @[[[UITapGestureRecognizer alloc] init]];
//}
//
//- (BOOL)addToGesture:(UIGestureRecognizer *)gestureRecognizer firstTouch:(UITouch *)touch isInside:(BOOL *)isInside {
//    if (HLGestureTarget_areEquivalentGestureRecognizers(gestureRecognizer, [[UITapGestureRecognizer alloc] init])) {
//        if ([_backButtonNode containsPoint:[touch locationInNode:_backgroundNode]]) {
//            if ([_delegate respondsToSelector:@selector(menuNodeDidTapBackButton:)]) {
//                [_delegate menuNodeDidTapBackButton:self];
//            }
//
//        }
//        return YES;
//    }
//    return NO;
//}

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
