//
//  GetData+GetGameData.m
//  LOLHelper
//
//  Created by Easer Liu on 24/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "GetData+GetGameData.h"
#import "MatchListEntites_ENHeader.h"
#import "OptimizeLog.h"

static NSManagedObjectContext * mainParentContext;

@implementation GetData (GetGameData)

+(void)updateChampionsBrife_EN
{
    NSString * strURL = [NSString stringWithFormat:@"https://na1.api.riotgames.com/lol/static-data/v3/champions?locale=en_US&tags=tags&tags=image&dataById=true&api_key=%@", [self getAPIKey_EN]];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [NSException raise:@"uploadChampionsBrife_EN 网络通信错误" format:@"错误是%@",[error localizedDescription]];
        }else
        {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"jsonData is %@", jsonString);
            NSDictionary * dic = nil;
            
            if (data != nil) {
                dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
                if ([dic.allKeys containsObject:@"status"]) {
                    dic = [dic objectForKey:@"status"];
                    if ([dic.allKeys containsObject:@"message"] && [dic.allKeys containsObject:@"status_code"]) {
                        NSString * code = [NSString stringWithFormat:@"%@", [dic objectForKey:@"status_code"]];
                        if (![code isEqualToString:@"200"]) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayNotification" object:[NSString stringWithFormat:@"Gain Champ Brife Error is Message:%@ status_code:%@", [dic objectForKey:@"message"], [dic objectForKey:@"status_code"]]];
                            data = [self getChampionsFromURL];
                            dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
                            dic = [self checkKeyAndIdInDic:dic];
                        }
                    }
                }
            }else
            {
                data = [self getChampionsFromURL];
                dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
                dic = [self checkKeyAndIdInDic:dic];
            }
 
            [self insertChampionsBrife_ENWithData:data];
        }
    }];
    [dataTask resume];
    
    [self updateItem_EN];
    [self updateMasteryData_EN];
    [self updateRuneData_EN];
}
+(NSDictionary *) checkKeyAndIdInDic:(NSDictionary *)dic
{
    NSString * idS = [dic objectForKey:@"id"];
    NSString * keyS = [dic objectForKey:@"key"];
    NSString *idRegex = @"[0-9]+";
    NSString *keyRegex = @"[A-Za-z]+";
    NSPredicate *idTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idRegex];
    NSPredicate *keyTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", keyRegex];
    if ([idTest evaluateWithObject:keyS] && [keyTest evaluateWithObject:idS]) {
        NSMutableDictionary * dicM = [NSMutableDictionary dictionaryWithDictionary:dic];
        [dicM setObject:idS forKey:@"key"];
        [dicM setObject:keyS forKey:@"id"];
        dic = [NSDictionary dictionaryWithDictionary:dicM];
    }
    return dic;
}
+(NSData*)getChampionsFromURL
{
    NSString * strURL = [NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/6.24.1/data/en_US/champion.json"];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    NSData * data = [NSData dataWithContentsOfURL:url];
    return data;
}

+(NSDictionary *)getChampionDetailWithId:(NSString * )ChampionId  andName:(NSString * )ChampionKey
{
    NSString * strURL = [NSString stringWithFormat:@"https://na1.api.riotgames.com/lol/static-data/v3/champions/%@?locale=en_US&tags=all&api_key=%@", ChampionId,  [self getAPIKey_EN]];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    NSData * data = [NSData dataWithContentsOfURL:url];
    NSDictionary * dic = nil;
    
    if (data == nil) {
        data = [self getChampionDetailWithChampionKey:ChampionKey];
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@" str is %@", str);
        
        dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        dic = [dic objectForKey:@"data"];
        dic = [dic allValues][0];
        dic = [self checkKeyAndIdInDic:dic];

    }else
    {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@" str is %@", str);
        dic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        
    }
    
    return dic;
}

