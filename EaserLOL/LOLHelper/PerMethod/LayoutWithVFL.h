//
//  LayoutWithVFL.h
//  LOLHelper
//
//  Created by Easer Liu on 21/06/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
#ifndef LayoutWithVFL_h
#define LayoutWithVFL_h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LayoutWithVFL : NSObject

+(void)LayoutHView:(UIView *)view withSubviews:(NSArray *)subviews;
+(void)LayoutVView:(UIView *)view withSubviews:(NSArray *)subviews;

@end

#endif /* LayoutWithVFL_h */
