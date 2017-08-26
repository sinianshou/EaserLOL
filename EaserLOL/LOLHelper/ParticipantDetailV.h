//
//  ParticipantDetailV.h
//  LOLHelper
//
//  Created by Easer Liu on 05/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#ifndef ParticipantDetailV_h
#define ParticipantDetailV_h

#import <UIKit/UIKit.h>

@interface ParticipantDetailV : UIControl


@property (strong, nonatomic) UIView *View01;
@property (strong, nonatomic) UIView *View02;

@property (strong, nonatomic) UIImageView *ChampIcon;
@property (strong, nonatomic) UILabel *summonerName;
@property (strong, nonatomic) UILabel *goldEarned;
@property (strong, nonatomic) UILabel *kda;
@property (strong, nonatomic) UIImageView *item0;
@property (strong, nonatomic) UIImageView *item1;
@property (strong, nonatomic) UIImageView *item2;
@property (strong, nonatomic) UIImageView *item3;
@property (strong, nonatomic) UIImageView *item4;
@property (strong, nonatomic) UIImageView *item5;
@property (strong, nonatomic) UIImageView *item6;
@property (strong, nonatomic) UIImageView *pentaKills;
@property (strong, nonatomic) UIImageView *mvp;
@property (strong, nonatomic) UIImageView *isExported;
@property (strong, nonatomic) NSString * teamId;
@property (strong, nonatomic) NSString *participantId;
@property (strong, nonatomic) NSString *win;


@property (strong, nonatomic) UILabel *View02La;
@property (strong, nonatomic) NSString *View02Text;
@property (strong, nonatomic) UIImageView *spell1Id;
@property (strong, nonatomic) UIImageView *spell2Id;

-(void)layoutView02;

@end

#endif /* ParticipantDetailV_h */
