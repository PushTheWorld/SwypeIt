//  StoreScene.h
//  Swype It
//
//  Created by Andrew Keller on 7/21/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
#import <SpriteKit/SpriteKit.h>

@interface StoreScene : HLScene

- (instancetype)initWithSize:(CGSize)size willAwardPrize:(BOOL)willAwardPrize;

@property (assign, nonatomic) BOOL     isInTestMode;
@property (assign, nonatomic) BOOL     wasLaunchedFromMainMenu;



@end
