//  ProgressBar.m
//  Swype It
//
//  Created by Andrew Keller on 7/25/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: Progress Bar
//
// Local Controller Import
#import "CustomProgressBar.h"
#import "ProgressBar.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
//#import "SIConstants.h"
// Other Imports
// Defines...
#define DEFAULT_PROGRES_BAR_SIZE_HEIGHT     50
#define DEFAULT_PROGRES_BAR_SIZE_WIDTH      250




@interface ProgressBar ()

@property (assign, nonatomic) CGSize             progressBarSize;

@property (strong, nonatomic) SKColor           *progressBarColorBackground;
@property (strong, nonatomic) SKColor           *progressBarColorFill;
@property (strong, nonatomic) CustomProgressBar *customProgressBar;

@end

@implementation ProgressBar

/**Allow default init to be used*/
- (instancetype)init {
    if (self = [super init]) {
        /**Do Iniitalization*/
        [self setupProgressBar:CGSizeMake(DEFAULT_PROGRES_BAR_SIZE_WIDTH, DEFAULT_PROGRES_BAR_SIZE_HEIGHT) progressColor:[UIColor redColor] backgroundColor:[SKColor grayColor] cornerRadius:0];
    }
    return self;
}
///**Allow for default but use color for background*/
- (instancetype)initWithSize:(CGSize)size progressColor:(UIColor *)progressColor backgroundColor:(UIColor *)backgroundColor {
    if (self = [super init]) {
        [self setupProgressBar:size progressColor:progressColor backgroundColor:backgroundColor cornerRadius:0];
    }
    return self;
}
- (instancetype)initWithSize:(CGSize)size progressColor:(UIColor *)progressColor backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius {
    if (self = [super init]) {
        [self setupProgressBar:size progressColor:progressColor backgroundColor:backgroundColor cornerRadius:cornerRadius];
    }
    return self;
}
- (void)setupProgressBar:(CGSize)size progressColor:(UIColor *)progressColor backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius {
    /**Do Iniitalization*/
    self.progressBarSize            = size;
    self.progressBarColorBackground = backgroundColor;
    self.progressBarColorFill       = progressColor;

    
    SKShapeNode *shapeNode;
#ifdef __IPHONE_8_0
    shapeNode  = [SKShapeNode shapeNodeWithRectOfSize:size cornerRadius:cornerRadius];
#else
    shapeNode          = [SKShapeNode node];
    [shapeNode setPath:CGPathCreateWithRoundedRect(CGRectMake(-1.0f * (size.width / 2.0f), -1.0f * (size.height / 2.0f), size.width, size.height), cornerRadius, cornerRadius, nil)];
#endif
    
    shapeNode.fillColor             = backgroundColor;
    
    [self addChild:shapeNode];
    
    [self addCustomProgressBar:size progressColor:progressColor cornerRadius:cornerRadius];
}
- (void)addCustomProgressBar:(CGSize)size progressColor:(UIColor *)progressColor cornerRadius:(CGFloat)cornerRadius {
    self.customProgressBar          = [[CustomProgressBar alloc] initWithSize:size color:progressColor cornerRadius:cornerRadius];
    self.customProgressBar.position = CGPointMake((size.width / 2.0f), 0.0f);
    [self.customProgressBar setProgress:1.0];
    [self addChild:self.customProgressBar];
}
/*progress is 0.0 - 1.0*/
- (void)setProgress:(CGFloat)progress {
    if (progress > 1.0f) {
        progress = 1.0f;
    } else if (progress < 0.0f) {
        progress = 0.0f;
    }
    if (self.customProgressBar) {
        [self.customProgressBar setProgress:progress];
    } else {
        NSLog(@"Error: Cannot set progress for nil bar...");
    }
}


@end
