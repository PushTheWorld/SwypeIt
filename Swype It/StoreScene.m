//  StoreScene.m
//  Swype It
//
//  Created by Andrew Keller on 7/21/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: Thie is the startign screen for the swype it game
//
// Local Controller Import
#import "EndGameScene.h"
#import "SIGameController.h"
#import "SIPopupNode.h"
#import "SIStoreButtonNode.h"
#import "StartScreenScene.h"
#import "StoreScene.h"
// Framework Import
#import <StoreKit/StoreKit.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "BMGlyphFont.h"
#import "BMGlyphLabel.h"
#import "MKStoreKit.h"
#import "SoundManager.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIIAPUtility.h"
// Other Imports

#define MAX_NUMBER_OF_ATTEMPTS 20
enum {
    SIStoreSceneZPositionLayerBackground = 0,
    SIStoreSceneZPositionLayerText,
    SIStoreSceneZPositionLayerButtons,
    SIStoreSceneZPositionLayerPopup,
    SIStoreSceneZPositionLayerPopupContent,
    SIStoreSceneZPositionLayerPopupCoin,
    SIStoreSceneZPositionLayerCount
};
enum {
    SIStoreSceneZPositionPopupBackground = 0,
    SIStoreSceneZPositionPopupContent,
    SIStoreSceneZPositionPopupCount
};
@interface StoreScene () <HLMenuNodeDelegate, SIPopUpNodeDelegate> {

}

@property (strong, nonatomic) HLMenuNode    *menuNode;
@property (strong, nonatomic) SKLabelNode   *itCoinsLabel;
@property (strong, nonatomic) SKLabelNode   *titleLabel;

@end

@implementation StoreScene {
    BMGlyphLabel                    *_prizeAmountLabelNode;
    
    BOOL                             _isPurchaseInProgress;
    BOOL                             _shouldRespondToTap;
    BOOL                             _willAwardPrize;
    
    CGFloat                          _buttonAnimationDuration;
    CGFloat                          _buttonSpacing;
    
    CGSize                           _coinSize;

    NSArray                         *_products;
    
    SIPopupNode                     *_popupNode;
}

#pragma mark - Scene Life Cycle
- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /**Do any setup before self.view is loaded*/
        _willAwardPrize = NO;
        [self initSetup:size];
    }
    return self;
}
- (instancetype)initWithSize:(CGSize)size willAwardPrize:(BOOL)willAwardPrize {
    if (self = [super initWithSize:size]) {
        /**Do any setup before self.view is loaded*/
        _willAwardPrize = willAwardPrize;
        [self initSetup:size];
    }
    return self;
}

