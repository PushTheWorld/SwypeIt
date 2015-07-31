//  StartScreenScene.m
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
#import "GameScene.h"
#import "SettingsScene.h"
#import "StartScreenScene.h"
#import "StoreScene.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "SoundManager.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "Game.h"
// Other Imports


@implementation StartScreenScene

-(nonnull instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor sandColor];
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
        label.text = @"Welcome";
        label.fontColor = [SKColor blackColor];
        label.fontSize = 44;
        label.position = CGPointMake(CGRectGetMidX(self.frame),size.height - label.frame.size.height - VERTICAL_SPACING_16);
        [self addChild:label];
        
        SKLabelNode *nameLabel = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
        nameLabel.text = @"Swype It 2.0 Beta";
        nameLabel.fontColor = [SKColor blackColor];
        nameLabel.fontSize = 30;
        nameLabel.position = CGPointMake(CGRectGetMidX(self.frame),label.frame.origin.y - nameLabel.frame.size.height - VERTICAL_SPACING_16);
        [self addChild:nameLabel];
        
        SKSpriteNode *oneHand   = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonGameModeOneHand] size:CGSizeMake((size.width / 2.0f), size.width / 5.0)];
        oneHand.name            = kSINodeButtonOneHand;
        oneHand.position        = CGPointMake(CGRectGetMidX(self.frame),
                                              CGRectGetMidY(self.frame) + (oneHand.frame.size.height/2.0f) + VERTICAL_SPACING_8);
        [self addChild:oneHand];
        
        SKSpriteNode *twoHand = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonGameModeTwoHand] size:CGSizeMake((size.width / 2.0f), size.width / 5.0)];
        twoHand.name            = kSINodeButtonTwoHand;
        twoHand.position        = CGPointMake(CGRectGetMidX(self.frame),
                                              oneHand.frame.origin.y - (oneHand.frame.size.height/2.0f) - VERTICAL_SPACING_8);
        [self addChild:twoHand];
        
        /*Store Button*/
        SKSpriteNode *store     = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonStore] size:CGSizeMake(size.width / 2.0f, size.width / 5.0f)];
        store.position          = CGPointMake(CGRectGetMidX(self.frame),
                                              twoHand.frame.origin.y - (twoHand.frame.size.height/2.0f) - VERTICAL_SPACING_8);
        store.name              = kSINodeButtonStore;
        [self addChild:store];
        
        /*Store Button*/
        SKSpriteNode *settings  = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonSettings] size:CGSizeMake(size.width / 2.0f, size.width / 5.0f)];
        settings.position       = CGPointMake(CGRectGetMidX(self.frame),
                                              store.frame.origin.y - (store.frame.size.height/2.0f) - VERTICAL_SPACING_8);
        settings.name           = kSINodeButtonSettings;
        [self addChild:settings];
        
    }
    
    return self;
}
- (void)didMoveToView:(nonnull SKView *)view {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kSINSUserDefaultSoundIsAllowedBackground]) {
        [[SoundManager sharedManager] playMusic:kSISoundBackgroundMenu looping:YES fadeIn:YES];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch      = [touches anyObject];
    CGPoint location    = [touch locationInNode:self];
    SKNode  *node       = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:kSINodeButtonOneHand]) {
        [self launchGameSceneForGameMode:SIGameModeOneHand];
    } else if ([node.name isEqualToString:kSINodeButtonTwoHand]) {
        [self launchGameSceneForGameMode:SIGameModeTwoHand];
    } else if ([node.name isEqualToString:kSINodeButtonStore]) {
        StoreScene *storeScene = [StoreScene sceneWithSize:self.size];
        storeScene.wasLaunchedFromMainMenu = YES;
        [Game transisitionToSKScene:storeScene toSKView:self.view DoorsOpen:YES pausesIncomingScene:NO pausesOutgoingScene:NO duration:1.0];
        
    } else if ([node.name isEqualToString:kSINodeButtonSettings]) {
        SettingsScene *settingsScene = [SettingsScene sceneWithSize:self.size];
        [Game transisitionToSKScene:settingsScene toSKView:self.view DoorsOpen:YES pausesIncomingScene:NO pausesOutgoingScene:NO duration:1.0];
        
    } else {
        // Do Nothing...
        NSLog(@"Non button area touched");
    }
    
}
- (void)launchGameSceneForGameMode:(SIGameMode)gameMode {
    [[AppSingleton singleton] initAppSingletonWithGameMode:gameMode];
    GameScene *firstScene = [[GameScene alloc] initWithSize:self.size gameMode:gameMode];
    [Game transisitionToSKScene:firstScene toSKView:self.view DoorsOpen:YES pausesIncomingScene:NO pausesOutgoingScene:NO duration:1.0];

}

@end
