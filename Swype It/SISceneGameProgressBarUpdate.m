//
//  SISceneGameProgressBarUpdate.m
//  Swype It
//
//  Created by Andrew Keller on 9/5/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import "SISceneGameProgressBarUpdate.h"

@implementation SISceneGameProgressBarUpdate

- (void)setPercentMove:(float)percentMove {
    if (percentMove < 0.0f) {
        percentMove = 0.0f;
    } else if (percentMove > 1.0f) {
        percentMove = 1.0f;
    }
}

- (void)setPercentPowerUp:(float)percentPowerUp {
    if (percentPowerUp < 0.0f) {
        percentPowerUp = 0.0f;
    } else if (percentPowerUp > 1.0f) {
        percentPowerUp = 1.0f;
    }
}

- (NSString *)textMove {
    return [NSString stringWithFormat:@"%0.2f",_pointsMove];
}

@end