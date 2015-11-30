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
#import <AudioToolbox/AudioToolbox.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIGame.h"
// Other Imports
#import "SIFallingMonkeyScene.h"

#define FALLING_MONKEY_Z_POSITION_INCREMENTER 0.01
static const uint32_t SIFallingMonkeySceneCategoryZero          = 0x0;      // 00000000000000000000000000000000
static const uint32_t SIFallingMonkeySceneCategoryBananaBunch   = 0x1;      // 00000000000000000000000000000001
static const uint32_t SIFallingMonkeySceneCategoryMonkey        = 0x1 << 1; // 00000000000000000000000000000010
//static const uint32_t SIFallingMonkeySceneCategoryBanana        = 0x1 << 2; // 00000000000000000000000000000100
static const uint32_t SIFallingMonkeySceneCategoryUIControl     = 0x1 << 3; // 00000000000000000000000000001000
static const uint32_t SIFallingMonkeySceneCategoryEdgeBottom    = 0x1 << 4; // 00000000000000000000000000010000
static const uint32_t SIFallingMonkeySceneCategoryEdgeSide      = 0x1 << 5; // 00000000000000000000000000100000



@implementation SIFallingMonkeyScene  {
    
    float                                _monkeySpeed;
    
    int                                  _numberOfMonkeysLaunched;
    
    CGFloat                              _fallingMonkeyZPosition;
    
    CGSize                               _sceneSize;
    
    SIAdBannerNode                      *_adContentNode;
    
    SKAction                            *_pulseSequence;
    
    SKLabelNode                         *_scoreLabelNode;
    
    SKNode                              *_edgeBottom;
    SKNode                              *_edgeLeft;
    SKNode                              *_edgeRight;
    
    SKSpriteNode                        *_backgroundNode;
    SKSpriteNode                        *_sandNode;

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
    for (SKNode *node in _backgroundNode.children) {
        if ([node.name isEqualToString:kSINodeFallingMonkey]) {
            [node removeFromParent];
        }
    }
    
    _numberOfMonkeysLaunched                        = 0;
    _fallingMonkeyZPosition                         = [SIGameController floatZPositionFallingMonkeyForContent:SIZPositionFallingMonkeyFallingMonkey];
    _monkeySpeed                                    = MONKEY_SPEED_INITIAL;


//    self.physicsWorld.gravity                       = CGVectorMake(0, 0);
    
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
#pragma mark Scene Setup
- (void)createConstantsWithSize:(CGSize)size {
    /**Configure any constants*/
    _numberOfMonkeysLaunched                        = 0;
    _fallingMonkeyZPosition                         = [SIGameController floatZPositionFallingMonkeyForContent:SIZPositionFallingMonkeyFallingMonkey];
    _monkeySpeed                                    = MONKEY_SPEED_INITIAL;
    
    
    SKAction *grow                                  = [SKAction scaleTo:1.3 duration:FALLING_MONKEY_END_DELAY/4.0f];
    SKAction *shrink                                = [SKAction scaleTo:0.9 duration:FALLING_MONKEY_END_DELAY/4.0f];
    
    _pulseSequence                                  = [SKAction sequence:@[grow,shrink,grow,shrink]];
    
}

- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    
    /*Create Background Node*/
    _backgroundNode                                 = [SKSpriteNode spriteNodeWithColor:[SKColor simplstMainColor] size:_sceneSize];
    
    /*Edges for physics*/
    _edgeBottom                                     = [SKNode node];
    _edgeLeft                                       = [SKNode node];
    _edgeRight                                      = [SKNode node];
    
    // the toal score label
    _scoreLabelNode                                 = [SIGameController SILabelHeader_x3:@"0.00"];
    
    // Make Sand node
    _sandNode                                       = [SKSpriteNode spriteNodeWithImageNamed:kSIAssestFallingMonkeySand];
        
}

- (void)setupControlsWithSize:(CGSize)size {
    self.backgroundColor                            = [SKColor SIColorPrimary];
    
    self.physicsWorld.contactDelegate               = self;
    
    self.physicsWorld.gravity                       = CGVectorMake(0, 0);

    /**Configrue the labels, nodes and what ever else you can*/
    _backgroundNode.anchorPoint                     = CGPointMake(0.0f, 0.0f);
    
    [self updatePhysicsEdges];
    
    //configure dat label
    _scoreLabelNode.horizontalAlignmentMode         = SKLabelHorizontalAlignmentModeCenter;
    _scoreLabelNode.verticalAlignmentMode           = SKLabelVerticalAlignmentModeTop;
    _scoreLabelNode.physicsBody.categoryBitMask     = SIFallingMonkeySceneCategoryUIControl;
    
    _sandNode.anchorPoint                           = CGPointZero;
    _sandNode.position                              = CGPointZero;
    
    
}

