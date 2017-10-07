//
//  MyTransitionAnimator.m
//  LOLHelper
//
//  Created by Easer Liu on 6/13/17.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "MyTransitionAnimator.h"

typedef NS_ENUM(NSUInteger, ZFModalTransitonDirection) {
    ZFModalTransitonDirectionBottom,
    ZFModalTransitonDirectionLeft,
    ZFModalTransitonDirectionRight,
};

@interface MyTransitionAnimator()

@property BOOL isInteractive;
@property ZFModalTransitonDirection direction;
@property (nonatomic, strong) UIViewController *modalController;
@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;
@property CGFloat panLocationStart;

@end

@implementation MyTransitionAnimator

- (instancetype)initWithModalViewController:(UIViewController *)modalViewController
{
    self = [super init];
    _modalController = modalViewController;
    _direction = ZFModalTransitonDirectionLeft;
    _behindViewScale = 0.9f;
    _behindViewAlpha = 1.0f;
    //添加拖动手势
    UIPanGestureRecognizer * pan01 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    pan01.minimumNumberOfTouches = 1;
    pan01.maximumNumberOfTouches = 2;
    pan01.delegate = self;
    [modalViewController.view addGestureRecognizer:pan01];
    return self;
}


-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isInteractive) {        
        return;
    }
    // Grab the from and to view controllers from the context
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    
    if (!fromViewController.isBeingDismissed) {
        
        CGRect startRect = CGRectZero;

        [[transitionContext containerView] addSubview:toViewController.view];

//        toViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        if (self.direction == ZFModalTransitonDirectionBottom) {
            startRect = CGRectMake(0,
                                   CGRectGetHeight(toViewController.view.frame),
                                   CGRectGetWidth(toViewController.view.bounds),
                                   CGRectGetHeight(toViewController.view.bounds));
        } else if (self.direction == ZFModalTransitonDirectionLeft) {
            startRect = CGRectMake(-CGRectGetWidth(toViewController.view.frame),
                                   0,
                                   CGRectGetWidth(toViewController.view.bounds),
                                   CGRectGetHeight(toViewController.view.bounds));
        }else if (self.direction == ZFModalTransitonDirectionRight) {
            startRect = CGRectMake(CGRectGetWidth(toViewController.view.frame),
                                   0,
                                   CGRectGetWidth(toViewController.view.bounds),
                                   CGRectGetHeight(toViewController.view.bounds));
        }
        
//        CGPoint transformedPoint = CGPointApplyAffineTransform(startRect.origin, toViewController.view.transform);
//        toViewController.view.frame = CGRectMake(transformedPoint.x, transformedPoint.y, startRect.size.width, startRect.size.height);
        toViewController.view.frame = startRect;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
             usingSpringWithDamping:5
              initialSpringVelocity:5
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [self doScaleVC:fromViewController WithA:self.behindViewScale D:self.behindViewScale alpha:self.behindViewAlpha moveVC:toViewController toFrame:CGRectMake(0,0,CGRectGetWidth(toViewController.view.frame),CGRectGetHeight(toViewController.view.frame))];
                             
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                             
                         }];
    } else {
        
        [[transitionContext containerView] bringSubviewToFront:fromViewController.view];
        
        toViewController.view.alpha = self.behindViewAlpha;
        
        CGRect endRect = CGRectZero;
        
        if (self.direction == ZFModalTransitonDirectionBottom) {
            endRect = CGRectMake(0,
                                 CGRectGetHeight(fromViewController.view.bounds),
                                 CGRectGetWidth(fromViewController.view.frame),
                                 CGRectGetHeight(fromViewController.view.frame));
        } else if (self.direction == ZFModalTransitonDirectionLeft) {
            endRect = CGRectMake(-CGRectGetWidth(fromViewController.view.bounds),
                                 0,
                                 CGRectGetWidth(fromViewController.view.frame),
                                 CGRectGetHeight(fromViewController.view.frame));
        } else if (self.direction == ZFModalTransitonDirectionRight) {
            endRect = CGRectMake(CGRectGetWidth(fromViewController.view.bounds),
                                 0,
                                 CGRectGetWidth(fromViewController.view.frame),
                                 CGRectGetHeight(fromViewController.view.frame));
        }
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0
             usingSpringWithDamping:5
              initialSpringVelocity:5
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
//                             CGFloat scaleBack = (1 / self.behindViewScale);
//                             toViewController.view.layer.transform = CATransform3DScale(toViewController.view.layer.transform, scaleBack, scaleBack, 1);
                             [self doScaleVC:toViewController WithA:1 D:1 alpha:1 moveVC:fromViewController toFrame:endRect];
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                             
                         }];
    }

}

