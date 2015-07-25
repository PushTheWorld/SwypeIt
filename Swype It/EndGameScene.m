//  EndGameScene.m
//  Swype It
//
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: Thie is the startign screen for the swype it game
//
// Local Controller Import
#import "AppSingleton.h"
#import "EndGameScene.h"
#import "GameScene.h"
#import "StartScreenScene.h"
#import "StoreScene.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "Game.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIConstants.h"
// Other Imports
@interface EndGameScene ()

@property (strong, nonatomic) SKLabelNode *gameScoreLabel;

@end

@implementation EndGameScene
-(nonnull instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor sandColor];
        
        [self addLabels:size];
        [self addButtons:size];
    }
    
    return self;
}
- (void)addLabels:(CGSize)size {
    /*Game Over Label*/
    SKLabelNode *label                  = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    label.text                          = @"Game Over";
    label.fontColor                     = [SKColor blackColor];
    label.fontSize                      = 44;
    label.position                      = CGPointMake(size.width / 2.0f,
                                                      size.height - label.frame.size.height - VERTICAL_SPACING_16);
    [self addChild:label];
    
    self.gameScoreLabel                 = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    self.gameScoreLabel.text            = [NSString stringWithFormat:@"%0.2f", [AppSingleton singleton].currentGame.totalScore];
    self.gameScoreLabel.fontColor       = [SKColor blackColor];
    self.gameScoreLabel.fontSize        = 44;
    self.gameScoreLabel.position        = CGPointMake(size.width / 2.0f,
                                                      label.frame.origin.y - self.gameScoreLabel.frame.size.height - VERTICAL_SPACING_16);
    [self addChild:self.gameScoreLabel];
}
- (void)addButtons:(CGSize)size {
    /*Replay Button*/
    SKSpriteNode *replay        = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonReplay] size:CGSizeMake(size.width / 2.0f, size.width / 4.0f)];
    replay.position             = CGPointMake(-1.0f * (replay.size.width / 2.0f), (size.height / 2.0f) - (replay.frame.size.height/2.0f) - VERTICAL_SPACING_8);
    replay.name                 = kSINodeButtonReplay;
    
    SKAction *moveReplayButton  = [SKAction moveToX:size.width/2 duration:1.0];
    [replay runAction:moveReplayButton];
    [self addChild:replay];
    
    /*Store Button*/
    SKSpriteNode *store         = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonStore] size:CGSizeMake(size.width / 2.0f, size.width / 4.0f)];
    store.position              = CGPointMake(size.width + (store.size.width / 2.0f), replay.frame.origin.y - (replay.frame.size.height/2.0f) - VERTICAL_SPACING_8);
    store.name                  = kSINodeButtonStore;
    
    SKAction *moveStoreButton   = [SKAction moveToX:size.width/2 duration:1.0];
    [store runAction:moveStoreButton];
    [self addChild:store];
    
    SKSpriteNode *menu          = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonMenu] size:CGSizeMake(size.width / 2.0f, size.width / 4.0f)];
    menu.position               = CGPointMake(size.width / 2.0f, 0 - menu.size.height);
    menu.name                   = kSINodeButtonMenu;
    
    SKAction *moveMenuButton   = [SKAction moveToY:store.frame.origin.y - (store.frame.size.height/2.0f) - VERTICAL_SPACING_8 duration:1.0];
    [menu runAction:moveMenuButton];
    [self addChild:menu];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch          = [touches anyObject];
    CGPoint location        = [touch locationInNode:self];
    SKNode *node            = [self nodeAtPoint:location];

    if ([node.name isEqualToString:kSINodeButtonReplay]) {
        GameScene *firstScene = [[GameScene alloc] initWithSize:self.size gameMode:[AppSingleton singleton].currentGame.gameMode];
        [Game transisitionToSKScene:firstScene toSKView:self.view DoorsOpen:NO pausesIncomingScene:NO pausesOutgoingScene:NO duration:1.0];
        
    } else if ([node.name isEqualToString:kSINodeButtonStore]) {
        StoreScene *storeScene = [StoreScene sceneWithSize:self.size];
        [Game transisitionToSKScene:storeScene toSKView:self.view DoorsOpen:YES pausesIncomingScene:NO pausesOutgoingScene:NO duration:1.0];
        
    } else if ([node.name isEqualToString:kSINodeButtonMenu]) {
        StartScreenScene *startScene = [StartScreenScene sceneWithSize:self.size];
        [Game transisitionToSKScene:startScene toSKView:self.view DoorsOpen:NO pausesIncomingScene:NO pausesOutgoingScene:NO duration:1.0];
    }
    
}

@end