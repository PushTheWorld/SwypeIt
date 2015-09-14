//  SIFallingMonkeyScene.m
//  Swype It
//
//  Created by Andrew Keller on 9/4/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is....
//
// Local Controller Import
#import "SIGameController.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIGame.h"
// Other Imports
#import "SIFallingMonkeyScene.h"

#define FALLING_MONKEY_Z_POSITION_INCREMENTER 0.01
static const uint32_t SIFallingMonkeySceneCategoryZero          = 0x0;      // 00000000000000000000000000000000
static const uint32_t SIFallingMonkeySceneCategoryMonkey        = 0x1;      // 00000000000000000000000000000001
static const uint32_t SIFallingMonkeySceneCategoryUIControl     = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t SIFallingMonkeySceneCategoryEdgeBottom    = 0x1 << 2; // 00000000000000000000000000000100
static const uint32_t SIFallingMonkeySceneCategoryEdgeSide      = 0x1 << 3; // 00000000000000000000000000001000

enum {
    SIFallingMonkeySceneZPositionBackground = 0,
    SIFallingMonkeySceneZPositionTotalScore,
    SIFallingMonkeySceneZPositionFallingMonkey,
    SIFallingMonkeySceneZPositionCount
};

@implementation SIFallingMonkeyScene {
    
    float                                _monkeySpeed;
    
    int                                  _numberOfMonkeysLaunched;
    
    CGFloat                              _fallingMonkeyZPosition;
    
    CGSize                               _sceneSize;
    
    SIAdBannerNode                      *_adContentNode;
    
    SKLabelNode                         *_scoreLabelNode;
    
    SKNode                              *_edgeBottom;
    SKNode                              *_edgeLeft;
    SKNode                              *_edgeRight;
    
    SKSpriteNode                        *_backgroundNode;

}

#pragma mark - Scene Life Cycle
- (nonnull instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /**Do any setup before self.view is loaded*/
        
        /*CRITICAL VARIABLES*/
        _sceneSize                      = size;
        
        /*Run Init Stuff*/
        [self initSetup:size];
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
    [self layoutControlsWithSize:size];
}

- (void)viewSetup:(SKView *)view {
    /**Preform setup post-view load*/
    [self layoutXY];
    [self updatePhysicsEdges];
    
}
#pragma mark -
#pragma mark - Public Accessors
- (void)setAdBannerNode:(SIAdBannerNode *)adBannerNode {
    if (_adContentNode) {
        [_adContentNode removeFromParent];
    }
    if (adBannerNode) {
        _adContentNode                      = adBannerNode;
        _adContentNode.name                 = kSINodeAdBannerNode;
        _adContentNode.position             = CGPointMake(0.0f, 0.0f);
        [self addChild:_adContentNode];
        [_adContentNode hlSetGestureTarget:_adBannerNode];
        [self registerDescendant:_adBannerNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    }
    [self layoutXY];
    [self updatePhysicsEdges];
}
/**
 This will intercept the and override the command going to self
    and will allow us to actually change the color of the background node
 */
- (void)setBackgroundColor:(UIColor * __nonnull)backgroundColor {
    if (_backgroundNode) {
        _backgroundNode.color               = backgroundColor;
    }
}

#pragma mark Scene Setup
- (void)createConstantsWithSize:(CGSize)size {
    /**Configure any constants*/
    _numberOfMonkeysLaunched                = 0;
    _fallingMonkeyZPosition                 = 0.1f;
    _monkeySpeed                            = 1.0f;
    
}

- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    
    /*Create Background Node*/
    _backgroundNode                         = [SKSpriteNode spriteNodeWithColor:[SKColor simplstMainColor] size:_sceneSize];
    
    /*Edges for physics*/
    _edgeBottom                             = [SKNode node];
    _edgeLeft                               = [SKNode node];
    _edgeRight                              = [SKNode node];
        
}

- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    _backgroundNode.anchorPoint                     = CGPointMake(0.0f, 0.0f);
    
    _edgeBottom.physicsBody.categoryBitMask         = SIFallingMonkeySceneCategoryEdgeBottom;
    _edgeBottom.physicsBody.collisionBitMask        = SIFallingMonkeySceneCategoryZero;
    
    _edgeLeft.physicsBody.categoryBitMask           = SIFallingMonkeySceneCategoryEdgeSide;
    _edgeLeft.physicsBody.collisionBitMask          = SIFallingMonkeySceneCategoryEdgeSide;

    _edgeRight.physicsBody.categoryBitMask          = SIFallingMonkeySceneCategoryEdgeSide;
    _edgeRight.physicsBody.collisionBitMask         = SIFallingMonkeySceneCategoryEdgeSide;
    

    
}

