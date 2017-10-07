//
//  Refresh.m
//  LOLHelper
//
//  Created by Easer Liu on 6/8/17.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "RefreshView.h"
#import "OptimizeLog.h"
@implementation RefreshView

+(instancetype)getRefreshView
{
    return [[self alloc] initWithStrings:@"refreshView"];
}

-(instancetype)initWithStrings:(NSString *)str
{
    self = [super init];
    
   
    
    UIImageView * imageV = [[UIImageView alloc] init];
    imageV.bounds = CGRectMake(0, 0, 27, 31);
    imageV.image = [UIImage imageNamed:@"personal_refresh_loading21"];
    self.ImageV =imageV;
    [self addSubview:imageV];
    NSMutableArray * animationArr = [NSMutableArray array];
    for (int i = 1; i < 9; i++) {
        [animationArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"personal_refresh_loading2%d", i]]];
    }
    
    self.ImageV.animationImages = animationArr;
    self.ImageV.animationRepeatCount = 0;
    self.ImageV.animationDuration = 0.8;
    
    UILabel * label = [[UILabel alloc] init];
    label.bounds = CGRectMake(0, 0, 100, 10);
    [label setTextColor:[UIColor whiteColor]];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:10]];
    self.RefreshLabel = label;
    self.bounds = CGRectMake(0, 0, 100, 45);
    
    label.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self addSubview:label];
    [self downToRefresh];
    
    return self;
}

-(void)downToRefresh
{
    self.RefreshLabel.text = @"DownToRefresh";
    self.statu = DownToRefresh;
    [self.ImageV stopAnimating];
}
-(void)releaseToRefresh
{
    self.RefreshLabel.text = @"ReleaseToRefresh";
    self.statu = ReleaseToRefresh;
    [self.ImageV stopAnimating];
}
-(void)refreshing
{
    self.RefreshLabel.text = @"Refreshing";
    self.statu = Refreshing;
    [self.ImageV startAnimating];
}
-(void)finishRefreshing
{
    self.RefreshLabel.text = @"FinishRefreshing";
    self.statu = FinishRefreshing;
    [self.ImageV stopAnimating];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.bounds.size.height < 45) {
        self.bounds = CGRectMake(0, 0, self.bounds.size.width, 45);
    }
    if (self.bounds.size.width < 100) {
        self.bounds = CGRectMake(0, 0, 100, self.bounds.size.height);
    }
    self.ImageV.frame = CGRectMake((self.bounds.size.width-27)/2, (self.bounds.size.height-45)/2, 27, 31);
    self.RefreshLabel.frame = CGRectMake((self.bounds.size.width-100)/2, (self.bounds.size.height-45)/2+35, 100, 10);
}
@end
