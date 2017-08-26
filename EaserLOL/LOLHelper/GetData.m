//
//  GetData.m
//  LOLHelper
//
//  Created by Easer Liu on 5/27/17.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "GetData.h"

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UIKit/UIKit.h"
#import "OptimizeLog.h"
#import "ChineseNewestVideos+CoreDataClass.h"
#import "ChineseAuthors+CoreDataClass.h"
@implementation GetData

+(void)updateAccessKeys
{
    NSString *stringUrl = [NSString stringWithFormat:@"http://lolhelper.nos-eastchina1.126.net/APIKeys.plist"];
    NSString * strUrl = [stringUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strUrl];
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url
                                             completionHandler:^(NSData *data,
                                                                 NSURLResponse *response,
                                                                 NSError *error) {
                                                 if (error) {
                                                     [NSException raise:@"updateAccessKeys网络通信错误" format:@"错误是%@",[error localizedDescription]];
                                                 }else
                                                 {
                                                     NSString *APIKeysFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/APIKeys.plist"];
                                                     [data writeToFile:APIKeysFilePath atomically:YES];
                                                     NSLog(@"APIKeys.plist updated，path is %@", APIKeysFilePath);
                                                 }
                                                 
                                                 
                                                 //                                                 [self performSelectorOnMainThread:@selector(showWeatherOfLocation) withObject:NULL waitUntilDone:YES];
                                                 
                                             }];
    [dataTask resume];
}
+(id)getDataWithTag:(NSInteger)tag
{
    NSMutableArray * datas;
    switch (tag) {
        case 0:
            [self UpdateNewestVideosOfChineseLOL];
            datas = [NSMutableArray arrayWithArray:[self getResultsInEntity:@"ChineseNewestVideos"]];
            break;
        case 1: case 2:
            [self UpdateChineseAuthors];
            datas = [NSMutableArray arrayWithArray:[self getResultsInEntity:@"ChineseAuthors"]];
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
            
        default:
            break;
    }
    return datas;

}

+(void)UpdateChineseAuthors
{
//    NSDictionary * easerAPIKey = [NSDictionary dictionaryWithObject:@"1EE5E-16EA8-7271E-5A95E" forKey:@"DAIWAN-API-TOKEN"];
    
    
    NSDictionary * easerAPIKey = [NSDictionary dictionaryWithContentsOfFile:@"APIKeys.plist"];
    NSDictionary * CNAPIKeys = [easerAPIKey objectForKey:@"CNAPIKeys"];
    NSDictionary * CNVideoAPIKey = [CNAPIKeys objectForKey:@"CNVideoAPIKey"];
    NSString *stringUrl = [NSString stringWithFormat:@"http://infoapi.games-cube.com/GetAuthors"];
    NSString * strUrl = [stringUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strUrl];
    
    NSURLSessionConfiguration * sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfig setHTTPAdditionalHeaders:CNVideoAPIKey];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url
                                             completionHandler:^(NSData *data,
                                                                 NSURLResponse *response,
                                                                 NSError *error) {
                                                 // handle response
                                                 //                                                 freeChampionshipsList = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
                                                 if (error) {
                                                     [NSException raise:@"网络通信错误" format:@"错误是%@",[error localizedDescription]];
                                                 }
                                                 
                                                 [self updateDBBackgroundWithData:data intoEntity:@"ChineseAuthors"];
                                                 
                                                 
                                                 //                                                 [self performSelectorOnMainThread:@selector(showWeatherOfLocation) withObject:NULL waitUntilDone:YES];
                                                 
                                             }];
    [dataTask resume];

}

+(void)UpdateNewestVideosOfChineseLOL
{
//    NSDictionary * easerAPIKey = [NSDictionary dictionaryWithObject:@"1EE5E-16EA8-7271E-5A95E" forKey:@"DAIWAN-API-TOKEN"];
    NSDictionary * easerAPIKey = [NSDictionary dictionaryWithContentsOfFile:@"APIKeys.plist"];
    NSDictionary * CNAPIKeys = [easerAPIKey objectForKey:@"CNAPIKeys"];
    NSDictionary * CNVideoAPIKey = [CNAPIKeys objectForKey:@"CNVideoAPIKey"];
    int page = 1;
    NSString *stringUrl = [NSString stringWithFormat:@"http://infoapi.games-cube.com/GetNewstVideos?p={%d}",page];
    NSString * strUrl = [stringUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:strUrl];
    
    NSURLSessionConfiguration * sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    [sessionConfig setHTTPAdditionalHeaders:CNVideoAPIKey];
    
//    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url
                                             completionHandler:^(NSData *data,
                                                                 NSURLResponse *response,
                                                                 NSError *error) {
                                                 // handle response
                                                 //                                                 freeChampionshipsList = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
                                                 if (error) {
                                                     [NSException raise:@"网络通信错误" format:@"错误是%@",[error localizedDescription]];
                                                 }
                                                 
                                                 [self updateDBBackgroundWithData:data intoEntity:@"ChineseNewestVideos"];
                                                 
                                                 
                                                 //                                                 [self performSelectorOnMainThread:@selector(showWeatherOfLocation) withObject:NULL waitUntilDone:YES];
                                                 
                                             }];
    [dataTask resume];

}

