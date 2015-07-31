//
//  MainViewController.h
//  Swype It
//
//  Created by Andrew Keller on 7/19/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
// Framworks
#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
// Dropin Classes
#import "HLSpriteKit.h"


@interface MainViewController : UIViewController

+ (HLLabelButtonNode *)SI_sharedMenuButtonPrototypeBack:(CGSize)size;
+ (HLLabelButtonNode *)SI_sharedMenuButtonPrototypeBasic:(CGSize)size;
+ (HLLabelButtonNode *)SI_sharedMenuButtonPrototypeBasic:(CGSize)size color:(UIColor *)color;

@end