+(NSData *)getChampionDetailWithChampionKey:(NSString * )ChampionKey
{
    NSString * strURL = [NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/6.24.1/data/en_US/champion/%@.json", ChampionKey];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    NSData * data = [NSData dataWithContentsOfURL:url];
    return data;
}
+(void)insertChampionsBrife_ENWithData:(NSData *)data
{
    NSArray <ChampionsBrief_EN *>* matchesResults=[self getChampionsBrife_ENWithTag:NULL];
    NSMutableDictionary * results = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
    NSMutableDictionary * ChampionsBrifesM = [NSMutableDictionary dictionaryWithDictionary:[results objectForKey:@"data"]];
    ChampionsBrifesM = [NSMutableDictionary dictionaryWithDictionary:[self checkKeyAndIdInDic:[NSDictionary dictionaryWithDictionary:ChampionsBrifesM]]];
    NSManagedObjectContext * subContext = [self createSubContext];
    [subContext performBlock:^{
        NSArray * propertyList = [GetData getPropertyArrFrom:ChampionsBrief_EN.class];
        [ChampionsBrifesM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            ChampionsBrief_EN * __block championBrief = nil;
            NSString * championId =key;
            [matchesResults enumerateObjectsUsingBlock:^(ChampionsBrief_EN * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([((NSString *)[obj valueForKey:@"id"]) isEqualToString:championId] || [((NSString *)[obj valueForKey:@"key"]) isEqualToString:championId]) {
                    championBrief = obj;
                    *stop = YES;
                }
            }];
            
            if (championBrief == nil) {
                championBrief = [[ChampionsBrief_EN alloc] initWithEntity:[NSEntityDescription entityForName:@"ChampionsBrief_EN" inManagedObjectContext:subContext] insertIntoManagedObjectContext:subContext];
            }
            NSDictionary * datas = obj;
            [datas enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isEqualToString:@"tags"]) {
                    NSMutableString * __block tagsStr = [NSMutableString string];
                    [((NSArray *)obj) enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSMutableString * tagStr = [NSMutableString string];
                        if ([((NSString *)obj) isEqualToString:@"Tank,melee"]) {
                            tagStr = [NSMutableString stringWithFormat:@"Tank/Melee"];
                        }else
                        {
                            tagStr = [NSMutableString stringWithString:[((NSString *)obj) capitalizedString]];
                        }
                        if (idx == 0 ) {
                            [tagsStr appendString:tagStr];
                        }else
                        {
                            [tagsStr appendFormat:@"/%@", tagStr];
                        }
                    }];
                    championBrief.tags = [NSString stringWithString:tagsStr];
                }else if([key isEqualToString:@"image"])
                {
                    NSDictionary * dic = obj;
                    championBrief.square = [dic objectForKey:@"full"];
                }else if([propertyList containsObject:key])
                {
                    [championBrief setValue:[NSString stringWithFormat:@"%@", obj] forKey:key];
                    NSLog(@"ChampionBriefKeys contain %@", key);
                }else
                {
                    NSLog(@"ChampionBriefKeys does not contain %@", key);
                }
            }];
        }];
        NSError * err;
        [self saveContext:subContext withErr:err postNotificationName:@"UpdateChampionsBrief_ENFinished" object:NULL userInfo:NULL];
        if (err) {
            [NSException raise:@"insertChampionsBrife_ENWithData 错误" format:@"错误是%@",[err localizedDescription]];
        }
        
    }];
    
    
}
+(NSArray *)getChampionsBrife_ENWithTag:(nullable NSString * )tagStr
{
    NSError * errMatche01;
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ChampionsBrief_EN"];
    if (![tagStr isEqualToString:@"AllChamps"] && tagStr != nil) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"tags CONTAINS[cd] %@", tagStr];
        [fetchRequest setPredicate:predicate];
    }
    
    [self updateGGDParentContext];
    NSArray * ChampionsBrifesResults=[mainParentContext executeFetchRequest:fetchRequest error:&errMatche01];
    return ChampionsBrifesResults;
}

+(NSArray *)getChampionsBrife_ENWithId:(nonnull NSString * )Id
{
    NSError * errMatche01;
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"ChampionsBrief_EN"];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"id CONTAINS %@", Id];
        [fetchRequest setPredicate:predicate];
    
    [self updateGGDParentContext];
    NSArray * ChampionsBrifesResults=[mainParentContext executeFetchRequest:fetchRequest error:&errMatche01];
    
    return ChampionsBrifesResults;
}

