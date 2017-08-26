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
+(NSArray *)getChampionsBrife_ENWithTag:(nullable NSString * )tagStr;
+(NSArray *)getChampionsBrife_ENWithId:(nonnull NSString * )Id;
+(NSDictionary *)getChampionDetailWithId:(NSString * )ChampionId  andName:(NSString * )ChampionKey;
+(nonnull NSDictionary *)getChampPicDicImageName_EN:(nonnull NSString *)imageName;

+(NSURL *)getChampionSkinURLWithName_EN:(NSString *)ChampionKey Num:(NSString *)num;
+(NSURL *)getChampionLoadingArtURLWithName_EN:(NSString *)ChampionKey Num:(NSString *)num;
+(NSURL *)getChampionPassiveSkillURLWithSkillName_EN:(NSString *)SkillName;
+(NSURL *)getChampionActiveSkillURLWithSkillName_EN:(NSString *)SkillName;



+(void)updateItem_EN;
+(NSArray *)getItem_ENWithId:(nullable NSString *)identifyty tag:(nullable NSString *) tag map:(nullable NSString *)map;
+(NSURL *)getItemSquareWithImageName_EN:(NSString *)imageName;
+(nonnull NSDictionary *)getItemPicDicImageName_EN:(nonnull NSString *)imageName;

+(void)updateMasteryData_EN;
+(nonnull NSDictionary *)getMasteryDataPicDicImageName_EN:(nonnull NSString *)imageName;
+(NSArray*)getMasteryData_ENWithId:(nullable NSString *)identifyty masteryTree:(nullable NSString *)tree;
+(void)updateRuneData_EN;
+(nonnull NSDictionary *)getRuneDataPicDicImageName_EN:(nonnull NSString *)imageName;
+(NSArray*)getRuneData_ENWithId:(nullable NSString *)identifyty tags:(nullable NSString *)tag tier:(nullable NSString *)tier type:(nullable NSString *)type;
@end
