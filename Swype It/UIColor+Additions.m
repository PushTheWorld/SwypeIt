//  UIColor+Additions.m
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
#import "UIColor+Additions.h"
@implementation UIColor (Additions)

/*The main color for the App*/
+ (UIColor *)backgroundColorForLevelOneA { /*Rasta Green*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:035.0/255.0 green:177.0/255.0 blue:077.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelOneB { /*Clemson Orange*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:241.0/255.0 green:092.0/255.0 blue:043.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelOneC { /*Barley Blue*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:025.0/255.0 green:147.0/255.0 blue:255.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelTwoA { /*Camo Darkest Green*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:041.0/255.0 green:051.0/255.0 blue:040.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelTwoB { /*Camo Dark Green*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:083.0/255.0 green:093.0/255.0 blue:070.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelTwoC { /*Camo Light Green*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:142.0/255.0 green:149.0/255.0 blue:092.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelThreeA { /*Medium Green*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:024.0/255.0 green:153.0/255.0 blue:024.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelThreeB { /*BC Color*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:102.0/255.0 green:000.0/255.0 blue:000.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelThreeC { /*Navy Color*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:010.0/255.0 green:010.0/255.0 blue:060.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelFourA { /*Light Blue*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:037.0/255.0 green:200.0/255.0 blue:255.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelFourB { /*Magenta*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:245.0/255.0 green:000.0/255.0 blue:254.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelFourC { /*Light Green*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:101.0/255.0 green:176.0/255.0 blue:081.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelFiveA { /*Sunset 1A*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:125.0/255.0 green:056.0/255.0 blue:255.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelFiveB { /*Sunset 1B*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:079.0/255.0 green:043.0/255.0 blue:061.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelFiveC { /*Sunset 1C*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:223.0/255.0 green:096.0/255.0 blue:034.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelSixA { /*Sunset 2A*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:253.0/255.0 green:174.0/255.0 blue:125.0/051.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelSixB { /*Sunset 2B*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:114.0/255.0 green:047.0/255.0 blue:064.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelSixC { /*Sunset 2C*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:070.0/255.0 green:047.0/255.0 blue:070.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelSevenA { /*Sunset 3A*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:238.0/255.0 green:103.0/255.0 blue:100.0/051.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelSevenB { /*Sunset 3B*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:046.0/255.0 green:054.0/255.0 blue:089.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelSevenC { /*Sunset 3C*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:178.0/255.0 green:058.0/255.0 blue:086.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelEightA { /*Mountain 1A*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:179.0/255.0 green:146.0/255.0 blue:110.0/051.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelEightB { /*Mountain 1B*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:069.0/255.0 green:050.0/255.0 blue:048.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelEightC { /*Mountain 1C*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:088.0/255.0 green:082.0/255.0 blue:044.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelNineA { /*Mountain 2A*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:037.0/255.0 green:051.0/255.0 blue:027.0/051.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelNineB { /*Mountain 2B*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:069.0/255.0 green:094.0/255.0 blue:043.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelNineC { /*Mountain 2C*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:175.0/255.0 green:163.0/255.0 blue:076.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelTenA { /*Mountain 3A*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:098.0/255.0 green:111.0/255.0 blue:135.0/051.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelTenB { /*Mountain 3B*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:120.0/255.0 green:134.0/255.0 blue:113.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelTenC { /*Mountain 3C*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:156.0/255.0 green:157.0/255.0 blue:162.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelElevenA { /*City 1A New York*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:000.0/255.0 green:033.0/255.0 blue:110.0/051.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelElevenB { /*City 1B*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:085.0/255.0 green:046.0/255.0 blue:065.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelElevenC { /*City 1C*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:243.0/255.0 green:173.0/255.0 blue:113.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelTwelveA { /*City 2A*/ /*Paris*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:234.0/255.0 green:146.0/255.0 blue:023.0/051.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelTwelveB { /*City 2B*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:091.0/255.0 green:027.0/255.0 blue:014.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelTwelveC { /*City 2C*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:011.0/255.0 green:024.0/255.0 blue:004.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelThirteenA { /*City 3A*/ /*Thialand*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:131.0/255.0 green:162.0/255.0 blue:136.0/051.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelThirteenB { /*City 3B*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:093.0/255.0 green:152.0/255.0 blue:077.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)backgroundColorForLevelThirteenC { /*City 3C*/
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:233.0/255.0 green:179.0/255.0 blue:172.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)goldColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:255.0/255.0 green:206.0/255.0 blue:053.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)mainColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:025.0/255.0 green:147.0/255.0 blue:255.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)sandColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:230.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)simplstMainColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:240.0/255.0 green:085.0/255.0 blue:020.0/255.0 alpha:1.0];
    });
    return color;
}
+ (UIColor *)royalBlueColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:000.0/255.0 green:035.0/255.0 blue:02.0/255.0 alpha:1.0];
    });
    return color;
}
@end