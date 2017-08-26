//
//  GetData+Me.m
//  LOLHelper
//
//  Created by Easer Liu on 27/06/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "GetData+Me.h"
#import "MatchList_CN+CoreDataClass.h"
#import "MatchListEntites_ENHeader.h"
#import <objc/runtime.h>
#import "GoldEventsModel.h"

static NSManagedObjectContext * parentContext;

NSMutableString * finishNum = @"0";

@implementation GetData (Me)

+(id)getCNMatchList
{
    return nil;
}

+(void)updateMatchListWithQquin_CN:(NSString *) qquin inVaid:(NSString *) vaid page:(NSString *) page
{
    NSDictionary * easerAPIKey = [NSDictionary dictionaryWithContentsOfFile:@"APIKeys.plist"];
    NSDictionary * CNAPIKeys = [easerAPIKey objectForKey:@"CNAPIKeys"];
    NSDictionary * CNOpenAPIKey = [CNAPIKeys objectForKey:@"CNOpenAPIKey"];
    
    NSString *stringUrl = [NSString stringWithFormat:@"http://lolapi.games-cube.com/CombatList?qquin={%@}&vaid={%@}&p={%@}", qquin, vaid, page];
    NSString * strUrl = [stringUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strUrl];
    
    NSURLSessionConfiguration * sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfig setHTTPAdditionalHeaders:CNOpenAPIKey];
    
    //    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url
                                             completionHandler:^(NSData *data,
                                                                 NSURLResponse *response,
                                                                 NSError *error) {
                                                 // handle response
                                                 if (error) {
                                                     [NSException raise:@"网络通信错误" format:@"错误是%@",[error localizedDescription]];
                                                 }else
                                                 {
                                                     [self insertCNMatchListWithData:data];
                                                 }
                                                 
                                                 
                                             }];
    [dataTask resume];
}

+(void)updateMatchListWithAccountId_EN:(NSString *) accountId
{
    NSString * strURL = [NSString stringWithFormat:@"https://na1.api.riotgames.com/lol/match/v3/matchlists/by-account/%@/recent?api_key=%@", accountId, [self getAPIKey_EN]];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [NSException raise:@"updateMatchListWithAccountId_EN 网络通信错误" format:@"错误是%@",[error localizedDescription]];
        }else
        {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"jsonData is %@", jsonString);
            [self insertENMatchListWithData:data];
        }
    }];
    [dataTask resume];
}


+(void)insertENMatchListWithData:(NSData *) data
{
    NSError * errMatche01;
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MatchList_EN"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"accountId == %@", [[self getSummonerInfo_EN] objectForKey:@"accountId"]];
    [fetchRequest setPredicate:predicate];
    NSArray * matchesResults=[parentContext executeFetchRequest:fetchRequest error:&errMatche01];
    NSMutableArray * existMatchsGIDsM = [NSMutableArray array];
    [matchesResults enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [existMatchsGIDsM addObject:((MatchList_EN *)obj).gameId];
    }];
    
    NSMutableDictionary * results = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
    NSMutableArray * matchesM = [NSMutableArray arrayWithArray:[results objectForKey:@"matches"]];
    NSMutableDictionary * matchListM = nil;
    NSMutableArray * removeMatchsM = [NSMutableArray array];
    
    [matchesM enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * ids =[NSString stringWithFormat:@"%@", [((NSDictionary *)obj) objectForKey:@"gameId"]];
        if ([existMatchsGIDsM containsObject:ids]) {
            [removeMatchsM addObject:obj];
        }
    }];
    [matchesM removeObjectsInArray:removeMatchsM];
    
    if (matchesM.count > 0) {
        //    NSMutableArray * gameIdArr = [NSMutableArray array];
        NSString * __block key = nil;
        NSString * __block value = nil;
        NSMutableArray * objectIDs = [NSMutableArray array];
        for (matchListM in matchesM) {
            matchListM = [NSMutableDictionary dictionaryWithDictionary:matchListM];
            [self updateParentContext];
            [parentContext performBlockAndWait:^{
                MatchList_EN * MatchList_ENEntity = [[MatchList_EN alloc] initWithEntity:[NSEntityDescription entityForName:@"MatchList_EN" inManagedObjectContext:parentContext] insertIntoManagedObjectContext:parentContext];
                
                ///存储所有的属性名称
                NSMutableArray *allNames = [[NSMutableArray alloc] init];
                ///存储属性的个数
                unsigned int propertyCount = 0;
                
                ///通过运行时获取当前类的属性
                objc_property_t *propertys = class_copyPropertyList([MatchList_ENEntity class], &propertyCount);
                
                NSLog(@"class is %@", NSStringFromClass(MatchList_ENEntity.class));
                //把属性放到数组中
                for (int i = 0; i < propertyCount; i ++) {
                    ///取出第一个属性
                    objc_property_t property = propertys[i];
                    
                    const char * propertyName = property_getName(property);
                    
                    [allNames addObject:[NSString stringWithUTF8String:propertyName]];
                    NSLog(@"propert is %@", [NSString stringWithUTF8String:propertyName]);
                }
                
                ///释放
                free(propertys);
                
                if (matchListM != nil) {
                    [matchListM setValue:[[self getSummonerInfo_EN] objectForKey:@"accountId"] forKey:@"accountId"];
                    [matchListM setValue:[[self getSummonerInfo_EN] objectForKey:@"name"] forKey:@"summonerName"];
                    for (key in matchListM.allKeys) {
                        value = [NSString stringWithFormat:@"%@",[matchListM objectForKey:key]];
                        if ([key isEqualToString:@"summonerName"]) {
                            MatchList_ENEntity.summonerName = value;
                        }
                        [MatchList_ENEntity setValue:value forKey:key];
                    }
                    
                    //                @try
                    //                {
                    //
                    //                }
                    //                @catch (NSException * e) {
                    //                    NSLog(@"Exception: %@", e);
                    //                }
                    //                [gameIdArr addObject:[matchList objectForKey:@"gameId"]];
                }
                
                NSError * err;
                if ([parentContext save:&err]) {
                    NSLog(@"写入成功：MatchList_EN");
                    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                    NSLog(@"路径是：%@",docPath);
                    
                    if (matchListM != nil) {
                        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:MatchList_ENEntity.objectID,@"objectID", [matchListM objectForKey:@"gameId"], @"gameId", nil];
                        [objectIDs addObject:dic];
                        //                    [self updateMatchWithListEntity:MatchList_ENEntity gameId:[matchList objectForKey:@"gameId"]];
                    }
                }else
                {
                    [NSException raise:@"写入错误" format:@"错误是%@",[err localizedDescription]];
                }
            }];
        }
        
        finishNum = [NSMutableString stringWithFormat:@"%d",(int)objectIDs.count];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMatchFinished:) name:NSManagedObjectContextDidSaveNotification object:nil];
        for (NSDictionary * dic in objectIDs) {
            [self updateMatchWithListEntity:[parentContext objectWithID:[dic objectForKey:@"objectID"]] gameId:[dic objectForKey:@"gameId"]];
        }
        NSLog(@"insertENMatchList finished");
    }else
    {
        NSLog(@"No new MatchList_EN ");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoUpdateFinished" object:NULL];
    }
}

