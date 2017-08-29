//
//  PersonalTransitionAnimator.m
//  Test01
//
//  Created by Easer Liu on 26/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "PersonalTransitionAnimator.h"
#import "UIView+Explode.h"
#import "UIView+Fire.h"

@interface PersonalTransitionAnimator ()

@property (nonatomic, strong) UIViewController * fromVC;
@property (nonatomic, strong) UIViewController * toVC;
@property (nonatomic, strong) UIImageView * snapShotV;

@end

@implementation PersonalTransitionAnimator

-(instancetype)initWithModelVC:(UIViewController *)VC
{
    self = [super init];
    
    self.modelVC = VC;
    self.animatorStyle = TransitionAnimatorStyleRandom;
    
    return self;
}

-(instancetype)init
{
    self = [super init];
    self.animatorStyle = TransitionAnimatorStyleRandom;
    return self;
}

- (void) animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    [self updateFromVCandToVCInTransition:transitionContext];
    
    switch (self.animatorStyle) {
        case TransitionAnimatorStyleBreak:
            [self breakAnimatorInTransition:transitionContext];
            break;
            
        case TransitionAnimatorStyleFire:
            [self fireAnimatorInTransition:transitionContext];
            break;
            
        default:
            [self breakAnimatorInTransition:transitionContext];
            break;
    }
    
    
}

- (NSTimeInterval) transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.1;
}

- (void) startInteractiveTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
}
-(void)animationEnded:(BOOL)transitionCompleted
{
    NSLog(@"self.fromVC.view hidden is %d self.toVC.view hidden is %d", self.fromVC.view.hidden?1:0, self.toVC.view.hidden?1:0);
    NSLog(@"self.fromVC.view.frame is %f %f %f %f, self.toVC.view.frame is %f %f %f %f", self.fromVC.view.frame.origin.x, self.fromVC.view.frame.origin.y, self.fromVC.view.frame.size.width, self.fromVC.view.frame.size.height, self.toVC.view.frame.origin.x, self.toVC.view.frame.origin.y, self.toVC.view.frame.size.width, self.toVC.view.frame.size.height );
    NSLog(@"animate fanished");
    
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
    return nil;
}
#pragma mark - subMethods
-(void)updateFromVCandToVCInTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    self.fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if ([self.toVC isEqual:self.modelVC]) {
        switch (self.toVC.modalPresentationStyle) {
            case UIModalPresentationCustom:
                if(![transitionContext.containerView.subviews containsObject:self.toVC.view])
                {
                    self.toVC.view.frame = transitionContext.containerView.bounds;
                    [transitionContext.containerView addSubview:self.toVC.view];
                    NSLog(@"add toVC");
                }
                break;
                
            case UIModalPresentationFullScreen:
                if(![transitionContext.containerView.subviews containsObject:self.toVC.view])
                {
                    self.toVC.view.frame = transitionContext.containerView.bounds;
                    [transitionContext.containerView addSubview:self.toVC.view];
                    NSLog(@"add toVC");
                }
                break;
                
            default:
                break;
        }
    }else
    {
        switch (self.toVC.modalPresentationStyle) {
            case UIModalPresentationCustom:
                
                break;
                
            case UIModalPresentationFullScreen:
                if(![transitionContext.containerView.subviews containsObject:self.toVC.view])
                {
                    self.toVC.view.frame = transitionContext.containerView.bounds;
                    [transitionContext.containerView addSubview:self.toVC.view];
                    NSLog(@"add toVC");
                }
                break;
                
            default:
                break;
        }
    }
}
-(void)breakAnimatorInTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    UIGraphicsBeginImageContext([self.fromVC.view.layer frame].size);
    [self.fromVC.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView * snapShotV = [[UIImageView alloc] initWithImage:outputImage];
    snapShotV.frame = transitionContext.containerView.bounds;
    self.fromVC.view.hidden = YES;
    self.toVC.view.hidden = NO;
    snapShotV.hidden = NO;
    [self.toVC.view addSubview:snapShotV];
    [snapShotV lp_explodeDuring:0];
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
}
-(void)fireAnimatorInTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    UIGraphicsBeginImageContext([self.fromVC.view.layer frame].size);
    [self.fromVC.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView * snapShotV = [[UIImageView alloc] initWithImage:outputImage];
    snapShotV.frame = transitionContext.containerView.bounds;
    self.fromVC.view.hidden = YES;
    self.toVC.view.hidden = NO;
    snapShotV.hidden = NO;
    [self.toVC.view addSubview:snapShotV];
    [snapShotV fireBurnAtPoint:CGPointMake(snapShotV.bounds.size.width/3, snapShotV.bounds.size.height/3) During:0.8];
    [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
}
@end
