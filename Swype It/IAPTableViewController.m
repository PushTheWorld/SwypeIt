//  IAPTableViewController.m
//  Swype It
//
//  Created by Andrew Keller on 7/15/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//
//  Purpose: Thie is the startign screen for the swype it game
//
// Local Controller Import
#import "IAPTableViewController.h"
// Framework Import
#import <StoreKit/StoreKit.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "MKStoreKit.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
#import "SIConstants.h"
// Other Imports


@interface IAPTableViewController () {
     NSNumberFormatter * _priceFormatter;
}

@property (strong, nonatomic) NSArray *products;

@end

@implementation IAPTableViewController
static NSString * const reuseIdentifier =  @"cell";

#pragma mark - UI Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell  class] forCellReuseIdentifier:reuseIdentifier];

    self.products = [MKStoreKit sharedKit].availableProducts;
    
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    SKProduct * product = (SKProduct *) self.products[indexPath.row];
    cell.textLabel.text = product.localizedTitle;
    [_priceFormatter setLocale:product.priceLocale];
    cell.detailTextLabel.text = [_priceFormatter stringFromNumber:product.price];
    
    return cell;
}


@end
