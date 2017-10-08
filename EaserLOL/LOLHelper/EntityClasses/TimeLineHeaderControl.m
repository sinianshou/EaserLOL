//
//  TimeLineHeaderControl.m
//  LOLHelper
//
//  Created by Easer Liu on 22/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "TimeLineHeaderControl.h"

@implementation TimeLineHeaderControl

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 0.5;
    
    if (frame.size.height < 25) {
        self.bounds = CGRectMake(0, 0, frame.size.width, 40);
    }
    self.iconV = [[UIImageView alloc] init];
    self.iconV.bounds = CGRectMake(0, 0, 30, 30);
    self.iconV.center = CGPointMake(10 + CGRectGetMidX(self.iconV.bounds), CGRectGetMidY(self.bounds));
    self.iconV.layer.cornerRadius = self.iconV.bounds.size.width/2;
    self.iconV.layer.masksToBounds = YES;
    [self addSubview:self.iconV];
    self.nameLa = [[UILabel alloc] init];
    self.nameLa.bounds = CGRectMake(0, 0, self.bounds.size.width/2, 20);
    self.nameLa.center = CGPointMake(CGRectGetMaxX(self.iconV.frame) + 5 + CGRectGetMidX(self.nameLa.bounds), CGRectGetMidY(self.bounds));
    [self addSubview:self.nameLa];
    self.arrow = [[UIImageView alloc] init];
    self.arrow.bounds = CGRectMake(0, 0, 9, 9);
    self.arrow.image = [UIImage imageNamed:@"club_fans_circle_control_arrow_down"];
    self.arrow.center = CGPointMake(CGRectGetMaxX(self.bounds) - (10 + CGRectGetMidX(self.arrow.bounds)), CGRectGetMaxY(self.bounds) - (10 + CGRectGetMidY(self.arrow.bounds)));
    [self addSubview:self.arrow];
    [self didNotSelected];

    return self;
}

-(void)changeSelected
{
    if (self.selected) {
        [self didNotSelected];
    }else
    {
        [self didSelected];
    }
}
-(void)didSelected
{
    self.selected = YES;
    self.backgroundColor = [UIColor colorWithRed:210/225.00 green:210/225.00 blue:210/225.00 alpha:1];
    self.arrow.image = [UIImage imageNamed:@"club_fans_circle_control_arrow_up"];
}
-(void)didNotSelected
{
    self.selected = NO;
    self.backgroundColor = [UIColor whiteColor];
    self.arrow.image = [UIImage imageNamed:@"club_fans_circle_control_arrow_down"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
