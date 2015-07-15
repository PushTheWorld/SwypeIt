//  IAPViewController.m
//  Swype It
//
//  Created by Andrew Keller on 7/14/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: This is the view controller for in app purchases
//
// Local Controller Import
#import "IAPViewController.h"
#import "IAPTableViewController.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "MKStoreKit.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIConstants.h"
// Other Imports


@interface IAPViewController () {
    
}
#pragma mark - Private Properties
@property (strong, nonatomic) UIView    *containerView;

@end

@implementation IAPViewController

#pragma mark - UI Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUserInterface];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)setupUserInterface {
    [self createConstants];
    [self createControls];
    [self setupControls];
    [self layoutControls];
    [self setupNav];
    [self addContainedViewController];
}
- (void)createConstants {
    
}
- (void)createControls {
    self.containerView          = [[UIView alloc] init];
    self.tableViewController    = [[IAPTableViewController alloc] initWithStyle:UITableViewStylePlain];

}
- (void)setupControls {
    [self.containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
}
- (void)layoutControls {
    [self.view addSubview:self.containerView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[container]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"container": self.containerView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[container]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"container": self.containerView}]];
}
- (void)setupNav {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Restore" style:UIBarButtonItemStyleBordered target:self action:@selector(restoreTapped:)];

}
- (void)addContainedViewController {
    [self.tableViewController.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.tableViewController.tableView.backgroundColor  = [UIColor sandColor];
    self.tableViewController.tableView.separatorStyle   = UITableViewCellSeparatorStyleSingleLine;
    [self addChildViewController:self.tableViewController];
    [self.containerView addSubview:self.tableViewController.view];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:@{@"view"         : self.tableViewController.view}]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:@{@"view"         : self.tableViewController.view}]];
    [self.tableViewController didMoveToParentViewController: self];
}

#pragma mark - Private Methods
- (void)restoreTapped:(id)sender {
    [[MKStoreKit sharedKit] restorePurchases];
}

@end
