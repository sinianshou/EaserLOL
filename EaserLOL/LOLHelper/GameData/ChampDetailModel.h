//
//  ChampDetailModel.h
//  LOLHelper
//
//  Created by Easer Liu on 29/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#ifndef ChampDetailModel_h
#define ChampDetailModel_h

#import <Foundation/Foundation.h>

@interface ChampDetailModel : NSObject

@property (strong, nonatomic) NSString * cachesDir;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * key;
@property (strong, nonatomic) NSString * ChampionId;
@property (strong, nonatomic) NSString * lore;
@property (strong, nonatomic) NSArray<NSDictionary *>* skins;
@property (strong, nonatomic) NSArray<NSDictionary *>* loadingScreenArts;
@property (strong, nonatomic) NSString * BGPnameKey;
@property (strong, nonatomic) NSString * BGPpath;
@property (strong, nonatomic) NSURL * BGPURL;

@property (strong, nonatomic) NSString * allytips;
@property (strong, nonatomic) NSString * enemytips;

@property (strong, nonatomic) NSString * PSkillnameKey;
@property (strong, nonatomic) NSString * PSkillpath;
@property (strong, nonatomic) NSURL * PSkillURL;
@property (strong, nonatomic) NSString * PSkilltext;
@property (strong, nonatomic) NSString * QSkillnameKey;
@property (strong, nonatomic) NSString * QSkillpath;
@property (strong, nonatomic) NSURL * QSkillURL;
@property (strong, nonatomic) NSString * QSkilltext;
@property (strong, nonatomic) NSString * WSkillnameKey;
@property (strong, nonatomic) NSString * WSkillpath;
@property (strong, nonatomic) NSURL * WSkillURL;
@property (strong, nonatomic) NSString * WSkilltext;
@property (strong, nonatomic) NSString * ESkillnameKey;
@property (strong, nonatomic) NSString * ESkillpath;
@property (strong, nonatomic) NSURL * ESkillURL;
@property (strong, nonatomic) NSString * ESkilltext;
@property (strong, nonatomic) NSString * RSkillnameKey;
@property (strong, nonatomic) NSString * RSkillpath;
@property (strong, nonatomic) NSURL * RSkillURL;
@property (strong, nonatomic) NSString * RSkilltext;

@property (assign, nonatomic) float difficulty;
@property (assign, nonatomic) float attack;
@property (assign, nonatomic) float defense;
@property (assign, nonatomic) float magic;

@property (assign, nonatomic) float armorperlevel;
@property (assign, nonatomic) float attackdamage;
@property (assign, nonatomic) float mpperlevel;
@property (assign, nonatomic) float attackspeedoffset;
@property (assign, nonatomic) float mp;
@property (assign, nonatomic) float armor;
@property (assign, nonatomic) float hp;
@property (assign, nonatomic) float hpregenperlevel;
@property (assign, nonatomic) float attackspeedperlevel;
@property (assign, nonatomic) float attackrange;
@property (assign, nonatomic) float movespeed;
@property (assign, nonatomic) float attackdamageperlevel;
@property (assign, nonatomic) float mpregenperlevel;
@property (assign, nonatomic) float critperlevel;
@property (assign, nonatomic) float spellblockperlevel;
@property (assign, nonatomic) float crit;
@property (assign, nonatomic) float mpregen;
@property (assign, nonatomic) float spellblock;
@property (assign, nonatomic) float hpregen;
@property (assign, nonatomic) float hpperlevel;

-(instancetype)initWithDic:(NSDictionary *)dic;
-(void)resetWithDic:(NSDictionary *)dic;
@end
#endif /* ChampDetailModel_h */
