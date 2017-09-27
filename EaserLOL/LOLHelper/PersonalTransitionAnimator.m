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
            
        case TransitionAnimatorStyle3DTransform:
            [self TransformAnimatorInTransition:transitionContext];
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
    
    [UIView animateWithDuration:0.75 animations:^{
        [snapShotV fireBurnDuring:0.5];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
-(void)TransformAnimatorInTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext
{
    CGSize viewSize = transitionContext.containerView.bounds.size;
    CATransform3D __block transform00 = CATransform3DIdentity;
    transform00 = CATransform3DRotate(transform00, M_PI_2, 0, 1, 0);
    //    transform00 = CATransform3DTranslate(transform00, 0, 0, viewSize.width/2);
    
    CATransform3D transform01 = CATransform3DIdentity;
    transform01 = CATransform3DRotate(transform01, M_PI_4, 0, 1, 0);
    //    transform01 = CATransform3DTranslate(transform01, 0, 0, viewSize.width/2);
    
    CATransform3D __block transform02 = CATransform3DIdentity;
    //    transform02 = CATransform3DTranslate(transform02, 0, 0, viewSize.width/2);
    
    CATransform3D transform03 = CATransform3DIdentity;
    transform03 = CATransform3DRotate(transform03, -M_PI_4, 0, 1, 0);
    
    CATransform3D transform04 = CATransform3DIdentity;
    transform04 = CATransform3DRotate(transform04, -M_PI_2, 0, 1, 0);
    
    CATransform3D __block transform05 = CATransform3DIdentity;
    transform05 = CATransform3DRotate(transform05, M_PI_2, 1, 0, 0);
    
    CGFloat __block durTime = 0.8;
    CATransform3D __block transform10 = CATransform3DIdentity;
    //    transform10.m34 = -1.0 / 500.0;
    
    transitionContext.containerView.layer.sublayerTransform = CATransform3DIdentity;
    self.fromVC.view.center =  CGPointMake(viewSize.width/2, viewSize.height/2);
    self.fromVC.view.layer.anchorPointZ = -viewSize.width/2;
    self.fromVC.view.layer.transform = transform02;
    CALayer __block *fromVClayer = [CALayer layer];
    fromVClayer.frame = self.fromVC.view.bounds;
    [self.fromVC.view.layer addSublayer:fromVClayer];
    self.toVC.view.center =  CGPointMake(viewSize.width/2, viewSize.height/2);
    self.toVC.view.layer.anchorPointZ = -viewSize.width/2;
    self.toVC.view.layer.transform = transform00;
    CALayer __block *toVClayer = [CALayer layer];
    toVClayer.frame = self.toVC.view.bounds;
    [self.toVC.view.layer addSublayer:toVClayer];
    if (self.snapShotV == nil) {
        self.snapShotV = [[UIImageView alloc] init];
        self.snapShotV.bounds = CGRectMake(0, 0, viewSize.width, viewSize.width);
//        self.snapShotV.backgroundColor = [UIColor greenColor];
        self.snapShotV.center = CGPointMake(viewSize.width/2, viewSize.height/2);
        
        UIImage * im = [UIImage imageNamed:@"HeaderNews"];
        [self.snapShotV setImage:im];
    }
    if (![transitionContext.containerView.subviews containsObject:self.snapShotV]) {
        [transitionContext.containerView addSubview:self.snapShotV];
    }
    self.snapShotV.layer.anchorPointZ = -viewSize.height/2;
    self.snapShotV.layer.transform = transform05;
    CALayer *snapShotVlayer = [CALayer layer];
    snapShotVlayer.frame = self.snapShotV.bounds;
    [self.snapShotV.layer addSublayer:snapShotVlayer];
    
    //    CATransform3D transformCur00 = transform00;
    //    transformCur00 = CATransform3DRotate(transform00, -M_PI_2, 0, 1, 0);
    //
    //    CATransform3D transformCur02 = transform02;
    //    transformCur02 = CATransform3DRotate(transform02, -M_PI_2, 0, 1, 0);
    //
    //    CATransform3D transformCur05 = transform05;
    //    transformCur05 = CATransform3DRotate(transform05, M_PI_2, 0, 1, 0);
    //
    //    CATransform3D transformCur10 = transform10;
    //    transformCur10 = CATransform3DRotate(transformCur10, -M_PI_4, 1, 0, 0);
    //    transformCur10 =  CATransform3DScale(transformCur10, 0.5, 0.5, 0.5);
    //    transitionContext.containerView.layer.sublayerTransform = transformCur10;
    
    int __block countDny = 0;
    CGFloat __block countSta = durTime/0.03;
    snapShotVlayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    [NSTimer scheduledTimerWithTimeInterval:durTime/countSta repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        transform02 = CATransform3DRotate(transform02, -M_PI_2/countSta, 0, 1, 0);
        transform00 = CATransform3DRotate(transform00, -M_PI_2/countSta, 0, 1, 0);
        transform05 = CATransform3DRotate(transform05, M_PI_2/countSta, 0, 0, 1);
        fromVClayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8*(countDny/countSta)].CGColor;
        toVClayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8*(1-countDny/countSta)].CGColor;
        if (countDny < countSta/2) {
            //            transform10.m34 = -1.0/500.0*(countDny/countSta);
            transform10 = CATransform3DRotate(transform10, -M_PI_4/countSta, 1, 0, 0);
            transform10 = CATransform3DScale(transform10, (countSta-2)/countSta, (countSta-2)/countSta, (countSta-2)/countSta);
            NSLog(@"count01 < durTime/timer.timeInterval/2");
        }else
        {
            //            transform10.m34 = -1.0/500.0*(1-countDny/countSta);
            transform10 = CATransform3DRotate(transform10, M_PI_4/(durTime/timer.timeInterval), 1, 0, 0);
            transform10 = CATransform3DScale(transform10, countSta/(countSta-2), countSta/(countSta-2), countSta/(countSta-2));
            NSLog(@"count01 >= durTime/timer.timeInterval/2");
        }
        transitionContext.containerView.layer.sublayerTransform = transform10;
        self.fromVC.view.layer.transform = transform02;
        self.toVC.view.layer.transform = transform00;
        self.snapShotV.layer.transform = transform05;
        NSLog(@"count01 is %d", countDny);
        countDny += 1;
        if (countDny > countSta) {
            [timer invalidate];
            [UIView animateWithDuration:0.2 animations:^{
                transitionContext.containerView.layer.sublayerTransform = CATransform3DIdentity;
                self.toVC.view.layer.transform = CATransform3DIdentity;
                fromVClayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0].CGColor;
                toVClayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0].CGColor;
            } completion:^(BOOL finished) {
                [[self.fromVC.view.layer.sublayers lastObject] removeFromSuperlayer];
                [[self.toVC.view.layer.sublayers lastObject] removeFromSuperlayer];
                [snapShotVlayer removeFromSuperlayer];
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            }];
        }
    }];
}
@end
