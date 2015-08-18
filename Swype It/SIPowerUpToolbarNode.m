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
// Other Imports

#define COIN_TO_ICON_RATIO 0.75
#define TEXT_TO_COIN_RATIO 0.66

enum {
    SINodeZPositionLayerIcon = 0,
    SINodeZPositionLayerContent,
    SINodeZPositionLayerCount
};

@implementation SIPowerUpToolbarNode{
    CGFloat                          _textHeight;
    
    CGSize                           _coinNodeSize;
    CGSize                           _iconNodeSize;
    
    SIPowerUp                        _siPowerUp;
    
    SIPowerUpCost                    _powerUpCost;
    
    SKLabelNode                     *_costLabelNode;
    SKSpriteNode                    *_backgroundNode;
    SKSpriteNode                    *_coinNode;
    SKSpriteNode                    *_iconNode;
    
}

- (instancetype)initWithSIPowerUp:(SIPowerUp)siPowerUp size:(CGSize)size {
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
    _powerUpCost                    = [Game costForPowerUp:_siPowerUp];

    _textHeight                     = (size.height * (1- COIN_TO_ICON_RATIO)) * TEXT_TO_COIN_RATIO;
    
    _coinNodeSize                   = CGSizeMake(size.height * (1- COIN_TO_ICON_RATIO), size.height * (1- COIN_TO_ICON_RATIO));
    _iconNodeSize                   = CGSizeMake(size.height * COIN_TO_ICON_RATIO, size.height * COIN_TO_ICON_RATIO);
}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    _coinNode                       = [SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageCoinSmallBack] size:_coinNodeSize];
    _coinNode.anchorPoint           = CGPointMake(0.0f, 1.0f);

    
    _iconNode                       = [SKSpriteNode spriteNodeWithTexture:[Game textureForSIPowerUp:_siPowerUp] size:_iconNodeSize];
    _iconNode.anchorPoint           = CGPointMake(0.5f, 0.0f);
    
    _costLabelNode                  = [SKLabelNode labelNodeWithFontNamed:kSIFontUltra];
    [_costLabelNode setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
    [_costLabelNode setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    _costLabelNode.text             = [NSString stringWithFormat:@"%dx",(int)_powerUpCost];
    _costLabelNode.fontSize         = _textHeight;
    _costLabelNode.fontColor        = [SKColor blackColor];
}
- (void)layoutControlsWithSize:(CGSize)size {
    /**Layout those controls*/
    _costLabelNode.position         = CGPointMake(0.0f,(size.height / 2.0f) - (_coinNodeSize.height / 2.0f));
    [_backgroundNode addChild:_costLabelNode];
    
    _coinNode.position              = CGPointMake(0.0f, (size.height / 2.0f));
    [_backgroundNode addChild:_coinNode];
    
    _iconNode.position              = CGPointMake(0.0f, -1.0f * (size.height / 2.0f));
    [_backgroundNode addChild:_iconNode];
}

@end
