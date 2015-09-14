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
#import "FXReachability.h"
#import "MKStoreKit.h"
#import "SoundManager.h"
// Category Import
// Support/Data Class Imports

// Other Imports

@implementation SIIAPUtility

#pragma mark - Singleton Method
+ (instancetype)singleton {
    static SIIAPUtility *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[SIIAPUtility alloc] init];
    });
    return singleton;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //[self registerForNotifications];
    }
    return self;
}
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

+ (int)getDailyFreePrizeAmount {
    NSNumber *numberOfConsecutiveDaysLaunched = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultNumberConsecutiveAppLaunches];
    if (!numberOfConsecutiveDaysLaunched) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kSINSUserDefaultNumberConsecutiveAppLaunches];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return 1;
    }
    
    if ([numberOfConsecutiveDaysLaunched intValue] > 30) {
        return 30 * FREE_COINS_PER_DAY;
    }
    
    return [numberOfConsecutiveDaysLaunched intValue] * FREE_COINS_PER_DAY;
}

+ (void)increaseConsecutiveDaysLaunched {
    NSNumber *numberOfConsecutiveDaysLaunched = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultNumberConsecutiveAppLaunches];
    [[NSUserDefaults standardUserDefaults] setInteger:[numberOfConsecutiveDaysLaunched integerValue] + 1 forKey:kSINSUserDefaultNumberConsecutiveAppLaunches];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (SKSpriteNode *)createTitleNode:(CGSize)size {
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

#pragma mark Daily Prize Methods
+ (NSDate *)getDateFromInternet {
    NSDate *currentDate = nil;
    
    if ([FXReachability isReachable]) {
        NSURL * scriptUrl = [NSURL URLWithString: @"http://s132342840.onlinehome.us/swypeIt/date.php"];
        NSData * data = [NSData dataWithContentsOfURL: scriptUrl];
        
        if (data) {
            NSString * tempString = [NSString stringWithUTF8String: [data bytes]];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *currentDate = [df dateFromString:tempString];
            //            NSDate * currDate = [NSDate dateWithTimeIntervalSince1970: [tempString doubleValue]];
            //            NSLog (@ "String returned from the site is:%@ and date is:%@", tempString, [currDate description]);
            return currentDate;
        } else {
            NSLog(@"Could not resolve webpage....");
        }
    } else {
        NSLog(@"Not connected to internet");
    }
    
    return currentDate;
}

#pragma mark IAP convience methods
+ (int)numberOfCoinsForUser {
    return [[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue];
}


@end
