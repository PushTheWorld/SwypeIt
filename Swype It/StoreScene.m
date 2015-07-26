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
#import "SIIAPUtility.h"
// Other Imports

#define MAX_NUMBER_OF_ATTEMPTS 20

@interface StoreScene () {

}
@property (assign, nonatomic) BOOL               isPurchaseInProgress;
@property (assign, nonatomic) CGFloat            verticalNodeCenterPoint;

@property (strong, nonatomic) NSArray           *products;
@property (strong, nonatomic) NSNumberFormatter *priceFormatter;
@property (strong, nonatomic) SKLabelNode       *itCoinsLabel;

@end

@implementation StoreScene


-(nonnull instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor            = [SKColor sandColor];
        
        self.isInTestMode               = NO;
        
        self.isPurchaseInProgress       = NO;
        
        self.verticalNodeCenterPoint    = size.height / 6.0f;
        
        [self registerForNotifications];
        
        /*Configure the price formatter before trying to add the buttons*/
        [self configurePriceFormatter];
        
        [self addButtons:size];
        [self addLabels:size];
        
        if (self.isInTestMode) {
            for (int i = 0; i < 5; i++) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 + 4*i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self changeCoinValue];
                });
            }
        }
    }
    return self;
}
-(void)willMoveFromView:(nonnull SKView *)view {
    [super willMoveFromView:view];
//    [self removeObserver:self forKeyPath:kMKStoreKitProductPurchasedNotification];
//    [self removeObserver:self forKeyPath:kMKStoreKitRestoredPurchasesNotification];
//    [self removeObserver:self forKeyPath:kMKStoreKitRestoringPurchasesFailedNotification];
}
- (BOOL)isMKStoreKitAvailableAttempt:(NSUInteger)attemptNumber {
    NSArray *productsArray  = [MKStoreKit sharedKit].availableProducts;
    
    if (productsArray) {
        /*MKStoreKit is up and running*/
        self.products       = productsArray;
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
- (void)configurePriceFormatter {
    self.priceFormatter = [[NSNumberFormatter alloc] init];
    [self.priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [self.priceFormatter setLocale:[NSLocale currentLocale]];
}
- (void)addLabels:(CGSize)size {
    SKLabelNode *storeLabel                     = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    storeLabel.text                             = @"Store";
    storeLabel.position                         = CGPointMake(size.width / 2.0f, size.height - (VERTICAL_SPACING_16 + (storeLabel.frame.size.height / 2.0f)));
    storeLabel.fontColor                        = [SKColor blackColor];
    storeLabel.fontSize                         = 30;
    storeLabel.horizontalAlignmentMode          = SKLabelHorizontalAlignmentModeCenter;
    [self addChild:storeLabel];
    
    self.itCoinsLabel                           = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    self.itCoinsLabel.text                      = [NSString stringWithFormat:@"You have %d IT Coins",[[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue]];
    self.itCoinsLabel.position                  = CGPointMake(self.itCoinsLabel.frame.size.width / 2.0f + VERTICAL_SPACING_8, size.height - VERTICAL_SPACING_8 - storeLabel.frame.size.height - VERTICAL_SPACING_8);
    self.itCoinsLabel.fontColor                 = [SKColor blackColor];
    self.itCoinsLabel.fontSize                  = 25;
    self.itCoinsLabel.verticalAlignmentMode     = SKLabelVerticalAlignmentModeCenter;
    self.itCoinsLabel.horizontalAlignmentMode   = SKLabelHorizontalAlignmentModeCenter;
    [self addChild:self.itCoinsLabel];

}
- (void)addButtons:(CGSize)size {
    NSLog(@"addButtons called");
    
    for (int i = 0; i < 4; i++) {
        [self addButton:size withSIIAPPack:(SIIAPPack)(i) withVerticalCenterPoints:self.verticalNodeCenterPoint];
    }
    
    SKSpriteNode *doneButton    = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonDone] size:CGSizeMake(size.width / 2.0f, size.width / 4.0f)];
    doneButton.name             = kSINodeButtonDone;
    doneButton.position         = CGPointMake(size.width / 2.0f, self.verticalNodeCenterPoint);
    [self addChild:doneButton];
    
}
- (void)addButton:(CGSize)size withSIIAPPack:(SIIAPPack)siiapPack withVerticalCenterPoints:(CGFloat)verticalNodeCenterPoint {
    
    NSArray *productArray = [MKStoreKit sharedKit].availableProducts;
    
    [SIIAPUtility productForSIIAPPack:siiapPack inPackArray:productArray withBlock:^(BOOL succeeded, SKProduct *product) {
        if (succeeded) {
            NSLog(@"Found IAP for SIIAPPack: %d || Creating dynamic button",siiapPack);
            [self createButtonForProduct:product centerPoint:verticalNodeCenterPoint size:size siiapPack:siiapPack];
        } else {
            NSLog(@"Unable to find IAP for SIIAPPack: %d || Creating static button",siiapPack);
            [self createButtonForSIIAPPack:siiapPack centerPoint:verticalNodeCenterPoint size:size];
        }
    }];
}
- (void)createButtonForProduct:(SKProduct *)product centerPoint:(CGFloat)verticalNodeCenterPoint size:(CGSize)size siiapPack:(SIIAPPack)siiapPack {
    /*Main node... this is the button essentially*/
    SKSpriteNode *mainNode                      = [SKSpriteNode spriteNodeWithColor:[SKColor mainColor] size:CGSizeMake(size.width - VERTICAL_SPACING_16, verticalNodeCenterPoint - VERTICAL_SPACING_8)];
    mainNode.position                           = CGPointMake(size.width / 2.0f, verticalNodeCenterPoint + verticalNodeCenterPoint * (4 - siiapPack));
    mainNode.name                               = [Game buttonNodeNameNodeForSIIAPPack:siiapPack];
    [self addChild:mainNode];
    
    /*This is the product description*/
    SKLabelNode *descriptionLabel               = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    descriptionLabel.position                   = CGPointMake(0, 0); //CGPointMake(mainNode.frame.size.width / 2.0f, mainNode.frame.size.height - VERTICAL_SPACING_8);
    descriptionLabel.text                       = [Game buttonTextForSIIAPPack:siiapPack];
    descriptionLabel.fontSize                   = 16;
    descriptionLabel.fontColor                  = [SKColor whiteColor];
    descriptionLabel.name                       = [Game buttonNodeNameLabelPriceForSIIAPPack:siiapPack];
    [mainNode addChild:descriptionLabel];
    
    /*This is the product price*/
    SKLabelNode *priceLabel                     = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    priceLabel.position                         = CGPointMake(0, -1.0f * descriptionLabel.frame.size.height); // CGPointMake(mainNode.frame.size.width / 2.0f, VERTICAL_SPACING_8);
    priceLabel.text                             = [self.priceFormatter stringFromNumber:product.price];
    priceLabel.fontSize                         = 14;
    priceLabel.fontColor                        = [SKColor whiteColor];
    priceLabel.name                             = [Game buttonNodeNameLabelPriceForSIIAPPack:siiapPack];
    [mainNode addChild:priceLabel];
    
    /*This is the product price*/
    SKLabelNode *amountOfItCoinsLabel           = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    amountOfItCoinsLabel.position               = CGPointMake(0, descriptionLabel.frame.size.height); // CGPointMake(mainNode.frame.size.width / 2.0f, VERTICAL_SPACING_8);
    amountOfItCoinsLabel.text                   = [NSString stringWithFormat:@"Value: %d IT Coins",[Game numberOfCoinsForSIIAPPack:siiapPack]];
    amountOfItCoinsLabel.fontSize               = 14;
    amountOfItCoinsLabel.fontColor              = [SKColor whiteColor];
    amountOfItCoinsLabel.name                   = [Game buttonNodeNameLabelPriceForSIIAPPack:siiapPack];
    [mainNode addChild:amountOfItCoinsLabel];
}
- (void)createButtonForSIIAPPack:(SIIAPPack)siiapPack centerPoint:(CGFloat)verticalNodeCenterPoint size:(CGSize)size {
    /*Main node... this is the button essentially*/
    SKSpriteNode *mainNode                      = [SKSpriteNode spriteNodeWithColor:[SKColor mainColor] size:CGSizeMake(size.width - VERTICAL_SPACING_16, verticalNodeCenterPoint - VERTICAL_SPACING_8)];
    mainNode.position                           = CGPointMake(size.width / 2.0f, verticalNodeCenterPoint + verticalNodeCenterPoint * (siiapPack + 1));
    mainNode.name                               = [Game buttonNodeNameNodeForSIIAPPack:siiapPack];
    [self addChild:mainNode];
    
    /*This is the product description*/
    SKLabelNode *descriptionLabel               = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    descriptionLabel.position                   = CGPointMake(0, 0); //CGPointMake(mainNode.frame.size.width / 2.0f, mainNode.frame.size.height - VERTICAL_SPACING_8);
    descriptionLabel.text                       = [Game buttonTextForSIIAPPack:siiapPack];
    descriptionLabel.fontSize                   = 16;
    descriptionLabel.fontColor                  = [SKColor whiteColor];
    descriptionLabel.name                       = [Game buttonNodeNameLabelPriceForSIIAPPack:siiapPack];
    [mainNode addChild:descriptionLabel];
    
    //        /*This is the product price*/
    SKLabelNode *priceLabel                     = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
    priceLabel.position                         = CGPointMake(0, -1.0f * descriptionLabel.frame.size.height); // CGPointMake(mainNode.frame.size.width / 2.0f, VERTICAL_SPACING_8);
    
    priceLabel.text                             = [self.priceFormatter stringFromNumber:[SIIAPUtility productPriceForSIIAPPack:siiapPack]];
    priceLabel.fontSize                         = 14;
    priceLabel.fontColor                        = [SKColor whiteColor];
    priceLabel.name                             = [Game buttonNodeNameLabelPriceForSIIAPPack:siiapPack];
    [mainNode addChild:priceLabel];
}
- (void)touchesBegan:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch          = [touches anyObject];
    CGPoint location        = [touch locationInNode:self];
    NSArray *nodesAtPoint   = [self nodesAtPoint:location];
    
    for (SKNode *node in nodesAtPoint) {
        if ([node.name isEqualToString:kSINodeButtonDone]) {
            if (self.wasLaunchedFromMainMenu) {
                StartScreenScene *startScene = [StartScreenScene sceneWithSize:self.size];
                [Game transisitionToSKScene:startScene toSKView:self.view DoorsOpen:NO pausesIncomingScene:NO pausesOutgoingScene:NO duration:1.0];

            } else {
                EndGameScene *endScene = [EndGameScene sceneWithSize:self.size];
                [Game transisitionToSKScene:endScene toSKView:self.view DoorsOpen:NO pausesIncomingScene:NO pausesOutgoingScene:NO duration:1.0];
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
                NSLog(@"Error: Could not find the SIIAPPack (%d) after button touch for purchase",siiapPack);
            }
        }];
    }
}
- (void)changeCoinValue {
    /*transition out sequence*/
//    SKAction *spin                = [SKAction rotateByAngle:M_PI duration:1.0f];
    SKAction *shrink              = [SKAction scaleTo:0.2f duration:1.0f];
    SKAction *reduceAlpha         = [SKAction fadeAlphaTo:0.0f duration:1.0f];
    SKAction *oldCoinGroup        = [SKAction group:@[shrink,reduceAlpha]];
    /*Change that value*/
    SKAction *changeValue         = [SKAction runBlock:^{
        self.itCoinsLabel.text    = [NSString stringWithFormat:@"%d",[[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue]];
    }];
    /*transistion in*/
    SKAction *growLarge           = [SKAction scaleTo:2.0 duration:1.2f];
    SKAction *increaseAlpha       = [SKAction fadeAlphaTo:1.0f duration:1.0f];
    SKAction *newCoinGroup        = [SKAction group:@[growLarge,increaseAlpha]];
    SKAction *growNormal          = [SKAction scaleTo:1.0 duration:0.5f];
    /*Make action sequence*/
    SKAction *completeSequence    = [SKAction sequence:@[oldCoinGroup,changeValue,newCoinGroup,growNormal]];
    /*run action*/
    [self.itCoinsLabel runAction:completeSequence];
}

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(packPurchaseRequest:) name:kSINotificationPackPurchaseRequest object:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Purchased/Subscribed to product with id: %@", [note object]);
                                                      self.isPurchaseInProgress = NO;
                                                      [self changeCoinValue];
                                                      [self purchaseSuccess:YES titleText:@"Purchased!" infoText:@"Swype On!" duration:2.0f];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoredPurchasesNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Restored Purchases");
                                                      self.isPurchaseInProgress = NO;
                                                      [self changeCoinValue];
                                                      [self purchaseSuccess:YES titleText:@"Restored!" infoText:@"" duration:2.0f];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoringPurchasesFailedNotification
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      NSLog(@"Failed restoring purchases with error: %@", [note object]);
                                                      self.isPurchaseInProgress = NO;
                                                      [self purchaseSuccess:NO titleText:@"Failed." infoText:@"Try again later..." duration:1.0f];

                                                  }];
}
- (void)purchaseSuccess:(BOOL)puchaseWasSuccessful titleText:(NSString *)titleText infoText:(NSString *)infoText duration:(CGFloat)duration {
    NSDictionary *userInfo          = @{kSINSDictionaryKeyHudWillAnimate            : @YES,
                                        kSINSDictionaryKeyHudWillShowCheckmark      : [NSNumber numberWithBool:puchaseWasSuccessful],
                                        kSINSDictionaryKeyHudHoldDismissForDuration : [NSNumber numberWithFloat:duration],
                                        kSINSDictionaryKeyHudMessagePresentTitle    : titleText,
                                        kSINSDictionaryKeyHudMessagePresentInfo     : infoText};
    NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationHudHide object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

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
