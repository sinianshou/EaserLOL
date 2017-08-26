//
//  PerInfoCell.h
//  LOLHelper
//
//  Created by Easer Liu on 25/06/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
#ifndef PerInfoCell_h
#define PerInfoCell_h

#import <UIKit/UIKit.h>

//#import "PerInfoCell+Ability.h"
typedef NS_OPTIONS(NSInteger, CellType) {
    
    StatsCellType = 0,
    MatchListHeaderCellType,
    MatchListCellType,
    AbilityCellRow0Type,
    AbilityCellRow1Type,
    AbilityCellRow2Type,
    AbilityCellRow3Type,
    AbilityCellRow4Type,
};

@interface PerInfoCell : UITableViewCell

@property (nonatomic,assign) CellType celltype;
@property (nonatomic,assign) CGFloat lastHeight;

-(instancetype)initStatsCellWithIndexPath:(NSIndexPath *)indexPath;
-(void)configueStatsCellWithDic:(NSDictionary *)dic atIndexPath:(NSIndexPath *)indexPath;
@end

#import "PerInfoCell+Ability.h"
#endif /* PerInfoCell_h */