+(void)updateDBBackgroundWithData:(NSData*)data intoEntity:(NSString *) entityName
{
    NSMutableDictionary * results = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
    NSArray * subResults = [results valueForKey:@"data"];
    
    for (NSDictionary * subResult in subResults) {
        if ([entityName  isEqual: @"ChineseNewestVideos"]) {
            [self insertChineseNewestVideos:entityName WithDic:subResult];
        }else if ([entityName  isEqual: @"ChineseAuthors"])
        {
            [self insertChineseAuthors:entityName WithDic:subResult];
        }
    }
    
    
    NSLog(@"数据更新完了");

}

+(void)insertEntity:(NSString *) entityName withDic:(NSDictionary *) dic
{
    NSManagedObjectContext * context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    //设置各value
    NSString * fullSelectorString = [NSString stringWithFormat:@"insert%@WithDic:",entityName];
    SEL priSelector = NSSelectorFromString(fullSelectorString);
    if ([self respondsToSelector:priSelector]) {
        [self performSelector:priSelector withObject:dic];
    }else
    {
        NSLog(@"method %@ does not exist",fullSelectorString);
    }
    
    NSError * err;
    if ([context save:&err]) {
        NSLog(@"写入成功：%@", entityName);
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSLog(@"路径是：%@",docPath);
    }else
    {
        [NSException raise:@"写入错误" format:@"错误是%@",[err localizedDescription]];
    }
}

+(void)insertChineseAuthors:(NSString *) entityName WithDic:(NSDictionary *) author
{
    NSManagedObjectContext * context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    ChineseAuthors * authorsEntity = [NSEntityDescription insertNewObjectForEntityForName:@"ChineseAuthors" inManagedObjectContext:context];
    authorsEntity.id = [author valueForKey:@"id"];
    authorsEntity.name = [author valueForKey:@"name"];
    NSString * imgStr1 =[author valueForKey:@"img"];
    NSString * imgStr2 ;
    if(![imgStr1 containsString:@"http:"] && ![imgStr1 containsString:@"https:"])
    {
        imgStr2 = [NSString stringWithFormat:@"http:%@",imgStr1];
    }else
    {
        imgStr2 = imgStr1;
    }
    authorsEntity.img = imgStr2;
    authorsEntity.isex = [author valueForKey:@"isex"];
    authorsEntity.ivideo = [author valueForKey:@"ivideo"];
    authorsEntity.desc = [author valueForKey:@"desc"];
    authorsEntity.usernum = [author valueForKey:@"usernum"];
    authorsEntity.videonum = [author valueForKey:@"videonum"];
    //        authorsEntity.count = [author valueForKey:@"count"];
    
    NSError * err;
    if ([context save:&err]) {
        NSLog(@"写入成功：%@", authorsEntity.name);
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSLog(@"路径是：%@",docPath);
    }else
    {
        [NSException raise:@"写入错误" format:@"错误是%@",[err localizedDescription]];
    }

}