- (void)didMoveToView:(nonnull SKView *)view {
    [super didMoveToView:view];
    /**Do any setup post self.view creation*/
    [self viewSetup:view];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSINotificationAdBannerHide object:nil];
    
    if (_willAwardPrize) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self createPopup:view.frame.size];
            [self presentModalNode:_popupNode
                         animation:HLScenePresentationAnimationFade
                      zPositionMin:(float)SIStoreSceneZPositionLayerPopup / (float)SIStoreSceneZPositionLayerCount
                      zPositionMax:(float)SIStoreSceneZPositionLayerPopupContent / (float)SIStoreSceneZPositionLayerCount];
        });
    }
}
- (void)willMoveFromView:(nonnull SKView *)view {
    /**Do any breakdown prior to the view being unloaded*/
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    /*Resume move from view*/
    [super willMoveFromView:view];
}
- (void)initSetup:(CGSize)size {
    /**Preform initalization pre-view load*/
    [self createConstantsWithSize:size];
    [self createControlsWithSize:size];
    [self setupControlsWithSize:size];
    [self layoutControlsWithSize:size];
    [self registerForNotifications];
}
- (void)viewSetup:(SKView *)view {
    /**Preform setup post-view load*/
    self.backgroundColor            = [SKColor sandColor];
    _shouldRespondToTap             = YES;
}
#pragma mark Scene Setup
- (void)createConstantsWithSize:(CGSize)size {
    /**Configure any constants*/
    _isPurchaseInProgress           = NO;
    
    _buttonAnimationDuration        = 0.5;
    _buttonSpacing                  = VERTICAL_SPACING_16;
    
}
- (void)createControlsWithSize:(CGSize)size {
    /**Preform all your alloc/init's here*/
    _titleLabel                     = [SIGameController SI_sharedLabelHeader_x3:@"Store"];
    
    _itCoinsLabel                   = [SIGameController SI_sharedLabelParagraph:[NSString stringWithFormat:@"Bank: %d IT Coins",[[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue]]];

    /*Menu Node*/
    _menuNode                       = [[HLMenuNode alloc] init];

}
- (void)setupControlsWithSize:(CGSize)size {
    /**Configrue the labels, nodes and what ever else you can*/
    /*Menu Node*/
    _menuNode.delegate                              = self;
    _menuNode.itemAnimation                         = HLMenuNodeAnimationSlideLeft;
    _menuNode.itemAnimationDuration                 = _buttonAnimationDuration;
    _menuNode.itemButtonPrototype                   = [[SIStoreButtonNode alloc] initWithSize:[SIGameController buttonSize:size] buttonName:SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackSmall] SIIAPPack:SIIAPPackSmall];
    _menuNode.backItemButtonPrototype               = [SIGameController SI_sharedMenuButtonPrototypeBack:[SIGameController buttonSize:size]];
    _menuNode.itemSeparatorSize                     = _buttonSpacing;
    _menuNode.anchorPoint                           = CGPointMake(0.5f, 0.0f);
    _menuNode.zPosition                             = (float)SIStoreSceneZPositionLayerButtons / (float)SIStoreSceneZPositionLayerCount;

    
}
- (void)layoutControlsWithSize:(CGSize)size {
    /**Layout those controls*/
    /*Title Label*/
    _titleLabel.position                            = CGPointMake((size.width / 2.0f),
                                                                  size.height - _titleLabel.frame.size.height - VERTICAL_SPACING_8);
    [self addChild:_titleLabel];
    
    _itCoinsLabel.position                          = CGPointMake((size.width / 2.0f),
                                                                  _titleLabel.frame.origin.y - (_titleLabel.frame.size.height / 2.0f) - (_itCoinsLabel.frame.size.height / 2.0f) );
    [self addChild:_itCoinsLabel];
    
    /*Menu Node*/
    _menuNode.position  = CGPointMake(size.width / 2.0f, VERTICAL_SPACING_16);
    [self addChild:_menuNode];
    [_menuNode hlSetGestureTarget:_menuNode];
    [self registerDescendant:_menuNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    [self menuCreate:size];
    
}
- (void)registerForNotifications {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(packPurchaseRequest:) name:kSINotificationPackPurchaseRequest object:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Purchased/Subscribed to product with id: %@", [note object]);
                                                      _isPurchaseInProgress = NO;
                                                      [self changeCoinValue];
                                                      [self purchaseSuccess:YES titleText:@"Purchased!" infoText:@"Swype On!" duration:2.0f];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchaseFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Failed [kMKStoreKitProductPurchaseFailedNotification] with error: %@", [note object]);
                                                      _isPurchaseInProgress = NO;
                                                      [self purchaseSuccess:NO titleText:@"Canceled" infoText:@"" duration:0.5f];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchaseDeferredNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Failed [kMKStoreKitProductPurchaseDeferredNotification] with error: %@", [note object]);
                                                      _isPurchaseInProgress = NO;
                                                      [self purchaseSuccess:NO titleText:@"Failed." infoText:@"Parental Controls On" duration:1.0f];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoredPurchasesNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Restored Purchases");
                                                      _isPurchaseInProgress = NO;
                                                      [self changeCoinValue];
                                                      [self purchaseSuccess:YES titleText:@"Restored!" infoText:@"" duration:2.0f];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoringPurchasesFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Failed restoring purchases with error: %@", [note object]);
                                                      _isPurchaseInProgress = NO;
                                                      [self purchaseSuccess:NO titleText:@"Failed." infoText:@"Try again later..." duration:1.0f];
                                                      
                                                  }];
}

