//
//  RuneTableCell.m
//  LOLHelper
//
//  Created by Easer Liu on 15/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "RuneTableCell.h"
#import "MatchListEntites_ENHeader.h"

@implementation RuneTableCell

-(instancetype)init
{
    self = [super init];
    
    [self createControlls];
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self createControlls];
    return self;
}

-(void)createControlls
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.iconImgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 32, 32)];
    [self.contentView addSubview:self.iconImgV];
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImgV.frame.origin.x + self.iconImgV.frame.size.width + 10, self.iconImgV.frame.origin.y, [UIScreen mainScreen].bounds.size.width - (self.iconImgV.frame.origin.x + self.iconImgV.frame.size.width + 20), self.iconImgV.frame.size.height/2)];
    self.name.textColor = [UIColor whiteColor];
    self.name.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.name];
    self.perDescription = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImgV.frame.origin.x + self.iconImgV.frame.size.width + 10, self.iconImgV.frame.origin.y + self.iconImgV.frame.size.height/2, [UIScreen mainScreen].bounds.size.width - (self.iconImgV.frame.origin.x + self.iconImgV.frame.size.width + 20), self.iconImgV.frame.size.height/2)];
    self.perDescription.textColor = [UIColor grayColor];
    self.perDescription.font = self.name.font;
    [self.contentView addSubview:self.perDescription];
    self.contentView.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.perDescription.frame.origin.y + self.perDescription.frame.size.height + 10);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
