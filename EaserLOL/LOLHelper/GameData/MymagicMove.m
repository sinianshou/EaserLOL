//
//  MymagicMove.m
//  LOLHelper
//
//  Created by Easer Liu on 28/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "MymagicMove.h"
#import "GameDataViewController.h"
#import "ChampionsCollectionCell.h"
#import "ChampDetailViewController.h"
@interface MymagicMove ()

@property (nonatomic, strong) UIViewController * fromController;
@property (nonatomic, strong) UIViewController * toController;
@property (nonatomic, strong) UIView * snapShotV;


@end

@implementation MymagicMove
- (instancetype)initWithModalViewController:(UIViewController *)modalViewController
{
    self = [super init];
    self.modalController = modalViewController;
    return self;
}
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    [self updateFromAndToControllerFromTransitionContext:transitionContext];
    NSLog(@"self.fromController.isBeingPresented is %d, self.fromController.isBeingDismissed is %d", self.fromController.isBeingPresented?1:0, self.fromController.isBeingDismissed?1:0);
    if (!self.fromController.isBeingDismissed) {
        [self presentedAnimateInTransitionContext:transitionContext];
    }else
    {
        [self dismissedAnimateInTransitionContext:transitionContext];
    }
}

-(void)presentedAnimateInTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    CGSize __block size = [UIScreen mainScreen].bounds.size;
    self.toController.view.frame = CGRectMake(0, 0, size.width, size.height);
    self.toController.view.alpha = 0;
    self.fromController.view.frame = CGRectMake(0, 0, size.width, size.height);
    
    
    GameDataViewController * selectedVC = ((UITabBarController *)self.fromController).selectedViewController;
    ChampionsCollectionCell * cell = [selectedVC.collectionView cellForItemAtIndexPath:[selectedVC.collectionView indexPathsForSelectedItems].firstObject];
    self.snapShotV = [cell.championIcon snapshotViewAfterScreenUpdates:NO];
    self.snapShotV.frame = [transitionContext.containerView convertRect:cell.championIcon.frame fromView:cell];
    self.snapShotV.hidden = NO;
    cell.championIcon.hidden = YES;
    ((ChampDetailViewController *)self.toController).championIcon.hidden = YES;
    
    [transitionContext.containerView addSubview:self.toController.view];
    [transitionContext.containerView addSubview:self.snapShotV];
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:5
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.toController.view.alpha = 1;
                         self.snapShotV.frame = ((ChampDetailViewController *)self.toController).championIcon.frame;
//                         self.snapShotV.frame = [transitionContext.containerView convertRect:((ChampDetailViewController *)self.toController).championIcon.frame fromView:((ChampDetailViewController *)self.toController).view];
                         
                     } completion:^(BOOL finished) {
                         self.snapShotV.hidden = YES;
                         ((ChampDetailViewController *)self.toController).championIcon.hidden = NO;
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
    
}
-(void)animationEnded:(BOOL)transitionCompleted
{
    NSLog(@"animate fanished");
    
}
-(void)dismissedAnimateInTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    CGSize __block size = [UIScreen mainScreen].bounds.size;
    self.toController.view.frame = CGRectMake(0, 0, size.width, size.height);
    self.fromController.view.frame = CGRectMake(0, 0, size.width, size.height);
    
    GameDataViewController * selectedVC = ((UITabBarController *)self.toController).selectedViewController;
    ChampionsCollectionCell * cell = [selectedVC.collectionView cellForItemAtIndexPath:[selectedVC.collectionView indexPathsForSelectedItems].firstObject];
    
    self.snapShotV.hidden = NO;
    ((ChampDetailViewController *)self.fromController).championIcon.hidden = YES;
    cell.championIcon.hidden = YES;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0
         usingSpringWithDamping:5
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.fromController.view.alpha = 0;
                         self.snapShotV.frame = [transitionContext.containerView convertRect:cell.championIcon.frame fromView:cell];
                     } completion:^(BOOL finished) {
                         self.snapShotV.hidden = YES;
                         cell.championIcon.hidden = NO;
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                         
                     }];
}

-(void)updateFromAndToControllerFromTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * v01 =self.fromController.view;
    UIView * v02 =self.toController.view;
    NSLog(@"contain v1 %d, contain v2 %d", [transitionContext.containerView.subviews containsObject:v01]?1:0, [transitionContext.containerView.subviews containsObject:v02]?1:0);
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
@end
