//
//  SISceneGameProgressBarUpdate.h
//  Swype It
//
//  Created by Andrew Keller on 9/5/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SISceneGameProgressBarUpdate : NSObject

/**
 The move progress bar percent. 0.0f to 1.0f
 */
@property (nonatomic, assign) float percentMove;

/**
 The power up progress bar percent. 0.0f to 1.0f
 */
@property (nonatomic, assign) float percentPowerUp;

/**
 The free coin progress bar percent. 0.0f to 1.0f
 */
@property (nonatomic, assign) float percentFreeCoin;

/**
 The amounts of points left
 
 */
@property (nonatomic, assign) float pointsMove;

/**
 The move bar text
 */
@property (nonatomic, strong) NSString *textMove;

/**
 The
 */
@property (nonatomic, assign) BOOL hasStarted;


@end