+(nonnull NSDictionary *)getChampPicDicImageName_EN:(nonnull NSString *)imageName
{
    NSString * iconNameKey = [NSString stringWithFormat:@"championIcon_EN_%@", imageName];
    NSString * iconPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:iconNameKey];
    NSString * iconURL = [NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/6.24.1/img/champion/%@", imageName];
    NSString * strURLEncod = [iconURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:iconNameKey, @"NameKey", iconPath, @"Path", url, @"URL", nil];
    return dic;
}

+(NSManagedObjectContext * )createSubContext
{
    if (mainParentContext == nil) {
        AppDelegate * appDe = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext * subContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [subContext setParentContext:appDe.persistentContainer.viewContext];
        mainParentContext = subContext;
    }
    return mainParentContext;
}
+(void)updateGGDParentContext
{
    if (mainParentContext == nil) {
        AppDelegate * appDe = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext * subContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [subContext setParentContext:appDe.persistentContainer.viewContext];
        mainParentContext = subContext;
    }
}


+(NSURL *)getChampionSkinURLWithName_EN:(NSString *)ChampionKey Num:(NSString *)num
{
    NSString * strURL = [NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/img/champion/splash/%@_%@.jpg", ChampionKey, num];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    return url;
}
+(NSURL *)getChampionLoadingArtURLWithName_EN:(NSString *)ChampionKey Num:(NSString *)num
{
    NSString * strURL = [NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/img/champion/loading/%@_%@.jpg", ChampionKey, num];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    return url;
}
+(NSURL *)getChampionPassiveSkillURLWithSkillName_EN:(NSString *)SkillName
{
    NSString * strURL = [NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/6.24.1/img/passive/%@", SkillName];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    return url;
}

+(NSURL *)getChampionActiveSkillURLWithSkillName_EN:(NSString *)SkillName
{
    NSString * strURL = [NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/6.24.1/img/spell/%@", SkillName];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    return url;
}


+(void)updateItem_EN
{
    NSString * urlStr = [NSString stringWithFormat:@"https://na1.api.riotgames.com/lol/static-data/v3/items?locale=en_US&tags=all&api_key=%@",[self getAPIKey_EN]];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [NSException raise:@"updateItem_EN 网络通信错误" format:@"错误是%@",[error localizedDescription]];
        }else
        {
            NSError * err;
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
            if (err) {
                [NSException raise:@"updateItem_EN 网络通信错误" format:@"错误是%@",[err localizedDescription]];
                dic = [self getItemsJOSN_EN];
                
            }else if ([dic objectForKey:@"status"])
            {
                NSDictionary * ststus = [dic objectForKey:@"status"];
                NSLog(@"message is %@, ststus_code is %@", [ststus objectForKey:@"message"], [ststus objectForKey:@"status_code"]);
                dic = [self getItemsJOSN_EN];
            }

            NSDictionary * resultsDic = [dic objectForKey:@"data"];
            [self insertItem_ENWithDic:resultsDic];
            
        }
            }];
    [dataTask resume];
}

+(NSDictionary *)getItemsJOSN_EN
{
    NSString * strURL = [NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/6.24.1/data/en_US/item.json"];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    
    NSData * data = [NSData dataWithContentsOfURL:url];

    NSError * err;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
    
    if (err) {
        [NSException raise:@"getItemsJOSN_EN 网络通信错误" format:@"错误是%@",[err localizedDescription]];
        return nil;
    }else
    {
        return dic;
    }
}

+(void)insertItem_ENWithDic:(NSDictionary *)dic
{
    NSArray<Item_EN *> * resultsArrGot = [self getItem_ENWithId:NULL tag:NULL map:NULL];
    NSMutableDictionary * resultsDicGot = [NSMutableDictionary dictionary];
    NSManagedObjectContext * subContect = [self createSubContext];
    [subContect performBlock:^{
        
        [resultsArrGot enumerateObjectsUsingBlock:^(Item_EN * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"name is %@, id is %@, tags is %@", [obj valueForKey:@"name"], [obj valueForKey:@"id"], [obj valueForKey:@"tags"]);
            [resultsDicGot setObject:obj forKey:obj.id];
        }];
        
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            Item_EN * item = nil;
            if ([resultsDicGot.allKeys containsObject:key]) {
                item = [resultsDicGot objectForKey:key];
            }else
            {
                item = [[Item_EN alloc] initWithEntity:[NSEntityDescription entityForName:@"Item_EN" inManagedObjectContext:subContect] insertIntoManagedObjectContext:subContect];
            }
            
            [item setId:key];
            [((NSDictionary *)obj) enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                if ([key isEqualToString:@"gold"]) {
                    [(NSDictionary *)obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        [item setValue:[NSString stringWithFormat:@"%@", obj] forKey:key];
                        NSLog(@"key is %@, value is %@", key, obj);
                    }];
                }else if ([key isEqualToString:@"image"])
                {
                    item.square = [NSString stringWithFormat:@"%@", [(NSDictionary *)obj objectForKey:@"full"]];
                    NSLog(@"key is square, value is %@", item.square);
                }else if ([[NSArray arrayWithObjects:@"into",@"tags", @"from", nil] containsObject:key])
                {
                    NSMutableString * valueM = [NSMutableString string];
                    
                    [(NSArray *)obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (idx == 0) {
                            [valueM appendString:[NSString stringWithFormat:@"%@", obj]];
                        }else
                        {
                            [valueM appendString:[NSString stringWithFormat:@"/%@", obj]];
                        }
                    }];
                    
                    [item setValue:valueM forKey:key];
                    NSLog(@"key is %@, value is %@", key, valueM);
                }else if ([key isEqualToString:@"maps"])
                {
                    NSDictionary * mapKeyDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Crystal Scar", @"8",@"Twisted Treeline", @"10", @"Summoner's Rift", @"11",@"Howling Abyss",@"12", nil];
                    NSMutableString * valueM = [NSMutableString string];
                    NSDictionary * mapDic = (NSDictionary *)obj;
                    
                    [mapKeyDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([[NSString stringWithFormat:@"%@", [mapDic objectForKey:key]] isEqualToString:@"1"]) {
                            
                            [valueM appendFormat:@"%@/", obj];
                        }
                    }];
                    NSLog(@"valueM is %@, length is %d", valueM, (int)valueM.length);
                    if (valueM.length > 0) {
                        [valueM deleteCharactersInRange:NSMakeRange(valueM.length-1, 1)];
                        [item setValue:[NSString stringWithString:valueM] forKey:key];
                    }
                }else if ([key isEqualToString:@"description"])
                {
                    item.descriptions = [NSString stringWithFormat:@"%@", obj];
                }else if ([key isEqualToString:@"effect"])
                {
                    NSDictionary * effectDic = obj;
                    NSMutableString * valueM = [NSMutableString string];
                    
                    [effectDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        [valueM appendFormat:@"%@/", key];
                        [valueM appendFormat:@"%@/", obj];
                    }];
                    
                    if (valueM.length > 0) {
                        [valueM deleteCharactersInRange:NSMakeRange(valueM.length-1, 1)];
                    }
                    [item setValue:[NSString stringWithString:valueM] forKey:key];
                }else
                {
                    [item setValue:[NSString stringWithFormat:@"%@", obj] forKey:key];
                    NSLog(@"key is %@, value is %@", key, obj);
                }

            }];
        }];
        NSError * itemErr;
        [self saveContext:subContect withErr:itemErr postNotificationName:@"insertItem_ENWithDic" object:NULL userInfo:NULL];
    }];
}

