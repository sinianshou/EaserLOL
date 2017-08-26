//
//  HonorView.h
//  LOLHelper
//
//  Created by Easer Liu on 24/06/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
#ifndef HonorView_h
#define HonorView_h

#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSInteger, ViewType) {
    
    LeagueViewType = 0,
    HonorViewType,
    CustomViewType,
};
typedef NS_OPTIONS(NSInteger, HonorType) {
    
    PentaKill = 0,
    QuadraKill,
    TripleKill,
    DoubleKill,
};
typedef NS_OPTIONS(NSInteger, LeagueType) {
    
    Unknown = 0,
    Brass,
    Silver,
    Gold,
    Platinum,
    Diamond,
    King,
    Supermaster,
};
@interface HonorView : UIView

@property (nonatomic, assign) ViewType viewType;

-(instancetype)initWithName:(NSString *)name viewType:(ViewType) viewType;
-(void)setHonorViewWithType:(HonorType) honorType Num:(NSString *)num;
-(void)setLeagueViewWithType:(LeagueType) LeagueType  duanwei:(NSString *)duanwei;

@end
#endif /* HonorView_h */
