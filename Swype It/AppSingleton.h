//  AppSingleton.h
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
#import <Foundation/Foundation.h>

@class Game;
@interface AppSingleton : NSObject {
    
}

#pragma mark - Singleton Method
+ (instancetype)singleton;

#pragma mark - Public Properties
@property (assign, nonatomic) BOOL               isSaving;
@property (assign, nonatomic) BOOL               isGameActive;




#pragma mark - Public Objects
@property (strong, nonatomic) Game              *currentGame;
//@property (strong, nonatomic) NSMutableArray    *lalaItemEditWatchers;


#pragma mark - Public Instance Methods
- (void)startGame;
- (void)endGame;
@end