+(void)updateMatchFinished:(NSNotification *)notification
{
    finishNum = [NSMutableString stringWithFormat:@"%d", finishNum.intValue - 1];
    if (finishNum.intValue == 0) {
        [self updateCurrentAccountStats];
//        NSThread * updateCASThread = [[NSThread alloc] initWithTarget:self selector:@selector(updateCurrentAccountStats) object:NULL];
//        [updateCASThread start];
        
    }
    NSSet * set01 = [notification.userInfo objectForKey:@"inserted"];
    NSSet * set02 = [notification.userInfo objectForKey:@"updated"];
    NSSet * set03 = [notification.userInfo objectForKey:@"deleted"];
    
    if (set01 != nil) {
        [set01 enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSLog(@"inserted class is %@", [obj class]);
        }];
    }
    if (set02 != nil) {
        [set02 enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSLog(@"updated class is %@", [obj class]);
        }];
    }
    if (set03 != nil) {
        [set03 enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSLog(@"updated class is %@", [obj class]);
        }];
    }
    
    
}
+(void)updateCurrentAccountStats
{
//    [NSThread sleepForTimeInterval:4];
    
    //收集当前用户honor信息
    [self updateParentContext];
    Player_EN * currentPlayer_ENEntity = nil;
    NSError * errPlayer01;
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Player_EN"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"accountId == %@", [[GetData getSummonerInfo_EN] objectForKey:@"accountId"]];
    [fetchRequest setPredicate:predicate];
    NSArray * playersResults=[parentContext executeFetchRequest:fetchRequest error:&errPlayer01];
    if (errPlayer01) {
        [NSException raise:@"Player_EN读取错误" format:@"错误是%@",[errPlayer01 localizedDescription]];
    }
    if (playersResults.count > 0)
    {
        currentPlayer_ENEntity = playersResults[0];
        NSSet * ParSet = currentPlayer_ENEntity.playToParticipants;
//        int __block parNum = 1;
        NSDictionary * __block currentPlayer_ENkeys = [NSDictionary dictionaryWithObjectsAndKeys:@"assistsNum", @"assists", @"doubleKNum", @"doubleKills", @"killsNum", @"kills", @"deathsNum", @"deaths", @"mvpNum", @"mvp", @"pentaKNum", @"pentaKills", @"quadraKNum", @"quadraKills", @"tripleKNum", @"tripleKills", @"wardsNum", @"wardsPlaced", @"winRate", @"win", @"chaoshenNum",@"chaoshen", @"goldEarnedNum", @"goldEarned", @"totalDamageTakenNum", @"totalDamageTaken", @"physicalDamageDealtToChampionsNum", @"physicalDamageDealtToChampions", @"magicDamageDealtToChampionsNum", @"magicDamageDealtToChampions", nil];
        NSMutableDictionary * __block  herosInfoDic = [NSMutableDictionary dictionary];
        
        //@"goodHero01ID", @"goodHero02ID", @"goodHero03ID", @"goodHero04ID", @"goodHero05ID", @"goodHero01totalNum", @"goodHero02totalNum", @"goodHero03totalNum", @"goodHero04totalNum", @"goodHero05totalNum", @"goodHero01winRate", @"goodHero02winRate", @"goodHero03winRate", @"goodHero04winRate", @"goodHero05winRate", @"killsNum_ablity", @"deathsNum_ablity", @"assistsNum_ability", @"goldEarnedNum_ability", @"totalDamageTakenNum_ability", @"physicalDamageDealtToChampionsNum_ability", @"magicDamageDealtToChampionsNum_ability",
        [currentPlayer_ENkeys.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [currentPlayer_ENEntity setValue:@"0" forKey:obj];
        }];
        int __block largestMultiWinsLim = 1;
        NSSortDescriptor *ageDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gameId" ascending:NO];
        NSArray *sortDescriptors = @[ageDescriptor];
        NSArray * ParArr = [ParSet sortedArrayUsingDescriptors:sortDescriptors];
        [ParArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString * key = nil;
            int numValue = 0;
            NSString * CPKey =nil;
            Participant_EN *  par = (Participant_EN *)obj;
            for (key in currentPlayer_ENkeys.allKeys) {
                CPKey =[currentPlayer_ENkeys objectForKey:key];
                numValue =((NSString *)[currentPlayer_ENEntity valueForKey:CPKey]).intValue + ((NSString *)[par valueForKey:key]).intValue;
                [currentPlayer_ENEntity setValue:[NSString stringWithFormat:@"%d",numValue] forKey:CPKey];
            }
            if (idx == 0) {
                currentPlayer_ENEntity.largestMultiWins = par.win;
            }else
            {
                if ([par.win intValue] > [currentPlayer_ENEntity.largestMultiWins intValue] && largestMultiWinsLim < 10) {
                    currentPlayer_ENEntity.largestMultiWins = [NSString stringWithFormat:@"personal_lost_%d", (int)(idx < 10? idx : 10)];;
                    largestMultiWinsLim = 20;
                }else if ([par.win intValue] < [currentPlayer_ENEntity.largestMultiWins intValue] && largestMultiWinsLim < 10)
                {
                    currentPlayer_ENEntity.largestMultiWins = [NSString stringWithFormat:@"personal_win_%d", (int)(idx < 10? idx : 10)];;
                    largestMultiWinsLim = 20;
                }
            }
            currentPlayer_ENEntity.ranked = par.highestAchievedSeasonTier;
            
            //保存使用英雄ID以及胜利
            NSMutableDictionary * heroInfo = [NSMutableDictionary dictionary];
            if ([herosInfoDic.allKeys containsObject:par.championId]) {
                heroInfo = [herosInfoDic objectForKey:par.championId];
                NSString * winNum = [NSString stringWithFormat:@"%d", ((NSString *)[heroInfo objectForKey:@"winNum"]).intValue + par.win.intValue];
                NSString * totalNum = [NSString stringWithFormat:@"%d", ((NSString *)[heroInfo objectForKey:@"totalNum"]).intValue + 1];
                [heroInfo setObject:winNum forKey:@"winNum"];
                [heroInfo setObject:totalNum forKey:@"totalNum"];
                [herosInfoDic setObject:heroInfo forKey:par.championId];
            }else
            {
                [heroInfo setObject:par.win forKey:@"winNum"];
                [heroInfo setObject:@"1" forKey:@"totalNum"];
                [heroInfo setObject:par.championId forKey:@"championId"];
                [herosInfoDic setObject:heroInfo forKey:par.championId];
            }
            if (idx >= 19) {
                * stop = YES;
            }else
            {
                * stop = NO;
            }
        }];
        //排序获取常用5名英雄
        NSArray * herosInfoArrModel = herosInfoDic.allValues;
        NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"totalNum"ascending:NO];
        NSArray * herosInfoArr = [herosInfoArrModel sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor1]];
        [herosInfoArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary * heroInfo = (NSMutableDictionary *) obj;
            //@"goodHero01ID", @"goodHero01totalNum", @"goodHero05totalNum", @"goodHero01winRate",
            [currentPlayer_ENEntity setValue:[heroInfo objectForKey:@"championId"] forKey:[NSString stringWithFormat:@"goodHero0%dID", (int)(idx + 1)]];
            [currentPlayer_ENEntity setValue:[heroInfo objectForKey:@"totalNum"] forKey:[NSString stringWithFormat:@"goodHero0%dtotalNum", (int)(idx + 1)]];
            
            [currentPlayer_ENEntity setValue:[NSString stringWithFormat:@"%d%%", (int)(100 * ((NSString *)[heroInfo objectForKey:@"winNum"]).intValue/((NSString *)[heroInfo objectForKey:@"totalNum"]).intValue)] forKey:[NSString stringWithFormat:@"goodHero0%dwinRate", (int)(idx + 1)]];
            if (idx == 4) {
                * stop = YES;
            }
        }];
        
        //写入能力值
        NSDictionary * abilities = [NSDictionary dictionaryWithObjectsAndKeys:@"10", @"killsNum_ability", @"10", @"deathsNum_ability", @"10", @"assistsNum_ability", @"20000", @"goldEarnedNum_ability", @"50000", @"totalDamageTakenNum_ability", @"15000", @"physicalDamageDealtToChampionsNum_ability", @"15000", @"magicDamageDealtToChampionsNum_ability", nil];
        [abilities enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//            NSString * numKey = [((NSString *)key) stringByReplacingOccurrencesOfString:@"_ablity" withString:@""];
            NSMutableString * numKey = [NSMutableString stringWithString:key];
            [numKey deleteCharactersInRange:NSMakeRange(numKey.length - 8, 8)];
            int abV = ((NSString *)[currentPlayer_ENEntity valueForKey:numKey]).intValue * 100/ (20*((NSString *)obj).intValue);
            abV = (abV >= 95) ? 95:abV;
            abV = (abV <= 5) ? 5:abV;
            [currentPlayer_ENEntity setValue:[NSString stringWithFormat:@"%d", abV] forKey:key];
        }];
        
        
        currentPlayer_ENEntity.winRate = [NSString stringWithFormat:@"%d%%", currentPlayer_ENEntity.winRate.intValue*5];
        [parentContext save:NULL];
        NSLog(@"updateCurrentAccountStats finished");
        
    }else
    {
        NSLog(@"currentPlayer does not exist");
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoUpdateFinished" object:NULL];
}

