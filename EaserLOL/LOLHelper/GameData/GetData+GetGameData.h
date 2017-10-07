//
//  GetData+GetGameData.h
//  LOLHelper
//
//  Created by Easer Liu on 24/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "GetData.h"

@interface GetData (GetGameData)

+(void)updateChampionsBrife_EN;
+(NSArray *_Nullable)getChampionsBrife_ENWithTag:(nullable NSString * )tagStr;
+(NSArray *_Nullable)getChampionsBrife_ENWithId:(nonnull NSString * )Id;
+(NSDictionary *_Nullable)getChampionDetailWithId:(NSString * _Nullable )ChampionId  andName:(NSString * _Nullable )ChampionKey;
+(nonnull NSDictionary *)getChampPicDicImageName_EN:(nonnull NSString *)imageName;

+(NSURL * _Nullable)getChampionSkinURLWithName_EN:(NSString * _Nullable)ChampionKey Num:(NSString * _Nullable)num;
+(NSURL * _Nullable)getChampionLoadingArtURLWithName_EN:(NSString * _Nullable)ChampionKey Num:(NSString * _Nullable)num;
+(NSURL * _Nullable)getChampionPassiveSkillURLWithSkillName_EN:(NSString * _Nullable)SkillName;
+(NSURL * _Nullable)getChampionActiveSkillURLWithSkillName_EN:(NSString * _Nullable)SkillName;



+(void)updateItem_EN;
+(NSArray * _Nullable)getItem_ENWithId:(nullable NSString *)identifyty tag:(nullable NSString *) tag map:(nullable NSString *)map;
+(NSURL * _Nullable)getItemSquareWithImageName_EN:(NSString * _Nullable)imageName;
+(nonnull NSDictionary *)getItemPicDicImageName_EN:(nonnull NSString *)imageName;

+(void)updateMasteryData_EN;
+(nonnull NSDictionary *)getMasteryDataPicDicImageName_EN:(nonnull NSString *)imageName;
+(NSArray* _Nullable)getMasteryData_ENWithId:(nullable NSString *)identifyty masteryTree:(nullable NSString *)tree;
+(void)updateRuneData_EN;
+(nonnull NSDictionary *)getRuneDataPicDicImageName_EN:(nonnull NSString *)imageName;
+(NSArray* _Nullable)getRuneData_ENWithId:(nullable NSString *)identifyty tags:(nullable NSString *)tag tier:(nullable NSString *)tier type:(nullable NSString *)type;
@end
