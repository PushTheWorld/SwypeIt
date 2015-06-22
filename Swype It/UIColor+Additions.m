//  UIColor+Additions.m
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
#import "UIColor+Additions.h"
@implementation UIColor (Additions)

/*The main color for the App*/
+ (UIColor *)mainColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:025.0/255.0 green:147.0/255.0 blue:255.0/255.0 alpha:1.0];
    });
    return color;
}
@end