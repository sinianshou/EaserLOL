//
//  MymagicMove.h
//  LOLHelper
//
//  Created by Easer Liu on 28/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
#ifndef MymagicMove_h
#define MymagicMove_h

#import <UIKit/UIKit.h>

@interface MymagicMove : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIViewController * modalController;

- (instancetype)initWithModalViewController:(UIViewController *)modalViewController;

@end
#endif /* MymagicMove_h */
