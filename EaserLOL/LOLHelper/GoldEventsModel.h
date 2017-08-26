//
//  GoldEventsModel.h
//  Test01
//
//  Created by Easer Liu on 20/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoldEventsModel : NSValueTransformer<NSCoding>

@property (strong, nonatomic) NSMutableDictionary * goldDic;
@property (strong, nonatomic) NSMutableArray * killerArrM;
@property (strong, nonatomic) NSMutableArray * victimArrM;
@property (strong, nonatomic) NSString * participantId;

+(NSMutableDictionary *)createModelsDicWithData:(NSData *)data;
@end
