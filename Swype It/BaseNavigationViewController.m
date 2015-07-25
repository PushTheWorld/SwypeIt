//  BaseNavigationViewController.m
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
#import "BaseNavigationViewController.h"
#import "UIColor+Additions.h"
@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setColorsOfNavBar];
}
- (void)setColorsOfNavBar {

}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end