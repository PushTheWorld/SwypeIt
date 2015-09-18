//  SIPowerUpToolbarNode.m
//  Swype It
//
//  Created by Andrew Keller on 8/17/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: This is....
//
// Local Controller Import
#import "SIPowerUpToolbarNode.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIPowerUp.h"
// Other Imports

#define COIN_TO_ICON_RATIO 0.75
#define TEXT_TO_COIN_RATIO 1.0

enum {
    SINodeZPositionLayerIconShadow = 0,
    SINodeZPositionLayerIcon,
    SINodeZPositionLayerContent,
    SINodeZPositionLayerCount
};

@implementation SIPowerUpToolbarNode{
    CGFloat                          _textHeight;
    
    CGSize                           _coinNodeSize;
    CGSize                           _iconNodeSize;
    
    SIPowerUpType                    _siPowerUp;
    
    SIPowerUpCost                    _powerUpCost;
    
    SKLabelNode                     *_costLabelNode;
    SKSpriteNode                    *_backgroundNode;
    SKSpriteNode                    *_coinNode;
    SKSpriteNode                    *_iconNode;
    
}

- (instancetype)initWithSIPowerUp:(SIPowerUpType)siPowerUp size:(CGSize)size {
    self = [super init];
    if (self) {
        _siPowerUp                  = siPowerUp;
        _size                       = size;
        
        _backgroundNode             = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
        [self addChild:_backgroundNode];
        
        [self initSetup:size];
    }
    return self;
}

- (void)initSetup:(CGSize)size {
    /**Preform initalization pre-view load*/
    [self createConstantsWithSize:size];
    [self createControlsWithSize:size];
    [self setupControlsWithSize:size];
    [self layoutControlsWithSize:size];
}

#pragma mark Node Setup
- (void)createConstantsWithSize:(CGSize)size {
    /**Configure any constants*/
    _powerUpCost                    = [SIPowerUp costForPowerUp:_siPowerUp];
    
    CGFloat shrinkerConstant        = 0.75f;

    _textHeight                     = (size.height * (1 - COIN_TO_ICON_RATIO)) * TEXT_TO_COIN_RATIO * shrinkerConstant;
    
    _coinNodeSize                   = CGSizeMake(size.height * (1 - COIN_TO_ICON_RATIO) * shrinkerConstant, size.height * (1 - COIN_TO_ICON_RATIO) * shrinkerConstant);
    
    _iconNodeSize                   = CGSizeMake(size.height * COIN_TO_ICON_RATIO, size.height * COIN_TO_ICON_RATIO);
}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    _coinNode                       = [SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageCoinSmallBack] size:_coinNodeSize];

    
    _iconNode                       = [SKSpriteNode spriteNodeWithTexture:[SIGame textureForSIPowerUp:_siPowerUp] size:_iconNodeSize];
    
    
    _costLabelNode                  = [SKLabelNode labelNodeWithFontNamed:kSISFFontTextHeavy];
    
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    
    _coinNode.anchorPoint           = CGPointMake(0.0f, 0.0f);
    
    _iconNode.anchorPoint           = CGPointMake(0.5f, 0.5f);

    _costLabelNode.text             = [NSString stringWithFormat:@"%dx",(int)_powerUpCost];
    _costLabelNode.fontSize         = _textHeight;
    _costLabelNode.fontColor        = [SKColor whiteColor];
//    [_costLabelNode setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
//    [_costLabelNode setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    [_costLabelNode setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
    [_costLabelNode setVerticalAlignmentMode:SKLabelVerticalAlignmentModeBottom];

}
- (void)layoutControlsWithSize:(CGSize)size {
    /**Layout those controls*/
    _costLabelNode.position         = CGPointMake(0.0f, -1.0f * (size.height / 2.0f) + VERTICAL_SPACING_4); //CGPointMake(0.0f,(size.height / 2.0f) - (_coinNodeSize.height / 2.0f));
    [_backgroundNode addChild:_costLabelNode];
    
    _coinNode.position              = CGPointMake(0.0f, -1.0f * (size.height / 2.0f) + VERTICAL_SPACING_4);
    [_backgroundNode addChild:_coinNode];
    
    /*Add shadow node*/
    SKNode *shadow                  = [_iconNode shadowWithColor:[SKColor blackColor] blur:0.4f];
    shadow.position                 = CGPointMake(0.0f, VERTICAL_SPACING_4);// CGPointMake(_iconNodeSize.width * 0.05f, _iconNodeSize.height * -0.05f);
    shadow.zPosition                = (CGFloat)SINodeZPositionLayerIconShadow / (CGFloat)SINodeZPositionLayerCount;
    [_backgroundNode addChild:shadow];
    
    _iconNode.position              = CGPointMake(-1.0f, 1.0f);
    _iconNode.zPosition             = (CGFloat)SINodeZPositionLayerIcon / (CGFloat)SINodeZPositionLayerCount;
    [shadow addChild:_iconNode];
}

@end
