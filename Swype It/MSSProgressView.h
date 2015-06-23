//  MSSProgressView.h
//  Digibopit
//
//  Created by Michael McEvoy on 12/1/14.
//

#import <UIKit/UIKit.h>
@interface MSSProgressView : UIView {
    
}

#pragma mark -
#pragma mark - Public Instance Properties
@property (assign, nonatomic) CGFloat    borderWidth;
@property (assign, nonatomic) CGFloat    cornerRadius;
@property (assign, nonatomic) CGFloat    progress; // On a scale from 0.0 to 1.0, where 1.0 represents 100% progress.
@property (strong, nonatomic) UIColor   *backColor;
@property (strong, nonatomic) UIColor   *borderColor;
@property (strong, nonatomic) UIColor   *progressColor;

@end
