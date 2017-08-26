//
//  ItemDetailVC.h
//  LOLHelper
//
//  Created by Easer Liu on 08/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item_EN+CoreDataClass.h"

@interface ItemDetailVC : UIScrollView

@property (assign, nonatomic) CGRect startRect;
@property (strong, nonatomic) Item_EN * itemResouse;
@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UILabel * name;
@property (strong, nonatomic) UILabel * tags;
@property (strong, nonatomic) UILabel * maps;
@property (strong, nonatomic) UILabel * golds;
@property (strong, nonatomic) UILabel * desTitle;
@property (strong, nonatomic) UILabel * descriptionLa;
@property (strong, nonatomic) UILabel * fromTitle;
@property (strong, nonatomic) NSMutableArray <UIButton *> * fromArrM;
@property (strong, nonatomic) UILabel * intoTitle;
@property (strong, nonatomic) NSMutableArray <UIButton *>* intoArrM;
-(instancetype)initVoid;
-(void)resetWithItem:(Item_EN *) item startRect:(CGRect) startRect;
@end
