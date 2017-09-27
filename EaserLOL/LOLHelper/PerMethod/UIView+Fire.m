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

-(void)fireBurnDuring:(NSTimeInterval)time
{
    CGFloat durTime;
    if (time == 0) {
        durTime = 2;
    }else
    {
        durTime = time;
    }
    
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    UIImage * outputImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if ([self isKindOfClass:[UIImageView class]])
    {
        [(UIImageView*)self setImage:nil];
        NSLog(@"UIImageView set");
    }
    
    UIImageView * imV = [[UIImageView alloc] initWithFrame:self.bounds];
    imV.backgroundColor = [UIColor clearColor];
    [self addSubview:imV];
    imV.image =  outputImage;
    
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
    
    CGRect __block rect = CGRectMake(0, 0, CGRectGetMaxX(self.bounds), 0);
    CGFloat __block t1 = durTime;
    NSTimer * timer =[NSTimer scheduledTimerWithTimeInterval:0.03 repeats:YES block:^(NSTimer * _Nonnull timer) {
        t1 -= (CGFloat)timer.timeInterval;
        if (t1 >= 0) {
            en.position = CGPointMake(en.position.x, self.bounds.size.height*(t1/durTime));
            
            rect = CGRectMake(0, 0, rect.size.width, self.bounds.size.height*(1-t1/durTime));
            CGContextClearRect(ctx, rect);
            UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
            imV.image = img;
        }else if(t1 <= -durTime*0.3)
        {
            [timer invalidate];
            SKAction * scale = [SKAction scaleYTo:0 duration:durTime*0.2];
            [en runAction:scale completion:^{
                UIGraphicsEndImageContext();
                [self removeFromSuperview];
                NSLog(@"Finished");
            }];
        }else
        {
            imV.hidden = YES;
            en.position = CGPointMake(en.position.x, self.bounds.size.height*(t1/durTime) < -en.particlePositionRange.dy?-en.particlePositionRange.dy:self.bounds.size.height*(t1/durTime));
        }
    }];
    
}

@end