- (void)animationEnded:(BOOL)transitionCompleted
{
    // Reset to our default state
    self.isInteractive = NO;
    self.transitionContext = nil;
    
}

-(void)doScaleVC:(UIViewController*) scaleVC WithA:(CGFloat) a D:(CGFloat) d alpha:(CGFloat)alpha moveVC:(UIViewController*) moveVC toFrame:(CGRect) toRect
{
    scaleVC.view.transform = CGAffineTransformMakeScale(a, d);
    scaleVC.view.alpha = alpha;
    moveVC.view.frame = toRect;
}

#pragma mark - UIViewControllerTransitioningDelegate Methods

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}
//
- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    if (self.isInteractive ) {
        return self;
    }
    return nil;
}

#pragma mark - UIPercentDrivenInteractiveTransition Methods

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    if (self.transitionContext == nil) {
        NSLog(@"start里为空");
    }else
    {
        NSLog(@"start里不为空");
    }
    NSLog(@"执行了start");
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (fromVC == nil) {
        NSLog(@"start里fromVC为空");
    }else
    {
        NSLog(@"start里fromVC不为空");
    }
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (toVC == nil) {
        NSLog(@"start里toVC为空");
    }else
    {
        NSLog(@"start里toVC不为空");
    }
    [[transitionContext containerView] bringSubviewToFront:fromVC.view];
    toVC.view.alpha = self.behindViewAlpha;
}
-(void)updateInteractiveTransition:(CGFloat)percentComplete
{
    if (percentComplete < 0) {
        percentComplete = 0;
    }
    
    id<UIViewControllerContextTransitioning> transitionContext = self.transitionContext;
    
    if (self.transitionContext == nil) {
        NSLog(@"update里为空");
    }else
    {
        NSLog(@"update里不为空");
    }
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (fromVC == nil) {
        NSLog(@"update里fromVC为空");
    }else
    {
        NSLog(@"update里fromVC不为空");
    }
    UIViewController * toVC = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (toVC == nil) {
        NSLog(@"update里toVC为空");
    }else
    {
        NSLog(@"update里toVC不为空");
    }
    CGFloat sc = 0.5 + 0.5 * percentComplete;
    CGFloat alpha = self.behindViewAlpha + (1-self.behindViewAlpha)*percentComplete;
    CGRect toFrame = CGRectMake(-(CGRectGetWidth(fromVC.view.bounds) * percentComplete),
                                0,
                                CGRectGetWidth(fromVC.view.frame),
                                CGRectGetHeight(fromVC.view.frame));

    [self doScaleVC:toVC WithA:sc D:sc alpha:alpha moveVC:fromVC toFrame:toFrame];
}
-(void)cancelInteractiveTransition
{
    [super cancelInteractiveTransition];
    if (self.transitionContext == nil) {
        NSLog(@"cancel里为空");
    }else
    {
        NSLog(@"cancel里不为空");
    }
    UIViewController * fromVC = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (fromVC == nil) {
        NSLog(@"cancel里fromVC为空");
    }else
    {
        NSLog(@"cancel里fromVC不为空");
    }
    UIViewController * toVC = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (toVC == nil) {
        NSLog(@"cancel里toVC为空");
    }else
    {
        NSLog(@"cancel里toVC不为空");
    }

    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:5
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self doScaleVC:toVC WithA:self.behindViewScale D:self.behindViewScale alpha:self.behindViewAlpha moveVC:fromVC toFrame:CGRectMake(0,0,CGRectGetWidth(fromVC.view.frame),CGRectGetHeight(fromVC.view.frame))];

                     } completion:^(BOOL finished) {
                         [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];

                     }];


}
-(void)finishInteractiveTransition
{
    [super finishInteractiveTransition];
    if (self.transitionContext == nil) {
        
        NSLog(@"finish里为空");
    }else
    {
        NSLog(@"finish里不为空");
    }
    UIViewController * fromVC = [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (fromVC == nil) {
        NSLog(@"finish里fromVC为空");
    }else
    {
        NSLog(@"finish里fromVC不为空");
    }
    UIViewController * toVC = [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (toVC == nil) {
        NSLog(@"finish里toVC为空");
    }else
    {
        NSLog(@"finish里toVC不为空");
    }
    
    [[self.transitionContext containerView] bringSubviewToFront:fromVC.view];
    
    //        if (![self isIOS8]) {
    //            toViewController.view.layer.transform = CATransform3DScale(toViewController.view.layer.transform, self.behindViewScale, self.behindViewScale, 1);
    //        }
    
    toVC.view.alpha = self.behindViewAlpha;
    
    CGRect endRect = CGRectZero;
    
    if (self.direction == ZFModalTransitonDirectionBottom) {
        endRect = CGRectMake(0,
                             CGRectGetHeight(fromVC.view.bounds),
                             CGRectGetWidth(fromVC.view.frame),
                             CGRectGetHeight(fromVC.view.frame));
    } else if (self.direction == ZFModalTransitonDirectionLeft) {
        endRect = CGRectMake(-CGRectGetWidth(fromVC.view.bounds),
                             0,
                             CGRectGetWidth(fromVC.view.frame),
                             CGRectGetHeight(fromVC.view.frame));
    } else if (self.direction == ZFModalTransitonDirectionRight) {
        endRect = CGRectMake(CGRectGetWidth(fromVC.view.bounds),
                             0,
                             CGRectGetWidth(fromVC.view.frame),
                             CGRectGetHeight(fromVC.view.frame));
    }
    
    //        CGPoint transformedPoint = CGPointApplyAffineTransform(endRect.origin, fromViewController.view.transform);
    //        endRect = CGRectMake(transformedPoint.x, transformedPoint.y, endRect.size.width, endRect.size.height);
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:5
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self doScaleVC:toVC WithA:1 D:1 alpha:1 moveVC:fromVC toFrame:endRect];
                     } completion:^(BOOL finished) {
                         [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
                         
                     }];
}

