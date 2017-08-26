//
//  TableHeaderViewModel.h
//  LOLHelper
//
//  Created by Easer Liu on 6/5/17.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#ifndef TableHeaderViewModel_h
#define TableHeaderViewModel_h


#endif /* TableHeaderViewModel_h */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TableHeaderViewModel : UIView


@property (nonatomic, strong) UIView * MenuControlHView;
@property (nonatomic, strong) UIImageView * imgView;


+(UIView *)getTableHeaderView;

@end
