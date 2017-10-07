//
//  ChampionsCollectionCell.m
//  LOLHelper
//
//  Created by Easer Liu on 24/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "ChampionsCollectionCell.h"
#import "PerCategory.h"

@implementation ChampionsCollectionCell

-(instancetype)init
{
    self = [super init];
    [self createCell];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self createCell];
    return self;
}

-(void)createCell
{
    self.championIcon = [[UIImageView alloc] initWithName:@"championIcon"];
    self.championIcon.layer.cornerRadius = 30;
    self.championIcon.clipsToBounds = YES;
    self.briefLa = [[UILabel alloc] initWithName:@"briefLa"];
    self.titleLa = [[UILabel alloc] initWithName:@"titleLa"];
    NSLog(@"init:self.championIcon.perViewName is %@, self.briefLa.perViewName is %@", self.championIcon.perViewName, self.briefLa.perViewName);
    self.briefLa.numberOfLines = 2;
    self.briefLa.textAlignment = NSTextAlignmentLeft;
    [self perAddSubviews:self.briefLa, self.championIcon, nil];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutControlls];
}

-(void)layoutControlls
{    
    self.championIcon.frame = CGRectMake(5, 5, 60, 60);
    self.briefLa.frame = CGRectMake(70, 5, self.bounds.size.width-60, 60);
    
}
@end
