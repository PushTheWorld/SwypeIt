//
//  SlotView.h
//  SlotMachineDemo
//
//  Created by Xinling on 26/2/15.
//  Copyright (c) 2015 Xinling. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlotView;

@protocol SlotViewDelegate <NSObject>

@required
- (NSInteger)slotView:(SlotView *)slotView selectedRowInComponent:(NSInteger)component;


@optional
- (void)stopCompleteInSlotView:(SlotView *)slotView;

@end

@interface SlotView : UIView
@property (nonatomic, assign, readonly) NSInteger numberOfComponents;
@property (nonatomic, strong) NSArray* slotImages;

@property (nonatomic, weak) id<SlotViewDelegate> delegate;

- (id)initWithNumberOfComponents:(NSInteger)numberOfComponents;
- (NSInteger)selectedRowInComponent:(NSInteger)component;

- (void)start;
- (void)stop;
@end
