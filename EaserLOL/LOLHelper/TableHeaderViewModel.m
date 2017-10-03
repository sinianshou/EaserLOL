//
//  TableVewModel.m
//  LOLHelper
//
//  Created by Easer Liu on 6/5/17.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "TableHeaderViewModel.h"
#import "MenuControlH.h"
#import "OptimizeLog.h"

@interface TableHeaderViewModel()

@property CGRect subHeaderViewFrame;
@end

@implementation TableHeaderViewModel

@synthesize subHeaderViewFrame;
@synthesize MenuControlHView;
@synthesize imgView;

+(UIView *)getTableHeaderView
{
    
    
    return [[self alloc] initTableHeaderView];
}

-(UIView *)initTableHeaderView
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self  = [super  init];
    self.userInteractionEnabled = YES;
    
    NSArray * buttonstitle = [[NSArray alloc] initWithObjects:@"Video",@"Author",@"Chanel",@"Menu4",@"Menu5",@"Menu6", nil];
    self.MenuControlHView = [MenuControlH menuControlHWithNormalTitles:buttonstitle SelectedTitles:nil Images:nil];
    self.MenuControlHView.bounds = CGRectMake(0, 0, screenSize.width*1.5, 23);
    self.MenuControlHView.frame = CGRectMake(0, screenSize.width*9/16, screenSize.width*1.5, 20);
    self.MenuControlHView.tag = 11;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.MenuControlHView];
    
    //320x180
    UIImage * img = [UIImage imageNamed:@"HeaderNews01"];
    
    self.imgView = [[UIImageView alloc] initWithImage:img];
    self.imgView.bounds = CGRectMake(0, 0, screenSize.width, screenSize.width*9/16);
    self.imgView.frame = CGRectMake(0, 0, screenSize.width, screenSize.width*9/16);
    [self setBackgroundColor:[UIColor whiteColor]];
    self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgView.tag = 12;
    
    [self addSubview:self.imgView];
    
    NSDictionary * views2 = [[NSDictionary alloc]initWithObjectsAndKeys:self.imgView,@"imgView",self.MenuControlHView,@"MenuControlHView", nil];
//    NSDictionary * views2 = NSDictionaryOfVariableBindings(MenuControlHView,imgView);
    NSString * vflV11 = @"V:|[imgView][MenuControlHView]|";
    NSArray * constraintsV11 = [NSLayoutConstraint constraintsWithVisualFormat:vflV11 options:0 metrics:NULL views:views2];
    [self addConstraints:constraintsV11];
    
    CGFloat imgViewWidth = self.imgView.bounds.size.width;
    NSString * vflH12 = [NSString stringWithFormat:@"H:|[imgView(%f)]",imgViewWidth];
    NSArray * constraintsH12 = [NSLayoutConstraint constraintsWithVisualFormat:vflH12 options:0 metrics:NULL views:views2];
    [self addConstraints:constraintsH12];

    NSString * vflH13 = @"H:|[MenuControlHView]|";
    NSArray * constraintsH13 = [NSLayoutConstraint constraintsWithVisualFormat:vflH13 options:0 metrics:NULL views:views2];
    [self addConstraints:constraintsH13];
    
    self.bounds = CGRectMake(0, 0, screenSize.width, self.MenuControlHView.frame.size.height + self.imgView.frame.size.height +1);
    NSLog(@"SY is %f %F %F %F, IY is %f %F %F %F",self.MenuControlHView.frame.origin.x,self.MenuControlHView.frame.origin.y,self.MenuControlHView.frame.size.width,self.MenuControlHView.frame.size.height,self.imgView.frame.origin.x,self.imgView.frame.origin.y,self.imgView.frame.size.width,self.imgView.frame.size.height);
    return self;
}


@end
