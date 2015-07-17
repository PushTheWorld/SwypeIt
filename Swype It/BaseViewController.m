//  BaseViewController.m
//  lala
//  Created by Andrew Keller on 2/27/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
// Header Impoer
#import "BaseViewController.h"
// Other Imports
#import "UIColor+Additions.h"
@interface BaseViewController ()

@end

@implementation BaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