- (void)layoutControlsWithSize:(CGSize)size {
    /**Layout those controls*/
    _backgroundNode.position                        = CGPointMake(0.0f, 0.0f);
    [self addChild:_backgroundNode];
    
    [_backgroundNode addChild:_sandNode];
    
    [_backgroundNode addChild:_edgeBottom];
    
    [_backgroundNode addChild:_edgeLeft];

    [_backgroundNode addChild:_edgeRight];
    
    [_backgroundNode addChild:_scoreLabelNode];

}
/**
 
 */
- (void)updatePhysicsEdges {
    if (_backgroundNode == nil) {
        return;
    }
    _edgeBottom.physicsBody                         = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0.0f, 1.0f)
                                                                                   toPoint:CGPointMake(_backgroundNode.size.width, 1.0f)];
    _edgeBottom.physicsBody.categoryBitMask         = SIFallingMonkeySceneCategoryEdgeBottom;
    _edgeBottom.physicsBody.collisionBitMask        = SIFallingMonkeySceneCategoryZero;
    
    _edgeLeft.physicsBody                           = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(-1.0f * ([SIGameController SIFallingMonkeySize].width / 2.0f), 0.0f)
                                                                                   toPoint:CGPointMake(-1.0f * ([SIGameController SIFallingMonkeySize].width / 2.0f), _backgroundNode.size.height)];
    _edgeLeft.physicsBody.categoryBitMask           = SIFallingMonkeySceneCategoryEdgeSide;
    _edgeLeft.physicsBody.collisionBitMask          = SIFallingMonkeySceneCategoryEdgeSide;
    
    _edgeRight.physicsBody                          = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(_backgroundNode.size.width + ([SIGameController SIFallingMonkeySize].width / 2.0f), 0.0f)
                                                                                   toPoint:CGPointMake(_backgroundNode.size.width + ([SIGameController SIFallingMonkeySize].width / 2.0f), _backgroundNode.size.height)];
    _edgeRight.physicsBody.categoryBitMask          = SIFallingMonkeySceneCategoryEdgeSide;
    _edgeRight.physicsBody.collisionBitMask         = SIFallingMonkeySceneCategoryEdgeSide;

}

/**
 Everything is controlled by the ad node, if the main view controller cannot supply
    it then it will not show up...
 */
- (void)layoutXY {
    
    CGSize newBackgroundSize = CGSizeMake(_sceneSize.width, _sceneSize.height - _adContentNode.size.height);
    
    _backgroundNode.size                            = newBackgroundSize;
    _backgroundNode.position                        = CGPointMake(0.0f, _adContentNode.size.height);
    
    if (_scoreLabelNode) {
        _scoreLabelNode.position                    = CGPointMake(newBackgroundSize.width / 2.0f, newBackgroundSize.height - VERTICAL_SPACING_8);
    }
    
}

- (void)layoutZ {
    _backgroundNode.zPosition                       = [SIGameController floatZPositionFallingMonkeyForContent:SIZPositionFallingMonkeyBackground];
    
    if (_scoreLabelNode) {
        _scoreLabelNode.zPosition                   = [SIGameController floatZPositionFallingMonkeyForContent:SIZPositionFallingMonkeyUIContent];
    }
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
        //TODO: Uncomment this line, change back to HLScene
        [_adContentNode hlSetGestureTarget:_adContentNode];
        [self registerDescendant:_adContentNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
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
        _backgroundNode.color                       = backgroundColor;
    }
}

- (void)setTotalScore:(float)totalScore {
    _totalScore                                     = totalScore;
    if (_scoreLabelNode) {
        _scoreLabelNode.text                        = [NSString stringWithFormat:@"%0.2f",_totalScore];
    }
}

