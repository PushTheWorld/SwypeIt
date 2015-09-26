//  Game.m
//  Swype It
//  Created by Andrew Keller on 6/26/15.
//  Copyright (c) 2015 Push The World LLC. All rights reserved.
//
//  Purpose: Singleton file for a game, there can only be one game played at a time.
//

// Local Controller Import
#import "SIGame.h"
// Framework Import
#import <math.h>
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
// Category Import
#import "UIImage+BlurredFrame.h"
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports


@interface SIGame () {
    
}

@end

@implementation SIGame

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        // Do setup here for new game
        self.gameMode = SIGameModeTwoHand;
        _powerUpArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Class Methods
+ (float)scoreForMoveDuration:(NSTimeInterval)durationOfLastMove withLevelSpeedDivider:(float)levelSpeedDivider {
//    NSLog(@"Duration of last move: %0.2f",durationOfLastMove);
    return MAX_MOVE_SCORE * exp(SCORE_EXP_POWER_WEIGHT * (durationOfLastMove * MILI_SECS_IN_SEC) / levelSpeedDivider);
}
+ (int)nextLevelForScore:(float)score {
    int levelScore = 0;
    
    if (score < LEVEL1) {
        levelScore  = LEVEL1;
    } else if (score < LEVEL2) {
        levelScore  = LEVEL2;
    } else if (score < LEVEL3) {
        levelScore  = LEVEL3;
    } else if (score < LEVEL4) {
        levelScore  = LEVEL4;
    } else if (score < LEVEL5) {
        levelScore  = LEVEL5;
    } else if (score < LEVEL6) {
        levelScore  = LEVEL6;
    } else if (score < LEVEL7) {
        levelScore  = LEVEL7;
    } else if (score < LEVEL8) {
        levelScore  = LEVEL8;
    } else if (score < LEVEL9) {
        levelScore  = LEVEL9;
    } else if (score < LEVEL10) {
        levelScore  = LEVEL10;
    } else if (score < LEVEL11) {
        levelScore  = LEVEL11;
    } else if (score < LEVEL12) {
        levelScore  = LEVEL12;
    } else if (score < LEVEL13) {
        levelScore  = LEVEL13;
    } else if (score < LEVEL14) {
        levelScore  = LEVEL14;
    } else if (score < LEVEL15) {
        levelScore  = LEVEL15;
    } else if (score < LEVEL16) {
        levelScore  = LEVEL16;
    } else if (score < LEVEL17) {
        levelScore  = LEVEL17;
    } else if (score < LEVEL18) {
        levelScore  = LEVEL18;
    } else if (score < LEVEL19) {
        levelScore  = LEVEL19;
    } else if (score < LEVEL20) {
        levelScore  = LEVEL20;
    } else {
        levelScore  = [SIGame numberLevelForScore:score];
    }
    return levelScore;
}
+ (int)numberLevelForScore:(float)score {
    int numberLevel = (int)score / 1000;
    numberLevel     = numberLevel + 1;
    numberLevel     = numberLevel * 1000;
    return numberLevel;
}
+ (NSString *)currentLevelStringForScore:(float)score {
    int numberLevel = 0;
    if (score < LEVEL1) {
        numberLevel = 1;
    } else if (score < LEVEL2) {
        numberLevel = 2;
    } else if (score < LEVEL3) {
        numberLevel = 3;
    } else if (score < LEVEL4) {
        numberLevel = 4;
    } else if (score < LEVEL5) {
        numberLevel = 5;
    } else if (score < LEVEL6) {
        numberLevel = 6;
    } else if (score < LEVEL7) {
        numberLevel = 7;
    } else if (score < LEVEL8) {
        numberLevel = 8;
    } else if (score < LEVEL9) {
        numberLevel = 9;
    } else if (score < LEVEL10) {
        numberLevel = 10;
    } else if (score < LEVEL11) {
        numberLevel = 11;
    } else if (score < LEVEL12) {
        numberLevel = 12;
    } else if (score < LEVEL13) {
        numberLevel = 13;
    } else if (score < LEVEL14) {
        numberLevel = 14;
    } else if (score < LEVEL15) {
        numberLevel = 15;
    } else if (score < LEVEL16) {
        numberLevel = 16;
    } else if (score < LEVEL17) {
        numberLevel = 17;
    } else if (score < LEVEL18) {
        numberLevel = 18;
    } else if (score < LEVEL19) {
        numberLevel = 19;
    } else if (score < LEVEL20) {
        numberLevel = 20;
    }else {
        numberLevel = ([SIGame numberLevelForScore:score]/1000) + 10;
    }
    
    return [NSString stringWithFormat:@"Level %d",numberLevel];
}