+(NSArray *)getItem_ENWithId:(nullable NSString *)identifyty tag:(nullable NSString *) tag map:(nullable NSString *)map
{
    NSFetchRequest * request = [Item_EN fetchRequest];
    NSMutableArray * preArrM = [NSMutableArray array];
    if (identifyty) {
        [preArrM addObject:[NSPredicate predicateWithFormat:@"id CONTAINS %@", identifyty]];
        
    }else
    {
        if (tag && ![tag isEqualToString:@"All Items"]){
            [preArrM addObject:[NSPredicate predicateWithFormat:@"tags CONTAINS %@", tag]];
        }
        if (map && ![map isEqualToString:@"All Maps"]){
            [preArrM addObject:[NSPredicate predicateWithFormat:@"maps CONTAINS %@", map]];
        }
    }
    
    if (preArrM.count > 0) {
        NSCompoundPredicate * pre = [NSCompoundPredicate andPredicateWithSubpredicates:preArrM];
        [request setPredicate:pre];
    }
    [self updateGGDParentContext];
    NSError * err;
    NSArray <Item_EN *>* resualtsArr = [mainParentContext executeFetchRequest:request error:&err];
    
    if (resualtsArr.count > 0) {
        return resualtsArr;
    }else if(err)
    {
        [NSException raise:@"getItem_EN错误" format:@"错误是%@",[err localizedDescription]];
        return nil;
    }else
    {
        return nil;
    }
}
+(NSURL *)getItemSquareWithImageName_EN:(NSString *)imageName
{
    NSString * strURL = [NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/6.24.1/img/item/%@", imageName];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    return url;
}

+(nonnull NSDictionary *)getItemPicDicImageName_EN:(nonnull NSString *)imageName
{
    NSString * iconNameKey = [NSString stringWithFormat:@"item_EN_%@", imageName];
    NSString * iconPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:iconNameKey];
    NSString * iconURL = [NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/6.24.1/img/item/%@", imageName];
    
    NSString * strURLEncod = [iconURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:iconNameKey, @"NameKey", iconPath, @"Path", url, @"URL", nil];
    return dic;
}

+(void)updateMasteryData_EN
{
    NSString * strURL = [NSString stringWithFormat:@"https://na1.api.riotgames.com/lol/static-data/v3/masteries?locale=en_US&tags=all&api_key=%@",[self getAPIKey_EN]];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [NSException raise:@"updateMasteryData_EN 网络通信错误" format:@"错误是%@",[error localizedDescription]];
        }else
        {
            NSError * err;
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
            if (err) {
                [NSException raise:@"updateMasteryData_EN 错误" format:@"错误是%@",[err localizedDescription]];
                dic = [self getMasteriesJOSN_EN];
                
            }else if ([dic objectForKey:@"status"])
            {
                NSDictionary * ststus = [dic objectForKey:@"status"];
                NSLog(@"updateMasteryData_EN message is %@, ststus_code is %@", [ststus objectForKey:@"message"], [ststus objectForKey:@"status_code"]);
                dic = [self getMasteriesJOSN_EN];
            }
            if (dic != nil) {
                NSDictionary * resultsDic = [dic objectForKey:@"data"];
                [self insertMasteryData_ENWithDic:resultsDic];
            }else
            {
                NSLog(@"masteries dic is nil");
            }
        }
    }];
    [dataTask resume];
}

