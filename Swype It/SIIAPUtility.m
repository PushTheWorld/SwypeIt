//  SIIAPUtility.m
//  Swype It
//
//  Created by Andrew Keller on 7/23/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: Thie is the startign screen for the swype it game
//
// Local Controller Import
#import "SIIAPUtility.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "MKStoreKit.h"
// Category Import
// Support/Data Class Imports

// Other Imports

@implementation SIIAPUtility

//#pragma mark - Singleton Method
//+ (instancetype)singleton {
//    static SIIAPUtility *singleton = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        singleton = [[SIIAPUtility alloc] init];
//    });
//    return singleton;
//}
//
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        [self registerForNotifications];
//    }
//    return self;
//}
//
//- (void)registerForNotifications {
//    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(packPurchaseRequest:) name:kSINotificationPackPurchaseRequest object:nil];
//    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification
//                                                      object:nil
//                                                       queue:[[NSOperationQueue alloc] init]
//                                                  usingBlock:^(NSNotification *note) {
//                                                      
//                                                      NSLog(@"Purchased/Subscribed to product with id: %@", [note object]);
//                                                      NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationAdFreePurchasedSucceded object:nil userInfo:nil];
//                                                      [[NSNotificationCenter defaultCenter] postNotification:notification];
//                                                  }];
//    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchaseFailedNotification
//                                                      object:nil
//                                                       queue:[[NSOperationQueue alloc] init]
//                                                  usingBlock:^(NSNotification *note) {
//                                                      
//                                                      NSLog(@"Failed [kMKStoreKitProductPurchaseFailedNotification] with error: %@", [note object]);
//                                                      NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationAdFreePurchasedFailed object:nil userInfo:nil];
//                                                      [[NSNotificationCenter defaultCenter] postNotification:notification];
//                                                  }];
//    
//    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchaseDeferredNotification
//                                                      object:nil
//                                                       queue:[[NSOperationQueue alloc] init]
//                                                  usingBlock:^(NSNotification *note) {
//                                                      
//                                                      NSLog(@"Failed [kMKStoreKitProductPurchaseDeferredNotification] with error: %@", [note object]);
//                                                      NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationAdFreePurchasedFailed object:nil userInfo:nil];
//                                                      [[NSNotificationCenter defaultCenter] postNotification:notification];
//                                                  }];
//    
//    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoredPurchasesNotification
//                                                      object:nil
//                                                       queue:[[NSOperationQueue alloc] init]
//                                                  usingBlock:^(NSNotification *note) {
//                                                      
//                                                      NSLog(@"Restored Purchases");
//                                                      NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationAdFreePurchasedSucceded object:nil userInfo:nil];
//                                                      [[NSNotificationCenter defaultCenter] postNotification:notification];
//                                                  }];
//    
//    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoringPurchasesFailedNotification
//                                                      object:nil
//                                                       queue:[[NSOperationQueue alloc] init]
//                                                  usingBlock:^(NSNotification *note) {
//                                                      
//                                                      NSLog(@"Failed restoring purchases with error: %@", [note object]);
//                                                      NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationAdFreePurchasedFailed object:nil userInfo:nil];
//                                                      [[NSNotificationCenter defaultCenter] postNotification:notification];
//                                                  }];
//}

/**Retuns nil if the product cannot be found*/
+(void)productForSIIAPPack:(SIIAPPack)siiapPack inPackArray:(NSArray *)productArray withBlock:(void (^)(BOOL, SKProduct *))completionBlock {
    BOOL productNotFound    = YES;
    for (SKProduct *product in productArray) {
        NSString *productID = product.productIdentifier;
        if ([productID isEqualToString:[SIGame productIDForSIIAPPack:siiapPack]]) {
            productNotFound = NO;
            if (completionBlock) {
                completionBlock(YES,product);
            }
        }
    }
    if (productNotFound) {
        if (completionBlock) {
            completionBlock(NO,nil);
        }
    }
}

+ (NSDecimalNumber *)productPriceForSIIAPPack:(SIIAPPack)siiapPack {
    switch (siiapPack) {
        case SIIAPPackSmall:
            return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%0.2f",IAP_PACK_PRICE_SMALL]];
        case SIIAPPackMedium:
            return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%0.2f",IAP_PACK_PRICE_MEDIUM]];
        case SIIAPPackLarge:
            return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%0.2f",IAP_PACK_PRICE_LARGE]];
        case SIIAPPackExtraLarge:
            return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%0.2f",IAP_PACK_PRICE_EXTRA_LARGE]];
        default:
            return [NSDecimalNumber decimalNumberWithString:@"0.00"];
    }
}
+ (NSString *)imageNameForSIIAPPack:(SIIAPPack)siiapPack {
    switch (siiapPack) {
        case SIIAPPackSmall:
            return kSIImageIAPSmall;
        case SIIAPPackMedium:
            return kSIImageIAPMedium;
        case SIIAPPackLarge:
            return kSIImageIAPLarge;
        case SIIAPPackExtraLarge:
            return kSIImageIAPExtraLarge;
        default:
            return nil;
    }
}
+ (BOOL)canAffordContinue:(int)continueCost {
    int numberOfItCoins = [[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue];
    if (continueCost <= numberOfItCoins) {
        return YES;
    }
    return NO;
}


@end