/*AUTO TESTED*/
+ (NSString *)stringForMove:(SIMoveCommand)move {
    switch (move) {
        case SIMoveCommandTap:
            return kSIMoveCommandTap;
        case SIMoveCommandSwype:
            return kSIMoveCommandSwype;
        case SIMoveCommandPinch:
            return kSIMoveCommandPinch;
        case SIMoveCommandShake:
            return kSIMoveCommandShake;
        default:
            return nil;
    }
}

+ (UIColor *)backgroundColorForScore:(float)score forRandomNumber:(NSInteger)randomNumber {
    if (score < LEVEL1) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelOneA];
            case 1:
                return [UIColor backgroundColorForLevelOneB];
            default:
                return [UIColor backgroundColorForLevelOneC];
        }
    } else if (score < LEVEL2) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelTwoA];
            case 1:
                return [UIColor backgroundColorForLevelTwoB];
            default:
                return [UIColor backgroundColorForLevelTwoC];
        }
    } else if (score < LEVEL3) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelThreeA];
            case 1:
                return [UIColor backgroundColorForLevelThreeB];
            default:
                return [UIColor backgroundColorForLevelThreeC];
        }
    } else if (score < LEVEL4) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelFourA];
            case 1:
                return [UIColor backgroundColorForLevelFourB];
            default:
                return [UIColor backgroundColorForLevelFourC];
        }
    } else if (score < LEVEL5) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelFiveA];
            case 1:
                return [UIColor backgroundColorForLevelFiveB];
            default:
                return [UIColor backgroundColorForLevelFiveC];
        }
    } else if (score < LEVEL6) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelSixA];
            case 1:
                return [UIColor backgroundColorForLevelSixB];
            default:
                return [UIColor backgroundColorForLevelSixC];
        }
    } else if (score < LEVEL7) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelSevenA];
            case 1:
                return [UIColor backgroundColorForLevelSevenB];
            default:
                return [UIColor backgroundColorForLevelSevenC];
        }
    } else if (score < LEVEL8) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelEightA];
            case 1:
                return [UIColor backgroundColorForLevelEightB];
            default:
                return [UIColor backgroundColorForLevelEightC];
        }
    } else if (score < LEVEL9) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelNineA];
            case 1:
                return [UIColor backgroundColorForLevelNineB];
            default:
                return [UIColor backgroundColorForLevelNineC];
        }
    } else if (score < LEVEL10) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelTenA];
            case 1:
                return [UIColor backgroundColorForLevelTenB];
            default:
                return [UIColor backgroundColorForLevelTenC];
        }
    } else if (score < LEVEL11) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelElevenA];
            case 1:
                return [UIColor backgroundColorForLevelElevenB];
            default:
                return [UIColor backgroundColorForLevelElevenC];
        }
    } else if (score < LEVEL12) {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelTwelveA];
            case 1:
                return [UIColor backgroundColorForLevelTwelveB];
            default:
                return [UIColor backgroundColorForLevelTwelveC];
        }
    } else {
        switch (randomNumber) {
            case 0:
                return [UIColor backgroundColorForLevelOneA];
            case 1:
                return [UIColor backgroundColorForLevelTwoB];
            case 2:
                return [UIColor backgroundColorForLevelThreeC];
            case 3:
                return [UIColor backgroundColorForLevelFourA];
            case 4:
                return [UIColor backgroundColorForLevelSixB];
            case 5:
                return [UIColor backgroundColorForLevelSevenC];
            case 6:
                return [UIColor backgroundColorForLevelEightA];
            case 7:
                return [UIColor backgroundColorForLevelNineB];
            case 8:
                return [UIColor backgroundColorForLevelTenC];
            default:
                return [UIColor backgroundColorForLevelElevenB];
        }
    }
}