#pragma mark - GestureRecognizer Methods

-(void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    // Location reference
    CGPoint location = [panGesture locationInView:self.modalController.view.window];
    location = CGPointApplyAffineTransform(location, CGAffineTransformInvert(panGesture.view.transform));
    // Velocity reference
    CGPoint velocity = [panGesture velocityInView:[self.modalController.view window]];
    velocity = CGPointApplyAffineTransform(velocity, CGAffineTransformInvert(panGesture.view.transform));
    
    
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.isInteractive = YES;
            self.panLocationStart = location.x;
            [self.modalController dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat animationRatio = (self.panLocationStart - location.x) / (CGRectGetWidth([self.modalController view].bounds));
            [self updateInteractiveTransition:animationRatio];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGFloat velocityForSelectedDirection = velocity.x;
            if (velocityForSelectedDirection > 100
                && (self.direction == ZFModalTransitonDirectionRight
                    || self.direction == ZFModalTransitonDirectionBottom)) {
                    [self finishInteractiveTransition];
                } else if (velocityForSelectedDirection < -100 && self.direction == ZFModalTransitonDirectionLeft) {
                    [self finishInteractiveTransition];
                } else {
                    [self cancelInteractiveTransition];
                }
            self.isInteractive = NO;
        }
            break;
        case UIGestureRecognizerStateCancelled:
            
            break;
        case UIGestureRecognizerStateFailed:
            
            break;
            
        default:
            break;
    }
}
-(void)handleSwipeGesture:(UISwipeGestureRecognizer *)swipeGesture
{}

@end