+(void)insertCNMatchListWithData:(NSData *) data
{
    NSMutableDictionary * results = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
    
    for (NSDictionary * matchList in results) {
        NSManagedObjectContext * context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
        MatchList_CN * CNMatchListEntity = [NSEntityDescription insertNewObjectForEntityForName:@"MatchList_CN" inManagedObjectContext:context];
        CNMatchListEntity.battle_map = [matchList valueForKey:@"battle_map"];
        CNMatchListEntity.battle_time = [matchList valueForKey:@"battle_time"];
        CNMatchListEntity.champion_id = [matchList valueForKey:@"champion_id"];
        CNMatchListEntity.flag = [matchList valueForKey:@"flag"];
        CNMatchListEntity.game_id = [matchList valueForKey:@"game_id"];
        CNMatchListEntity.game_type = [matchList valueForKey:@"game_type"];
        CNMatchListEntity.win = [matchList valueForKey:@"win"];
        
        NSError * err;
        if ([context save:&err]) {
            NSLog(@"写入成功：CNMatchListEntity");
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSLog(@"路径是：%@",docPath);
        }else
        {
            [NSException raise:@"写入错误" format:@"错误是%@",[err localizedDescription]];
        }
    }
    
}
+(void)updateUserName_CN:(NSString *)userName
{
    NSString * APIKeysFilePath = [[NSBundle mainBundle] pathForResource:@"APIKeys" ofType:@"plist"];
    NSDictionary * easerAPIKey = [NSDictionary dictionaryWithContentsOfFile:APIKeysFilePath];
    NSDictionary * CNAPIKeys = [easerAPIKey objectForKey:@"CNAPIKeys"];
    NSDictionary * CNOpenAPIKey = [CNAPIKeys objectForKey:@"CNOpenKey"];
    
    if (CNOpenAPIKey == nil) {
        CNOpenAPIKey = [NSDictionary dictionaryWithObjectsAndKeys:@"5E4B0-55494-34708-B3444" ,@"DAIWAN-API-TOKEN", nil];
    }
    NSString * strURL = [NSString stringWithFormat:@"http://lolapi.games-cube.com/UserArea?keyword={%@}",userName];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    
    NSURLSessionConfiguration * sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfig setHTTPAdditionalHeaders:CNOpenAPIKey];
    
    NSURLSession * session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [NSException raise:@"获取UserArea网络通信错误" format:@"错误是%@",[error localizedDescription]];
        }else
        {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"jsonData is %@", jsonString);
            NSString *dataFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/CurrentSummoner_CN.plist"];
            [data writeToFile:dataFilePath atomically:YES];
            NSLog(@" dataFilePath is %@",dataFilePath);
        }
    }];
    [dataTask resume];
}
+(void)updateUserName_EN:(NSString *)userName
{
    NSString * strURL = [NSString stringWithFormat:@"https://na1.api.riotgames.com/lol/summoner/v3/summoners/by-name/%@?api_key=%@", userName, [self getAPIKey_EN]];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [NSException raise:@"获取UserArea网络通信错误" format:@"错误是%@",[error localizedDescription]];
        }else
        {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"jsonData is %@", jsonString);
            NSString *dataFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/CurrentSummoner_EN.plist"];
            NSLog(@"CurrentSummoner_EN.plist dataFilePath is %@",dataFilePath);
            NSDictionary * SummonerInfo_EN = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
            [SummonerInfo_EN writeToFile:dataFilePath atomically:YES];
            
        }
    }];
    [dataTask resume];
}

