//
//  HonorView.m
//  LOLHelper
//
//  Created by Easer Liu on 24/06/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "HonorView.h"
#import "UIViewPer.h"

@implementation HonorView



-(instancetype)initWithName:(NSString *)name viewType:(ViewType) viewType
{
    if([self respondsToSelector:@selector(init)])
    {
        NSLog(@"initWithName: 存在");
    }else
    {
        NSLog(@"initWithName: 不存在");
    }
    
    
    self = [super init];
    self.perViewName = name;
    
    self.viewType = viewType;
    
    UIImageView * honorImgV = [[UIImageView alloc] init];
    honorImgV.perViewName = @"honorImgV";
    //    honorImgV.bounds = CGRectMake(0, 0, 45, 45);
    honorImgV.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILabel * honorNumLa = [[UILabel alloc] init];
    honorNumLa.perViewName = @"honorNumLa";
    honorNumLa.font = [UIFont systemFontOfSize:6];
    honorNumLa.translatesAutoresizingMaskIntoConstraints = NO;
    honorNumLa.textAlignment = NSTextAlignmentCenter;
    
    UILabel * honorNameLa = [[UILabel alloc] init];
    honorNameLa.perViewName = @"honorNameLa";
    honorNameLa.translatesAutoresizingMaskIntoConstraints = NO;
    honorNameLa.font = [UIFont systemFontOfSize:10];
    honorNameLa.textAlignment = NSTextAlignmentCenter;
    [self perAddSubviews:honorImgV, honorNumLa, honorNameLa, nil];
    
    [self bringSubviewToFront:honorNumLa];
    return self;
}
//-(instancetype)init
//{
//    self = [super init];
//    UIImageView * honorImgV = [[UIImageView alloc] init];
//    honorImgV.perViewName = @"honorImgV";
////    honorImgV.bounds = CGRectMake(0, 0, 45, 45);
//    honorImgV.translatesAutoresizingMaskIntoConstraints = NO;
//
//    UILabel * honorNumLa = [[UILabel alloc] init];
//    honorNumLa.perViewName = @"honorNumLa";
//    honorNumLa.font = [UIFont systemFontOfSize:6];
//    honorNumLa.translatesAutoresizingMaskIntoConstraints = NO;
//    honorNumLa.textAlignment = NSTextAlignmentCenter;
//
//    UILabel * honorNameLa = [[UILabel alloc] init];
//    honorNameLa.perViewName = @"honorNameLa";
//    honorNameLa.translatesAutoresizingMaskIntoConstraints = NO;
//    honorNameLa.font = [UIFont systemFontOfSize:10];
//    honorNameLa.textAlignment = NSTextAlignmentCenter;
//    [self perAddSubviews:honorImgV, honorNumLa, honorNameLa, nil];
//
//    [self bringSubviewToFront:honorNumLa];
//    return self;
//}

-(void)layoutSubviews
{
    [super layoutSubviews];
    switch (self.viewType) {
        case LeagueViewType:
            [self autoLayoutLeagueViewType];
            break;
            
        case HonorViewType:
            [self autoLayoutHonorViewType];
            break;
            
        default:
            break;
    }
}
-(void)autoLayoutHonorViewType
{
    int heiRest = (self.bounds.size.height - 60)/2;
    int widRest = (self.bounds.size.width - 45)/2;
    NSString * vflV01 = [NSString stringWithFormat:@"V:[honorImgV(45)]-5-[honorNameLa(10)]-%d-|",heiRest];
    NSString * vflV02 = [NSString stringWithFormat:@"V:[honorNumLa(10)]-6-[honorNameLa(10)]-%d-|",heiRest];
    NSString * vflH01 = [NSString stringWithFormat:@"H:|-%d-[honorImgV(45)]-%d-|",widRest,widRest];
    NSString * vflH02 = [NSString stringWithFormat:@"H:|[honorNumLa]|"];
    NSString * vflH03 = [NSString stringWithFormat:@"H:|[honorNameLa]|"];
    [self perAddConstraints:vflV01, vflV02, vflH01, vflH02, vflH03, nil];
}

-(void)setHonorViewWithType:(HonorType)honorType Num:(NSString *)num
{
    UIImageView * honorImgV = [self.perSubviews objectForKey:@"honorImgV"];
    UILabel * honorNumLa = [self.perSubviews objectForKey:@"honorNumLa"];
    UILabel * honorNameLa = [self.perSubviews objectForKey:@"honorNameLa"];
    
    
    UIImage * honorImg = nil;
    NSMutableString * imgStr = nil;
    NSString * honorName = nil;
    switch (honorType) {
        case PentaKill:
            imgStr = [NSMutableString stringWithFormat:@"personal_honor_type_penta_kill"];
            honorName = @"五杀";
            break;
        case QuadraKill:
            imgStr = [NSMutableString stringWithFormat:@"personal_honor_type_ultra_kill"];
            honorName = @"四杀";
            break;
        case TripleKill:
            imgStr = [NSMutableString stringWithFormat:@"personal_honor_type_triple_kill"];
            honorName = @"三杀";
            break;
            
        default:
            break;
    }
    
    if (num.intValue == 0) {
        [imgStr appendString:@"_gray"];
    }
    honorImg = [UIImage imageNamed:imgStr];
    honorImgV.image = honorImg;
    honorNumLa.text = [NSString stringWithFormat:@"%@次",num];
    honorNameLa.text = honorName;    
}
-(void)autoLayoutLeagueViewType
{
    int heiRest = (self.bounds.size.height - 75)/2;
    int widRest = (self.bounds.size.width - 72)/2;
    NSString * vflV01 = [NSString stringWithFormat:@"V:[honorImgV(60)]-5-[honorNameLa(10)]-%d-|",heiRest];
    NSString * vflH01 = [NSString stringWithFormat:@"H:|-%d-[honorImgV(72)]",widRest];
    NSString * vflH02 = [NSString stringWithFormat:@"H:|[honorNameLa]|"];
    [self perAddConstraints:vflV01, vflH01, vflH02,  nil];
}
-(void)setLeagueViewWithType:(LeagueType) LeagueType duanwei:(NSString *)duanwei
{
    UIImageView * honorImgV = [self.perSubviews objectForKey:@"honorImgV"];
    UILabel * honorNumLa = [self.perSubviews objectForKey:@"honorNumLa"];
    UILabel * honorNameLa = [self.perSubviews objectForKey:@"honorNameLa"];
    UIImage * honorImg = nil;
    NSMutableString * imgStr = nil;
    imgStr = [NSMutableString stringWithFormat:@"personal_stage_%d",(int)LeagueType];
    honorImg = [UIImage imageNamed:imgStr];
    honorImgV.image = honorImg;
    honorNumLa.hidden = YES;
    honorNameLa.text = [NSString stringWithFormat:@"%@",duanwei];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
