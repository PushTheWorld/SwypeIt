//  AppSingleton.h
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is the header file for the app singleton
//
// Local Controller Import
// Framework Import
#import <CoreMotion/CoreMotion.h>
#import <Foundation/Foundation.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
// Support/Data Class Imports
#import "SIConstants.h"
// Other Imports

@class Game;
@interface AppSingleton : NSObject {
    
}

#pragma mark - Singleton Method
+ (instancetype)singleton;

#pragma mark - Public Properties
@property (assign, nonatomic) BOOL               isSaving;
//@property (assign, nonatomic) BOOL               isGameActive;




#pragma mark - Public Objects
@property (strong, nonatomic) CMMotionManager   *manager;
@property (strong, nonatomic) Game              *currentGame;

//@property (strong, nonatomic) NSMutableArray    *lalaItemEditWatchers;


#pragma mark - Public Instance Methods
- (void)runFirstGame;
- (void)startGame;
- (void)endGame; /*Should only be used for force quit*/
- (void)moveEnterForType:(Move)move;
- (void)initAppSingletonWithGameMode:(GameMode)gameMode;
@end