//
//  UIView+CoreAnimation.h
//  CoreAnimationPlayGround
//
//  Created by Daniel Tavares on 27/03/2013.
//  Copyright (c) 2013 Daniel Tavares. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Explode) <CAAnimationDelegate>

- (void)lp_explodeDuring:(NSTimeInterval)time;

@end
