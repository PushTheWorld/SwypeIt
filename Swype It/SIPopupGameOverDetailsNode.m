//  SIPopupGameOverDetailsNode.m
//  Swype It
//
//  Created by Andrew Keller on 9/26/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//
//  Purpose: This is to display the final scene things
//
// Local Controller Import
#import "SIGameController.h"
#import "SIPopupGameOverDetailsNode.h"
// Framework Import
// Drop-In Class Imports (CocoaPods/GitHub/Guru)
#import "DSMultilineLabelNode.h"
// Category Import
#import "UIColor+Additions.h"
// Support/Data Class Imports
// Other Imports


@implementation SIPopupGameOverDetailsNode {
    
    DSMultilineLabelNode    *_labelMultilineUserMessage;
    
    NSNumberFormatter       *_numberFormatter;
    
    SKLabelNode             *_labelCoinsEarnedText;
    SKLabelNode             *_labelTotalScoreText;
    SKLabelNode             *_labelHighScoreText;
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
    _numberFormatter                                    = [[NSNumberFormatter alloc] init];
    [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

}

/**
 Preform all your alloc/init's here
 */
- (void)createControlsWithSize:(CGSize)size {
    _backgroundNode.anchorPoint                         = CGPointMake(0.5f, 0.5f);
    _backgroundNode                                     = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
    
    _labelCoinsEarnedText                               = [SIGameController SILabelParagraph:NSLocalizedString(kSITextMenuEndGameFreeCoinsEarned, nil)];
    _labelCoinsEarnedText.horizontalAlignmentMode       = SKLabelHorizontalAlignmentModeLeft;
    _labelCoinsEarnedText.verticalAlignmentMode         = SKLabelVerticalAlignmentModeBottom;

    _labelCoinsEarned                                   = [SIGameController SILabelParagraph:@"0"];
    _labelCoinsEarned.horizontalAlignmentMode           = SKLabelHorizontalAlignmentModeRight;
    _labelCoinsEarned.verticalAlignmentMode             = SKLabelVerticalAlignmentModeBottom;
    
    _labelTotalScoreText                                = [SIGameController SILabelParagraph:NSLocalizedString(kSITextMenuEndGameScore, nil)];
    _labelTotalScoreText.horizontalAlignmentMode        = SKLabelHorizontalAlignmentModeLeft;
    _labelTotalScoreText.verticalAlignmentMode          = SKLabelVerticalAlignmentModeBottom;
    
    _labelTotalScore                                    = [SIGameController SILabelParagraph:@"0.0f"];
    _labelTotalScore.horizontalAlignmentMode            = SKLabelHorizontalAlignmentModeRight;
    _labelTotalScore.verticalAlignmentMode              = SKLabelVerticalAlignmentModeBottom;

    _labelHighScoreText                                 = [SIGameController SILabelParagraph:NSLocalizedString(kSITextMenuEndGameHighScore, nil)];
    _labelHighScoreText.horizontalAlignmentMode         = SKLabelHorizontalAlignmentModeLeft;
    _labelHighScoreText.verticalAlignmentMode           = SKLabelVerticalAlignmentModeBottom;
    
    _labelHighScore                                     = [SIGameController SILabelParagraph:@"0.0"];
    _labelHighScore.horizontalAlignmentMode             = SKLabelHorizontalAlignmentModeRight;
    _labelHighScore.verticalAlignmentMode               = SKLabelVerticalAlignmentModeBottom;
    
    _labelMultilineUserMessage                          = [[DSMultilineLabelNode alloc] initWithFontNamed:_labelCoinsEarned.fontName];
    _labelMultilineUserMessage.fontColor                = [SKColor whiteColor];
    _labelMultilineUserMessage.verticalAlignmentMode    = SKLabelVerticalAlignmentModeTop;
    _labelMultilineUserMessage.horizontalAlignmentMode  = SKLabelHorizontalAlignmentModeCenter;
    
    
}

/**
 Configrue the labels, nodes and what ever else you can
 */
- (void)setupControlsWithSize:(CGSize)size {
    [self addChild:_backgroundNode];

    [_backgroundNode addChild:_labelHighScore];
    [_backgroundNode addChild:_labelHighScoreText];
    
    [_backgroundNode addChild:_labelTotalScore];
    [_backgroundNode addChild:_labelTotalScoreText];
    
    [_backgroundNode addChild:_labelCoinsEarned];
    [_backgroundNode addChild:_labelCoinsEarnedText];

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
    CGFloat topY                                        = _backgroundNode.size.height / 2.0f;
    CGFloat leftX                                       = -1.0f * (_backgroundNode.size.height / 2.0f);
    CGFloat rightX                                      = _backgroundNode.size.height / 2.0f;

    _labelTotalScoreText.position                       = CGPointMake(leftX, topY);
    _labelTotalScore.position                           = CGPointMake(rightX, _labelTotalScoreText.position.y);
    
    _labelHighScoreText.position                        = CGPointMake(leftX, _labelTotalScoreText.position.y  + (-1.0f * (_labelTotalScoreText.frame.size.height + VERTICAL_SPACING_8)));
    _labelHighScore.position                            = CGPointMake(rightX, _labelHighScoreText.position.y);
    
    _labelCoinsEarnedText.position                      = CGPointMake(leftX, _labelHighScoreText.position.y + (-1.0f * (_labelHighScoreText.frame.size.height + VERTICAL_SPACING_8)));
    _labelCoinsEarned.position                          = CGPointMake(rightX, _labelCoinsEarnedText.position.y);
    
    _labelMultilineUserMessage.position                 = CGPointMake(0.0f, _labelCoinsEarnedText.position.y + (-1.0F * (_labelCoinsEarnedText.frame.size.height + VERTICAL_SPACING_8)));
}

/**
 Layout the Z
 */
- (void)layoutZ {
    _labelMultilineUserMessage.zPosition                = [SIGameController floatZPositionMenuForContent:SIZPositionMenuContent];
    _labelTotalScore.zPosition                          = [SIGameController floatZPositionMenuForContent:SIZPositionMenuContent];
    _labelTotalScoreText.zPosition                      = [SIGameController floatZPositionMenuForContent:SIZPositionMenuContent];
    _labelHighScore.zPosition                           = [SIGameController floatZPositionMenuForContent:SIZPositionMenuContent];
    _labelHighScoreText.zPosition                       = [SIGameController floatZPositionMenuForContent:SIZPositionMenuContent];
    _labelCoinsEarned.zPosition                         = [SIGameController floatZPositionMenuForContent:SIZPositionMenuContent];
    _labelCoinsEarnedText.zPosition                     = [SIGameController floatZPositionMenuForContent:SIZPositionMenuContent];
    
}

#pragma mark -
#pragma mark - Public Accessors
- (void)setGame:(SIGame *)game {
    float highScore                                     = [[NSUserDefaults standardUserDefaults] floatForKey:kSINSUserDefaultLifetimeHighScore];
    
    _labelTotalScore.text                               = [_numberFormatter stringFromNumber:[NSNumber numberWithFloat:game.totalScore]];
    
    _labelCoinsEarned.text                              = [NSString stringWithFormat:@"%d",game.freeCoinsEarned];
    
    if (game.isHighScore) {
        _labelHighScoreText.text                        = NSLocalizedString(kSITextMenuEndGameHighScoreNew, nil);
        _labelHighScore.text                            = @"";
        
    } else {
        _labelHighScoreText.text                        = NSLocalizedString(kSITextMenuEndGameHighScore, nil);
        _labelHighScore.text                            = [_numberFormatter stringFromNumber:@(highScore)];
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
+ (void)reelNumbersForLabel:(SKLabelNode *)labelNode numberFormatter:(NSNumberFormatter *)numberFormatter score:(float)score totalScore:(float)totalScore {
    if (score > totalScore) {
        return;
    }
    
    labelNode.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:score]];
}



@end