+(void)updateMatchWithListEntity:(MatchList_EN *) MatchList_ENEntity gameId:(NSString *) gameId
{
    NSString * strURL = [NSString stringWithFormat:@"https://na1.api.riotgames.com/lol/match/v3/matches/%@?api_key=%@", gameId, [self getAPIKey_EN]];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [NSException raise:@"updateMatchWithListEntity 网络通信错误" format:@"错误是%@",[error localizedDescription]];
        }else
        {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"jsonData is %@", jsonString);
            [self insertMatch_ENWithData:data withListEntity:MatchList_ENEntity gameId:gameId];
        }
    }];
    [dataTask resume];
}

+(void)insertMatch_ENWithData:(NSData *)data withListEntity:(MatchList_EN *) MatchList_ENEntity gameId:(NSString *) gameId
{
    NSMutableDictionary * __block Match_ENResource = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil]];
    NSMutableArray * __block teamsResource = [NSMutableArray arrayWithArray:[Match_ENResource objectForKey:@"teams"]];
    NSMutableArray * __block participantResource = [Match_ENResource objectForKey:@"participants"];
    NSMutableArray * __block participantIdentities = [Match_ENResource objectForKey:@"participantIdentities"];
    NSString * __block nomkey= nil;
    NSString * __block nomvalue = nil;
    NSArray * __block list_ENkeys = [NSArray arrayWithObjects:@"assistMost", @"assists", @"damageMost", @"deaths", @"doubleKills", @"gameCreation", @"gameMode", @"gameType", @"killMost", @"kills", @"minionMost", @"moneyMost", @"mvp", @"pentaKills", @"quadraKills", @"takenMost", @"tripleKills", @"turretMost", @"win", nil];
    int __block i = 0;
    //写入Match_EN实体
    [Match_ENResource removeObjectForKey:@"teams"];
    [Match_ENResource removeObjectForKey:@"participants"];
    [Match_ENResource removeObjectForKey:@"participantIdentities"];
