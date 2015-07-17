//
//  InAppPurchasePack.h
//  Swype It
//
//  Created by Andrew Keller on 7/14/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FallingMonkeyView;
@protocol FallingMonkeyViewDelegate <NSObject>

- (void)monkeyWasTapped:(FallingMonkeyView *)fallingMonkeyView;

@end
@interface FallingMonkeyView : UIView

#pragma mark - Delegate Functions
@property (nonatomic, weak) id <FallingMonkeyViewDelegate> delegate;

@end
