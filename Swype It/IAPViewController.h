//  IAPViewController.h
//  Swype It
//
//  Created by Andrew Keller on 7/14/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is the view controller that presents in app purcahses
//
// Local Controller Import
// Framework Import
#import <UIKit/UIKit.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIConstants.h"
// Other Imports
@class IAPTableViewController;
@interface IAPViewController : UIViewController

#pragma mark - Properties
@property (strong, nonatomic) IAPTableViewController *tableViewController;

@end