//    NSManagedObjectContext * context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
//    NSManagedObjectContext * contextMatch_EN = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
//    [contextMatch_EN setParentContext:parentContext];
    
    [parentContext performBlock:^{
        NSString * currentAccountID = [NSString stringWithFormat:@"%@", [[GetData getSummonerInfo_EN] objectForKey:@"accountId"]];
        MatchList_EN * list_ENEntity =[parentContext objectWithID:MatchList_ENEntity.objectID];
//        Player_EN * currentPlayer = nil;
        
        NSError * errMatche01;
        NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Match_EN"];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"gameId == %@", list_ENEntity.gameId];
        [fetchRequest setPredicate:predicate];
        NSArray * matchesResults=[parentContext executeFetchRequest:fetchRequest error:&errMatche01];
        if (matchesResults.count > 0) {
            Match_EN * Match_ENEntity = matchesResults[0];
            for (nomkey in Match_ENResource.allKeys) {
                nomvalue = [NSString stringWithFormat:@"%@", [Match_ENResource objectForKey:nomkey]];
                if ([list_ENkeys containsObject:nomkey]) {
                    [list_ENEntity setValue:[Match_ENEntity valueForKey:nomkey] forKey:nomkey];
                }
            }
            NSMutableSet * listSetM = nil;
            if (Match_ENEntity.matchToLists == nil) {
                listSetM = [NSMutableSet set];
            }else
            {
                listSetM = [NSMutableSet setWithSet:Match_ENEntity.matchToLists];
            }
            [listSetM addObject:list_ENEntity];
            Match_ENEntity.matchToLists = [NSSet setWithSet:listSetM];
            
            Participant_EN * __block currentPar = nil;
            [Match_ENEntity.matchToTeams enumerateObjectsUsingBlock:^(Team_EN * _Nonnull obj, BOOL * _Nonnull stop) {
                [obj.teamToParticipants enumerateObjectsUsingBlock:^(Participant_EN * _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([currentAccountID isEqualToString:obj.accountId]) {
                        currentPar = obj;
                        [list_ENkeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([currentPar valueForKey:obj]) {
                                [list_ENEntity setValue:[currentPar valueForKey:obj] forKey:obj];
                                
                            }
                        }];
                    }
                    if (currentPar) {
                        *stop = YES;
                    }
                }];
                if (currentPar) {
                    *stop = YES;
                }
            }];
            NSLog(@"update Match_EN With Data finished");
        }else
        {
            Match_EN * Match_ENEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Match_EN" inManagedObjectContext:parentContext];
            for (nomkey in Match_ENResource.allKeys) {
                nomvalue = [NSString stringWithFormat:@"%@", [Match_ENResource objectForKey:nomkey]];
                [Match_ENEntity setValue:nomvalue forKey:nomkey];
                if ([list_ENkeys containsObject:nomkey]) {
                    [list_ENEntity setValue:[Match_ENEntity valueForKey:nomkey] forKey:nomkey];
                }
            }
            NSData * goldEventsData = [self getMatchTimeLineDataWithGameId:gameId];
            Match_ENEntity.goldEventsDicM = goldEventsData;
            NSMutableSet * listSetM = nil;
            if (Match_ENEntity.matchToLists == nil) {
                listSetM = [NSMutableSet set];
            }else
            {
                listSetM = [NSMutableSet setWithSet:Match_ENEntity.matchToLists];
            }
            [listSetM addObject:list_ENEntity];
            Match_ENEntity.matchToLists = [NSSet setWithSet:listSetM];
            //        NSError * err;
            //        if ( [parentContext save:&err]) {
            //            NSLog(@"写入成功：Match_EN");
            //            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            //            NSLog(@"路径是：%@",docPath);
            //            }else
            //        {
            //            [NSException raise:@"Match_EN写入错误" format:@"错误是%@",[err localizedDescription]];
            //        }
            //写入Team_EN实体
            for (NSDictionary * teamD in teamsResource) {
                NSMutableDictionary * honorShujuM = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0", @"kda", @"0", @"assists", @"0", @"kills", @"0", @"totalMinionsKilled", @"0", @"goldEarned", @"0", @"totalDamageTaken",  @"0", @"turretKills",@"0", @"totalDamageDealt", nil];
                NSMutableDictionary * honorConectM = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"mvp",@"kda", @"assistMost",@"assists", @"killMost", @"kills", @"minionMost", @"totalMinionsKilled", @"moneyMost", @"goldEarned",  @"takenMost", @"totalDamageTaken", @"turretMost", @"turretKills", @"damageMost", @"totalDamageDealt", nil];
                NSMutableDictionary * honorObjIdM = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0", @"mvp", @"0", @"assistMost", @"0", @"killMost", @"0", @"minionMost", @"0", @"moneyMost", @"0", @"takenMost", @"0", @"turretMost" , @"0", @"damageMost",nil];
                //                NSMutableDictionary * honorObjIdM = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0", @"KDA", @"0", @"mvp", @"0", @"assists", @"0", @"assistMost", @"0", @"kills", @"0", @"killMost", @"0", @"totalMinionsKilled", @"0", @"minionMost", @"0", @"goldEarned", @"0", @"moneyMost", @"0", @"totalDamageTaken", @"0", @"takenMost",  @"0", @"turretKills", @"0", @"turretMost" , @"0", @"totalDamageDealt", @"0", @"damageMost",nil];
                NSMutableDictionary * team = [NSMutableDictionary dictionaryWithDictionary:teamD];
                [team setObject:gameId forKey:@"gameId"];
                NSArray * bans = [team objectForKey:@"bans"];
                for (i = 0; i < bans.count; i++) {
                    NSMutableDictionary * ban = bans[i];
                    [ban objectForKey:@"championId"];
                    [team setObject:[ban objectForKey:@"championId"] forKey:[NSString stringWithFormat:@"ban%d",i]];
                }
                [team removeObjectForKey:@"bans"];
                //            NSManagedObjectContext * context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
                //            NSManagedObjectContext * contextTeam_EN = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
                Team_EN * Team_ENEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Team_EN" inManagedObjectContext:parentContext];
                for (nomkey in team.allKeys) {
                    nomvalue = [NSString stringWithFormat:@"%@", [team objectForKey:nomkey]];
                    [Team_ENEntity setValue:nomvalue forKey:nomkey];
                }
                Team_ENEntity.teamToMatch = Match_ENEntity;
                //            NSError * err;
                //            if ([parentContext save:&err]) {
                //                NSLog(@"写入成功：Team_EN");
                //                NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                //                NSLog(@"路径是：%@",docPath);
                //            }else
                //            {
                //                [NSException raise:@"Team_EN写入错误" format:@"错误是%@",[err localizedDescription]];
                //            }
                
                int lim = 0;
                if ([Team_ENEntity.teamId isEqualToString:@"100"]) {
                    i = 0;
                    lim = 5;
                }else
                {
                    i = 5;
                    lim = 10;
                }
                //写入Participant_EN实体
                for (; i < lim; i++) {
                    
                    //写入Player_EN实体
                    NSDictionary * participantIdentity = participantIdentities[i];
                    NSDictionary * player = [participantIdentity objectForKey:@"player"];
                    Player_EN * Player_ENEntity = nil;
                    NSError * errPlayer01;
                    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Player_EN"];
                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"accountId == %@", [player objectForKey:@"accountId"]];
                    [fetchRequest setPredicate:predicate];
                    NSArray * playersResults=[parentContext executeFetchRequest:fetchRequest error:&errPlayer01];
                    if (errPlayer01) {
                        [NSException raise:@"Player_EN读取错误" format:@"错误是%@",[errPlayer01 localizedDescription]];
                    }
                    if (playersResults.count > 0)
                    {
                        Player_ENEntity = playersResults[0];
                        
                    }else
                    {
                        Player_ENEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Player_EN" inManagedObjectContext:parentContext];
                    }
                    for (nomkey in player.allKeys) {
                        nomvalue = [NSString stringWithFormat:@"%@", [player objectForKey:nomkey]];
                        [Player_ENEntity setValue:nomvalue forKey:nomkey];
                    }
                    
//                    if ([Player_ENEntity.accountId isEqualToString:currentAccountID] ) {
//                        currentPlayer = Player_ENEntity;
//                    }
                    
                    NSMutableDictionary * participant = [NSMutableDictionary dictionaryWithDictionary:participantResource[i]];
                    [participant setObject:gameId forKey:@"gameId"];
                    NSMutableDictionary * stats = [NSMutableDictionary dictionaryWithDictionary:[participant objectForKey:@"stats"]];
                    NSMutableArray * runes = [participant objectForKey:@"runes"];
                    NSMutableArray * masteries = [participant objectForKey:@"masteries"];
                    NSMutableDictionary * timeline = [participant objectForKey:@"timeline"];
                    [participant removeObjectForKey:@"stats"];
                    [participant removeObjectForKey:@"runes"];
                    [participant removeObjectForKey:@"masteries"];
                    [participant removeObjectForKey:@"timeline"];
                    //                    NSManagedObjectContext * context = ((AppDelegate *)[UIApplication sharedApplication].delegate).persistentContainer.viewContext;
                    //                    NSManagedObjectContext * contextParticipant_EN = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
                    Participant_EN * Participant_ENEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Participant_EN" inManagedObjectContext:parentContext];
                    for (nomkey in participant.allKeys) {
                        nomvalue = [NSString stringWithFormat:@"%@", [participant objectForKey:nomkey]];
                        [Participant_ENEntity setValue:nomvalue forKey:nomkey];
                    }
                    CGFloat dF = [[stats objectForKey:@"deaths"] floatValue]>0?[[stats objectForKey:@"deaths"] floatValue]:1.0f;
                    CGFloat kdaP = (([[stats objectForKey:@"kills"] floatValue] + [[stats objectForKey:@"assists"] floatValue])/(dF * 3.0f));
                    NSString * kdaStr = [NSString stringWithFormat:@"%.2f",kdaP];
                    [stats setObject:kdaStr forKey:@"kda"];
                    if (Player_ENEntity.accountId != nil) {
                        [stats setObject:Player_ENEntity.accountId forKey:@"accountId"];
                        [stats setObject:Player_ENEntity.summonerName forKey:@"summonerName"];
                        NSLog(@"Player_ENEntity exist01");
                    }else
                    {
                        NSLog(@"Player_ENEntity does not exist01");
                    }
                    if ([NSString stringWithFormat:@"%@", [stats objectForKey:@"largestMultiKill"]].intValue > 7) {
                        [stats setObject:@"1" forKey:@"chaoshen"];
                    }
                    for (nomkey in stats.allKeys) {
                        nomvalue = [NSString stringWithFormat:@"%@", [stats objectForKey:nomkey]];
                        [Participant_ENEntity setValue:nomvalue forKey:nomkey];
                        if ([list_ENkeys containsObject:nomkey] && [currentAccountID isEqualToString:Player_ENEntity.accountId]) {
                            NSLog(@"set current account %@ honor01", Player_ENEntity.accountId);
                            [list_ENEntity setValue:nomvalue forKey:nomkey];
                        }else
                        {
                            NSLog(@"is not current account honor01");
                        }
                    }
                    [honorShujuM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        CGFloat recV =[((NSString *)obj) floatValue];
                        CGFloat parV =[[Participant_ENEntity valueForKey:key] floatValue];
                        
                        if ([((NSString *)obj) floatValue] < [[Participant_ENEntity valueForKey:key] floatValue]) {
                            [honorObjIdM setObject:Participant_ENEntity.objectID forKey:[honorConectM objectForKey:key]];
                            [honorShujuM setObject:[Participant_ENEntity valueForKey:key] forKey:key];
                        }else
                        {
                            NSLog(@"recV is %f parV is %f key is %@ honor is %@", recV, parV, key, [honorConectM objectForKey:key]);
                            
                            CGFloat recV =[((NSString *)obj) floatValue];
                            CGFloat parV =[[Participant_ENEntity valueForKey:key] floatValue];
                            
                            
                        }
                    }];
                    Participant_ENEntity.participantToTeam = Team_ENEntity;
                    
                    
                    //设置playToParticipants
                    if (Player_ENEntity.accountId != nil) {
                        NSMutableSet * set = [NSMutableSet setWithSet:Player_ENEntity.playToParticipants];
                        if (set == nil) {
                            set = [NSMutableSet set];
                        }
                        if (Participant_ENEntity != nil) {
                            [set addObject:Participant_ENEntity];
                        }
                        Player_ENEntity.playToParticipants = [NSSet setWithSet:set];
                        NSLog(@"Player_ENEntity.accountId is %@, does not set playToParticipants", Player_ENEntity.accountId);
                    }else
                    {
                        NSLog(@"Player_ENEntity.accountId is nil, does not set playToParticipants");
                    }
                    
                    
                    
                    
                    //写入Rune_EN实体
                    for (NSDictionary * run in runes) {
                        Rune_EN * Rune_ENEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Rune_EN" inManagedObjectContext:parentContext];
                        for (nomkey in run.allKeys) {
                            nomvalue = [NSString stringWithFormat:@"%@", [run objectForKey:nomkey]];
                            [Rune_ENEntity setValue:nomvalue forKey:nomkey];
                        }
                        Rune_ENEntity.runeToParticipant = Participant_ENEntity;
                    }
                    
                    //写入Mastery_EN实体
                    for (NSDictionary * mastery in masteries) {
                        Mastery_EN * Mastery_ENEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Mastery_EN" inManagedObjectContext:parentContext];
                        for (nomkey in mastery.allKeys) {
                            nomvalue = [NSString stringWithFormat:@"%@", [mastery objectForKey:nomkey]];
                            [Mastery_ENEntity setValue:nomvalue forKey:nomkey];
                        }
                        Mastery_ENEntity.masteryToParticipant = Participant_ENEntity;
                    }
                    
                }
                
                
                
                [honorObjIdM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    
                    if ([obj isKindOfClass:[NSManagedObjectID class]]) {
                        
                        Participant_EN * participant_EN = [parentContext objectWithID:(NSManagedObjectID *)obj];
                        [participant_EN setValue:@"1" forKey:key];
                        NSLog(@"set honor participant_EN.accountId is %@", participant_EN.accountId);
                        if ([participant_EN.accountId isEqualToString:currentAccountID]) {
                            
                            [list_ENEntity setValue:@"1" forKey:key];
                            
                        }
                        
                    }
                }];
            }
            NSLog(@"insert Match_EN With Data finished");
        }
        NSError * err01;
        if ([parentContext save:&err01]) {
            NSLog(@"写入成功：Match_EN");
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSLog(@"路径是：%@",docPath);
        }else
        {
            [NSException raise:@"Match_EN写入错误" format:@"错误是%@",[err01 localizedDescription]];
        }
    }];
}
                                                    
