//
//  ChampDetailModel.m
//  LOLHelper
//
//  Created by Easer Liu on 29/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "ChampDetailModel.h"
#import "GetData.h"

@implementation ChampDetailModel


-(instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    
    self.cachesDir =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    [self resetWithDic:dic];
    
    return self;
}

-(void)resetWithDic:(NSDictionary *)dic
{
    self.name = [dic objectForKey:@"name"];
    self.title = [dic objectForKey:@"title"];
    self.key = [dic objectForKey:@"key"];
    self.ChampionId = [dic objectForKey:@"id"];
    self.lore = [NSString stringWithFormat:@"Lore:<br>%@", [dic objectForKey:@"lore"]];
    //配置SkinDic
    self.skins = [dic objectForKey:@"skins"];
    NSMutableArray * __block temSkinsArr = [NSMutableArray array];
    NSMutableArray * __block loadingScreenArtsArr = [NSMutableArray array];
    [self.skins enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * skinnameKey = [NSString stringWithFormat:@"championSkin_EN_%@.png", [obj objectForKey:@"id"]];
        NSString * skinpath = [self.cachesDir stringByAppendingPathComponent:skinnameKey];
        NSURL * skinURL = [GetData getChampionSkinURLWithName_EN:self.key Num:[obj objectForKey:@"num"]];
        NSDictionary * skinDic = [NSDictionary dictionaryWithObjectsAndKeys:skinnameKey, @"skinnameKey", skinpath, @"skinpath", skinURL, @"skinURL", nil];
        [temSkinsArr addObject:skinDic];
        
        NSString * loadingArtnameKey = [NSString stringWithFormat:@"championLoadingArt_EN_%@.png", [obj objectForKey:@"id"]];
        NSString * loadingArtpath = [self.cachesDir stringByAppendingPathComponent:loadingArtnameKey];
        NSURL * loadingArtURL = [GetData getChampionLoadingArtURLWithName_EN:self.key Num:[obj objectForKey:@"num"]];
        NSDictionary * loadingArtDic = [NSDictionary dictionaryWithObjectsAndKeys:loadingArtnameKey, @"loadingArtnameKey", loadingArtpath, @"loadingArtpath", loadingArtURL, @"loadingArtURL", nil];
        [loadingScreenArtsArr addObject:loadingArtDic];
    }];
    self.skins = [NSArray arrayWithArray:temSkinsArr];
    self.loadingScreenArts = [NSArray arrayWithArray:loadingScreenArtsArr];
    self.BGPnameKey = [self.skins[0] objectForKey:@"skinnameKey"];
    self.BGPpath = [self.skins[0] objectForKey:@"skinpath"];
    self.BGPURL = [self.skins[0] objectForKey:@"skinURL"];
    
    
    NSDictionary * info = [dic objectForKey:@"info"];
    [info enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self setValue:obj forKey:key];
    }];
    self.difficulty = 0.1 *  self.difficulty;
    self.attack = 0.1 *  self.attack;
    self.defense = 0.1 *  self.defense;
    self.magic = 0.1 *  self.magic;
    
    NSDictionary * stats = [dic objectForKey:@"stats"];
    [stats enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self setValue:obj forKey:key];
    }];
    
    NSString * PSkillFullName = [(NSDictionary *)[(NSDictionary *)[dic objectForKey:@"passive"] objectForKey:@"image"] objectForKey:@"full"];
    self.PSkillnameKey = [NSString stringWithFormat:@"EN_%@", PSkillFullName];;
    self.PSkillpath = [self.cachesDir stringByAppendingPathComponent:self.PSkillnameKey];;
    self.PSkillURL = [GetData getChampionPassiveSkillURLWithSkillName_EN:PSkillFullName];
    self.PSkilltext = [NSString stringWithFormat:@"%@\n%@\n", [(NSDictionary *)[dic objectForKey:@"passive"] objectForKey:@"name"], [(NSDictionary *)[dic objectForKey:@"passive"] objectForKey:@"description"]];
    
    NSArray * spells = [dic objectForKey:@"spells"];
    
    NSString * QSkillFullName = [(NSDictionary *)[((NSDictionary *)spells[0]) objectForKey:@"image"] objectForKey:@"full"];
    self.QSkillnameKey = [NSString stringWithFormat:@"EN_%@", QSkillFullName];;
    self.QSkillpath = [self.cachesDir stringByAppendingPathComponent:self.QSkillnameKey];;
    self.QSkillURL = [GetData getChampionActiveSkillURLWithSkillName_EN:QSkillFullName];
    self.QSkilltext = [NSString stringWithFormat:@"%@\n%@\n", [((NSDictionary *)spells[0]) objectForKey:@"name"], [((NSDictionary *)spells[0]) objectForKey:@"description"]];
    
    NSString * WSkillFullName = [(NSDictionary *)[((NSDictionary *)spells[1]) objectForKey:@"image"] objectForKey:@"full"];
    self.WSkillnameKey = [NSString stringWithFormat:@"EN_%@", WSkillFullName];;
    self.WSkillpath = [self.cachesDir stringByAppendingPathComponent:self.WSkillnameKey];;
    self.WSkillURL = [GetData getChampionActiveSkillURLWithSkillName_EN:WSkillFullName];
    self.WSkilltext = [NSString stringWithFormat:@"%@\n%@\n", [((NSDictionary *)spells[1]) objectForKey:@"name"], [((NSDictionary *)spells[1]) objectForKey:@"description"]];
    
    NSString * ESkillFullName = [(NSDictionary *)[((NSDictionary *)spells[2]) objectForKey:@"image"] objectForKey:@"full"];
    self.ESkillnameKey = [NSString stringWithFormat:@"EN_%@", ESkillFullName];;
    self.ESkillpath = [self.cachesDir stringByAppendingPathComponent:self.ESkillnameKey];;
    self.ESkillURL = [GetData getChampionActiveSkillURLWithSkillName_EN:ESkillFullName];
    self.ESkilltext = [NSString stringWithFormat:@"%@\n%@\n", [((NSDictionary *)spells[2]) objectForKey:@"name"], [((NSDictionary *)spells[2]) objectForKey:@"description"]];
    
    NSString * RSkillFullName = [(NSDictionary *)[((NSDictionary *)spells[3]) objectForKey:@"image"] objectForKey:@"full"];
    self.RSkillnameKey = [NSString stringWithFormat:@"EN_%@", RSkillFullName];;
    self.RSkillpath = [self.cachesDir stringByAppendingPathComponent:self.RSkillnameKey];;
    self.RSkillURL = [GetData getChampionActiveSkillURLWithSkillName_EN:RSkillFullName];
    self.RSkilltext = [NSString stringWithFormat:@"%@\n%@\n", [((NSDictionary *)spells[3]) objectForKey:@"name"], [((NSDictionary *)spells[3]) objectForKey:@"description"]];
    
    NSMutableString * enemytipsM = [NSMutableString string];
    [((NSArray *)[dic objectForKey:@"enemytips"]) enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [enemytipsM appendFormat:@"%@<br>", obj];
    }];
    self.enemytips = [NSString stringWithFormat:@"Enemytips:<br>%@", enemytipsM];
    
    NSMutableString * allytipsM = [NSMutableString string];
    [((NSArray *)[dic objectForKey:@"allytips"]) enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [allytipsM appendFormat:@"%@<br>", obj];
    }];
    self.allytips = [NSString stringWithFormat:@"Allytips:<br>%@", enemytipsM];
}

//-(void)configueENSkillnameKey:(NSString **)SkillnameKey Skillpath:(NSString **)Skillpath PSkillURL:(NSURL **)PSkillURL PSkilltext:(NSString **)PSkilltext fromDic:(NSDictionary *) dic
//{
//    NSString * PSkillFullName = [(NSDictionary *)[dic  objectForKey:@"image"] objectForKey:@"full"];
//    NSString * STR =[NSString stringWithFormat:@"EN_%@", PSkillFullName];
//    *SkillnameKey = STR;
//    *Skillpath = [self.cachesDir stringByAppendingPathComponent:self.PSkillnameKey];;
//    *PSkillURL = [GetData getChampionPassiveSkillURLWithSkillName_EN:PSkillFullName];
//    *PSkilltext = [dic objectForKey:@"description"];
//}

@end
