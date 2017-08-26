//
//  TimeLineHeaderControl.h
//  LOLHelper
//
//  Created by Easer Liu on 22/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
#ifndef TimeLineHeaderControl_h
#define TimeLineHeaderControl_h
#import <UIKit/UIKit.h>

@interface TimeLineHeaderControl : UIControl


@property (strong, nonatomic)  UIImageView * iconV;
@property (strong, nonatomic)  UILabel * nameLa;
@property (strong, nonatomic)  UIImageView * arrow;
@property (strong, nonatomic)  NSString * teamId;
@property (strong, nonatomic)  NSString * participantId;

-(void)changeSelected;
-(void)didSelected;
-(void)didNotSelected;

@end

#endif /* TimeLineHeaderControl_h */
