//
//  ItemsVCCell.m
//  LOLHelper
//
//  Created by Easer Liu on 08/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "ItemsVCCell.h"

@implementation ItemsVCCell


-(instancetype)init
{
    self = [super init];
    [self configueCell];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self configueCell];
    
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self configueCell];
    return self;
}
-(void)configueCell
{
    self.icon  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [self addSubview:self.icon];
    self.la = [[UILabel alloc] init];
    //    la.backgroundColor = [UIColor yellowColor];
    self.la.textColor = [UIColor blackColor];
    self.la.frame =CGRectMake(0, self.icon.frame.origin.y + self.icon.frame.size.height, self.icon.frame.size.width, 16);
    self.la.numberOfLines = 2;
    self.la.lineBreakMode = NSLineBreakByTruncatingTail;
    //    la.adjustsFontSizeToFitWidth = YES;
    self.la.font = [UIFont systemFontOfSize:self.la.bounds.size.height/2-2];
    [self addSubview:self.la];
}
@end
