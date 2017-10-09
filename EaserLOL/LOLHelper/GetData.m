//
//  GetData.m
//  LOLHelper
//
//  Created by Easer Liu on 5/27/17.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "GetData.h"
#import <objc/runtime.h>
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
                                                     NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                     NSString * APIKeyspath = [NSString stringWithFormat:@"APIKeys.plist updated，path is %@", APIKeysFilePath];
                                                     NSLog(@"APIKeys Data is %@,path is %@", jsonString, APIKeyspath);
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayNotification" object:APIKeyspath userInfo:NULL];
                                                 }
                                             }];
    [dataTask resume];

}
+(nullable id)getDataWithTag:(NSInteger)tag
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
    NSString *APIKeysFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/APIKeys.plist"];
    NSDictionary * easerAPIKey = [NSDictionary dictionaryWithContentsOfFile:APIKeysFilePath];
    NSDictionary * APIKeys_CN = [easerAPIKey objectForKey:@"APIKeys_CN"];
    NSDictionary * CNVideoAPIKey = [APIKeys_CN objectForKey:@"VideoAPIKey_CN"];
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
               
                                                 if (error) {
                                                     [NSException raise:@"网络通信错误" format:@"错误是%@",[error localizedDescription]];
                                                 }
                                                 [self updateDBBackgroundWithData:data intoEntity:@"ChineseAuthors"];

                                             }];
    [dataTask resume];

}

+(void)UpdateNewestVideosOfChineseLOL
{
    NSString *APIKeysFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/APIKeys.plist"];
    NSDictionary * easerAPIKey = [NSDictionary dictionaryWithContentsOfFile:APIKeysFilePath];
    NSDictionary * APIKeys_CN = [easerAPIKey objectForKey:@"APIKeys_CN"];
    NSDictionary * CNVideoAPIKey = [APIKeys_CN objectForKey:@"VideoAPIKey_CN"];
    int page = 1;
    NSString *stringUrl = [NSString stringWithFormat:@"http://infoapi.games-cube.com/GetNewstVideos?p={%d}",page];
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
                                                 if (error) {
                                                     [NSException raise:@"网络通信错误" format:@"错误是%@",[error localizedDescription]];
                                                 }
                                                 
                                                 [self updateDBBackgroundWithData:data intoEntity:@"ChineseNewestVideos"];
                                                 
                                             }];
    [dataTask resume];
}

+(void)updateDBBackgroundWithData:(NSData*)data intoEntity:(NSString *) entityName
{
    NSMutableDictionary * results = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
    NSArray * subResults = [results valueForKey:@"data"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayNotification" object:[NSString stringWithFormat:@"Wait a second, start to load %@", entityName] userInfo:NULL];
    for (NSDictionary * subResult in subResults) {
        if ([entityName  isEqual: @"ChineseNewestVideos"]) {
            [self insertChineseNewestVideos:entityName WithDic:subResult];
        }else if ([entityName  isEqual: @"ChineseAuthors"])
        {
            if ([[NSThread currentThread] isMainThread]) {
                [self insertChineseAuthors:entityName WithDic:subResult];
            }else
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self insertChineseAuthors:entityName WithDic:subResult];
                }];
            }
            
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayNotification" object:[NSString stringWithFormat:@"Finish uploading %@", entityName] userInfo:NULL];

}

+(void)insertChineseAuthors:(NSString *) entityName WithDic:(NSDictionary *) author
{
    NSManagedObjectContext * context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", [author valueForKey:@"name"]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (!(fetchedObjects.count > 0)) {
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
        
        NSError * err;
        if ([context save:&err]) {
            NSLog(@"写入成功：%@", authorsEntity.name);
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSLog(@"路径是：%@",docPath);
        }else
        {
            [NSException raise:@"写入错误" format:@"错误是%@",[err localizedDescription]];
        }
    }else
    {
        NSLog(@"%@ already exist", [author valueForKey:@"name"]);
    }
    
    

}

+(void)insertChineseNewestVideos:(NSString *) entityName WithDic:(NSDictionary *) video
{
    NSManagedObjectContext * context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", [video valueForKey:@"title"]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (!(fetchedObjects.count > 0)) {
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
    }else
    {
        NSLog(@"%@ already exist", [video valueForKey:@"title"]);
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
+(NSArray <NSString*>*)getPropertyArrFrom:(Class)perClass
{
    ///存储所有的属性名称
    NSMutableArray *allNames = [[NSMutableArray alloc] init];
    ///存储属性的个数
    unsigned int propertyCount = 0;
    ///通过运行时获取当前类的属性
    objc_property_t *propertys = class_copyPropertyList(perClass, &propertyCount);
    
    NSLog(@"class is %@", NSStringFromClass(perClass));
    //把属性放到数组中
    for (int i = 0; i < propertyCount; i ++) {
        ///取出第一个属性
        objc_property_t property = propertys[i];
        
        const char * propertyName = property_getName(property);
        
        [allNames addObject:[NSString stringWithUTF8String:propertyName]];
    }
    NSLog(@"%@ property is %@", NSStringFromClass(perClass), [allNames componentsJoinedByString:@","]);
    ///释放
    free(propertys);
    return [NSArray arrayWithArray:allNames];
}

+(BOOL)saveContext:(NSManagedObjectContext * )subContext withErr:(NSError * _Nullable) err  postNotificationName:(nullable NSString *)name object:(nullable id)object userInfo:(nullable NSDictionary *) userInfo
{
    BOOL success = YES;
    if ([subContext save:&err]) {
        NSLog(@"%@ subContext写入成功", name);
    }else
    {
        [NSException raise:@"subContext写入错误" format:@"%@ 错误是%@", name,[err localizedDescription]];
        success = NO;
    }
    NSManagedObjectContext * temContext = subContext;
    
    while (temContext.parentContext != nil) {
        if ([temContext.parentContext save:&err]) {
            NSLog(@"%@ temContext.parentContext写入成功", name);
        }else
        {
            [NSException raise:@"temContext.parentContext写入错误" format:@"%@ 错误是%@", name,[err localizedDescription]];
            success = NO;
        }
        temContext = temContext.parentContext;
    }
    if ([name isEqualToString:@"insertItem_ENWithDic"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayNotification" object:@"Update Items Finished" userInfo:NULL];
    }
    if (name != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:userInfo];
    }
    return success;
}

@end
