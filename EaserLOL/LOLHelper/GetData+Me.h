//
//  GetData+Me.h
//  LOLHelper
//
//  Created by Easer Liu on 27/06/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "GetData.h"

@interface GetData (Me)


//@property (readonly ,strong, nonatomic) NSManagedObjectContext *bgObjectContext;
//+(id)getCNMatchList;

+(void)updateUserName_CN:(NSString *)userName;
+(void)updateUserName_EN:(NSString *)userName;

//+(NSDictionary *)getSummonerInfo_CN;
+(NSDictionary *)getSummonerInfo_EN;
+(NSDictionary *)getSummonerPicDic_EN;
+(NSArray *)getSummonerEntityArr_EN;

+(void)updateMatchListWithQquin_CN:(NSString *) qquin inVaid:(NSString *) vaid page:(NSString *) page;
+(void)updateMatchListWithAccountId_EN:(NSString *) accountId;

+(NSArray *)getMatchListWithAccountId_EN:(NSString *) accountId;
+(NSArray *)getMatchsWithGameId_EN:(NSString *) GameId;
+(NSURL *)getProfileIconURL_EN;
+(NSURL *)getChampionIconURLWithName_EN:(NSString *)squareFullName;
+(NSURL *)getChampionURLWithID_EN:(NSString *)ChampionID;
+(NSDictionary *)getChampionWithID_EN:(NSString *)ChampionID;

+(void)deleteCoreData;

@end