+(NSData *)getMatchTimeLineDataWithGameId:(NSString *)gameId
{
    // https://na1.api.riotgames.com/lol/match/v3/timelines/by-match/2544379303?api_key=RGAPI-a281494f-4dc4-47dd-8ad3-41dfd956d099
    NSString * strURL = [NSString stringWithFormat:@"https://na1.api.riotgames.com/lol/match/v3/timelines/by-match/%@?api_key=%@", gameId, [self getAPIKey_EN]];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    NSData * data01 = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:nil];
    return data01;
}

+(NSURL *)getProfileIconURL_EN
{
    NSDictionary * getSummonerInfo_EN = [self getSummonerInfo_EN];
    
    NSString * strURL = [NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/6.24.1/img/profileicon/%@.png", [getSummonerInfo_EN objectForKey:@"profileIconId"]];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    return url;
}
+(NSURL *)getChampionIconURLWithName_EN:(NSString *)squareFullName
{
    NSString * strURL = [NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/6.24.1/img/champion/%@", squareFullName];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    return url;
}

+(NSURL *)getChampionURLWithID_EN:(NSString *)ChampionID
{
    NSString * strURL = [NSString stringWithFormat:@"https://na1.api.riotgames.com/lol/static-data/v3/champions/%@?locale=en_US&tags=all&api_key=%@", ChampionID, [self getAPIKey_EN]];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    return url;
}
+(NSDictionary *)getChampionWithID_EN:(NSString *)ChampionID
{
    NSString * strURL = [NSString stringWithFormat:@"https://na1.api.riotgames.com/lol/static-data/v3/champions/%@?locale=en_US&api_key=%@", ChampionID, [self getAPIKey_EN]];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    NSData * data = [NSData dataWithContentsOfURL:url];
    if (data == nil) {
        return nil;
    }else{
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:NULL];
        return dic;
    }
}
+(NSArray *)getMatchListWithAccountId_EN:(NSString *) accountId
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"accountId == %@",accountId];
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"gameId" ascending:NO];
    NSArray * matchs = [self fetchEntityNamed:@"MatchList_EN" withPredicate:predicate withSort: sort];
    return matchs;
}

