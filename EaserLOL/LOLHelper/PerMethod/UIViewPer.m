//
//  UIView.m
//  LOLHelper
//
//  Created by Easer Liu on 24/06/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "UIViewPer.h"
#import <objc/runtime.h>

static const void * perViewNameKey = &perViewNameKey;
static const void * perSubviewsKey = &perSubviewsKey;

@implementation UIView (per)

-(instancetype)initWithName:(NSString *)name
{
    self = [self init];
    
    self.perViewName = name;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return self;
}
-(void)perAddSubviews:(nonnull UIView *)firstView, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableDictionary * viewsDic = [[NSMutableDictionary alloc] init];
    
    if(self.perSubviews != nil)
    {
        [viewsDic addEntriesFromDictionary:self.perSubviews];
    }else
    {
        self.perSubviews = [[NSMutableDictionary alloc] init];
    }
    [self addSubview:firstView];
    [viewsDic setObject:firstView forKey:firstView.perViewName];
    // 定义一个指向个数可变的参数列表指针；
    va_list views;
    // 用于存放取出的参数
    UIView * view;
    // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
    va_start(views, firstView);
    // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)
    while ((view = va_arg(views, UIView *))) {
            [self addSubview:view];
            [viewsDic setObject:view forKey:view.perViewName];
    }
    [viewsDic addEntriesFromDictionary:self.perSubviews];
    [self.perSubviews removeAllObjects];
    self.perSubviews = viewsDic;
    // 清空参数列表，并置参数指针args无效
    va_end(views);
}

-(void)perAddConstraints:(nonnull NSString *)firstVFL, ... NS_REQUIRES_NIL_TERMINATION
{
    
    NSArray * constraints = [NSLayoutConstraint constraintsWithVisualFormat:firstVFL options:0 metrics:NULL views:self.perSubviews];
    [self addConstraints:constraints];
    // 定义一个指向个数可变的参数列表指针；
    va_list VFLs;
    // 用于存放取出的参数
    NSString * VFL;
    // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
    va_start(VFLs, firstVFL);
    // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)
    while ((VFL = va_arg(VFLs, NSString *))) {
        NSArray * constraints = [NSLayoutConstraint constraintsWithVisualFormat:VFL options:0 metrics:NULL views:self.perSubviews];
        [self addConstraints:constraints];
    }
    // 清空参数列表，并置参数指针args无效
    va_end(VFLs);
}

-(void)setPerViewName:(NSString *)perViewName
{
    objc_setAssociatedObject(self, perViewNameKey, perViewName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSString *)perViewName
{
    return objc_getAssociatedObject(self, perViewNameKey);
}
-(void)setPerSubviews:(NSMutableDictionary *)perSubviews
{
    objc_setAssociatedObject(self, perSubviewsKey, perSubviews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSMutableDictionary *)perSubviews
{
    return objc_getAssociatedObject(self, perSubviewsKey);
}
@end
