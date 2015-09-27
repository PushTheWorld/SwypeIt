//  SIMenuEndNode.m
//  Swype It
//
//  Created by Andrew Keller on 9/26/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is to display the final scene things
//
// Local Controller Import
#import "SIGameController.h"
#import "SIMenuEndNode.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "DSMultilineLabelNode.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports


@implementation SIMenuEndNode {
    
    DSMultilineLabelNode    *_labelMultilineUserMessage;
    
    SKLabelNode             *_labelCoinsEarned;
    SKLabelNode             *_labelTotalScore;
    SKLabelNode             *_labelHighScore;
    
    SKSpriteNode            *_backgroundNode;
    
}

#pragma mark -
#pragma mark - Node Life Cycle
- (instancetype)initWithSize:(CGSize)size {
    self = [super init];
    if (self) {
        [self initSetup:size];
    }
    return self;
}

- (void)initSetup:(CGSize)size {
    [self createConstantsWithSize:size];
    [self createControlsWithSize:size];
    [self setupControlsWithSize:size];
}

/**
 Configure any constants
 */
- (void)createConstantsWithSize:(CGSize)size {

}

/**
 Preform all your alloc/init's here
 */
- (void)createControlsWithSize:(CGSize)size {
    _backgroundNode                                     = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];

    _labelHighScore                                     = [SIGameController SILabelParagraph:@"High Score: 0.00"];
    _labelHighScore.horizontalAlignmentMode             = SKLabelHorizontalAlignmentModeCenter;
    _labelHighScore.verticalAlignmentMode               = SKLabelVerticalAlignmentModeBottom;
    
    _labelTotalScore                                    = [SIGameController SILabelHeader:@"Score: 0.00"];
    _labelTotalScore.horizontalAlignmentMode            = SKLabelHorizontalAlignmentModeCenter;
    _labelTotalScore.verticalAlignmentMode              = SKLabelVerticalAlignmentModeBottom;
    
    _labelMultilineUserMessage                          = [[DSMultilineLabelNode alloc] initWithFontNamed:_labelCoinsEarned.fontName];
    _labelMultilineUserMessage.fontColor                = [SKColor whiteColor];
    _labelMultilineUserMessage.verticalAlignmentMode    = SKLabelVerticalAlignmentModeCenter;
    _labelMultilineUserMessage.horizontalAlignmentMode  = SKLabelHorizontalAlignmentModeCenter;
    
    _labelCoinsEarned                                   = [SIGameController SILabelParagraph:@"Free Coins Earned: 0"];
    _labelCoinsEarned.horizontalAlignmentMode           = SKLabelHorizontalAlignmentModeCenter;
    _labelCoinsEarned.verticalAlignmentMode             = SKLabelVerticalAlignmentModeTop;
}

/**
 Configrue the labels, nodes and what ever else you can
 */
- (void)setupControlsWithSize:(CGSize)size {
    _backgroundNode.anchorPoint                         = CGPointMake(0.5f, 0.5f);
    [self addChild:_backgroundNode];

    [_backgroundNode addChild:_labelHighScore];
    
    [_backgroundNode addChild:_labelTotalScore];
    
    [_backgroundNode addChild:_labelCoinsEarned];
    
    [_backgroundNode addChild:_labelMultilineUserMessage];
    
}

/**
 Layout both the XY & Z
 */
- (void)layoutXYZ {
    [self layoutXY];
    [self layoutZ];
}

/**
 Layout the XY
 */
- (void)layoutXY {
    _labelMultilineUserMessage.position                 = CGPointMake(0.0f, 0.0f);
    _labelTotalScore.position                           = CGPointMake(0.0f, (_labelMultilineUserMessage.frame.size.height / 2.0f) + VERTICAL_SPACING_8);
    _labelHighScore.position                            = CGPointMake(0.0f, _labelTotalScore.position.y + (_labelTotalScore.frame.size.height / 2.0f) + VERTICAL_SPACING_8);
    _labelCoinsEarned.position                          = CGPointMake(0.0f, -1.0f * ((_labelMultilineUserMessage.frame.size.height / 2.0f) + VERTICAL_SPACING_8));

}

/**
 Layout the Z
 */
- (void)layoutZ {
    _labelMultilineUserMessage.zPosition                = [SIGameController floatZPositionMenuForContent:SIZPositionMenuContent];
    _labelTotalScore.zPosition                          = [SIGameController floatZPositionMenuForContent:SIZPositionMenuContent];
    _labelHighScore.zPosition                           = [SIGameController floatZPositionMenuForContent:SIZPositionMenuContent];
    _labelCoinsEarned.zPosition                         = [SIGameController floatZPositionMenuForContent:SIZPositionMenuContent];
    
}

#pragma mark -
#pragma mark - Public Accessors
- (void)setGame:(SIGame *)game {
    float highScore                                     = [[NSUserDefaults standardUserDefaults] floatForKey:kSINSUserDefaultLifetimeHighScore];
    _labelCoinsEarned.text                              = [NSString stringWithFormat:@"Free Coins Earned: %d",game.freeCoinsEarned];
    _labelTotalScore.text                               = [NSString stringWithFormat:@"Score: %0.2f",game.totalScore];
    if (game.isHighScore) {
        _labelHighScore.text                            = @"New High Score!";
    } else {
        _labelHighScore.text                            = [NSString stringWithFormat:@"%0.2f",highScore];
    }
    
    _labelMultilineUserMessage.text                     = [SIGame userMessageForScore:game.totalScore isHighScore:game.isHighScore highScore:highScore];
    
    _game                                               = game;
    
    [self layoutXYZ];
}
- (CGSize)size {
    return _backgroundNode.size;
}
- (void)setSize:(CGSize)size {
    _backgroundNode.size                                = size;
    [self layoutXYZ];
}
#pragma mark -
#pragma mark - Class Functions

@end
