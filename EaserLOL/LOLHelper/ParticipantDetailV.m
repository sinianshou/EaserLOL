//
//  ParticipantDetailV.m
//  LOLHelper
//
//  Created by Easer Liu on 05/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "ParticipantDetailV.h"
@interface ParticipantDetailV ()


@end

@implementation ParticipantDetailV


-(instancetype)init
{
    self = [super init];
    
    [self initView01];
    [self initView02];
    [self addTarget:self action:@selector(clickView) forControlEvents:UIControlEventTouchUpInside];
    self.bounds = self.View01.bounds;
    self.View01.backgroundColor = [UIColor whiteColor];
    self.View02.backgroundColor = [UIColor colorWithRed:210/225.00 green:210/225.00 blue:210/225.00 alpha:1];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = self.View02.backgroundColor.CGColor;
    return self;
}
-(void)initView01
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.View01 = [[UIView alloc] init];
    self.ChampIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    self.ChampIcon.layer.cornerRadius = 30;
    self.ChampIcon.clipsToBounds = YES;
    [self.View01 addSubview:self.ChampIcon];
    
    self.item0 = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.ChampIcon.frame.origin.y + self.ChampIcon.frame.size.height +10, 32, 32)];
    [self.View01 addSubview:self.item0];
    self.item1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.item0.frame.origin.x + self.item0.frame.size.width + 5, self.item0.frame.origin.y, 32, 32)];
    [self.View01 addSubview:self.item1];
    self.item2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.item1.frame.origin.x + self.item1.frame.size.width + 5, self.item1.frame.origin.y, 32, 32)];
    [self.View01 addSubview:self.item2];
    self.item3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.item2.frame.origin.x + self.item2.frame.size.width + 5, self.item2.frame.origin.y, 32, 32)];
    [self.View01 addSubview:self.item3];
    self.item4 = [[UIImageView alloc] initWithFrame:CGRectMake(self.item3.frame.origin.x + self.item3.frame.size.width + 5, self.item3.frame.origin.y, 32, 32)];
    [self.View01 addSubview:self.item4];
    self.item5 = [[UIImageView alloc] initWithFrame:CGRectMake(self.item4.frame.origin.x + self.item4.frame.size.width + 5, self.item4.frame.origin.y, 32, 32)];
    [self.View01 addSubview:self.item5];
    self.item6 = [[UIImageView alloc] initWithFrame:CGRectMake(self.item5.frame.origin.x + self.item5.frame.size.width + 5, self.item5.frame.origin.y, 32, 32)];
    NSLog(@"item6 left is %f scren width is %f", self.item6.frame.origin.x + self.item6.frame.size.width, [UIScreen mainScreen].bounds.size.width);
    [self.View01 addSubview:self.item6];
    
    
    self.kda = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width - 40-10, CGRectGetMidY(self.ChampIcon.frame) - 20 , 40, 16)];
    self.kda.font = [UIFont systemFontOfSize:10];
    [self.View01 addSubview:self.kda];
    UIImageView * kdaImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.kda.frame.origin.x - 16, self.kda.frame.origin.y, 16, 16)];
    kdaImg.image = [UIImage imageNamed:@"score"];
    [self.View01 addSubview:kdaImg];
    self.goldEarned = [[UILabel alloc] initWithFrame:CGRectMake(kdaImg.frame.origin.x - 40, self.kda.frame.origin.y, 40, 16)];
    self.goldEarned.font = [UIFont systemFontOfSize:10];
    [self.View01 addSubview:self.goldEarned];
    UIImageView * goldImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.goldEarned.frame.origin.x - 16, self.kda.frame.origin.y, 16, 16)];
    UIImage * im =[UIImage imageNamed:@"gold"];
    goldImg.image = im;
    [self.View01 addSubview:goldImg];
    
    self.summonerName = [[UILabel alloc] initWithFrame:CGRectMake(self.ChampIcon.frame.origin.x + self.ChampIcon.frame.size.width + 10, self.ChampIcon.frame.origin.y, CGRectGetMidX(goldImg.frame) - CGRectGetMaxX(self.ChampIcon.frame) , self.ChampIcon.frame.size.height/2)];
    self.summonerName.lineBreakMode = NSLineBreakByTruncatingTail;