- (void)layoutControlsWithSize:(CGSize)size {
    /**Layout those controls*/
    _backgroundNode.position                        = CGPointMake(0.0f, 0.0f);
    [self addChild:_backgroundNode];
    
    [_backgroundNode addChild:_edgeBottom];
    
    [_backgroundNode addChild:_edgeLeft];

    [_backgroundNode addChild:_edgeRight];

}
/**
 
 */
- (void)updatePhysicsEdges {
    if (_backgroundNode == nil) {
        return;
    }
    _edgeBottom.physicsBody                         = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0.0f, 1.0f)
                                                                                   toPoint:CGPointMake(_backgroundNode.size.width, 1.0f)];
    
    _edgeLeft.physicsBody                           = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(-1.0f * ([SIGameController SIFallingMonkeySize].width / 2.0f), 0.0f)
                                                                                   toPoint:CGPointMake(-1.0f * ([SIGameController SIFallingMonkeySize].width / 2.0f), _backgroundNode.size.height)];
    
    _edgeRight.physicsBody                          = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(_backgroundNode.size.width + ([SIGameController SIFallingMonkeySize].width / 2.0f), 0.0f)
                                                                                   toPoint:CGPointMake(_backgroundNode.size.width + ([SIGameController SIFallingMonkeySize].width / 2.0f), _backgroundNode.size.height)];
}

/**
 Everything is controlled by the ad node, if the main view controller cannot supply
    it then it will not show up...
 */
- (void)layoutXY {
    
    _backgroundNode.size                            = CGSizeMake(_sceneSize.width, _sceneSize.height - _adContentNode.size.height);
    _backgroundNode.position                        = CGPointMake(0.0f, _adContentNode.size.height);
    
}

#pragma mark - Public Methods
- (void)sceneFallingMonkeyWillStart {
    _fallingMonkeyZPosition                         = FALLING_MONKEY_Z_POSITION_INCREMENTER;
    _monkeySpeed                                    = 1.0f;
}

- (void)sceneFallingMonkeyWillLaunchMonkey:(SKSpriteNode *)monkey withWorldGravitySpeed:(CGFloat)worldGravitySpeed {
    monkey.physicsBody.categoryBitMask          = SIFallingMonkeySceneCategoryMonkey;
    monkey.physicsBody.contactTestBitMask       = SIFallingMonkeySceneCategoryEdgeBottom;
    monkey.physicsBody.collisionBitMask         = SIFallingMonkeySceneCategoryEdgeSide;
    monkey.zPosition                            = _fallingMonkeyZPosition;
    
    [self addChild:monkey];
    
    /*Update the gravity*/
    self.physicsWorld.gravity                   = CGVectorMake(0.0f, -1.0f * worldGravitySpeed);
    
    /*Apply impulse to the monkey*/
    CGVector monkeyVector                       = CGVectorMake(0, -1.0);
    [monkey.physicsBody applyImpulse:monkeyVector];
    
    /*Increase the zPosition for the next one...*/
    _fallingMonkeyZPosition                     = _fallingMonkeyZPosition + FALLING_MONKEY_Z_POSITION_INCREMENTER;
}

#pragma mark - Custom Touch Methods
-(void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    NSArray  *nodes    = [self nodesAtPoint:touchLocation];
    
    for (SKNode *node in nodes) {
        if ([node.name isEqualToString:kSINodeFallingMonkey]) {
            if ([_sceneDelegate respondsToSelector:@selector(sceneFallingMonkeyWasTappedMonkey:)]) {
                [_sceneDelegate sceneFallingMonkeyWasTappedMonkey:node];
            }
        }
    }
}


