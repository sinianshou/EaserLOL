//
//  ItemsCollectionVC.h
//  LOLHelper
//
//  Created by Easer Liu on 07/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Item_EN+CoreDataClass.h"


@interface ItemsCollectionVC : UICollectionViewController

@property (strong, nonatomic) NSArray<Item_EN *> * ItemsArrResouce;


@end
