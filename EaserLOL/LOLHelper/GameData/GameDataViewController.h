//
//  GameDataViewController.h
//  LOLHelper
//
//  Created by Easer Liu on 24/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
#ifndef GameDataViewController_h
#define GameDataViewController_h

#import <UIKit/UIKit.h>

@interface GameDataViewController : UICollectionViewController
@property (strong, nonatomic)  UIView *headerView;
@property (strong, nonatomic)  UIButton *items;
@property (strong, nonatomic)  UIButton *masteries;
@property (strong, nonatomic)  UIButton *runes;
@property (strong, nonatomic)  UIButton *champFilter;
@property (strong, nonatomic)  UIView *filterView;


@end
#endif /* GameDataViewController_h */
