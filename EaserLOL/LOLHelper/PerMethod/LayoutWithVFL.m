//
//  LayoutWithVFL.m
//  LOLHelper
//
//  Created by Easer Liu on 21/06/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "LayoutWithVFL.h"

@implementation LayoutWithVFL


+(void)LayoutHView:(UIView *)view withSubviews:(NSArray *)subviews
{
    NSMutableDictionary * views = [[NSMutableDictionary alloc] init];
    NSMutableString * vflH = [NSMutableString stringWithFormat:@"H:|-"];
    NSString * viewBaseStr = [NSString stringWithFormat:@"ViewStr"];
    for (int i = 0; i < subviews.count;i++) {
        NSString * viewStr = [NSString stringWithFormat:@"%@%d",viewBaseStr,i];
        [vflH appendFormat:@"[%@]-",viewStr];
        [views setObject:subviews[i] forKey:viewStr];
        NSString * vflV = [NSString stringWithFormat:@"V:|-[%@]-|",viewStr];
        NSArray * constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:vflV options:0 metrics:NULL views:views];
        [view addConstraints:constraintsV];
    }
    [vflH appendString:@"|"];
    NSArray * constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:vflH options:0 metrics:NULL views:views];
    [view addConstraints:constraintsH];
}

+(void)LayoutVView:(UIView *)view withSubviews:(NSArray *)subviews
{
    NSMutableDictionary * views = [[NSMutableDictionary alloc] init];
    NSMutableString * vflV = [NSMutableString stringWithFormat:@"V:|-"];
    NSString * viewBaseStr = [NSString stringWithFormat:@"ViewStr"];
    for (int i = 0; i < subviews.count;i++) {
        NSString * viewStr = [NSString stringWithFormat:@"%@%d",viewBaseStr,i];
        [vflV appendFormat:@"[%@]-",viewStr];
        [views setObject:subviews[i] forKey:viewStr];
        NSString * vflH = [NSString stringWithFormat:@"H:|-[%@]-|",viewStr];
        NSArray * constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:vflH options:0 metrics:NULL views:views];
        [view addConstraints:constraintsH];
    }
    [vflV appendString:@"|"];
    NSArray * constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:vflV options:0 metrics:NULL views:views];
    [view addConstraints:constraintsV];
}


@end
