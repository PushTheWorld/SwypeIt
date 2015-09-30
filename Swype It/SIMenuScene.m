//  SIMenuScene.m
//  Swype It
//
//  Created by Andrew Keller on 9/6/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is the main m file for the start/end screen for swype it
//
// Local Controller Import
#import "SIGameController.h"
#import "SIMenuScene.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
//#import "SoundManager.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports
@implementation SIMenuScene {
    CGSize                                           _backButtonSize;
    CGSize                                           _sceneSize;
    
    HLGridNode                                      *_gridContentNode;
    
    HLToolbarNode                                   *_toolbarContentNode;
    
    SIAdBannerNode                                  *_adContentNode;
    
    SIMenuNode                                      *_currentMenuNode;
    SIMenuNode                                      *_rootSceneMenuNode;
    
//    SIPopupNode                                     *_centerNode;
    
    SKSpriteNode                                    *_backgroundNode;

}
- (nonnull instancetype)init {
    self = [super init];
    if (self) {
        _animationDuration                          = SCENE_TRANSISTION_DURATION_NORMAL;
    }
    return self;
}

#pragma mark - Scene Life Cycle
- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /**Do any setup before self.view is loaded*/
        [self initSetup:size];
        _sceneSize                                  = size;
        self.gestureTargetHitTestMode = HLSceneGestureTargetHitTestModeDeepestThenParent;
//        self.backgroundColor = [SKColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:0.5f];
        

    }
    return self;
}
- (void)didMoveToView:(nonnull SKView *)view {
    [super didMoveToView:view];
    /**Do any setup post self.view creation*/
    [self viewSetup:view];
}
- (void)willMoveFromView:(nonnull SKView *)view {
    /**Do any breakdown prior to the view being unloaded*/
    
    /*Resume move from view*/
    [super willMoveFromView:view];
}
- (void)initSetup:(CGSize)size {
    /**Preform initalization pre-view load*/
    [self createConstantsWithSize:size];
    [self createControlsWithSize:size];
    [self setupControlsWithSize:size];
}
- (void)viewSetup:(SKView *)view {
    /**Preform setup post-view load*/

}
#pragma mark Scene Setup
- (void)createConstantsWithSize:(CGSize)size {
    /**Configure any constants*/
}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    _backgroundNode                                 = [SKSpriteNode spriteNodeWithColor:[SKColor SIColorPrimary] size:_sceneSize];
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    /*Create Background Node*/
    _backgroundNode.anchorPoint                     = CGPointMake(0.0f, 0.0f);
    
    [self addChild:_backgroundNode];

    self.backgroundColor                           = [SKColor SIColorPrimary]; //this sets color for everything muwahah

}

#pragma mark -
#pragma mark - Public Accessors
- (SIAdBannerNode *)adBannerNode {
    if (_adContentNode) {
        return _adContentNode;
    } else {
        return nil;
    }
}
- (void)setAdBannerNode:(SIAdBannerNode *)adBannerNode {
    if (_adContentNode) {
        [_adContentNode removeFromParent];
    }
    if (adBannerNode) {
        _adContentNode                              = adBannerNode;
        _adContentNode.name                         = kSINodeAdBannerNode;
        _adContentNode.position                     = CGPointMake(0.0f, 0.0f);
        [self addChild:_adContentNode];
        [_adContentNode hlSetGestureTarget:_adContentNode];
        [self registerDescendant:_adContentNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];

    }
    [self layoutXYAnimation:SISceneContentAnimationNone];
}

//- (SIPopupNode *)popupNode {
//    if (_centerNode) {
//        return _centerNode;
//    } else {
//        return nil;
//    }
//}

/**
 A popup node to be displayed modally
 */
