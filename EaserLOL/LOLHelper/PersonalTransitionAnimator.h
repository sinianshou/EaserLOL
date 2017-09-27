//
//  BreakTransitionAnimator.h
//  Test01
//
//  Created by Easer Liu on 26/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
#ifndef PersonalTransitionAnimator_h
#define PersonalTransitionAnimator_h

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, TransitionAnimatorStyle) {
    
    TransitionAnimatorStyleRandom = 1,
    TransitionAnimatorStyleBreak ,
    TransitionAnimatorStyleFire ,
    TransitionAnimatorStyle3DTransform ,
};

@interface PersonalTransitionAnimator : UIPercentDrivenInteractiveTransition<UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>

@property (assign, nonatomic) TransitionAnimatorStyle animatorStyle;
@property (strong, nonatomic) UIViewController * modelVC;

-(instancetype)initWithModelVC:(UIViewController *)VC;
@end
#endif /* PersonalTransitionAnimator_h */