+ (SIMoveCommand)getRandomMoveForGameMode:(SIGameMode)gameMode {
    NSInteger randomNumber = arc4random_uniform(NUMBER_OF_MOVES);
    switch (randomNumber) {
        case 0:
            return SIMoveCommandTap;
        case 1:
            return SIMoveCommandSwype;
        default:
            if (gameMode == SIGameModeOneHand) {
                return SIMoveCommandShake;
            } else { /*GameModeTwoHane*/
                return SIMoveCommandPinch;
            }
    }
}
+ (SIContinueLifeCost)lifeCostForNumberOfTimesContinued:(int)numberOfTimesContinued {
    switch (numberOfTimesContinued) {
        case 1:
            return SIContinueLifeCost1;
        case 2:
            return SIContinueLifeCost2;
        case 3:
            return SIContinueLifeCost3;
        case 4:
            return SIContinueLifeCost4;
        case 5:
            return SIContinueLifeCost5;
        case 6:
            return SIContinueLifeCost6;
        case 7:
            return SIContinueLifeCost7;
        case 8:
            return SIContinueLifeCost8;
        case 9:
            return SIContinueLifeCost9;
        case 10:
            return SIContinueLifeCost10;
        case 11:
            return SIContinueLifeCost11;
        case 12:
            return SIContinueLifeCost12;
        case 13:
            return SIContinueLifeCost13;
        case 14:
            return SIContinueLifeCost14;
        case 15:
            return SIContinueLifeCost15;
        case 16:
            return SIContinueLifeCost16;
        case 17:
            return SIContinueLifeCost17;
        case 18:
            return SIContinueLifeCost18;
        case 19:
            return SIContinueLifeCost19;
        case 20:
            return SIContinueLifeCost20;
        case 21:
            return SIContinueLifeCost21;
        default:
            return SIContinueLifeCost1;
    }
}
+ (SIContinueAdCount)adCountForNumberOfTimesContinued:(int)numberOfTimesContinued {
    switch (numberOfTimesContinued) {
        case 1:
            return SIContinueAdCount1;
        case 2:
            return SIContinueAdCount2;
        case 3:
            return SIContinueAdCount3;
        case 4:
            return SIContinueAdCount4;
        case 5:
            return SIContinueAdCount5;
        case 6:
            return SIContinueAdCount6;
        case 7:
            return SIContinueAdCount7;
        case 8:
            return SIContinueAdCount8;
        case 9:
            return SIContinueAdCount9;
        case 10:
            return SIContinueAdCount10;
        case 11:
            return SIContinueAdCount11;
        case 12:
            return SIContinueAdCount12;
        case 13:
            return SIContinueAdCount13;
        case 14:
            return SIContinueAdCount14;
        case 15:
            return SIContinueAdCount15;
        case 16:
            return SIContinueAdCount16;
        case 17:
            return SIContinueAdCount17;
        case 18:
            return SIContinueAdCount18;
        case 19:
            return SIContinueAdCount19;
        case 20:
            return SIContinueAdCount20;
        case 21:
            return SIContinueAdCount21;
        default:
            return SIContinueAdCount1;
    }
}

+ (void)incrementGamesPlayedWithNSUserDefaults:(NSUserDefaults *)defaults {
    NSInteger gamesPlayed = [defaults integerForKey:kSINSUserDefaultLifetimeGamesPlayed];
    [defaults setInteger:gamesPlayed + 1 forKey:kSINSUserDefaultLifetimeGamesPlayed];
    [defaults synchronize];
}