#pragma mark -
#pragma mark - Public Methods
- (void)launchMonkey {
    /*Get Random Number Max... based of width of screen and monkey*/
    CGFloat validMax                                = self.frame.size.width - ([SIGameController SIFallingMonkeySize].width / 2.0f);
    CGFloat xLocation                               = arc4random_uniform(validMax); /*This will be the y axis launch point*/
    while (xLocation < [SIGameController SIFallingMonkeySize].width / 2.0) {
        xLocation                                   = arc4random_uniform(validMax);
    }
    CGFloat yLocation                               = self.frame.size.height + [SIGameController SIFallingMonkeySize].height;
    
    /*Make Monkey*/
    SKSpriteNode *monkey                            = [[SIGameController SISpriteNodeFallingMonkey] copy];
    [monkey runAction:[SKAction scaleTo:0.5f duration:0.0f]];
    
    monkey.position                                 = CGPointMake(xLocation, yLocation);
    monkey.physicsBody                              = [SKPhysicsBody bodyWithCircleOfRadius:(monkey.size.width / 2.0f)];// [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(monkey.size.width, monkey.size.height)];
    monkey.physicsBody.linearDamping                = 0.0f;
    monkey.physicsBody.categoryBitMask              = SIFallingMonkeySceneCategoryMonkey;
    monkey.physicsBody.contactTestBitMask           = SIFallingMonkeySceneCategoryEdgeBottom | SIFallingMonkeySceneCategoryBananaBunch;
    monkey.physicsBody.collisionBitMask             = SIFallingMonkeySceneCategoryEdgeSide;
    monkey.physicsBody.dynamic                      = YES;
//    monkey.zPosition                                = _fallingMonkeyZPosition;

    
    
    [self addChild:monkey];
    
    /*Update the gravity*/
    
    /*Apply impulse to the monkey*/
    CGVector monkeyVector                           = CGVectorMake(0, -_monkeySpeed);
    [monkey.physicsBody applyImpulse:monkeyVector];
    
    /*Increase the zPosition for the next one...*/
    _fallingMonkeyZPosition                         = _fallingMonkeyZPosition + FALLING_MONKEY_Z_POSITION_INCREMENTER;
    
    
    /*Call Function again*/
    
    CGFloat randomDelay                             = (100 - (float)arc4random_uniform(75)) / (_monkeySpeed / 2.0f);
    
    _monkeySpeed                                    = _monkeySpeed + MONKEY_SPEED_INCREASE;
    
    [self performSelector:@selector(launchMonkey) withObject:nil afterDelay:randomDelay];
    
}


#pragma mark Custom Touch Methods
//-(void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
//    UITouch *touch                                              = [touches anyObject];
//    CGPoint touchLocation                                       = [touch locationInNode:self];
//    NSArray  *nodes                                             = [self nodesAtPoint:touchLocation];
//    
//    for (SKNode *node in nodes) {
//        if ([node.name isEqualToString:kSINodeFallingMonkey]) {
//            if ([_sceneDelegate respondsToSelector:@selector(sceneFallingMonkeyWasNailed:)]) {
//                [_sceneDelegate sceneFallingMonkeyWasNailed:node];
//            }
//        }
//    }
//}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 1 - Get location of the touch
    UITouch *touch                                              = [touches anyObject];
    CGPoint touchLocation                                       = [touch locationInNode:self];

    // 2 - Set up node to fire
    SKSpriteNode *bananaBunch                                   = [[SIGameController SISpriteNodeBananaBunch] copy];
    [bananaBunch runAction:[SKAction scaleTo:0.5f duration:0.0f]];
    bananaBunch.position                                        = CGPointMake(_sceneSize.width /2.0f, 0.0f);
    bananaBunch.physicsBody                                     = [SKPhysicsBody bodyWithCircleOfRadius:bananaBunch.size.width / 2.0f];
    bananaBunch.physicsBody.dynamic                             = YES;
    bananaBunch.physicsBody.categoryBitMask                     = SIFallingMonkeySceneCategoryBananaBunch;
    bananaBunch.physicsBody.contactTestBitMask                  = SIFallingMonkeySceneCategoryMonkey;
    bananaBunch.physicsBody.collisionBitMask                    = SIFallingMonkeySceneCategoryZero;
    bananaBunch.physicsBody.usesPreciseCollisionDetection       = YES;
    bananaBunch.zPosition                                       = [SIGameController floatZPositionFallingMonkeyForContent:SIZPositionFallingMonkeyBannana];
    
    
    // 3- Determine offset of location to projectile
    CGPoint offset = vectorSubtraction(touchLocation, bananaBunch.position);
    
    // 4 - Bail out if you are shooting down or backwards
