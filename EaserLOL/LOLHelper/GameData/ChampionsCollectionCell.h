//
//  ChampionsCollectionCell.h
//  LOLHelper
//
//  Created by Easer Liu on 24/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#ifndef ChampionsCollectionCell_h
#define ChampionsCollectionCell_h

#import <UIKit/UIKit.h>

@interface ChampionsCollectionCell : UICollectionViewCell

@property (strong,nonatomic) UIImageView * championIcon;
@property (strong,nonatomic) UILabel * briefLa;
@property (strong,nonatomic) UILabel * titleLa;
@property (strong,nonatomic) NSString * championId;
@property (strong,nonatomic) NSString * championName;
@property (strong,nonatomic) NSString * championKey;

@end
#endif /* ChampionsCollectionCell_h */
