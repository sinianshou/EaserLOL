//
//  PerInfoTableVC.h
//  LOLHelper
//
//  Created by Easer Liu on 19/06/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
#ifndef PerInfoTableVC_h
#define PerInfoTableVC_h

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, TableType) {
    
    StatsType = 0,
    AbilityType,
    AssetType,
};

@interface PerInfoTableVC : UITableViewController

@property (nonatomic, assign) TableType tableType;
@property (nonatomic, assign) NSInteger Origin;
@property (nonatomic, assign) UIEdgeInsets defaultEdgeInsets;
@property (nonatomic, strong) NSMutableArray * fetchResults;

@end

#endif /* PerInfoTableVC_h */