+ (SIBackgroundSound)backgroundSoundForScore:(float)score {
    if (score < SOUNDLEVEL1) {
        return SIBackgroundSoundOne;
    } else if (score < SOUNDLEVEL2) {
        return SIBackgroundSoundTwo;
    } else if (score < SOUNDLEVEL3) {
        return SIBackgroundSoundThree;
    } else if (score < SOUNDLEVEL4) {
        return SIBackgroundSoundFour;
    } else if (score < SOUNDLEVEL5) {
        return SIBackgroundSoundFive;
    } else {
        if ((int)score % SOUNDLEVEL5 < (SOUNDLEVEL5 / 2)) {
            return SIBackgroundSoundFour;
        } else {
            return SIBackgroundSoundFive;
        }
    }
}

+ (NSString *)soundNameForSIBackgroundSound:(SIBackgroundSound)siBackgroundSound {
    switch (siBackgroundSound) {
        case SIBackgroundSoundMenu:
            return kSISoundBackgroundMenu;
        case SIBackgroundSoundOne:
            return kSISoundBackgroundOne;
        case SIBackgroundSoundTwo:
            return kSISoundBackgroundTwo;
        case SIBackgroundSoundThree:
            return kSISoundBackgroundThree;
        case SIBackgroundSoundFour:
            return kSISoundBackgroundFour;
        case SIBackgroundSoundFive:
            return kSISoundBackgroundFive;
        case SIBackgroundSoundSix:
            return kSISoundBackgroundSix;
        case SIBackgroundSoundSeven:
            return kSISoundBackgroundSeven;
        default:
            return kSISoundBackgroundMenu;
    }
}

+ (NSString *)userMessageForScore:(float)score isHighScore:(BOOL)isHighScore highScore:(float)highScore {
    float scorePercent = score / highScore;
    NSUInteger randomNumber = 0;
    if (isHighScore) {
        randomNumber = arc4random_uniform((int)[[SIConstants userMessageHighScore] count]);
        return [SIConstants userMessageHighScore][randomNumber];
    } else if (scorePercent > 0.9) {
        randomNumber = arc4random_uniform((int)[[SIConstants userMessageHighScoreClose] count]);
        return [SIConstants userMessageHighScoreClose][randomNumber];
    } else if (scorePercent > 0.4) {
        randomNumber = arc4random_uniform((int)[[SIConstants userMessageHighScoreMedian] count]);
        return [SIConstants userMessageHighScoreMedian][randomNumber];
    } else {
        randomNumber = arc4random_uniform((int)[[SIConstants userMessageHighScoreBad] count]);
        return [SIConstants userMessageHighScoreBad][randomNumber];
    }
}

#pragma mark - Private Class Methods
+ (float)levelSpeedForScore:(float)score {
    if (score < MAX_MOVE_SCORE) {
        return 4.0f;
    } else if (score < SPEED_TRANSISTION_SCORE) {
        return SPEED_POWER_MULTIPLIER * pow(score,SPEED_POWER_EXPONENT);
    } else {
        return SPEED_LOG_MULTIPLIER * log(score) + SPEED_LOG_INTERCEPT;
    }
}
+ (UIImage *)getBluredScreenshot:(SKView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 1);
    [view drawViewHierarchyInRect:view.frame afterScreenUpdates:NO];
    UIImage *ss = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [ss applyLightEffectAtFrame:view.frame];
//    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [gaussianBlurFilter setDefaults];
//    [gaussianBlurFilter setValue:[CIImage imageWithCGImage:[ss CGImage]] forKey:kCIInputImageKey];
//    [gaussianBlurFilter setValue:@10 forKey:kCIInputRadiusKey];
//    
//    CIImage *outputImage = [gaussianBlurFilter outputImage];
//    CIContext *context   = [CIContext contextWithOptions:nil];
//    CGRect rect          = [outputImage extent];
//    rect.origin.x        += (rect.size.width  - ss.size.width ) / 2;
//    rect.origin.y        += (rect.size.height - ss.size.height) / 2;
//    rect.size            = ss.size;
//    CGImageRef cgimg     = [context createCGImage:outputImage fromRect:rect];
//    UIImage *image       = [UIImage imageWithCGImage:cgimg];
//    CGImageRelease(cgimg);
//    return image;
}

#pragma mark - Public Methods
- (NSNumber *)getNextLevelScore {
    return [NSNumber numberWithFloat:[SIGame nextLevelForScore:self.totalScore]];
}
- (NSString *)getCurrentLevelString {
    return [SIGame currentLevelStringForScore:self.totalScore];
}

