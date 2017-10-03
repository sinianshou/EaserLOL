//
//  GetData.h
//  LOLHelper
//
//  Created by Easer Liu on 5/27/17.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#ifndef GetData_h
#define GetData_h



#import "AppDelegate.h"

@interface GetData : NSObject

+(void)updateAccessKeys;
+(id)getDataWithTag:(NSInteger)tag;
+(NSString *)getAPIKey_EN;
+(NSDictionary *)getOpenAPIKey_CN;
+(NSDictionary *)getVideoAPIKey_CN;
+(NSArray *)getResultsInEntity:(NSString*)EntityName;
+(NSString *) convertTimeIntervalStrToString:(NSString *)TimeIntervalStr;
+(NSArray <NSString*>*)getPropertyArrFrom:(Class)perClass;

+(BOOL)saveContext:(NSManagedObjectContext * )subContext withErr:(NSError * _Nullable) err  postNotificationName:(nullable NSString *)name object:(nullable id)object userInfo:(nullable NSDictionary *) userInfo;

@end

#import "GetData+Me.h"
#import "GetData+GetGameData.h"

#endif /* GetData_h */