+(NSArray *) fetchEntityNamed:(NSString *) EntityName withPredicate:(nullable NSPredicate *) predicate withSort:(nullable NSSortDescriptor *) sort
{
    NSManagedObjectContext * context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:EntityName];;
    NSEntityDescription * testEntity = [NSEntityDescription entityForName:EntityName inManagedObjectContext:context];
    request.entity = testEntity;
//    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:[entityNameAndSort valueForKey:@"sort"] ascending:NO];
    if (sort != nil) {
        [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    }
//    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
//    [request setFetchBatchSize:20];
    if (predicate != nil) {
        [request setPredicate:predicate];
    }
    
    NSError * err;
    NSArray * results = [context executeFetchRequest:request error:&err];
    if(results.count)
    {
        NSLog(@"Success to get Result In Entity Named:%@ , result has %lu objects",EntityName,(unsigned long)results.count);
    }else if(err)
    {
        [NSException raise:@"Fail to get Result In Entity Named: " format:@"%@ ,error is %@",EntityName,[err localizedDescription]];
    }else
    {
        NSLog(@"No Results in Entity Named:%@",EntityName);
    }
    return results;
}


+(NSDictionary *)getSummonerInfo_EN
{
    NSString *dataFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/CurrentSummoner_EN.plist"];
    NSDictionary * SummonerInfo_EN = [NSDictionary dictionaryWithContentsOfFile:dataFilePath];
    return SummonerInfo_EN;
}

