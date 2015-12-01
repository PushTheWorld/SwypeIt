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
// Category Import
// Support/Data Class Imports

// Other Imports

@implementation SIIAPUtility

#pragma mark - Singleton Method
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
//        //[self registerForNotifications];
//    }
//    return self;
//}
////


/**Retuns nil if the product cannot be found*/
+(void)productForSIIAPPack:(SIIAPPack)siiapPack inPackArray:(NSArray *)productArray withBlock:(void (^)(BOOL, SKProduct *))completionBlock {
    BOOL productNotFound    = YES;
    for (SKProduct *product in productArray) {
        NSString *productID = product.productIdentifier;
        if ([productID isEqualToString:[SIIAPUtility productIDForSIIAPPack:siiapPack]]) {
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
        default:
            return [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%0.2f",IAP_PACK_PRICE_EXTRA_LARGE]];
    }
}
+ (NSString *)imageNameForSIIAPPack:(SIIAPPack)siiapPack {
    switch (siiapPack) {
        case SIIAPPackSmall:
            return kSIAssestIAPPile;
        case SIIAPPackMedium:
            return kSIAssestIAPBucket;
        case SIIAPPackLarge:
            return kSIAssestIAPBag;
        case SIIAPPackExtraLarge:
            return kSIAssestIAPChest;
        default:
            return nil;
    }
}
+ (BOOL)canAffordContinueNumberOfTimesContinued:(int)numberOfTimesContinued {
    int continueCost    = [SIGame lifeCostForNumberOfTimesContinued:numberOfTimesContinued];
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

+ (int)getTomorrowsDailyFreePrizeAmount {
    NSNumber *numberOfConsecutiveDaysLaunched = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultNumberConsecutiveAppLaunches];
    if (!numberOfConsecutiveDaysLaunched) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kSINSUserDefaultNumberConsecutiveAppLaunches];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return 1;
    }
    
    if ([numberOfConsecutiveDaysLaunched intValue] > 30) {
        return 30 * FREE_COINS_PER_DAY;
    }
    
    return ([numberOfConsecutiveDaysLaunched intValue] + 1) * FREE_COINS_PER_DAY;
}

+ (void)increaseConsecutiveDaysLaunched {
    NSNumber *numberOfConsecutiveDaysLaunched = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultNumberConsecutiveAppLaunches];
    [[NSUserDefaults standardUserDefaults] setInteger:[numberOfConsecutiveDaysLaunched integerValue] + 1 forKey:kSINSUserDefaultNumberConsecutiveAppLaunches];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



