//
//  UIView.h
//  LOLHelper
//
//  Created by Easer Liu on 24/06/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
#ifndef UIViewPer_h
#define UIViewPer_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (per)

@property (nonatomic, strong, nullable) NSString * perViewName;
@property (nonatomic, strong, nullable) NSMutableDictionary * perSubviews;

-(nonnull instancetype)initWithName:(nonnull NSString *)name;
-(void)perAddSubviews:(nonnull UIView *)firstView, ... NS_REQUIRES_NIL_TERMINATION;
-(void)perAddConstraints:(nonnull NSString *)firstVFL, ... NS_REQUIRES_NIL_TERMINATION;
@end
#endif /* UIViewPer_h */
