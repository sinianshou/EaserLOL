//
//  SpotlightView.m
//  LOLHelper
//
//  Created by Easer Liu on 11/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "SpotlightView.h"

@implementation SpotlightView

-(instancetype)init
{
    self = [super init];
    self.backgroundColor = [UIColor clearColor];
    self.startColor = [NSArray arrayWithObjects:@"255", @"0", @"0", @"1", nil];
    self.endColor = [NSArray arrayWithObjects:@"4", @"26", @"35", @"0.8", nil];
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self customLightDrawWithRect:rect];
}

-(void)customLightDrawWithRect:(CGRect)rect
{
    
    
    // 创建色彩空间对象
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    // 创建起点和终点颜色分量的数组
    CGFloat colors[] =
    {
        [[self.startColor objectAtIndex:0] floatValue]/255.00, [[self.startColor objectAtIndex:1] floatValue]/255.00, [[self.startColor objectAtIndex:2] floatValue]/255.00, [[self.startColor objectAtIndex:3] floatValue],//start color(r,g,b,alpha)
        [[self.endColor objectAtIndex:0] floatValue]/255.00, [[self.endColor objectAtIndex:1] floatValue]/255.00, [[self.endColor objectAtIndex:2] floatValue]/255.00, [[self.endColor objectAtIndex:3] floatValue],//end color
    };
    
    //形成梯形，渐变的效果
    CGGradientRef gradient = CGGradientCreateWithColorComponents
    (rgb, colors, NULL, 2);
    
    //    NSLog(@"%lu",sizeof(colors)/(sizeof(colors[0])*4));
    
    // 起点颜色起始圆心
    CGPoint start = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
    // 终点颜色起始圆心
    CGPoint end = CGPointMake(self.frame.size.width/2, self.frame.size.width/2);
    // 起点颜色圆形半径
    CGFloat startRadius = 0.0f;
    // 终点颜色圆形半径
    CGFloat endRadius = self.frame.size.width/2;
    // 获取上下文
    CGContextRef graCtx = UIGraphicsGetCurrentContext();
    // 创建一个径向渐变
    CGContextDrawRadialGradient(graCtx, gradient, start, startRadius, end, endRadius, kCGGradientDrawsAfterEndLocation);
    
    //releas
    CGGradientRelease(gradient);
    gradient=NULL;
    CGColorSpaceRelease(rgb);
}

-(void)spotLightDrawWithRect:(CGRect)rect
{
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //在上下文中创建一个背景图
    CGImageRef backgroundImage = CGBitmapContextCreateImage(context);
    //将当前context压入堆栈，保存现在的context状态
    CGContextSaveGState(context);
    //翻转上下文
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // 创建色彩空间对象
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    // 创建起点颜色分量的数组
    CGFloat white[4] = {1.0,1.0,1.0,1.0};
    // 创建终点颜色分量的数组
    CGFloat black[4] = {0.0,0.0,0.0,0.8};
    CGFloat components[8] = {
        white[0],white[1],white[2],white[3],
        black[0],black[1],black[2],black[3],
    };
    // 起点和终点颜色位置
    CGFloat colorLocations[2] = {0.25,0.5};
    //创建渐变梯度CGGradientRef
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorspace, components, colorLocations, 2);
    //创建一个径向渐变
//    CGContextDrawRadialGradient(context, gradientRef, _position, 0.0f, _position, _radius * 5, 0);
    
    //释放渐变对象
    CGGradientRelease(gradientRef);
    //恢复到之前的context
    CGContextRestoreGState(context);
    
    //画背景图
    CGImageRef maskImage = CGBitmapContextCreateImage(context);
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskImage),
                                        CGImageGetHeight(maskImage),
                                        CGImageGetBitsPerComponent(maskImage),
                                        CGImageGetBitsPerPixel(maskImage),
                                        CGImageGetBytesPerRow(maskImage),
                                        CGImageGetDataProvider(maskImage),
                                        NULL,
                                        FALSE);
    CGImageRef masked = CGImageCreateWithMask(backgroundImage, mask);
    CGImageRelease(backgroundImage);
    CGContextClearRect(context, rect);
    CGContextDrawImage(context, rect, masked);
    CGImageRelease(maskImage);
    CGImageRelease(mask);
    CGImageRelease(masked);
}

@end
