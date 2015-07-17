//
//  SlotItem.h
//  SlotMachineDemo
//
//  Created by Xinling on 26/2/15.
//  Copyright (c) 2015 Xinling. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, SlotItemState)
{
    SlotItemStateStop = 0,
    SlotItemStateStart,
    SlotItemStateStopping,
};

@interface SlotItem : UIView

@property (nonatomic, assign) CGFloat interitemSpacing;
@property (nonatomic, assign) CGSize itemSize;

@property (nonatomic, strong) NSArray* images;

@property (nonatomic, assign, readonly) SlotItemState state;
@property (nonatomic, assign) NSInteger selectedRow;
- (void)start;
- (void)stopAtPosition:(NSInteger)position;
@end
