//
//  SlotItem.m
//  SlotMachineDemo
//
//  Created by Xinling on 26/2/15.
//  Copyright (c) 2015 Xinling. All rights reserved.
//

#import "SlotItem.h"

CGFloat const KMaxSpeed = 15;
CGFloat const KAccelerated = 0.1;

@interface SlotItem ()
@property (nonatomic, strong) NSMutableArray* imageViews;
@property (nonatomic, strong) CADisplayLink* displayLink;

@property (nonatomic, assign) CGFloat moveSpeed;
@property (nonatomic, assign) CGFloat maxOfCenter;
@property (nonatomic, assign) CGFloat accelerated;
@property (nonatomic, assign) NSInteger positionForStop;

@property (nonatomic, assign) SlotItemState state;
@end

@implementation SlotItem

- (void)setState:(SlotItemState)state
{
    [self willChangeValueForKey:@"state"];
    _state = state;
    [self didChangeValueForKey:@"state"];
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    self.imageViews = [[NSMutableArray alloc] initWithCapacity:images.count];
    for ( UIImage* image in images)
    {
        UIImageView* imageView      = [[UIImageView alloc] initWithImage:image];
        imageView.layer.borderColor = [UIColor blueColor].CGColor;
        imageView.layer.borderWidth = 1;
        imageView.contentMode       = UIViewContentModeScaleAspectFit;
        [self.imageViews addObject:imageView];
        [self addSubview:imageView];
    }
}

- (UIColor *)randomColor
{
    return [UIColor colorWithRed:(random() % 255) / 255.0
                           green:(random() % 255) / 255.0
                            blue:(random() % 255) / 255.0
                           alpha:1];
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.clipsToBounds = YES;
        self.moveSpeed = 0;
        self.state = SlotItemStateStop;
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.interitemSpacing = 10;
        self.itemSize = CGSizeMake(50, 50);
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    center.y -= (self.itemSize.height + self.interitemSpacing) * self.imageViews.count / 2;
    
    for ( UIImageView* imageView in self.imageViews )
    {
        imageView.frame = CGRectMake(center.x - self.itemSize.width * 0.5,
                                     center.y - self.itemSize.height * 0.5,
                                     self.itemSize.width,
                                     self.itemSize.height);
        center.y += self.itemSize.height + self.interitemSpacing;
    }
    self.maxOfCenter = center.y + self.itemSize.height * 0.5 + self.interitemSpacing;
}


- (CADisplayLink *)displayLink
{
    if ( !_displayLink )
    {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(autoRun:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        _displayLink.paused = YES;
    }
    return _displayLink;
}

- (void)start
{
    self.state = SlotItemStateStart;
    self.displayLink.paused = NO;
    self.accelerated = KAccelerated;
}

- (void)stopAtPosition:(NSInteger)index
{
    self.selectedRow = index;
    self.accelerated = -KAccelerated;
    self.positionForStop = index;
    self.state = SlotItemStateStopping;
}

- (void)autoRun:(CADisplayLink *)displayLink
{
    for ( UIImageView* imageView in self.imageViews )
    {
        CGPoint center = imageView.center;
        center.y += self.moveSpeed;
        if ( center.y > self.maxOfCenter )
        {
            center.y -= (self.itemSize.height + self.interitemSpacing) * self.imageViews.count;
        }

        imageView.center = center;
    }
    self.moveSpeed = self.accelerated + self.moveSpeed;
    self.moveSpeed = MIN(KMaxSpeed, self.moveSpeed);
    if ( self.state == SlotItemStateStopping )
    {
        self.moveSpeed = MAX(2, self.moveSpeed);
        if ( ABS([self.imageViews[self.positionForStop] center].y - CGRectGetMidY(self.bounds)) < 2)
        {
            self.moveSpeed = 0;
            [self stopAnimation];
        }
    }
    
    if ( 0 == self.moveSpeed )
    {
        displayLink.paused = YES;
    }
}

- (void)stopAnimation
{
    [UIView animateWithDuration:0.25 animations:^{
        for ( NSInteger i = 0; i < self.imageViews.count; i++ )
        {
            UIImageView* imageView = self.imageViews[i];
            CGPoint center = imageView.center;
            center.y = CGRectGetMidY(self.bounds) + (i - self.positionForStop) * (self.itemSize.height + self.interitemSpacing);
            if ( center.y > self.maxOfCenter )
            {
                center.y -= (self.itemSize.height + self.interitemSpacing) * self.imageViews.count;
            }
            imageView.center = center;
        }
    } completion:^(BOOL finished) {
        self.state = SlotItemStateStop;
    }];
}
@end
