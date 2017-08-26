//
//  RuneTableCell.h
//  LOLHelper
//
//  Created by Easer Liu on 15/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RuneTableCell : UITableViewCell

@property (strong, nonatomic) UIImageView * iconImgV;
@property (strong, nonatomic) UILabel * name;
@property (strong, nonatomic) UILabel * perDescription;
@property (strong, nonatomic) NSString * type;
@property (strong, nonatomic) NSString * stats;

@end
