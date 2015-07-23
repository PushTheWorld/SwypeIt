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
#import "StartScreenScene.h"
#import "StoreScene.h"
// Framework Import
#import <StoreKit/StoreKit.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "MKStoreKit.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "Game.h"
#import "SIConstants.h"
// Other Imports

@interface StoreScene () {
    NSNumberFormatter * _priceFormatter;
}
@property (assign, nonatomic) BOOL           isPurchaseInProgress;
@property (assign, nonatomic) CGFloat        verticalNodeCenterPoint;

@property (strong, nonatomic) NSArray       *products;
@property (strong, nonatomic) SKLabelNode   *itCoinsLabel;

@end

@implementation StoreScene


-(nonnull instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor            = [SKColor sandColor];
        
        self.isPurchaseInProgress       = NO;
        
        self.products                   = [MKStoreKit sharedKit].availableProducts;
        
        self.verticalNodeCenterPoint    = size.height / 6.0f;
        
        [self addButtons:size];
        [self addLabels:size];
    
    }
    return self;
}
- (void)addLabels:(CGSize)size {
    SKLabelNode *storeLabel                     = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    storeLabel.text                             = @"Store";
    storeLabel.position                         = CGPointMake(size.width / 2.0f, size.height - (VERTICAL_SPACING_8 + (storeLabel.frame.size.height / 2.0f)));
    storeLabel.fontColor                        = [SKColor blackColor];
    storeLabel.fontSize                         = 30;
    storeLabel.horizontalAlignmentMode          = SKLabelHorizontalAlignmentModeCenter;
    [self addChild:storeLabel];
    
    self.itCoinsLabel                           = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    self.itCoinsLabel.text                      = [NSString stringWithFormat:@"%d",[[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue]];
    self.itCoinsLabel.position                  = CGPointMake(self.itCoinsLabel.frame.size.width / 2.0f + VERTICAL_SPACING_8, size.height - VERTICAL_SPACING_8 - storeLabel.frame.size.height - VERTICAL_SPACING_8);
    self.itCoinsLabel.fontColor                 = [SKColor blackColor];
    self.itCoinsLabel.fontSize                  = 25;
    self.itCoinsLabel.horizontalAlignmentMode   = SKLabelHorizontalAlignmentModeLeft;
    [self addChild:self.itCoinsLabel];

}
- (void)addButtons:(CGSize)size {
    for (int i = 3; i >= 0; i--) {
        [self addButton:size withSIIAPPack:(SIIAPPack)(i) withVerticalCenterPoints:self.verticalNodeCenterPoint];
    }
    
    SKSpriteNode *doneButton    = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:kSIImageButtonDone] size:CGSizeMake(size.width / 2.0f, size.width / 4.0f)];
    doneButton.name             = kSINodeButtonDone;
    doneButton.position         = CGPointMake(size.width / 2.0f, self.verticalNodeCenterPoint);
    [self addChild:doneButton];
    
}
- (void)addButton:(CGSize)size withSIIAPPack:(SIIAPPack)siiapPack withVerticalCenterPoints:(CGFloat)verticalNodeCenterPoint {
    
    NSArray *productArray = [MKStoreKit sharedKit].availableProducts;
    
    SKProduct *product = [StoreScene productForSIIAPPack:siiapPack inPackArray:productArray];
    if (product) {
        NSLog(@"Trying to load product for SIIAPPack %d",siiapPack);

        /*Main node... this is the button essentially*/
        SKSpriteNode *mainNode                      = [SKSpriteNode spriteNodeWithColor:[SKColor mainColor] size:CGSizeMake(size.width - VERTICAL_SPACING_16, verticalNodeCenterPoint - VERTICAL_SPACING_8)];
        mainNode.position                           = CGPointMake(size.width / 2.0f, verticalNodeCenterPoint + verticalNodeCenterPoint * (siiapPack + 1));
        mainNode.name                               = [Game buttonNodeNameNodeForSIIAPPack:siiapPack];
        [self addChild:mainNode];
        
        /*This is the product description*/
        SKLabelNode *descriptionLabel               = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
        descriptionLabel.position                   = CGPointMake(0, 0); //CGPointMake(mainNode.frame.size.width / 2.0f, mainNode.frame.size.height - VERTICAL_SPACING_8);
//        descriptionLabel.verticalAlignmentMode      = SKLabelVerticalAlignmentModeTop;
//        descriptionLabel.horizontalAlignmentMode    = SKLabelHorizontalAlignmentModeLeft;
        descriptionLabel.text                       = [Game buttonTextForSIIAPPack:siiapPack];
        descriptionLabel.fontSize                   = 16;
        descriptionLabel.fontColor                  = [SKColor whiteColor];
        descriptionLabel.name                       = [Game buttonNodeNameLabelPriceForSIIAPPack:siiapPack];
        [mainNode addChild:descriptionLabel];
        
//        /*This is the product price*/
        [_priceFormatter setLocale:product.priceLocale];
        SKLabelNode *priceLabel                     = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
        priceLabel.position                         = CGPointMake(0, 0.5); // CGPointMake(mainNode.frame.size.width / 2.0f, VERTICAL_SPACING_8);
//        priceLabel.verticalAlignmentMode            = SKLabelVerticalAlignmentModeBottom;
//        priceLabel.horizontalAlignmentMode          = SKLabelHorizontalAlignmentModeRight;
        priceLabel.text                             = [_priceFormatter stringFromNumber:product.price];
        NSLog(@"Price: %@",priceLabel.text);
        priceLabel.fontSize                         = 14;
        priceLabel.fontColor                        = [SKColor whiteColor];
        priceLabel.name                             = [Game buttonNodeNameLabelPriceForSIIAPPack:siiapPack];
        [mainNode addChild:priceLabel];
    } else {
        NSLog(@"Product is nil");
    }
}
- (void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch          = [touches anyObject];
    CGPoint location        = [touch locationInNode:self];
    NSArray *nodesAtPoint   = [self nodesAtPoint:location];
    
    for (SKNode *node in nodesAtPoint) {
        if ([node.name isEqualToString:kSINodeButtonDone]) {
            if (self.wasLaunchedFromMainMenu) {
                StartScreenScene *startScene = [StartScreenScene sceneWithSize:self.size];
                [self.view presentScene:startScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];

            } else {
                EndGameScene *endScene = [EndGameScene sceneWithSize:self.size];
                [self.view presentScene:endScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];

            }
        } else {
            for (int i = 0; i < NUMBER_OF_IAP_PACKS; i++) {
                if ([StoreScene isNodeNode:node matchingSIIAPPack:(SIIAPPack)i]) {
                    if (self.isPurchaseInProgress == NO) {
                        self.isPurchaseInProgress = YES;
                        SIIAPPack siiapPack = [Game siiapPackForNameNodeNode:node.name];
                        [self packPurchaseRequest:siiapPack];
                    }
                }
            }
        }
    }
}
#pragma mark - Class Methods
- (void)packPurchaseRequest:(SIIAPPack)siiapPack {
    NSArray *productArray = [MKStoreKit sharedKit].availableProducts;
    
    if (productArray.count > 0) {
        SKProduct *product = [StoreScene productForSIIAPPack:siiapPack inPackArray:productArray];
        if (product) {
            [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:product.productIdentifier];
        } else {
            NSLog(@"Error: finding purchase pack");
        }
    }
}
- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(packPurchaseRequest:) name:kSINotificationPackPurchaseRequest object:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Purchased/Subscribed to product with id: %@", [note object]);
                                                      self.isPurchaseInProgress = NO;
                                                      self.itCoinsLabel.text    = [NSString stringWithFormat:@"%d",[[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue]];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoredPurchasesNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Restored Purchases");
                                                      self.isPurchaseInProgress = NO;
                                                      self.itCoinsLabel.text    = [NSString stringWithFormat:@"%d",[[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue]];

                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoringPurchasesFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Failed restoring purchases with error: %@", [note object]);
                                                      self.isPurchaseInProgress = NO;

                                                  }];
}
/**Retuns nil if the product cannot be found*/
+ (SKProduct *)productForSIIAPPack:(SIIAPPack)siiapPack inPackArray:(NSArray *)productArray {
    SKProduct *matchingProduct;
    for (SKProduct *product in productArray) {
        NSString *productID = product.productIdentifier;
        if ([productID isEqualToString:[Game productIDForSIIAPPack:siiapPack]]) {
            matchingProduct = product;
        }
        
    }
    return matchingProduct;
}
/**Checks to see if the node name is equal to the siiapPack*/
+ (BOOL)isNodeNode:(SKNode *)node matchingSIIAPPack:(SIIAPPack)siiapPack {
    /*Need to check node*/
    if ([node.name isEqualToString:[Game buttonNodeNameNodeForSIIAPPack:siiapPack]]) {
        return YES;
    } else {
        return NO;
    }
}

@end