+(NSDictionary *)getMasteriesJOSN_EN
{
    NSString * strURL = [NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/6.24.1/data/en_US/mastery.json"];
    NSString * strURLEcond = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEcond];
    NSData * data = [NSData dataWithContentsOfURL:url];
    NSError * err;
    NSDictionary * dic = nil;
    if (data != nil) {
        dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
    }else
    {
        NSLog(@"MasteriesJOSN data is nil");
    }
    if (err) {
        [NSException raise:@"getMasteriesJOSN_EN 错误" format:@"错误是%@",[err localizedDescription]];
        return nil;
    }else
    {
        return dic;
    }
}
+(void)insertMasteryData_ENWithDic:(NSDictionary *)dic
{
    NSManagedObjectContext * subContext = [self createSubContext];
    [subContext performBlock:^{
        NSArray <MasteryData_EN *>* masteriesArr = [self getMasteryData_ENWithId:NULL masteryTree:NULL];
        if (masteriesArr.count > 0) {
            [self updateGGDParentContext];
            [masteriesArr enumerateObjectsUsingBlock:^(MasteryData_EN * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [mainParentContext deleteObject:obj];
            }];
        }
        
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {

            MasteryData_EN * mastery = [[MasteryData_EN alloc] initWithContext:subContext];
            [(NSDictionary *)obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isEqualToString:@"description"])
                {
                    NSMutableString * valueM = [NSMutableString string];
                    [(NSArray *)obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [valueM appendFormat:@"%@<br>", obj];
                    }];
                    if (valueM.length > 0) {
                        [valueM deleteCharactersInRange:NSMakeRange(valueM.length - 4, 4)];
                    }
                    [mastery setValue:valueM forKey:@"descriptions"];
                }else if ([key isEqualToString:@"sanitizedDescription"])
                {
                    NSMutableString * valueM = [NSMutableString string];
                    [(NSArray *)obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [valueM appendFormat:@"%@<br>", obj];
                    }];
                    if (valueM.length > 0) {
                        [valueM deleteCharactersInRange:NSMakeRange(valueM.length - 4, 4)];
                    }
                    [mastery setValue:valueM forKey:key];
                }else if ([key isEqualToString:@"image"])
                {
                    [mastery setValue:[(NSDictionary *)obj objectForKey:@"full"] forKey:@"square"];
                }else
                {
                    [mastery setValue:[NSString stringWithFormat:@"%@", obj] forKey:key];
                }
            }];
            
        }];
        
        NSError * err;
        [self saveContext:subContext withErr:err postNotificationName:@"insertMasteryData_ENWithDicFinished" object:NULL userInfo:NULL];
    }];
}
+(NSArray*)getMasteryData_ENWithId:(nullable NSString *)identifyty masteryTree:(nullable NSString *)tree
{
    NSFetchRequest * request = [MasteryData_EN fetchRequest];
    if (identifyty != nil) {
        NSPredicate * pre = [NSPredicate predicateWithFormat:@"id == %@",identifyty];
        [request setPredicate:pre];
        
    }else if (tree != nil)
    {
        NSPredicate * pre = [NSPredicate predicateWithFormat:@"masteryTree == %@",tree];
        [request setPredicate:pre];
    }
    NSError * err;
    [self updateGGDParentContext];
    NSArray * arr = [mainParentContext executeFetchRequest:request error:&err];
    if (err) {
        [NSException raise:@"getMasteryData_ENWithId 错误" format:@"错误是%@",[err localizedDescription]];
        return nil;
    }else if (arr.count > 0)
    {
        return arr;
        
    }else
    {
        NSLog(@"getMasteryData_ENWithId result count is 0");
        return nil;
    }
}

