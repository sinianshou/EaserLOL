//
//  TableViewDelegate.h
//  LOLHelper
//
//  Created by Easer Liu on 5/28/17.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#ifndef TableViewDelegate_h
#define TableViewDelegate_h


#endif /* TableViewDelegate_h */
#import <UIKit/UIKit.h>
#import "TableCellModel.h"
#import <CoreData/CoreData.h>


typedef NS_ENUM(NSUInteger, LHFetchResultsControllerType) {
    ChineseNewestVideosList,
    FreeChampionsList,
    ChineseAuthorsList,
    ChineseChannelList,
};


@protocol LHFetchedResultsDelegate <NSFetchedResultsControllerDelegate>

- (void)configChineseNewestVideoCell:(TableCellModel *)cell index:(NSIndexPath *)indexPath;
-(void)didselectRowData:(id)data;

@end

@protocol LHUpDropDelegate <NSObject>

-(void)changeNavigationStatu:(NSString *) headerStatue;
-(void)didSelectedCell:(NSString *) str;

@end

@interface TableViewDataSource : NSObject <UITableViewDataSource,UITableViewDelegate,LHFetchedResultsDelegate>

@property (nonatomic,strong)UITableView * myTableView;
@property (nonatomic,strong)UITableViewCell * tableCell;
@property (nonatomic,strong) NSFetchedResultsController * LHfetchedResultsController;
@property NSInteger numberOfRows;
@property NSArray * dataTemp;
@property NSMutableDictionary * imgAche;
@property (nonatomic,assign) BOOL isPaused;
@property LHFetchResultsControllerType type;
@property CGFloat cellHeight;
@property NSInteger NumCell;
@property CGPoint offSet;
@property (nonatomic,strong)UIView * headerView;
@property enum {Normal,UpToTop, DownToRefresh, ReleaseToRefresh} headerStatue;
@property (nonatomic, weak) id<LHUpDropDelegate> myLHUpDropDelegate;

-(void)dataSourceWithFreeChampionsList:(NSArray *) freeChampionsList;
-(void)dataSourceWithChineseNewestVideosFetchedResultsController;
-(void)dataSourceWithChineseAuthorsFetchedResultsController;
-(void)dataSourceWithFetchedResultsController:(NSInteger)tag;
-(id)initWithTableView:(UITableView *) tableView;

@end