- (void)menuCreate:(CGSize)size {
    HLMenu *menu                = [[HLMenu alloc] init];
    
    /*Add the regular buttons*/
    HLMenuItem *item1           = [HLMenuItem menuItemWithText:SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackExtraLarge]];
    item1.buttonPrototype       = [[SIStoreButtonNode alloc] initWithSize:[SIGameController buttonSize:size] buttonName:SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackExtraLarge] SIIAPPack:SIIAPPackExtraLarge];

    HLMenuItem *item2           = [HLMenuItem menuItemWithText:SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackLarge]];
    item2.buttonPrototype       = [[SIStoreButtonNode alloc] initWithSize:[SIGameController buttonSize:size] buttonName:SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackLarge] SIIAPPack:SIIAPPackLarge];
    
    HLMenuItem *item3           = [HLMenuItem menuItemWithText:SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackMedium]];
    item3.buttonPrototype       = [[SIStoreButtonNode alloc] initWithSize:[SIGameController buttonSize:size] buttonName:SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackMedium] SIIAPPack:SIIAPPackMedium];

    HLMenuItem *item4           = [HLMenuItem menuItemWithText:SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackSmall]];
    item4.buttonPrototype       = [[SIStoreButtonNode alloc] initWithSize:[SIGameController buttonSize:size] buttonName:SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackSmall] SIIAPPack:SIIAPPackSmall];

    [menu addItem:item4];
    [menu addItem:item3];
    [menu addItem:item2];
    [menu addItem:item1];
    
    
    /*Add the Back Button... Need to change the prototype*/
    HLMenuItem *resumeItem      = [HLMenuItem menuItemWithText:kSIMenuTextBack];
    resumeItem.buttonPrototype  = [SIGameController SI_sharedMenuButtonPrototypeBack:[SIGameController buttonSize:size]];
    [menu addItem:resumeItem];
    
    [_menuNode setMenu:menu animation:HLMenuNodeAnimationNone];
//    [_menuNode redisplayMenuAnimation:HLMenuNodeAnimationNone];
}
#pragma mark - HLMenuNodeDelegate
- (void)menuNode:(HLMenuNode *)menuNode willDisplayButton:(SKNode *)buttonNode forMenuItem:(HLMenuItem *)menuItem itemIndex:(NSUInteger)itemIndex {
    SIStoreButtonNode *button = (SIStoreButtonNode *)buttonNode;
    button.size                 = [SIGameController buttonSize:self.frame.size];
}
- (void)menuNode:(HLMenuNode *)menuNode didTapMenuItem:(HLMenuItem *)menuItem itemIndex:(NSUInteger)itemIndex {
    if ([menuItem.text isEqualToString:SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackSmall]]) {
        [self requestPurchaseForPack:SIIAPPackSmall];
    } else if ([menuItem.text isEqualToString:SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackMedium]]) {
        [self requestPurchaseForPack:SIIAPPackMedium];
    }  else if ([menuItem.text isEqualToString:SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackLarge]]) {
        [self requestPurchaseForPack:SIIAPPackLarge];
    }  else if ([menuItem.text isEqualToString:SIGame buttonNodeNameNodeForSIIAPPack:SIIAPPackExtraLarge]]) {
        [self requestPurchaseForPack:SIIAPPackExtraLarge];
    } else if ([menuItem.text isEqualToString:kSIMenuTextBack]) {
        [self goBack];
    }
}
-(BOOL)menuNode:(HLMenuNode *)menuNode shouldTapMenuItem:(HLMenuItem *)menuItem itemIndex:(NSUInteger)itemIndex {
    return _shouldRespondToTap;
}
- (void)goBack {
    _shouldRespondToTap = NO;
    if (self.wasLaunchedFromMainMenu) {
        StartScreenScene *startScene = [StartScreenScene sceneWithSize:self.size];
        SIGame transisitionToSKScene:startScene toSKView:self.view DoorsOpen:NO pausesIncomingScene:YES pausesOutgoingScene:YES duration:SCENE_TRANSISTION_DURATION];
        
    } else {
        EndGameScene *endScene = [EndGameScene sceneWithSize:self.size];
        SIGame transisitionToSKScene:endScene toSKView:self.view DoorsOpen:NO pausesIncomingScene:YES pausesOutgoingScene:YES duration:SCENE_TRANSISTION_DURATION];
    }
}
- (void)requestPurchaseForPack:(SIIAPPack)siiapPack {
    if (_isPurchaseInProgress == NO) {
        _isPurchaseInProgress = YES;
        [self packPurchaseRequest:siiapPack attemptNumber:0];
    }
}


