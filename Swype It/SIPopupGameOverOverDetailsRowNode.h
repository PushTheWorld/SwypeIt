//
//  SIPopupGameOverOverDetailsRowNode.h
//  Swype It
//
//  Created by Andrew Keller on 9/30/15.
//  Copyright © 2015 Push The World LLC. All rights reserved.
//

#import "HLComponentNode.h"

@interface SIPopupGameOverOverDetailsRowNode : HLComponentNode <NSCopying>

/**
 Create a new one
 */
- (instancetype)initWithSize:(CGSize)size;

/**
 The text label
 */
@property (nonatomic, strong) SKLabelNode *textLabel;

/**
 The score label
 */
@property (nonatomic, strong) SKLabelNode *scoreLabel;


@end
