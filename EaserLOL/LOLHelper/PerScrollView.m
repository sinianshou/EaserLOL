//
//  PerScrollView.m
//  LOLHelper
//
//  Created by Easer Liu on 05/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "PerScrollView.h"

@implementation PerScrollView

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"touchesBegan");
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    NSLog(@"touchesMoved");
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    NSLog(@"touchesEnded");
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    NSLog(@"touchesCancelled");
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    NSLog(@"touchesShouldCancelInContentView");
    BOOL b = [super touchesShouldCancelInContentView:view];
    return b;
}
-(void)touchesEstimatedPropertiesUpdated:(NSSet<UITouch *> *)touches
{
    [super touchesEstimatedPropertiesUpdated:touches];
    NSLog(@"touchesEstimatedPropertiesUpdated");
}
-(BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    NSLog(@"touchesShouldBegin");
    BOOL b = [super touchesShouldBegin:touches withEvent:event inContentView:view];
    return b;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