+(nonnull NSDictionary *)getMasteryDataPicDicImageName_EN:(nonnull NSString *)imageName
{
    NSString * iconNameKey = [NSString stringWithFormat:@"mastery_EN_%@", imageName];
    NSString * iconPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:iconNameKey];
    NSURL * iconURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/6.24.1/img/mastery/%@", imageName]];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:iconNameKey, @"NameKey", iconPath, @"Path", iconURL, @"URL", nil];
    return dic;
}


+(void)updateRuneData_EN
{
    NSString * strURL = [NSString stringWithFormat:@"https://na1.api.riotgames.com/lol/static-data/v3/runes?locale=en_US&tags=all&api_key=%@",[self getAPIKey_EN]];
    NSString * strURLEncod = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [NSException raise:@"updateRuneData_EN 网络通信错误" format:@"错误是%@",[error localizedDescription]];
        }else
        {
            NSError * err;
            NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
            if (err) {
                [NSException raise:@"updateRuneData_EN 错误" format:@"错误是%@",[err localizedDescription]];
                dic = [self getRunesJOSN_EN];
                
            }else if ([dic objectForKey:@"status"])
            {
                NSDictionary * ststus = [dic objectForKey:@"status"];
                NSLog(@"updateRuneData_EN message is %@, ststus_code is %@", [ststus objectForKey:@"message"], [ststus objectForKey:@"status_code"]);
                dic = [self getRunesJOSN_EN];
            }
            if (dic != nil) {
                NSDictionary * resultsDic = [dic objectForKey:@"data"];
                [self insertRuneData_ENWithDic:resultsDic];
            }else
            {
                NSLog(@"runes dic is nil");
            }
        }
    }];
    [dataTask resume];
}