- (void)setPopupNode:(SIPopupNode *)popupNode {
    if (_popupNode) {
        if ([self modalNodePresented]) {
            [self dismissModalNodeAnimation:HLScenePresentationAnimationFade];
        }
        [_popupNode removeFromParent];
    }
    if (popupNode) {
        _popupNode                           = popupNode;
        [self addChild:_popupNode];
//        [_popupNode hlSetGestureTarget:_popupNode];
//        [self registerDescendant:_popupNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];

    }
    [self layoutZ];
}

#pragma mark -
#pragma mark - Layout Functions
/**Called when ever you may need to layout the end scene*/
#pragma mark Layout
- (void)layoutXYZAnimation:(SISceneContentAnimation)animation {
    [self layoutXYAnimation:animation];
    [self layoutZ];
}

- (void)layoutXYAnimation:(SISceneContentAnimation)animation {
    if (!_backgroundNode) {
        return;
    }
    CGFloat sceneMidX                                   = _sceneSize.width /2.0f;
    CGFloat sceneMidY                                   = _sceneSize.height /2.0f;
    
    _backgroundNode.size                                = CGSizeMake(sceneMidX, sceneMidY - _adContentNode.size.height);
    
    _backgroundNode.position                            = CGPointMake(0.0f, _adContentNode.size.height);
    if (_currentMenuNode) {
        _currentMenuNode.size                           = _backgroundNode.size;
        _currentMenuNode.position                       = CGPointMake(sceneMidX, _adContentNode.size.height + (_backgroundNode.size.height / 2.0f));
    }
    
}

- (void)layoutZ {
    if (_popupNode) {
        [self presentModalNode:_popupNode
                     animation:HLScenePresentationAnimationFade
                  zPositionMin:[SIGameController floatZPositionGameForContent:SIZPositionGameModalMin]
                  zPositionMax:[SIGameController floatZPositionGameForContent:SIZPositionGameModalMax]];
    }
}
#pragma mark -
#pragma mark - Delegate
#pragma mark SIMenuNode
- (void)menuNodeDidTapBackButton:(SIMenuNode *)menuNode {
    [self menuScenePopMenuNode];
}

#pragma mark -
#pragma mark - Public Functions
- (void)pushMenuNode:(SIMenuNode *)menuNode {
    [self showMenuNode:menuNode menuNodeAnimation:SIMenuNodeAnimationPush];
}

- (void)menuScenePopMenuNode {
    [self showMenuNode:_rootSceneMenuNode menuNodeAnimation:SIMenuNodeAnimationPop];
}

