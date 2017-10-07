//
//  MasteryPageV.h
//  LOLHelper
//
//  Created by Easer Liu on 11/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
#ifndef MasteryPageV_h
#define MasteryPageV_h
#import <UIKit/UIKit.h>
#import "MasteryData_EN+CoreDataClass.h"

@interface MasteryPageV : UIControl

@property (strong, nonatomic) NSString * _Nullable totalPoint;
@property (strong, nonatomic) NSString *  _Nullable availablePoint;
@property (strong, nonatomic) UIButton *  _Nullable addButton;
@property (strong, nonatomic) UIButton *  _Nullable reduceButton;

-(instancetype _Nullable )initWithFrame:(CGRect)frame masteriesArr:(nonnull NSArray <MasteryData_EN *> *)masteriesArr;
-(void)updateAvailablePoint:(NSString * _Nullable)pointStr;
-(void)resetPoints;
@end

#endif /* MasteryPageV_h */