- (BOOL)isMKStoreKitAvailableAttempt:(NSUInteger)attemptNumber {
    NSArray *productsArray  = [MKStoreKit sharedKit].availableProducts;
    
    if (productsArray) {
        /*MKStoreKit is up and running*/
        _products       = productsArray;
        return YES;
    } else {
        /*MKStoreKit is loading*/
        if (attemptNumber == MAX_NUMBER_OF_ATTEMPTS) {
            NSLog(@"Hit max reload attemps");
            return NO;
        } else {
            NSLog(@"Trying to load from MKStoreKit attempt: %lu",(unsigned long)attemptNumber);
            return [self isMKStoreKitAvailableAttempt:attemptNumber + 1];
        }
    }
}

- (void)addLabels:(CGSize)size {
    _titleLabel                     = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    _titleLabel.text                             = @"Store";
    _titleLabel.position                         = CGPointMake(size.width / 2.0f, size.height - (VERTICAL_SPACING_16 + (_titleLabel.frame.size.height / 2.0f)));
    _titleLabel.fontColor                        = [SKColor blackColor];
    _titleLabel.fontSize                         = [SIGameController fontSizeHeader];
    _titleLabel.horizontalAlignmentMode          = SKLabelHorizontalAlignmentModeCenter;
    [self addChild:_titleLabel];
    
    _itCoinsLabel                           = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    _itCoinsLabel.text                      = [NSString stringWithFormat:@"You have %d IT Coins",[[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue]];
    _itCoinsLabel.position                  = CGPointMake(self.itCoinsLabel.frame.size.width / 2.0f + VERTICAL_SPACING_8, size.height - VERTICAL_SPACING_8 - _titleLabel.frame.size.height - VERTICAL_SPACING_8);
    _itCoinsLabel.fontColor                 = [SKColor blackColor];
    _itCoinsLabel.fontSize                  = [SIGameController fontSizeParagraph];
    _itCoinsLabel.verticalAlignmentMode     = SKLabelVerticalAlignmentModeCenter;
    _itCoinsLabel.horizontalAlignmentMode   = SKLabelHorizontalAlignmentModeCenter;
    [self addChild:_itCoinsLabel];

}
#pragma mark - Class Methods
- (void)packPurchaseRequest:(SIIAPPack)siiapPack attemptNumber:(int)attemptNumber {
    if (attemptNumber == 6) {
        NSLog(@"Failed after 3 seconds.... ");
        /*TODO: Throw error message about not being able to connect*/
        // blah blah
        _isPurchaseInProgress                   = NO;
        return;
    }
    
    NSArray *productArray = [MKStoreKit sharedKit].availableProducts;
    
    if (productArray.count > 0) {
        [SIIAPUtility productForSIIAPPack:siiapPack inPackArray:productArray withBlock:^(BOOL succeeded, SKProduct *product) {
            if (succeeded) {
                NSDictionary *userInfo          = @{kSINSDictionaryKeyHudWillAnimate            : @YES,
                                                    kSINSDictionaryKeyHudWillDimBackground      : @YES,
                                                    kSINSDictionaryKeyHudMessagePresentTitle    : @"Purchasing...",
                                                    kSINSDictionaryKeyHudMessagePresentInfo     : @"Working..."};
                NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationHudShow object:nil userInfo:userInfo];
                [[NSNotificationCenter defaultCenter] postNotification:notification];

                [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:product.productIdentifier];
            } else {
                NSLog(@"Error: Could not find the SIIAPPack (%ld) after button touch for purchase",(long)siiapPack);
            }
        }];
    } else {
        NSLog(@"Trying Request Again....");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self packPurchaseRequest:siiapPack attemptNumber:attemptNumber + 1];
        });
    }
}
- (void)changeCoinValue {
    /*transition out sequence*/
//    SKAction *spin                = [SKAction rotateByAngle:M_PI duration:1.0f];
    SKAction *shrink                    = [SKAction scaleTo:0.2f duration:1.0f];
    SKAction *reduceAlpha               = [SKAction fadeAlphaTo:0.0f duration:1.0f];
    SKAction *oldCoinGroup              = [SKAction group:@[shrink,reduceAlpha]];
    /*Change that value*/
    SKAction *changeValue               = [SKAction runBlock:^{
        self.itCoinsLabel.text          = [NSString stringWithFormat:@"You have %d IT Coins",[[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue]];
    }];
    /*transistion in*/
    SKAction *growLarge                 = [SKAction scaleTo:2.0 duration:1.2f];
    SKAction *increaseAlpha             = [SKAction fadeAlphaTo:1.0f duration:1.0f];
    SKAction *newCoinGroup              = [SKAction group:@[growLarge,increaseAlpha]];
    SKAction *growNormal                = [SKAction scaleTo:1.0 duration:0.5f];
    /*Make action sequence*/
    SKAction *completeSequence          = [SKAction sequence:@[oldCoinGroup,changeValue,newCoinGroup,growNormal]];
    /*run action*/
    [self.itCoinsLabel runAction:completeSequence];
}


- (void)purchaseSuccess:(BOOL)puchaseWasSuccessful titleText:(NSString *)titleText infoText:(NSString *)infoText duration:(CGFloat)duration {
    NSDictionary *userInfo              = @{kSINSDictionaryKeyHudWillAnimate            : @YES,
                                            kSINSDictionaryKeyHudWillShowCheckmark      : [NSNumber numberWithBool:puchaseWasSuccessful],
                                            kSINSDictionaryKeyHudHoldDismissForDuration : [NSNumber numberWithFloat:duration],
                                            kSINSDictionaryKeyHudMessagePresentTitle    : titleText,
                                            kSINSDictionaryKeyHudMessagePresentInfo     : infoText};
    NSNotification *notification        = [[NSNotification alloc] initWithName:kSINotificationHudHide object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}

#pragma mark - SIPopupNode methods
- (void)createPopup:(CGSize)size {
    _popupNode                                  = [SIGameController SIPopUpNodeTitle:@"DAILY FREE PRIZE!" SceneSize:size];
    _popupNode.zPosition                        = (float)SIStoreSceneZPositionPopupBackground / (float)SIStoreSceneZPositionPopupCount;
    _popupNode.delegate                         = self;
    
    _coinSize                                   = CGSizeMake(_popupNode.backgroundSize.width * 0.25f, _popupNode.backgroundSize.width * 0.25f);
    
    SKSpriteNode *mainNode                      = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:_popupNode.backgroundSize];
    mainNode.anchorPoint                        = CGPointMake(0.5f, 0.5f);
    mainNode.zPosition                          = (float)SIStoreSceneZPositionPopupBackground / (float)SIStoreSceneZPositionPopupCount;
    
    CGSize chestSize                            = CGSizeMake(_popupNode.backgroundSize.width * 0.8, _popupNode.backgroundSize.width * 0.8);
    
    SKSpriteNode *chest                         = [SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageIAPExtraLarge] size:chestSize];
    chest.anchorPoint                           = CGPointMake(0.5f, 0.5f);
    chest.position                              = CGPointMake(0.0f, 0.0f);
    chest.zPosition                             = 0.5;
    [mainNode addChild:chest];
    
    _popupNode.titleContentNode                 = [self createTitleNode:CGSizeMake(size.width - VERTICAL_SPACING_16, (_popupNode.backgroundSize.height / 2.0f) - (chestSize.height / 2.0f))];
    
    BMGlyphFont *font                           = [[BMGlyphFont alloc] initWithName:kSIFontUltraStroked];
    _prizeAmountLabelNode                       = [[BMGlyphLabel alloc] initWithText:[NSString stringWithFormat:@"%d",[self getPrizeAmount]] font:font];
    _prizeAmountLabelNode.verticalAlignment     = BMGlyphVerticalAlignmentBottom;
    _prizeAmountLabelNode.horizontalAlignment   = BMGlyphHorizontalAlignmentCentered;
    _prizeAmountLabelNode.zPosition             = 0.6;
    [_prizeAmountLabelNode runAction:[SKAction scaleBy:3.0f duration:0.0f]];
    _prizeAmountLabelNode.position              = CGPointMake(0.0f, -1.0f * (chestSize.height / 2.0f) + VERTICAL_SPACING_16);
    [chest addChild:_prizeAmountLabelNode];
    
    CGSize claimButtonSize                      = CGSizeMake(_popupNode.backgroundSize.width / 2.0f, _popupNode.backgroundSize.width / 4.0f);
    
    HLLabelButtonNode *claimButton              = [[HLLabelButtonNode alloc] initWithColor:[SKColor redColor] size:claimButtonSize];
    claimButton.cornerRadius                    = 8.0f;
    claimButton.borderWidth                     = 8.0f;
    claimButton.borderColor                     = [SKColor blackColor];
    claimButton.text                            = @"CLAIM!";
    claimButton.fontColor                       = [SKColor whiteColor];
    claimButton.verticalAlignmentMode           = HLLabelNodeVerticalAlignFont;
    claimButton.position                        = CGPointMake(0.0f, -1.0f * (_popupNode.backgroundSize.height / 2.0f) + VERTICAL_SPACING_8 + (claimButtonSize.height / 2.0f));
    [claimButton hlSetGestureTarget:[HLTapGestureTarget tapGestureTargetWithHandleGestureBlock:^(UIGestureRecognizer *gestureRecognizer) {
        [self launchCoins:[self getPrizeAmount] coinsLaunched:0];
        [claimButton removeFromParent];
    }]];
    [self registerDescendant:claimButton withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
    [mainNode addChild:claimButton];
    
    _popupNode.popupContentNode                 = mainNode;
}
- (void)launchCoins:(int)totalCoins coinsLaunched:(int)coinsLaunched {
    if (coinsLaunched == totalCoins) {
        [self finishPrize];
    } else {
        _prizeAmountLabelNode.text  = [NSString stringWithFormat:@"%d",totalCoins - coinsLaunched - 1];
        [self lauchCoin];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(((CGFloat)(totalCoins - coinsLaunched) / (CGFloat)totalCoins) / 2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self launchCoins:totalCoins coinsLaunched:coinsLaunched + 1];
        });
    }
}
- (void)lauchCoin {
    SKSpriteNode *coinNode;
    
    int randomCoin                                  = arc4random_uniform(2);
    if (randomCoin == 1) {
        coinNode                                    = [SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageCoinSmallBack] size:_coinSize];
    } else {
        coinNode                                    = [SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageCoinSmallFront] size:_coinSize];
    }
    
    coinNode.anchorPoint                            = CGPointMake(0.5f, 0.5f);
    coinNode.zPosition                              = (float)SIStoreSceneZPositionLayerPopupCoin / (float)SIStoreSceneZPositionLayerCount;
    coinNode.position                               = CGPointMake(0.0f, 0.0f);//CGPointMake(self.frame.size.width / 2.0f, (self.frame.size.height / 2.0f) - _moveCommandLabel.frame.size.height);
    coinNode.physicsBody                            = [SKPhysicsBody bodyWithCircleOfRadius:_coinSize.height/2.0f];
    coinNode.physicsBody.collisionBitMask           = 0;
    coinNode.physicsBody.linearDamping              = 0.0f;
    
    [_popupNode addChild:coinNode];
    
    
    CGFloat randomDx                            = arc4random_uniform(LAUNCH_DX_VECTOR_MAX);
    while (randomDx < LAUNCH_DX_VECTOR_MIX) {
        randomDx                                = arc4random_uniform(LAUNCH_DX_VECTOR_MAX);
    }
    int randomDirection                         = arc4random_uniform(2);
    if (randomDirection == 1) { /*Negative Direction*/
        randomDx                                = -1.0f * randomDx;
    }
    
    CGFloat randomDy                            = ((arc4random_uniform(5)/5) + 1)* LAUNCH_DY_MULTIPLIER;
    
    //    NSLog(@"Vector... dX = %0.2f | Y = %0.2f",randomDx,randomDy);
    CGVector moveScoreVector                    = CGVectorMake(randomDx, randomDy);
    
    [coinNode.physicsBody applyImpulse:moveScoreVector];
    
    if ([SIConstants isFXAllowed]) {
        [[SoundManager sharedManager] playSound:kSISoundFXChaChing];
    }
}
- (void)finishPrize {
    if ([SIConstants isFXAllowed]) {
        [[SoundManager sharedManager] playSound:kSISoundFXChaChing];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSDate *currentDate = [SIGameController getDateFromInternet];
        if (currentDate) {
            [[MKStoreKit sharedKit] addFreeCredits:[NSNumber numberWithInt:[self getPrizeAmount]] identifiedByConsumableIdentifier:kSIIAPConsumableIDCoins];
            
            [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:kSINSUserDefaultLastPrizeAwardedDate];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self changeCoinValue];
        }
        [self increaseConsecutiveDaysLaunched];
        [self dismissModalNodeAnimation:HLScenePresentationAnimationFade];
    });
}
- (int)getPrizeAmount {
    NSNumber *numberOfConsecutiveDaysLaunched = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultNumberConsecutiveAppLaunches];
    if (!numberOfConsecutiveDaysLaunched) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kSINSUserDefaultNumberConsecutiveAppLaunches];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return 1;
    }
    return [numberOfConsecutiveDaysLaunched intValue] * FREE_COINS_PER_DAY;
}