//    self.summonerName.font = [UIFont systemFontOfSize:self.summonerName.bounds.size.height*0.6];
    [self.View01 addSubview:self.summonerName];
    
    self.isExported = [[UIImageView alloc] initWithFrame:CGRectMake(screenSize.width - 9-10, self.item6.frame.origin.y + self.item6.frame.size.height -9, 9, 9)];
    self.isExported.image = [UIImage imageNamed:@"club_fans_circle_control_arrow_down"];
    [self.View01 addSubview:self.isExported];
    
    self.View01.frame = CGRectMake(0, 0, screenSize.width, self.isExported.frame.origin.y + self.isExported.frame.size.height + 10);
    [self addSubview:self.View01];
    self.View01.userInteractionEnabled = NO;
    
}

-(void)initView02
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.View02 = [[UIView alloc] init];
    self.View02Text = [NSString stringWithFormat:@""];
    self.View02La = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, screenSize.width - 20, 100)];
    self.View02La.numberOfLines = 0;
    self.View02La.textColor = [UIColor grayColor];
    [self.View02 addSubview:self.View02La];
    self.spell1Id = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.View02La.frame.origin.y + self.View02La.frame.size.height + 10, 32, 32)];
    [self.View02 addSubview:self.spell1Id];
    self.spell2Id = [[UIImageView alloc] initWithFrame:CGRectMake(self.spell1Id.frame.origin.x + self.spell1Id.frame.size.width + 5, self.spell1Id.frame.origin.y, 32, 32)];
    [self.View02 addSubview:self.spell2Id];
    self.View02.frame = CGRectMake(self.View01.frame.origin.x, self.View01.frame.origin.y + self.View01.frame.size.height, screenSize.width, 0);
    [self insertSubview:self.View02 belowSubview:self.View01];
    self.View02.userInteractionEnabled = NO;
    self.View02.hidden = YES;
}
-(void)layoutView02
{
    [self.View02La sizeToFit];
    self.spell1Id.center = CGPointMake(10 + self.spell1Id.bounds.size.height/2, self.View02La.frame.origin.y + self.View02La.frame.size.height + 10 + self.spell1Id.bounds.size.height/2);
    self.spell2Id.center = CGPointMake(self.spell1Id.center.x + self.spell1Id.bounds.size.width/2 + 10 + self.spell2Id.bounds.size.width/2, self.spell1Id.center.y);
}
-(void)clickView
{
    NSLog(@"click Par");
    if (self.selected) {
        [self changeIsExported];
        [UIView animateWithDuration:0.3 animations:^{
            self.View02.frame = CGRectMake(self.View01.frame.origin.x, self.View01.frame.origin.y + self.View01.frame.size.height, self.View02.frame.size.width, 0);
            
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.View01.bounds.size.height);
        } completion:^(BOOL finished) {
            self.selected = NO;
            self.View02.hidden = YES;
        }];
    }else
    {
        [self changeIsExported];
        self.View02.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.View02.frame = CGRectMake(self.View01.frame.origin.x, self.View01.frame.origin.y + self.View01.frame.size.height, self.View02.frame.size.width, self.spell1Id.frame.origin.y + self.spell1Id.frame.size.height + 10);
            
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.View01.bounds.size.height+self.View02.bounds.size.height);
        } completion:^(BOOL finished) {
            self.selected = YES;
        }];
    }
}
-(void)changeIsExported
{
    if (self.selected) {
        self.isExported.image = [UIImage imageNamed:@"club_fans_circle_control_arrow_down"];
    }else
    {
        self.isExported.image = [UIImage imageNamed:@"club_fans_circle_control_arrow_up"];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