+ (SKTexture *)textureBackgroundColor:(SKColor *)backgroundColor size:(CGSize)size {
    CAShapeLayer *shapeLayer    = [CAShapeLayer layer];
    shapeLayer.frame            = CGRectMake(0, 0, size.width, size.height);
    shapeLayer.fillColor        = backgroundColor.CGColor;
    
    return [SIGame textureFromLayer:shapeLayer];
}

+ (SKTexture *)textureLeftSegmentButtonColor:(SKColor *)backgroundColor size:(CGSize)size cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    UIBezierPath *maskPath      = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius];
    
    CAShapeLayer *shapeLayer    = [CAShapeLayer layer];
    shapeLayer.frame            = CGRectMake(0, 0, size.width, size.height);
    shapeLayer.path             = maskPath.CGPath;
    shapeLayer.fillColor        = backgroundColor.CGColor;
    shapeLayer.strokeColor      = borderColor.CGColor;
    shapeLayer.lineWidth        = borderWidth;
    shapeLayer.cornerRadius     = cornerRadius;
    shapeLayer.masksToBounds    = YES;
    
    return [SIGame textureFromLayer:shapeLayer];
}

+ (SKTexture *)textureBackgroundColor:(SKColor *)backgroundColor size:(CGSize)size cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    UIBezierPath *maskPath      = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius];
    
    CAShapeLayer *shapeLayer    = [CAShapeLayer layer];
    shapeLayer.frame            = CGRectMake(0, 0, size.width, size.height);
    shapeLayer.path             = maskPath.CGPath;
    shapeLayer.fillColor        = backgroundColor.CGColor;
    shapeLayer.strokeColor      = borderColor.CGColor;
    shapeLayer.lineWidth        = borderWidth;
    shapeLayer.cornerRadius     = cornerRadius;
    shapeLayer.masksToBounds    = YES;
    
    return [SIGame textureFromLayer:shapeLayer];
}

// note: we are going from CALayer -> UIImage -> SKTexture here, so that we can create SKSpriteNodes instead of SKShapeNodes
// (SKShapeNode doesn't work well with SKCropNode), which are then plugged into the maskNode property of a SKCropNode.
+ (SKTexture *)textureFromLayer:(CALayer *)layer {
    CGFloat width = layer.frame.size.width;
    CGFloat height = layer.frame.size.height;
    
    // value of 0 for scale will use device's main screen scale
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, width, height));
    
    [layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    SKTexture *texture = [SKTexture textureWithImage:image];
    
    return texture;
}