+(NSDictionary *)getRunesJOSN_EN
{
    NSString * strURL = [NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/6.24.1/data/en_US/rune.json"];
    NSString * strURLEcond = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEcond];
    NSData * data = [NSData dataWithContentsOfURL:url];
    NSError * err;
    NSDictionary * dic = nil;
    if (data != nil) {
        dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
    }else
    {
        NSLog(@"RunesJOSN data is nil");
    }
    if (err) {
        [NSException raise:@"getRunesJOSN_EN 错误" format:@"错误是%@",[err localizedDescription]];
        return nil;
    }else
    {
        return dic;
    }
}
+(void)insertRuneData_ENWithDic:(NSDictionary *)dic
{
    NSManagedObjectContext * subContext = [self createSubContext];
    [subContext performBlock:^{
        NSArray <RuneData_EN *>* runesArr = [self getRuneData_ENWithId:NULL tags:NULL tier:NULL type:NULL];
        if (runesArr.count > 0) {
            [self updateGGDParentContext];
            [runesArr enumerateObjectsUsingBlock:^(RuneData_EN * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [mainParentContext deleteObject:obj];
            }];
        }
        
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            RuneData_EN * rune = [[RuneData_EN alloc] initWithContext:subContext];
            NSDictionary * runeDataDic = (NSDictionary *)obj;
            [rune setValue:key forKey:@"id"];
            [runeDataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isEqualToString:@"stats"])
                {
                    NSMutableString * valueM = [NSMutableString string];
                    [(NSDictionary *)obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        [valueM appendFormat:@"%@<br>", key];
                        [valueM appendFormat:@"%@<br>", obj];
                    }];
                    //set Lethality
                    NSString * str = [NSString stringWithFormat:@"%@", [runeDataDic objectForKey:@"description"]];
                    if ([str containsString:@"Lethality"]) {
                        NSString * regex = @"[a-zA-Z]+ *[a-zA-Z]*|[0-9.]+";
                        NSError * err;
                        NSRegularExpression * regular = [NSRegularExpression regularExpressionWithPattern:regex                                      options:NSRegularExpressionCaseInsensitive                                     error:&err];
                        // 对str字符串进行匹配
                        NSArray <NSTextCheckingResult *>*matches = [regular matchesInString:str
                                                            options:0
                                                              range:NSMakeRange(0, str.length)];
                        // 遍历匹配后的每一条记录
                        for (NSTextCheckingResult *match in matches) {
                            NSRange range = [match range];
                            NSString *mStr = [str substringWithRange:range];
                            NSLog(@"%@", mStr);
                        }
                        if (matches.count > 1) {
                            [valueM appendFormat:@"%@<br>", [str substringWithRange:[[matches objectAtIndex:1] range]]];
                            NSLog(@"lethality str is %@", [str substringWithRange:[[matches objectAtIndex:1] range]]);
                            [valueM appendFormat:@"%@<br>", [str substringWithRange:[[matches objectAtIndex:0] range]]];
                            NSLog(@"lethality value is %@", [str substringWithRange:[[matches objectAtIndex:0] range]]);
                        }
                    }
                    if (valueM.length > 0) {
                        [valueM deleteCharactersInRange:NSMakeRange(valueM.length - 4, 4)];
                    }
                    [rune setValue:valueM forKey:key];
                }else if ([key isEqualToString:@"tags"])
                {
                    NSMutableString * valueM = [NSMutableString string];
                    [(NSArray *)obj enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [valueM appendFormat:@"%@<br>", obj];
                    }];
                    if (valueM.length > 0) {
                        [valueM deleteCharactersInRange:NSMakeRange(valueM.length - 4, 4)];
                    }
                    [rune setValue:valueM forKey:key];
                }else if ([key isEqualToString:@"image"])
                {
                    [rune setValue:[(NSDictionary *)obj objectForKey:@"full"] forKey:@"square"];
                }else if ([key isEqualToString:@"description"])
                {
                    [rune setValue:[NSString stringWithFormat:@"%@", obj] forKey:@"descriptions"];
                }else if ([key isEqualToString:@"rune"])
                {
                    [(NSDictionary *)obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([key isEqualToString:@"type"]) {
                            NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:@"mark", @"red", @"glyph", @"blue", @"seal", @"yellow", @"quintessence", @"black", nil];
                            [rune setValue:[dic objectForKey:obj] forKey:key];
                        }else if([key isEqualToString:@"isrune"])
                        {
                            rune.isRune = [NSString stringWithFormat:@"%@", obj];
                        }else
                        {
                            [rune setValue:[NSString stringWithFormat:@"%@", obj] forKey:key];
                        }
                    }];
                }else if ([[NSArray arrayWithObjects:@"colloq",  @"plaintext", nil] containsObject:key])
                {
                    NSLog(@"runeDic key is %@ ", key);
                }else
                {
                    [rune setValue:[NSString stringWithFormat:@"%@", obj] forKey:key];
                }
                if (rune.sanitizedDescription == nil) {
                    rune.sanitizedDescription = rune.descriptions;
                }
            }];
            
        }];
        
        NSError * err;
        [self saveContext:subContext withErr:err postNotificationName:@"insertRuneData_ENWithDicFinished" object:NULL userInfo:NULL];
    }];
}
+(NSArray*)getRuneData_ENWithId:(nullable NSString *)identifyty tags:(nullable NSString *)tag tier:(nullable NSString *)tier type:(nullable NSString *)type
{
    NSFetchRequest * request = [RuneData_EN fetchRequest];
    if (identifyty != nil) {
        NSPredicate * pre = [NSPredicate predicateWithFormat:@"id == %@",identifyty];
        [request setPredicate:pre];
        
    }else
    {
        NSMutableArray * preArrM = [NSMutableArray array];
        if (tag != nil) {
            NSPredicate * pre = [NSPredicate predicateWithFormat:@"tags CONTAINS[cd] %@", tag];
            [preArrM addObject:pre];
        }
        if (tier != nil)
        {
            NSPredicate * pre = [NSPredicate predicateWithFormat:@"tier CONTAINS[cd] %@", tier];
            [preArrM addObject:pre];
        }
        if (type != nil)
        {
            NSPredicate * pre = [NSPredicate predicateWithFormat:@"type CONTAINS[cd] %@", type];
            [preArrM addObject:pre];
        }
        
        if (preArrM.count > 0) {
            NSCompoundPredicate * comPre = [NSCompoundPredicate andPredicateWithSubpredicates:preArrM];
            [request setPredicate:comPre];
        }
        
    }
    NSError * err;
    [self updateGGDParentContext];
    NSSortDescriptor *typeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:NO];
    NSSortDescriptor *tierDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tier" ascending:NO];
    [request setSortDescriptors:@[typeDescriptor, tierDescriptor]];
    NSArray * arr = [mainParentContext executeFetchRequest:request error:&err];
    if (err) {
        [NSException raise:@"getRuneData_ENWithId 错误" format:@"错误是%@",[err localizedDescription]];
        return nil;
    }else if (arr.count > 0)
    {
        return arr;
        
    }else
    {
        NSLog(@"getRuneData_ENWithId result count is 0");
        return nil;
    }
}
+(nonnull NSDictionary *)getRuneDataPicDicImageName_EN:(nonnull NSString *)imageName
{
    NSString * iconNameKey = [NSString stringWithFormat:@"rune_EN_%@", imageName];
    NSString * iconPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:iconNameKey];
    NSString * iconURL = [NSString stringWithFormat:@"http://ddragon.leagueoflegends.com/cdn/6.24.1/img/rune/%@", imageName];
    NSString * strURLEncod = [iconURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strURLEncod];
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:iconNameKey, @"NameKey", iconPath, @"Path", url, @"URL", nil];
    return dic;
}

@end
