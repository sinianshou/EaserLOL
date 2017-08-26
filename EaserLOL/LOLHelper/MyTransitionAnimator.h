//
//  MyTransitionAnimator.h
//  LOLHelper
//
//  Created by Easer Liu on 6/13/17.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTransitionAnimator : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>

@property CGFloat behindViewScale;
@property CGFloat behindViewAlpha;

- (id)initWithModalViewController:(UIViewController *)modalViewController;

@end