#pragma mark - Monkey Methods!
- (void)launchMonkey {
    /*Get Random Number Max... based of width of screen and monkey*/
    CGFloat validMax                                = self.frame.size.width - ([SIGameController SIFallingMonkeySize].width / 2.0f);
    CGFloat xLocation                               = arc4random_uniform(validMax); /*This will be the y axis launch point*/
    while (xLocation < [SIGameController SIFallingMonkeySize].width / 2.0) {
        xLocation                               = arc4random_uniform(validMax);
    }
    CGFloat yLocation                           = self.frame.size.height + [SIGameController SIFallingMonkeySize].height;
    
    /*Make Monkey*/
    
    SKSpriteNode *monkey                        = [SIGameController SISpriteNodeFallingMonkey];
    
    monkey.position                             = CGPointMake(xLocation, yLocation);
    
    
    
    //create the vector
    NSLog(@"Launching Monkey with speed of: %0.1f",_monkeySpeed);
    CGVector monkeyVector                       = CGVectorMake(0, -1.0);
    [monkey.physicsBody applyImpulse:monkeyVector];
    
    /*Call Function again*/
    
    CGFloat randomDelay                         = (float)arc4random_uniform(75) / 100.0f;
    
    _monkeySpeed                                = _monkeySpeed + MONKEY_SPEED_INCREASE;
    
    [self performSelector:@selector(launchMonkey) withObject:nil afterDelay:randomDelay];
    
}
//+ (SKSpriteNode *)newMonkey {
//    SKSpriteNode *monkey                        = [SKSpriteNode spriteNodeWithTexture:[SIGameController sharedMonkeyFace]  size:SIGameScene fallingMonkeySize]];
//    monkey.name                                 = kSINodeFallingMonkey;
//    monkey.physicsBody                          = [SKPhysicsBody bodyWithRectangleOfSize:SIGameScene fallingMonkeySize]];
//    monkey.physicsBody.linearDamping            = 0.0f;
//    monkey.physicsBody.categoryBitMask          = monkeyCategory;
//    monkey.physicsBody.contactTestBitMask       = bottomEdgeCategory;
//    monkey.physicsBody.collisionBitMask         = sideEdgeCategory;
//    monkey.zPosition                            = SIGameNodeZPositionLayerFallingMonkey / SIGameNodeZPositionLayerCount;
//    monkey.userInteractionEnabled               = YES;
//    return monkey;
//}
///**Called when a monkey is tapped...*/
//- (void)monkeyWasTapped:(SKNode *)monkey {
//    /*Remove that monkey*/
//    if ([monkey.name isEqualToString:kSINodeFallingMonkey]) {
//        [monkey removeFromParent];
//        [AppSingleton singleton].currentGame.totalScore = [AppSingleton singleton].currentGame.totalScore + VALUE_OF_MONKEY;
//        
//        [[AppSingleton singleton] setAndCheckDefaults:VALUE_OF_MONKEY];
//        
//        _totalScoreLabel.text                       = [NSString stringWithFormat:@"%0.2f",[AppSingleton singleton].currentGame.totalScore];
//        
//        self.view.backgroundColor                       = [[AppSingleton singleton] newBackgroundColor];
//        
//    }
//}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    SKPhysicsBody *notTheBottomEdge;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        notTheBottomEdge                = contact.bodyA;
    } else {
        notTheBottomEdge                = contact.bodyB;
    }
    
    if (notTheBottomEdge.categoryBitMask == SIFallingMonkeySceneCategoryUIControl) { /*Label*/
        /*Remove the label*/
        SKNode *moveLabelNode = notTheBottomEdge.node;
        
        SKAction *fadeOut               = [SKAction fadeOutWithDuration:0.3];
        SKAction *removeNode            = [SKAction removeFromParent];
        
        SKAction *removeNodeSequence    = [SKAction sequence:@[fadeOut, removeNode]];
        
        [moveLabelNode runAction:removeNodeSequence];
        
    }
    
    if (notTheBottomEdge.categoryBitMask == SIFallingMonkeySceneCategoryMonkey) {
        /*Remove the Monkey*/
        for (SKNode *node in _backgroundNode.children) {
            if ([node.name isEqualToString:kSINodeFallingMonkey]) {
                [node removeFromParent];
            }
        }
        
        /**End The Powerup*/
        /*Cancel any monkeys that */
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(launchMonkey) object:nil];
        
        /*Tell delegate that monkey did colide!*/
        if ([_sceneDelegate respondsToSelector:@selector(sceneFallingMonkeyDidCollideWithBottomEdge)]) {
            [_sceneDelegate sceneFallingMonkeyDidCollideWithBottomEdge];
        }

        self.physicsWorld.gravity       = CGVectorMake(0, -9.8);
        
    }
    
}

@end
