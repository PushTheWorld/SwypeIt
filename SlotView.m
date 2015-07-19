//
//  SlotView.m
//  SlotMachineDemo
//
//  Created by Xinling on 26/2/15.
//  Copyright (c) 2015 Xinling. All rights reserved.
//

#import "SlotView.h"
#import "SlotItem.h"

@interface SlotView ()
@property (nonatomic, strong) NSMutableArray* slotItems;
@end

@implementation SlotView
- (NSInteger)numberOfComponents
{
    return self.slotItems.count;
}

- (id)initWithNumberOfComponents:(NSInteger)numberOfComponents
{
    self = [super init];
    if ( self )
    {
        self.slotItems = [[NSMutableArray alloc] init];
        for ( NSInteger i = 0; i < numberOfComponents; i ++ )
        {
            SlotItem* item = [[SlotItem alloc] init];
            item.interitemSpacing = 20;
            [item addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:NULL];
            [self.slotItems addObject:item];
            [self addSubview:item];
        }
    }
    return self;
}

- (void)setSlotImages:(NSArray *)images
{
    _slotImages = images;
    for ( SlotItem* item in self.slotItems )
    {
        item.images = images;
        item.itemSize = [images.firstObject size];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect newframe = self.bounds;
    newframe.size.width /= 3;
    for ( SlotItem* item in self.slotItems )
    {
        item.frame = newframe;
        newframe.origin.x += newframe.size.width;
    }
}

#pragma mark - action
- (void)start
{
    for ( NSInteger i = 0; i < self.slotItems.count; i++ )
    {
        SlotItem* item = self.slotItems[i];
        [item performSelector:@selector(start) withObject:nil afterDelay:0 + 0.3 * i];
    }
}

- (void)stop
{
    for ( NSInteger i = 0; i < self.slotItems.count; i++ )
    {
        [self performSelector:@selector(stopForComponent:) withObject:@(i) afterDelay:0 + 0.3 * i];
    }
}

- (void)stopForComponent:(NSNumber *)component
{
    NSInteger selectedRow = [self.delegate slotView:self selectedRowInComponent:component.integerValue];
    [self.slotItems[component.integerValue] stopAtPosition:selectedRow];
}


- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    NSInteger selectedRow = -1;
    if ( component < self.numberOfComponents )
    {
        selectedRow = [self.slotItems[component] selectedIndex];
    }
    return selectedRow;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( [keyPath isEqualToString:@"state"] )
    {
        BOOL allStop = YES;
        for ( SlotItem* item in self.slotItems )
        {
            if ( item.state != SlotItemStateStop )
            {
                allStop = NO;
                break;
            }
        }
        if ( allStop && [self.delegate respondsToSelector:@selector(stopCompleteInSlotView:)] )
        {
            [self.delegate stopCompleteInSlotView:self];
        }
    }
}




@end
