//
//  UIView+Fire.m
//  Test01
//
//  Created by Easer Liu on 27/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
#import "UIView+Fire.h"
#import <SpriteKit/SpriteKit.h>

@implementation UIView (Fire)

-(void)fireBurnAtPoint:(CGPoint)point During:(NSTimeInterval)time
{
    CGFloat durTime;
    if (time == 0) {
        durTime = 2;
    }else
    {
        durTime = time;
    }
    CGFloat imgCount = durTime*30;
    CGFloat line = CGRectGetMaxY(self.bounds)/imgCount;
    CGRect rect = CGRectMake(0, 0, CGRectGetMaxX(self.bounds), line+1);
    
    NSMutableArray * imgArr = [NSMutableArray array];
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    for(int i = 0; i < imgCount; i++)
    {
        CGContextClearRect(ctx, rect);
        UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
        [imgArr addObject:outputImage];
        rect = CGRectOffset(rect, 0, line);
    }
    UIGraphicsEndImageContext();
    
    if ([self isKindOfClass:[UIImageView class]])
    {
        [(UIImageView*)self setImage:nil];
        NSLog(@"UIImageView set");
    }
    
    UIImageView * imV = [[UIImageView alloc] initWithFrame:self.bounds];
    imV.backgroundColor = [UIColor clearColor];
    imV.animationImages = imgArr;
    // 设置动画的播放次数
    imV.animationRepeatCount = 1;
    
    // 设置播放时长
    // 1秒30帧, 一张图片的时间 = 1/30 = 0.03333 20 * 0.0333
    imV.animationDuration = durTime;
    
    [self addSubview:imV];
    // 开始动画
    [imV startAnimating];
    [self performSelector:@selector(finished) withObject:NULL afterDelay:durTime*1.5];
    [self fireBurnFromPoint:point startRect:rect farthest:self.bounds.size.height During:durTime];
    
    
}
-(void)fireBurnFromPoint:(CGPoint)point startRect:( CGRect )rect  farthest:(CGFloat)farthest During:(NSTimeInterval)durTime
{
    SKView * skv = [[SKView alloc] initWithFrame:self.bounds];
    skv.backgroundColor = [UIColor clearColor];
    [self addSubview:skv];
    
    SKScene * scene = [[SKScene alloc] initWithSize:skv.bounds.size];
    scene.scaleMode = SKSceneScaleModeResizeFill;
    scene.backgroundColor = [UIColor clearColor];
    [skv presentScene:scene];
    
    SKEmitterNode * en = [SKEmitterNode nodeWithFileNamed:@"fire002.sks"];
    en.particleSize = CGSizeMake(scene.size.width, scene.size.height);
    en.particleBirthRate = 400;
    en.position = CGPointMake(scene.size.width/2, scene.size.height);
    en.particlePositionRange = CGVectorMake(scene.size.width+30, scene.size.width/10+3);
    [scene addChild:en];
    
    SKAction * move = [SKAction moveTo:CGPointMake(scene.size.width/2, -en.particlePositionRange.dy) duration:durTime];
    SKAction * scale01 = [SKAction scaleBy:1 duration:durTime*0.3];
    SKAction * scale02 = [SKAction scaleYTo:0 duration:durTime*0.2];
    SKAction * sequence = [SKAction sequence:[NSArray arrayWithObjects:move,scale01,scale02, nil]];
    [en runAction:sequence];
}
-(void)finished
{
    [self removeFromSuperview];
    NSLog(@"Finished");
}

@end