- (void)increaseConsecutiveDaysLaunched {
    NSNumber *numberOfConsecutiveDaysLaunched = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultNumberConsecutiveAppLaunches];
    [[NSUserDefaults standardUserDefaults] setInteger:[numberOfConsecutiveDaysLaunched integerValue] + 1 forKey:kSINSUserDefaultNumberConsecutiveAppLaunches];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (SKSpriteNode *)createTitleNode:(CGSize)size {
    SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
    backgroundNode.anchorPoint                  = CGPointMake(0.5f, 0.5f);
    
    SKLabelNode *dailyNode                      = [SKLabelNode labelNodeWithFontNamed:kSIFontUltra];
    dailyNode.text                              = @"DAILY";
    dailyNode.fontColor                         = [SKColor whiteColor];
    dailyNode.fontSize                          = (size.height / 4.0f) - VERTICAL_SPACING_8;
    dailyNode.verticalAlignmentMode             = SKLabelVerticalAlignmentModeBottom;
    dailyNode.horizontalAlignmentMode           = SKLabelHorizontalAlignmentModeRight;
    
    SKLabelNode *prizeNode                      = [SKLabelNode labelNodeWithFontNamed:kSIFontUltra];
    prizeNode.text                              = @"PRIZE";
    prizeNode.fontColor                         = [SKColor whiteColor];
    prizeNode.fontSize                          = (size.height / 4.0f) - VERTICAL_SPACING_8;
    prizeNode.verticalAlignmentMode             = SKLabelVerticalAlignmentModeTop;
    prizeNode.horizontalAlignmentMode           = SKLabelHorizontalAlignmentModeRight;
    
    SKLabelNode *freeNode                       = [SKLabelNode labelNodeWithFontNamed:kSIFontUltra];
    freeNode.text                               = @"FREE";
    freeNode.fontColor                          = [SKColor redColor];
    freeNode.fontSize                           = (size.height / 2.0f) - VERTICAL_SPACING_16;
    freeNode.verticalAlignmentMode              = SKLabelVerticalAlignmentModeCenter;
    freeNode.horizontalAlignmentMode            = SKLabelHorizontalAlignmentModeLeft;
    
    CGFloat xOffset                             = -1.0f * (freeNode.frame.size.width - dailyNode.frame.size.width) / 2.0f;
    
    dailyNode.position                          = CGPointMake(xOffset, 0.0f);
    prizeNode.position                          = CGPointMake(xOffset, 0.0f);
    freeNode.position                           = CGPointMake(xOffset, 0.0f);
    
    [backgroundNode addChild:dailyNode];
    [backgroundNode addChild:prizeNode];
    [backgroundNode addChild:freeNode];
    
    return backgroundNode;
}
- (void)dismissPopUp:(SIPopupNode *)popUpNode {
    [self dismissModalNodeAnimation:HLScenePresentationAnimationFade];
}

@end
