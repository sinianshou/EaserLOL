//
//  RefreshView.h
//  LOLHelper
//
//  Created by Easer Liu on 6/8/17.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#ifndef RefreshView_h
#define RefreshView_h


#endif /* RefreshView_h */



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, RefreshStatus) {
    
    DownToRefresh = 1,
    ReleaseToRefresh,
    Refreshing,
    FinishRefreshing,
};

@interface RefreshView : UIView
@property (strong, nonatomic) UILabel * RefreshLabel;
@property (strong, nonatomic) UIImageView * ImageV;
@property (assign, nonatomic) RefreshStatus statu;

+(instancetype)getRefreshView;
-(instancetype)initWithStrings:(NSString *) str;
-(void)downToRefresh;
-(void)releaseToRefresh;
-(void)refreshing;
-(void)finishRefreshing;

@end
