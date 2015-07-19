//  MSSProgressView.m
//  ProgressViewTesting
//  Created by Michael McEvoy on 12/1/14.
//  Copyright (c) 2014 Mustard Seed Software LLC. All rights reserved.
// Header import
#import "MSSProgressView.h"
// Other imports
//#import "AppDelegate.h"
@interface MSSProgressView () {
    
}

#pragma mark -
#pragma mark - Private Instance Properties
@property (strong, nonatomic) NSLayoutConstraint    *progressOffset;
@property (strong, nonatomic) NSLayoutConstraint    *progressWidth;
@property (strong, nonatomic) UIView                *progressView;

@end
@implementation MSSProgressView

#pragma mark -
#pragma mark - Initializer
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        self.layer.masksToBounds    = YES;
        self.progressView           = [[UIView alloc] init];
        [self.progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.progressView];
        self.progressWidth          = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:self.frame.size.width];
        self.progressOffset         = [NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
        [self addConstraint:self.progressWidth];
        [self addConstraint:self.progressOffset];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:2.0f constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
        //        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:NSLayoutFormatAlignAllLeading metrics:nil views:@{@"view": self.progressView}]];
        self.progress               = 1.0f;
    }
    return self;
}

#pragma mark -
- (void)layoutSubviews {
    [super layoutSubviews];
    self.progressWidth.constant     = self.bounds.size.width;
    NSLog(@"Starting width: %f",self.progressWidth.constant);
//    [self setProgress:self.progress];
}

#pragma mark -
#pragma mark - Custom Accessors
- (void)setBackColor:(UIColor *)backColor {
    _backColor                      = backColor;
    self.backgroundColor            = backColor;
}
- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor                    = borderColor;
    self.layer.borderColor          = borderColor.CGColor;
}
- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth                    = borderWidth;
    self.layer.borderWidth          = borderWidth;
}
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius                           = cornerRadius;
    self.layer.cornerRadius                 = cornerRadius;
    self.progressView.layer.cornerRadius    = cornerRadius * 2.0f;
}
- (void)setProgress:(CGFloat)progress {
    _progress                               = progress;
//    NSLog(@"Percentage remaining: %0.2f",_progress);

    NSLog(@"Progress: %f",progress);
    CGFloat offset                          = (1.0f - progress);
    CGFloat offsetRaw                       = self.frame.size.width * offset;
    self.progressOffset.constant            = -1.0f * offsetRaw;
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:1.0f/3.0f
                     animations:^{
                         [self layoutIfNeeded];
                     }
     ];

}
- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor                      = progressColor;
    self.progressView.backgroundColor   = progressColor;
}

@end