+ (SKTexture *)textureForSIPowerUp:(SIPowerUpType)powerUp {
    switch (powerUp) {
        case SIPowerUpTypeFallingMonkeys:
            return [[SIConstants buttonAtlas] textureNamed:kSIImageFallingMonkeys];
        case SIPowerUpTypeRapidFire:
            return [[SIConstants imagesAtlas] textureNamed:kSIImageButtonRapidFire];
        case SIPowerUpTypeTimeFreeze:
            return [[SIConstants imagesAtlas] textureNamed:kSIImageButtonTimeFreeze];
        default:
            return nil;
    }
}
+ (SKAction *)actionForSIMoveCommandAction:(SIMoveCommandAction)siMoveCommandAction {
    
    SKAction *fadeOut               = [SKAction fadeOutWithDuration:MOVE_COMMAND_LAUNCH_DURATION];
    
    SKAction *leftShakeComponent    = [SKAction moveByX:50.0f y:0.0f duration:MOVE_COMMAND_LAUNCH_DURATION / 4.0f];
    SKAction *rightShakeComponent   = [SKAction moveByX:-100.0f y:0.0f duration:MOVE_COMMAND_LAUNCH_DURATION / 4.0f];
    SKAction *shakeRepeat           = [SKAction repeatAction:[SKAction sequence:@[leftShakeComponent, rightShakeComponent]] count:2];
    
    SKAction *tapIn1                = [SKAction scaleTo:0.9f duration:MOVE_COMMAND_LAUNCH_DURATION / 4.0f];
    SKAction *tapOut1               = [SKAction scaleTo:1.1f duration:MOVE_COMMAND_LAUNCH_DURATION / 4.0f];
    SKAction *tapIn2                = [SKAction scaleTo:0.7f duration:MOVE_COMMAND_LAUNCH_DURATION / 4.0f];
    SKAction *tapOut2               = [SKAction scaleTo:1.3f duration:MOVE_COMMAND_LAUNCH_DURATION / 4.0f];
    SKAction *tapAction             = [SKAction sequence:@[tapIn1,tapOut1,tapIn2,tapOut2]];
    
    SKAction *swypeUp               = [SKAction moveToY:SCREEN_HEIGHT + 100.0f duration:MOVE_COMMAND_LAUNCH_DURATION];
    SKAction *swypeDown             = [SKAction moveToY:-100.0f duration:MOVE_COMMAND_LAUNCH_DURATION];
    SKAction *swypeLeft             = [SKAction moveToX:-100.0f duration:MOVE_COMMAND_LAUNCH_DURATION];
    SKAction *swypeRight            = [SKAction moveToX:SCREEN_WIDTH + 100.0f duration:MOVE_COMMAND_LAUNCH_DURATION];
    
    SKAction *pinchShrink           = [SKAction scaleTo:0.0f duration:MOVE_COMMAND_LAUNCH_DURATION];
    SKAction *pinchRotateCW         = [SKAction rotateByAngle:M_PI duration:MOVE_COMMAND_LAUNCH_DURATION];
    SKAction *pinchRotateCCW        = [SKAction rotateByAngle:-M_PI duration:MOVE_COMMAND_LAUNCH_DURATION];
    
    switch (siMoveCommandAction) {
        case SIMoveCommandActionPinchNegative:
            return [SKAction group:@[pinchShrink,fadeOut,pinchRotateCCW]];
        case SIMoveCommandActionPinchPositive:
            return [SKAction group:@[pinchShrink,fadeOut,pinchRotateCW]];
        case SIMoveCommandActionShake:
            return [SKAction group:@[shakeRepeat,fadeOut]];
        case SIMoveCommandActionTap:
            return [SKAction group:@[tapAction,fadeOut]];
        case SIMoveCommandActionSwypeUp:
            return [SKAction group:@[swypeUp,fadeOut]];
        case SIMoveCommandActionSwypeDown:
            return [SKAction group:@[swypeDown,fadeOut]];
        case SIMoveCommandActionSwypeLeft:
            return [SKAction group:@[swypeLeft,fadeOut]];
        case SIMoveCommandActionSwypeRight:
            return [SKAction group:@[swypeRight,fadeOut]];
        default:
            return fadeOut;
    }
}

+ (SIBackgroundSound)checkBackgroundSound:(SIBackgroundSound)currentBackgroundSound forTotalScore:(float)totalScore withCallback:(void (^)(BOOL updatedBackgroundSound, SIBackgroundSound backgroundSound))callback {
    SIBackgroundSound newBackgroundSound = [SIGame backgroundSoundForScore:totalScore];
    if (newBackgroundSound != currentBackgroundSound) {
        if (callback) {
            callback(YES, newBackgroundSound);
        }
        return newBackgroundSound;
    } else {
        if (callback) {
            callback(NO, currentBackgroundSound);
        }
        return currentBackgroundSound;
    }
}

/**
 High score is separated from lifetime points to allow for the user to reset their 'Device High Score'
 */
+ (BOOL)isDevieHighScore:(float)totalScore withNSUserDefaults:(NSUserDefaults *)defaults {
    NSNumber *deviceHighScore                 = [defaults objectForKey:kSINSUserDefaultLifetimeHighScore];
    if (deviceHighScore == nil) {
        [defaults setObject:[NSNumber numberWithFloat:totalScore] forKey:kSINSUserDefaultLifetimeHighScore];
        [defaults synchronize];
        return YES;
    } else {
        if (totalScore > [deviceHighScore floatValue]) {
            [defaults setObject:[NSNumber numberWithFloat:totalScore] forKey:kSINSUserDefaultLifetimeHighScore];
            [defaults synchronize];
            return YES;
        }
    }
    return NO;
}

