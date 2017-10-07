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
+(nullable id)getDataWithTag:(NSInteger)tag;
+(nullable NSString *)getAPIKey_EN;
+(nullable NSDictionary *)getOpenAPIKey_CN;
+(nullable NSDictionary *)getVideoAPIKey_CN;
+(nullable NSArray *)getResultsInEntity:(nonnull NSString*)EntityName;
+(nullable NSString *) convertTimeIntervalStrToString:(nonnull NSString *)TimeIntervalStr;
+(nullable NSArray <NSString*>*)getPropertyArrFrom:(nonnull Class)perClass;

+(BOOL)saveContext:(nonnull NSManagedObjectContext * )subContext withErr:(NSError * _Nullable) err  postNotificationName:(nullable NSString *)name object:(nullable id)object userInfo:(nullable NSDictionary *) userInfo;

@end

#import "GetData+Me.h"
#import "GetData+GetGameData.h"

#endif /* GetData_h */
