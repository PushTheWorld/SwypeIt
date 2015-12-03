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
#import "SIGameController.h"
#import "SIStoreButtonNode.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "DSMultilineLabelNode.h"
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
    
    NSNumberFormatter                   *_priceFormatter;
    
    DSMultilineLabelNode                *_eyeCatchLabelNode;
    SKLabelNode                         *_priceLabelNode;
    SKLabelNode                         *_titleLabelNode;
    SKLabelNode                         *_valueLabelNode;
    
    SKSpriteNode                        *_backgroundNode;
    SKSpriteNode                        *_eyeCatchNode;
    SKSpriteNode                        *_imageNode;
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
        return 16.0;
    } else if (IS_IPHONE_6) {
        return 20.0;
    } else if (IS_IPHONE_6_PLUS) {
        return 22.0;
    } else {
        return 26.0;
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
    _imageSize                                      = CGSizeMake(size.height - VERTICAL_SPACING_16, size.height - VERTICAL_SPACING_16);
    
    /*Configure the price formatter*/
    _priceFormatter                                 = [[NSNumberFormatter alloc] init];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [_priceFormatter setLocale:[NSLocale currentLocale]];

}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    _backgroundNode                                 = [SKSpriteNode spriteNodeWithColor:[UIColor SIColorShopButton] size:size];
    
    _imageNode                                      = [SKSpriteNode spriteNodeWithImageNamed:[SIIAPUtility imageNameForSIIAPPack:_pack]]; //[SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:[SIIAPUtility imageNameForSIIAPPack:_pack]] size:_imageSize];
    
    if (IS_IPHONE_4) {
        [_imageNode runAction:[SKAction scaleTo:0.7f duration:0.0f]];
    } else if (IS_IPHONE_5) {
        [_imageNode runAction:[SKAction scaleTo:0.9f duration:0.0f]];
    }
    
    if (IS_IPHONE_4) {
        _eyeCatchNode                               = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(_imageNode.size.width, _imageNode.size.width * 0.4f)];

    } else {
        _eyeCatchNode                               = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(_imageNode.size.width, _imageNode.size.width * 0.5f)];
    }
    
    _eyeCatchLabelNode                              = [DSMultilineLabelNode labelNodeWithFontNamed:kSISFFontTextSemibold];
    
    _valueLabelNode                                 = [SKLabelNode labelNodeWithFontNamed:kSISFFontTextRegular];
    
    _titleLabelNode                                 = [SKLabelNode labelNodeWithFontNamed:kSISFFontTextRegular];
    
    _priceLabelNode                                 = [SKLabelNode labelNodeWithFontNamed:kSISFFontTextRegular];
}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    //mmmmmm custom textures
    _backgroundNode.texture                         = [SIGame textureBackgroundColor:[UIColor SIColorShopButton]
                                                                      size:size
                                                              cornerRadius:[SIStoreButtonNode cornerRadius]
                                                               borderWidth:4.0
                                                               borderColor:[UIColor blackColor]];
    _backgroundNode.zPosition                       = (float)SIStoreButtonNodeZPositionLayerBackground / (float)SIStoreButtonNodeZPositionLayerBackground;
    _backgroundNode.anchorPoint                     = CGPointMake(1, 0.5);
    
    _imageNode.zPosition                            = (float)SIStoreButtonNodeZPositionLayerLabel / (float)SIStoreButtonNodeZPositionLayerBackground;
    _imageNode.anchorPoint                          = CGPointMake(0.5, 0.5);
    
    _valueLabelNode.text                            = [NSString stringWithFormat:@"%d IT Coins",[SIIAPUtility numberOfCoinsForSIIAPPack:_pack]];
    _valueLabelNode.fontSize                        = [SIStoreButtonNode fontSizeSmall];
    _valueLabelNode.fontColor                       = [SKColor goldColor];
    _valueLabelNode.verticalAlignmentMode           = SKLabelVerticalAlignmentModeCenter;
    _valueLabelNode.horizontalAlignmentMode         = SKLabelHorizontalAlignmentModeCenter;
    _valueLabelNode.zPosition                       = (float)SIStoreButtonNodeZPositionLayerLabel / (float)SIStoreButtonNodeZPositionLayerBackground;
    
    _titleLabelNode.text                            = [SIIAPUtility buttonTextForSIIAPPack:_pack];
    _titleLabelNode.fontSize                        = [SIStoreButtonNode fontSizeLarge];
    _titleLabelNode.fontColor                       = [SKColor whiteColor];
    _titleLabelNode.verticalAlignmentMode           = SKLabelVerticalAlignmentModeCenter;
    _titleLabelNode.horizontalAlignmentMode         = SKLabelHorizontalAlignmentModeCenter;
    _titleLabelNode.zPosition                       = (float)SIStoreButtonNodeZPositionLayerLabel / (float)SIStoreButtonNodeZPositionLayerBackground;

    _priceLabelNode.text                            = [_priceFormatter stringFromNumber:[SIIAPUtility productPriceForSIIAPPack:_pack]];
    _priceLabelNode.fontSize                        = [SIStoreButtonNode fontSizeSmall];
    _priceLabelNode.fontColor                       = [SKColor goldColor];
    _priceLabelNode.verticalAlignmentMode           = SKLabelVerticalAlignmentModeCenter;
    _priceLabelNode.horizontalAlignmentMode         = SKLabelHorizontalAlignmentModeCenter;
    _priceLabelNode.zPosition                       = (float)SIStoreButtonNodeZPositionLayerLabel / (float)SIStoreButtonNodeZPositionLayerBackground;
    
    switch (_pack) {
        case SIIAPPackMedium:
            _eyeCatchLabelNode.text                 = NSLocalizedString(kSITextIAPMostPopular, nil);
            break;
        case SIIAPPackExtraLarge:
            _eyeCatchLabelNode.text                 = NSLocalizedString(kSITextIAPBestDeal, nil);
            break;
        case SIIAPPackLarge:
        case SIIAPPackSmall:
        default:
            _eyeCatchLabelNode.hidden               = YES;
            _eyeCatchNode.hidden                    = YES;
            break;
    }
    _eyeCatchLabelNode.paragraphWidth               = _imageNode.size.width - VERTICAL_SPACING_8;
    _eyeCatchLabelNode.fontColor                    = [SKColor whiteColor];
    _eyeCatchLabelNode.fontSize                     = [SIGameController SIFontSizeText];
    _eyeCatchLabelNode.verticalAlignmentMode        = SKLabelVerticalAlignmentModeCenter;
    _eyeCatchLabelNode.horizontalAlignmentMode      = SKLabelHorizontalAlignmentModeCenter;
    
    _eyeCatchNode.texture                           = [SIGame textureBackgroundColor:[UIColor redColor]
                                                                        size:CGSizeMake(_imageNode.size.width,_eyeCatchLabelNode.size.height + VERTICAL_SPACING_8)
                                                                cornerRadius:4.0f
                                                                 borderWidth:0.0f
                                                                 borderColor:[SKColor clearColor]];
    _eyeCatchNode.zPosition                         = (float)SIStoreButtonNodeZPositionLayerLabel / (float)SIStoreButtonNodeZPositionLayerBackground;


}
- (void)layoutControlsWithSize:(CGSize)size {
    /**Layout those controls*/
    CGFloat xImage                                  = (-1.0f * _backgroundNode.size.width) + (_imageNode.size.width / 2.0f) + VERTICAL_SPACING_16; //-3.3f * (_backgroundNode.frame.size.width / 4.0f);
    CGFloat xLabels                                 = -1.1f * (_backgroundNode.frame.size.width / 3.0f);
    _backgroundNode.position                        = CGPointMake(size.width / 2.0f, size.height / 2.0f);
    [self addChild:_backgroundNode];
    
    [_backgroundNode addChild:_imageNode];
    [_backgroundNode addChild:_eyeCatchNode];
    [_eyeCatchNode addChild:_eyeCatchLabelNode];
    [_backgroundNode addChild:_valueLabelNode];
    [_backgroundNode addChild:_titleLabelNode];
    [_backgroundNode addChild:_priceLabelNode];

    
    _imageNode.position                             = CGPointMake(xImage, 0.0f);
    
    _valueLabelNode.position                        = CGPointMake(xLabels, 0.0f);

    _titleLabelNode.position                        = CGPointMake(xLabels, _valueLabelNode.frame.size.height + VERTICAL_SPACING_8);

    _priceLabelNode.position                        = CGPointMake(xLabels, -1.0f * (_valueLabelNode.frame.size.height + VERTICAL_SPACING_8));
    
    switch (_pack) {
        case SIIAPPackMedium:
            [_eyeCatchNode runAction:[SKAction rotateByAngle:-M_PI_4/2 duration:0.0f]];
            _eyeCatchNode.position                  = CGPointMake(-1.0f * (_eyeCatchNode.size.width / 2.0f - VERTICAL_SPACING_16), (_eyeCatchNode.size.width / 2.0f));

            break;
        case SIIAPPackExtraLarge:
            [_eyeCatchNode runAction:[SKAction rotateByAngle:M_PI_4/2 duration:0.0f]];
            if (IS_IPHONE_4) {
                _eyeCatchNode.position              = CGPointMake(-1.0f * (_backgroundNode.size.width - (VERTICAL_SPACING_16 * 2)), (_eyeCatchNode.size.width / 2.0f) - VERTICAL_SPACING_16);
            } else {
                _eyeCatchNode.position              = CGPointMake(-1.0f * (_backgroundNode.size.width - VERTICAL_SPACING_16 - VERTICAL_SPACING_4), (_eyeCatchNode.size.width / 2.0f));
            }
            break;
        default:
            break;
    }
    
}

- (CGSize)size {
    return _backgroundNode.size;
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