/**
 Total points ever played
 this cannot be reset by the user
 */
+ (void)updateLifetimePointsScore:(float)totalScore withNSUserDefaults:(NSUserDefaults *)defaults {
    NSLog(@"%@",[defaults objectForKey:kSINSUserDefaultLifetimePointsEarned]);
    NSNumber *lifeTimePointsEarned              = [defaults objectForKey:kSINSUserDefaultLifetimePointsEarned];
    if (lifeTimePointsEarned == nil) {
        [defaults setObject:[NSNumber numberWithFloat:totalScore] forKey:kSINSUserDefaultLifetimePointsEarned];
    } else {
        lifeTimePointsEarned                    = [NSNumber numberWithFloat: [lifeTimePointsEarned floatValue] + totalScore];
        [defaults setObject:lifeTimePointsEarned forKey:kSINSUserDefaultLifetimePointsEarned];
    }
    [defaults synchronize];
}

+ (float)updatePointsTillFreeCoinMoveScore:(float)moveScore withNSUserDefaults:(NSUserDefaults *)defaults withCallback:(void (^)(BOOL willAwardFreeCoin))callback {
    NSNumber *pointsTillFreeCoinNumber  = [defaults objectForKey:kSINSUserDefaultPointsTowardsFreeCoin];
    
    if (pointsTillFreeCoinNumber == nil) {
        pointsTillFreeCoinNumber        = [NSNumber numberWithFloat:0.0f];
    }
    /*Store as float for easibility*/
    float pointsTillFreeCoin            = [pointsTillFreeCoinNumber floatValue];
    
    /*There was a bug early on where there was a potential for the move score to be
     very very high, like in the thousands... this is solved but in the thought
     to always protect from an extremely high number being stored in the nsuserdefaults
     we are going to leave in a protection statement to prevent this from ever happening
     */
    if (moveScore > MAX_MOVE_SCORE) {
        moveScore = MAX_MOVE_SCORE;
    }
    
    /*Add the move score*/
    pointsTillFreeCoin                  = pointsTillFreeCoin + moveScore;
    
    if (pointsTillFreeCoin > POINTS_NEEDED_FOR_FREE_COIN) {
        pointsTillFreeCoin              = pointsTillFreeCoin - POINTS_NEEDED_FOR_FREE_COIN;
        
        if (callback) {
            callback(YES);
        }
    } else {
        if (callback) {
            callback(NO);
        }
    }
    
    /*Update the nsuserdefaults with new points till score*/
    [defaults setObject:[NSNumber numberWithFloat:pointsTillFreeCoin] forKey:kSINSUserDefaultPointsTowardsFreeCoin];
    [defaults synchronize];
    
    return pointsTillFreeCoin;
}




/**
 Configures game properties for new game
 */
+ (void)setStartGameProperties:(SIGame *)game {
    game.moveScorePercentRemaining           = 1.0f;
    game.currentBackgroundSound              = SIBackgroundSoundMenu;
    game.currentLevel                        = [SIGame currentLevelStringForScore:0.0f];
    game.currentNumberOfTimesContinued       = 1;
    game.totalScore                          = 0.0f;
    game.freeCoinsEarned                     = 0;
    game.currentBackgroundColorNumber        = arc4random_uniform(NUMBER_OF_MOVES);
    game.currentBackgroundColor              = [SKColor mainColor];
    game.isHighScore                         = NO;
}
/**
 Determine prize to give based off when the last time a prize was given... either:
    SIGameFreePrizeNo -> No prize to be given
    SIGameFreePrizeYes -> Give prize, reset the days since last launch and such
    SIGameFreePrizeYesConsecutive -> give prize, increment days since last launch..
 */
