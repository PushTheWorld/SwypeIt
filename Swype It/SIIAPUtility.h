//  SIIAPUtility.h
//  Swype It
//
//  Created by Andrew Keller on 7/23/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: Thie is the startign screen for the swype it game
//
// Local Controller Import
// Framework Import
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIConstants.h"
// Other Imports

#define NUMBER_OF_IAP_PACKS 4

@interface SIIAPUtility : NSObject

/**Retuns nil if the product cannot be found*/
+ (NSDecimalNumber *)productPriceForSIIAPPack:(SIIAPPack)siiapPack;
+ (void)productForSIIAPPack:(SIIAPPack)siiapPack inPackArray:(NSArray *)productArray withBlock:(void (^)(BOOL succeeded, SKProduct *product))completionBlock;

@end
