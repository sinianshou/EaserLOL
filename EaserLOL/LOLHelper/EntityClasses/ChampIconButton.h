//
//  ChampIconButton.h
//  LOLHelper
//
//  Created by Easer Liu on 23/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
#ifndef ChampIconButton_h
#define ChampIconButton_h
#import <UIKit/UIKit.h>

@interface ChampIconButton : UIButton

@property (strong, nonatomic)  NSString * teamId;
@property (strong, nonatomic)  NSString * participantId;
@property (strong, nonatomic)  NSString * summonerName;

@end

#endif /* ChampIconButton_h */
