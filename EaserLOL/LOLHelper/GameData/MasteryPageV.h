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

@property (strong, nonatomic) NSString * totalPoint;
@property (strong, nonatomic) NSString * availablePoint;
@property (strong, nonatomic) UIButton * addButton;
@property (strong, nonatomic) UIButton * reduceButton;

-(instancetype)initWithFrame:(CGRect)frame masteriesArr:(nonnull NSArray <MasteryData_EN *> *)masteriesArr;
-(void)updateAvailablePoint:(NSString *)pointStr;
-(void)resetPoints;
@end

#endif /* MasteryPageV_h */
