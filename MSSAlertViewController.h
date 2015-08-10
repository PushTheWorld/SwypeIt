//  MSSAlertViewController.h
//  AlertViewControllerDemo
//  Created by Michael McEvoy on 2/8/15.
//  Copyright (c) 2015 Mustard Seed Software LLC. All rights reserved.
#import <UIKit/UIKit.h>
@interface MSSAlertViewController : UIViewController {
    
}

#pragma mark -
#pragma mark - Public Class Methods
+ (NSDictionary *)defaultButtonAttributes;
+ (NSDictionary *)messageAttributes;
+ (NSDictionary *)titleAttributes;
+ (void)setDefaultButtonAttributed:(NSDictionary *)buttonAttributes;
+ (void)setMessageAttributes:(NSDictionary *)messageAttributes;
+ (void)setTitleAttributes:(NSDictionary *)titleAttributes;

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message;
+ (instancetype)alertWithAttributedTitle:(NSAttributedString *)title attributedMessage:(NSAttributedString *)message;

#pragma mark -
#pragma mark - Public Instance Methods
- (void)addButtonWithAttributedTitle:(NSAttributedString *)title tapHandler:(void(^)(void))handler;
- (void)addButtonWithTitle:(NSString *)title tapHandler:(void(^)(void))handler;

#pragma mark -
#pragma mark - Properties
@property (assign, nonatomic)           BOOL                 showTextField;
@property (assign, nonatomic)           BOOL                 textFieldSecure;
@property (strong, nonatomic)           NSAttributedString  *attributedMessage;
@property (strong, nonatomic)           NSAttributedString  *attributedTitle;
@property (strong, nonatomic, readonly) NSMutableArray      *buttonInfo;
@property (copy  , nonatomic, readonly) NSString            *enteredText;
@property (copy  , nonatomic)           NSString            *textFieldPlaceholder;

@end