+(void)insertChineseNewestVideos:(NSString *) entityName WithDic:(NSDictionary *) video
{
    NSManagedObjectContext * context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    ChineseNewestVideos * videosEntity = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    videosEntity.writefilestatus = [video valueForKey:@"writefilestatus"];
    videosEntity.guid = [video valueForKey:@"guid"];
    videosEntity.source = [video valueForKey:@"source"];
    videosEntity.title = [video valueForKey:@"title"];
    videosEntity.url = [video valueForKey:@"url"];
    videosEntity.catalog = [video valueForKey:@"catalog"];
    videosEntity.exestatus = [video valueForKey:@"exestatus"];
    videosEntity.vid = [video valueForKey:@"vid"];
    
    NSString * imgStr1 =[video valueForKey:@"img"];
    NSString * imgStr2 ;
    if(![imgStr1 containsString:@"http:"] && ![imgStr1 containsString:@"https:"])
    {
        imgStr2 = [NSString stringWithFormat:@"http:%@",imgStr1];
    }else
    {
        imgStr2 = imgStr1;
    }
    videosEntity.img = imgStr2;
    
    videosEntity.physicalpath  = [video valueForKey:@"physicalpath"];
    videosEntity.uuid = [video valueForKey:@"uuid"];
    videosEntity.tag = [video valueForKey:@"tag"];
    videosEntity.type = [video valueForKey:@"type"];
    videosEntity.bigimg = [video valueForKey:@"bigimg"];
    videosEntity.virtualpath = [video valueForKey:@"virtualpath"];
    videosEntity.play = [video valueForKey:@"play"];
    videosEntity.comments = [video valueForKey:@"comments"];
    videosEntity.headlines = [video valueForKey:@"headlines"];
    videosEntity.createdate = [video valueForKey:@"createdate"];
    videosEntity.hero = [video valueForKey:@"hero"];
    videosEntity.content = [video valueForKey:@"content"];
    
    
    
    NSError * err;
    if ([context save:&err]) {
        NSLog(@"写入成功：%@", videosEntity.title);
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSLog(@"路径是：%@",docPath);
    }else
    {
        [NSException raise:@"写入错误" format:@"错误是%@",[err localizedDescription]];
    }

}

+(NSArray *)getResultsInEntity:(NSString*)EntityName
{
    NSManagedObjectContext * context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:EntityName];;
    NSEntityDescription * testEntity = [NSEntityDescription entityForName:EntityName inManagedObjectContext:context];
    request.entity = testEntity;
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

+(NSString *)getAPIKey_EN
{
    NSString *APIKeysFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/APIKeys.plist"];
    NSDictionary * easerAPIKey = [NSDictionary dictionaryWithContentsOfFile:APIKeysFilePath];
    NSString * APIKey_EN = [easerAPIKey objectForKey:@"APIKey_EN"];
    
//    if (APIKey_EN == nil) {
//        APIKey_EN = [NSString stringWithFormat:@"RGAPI-abf64225-cc2b-482b-98e1-dda56a6171f3"];
//    }
    return APIKey_EN;
}

+(NSDictionary *)getOpenAPIKey_CN
{
    NSString * APIKeysFilePath = [[NSBundle mainBundle] pathForResource:@"APIKeys" ofType:@"plist"];
    NSDictionary * easerAPIKey = [NSDictionary dictionaryWithContentsOfFile:APIKeysFilePath];
    NSDictionary * CNAPIKeys = [easerAPIKey objectForKey:@"APIKeys_CN"];
    NSDictionary * OpenAPIKey_CN = [CNAPIKeys objectForKey:@"OpenAPIKey_CN"];
    
    if (OpenAPIKey_CN == nil) {
        OpenAPIKey_CN = [NSDictionary dictionaryWithObjectsAndKeys:@"5E4B0-55494-34708-B3444" ,@"DAIWAN-API-TOKEN", nil];
    }
    return OpenAPIKey_CN;
}

+(NSDictionary *)getVideoAPIKey_CN
{
    NSString * APIKeysFilePath = [[NSBundle mainBundle] pathForResource:@"APIKeys" ofType:@"plist"];
    NSDictionary * easerAPIKey = [NSDictionary dictionaryWithContentsOfFile:APIKeysFilePath];
    NSDictionary * CNAPIKeys = [easerAPIKey objectForKey:@"APIKeys_CN"];
    NSDictionary * VideoAPIKey_CN = [CNAPIKeys objectForKey:@"VideoAPIKey_CN"];
    
    if (VideoAPIKey_CN == nil) {
        VideoAPIKey_CN = [NSDictionary dictionaryWithObjectsAndKeys:@"5E4B0-55494-34708-B3444" ,@"DAIWAN-API-TOKEN", nil];
    }
    return VideoAPIKey_CN;
}

+(void)showResultWithTitle:(NSString *) title Message:(NSString *)message
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:alertAction];
//    [self presentViewController:alert animated:YES completion:nil];
}

+(NSString *) convertTimeIntervalStrToString:(NSString *)TimeIntervalStr
{
    NSTimeInterval time=[TimeIntervalStr doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

@end
