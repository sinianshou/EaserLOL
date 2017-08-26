//
//  AssistiveTouch.h
//  LOLHelper
//
//  Created by Easer Liu on 16/06/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssistiveTouch : UIWindow <CAAnimationDelegate>

@property  (strong, nonatomic) UIButton * centerButton;
@property  (strong, nonatomic) NSMutableArray<UIButton*>* circleButtons;
@property  (strong, nonatomic) UIColor * ciecleColor;

-(id) initWithFrame:(CGRect)frame;
-(void)setCenterButtonWithRadius:(CGFloat)CBRadius;
-(void)setCenterButtonIconForState:(NSArray *)IconStateArrs;
-(void)setCircleButtonsWithImgs: (NSArray<UIImage*>*) iconArray Radius:(CGFloat) circleButtonRadius;

@end