+ (SKSpriteNode *)createTitleNode:(CGSize)size {
    SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
    backgroundNode.anchorPoint                  = CGPointMake(0.5f, 0.5f);
    
    SKLabelNode *dailyNode                      = [SKLabelNode labelNodeWithFontNamed:kSISFFontDisplayLight];
    dailyNode.text                              = @"DAILY";
    dailyNode.fontColor                         = [SKColor whiteColor];
    dailyNode.fontSize                          = (size.height / 4.0f) - VERTICAL_SPACING_8;
    dailyNode.verticalAlignmentMode             = SKLabelVerticalAlignmentModeBottom;
    dailyNode.horizontalAlignmentMode           = SKLabelHorizontalAlignmentModeRight;
    
    SKLabelNode *prizeNode                      = [SKLabelNode labelNodeWithFontNamed:kSISFFontDisplayLight];
    prizeNode.text                              = @"PRIZE";
    prizeNode.fontColor                         = [SKColor whiteColor];
    prizeNode.fontSize                          = (size.height / 4.0f) - VERTICAL_SPACING_8;
    prizeNode.verticalAlignmentMode             = SKLabelVerticalAlignmentModeTop;
    prizeNode.horizontalAlignmentMode           = SKLabelHorizontalAlignmentModeRight;
    
    SKLabelNode *freeNode                       = [SKLabelNode labelNodeWithFontNamed:kSISFFontDisplayBold];
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
+ (NSString *)buttonNodeNameLabelDescriptionForSIIAPPack:(SIIAPPack)siiapPack {
    switch (siiapPack) {
        case SIIAPPackSmall:
            return kSINodeLabelDescriptionPile;
        case SIIAPPackMedium:
            return kSINodeLabelDescriptionBucket;
        case SIIAPPackLarge:
            return kSINodeLabelDescriptionBag;
        case SIIAPPackExtraLarge:
            return kSINodeLabelDescriptionChest;
        default:
            return nil;
    }
}
+ (NSString *)buttonNodeNameLabelPriceForSIIAPPack:(SIIAPPack)siiapPack {
    switch (siiapPack) {
        case SIIAPPackSmall:
            return kSINodeLabelPricePile;
        case SIIAPPackMedium:
            return kSINodeLabelPriceBucket;
        case SIIAPPackLarge:
            return kSINodeLabelPriceBag;
        case SIIAPPackExtraLarge:
            return kSINodeLabelPriceChest;
        default:
            return nil;
    }
}
+ (NSString *)buttonNodeNameNodeForSIIAPPack:(SIIAPPack)siiapPack {
    switch (siiapPack) {
        case SIIAPPackSmall:
            return kSINodeNodePile;
        case SIIAPPackMedium:
            return kSINodeNodeBucket;
        case SIIAPPackLarge:
            return kSINodeNodeBag;
        case SIIAPPackExtraLarge:
            return kSINodeNodeChest;
        default:
            return nil;
    }
}
+ (NSString *)buttonTextForSIIAPPack:(SIIAPPack)siiapPack {
    NSString *prefix;
    switch (siiapPack) {
        case SIIAPPackSmall:
            prefix = kSIIAPPackNameSmall;
            break;
        case SIIAPPackMedium:
            prefix = kSIIAPPackNameMedium;
            break;
        case SIIAPPackLarge:
            prefix = kSIIAPPackNameLarge;
            break;
        case SIIAPPackExtraLarge:
            prefix = kSIIAPPackNameExtraLarge;
            break;
        default:
            prefix = nil;
            break;
    }
    return [NSString stringWithFormat:@"%@ of Coins",prefix];
}
+ (NSString *)productIDForSIIAPPack:(SIIAPPack)siiapPack {
    switch (siiapPack) {
        case SIIAPPackSmall:
            return kSIIAPProductIDCoinPackSmall;
        case SIIAPPackMedium:
            return kSIIAPProductIDCoinPackMedium;
        case SIIAPPackLarge:
            return kSIIAPProductIDCoinPackLarge;
        case SIIAPPackExtraLarge:
            return kSIIAPProductIDCoinPackExtraLarge;
        default:
            return nil;
    }
}
+ (SIIAPPack)siiapPackForNameNodeNode:(NSString *)nodeName {
    if ([nodeName isEqualToString:kSINodeNodeBag]) {
        return SIIAPPackSmall;
    } else if ([nodeName isEqualToString:kSINodeNodePile]) {
        return SIIAPPackMedium;
    } else if ([nodeName isEqualToString:kSINodeNodeBucket]) {
        return SIIAPPackLarge;
    } else if ([nodeName isEqualToString:kSINodeNodeChest]) {
        return SIIAPPackExtraLarge;
    } else {
        return NUMBER_OF_IAP_PACKS;
    }
}

+ (SIIAPPack)siiapPackForNameNodeLabel:(NSString *)nodeLabelName {
    if ([nodeLabelName isEqualToString:kSINodeLabelDescriptionBag]) {
        return SIIAPPackSmall;
    } else if ([nodeLabelName isEqualToString:kSINodeLabelDescriptionPile]) {
        return SIIAPPackMedium;
    } else if ([nodeLabelName isEqualToString:kSINodeLabelDescriptionBucket]) {
        return SIIAPPackLarge;
    } else if ([nodeLabelName isEqualToString:kSINodeLabelDescriptionChest]) {
        return SIIAPPackExtraLarge;
    } else {
        return NUMBER_OF_IAP_PACKS;
    }
}
+ (int)numberOfCoinsForSIIAPPack:(SIIAPPack)siiapPack {
    switch (siiapPack) {
        case SIIAPPackSmall:
            return 30;
        case SIIAPPackMedium:
            return 200;
        case SIIAPPackLarge:
            return 500;
        case SIIAPPackExtraLarge:
            return 1500;
        default:
            return 0;
    }
}
#pragma mark Daily Prize Methods
+ (void)getDateFromInternetWithCallback:(void (^)(NSDate *))callback {
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
            if (callback) {
                callback(currentDate);
            }
        } else {
            NSLog(@"Could not resolve webpage....");
        }
    } else {
        NSLog(@"Not connected to internet");
    }
    
    if (callback) {
        callback(currentDate);
    }
}

#pragma mark IAP convience methods
+ (int)numberOfCoinsForUser {
    return [[[MKStoreKit sharedKit] availableCreditsForConsumable:kSIIAPConsumableIDCoins] intValue];
}




@end