+ (SIFreePrizeType)gamePrizeForCurrentDate:(NSDate *)currentDate lastPrizeGivenDate:(NSDate *)lastPrizeGivenDate {
    
    //I would rather have a soft fail then a hard fail if either are nil
    if (!currentDate || !lastPrizeGivenDate) {
        return SIFreePrizeTypeNone;
    }
    
    NSTimeInterval timeSinceLastPrize = [currentDate timeIntervalSince1970] - [lastPrizeGivenDate timeIntervalSince1970];
    
    //Still the same day
    if (timeSinceLastPrize < SECONDS_IN_DAY) {
        return SIFreePrizeTypeNone;

    //Prize given more than two days ago
    } else if (timeSinceLastPrize >= 2 * SECONDS_IN_DAY) {
        return SIFreePrizeTypeNonConsecutive;
        
    //Prize for conseuctive launch
    } else {
        return SIFreePrizeTypeConsecutive;
    }
}

+ (NSString *)titleForMenuType:(SISceneMenuType)type {
    switch (type) {
        case SISceneMenuTypeEnd:
            return @"Swype It";
        case SISceneMenuTypeStart:
            return @"Swype It";
        case SISceneMenuTypeSettings:
            return @"Settings";
        case SISceneMenuTypeHelp:
            return @"Help";
        case SISceneMenuTypeStore:
            return @"Shop";
        default: //SISceneMenuTypeNone
            return nil;
    }
}
/**
 Call this to get the string name of a game state
 Default is End
 */
+ (NSString *)stateStringNameForGameState:(SIGameState)gameState {
    switch (gameState) {
        case SIGameStateIdle:
            return kSITKStateMachineStateGameIdle;
            
        case SIGameStatePause:
            return kSITKStateMachineStateGamePaused;
            
        case SIGameStatePayingForContinue:
            return kSITKStateMachineStateGamePayingForContinue;
            
        case SIGameStatePopupContinue:
            return kSITKStateMachineStateGamePopupContinue;
            
        case SIGameStateProcessingMove:
            return kSITKStateMachineStateGameProcessingMove;
            
        case SIGameStateStart:
            return kSITKStateMachineStateGameStart;
            
        case SIGameStateFallingMonkey:
            return kSITKStateMachineStateGameFallingMonkey;
            
        default:
            return kSITKStateMachineStateGameEnd;
    }
}
/**
 Call this to get an SIGameState for a string key
 Default return is SIGameStateStartEnd
 */
+ (SIGameState)gameStateForStringName:(NSString *)gameStateString {
    if ([gameStateString isEqualToString:kSITKStateMachineStateGamePaused]) {
        return SIGameStatePause;
    } else if ([gameStateString isEqualToString:kSITKStateMachineStateGamePayingForContinue]) {
        return SIGameStatePayingForContinue;
    } else if ([gameStateString isEqualToString:kSITKStateMachineStateGamePopupContinue]) {
        return SIGameStatePopupContinue;
    } else if ([gameStateString isEqualToString:kSITKStateMachineStateGameProcessingMove]) {
        return SIGameStateProcessingMove;
    } else if ([gameStateString isEqualToString:kSITKStateMachineStateGameIdle]) {
        return SIGameStateIdle;
    } else if ([gameStateString isEqualToString:kSITKStateMachineStateGameFallingMonkey]) {
        return SIGameStateFallingMonkey;
    } else if ([gameStateString isEqualToString:kSITKStateMachineStateGameStart]) {
        return SIGameStateStart;
    } else {
        return SIGameStateEnd;
    }
}

/**
 Geat a new background color
 */

+ (int)newBackgroundColorNumberCurrentNumber:(int)currentColorNumber totalScore:(float)totalScore {
    int randomNumber;
    if (totalScore >= LEVEL12) {
        randomNumber = arc4random_uniform(NUMBER_OF_MOVES * 3);
        while (randomNumber == currentColorNumber) {
            randomNumber = arc4random_uniform(NUMBER_OF_MOVES * 3);
        }
        
    } else {
        randomNumber = arc4random_uniform(NUMBER_OF_MOVES);
        while (randomNumber == currentColorNumber) {
            randomNumber = arc4random_uniform(NUMBER_OF_MOVES);
        }
        
    }
    currentColorNumber = randomNumber;
    return currentColorNumber;
}
@end
