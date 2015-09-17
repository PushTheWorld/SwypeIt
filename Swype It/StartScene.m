////  StartScreenScene.m
////  Swype It
////
////  Created by Andrew Keller on 7/19/15.
////  Copyright © 2015 Push The World LLC. All rights reserved.
////
////
////  Purpose: Thie is the startign screen for the swype it game
////
//// Local Controller Import
//#import "GameScene.h"
//#import "SIGameController.h"
//#import "MKStoreKit.h"
//#import "SettingsScene.h"
//#import "SIAdBannerNode.h"
//#import "SISegmentControl.h"
//#import "StartScene.h"
//#import "StoreScene.h"
//// Framework Import
//// Drop-In Class Imports (CocoaPods/GitHub/Guru)
//#import "FXReachability.h"
//#import "HLSpriteKit.h"
//#import "SoundManager.h"
//// Category Import
//#import "UIColor+Additions.h"
//// Support/Data Class Imports
//#import "SIGame.h"
//// Other Imports
//enum {
//    SIStartZPositionLayerBackground = 0,
//    SIStartZPositionLayerText,
//    SIStartZPositionLayerTextChild,
//    SIStartZPositionLayerButtons,
//    SIStartZPositionLayerToolbar,
//    SIStartZPositionLayerToolbarButtons,
//    SIStartZPositionLayerPopup,
//    SIStartZPositionLayerPopupContent,
//    SIStartZPositionLayerCount
//};
//
//@interface StartScene () <HLToolbarNodeDelegate, SISegmentControlDelegate, SIPopUpNodeDelegate, SIAdBannerNodeDelegate>
//
//
//@end
//@implementation StartScene {
//    BOOL                                     _shouldRespondToTap;
//    BOOL                                     _willAwardPrize;
//    
//    CGFloat                                  _buttonAnimationDuration;
//    CGFloat                                  _buttonSpacing;
//    
//    CGSize                                   _adBannerNodeSize;
//    CGSize                                   _backgroundNodeSize;
//    CGSize                                   _monkeySize;
//    CGSize                                   _storeButtonNodeSize;
//        
//    SKSpriteNode                            *_backgroundNode;
//    SKSpriteNode                            *_monkeyFace;
//    
//    HLLabelButtonNode                       *_storeButtonNode;
//    
//    HLToolbarNode                           *_toolbarNode;
//    
//    SIAdBannerNode                          *_adBannerNode;
//    
//    SISegmentControl                        *_segmentControl;
//    
//    SKLabelNode                             *_gameTitleLabelNode;
//    SKLabelNode                             *_gameTypeInstructionLabelNode;
//    SKLabelNode                             *_tapToPlayLabelNode;
//}
//
//#pragma mark - Scene Life Cycle
//- (instancetype)initWithSize:(CGSize)size {
//    if (self = [super initWithSize:size]) {
//        /**Do any setup before self.view is loaded*/
////        [self initSetup:size];
//        [self initSetup:size];
//    }
//    return self;
//}
//- (void)didMoveToView:(nonnull SKView *)view {
//    [super didMoveToView:view];
//    /**Do any setup post self.view creation*/
//    [self viewSetup:view];
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:kSINSUserDefaultSoundIsAllowedBackground]) {
//        [[SoundManager sharedManager] playMusic:kSISoundBackgroundMenu looping:YES fadeIn:YES];
//    }
//    NSNotification *notification        = [[NSNotification alloc] initWithName:kSINotificationMenuLoaded object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFreePuchasedSucceded)  name:kSINotificationAdFreePurchasedSucceded object:nil];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:kSINotificationAdBannerShow object:nil];
//
//    });
//
//    [self registerForNotifications];
//    
//    _willAwardPrize = NO;
//    
//    _storeButtonNode.text = [self checkForDailyPrize] ? @"" : @"Buy Coins";
//    
////    [self hlSetGestureTarget:self.scene];
////    [self registerDescendant:self.scene withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
//}
//- (void)willMoveFromView:(nonnull SKView *)view {
//    /**Do any breakdown prior to the view being unloaded*/
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSINotificationAdFreePurchasedSucceded object:nil];
//    /*Resume move from view*/
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [super willMoveFromView:view];
//}
//- (void)initSetup:(CGSize)size {
//    /**Preform initalization pre-view load*/
//    [self createConstantsWithSize:size];
//    [self createControlsWithSize:size];
//    [self setupControlsWithSize:size];
//    [self layoutControlsWithSize:size];
//}
//- (void)viewSetup:(SKView *)view {
//    /**Preform setup post-view load*/
//    self.backgroundColor                    = [SKColor orangeColor];
//    _shouldRespondToTap                     = YES;
////    [self needSharedGestureRecognizers:@[ [[UITapGestureRecognizer alloc] init] ]];
//    
//}
//#pragma mark Scene Setup
//- (void)createConstantsWithSize:(CGSize)size {
//    /**Configure any constants*/
//    _buttonSpacing                          = [SIGameController SIButtonSize:size].height * 0.25;
//    _buttonAnimationDuration                = 0.25f;
//    
//    if ([SIGameController isPremiumUser]) {
//        _adBannerNodeSize                   = CGSizeZero;
//    } else {
//        _adBannerNodeSize                   = CGSizeMake(size.width, [SIGameController bannerViewHeight]);
//    }
//    _backgroundNodeSize                     = CGSizeMake(size.width, size.height - _adBannerNodeSize.height);
//    
//    _storeButtonNodeSize                    = CGSizeMake([SIGameController SIButtonSize:size].width / 2.0f, [SIGameController SIButtonSize:size].height);
//
//}
//- (void)createControlsWithSize:(CGSize)size {
//    /**Preform all your alloc/init's here*/
//    /*Background nodes*/
//    _backgroundNode                         = [SKSpriteNode spriteNodeWithColor:[SKColor sandColor] size:_backgroundNodeSize];
//    
//    _adBannerNode                           = [[SIAdBannerNode alloc] initWithSize:_adBannerNodeSize];
//    
//    /*Labels*/
//    _gameTitleLabelNode                     = [SIGameController SILabelHeader_x3:@"SWYPE IT"];
//    
//    _tapToPlayLabelNode                     = [SIGameController SILabelParagraph_x2:@"Tap To Start"];
//    
//    _monkeyFace                             = [SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonFallingMonkey]];
//    
//    _gameTypeInstructionLabelNode           = [SIGameController SILabelParagraph_x2:@"Choose Game Mode:"];
//    
//    /*Store Button Label*/
//    _storeButtonNode                        = [[HLLabelButtonNode alloc] initWithColor:[SKColor redColor] size:_storeButtonNodeSize];
//
//    /*Segment Control*/
//    _segmentControl                         = [[SISegmentControl alloc] initWithSize:[SIGameController SIButtonSize:size] titles:@[@"Classic",@"One Hand"]];
//}
//- (void)setupControlsWithSize:(CGSize)size {
//    /**Configrue the labels, nodes and what ever else you can*/
//    /*Background*/
//    _backgroundNode.anchorPoint             = CGPointMake(0.0f, 0.0f);
//    _backgroundNode.zPosition               = (float)SIStartScreenZPositionLayerBackground / (float)SIStartScreenZPositionLayerCount;
//    
//    _adBannerNode.zPosition                 = (float)SIStartScreenZPositionLayerBackground / (float)SIStartScreenZPositionLayerCount;
//    _adBannerNode.delegate                  = self;
//    
//    _gameTitleLabelNode.zPosition           = (float)SIStartScreenZPositionLayerText / (float)SIStartScreenZPositionLayerCount;
//    _gameTitleLabelNode.fontName            = kSIFontFuturaMedium;
//    
//    _tapToPlayLabelNode.zPosition           = SIStartScreenZPositionLayerText / (float)SIStartScreenZPositionLayerCount;
//    _tapToPlayLabelNode.fontColor           = [SKColor grayColor];
//    _tapToPlayLabelNode.fontName            = kSIFontFuturaMedium;
//    
//    _monkeyFace.zPosition                   = (float)SIStartScreenZPositionLayerTextChild / (float)SIStartScreenZPositionLayerCount;
//    _monkeyFace.anchorPoint                 = CGPointMake(0.5f, 0.5f);
//    _monkeySize                             = CGSizeMake(size.width / 2.0f, size.width / 2.0f);
//    _monkeyFace.size                        = _monkeySize;
//    
//    _gameTypeInstructionLabelNode.zPosition = (float)SIStartScreenZPositionLayerText / (float)SIStartScreenZPositionLayerCount;
//    _gameTypeInstructionLabelNode.fontName  = kSIFontFuturaMedium;
//    _gameTypeInstructionLabelNode.fontColor = [SKColor grayColor];
//    
//    _segmentControl.zPosition               = (float)SIStartScreenZPositionLayerButtons / (float)SIStartScreenZPositionLayerCount;
//    _segmentControl.delegate                = self;
//    NSNumber *gameMode = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultGameMode];
//    if (gameMode) {
//        if ([gameMode integerValue] == 0) { /*One hand mode*/
//            _segmentControl.selectedSegment         = 1;
//        } else {
//            _segmentControl.selectedSegment         = 0;
//        }
//    } else {
//        [[NSUserDefaults standardUserDefaults] setInteger:SIGameModeTwoHand forKey:kSINSUserDefaultGameMode];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        _segmentControl.selectedSegment             = 0;
//    }
//    
//    /*Store Button Label*/
//    _storeButtonNode.fontName               = kSIFontFuturaMedium;
//    _storeButtonNode.fontSize               = [SIGameController SIButtonSize:size].height / 2.0f;
//    _storeButtonNode.fontColor              = [SKColor whiteColor];
//    _storeButtonNode.borderColor            = [SKColor blackColor];
//    _storeButtonNode.borderWidth            = 8.0f;
//    _storeButtonNode.cornerRadius           = 8.0f;
//    _storeButtonNode.verticalAlignmentMode  = HLLabelNodeVerticalAlignFont;
//    _storeButtonNode.anchorPoint            = CGPointMake(0.5f, 0.0f);
//    
//    /*Toolbar Node*/
//    _toolbarNode                            = [self createToolbarNode:size];
//    _toolbarNode.delegate                   = self;
//    _toolbarNode.zPosition                  = (float)SIStartScreenZPositionLayerToolbar / (float)SIStartScreenZPositionLayerCount;
//}
//- (void)layoutControlsWithSize:(CGSize)size {
//    /**Layout those controls*/
//    
//    /*Ad banner place holder*/
//    _adBannerNode.position                  = CGPointMake(0.0f, 0.0f);
//    [self addChild:_adBannerNode];
//    [_adBannerNode hlSetGestureTarget:_adBannerNode];
//    [self registerDescendant:_adBannerNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
//    
//    /*Background Node...*/
//    _backgroundNode.position                = CGPointMake(0.0f, 0.0f + _adBannerNodeSize.height);
//    [self addChild:_backgroundNode];
//    HLTapGestureTarget *tapGestureTarget    = [[HLTapGestureTarget alloc] init];
//    tapGestureTarget.handleGestureBlock     = ^(UIGestureRecognizer *gestureRecognizer){
//        [self startGame];
//    };
//    [_backgroundNode hlSetGestureTarget:tapGestureTarget];
//    [self registerDescendant:_backgroundNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
//    
//    _gameTitleLabelNode.position            = CGPointMake((size.width / 2.0f),size.height - (_gameTitleLabelNode.fontSize * 1.5));
//    [_backgroundNode addChild:_gameTitleLabelNode];
//    
//    _tapToPlayLabelNode.position            = CGPointMake((size.width / 2.0f), _gameTitleLabelNode.frame.origin.y - (_tapToPlayLabelNode.fontSize / 2.0f) - VERTICAL_SPACING_8);
//    [_backgroundNode addChild:_tapToPlayLabelNode];
//    
//    /*Store Button Label*/
//    _storeButtonNode.position               = CGPointMake(size.width / 2.0f,
//                                                          size.height - VERTICAL_SPACING_8 - _gameTitleLabelNode.fontSize - VERTICAL_SPACING_8 - _tapToPlayLabelNode.fontSize - [SIGameController SIButtonSize:size].height);
//    [self addChild:_storeButtonNode];
//    [_storeButtonNode hlSetGestureTarget:[HLTapGestureTarget tapGestureTargetWithHandleGestureBlock:^(UIGestureRecognizer *gestureRecognizer) {
//        StoreScene *storeScene = [[StoreScene alloc] initWithSize:self.size willAwardPrize:_willAwardPrize];//[StoreScene sceneWithSize:self.size];
//        storeScene.wasLaunchedFromMainMenu = YES;
//        SIGame transisitionToSKScene:storeScene toSKView:self.view duration:SCENE_TRANSISTION_DURATION];
////        SIGame transisitionToSKScene:storeScene toSKView:self.view DoorsOpen:YES pausesIncomingScene:YES pausesOutgoingScene:YES duration:SCENE_TRANSISTION_DURATION];
//        
//    }]];
//    [self registerDescendant:_storeButtonNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
//    
//    CGFloat maxMonkeyScaleSize              = 1.1f;
////    CGFloat maxMonkeyHeight                 = _monkeySize.height * maxMonkeyScaleSize;
//    _monkeyFace.position                    = CGPointMake((size.width / 2.0f), (size.height / 2.0f)); //CGPointMake(0.0f, _tapToPlayLabelNode.position.y - (maxMonkeyHeight / 1.5f));
//    [_backgroundNode addChild:_monkeyFace];
//    SKAction *increaseSize                  = [SKAction scaleTo:maxMonkeyScaleSize duration:1.2f];
//    SKAction *decreaseSize                  = [SKAction scaleTo:1.0f duration:1.2f];
//    SKAction *seq                           = [SKAction sequence:@[increaseSize,decreaseSize]];
//    [_monkeyFace runAction:[SKAction repeatActionForever:seq]];
//    
//    /*Menu Node*/
//    _toolbarNode.position                   = CGPointMake(0.0f,
//                                                          _adBannerNodeSize.height + VERTICAL_SPACING_8);
//    [self addChild:_toolbarNode];
//    [_toolbarNode hlSetGestureTarget:_toolbarNode];
//    [self registerDescendant:_toolbarNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
//
//    
//    /*Segment Control*/
//    _segmentControl.position                = CGPointMake((size.width / 2.0f),VERTICAL_SPACING_8 + [SIGameController SIButtonSize:size].height + VERTICAL_SPACING_8 + ([SIGameController SIButtonSize:size].height / 2.0f));
//    [_backgroundNode addChild:_segmentControl];
//    [_segmentControl hlSetGestureTarget:_segmentControl];
//    [self registerDescendant:_segmentControl withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
//
//    _gameTypeInstructionLabelNode.position  = CGPointMake((size.width / 2.0f), _segmentControl.frame.origin.y + ([SIGameController SIButtonSize:size].height / 2.0f) + VERTICAL_SPACING_4 + (_gameTypeInstructionLabelNode.fontSize / 2.0f));
//    [_backgroundNode addChild:_gameTypeInstructionLabelNode];
//
//}
//
//#pragma mark - Toolbar Delegates
//- (void)toolbarNode:(HLToolbarNode *)toolbarNode didTapTool:(NSString *)toolTag {
//    if ([self modalNodePresented]) {
//        [self dismissModalNodeAnimation:HLScenePresentationAnimationFade];
//        return;
//    }
//    if ([toolTag isEqualToString:kSINodeButtonLeaderBoard]) {
//        NSLog(@"Leaderboard Toolbar Button Tapped");
//        NSNotification *notification    = [[NSNotification alloc] initWithName:kSINotificationShowLeaderBoard object:nil userInfo:nil];
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//
//    } else if ([toolTag isEqualToString:kSINodeButtonNoAd]) {
//        [[MKStoreKit sharedKit] initiatePaymentRequestForProductWithIdentifier:kSIIAPProductIDAdFree];
//        NSLog(@"Ad Free Toolbar Button Tapped");
//        
//    } else if ([toolTag isEqualToString:kSINodeButtonSettings]) {
//        SettingsScene *settingsScene    = [SettingsScene sceneWithSize:self.size];
//        SIGame transisitionToSKScene:settingsScene toSKView:self.view DoorsOpen:YES pausesIncomingScene:YES pausesOutgoingScene:YES duration:SCENE_TRANSISTION_DURATION];
//        
//    } else if ([toolTag isEqualToString:kSINodeButtonInstructions]) {
//        NSLog(@"Instructions Toolbar Button Tapped");
//        [self launchHelp];
//    }
//}
//
//#pragma mark - Segment Control Delegate Methods
//- (void)segmentControl:(SISegmentControl *)segmentControl didTapNodeItem:(HLLabelButtonNode *)nodeItem itemIndex:(NSUInteger)itemIndex {
//    if (itemIndex == 0) { /*Two Hand Mode*/
//        [[NSUserDefaults standardUserDefaults] setInteger:SIGameModeTwoHand forKey:kSINSUserDefaultGameMode];
//    } else { /*One Hand Mode*/
//        [[NSUserDefaults standardUserDefaults] setInteger:SIGameModeOneHand forKey:kSINSUserDefaultGameMode];
//    }
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (HLToolbarNode *)createToolbarNode:(CGSize)size {
//    HLToolbarNode *toolbarNode                  = [[HLToolbarNode alloc] init];
//    toolbarNode.automaticHeight                 = NO;
//    toolbarNode.automaticWidth                  = NO;
//    toolbarNode.backgroundBorderSize            = 0.0f;
//    toolbarNode.squareSeparatorSize             = 10.0f;
//    toolbarNode.backgroundColor                 = [UIColor clearColor];
//    toolbarNode.anchorPoint                     = CGPointMake(0.0f, 0.0f);
//    toolbarNode.size                            = CGSizeMake(size.width, [SIGameController SIButtonSize:size].height);
//    toolbarNode.squareColor                     = [SKColor clearColor];
//    
//    
//    NSMutableArray *toolNodes                   = [NSMutableArray array];
//    NSMutableArray *toolTags                    = [NSMutableArray array];
//    
//    [toolNodes  addObject:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonSettings]]];
//    [toolTags   addObject:kSINodeButtonSettings];
//    
//    BOOL isPremiumUser = [[NSUserDefaults standardUserDefaults] boolForKey:kSINSUserDefaultPremiumUser];
//    if (!isPremiumUser) {
//        [toolNodes  addObject:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonNoAd]]];
//        [toolTags   addObject:kSINodeButtonNoAd];
//    }
//
//    [toolNodes  addObject:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonInstructions]]];
//    [toolTags   addObject:kSINodeButtonInstructions];
//
//    [toolNodes  addObject:[SKSpriteNode spriteNodeWithTexture:[[SIConstants buttonAtlas] textureNamed:kSIImageButtonLeaderboard]]];
//    [toolTags   addObject:kSINodeButtonLeaderBoard];
//    
//    [toolbarNode setTools:toolNodes tags:toolTags animation:HLToolbarNodeAnimationNone];
//    
//    [toolbarNode layoutToolsAnimation:HLToolbarNodeAnimationNone];
//    return toolbarNode;
//}
//
//#pragma mark - SIPopUpDelegate Methods
//- (void)dismissPopUp:(SIPopupNode *)popUpNode {
//    [self dismissModalNodeAnimation:HLScenePresentationAnimationFade];
//}
//
//#pragma mark - SIPopUpNode Helper Methods
//- (void)launchHelp {
//    SIPopupNode *popUpNode                      = [SIGameController SIPopUpNodeTitle:@"Help" SceneSize:self.size];
//    popUpNode.zPosition                         = SIStartScreenZPositionLayerPopup / SIStartScreenZPositionLayerCount;
//    popUpNode.titleFontName                     = kSIFontFuturaMedium;
//    
//    SKLabelNode *line1 = [SIGameController SILabelInterfaceFontSize:[SIGameController SIFontSizeParagraph]];
//    line1.text  = @"Tap to start";
//    
//    SKLabelNode *aboutLabelNode                 = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
//    aboutLabelNode.text                         = @"Tap To Start";
//    aboutLabelNode.fontSize                     = [SIGameController SIFontSizeParagraph];
//    aboutLabelNode.fontColor                    = [SKColor blackColor];
//    aboutLabelNode.zPosition                    = SIStartScreenZPositionLayerPopupContent / SIStartScreenZPositionLayerCount;
//    
//    popUpNode.popupContentNode                  = [self createPopupNodeContent:popUpNode.backgroundSize];
////    [self registerDescendant:menuNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
//    
//    popUpNode.delegate                          = self;
//    popUpNode.userInteractionEnabled            = YES;
//    [popUpNode hlSetGestureTarget:popUpNode];
//    [self registerDescendant:popUpNode withOptions:[NSSet setWithObject:HLSceneChildGestureTarget]];
//    [self presentModalNode:popUpNode animation:HLScenePresentationAnimationFade];
//}
//
////- (HLMenuNode *)menuCreate:(CGSize)size {
////    HLMenuNode *menuNode                = [[HLMenuNode alloc] init];
////    menuNode.delegate                   = self;
////    menuNode.itemAnimation              = HLMenuNodeAnimationSlideLeft;
////    menuNode.itemAnimationDuration      = 0.25;
////    menuNode.itemButtonPrototype        = [SIGameController SI_sharedMenuButtonPrototypePopUp:[SIGameController buttonSize:size]];
////    menuNode.backItemButtonPrototype    = [SIGameController SI_sharedMenuButtonPrototypeBack:[SIGameController buttonSize:size]];
////    menuNode.itemSeparatorSize          = 20;
////    
////    HLMenu *menu                        = [[HLMenu alloc] init];
////    
////    /*Add the Back Button... Need to change the prototype*/
////    HLMenuItem *endGameItem             = [HLMenuItem menuItemWithText:kSIMenuTextBack];
////    endGameItem.buttonPrototype         = [SIGameController SI_sharedMenuButtonPrototypeBack:[SIGameController buttonSize:size]];
////    [menu addItem:endGameItem];
////    
////    
////    [menuNode setMenu:menu animation:HLMenuNodeAnimationNone];
////    
////    menuNode.position                   = CGPointMake(0.0f, 0.0f);
////    
////    return menuNode;
////}
//
//- (SKSpriteNode *)createPopupNodeContent:(CGSize)size {
//    SKSpriteNode *node                  = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:size];
//    node.anchorPoint                    = CGPointMake(0.5f, 0.5f);
//    
//    SKLabelNode *line1                  = [self popupLabel:@"Tap the start screen to start a game."];
//    SKLabelNode *line2                  = [self popupLabel:@"A gesture command will appear."];
//    SKLabelNode *line3                  = [self popupLabel:@"Perform the gesture to progress"];
//    SKLabelNode *line4                  = [self popupLabel:@"through the game. The faster you enter"];
//    SKLabelNode *line5                  = [self popupLabel:@"the next gesture, the more points you"];
//    SKLabelNode *line6                  = [self popupLabel:@"earn! Points are awesome!"];
//    SKLabelNode *line7                  = [self popupLabel:@"Use power ups to get an even higher"];
//    SKLabelNode *line8                  = [self popupLabel:@"score! Power ups are purchased with"];
//    SKLabelNode *line9                  = [self popupLabel:@"IT Coins. BUY IT Coins in the Store,"];
//    SKLabelNode *line10                 = [self popupLabel:@"earn a coin every 500 points and"];
//    SKLabelNode *line11                 = [self popupLabel:@"each day you launch the app get free!"];
//    SKLabelNode *line12                 = [self popupLabel:@"Opening Swype It every day earns you"];
//    SKLabelNode *line13                 = [self popupLabel:@"more and more free coins!!!"];
//    SKLabelNode *line14                 = [self popupLabel:@"SWYPE ON!"];
//    line14.fontSize                     = [SIGameController SIFontSizeText_x3];
//    line14.horizontalAlignmentMode      = SKLabelHorizontalAlignmentModeCenter;
//    
//    CGFloat positionOffset              = line2.fontSize + VERTICAL_SPACING_4;
//    CGFloat xLabelPosition              = -1.0f * (size.width / 2.0f) + VERTICAL_SPACING_16;
//    line1.position                      = CGPointMake(xLabelPosition, (size.height / 6.0f) * 1.9f);
//    line2.position                      = CGPointMake(xLabelPosition, line1.position.y - positionOffset);
//    line3.position                      = CGPointMake(xLabelPosition, line2.position.y - positionOffset);
//    line4.position                      = CGPointMake(xLabelPosition, line3.position.y - positionOffset);
//    line5.position                      = CGPointMake(xLabelPosition, line4.position.y - positionOffset);
//    line6.position                      = CGPointMake(xLabelPosition, line5.position.y - positionOffset);
//    line7.position                      = CGPointMake(xLabelPosition, line6.position.y - (positionOffset * 2.0f));
//    line8.position                      = CGPointMake(xLabelPosition, line7.position.y - positionOffset);
//    line9.position                      = CGPointMake(xLabelPosition, line8.position.y - positionOffset);
//    line10.position                     = CGPointMake(xLabelPosition, line9.position.y - positionOffset);
//    line11.position                     = CGPointMake(xLabelPosition, line10.position.y - positionOffset);
//    line12.position                     = CGPointMake(xLabelPosition, line11.position.y - positionOffset);
//    line13.position                     = CGPointMake(xLabelPosition, line12.position.y - positionOffset);
//    line14.position                     = CGPointMake(0.0f, line13.position.y - (positionOffset * 2.0f));
//    
//    [node addChild:line1];
//    [node addChild:line2];
//    [node addChild:line3];
//    [node addChild:line4];
//    [node addChild:line5];
//    [node addChild:line6];
//    [node addChild:line7];
//    [node addChild:line8];
//    [node addChild:line9];
//    [node addChild:line10];
//    [node addChild:line11];
//    [node addChild:line12];
//    [node addChild:line13];
//    [node addChild:line14];
//
//    return node;
//}
//
//- (SKLabelNode *)popupLabel:(NSString *)text {
//    SKLabelNode *labelNode              = [SIGameController SILabelInterfaceFontSize:[SIGameController SIFontSizeText]];
//    labelNode.text                      = text;
//    labelNode.fontColor                 = [SKColor whiteColor];
//    labelNode.fontName                  = kSIFontFuturaMedium;
//    labelNode.horizontalAlignmentMode   = SKLabelHorizontalAlignmentModeLeft;
//    return labelNode;
//}
//
//#pragma mark - Private Methods
//- (void)launchGameSceneForGameMode:(SIGameMode)gameMode {
//    if ([self modalNodePresented]) {
//        [self dismissModalNodeAnimation:HLScenePresentationAnimationFade];
//        return;
//    }
//    [[AppSingleton singleton] initAppSingletonWithGameMode:gameMode];
//    GameScene *firstScene = [SIGameScene alloc] initWithSize:self.size gameMode:gameMode];
//    SIGame transisitionToSKScene:firstScene toSKView:self.view DoorsOpen:YES pausesIncomingScene:NO pausesOutgoingScene:NO duration:SCENE_TRANSISTION_DURATION];
//}
//
//- (void)startGame {
//    NSNumber *gameModeNumber = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultGameMode];
//    SIGameMode startingGameMode;
//    if (!gameModeNumber) {
//        [[NSUserDefaults standardUserDefaults] setInteger:SIGameModeTwoHand forKey:kSINSUserDefaultGameMode];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        startingGameMode   = SIGameModeTwoHand;
//    } else {
//        startingGameMode = [gameModeNumber integerValue];
//    }
//    
//    [self launchGameSceneForGameMode:startingGameMode];
//}
//#pragma mark - Ad Free Methods
//
///**
// Called to configure the device to enter an ad free state...
// */
//- (void)addFreePuchasedSucceded {
//    NSLog(@"Ad free purchsed... notification serviced in main view controller");
//    _toolbarNode = [self createToolbarNode:self.size];
//    
//}
//- (void)registerForNotifications {
//    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(packPurchaseRequest:) name:kSINotificationPackPurchaseRequest object:nil];
//    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchasedNotification
//                                                      object:nil
//                                                       queue:[[NSOperationQueue alloc] init]
//                                                  usingBlock:^(NSNotification *note) {
//                                                      NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationAdFreePurchasedSucceded object:nil userInfo:nil];
//                                                      [[NSNotificationCenter defaultCenter] postNotification:notification];
//                                                  }];
//    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchaseFailedNotification
//                                                      object:nil
//                                                       queue:[[NSOperationQueue alloc] init]
//                                                  usingBlock:^(NSNotification *note) {
//                                                      
//                                                      NSLog(@"Failed [kMKStoreKitProductPurchaseFailedNotification] with error: %@", [note object]);
//                                                      NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationAdFreePurchasedFailed object:nil userInfo:nil];
//                                                      [[NSNotificationCenter defaultCenter] postNotification:notification];
//                                                  }];
//    
//    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitProductPurchaseDeferredNotification
//                                                      object:nil
//                                                       queue:[[NSOperationQueue alloc] init]
//                                                  usingBlock:^(NSNotification *note) {
//                                                      
//                                                      NSLog(@"Failed [kMKStoreKitProductPurchaseDeferredNotification] with error: %@", [note object]);
//                                                      NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationAdFreePurchasedFailed object:nil userInfo:nil];
//                                                      [[NSNotificationCenter defaultCenter] postNotification:notification];
//                                                  }];
//    
//    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoredPurchasesNotification
//                                                      object:nil
//                                                       queue:[[NSOperationQueue alloc] init]
//                                                  usingBlock:^(NSNotification *note) {
//                                                      
//                                                      NSLog(@"Restored Purchases");
//                                                      NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationAdFreePurchasedSucceded object:nil userInfo:nil];
//                                                      [[NSNotificationCenter defaultCenter] postNotification:notification];
//                                                  }];
//    
//    [[NSNotificationCenter defaultCenter] addObserverForName:kMKStoreKitRestoringPurchasesFailedNotification
//                                                      object:nil
//                                                       queue:[[NSOperationQueue alloc] init]
//                                                  usingBlock:^(NSNotification *note) {
//                                                      
//                                                      NSLog(@"Failed restoring purchases with error: %@", [note object]);
//                                                      NSNotification *notification = [[NSNotification alloc] initWithName:kSINotificationAdFreePurchasedFailed object:nil userInfo:nil];
//                                                      [[NSNotificationCenter defaultCenter] postNotification:notification];
//                                                      
//                                                  }];
//}
//#pragma mark - SIAdBannerDelegate
//- (void)adBannerWasTapped {
//    NSLog(@"Ad Banner was tapped and delegate fired");
//}
//#pragma mark - Daily Prize Methods
/////**
//// Compares a time from the internet to determine if should give a daily prize
//// */
////- (BOOL)checkForDailyPrize {
////    NSDate *currentDate = [SIGameController getDateFromInternet];
////    if (!currentDate) {
////        return NO;
////    }
////    
////    NSDate *lastPrizeGivenDate = [[NSUserDefaults standardUserDefaults] objectForKey:kSINSUserDefaultLastPrizeAwardedDate];
////    if (!lastPrizeGivenDate) {
//////        NSLog(@"Set date for first time...");
////        [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:kSINSUserDefaultLastPrizeAwardedDate];
////        [[NSUserDefaults standardUserDefaults] synchronize];
////        [self willGivePrize];
////        return YES;
////    } else {
////        NSTimeInterval timeSinceLastLaunch = [currentDate timeIntervalSince1970] - [lastPrizeGivenDate timeIntervalSince1970];
////        if (timeSinceLastLaunch > 60 * 2 && timeSinceLastLaunch < 2 * 60 * 2) { //(timeSinceLastLaunch > SECONDS_IN_DAY && timeSinceLastLaunch < 2 * SECONDS_IN_DAY) { /*Consecutive launch!!! > 24 < 48*/
//////            NSLog(@"Consecutive Launch!");
////            _willAwardPrize = YES;
////            [self willGivePrize];
////            return YES;
////            
////        } else if (timeSinceLastLaunch > 2 * 60 * 2) {  //(timeSinceLastLaunch > 2 * SECONDS_IN_DAY) { /*Non consecutive launch.... two days have passed..*/
////            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kSINSUserDefaultNumberConsecutiveAppLaunches];
////            _willAwardPrize = YES;
////            [self willGivePrize];
////            return YES;
////        } else {
//////            NSLog(@"Already launched %0.0f minutes ago",timeSinceLastLaunch / 60);
////            return NO;
////        }
////    }
////}
///**
// Configures the view to give a prize!
// */
//- (void)willGivePrize {
//    CGSize newNodeSize                  = CGSizeMake(_storeButtonNodeSize.height / 2.0f, _storeButtonNodeSize.height / 2.0f);
//    
//    SKLabelNode *label                  = [SKLabelNode labelNodeWithFontNamed:kSIFontFuturaMedium];
//    label.fontSize                      = newNodeSize.height - VERTICAL_SPACING_8 - VERTICAL_SPACING_8;
//    label.text                          = @"FREE PRIZE!";
//    label.fontColor                     = [SKColor whiteColor];
//    label.verticalAlignmentMode         = SKLabelVerticalAlignmentModeTop;
//    label.horizontalAlignmentMode       = SKLabelHorizontalAlignmentModeCenter;
//    
//    /*Make the gift node*/
//    SKSpriteNode *giftNode              = [SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageGift]];
//    giftNode.size                       = newNodeSize;
//    giftNode.anchorPoint                = CGPointMake(0.5f, 0.5f);
//    
//    /*Make the coin nodes*/
//    SKSpriteNode *coinNode1             = [SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageCoinLargeFront]];
//    coinNode1.size                      = newNodeSize;
//    coinNode1.anchorPoint               = CGPointMake(0.5f, 0.5f);
//    
//    SKSpriteNode *coinNode2             = [SKSpriteNode spriteNodeWithTexture:[[SIConstants imagesAtlas] textureNamed:kSIImageCoinLargeBack]];
//    coinNode2.size                      = newNodeSize;
//    coinNode2.anchorPoint               = CGPointMake(0.5f, 0.5f);
//    
//    /*remove the text from store node...*/
//    _storeButtonNode.text               = nil;
//    
//    /*Add the gift node to the store button node*/
//    CGFloat yNodeHeight                 = (newNodeSize.height/2.0f) + VERTICAL_SPACING_8;
//    giftNode.position                   = CGPointMake(0.0f, yNodeHeight);
//    [_storeButtonNode addChild:giftNode];
//    
//    coinNode1.position                  = CGPointMake(newNodeSize.width + VERTICAL_SPACING_4, yNodeHeight);
//    [_storeButtonNode addChild:coinNode1];
//    
//    coinNode2.position                  = CGPointMake(-1.0f * (newNodeSize.width + VERTICAL_SPACING_4), yNodeHeight);
//    [_storeButtonNode addChild:coinNode2];
//    
//    label.position                      = CGPointMake(0.0f, _storeButtonNodeSize.height - VERTICAL_SPACING_8);
//    [_storeButtonNode addChild:label];
//    
//    /*Animate the gift node*/
//    CGFloat halfRotateTime              = 0.2f;
//    SKAction *wait                      = [SKAction waitForDuration:2.0f];
//    SKAction *rotate1                   = [SKAction rotateByAngle:-0.5f duration:halfRotateTime];
//    SKAction *rotate2                   = [SKAction rotateByAngle:1.0f duration:halfRotateTime * 2];
//    SKAction *rotate3                   = [SKAction rotateByAngle:-1.0f duration:halfRotateTime * 2];
//    SKAction *rotate4                   = [SKAction rotateByAngle:1.0f duration:halfRotateTime * 2];
//    SKAction *rotate5                   = [SKAction rotateByAngle:-0.5f duration:halfRotateTime];
//    SKAction *sequence1                 = [SKAction sequence:@[rotate1, rotate2, rotate3, rotate4, rotate5, wait]];
//    [giftNode runAction:[SKAction repeatActionForever:sequence1]];
//    
////    CGFloat coinSpinTime                = 2.0f;
////    
////    SKAction *spin1                     = [SKAction rotateByAngle:M_PI * 2 duration:coinSpinTime];
////    SKAction *sequence2                 = [SKAction sequence:@[spin1]];
////    [coinNode1 runAction:[SKAction repeatActionForever:sequence2]];
////
////    SKAction *spin2                     = [SKAction rotateByAngle:-M_PI * 2 duration:coinSpinTime];
////    SKAction *sequence3                 = [SKAction sequence:@[spin2]];
////    [coinNode2 runAction:[SKAction repeatActionForever:sequence3]];
//    
//}
//
//
//@end