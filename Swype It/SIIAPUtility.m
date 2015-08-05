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
// Category Import
// Support/Data Class Imports

// Other Imports

@implementation SIIAPUtility

/**Retuns nil if the product cannot be found*/
+(void)productForSIIAPPack:(SIIAPPack)siiapPack inPackArray:(NSArray *)productArray withBlock:(void (^)(BOOL, SKProduct *))completionBlock {
    BOOL productNotFound    = YES;
    for (SKProduct *product in productArray) {
        NSString *productID = product.productIdentifier;
        if ([productID isEqualToString:[Game productIDForSIIAPPack:siiapPack]]) {
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

@end