- (void)showMenuNode:(SIMenuNode *)menuNode menuNodeAnimation:(SIMenuNodeAnimation)menuNodeAnimation {
    if (menuNode.parent) { //this means that we are re laying out the scene
        [menuNode removeFromParent];
    }
    [self addChild:menuNode];
//    menuNode.animationDuration                      = SCENE_TRANSISTION_DURATION_FAST;
    
    
    SKAction *blockAction = [SKAction runBlock:^{
        if (_currentMenuNode) {
            [_currentMenuNode removeFromParent];
        }
        _currentMenuNode                            = menuNode;
        if ([_sceneDelegate respondsToSelector:@selector(menuSceneDidLoadMenuType:)]) {
            [_sceneDelegate menuSceneDidLoadMenuType:_currentMenuNode.type];
        }
    }];
    
    SKAction *moveAction;
    if (menuNodeAnimation == SIMenuNodeAnimationPush) {
        [SIGame playSound:kSISoundFXSceneWoosh];
        menuNode.position                           = CGPointMake(_currentMenuNode.position.x + menuNode.size.width, _currentMenuNode.position.y);
        [menuNode layoutXYZAnimation:SIMenuNodeAnimationStaticVisible];
        moveAction                                  = [SKAction moveByX:-1.0f * menuNode.size.width y:0.0f duration:menuNode.animationDuration]; //SCENE_TRANSISTION_DURATION_FAST];
        [menuNode runAction:moveAction];
        _rootSceneMenuNode = _currentMenuNode;
        [_currentMenuNode runAction:[SKAction sequence:@[moveAction,blockAction]]];
//        [menuNode hlSetGestureTarget:menuNode];



        
    } else if (menuNodeAnimation == SIMenuNodeAnimationPop) {
        [SIGame playSound:kSISoundFXSceneWoosh];
        menuNode.position                           = CGPointMake(-1.0f * menuNode.size.width, 0.0f);
        [menuNode layoutXYZAnimation:SIMenuNodeAnimationStaticVisible];
        moveAction                                  = [SKAction moveByX:menuNode.size.width y:0.0f duration:menuNode.animationDuration]; //SCENE_TRANSISTION_DURATION_FAST];
        [menuNode runAction:moveAction];
        [_currentMenuNode runAction:[SKAction sequence:@[moveAction,blockAction]]];

        
    } else {
        menuNode.position = CGPointZero;
        if (_currentMenuNode) {
            [_currentMenuNode removeFromParent];
        }
        _currentMenuNode                            = menuNode;
        if ([_sceneDelegate respondsToSelector:@selector(menuSceneDidLoadMenuType:)]) {
            [_sceneDelegate menuSceneDidLoadMenuType:_currentMenuNode.type];
        }
        [_currentMenuNode layoutXYZAnimation:menuNodeAnimation];
    }

    _currentMenuNode.delegate                       = self;
    [menuNode.backButtonNode hlSetGestureTarget:[HLTapGestureTarget tapGestureTargetWithHandleGestureBlock:^(UIGestureRecognizer *gr) {
        [self menuScenePopMenuNode];
    }]];
    [self registerDescendant:menuNode.backButtonNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    
    if (menuNode.centerNode) {
        if ([menuNode.centerNode isKindOfClass:[HLMenuNode class]]) {
            HLMenuNode *newMenuNode = (HLMenuNode *)menuNode.centerNode;
            [newMenuNode hlSetGestureTarget:newMenuNode];
            [self registerDescendant:newMenuNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
        } else if ([menuNode.centerNode isKindOfClass:[HLGridNode class]]){
            HLGridNode *newGridNode = (HLGridNode *)menuNode.centerNode;
            [newGridNode hlSetGestureTarget:newGridNode];
            [self registerDescendant:newGridNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
        }
    }
    if (menuNode.bottomNode) {
        if ([menuNode.bottomNode isKindOfClass:[HLToolbarNode class]]) {
            HLToolbarNode *newToolbarNode = (HLToolbarNode *)menuNode.bottomNode;
            [newToolbarNode hlSetGestureTarget:newToolbarNode];
            [self registerDescendant:newToolbarNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
        }
    }
    if (menuNode.shopNode) {
        [menuNode.shopNode hlSetGestureTarget:[HLTapGestureTarget tapGestureTargetWithHandleGestureBlock:^(UIGestureRecognizer *jerry) {
            if ([_sceneDelegate respondsToSelector:@selector(menuSceneShopNodeWasTapped)]) {
                [_sceneDelegate menuSceneShopNodeWasTapped];
            }
            
        }]];
        [self registerDescendant:menuNode.shopNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];

    }
}

- (void)showMenuNode:(SIMenuNode *)menuNode menuNodeAnimation:(SIMenuNodeAnimation)menuNodeAnimation animationDuration:(float)animationDuration {
    _animationDuration = animationDuration;
    [self showMenuNode:menuNode menuNodeAnimation:menuNodeAnimation];
}

-(void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch                                              = [touches anyObject];
    CGPoint touchLocation                                       = [touch locationInNode:self];
    SKNode *node                                                = [self nodeAtPoint:touchLocation];
    
    if ([node.name isEqualToString:@"b"]) {
        if ([_sceneDelegate respondsToSelector:@selector(menuSceneWasTappedToStart)]) {
            [_sceneDelegate menuSceneWasTappedToStart];
        }
    }
    
}


@end
