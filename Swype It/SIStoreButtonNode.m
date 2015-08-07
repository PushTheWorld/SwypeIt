//  SIStoreButtonNode.m
//  Swype It
//
//  Created by Andrew Keller on 8/4/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: This is the subclass for store buttons
//
// Local Controller Import
#import "SIStoreButtonNode.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIIAPUtility.h"
// Other Imports

enum {
    SIStoreButtonNodeZPositionLayerBackground = 0,
    SIStoreButtonNodeZPositionLayerLabel
};

@implementation SIStoreButtonNode {
    CGSize               _imageSize;
    
    NSNumberFormatter   *_priceFormatter;
    
    SKLabelNode         *_priceLabelNode;
    SKLabelNode         *_titleLabelNode;
    SKLabelNode         *_valueLabelNode;
    
    SKSpriteNode        *_backgroundNode;
    SKSpriteNode        *_imageNode;
}
+ (CGFloat)cornerRadius {
    if (IS_IPHONE_4) {
        return 8.0;
    } else if (IS_IPHONE_5) {
        return 8.0;
    } else if (IS_IPHONE_6) {
        return 8.0;
    } else if (IS_IPHONE_6_PLUS) {
        return 8.0;
    } else {
        return 8.0;
    }
}
+ (CGFloat)fontSizeLarge {
    if (IS_IPHONE_4) {
        return 16.0;
    } else if (IS_IPHONE_5) {
        return 20.0;
    } else if (IS_IPHONE_6) {
        return 20.0;
    } else if (IS_IPHONE_6_PLUS) {
        return 28.0;
    } else {
        return 32.0;
    }
}
+ (CGFloat)fontSizeMedium {
    return [SIStoreButtonNode fontSizeLarge] - 2.0f;
}
+ (CGFloat)fontSizeSmall {
    return [SIStoreButtonNode fontSizeLarge] - 4.0f;
}
- (instancetype)initWithSize:(CGSize)size buttonName:(NSString *)buttonName SIIAPPack:(SIIAPPack)pack {
    self = [super init];
    if (self) {
        /*Set Defaults*/
        _size               = size;
        _text               = buttonName;
        _pack               = pack;
        
        /*Run Initialization*/
        [self initSetup:size];
    }
    return self;
}
#pragma mark - Scene Life Cycle
- (void)initSetup:(CGSize)size {
    /**Preform initalization*/
    [self createConstantsWithSize:size];
    [self createControlsWithSize:size];
    [self setupControlsWithSize:size];
    [self layoutControlsWithSize:size];
}
#pragma mark - Node Setup
- (void)createConstantsWithSize:(CGSize)size {
    /**Configure any constants*/
    _imageSize                              = CGSizeMake(size.height - VERTICAL_SPACING_16, size.height - VERTICAL_SPACING_16);
    
    /*Configure the price formatter*/
    _priceFormatter                         = [[NSNumberFormatter alloc] init];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [_priceFormatter setLocale:[NSLocale currentLocale]];

}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    _backgroundNode                         = [SKSpriteNode spriteNodeWithColor:[UIColor mainColor] size:size];
    
    _imageNode                              = [SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:[SIIAPUtility imageNameForSIIAPPack:_pack]] size:_imageSize];
    
    _valueLabelNode                         = [SKLabelNode labelNodeWithFontNamed:kSIFontUltra];
    
    _titleLabelNode                         = [SKLabelNode labelNodeWithFontNamed:kSIFontUltra];
    
    _priceLabelNode                         = [SKLabelNode labelNodeWithFontNamed:kSIFontUltra];
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    //mmmmmm custom textures
    _backgroundNode.texture                 = [Game textureBackgroundColor:[UIColor mainColor]
                                                                      size:size
                                                              cornerRadius:[SIStoreButtonNode cornerRadius]
                                                               borderWidth:8.0
                                                               borderColor:[UIColor blackColor]];
    _backgroundNode.zPosition               = SIStoreButtonNodeZPositionLayerBackground;
    _backgroundNode.anchorPoint             = CGPointMake(1, 0.5);
    
    _imageNode.zPosition                    = SIStoreButtonNodeZPositionLayerLabel;
    
    _valueLabelNode.text                    = [NSString stringWithFormat:@"%d IT Coins",[Game numberOfCoinsForSIIAPPack:_pack]];
    _valueLabelNode.fontSize                = [SIStoreButtonNode fontSizeSmall];
    _valueLabelNode.fontColor               = [SKColor goldColor];
    _valueLabelNode.verticalAlignmentMode   = SKLabelVerticalAlignmentModeCenter;
    _valueLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _valueLabelNode.zPosition               = SIStoreButtonNodeZPositionLayerLabel;
    
    _titleLabelNode.text                    = [Game buttonTextForSIIAPPack:_pack];
    _titleLabelNode.fontSize                = [SIStoreButtonNode fontSizeLarge];
    _titleLabelNode.fontColor               = [SKColor whiteColor];
    _titleLabelNode.verticalAlignmentMode   = SKLabelVerticalAlignmentModeCenter;
    _titleLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _titleLabelNode.zPosition               = SIStoreButtonNodeZPositionLayerLabel;

    _priceLabelNode.text                    = [_priceFormatter stringFromNumber:[SIIAPUtility productPriceForSIIAPPack:_pack]];
    _priceLabelNode.fontSize                = [SIStoreButtonNode fontSizeSmall];
    _priceLabelNode.fontColor               = [SKColor goldColor];
    _priceLabelNode.verticalAlignmentMode   = SKLabelVerticalAlignmentModeCenter;
    _priceLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _priceLabelNode.zPosition               = SIStoreButtonNodeZPositionLayerLabel;

}
- (void)layoutControlsWithSize:(CGSize)size {
    /**Layout those controls*/
    CGFloat xImage                          = -3.2f * (_backgroundNode.frame.size.width / 4.0f);
    CGFloat xLabels                         = -1.1f * (_backgroundNode.frame.size.width / 3.0f);
    _backgroundNode.position                = CGPointMake(size.width / 2.0f, size.height / 2.0f);
    [self addChild:_backgroundNode];
    
    [_backgroundNode addChild:_imageNode];
    [_backgroundNode addChild:_valueLabelNode];
    [_backgroundNode addChild:_titleLabelNode];
    [_backgroundNode addChild:_priceLabelNode];

    
    _imageNode.position                     = CGPointMake(xImage, 0.0f);

    _valueLabelNode.position                = CGPointMake(xLabels, 0.0f);

    _titleLabelNode.position                = CGPointMake(xLabels, _valueLabelNode.frame.size.height + VERTICAL_SPACING_4);

    _priceLabelNode.position                = CGPointMake(xLabels, -1.0f * (_valueLabelNode.frame.size.height + VERTICAL_SPACING_4));
}

- (void)setAnchorPoint:(CGPoint)anchorPoint
{
    _backgroundNode.anchorPoint = anchorPoint;

}

- (CGPoint)anchorPoint
{
    return _backgroundNode.anchorPoint;
}
@end