//    if (offset.x <= 0) return;
    
    // 5 - OK to add now - we've double checked position
    [_backgroundNode addChild:bananaBunch];
    
    // 6 - Get the direction of where to shoot
    CGPoint direction = vectorNormalize(offset);
    
    // 7 - Make it shoot far enough to be guaranteed off screen
    CGPoint shootAmount = vectorMultiplication(direction, 1000);
    
    // 8 - Add the shoot amount to the current position
    CGPoint realDest = vectorAddition(shootAmount, bananaBunch.position);
    
    // 9 - Create the actions
    float velocity = 420.0/1.2;
    float realMoveDuration = self.size.width / velocity;
    SKAction * actionMove = [SKAction moveTo:realDest duration:realMoveDuration];
    SKAction * actionMoveDone = [SKAction removeFromParent];
    [bananaBunch runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    [SIGame playSound:kSISoundFXSceneWoosh];
}


#pragma mark Monkey Methods!
//- (void)launchMonkeyFromLocation:(CGPoint)location {
//    SKSpriteNode *monkey                            = [SIGameController SISpriteNodeFallingMonkey];
//    
//    monkey.position                                 = location;
//    
//    //create the vector
//    NSLog(@"Launching Monkey with speed of: %0.1f",_monkeySpeed);
//    CGVector monkeyVector                           = CGVectorMake(0, -1.0);
//    [monkey.physicsBody applyImpulse:monkeyVector];
//    
//    /*Call Function again*/
//    
//    CGFloat randomDelay                             = (float)arc4random_uniform(75) / 100.0f;
//    
//    _monkeySpeed                                    = _monkeySpeed + MONKEY_SPEED_INCREASE;
//    
//    [self performSelector:@selector(launchMonkey) withObject:nil afterDelay:randomDelay];
//}


-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }

    if ((firstBody.categoryBitMask & SIFallingMonkeySceneCategoryBananaBunch) != 0 &&
        (secondBody.categoryBitMask & SIFallingMonkeySceneCategoryMonkey) != 0) {
        [self bananaBunch:(SKSpriteNode *)firstBody.node didCollideWithMonkey:(SKSpriteNode *)secondBody.node];

    } else if ((firstBody.categoryBitMask & SIFallingMonkeySceneCategoryMonkey) != 0 &&
               (secondBody.categoryBitMask & SIFallingMonkeySceneCategoryEdgeBottom) != 0) {
        /**End The Powerup*/
        
        /*Pause the screen*/
        self.paused             = YES;

        /*Cancel any monkeys that */
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(launchMonkey) object:nil];
        
        /*Add a red circle to the bottom of the screen*/
        SKSpriteNode *redCircle = [SIGameController SISpriteNodeTarget];
        redCircle.position      = CGPointMake(firstBody.node.position.x, (redCircle.size.height / 2.0f));
        redCircle.name          = kSINodeFallingMonkeyTarget;
        [self addChild:redCircle];
        
        /*Vibrate the phone*/
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        /*Tell delegate that monkey did colide!*/
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(FALLING_MONKEY_END_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([_sceneDelegate respondsToSelector:@selector(sceneFallingMonkeyDidCollideWithBottomEdge)]) {
                [_sceneDelegate sceneFallingMonkeyDidCollideWithBottomEdge];
            }
            /*Remove the monkeys*/
            for (SKNode *node in self.children) {
                if ([node.name isEqualToString:kSINodeFallingMonkey]) {
                    [node removeFromParent];
                } else if ([node.name isEqualToString:kSINodeFallingMonkeyTarget]) {
                    [node removeFromParent];
                }
            }
        });
    }
    
}

- (void)bananaBunch:(SKSpriteNode *)bananaBunch didCollideWithMonkey:(SKSpriteNode *)monkey {
    NSLog(@"Nailed!");
    [bananaBunch removeFromParent];
    [monkey removeFromParent];
    if ([_sceneDelegate respondsToSelector:@selector(sceneFallingMonkeyWasNailed)]) {
        [_sceneDelegate sceneFallingMonkeyWasNailed];
    }
}
#pragma mark -
#pragma mark - Class Methods

@end