+(NSDictionary *)getSummonerPicDic_EN
{
    NSString * currentAcountId = [[GetData getSummonerInfo_EN] objectForKey:@"profileIconId"];
    NSString * iconNameKey = [NSString stringWithFormat:@"profileIcon_EN_%@.png", currentAcountId];
    NSString * iconPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:iconNameKey];
    NSString * iconURL = [NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/6.24.1/img/profileicon/%@.png", currentAcountId];
    NSString * strURLEncod = [iconURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:iconNameKey, @"NameKey", iconPath, @"Path", url, @"URL", nil];
    return dic;
}

+(NSArray *)getSummonerEntityArr_EN
{
    [self updateParentContext];
    NSError * errPlayer01;
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Player_EN"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"accountId == %@", [[self getSummonerInfo_EN] objectForKey:@"accountId"]];
    [fetchRequest setPredicate:predicate];
    NSArray * playersResults = [parentContext executeFetchRequest:fetchRequest error:&errPlayer01];
    if (playersResults.count > 0) {
        return playersResults;
    }else
    {
        return nil;
    }
}

+(void)updateParentContext
{
    if (!parentContext) {
        NSManagedObjectContext * contextMatchList_EN = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        NSPersistentContainer * psc =[[NSPersistentContainer alloc] initWithName:@"LOLHelper"];
        [psc loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * storeDescription, NSError * error) {
            if (error != nil) {
                NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                abort();
            }
        }];
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LOLHelper" withExtension:@"momd"];
        NSLog(@"%@", modelURL);
        
        [contextMatchList_EN setPersistentStoreCoordinator:psc.persistentStoreCoordinator];
        parentContext = contextMatchList_EN;
    }
}


+(void)deleteCoreData
{
    NSString *libDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    libDir = [libDir stringByAppendingPathComponent:@"Application Support"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSArray * fileList = [fileManager contentsOfDirectoryAtPath:libDir error:NULL];
    [fileList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * fileStr = [libDir stringByAppendingPathComponent:obj];
        [fileManager removeItemAtPath:fileStr error:NULL];
        NSLog(@"file path is %@", fileStr);
    }];
    NSLog(@"delete CoreData Finished");
}
@end
