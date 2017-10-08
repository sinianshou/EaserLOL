//
//  GoldEventsModel.m
//  Test01
//
//  Created by Easer Liu on 20/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "GoldEventsModel.h"
#import <UIKit/UIKit.h>

@implementation GoldEventsModel

-(instancetype)init
{
    self = [super init];
    
    self.goldDic = [NSMutableDictionary dictionary];
    self.killerArrM = [NSMutableArray array];
    self.victimArrM = [NSMutableArray array];
    
    return self;
}

+(NSMutableDictionary *)createModelsDicWithData:(NSData *)data
{
    NSDictionary * dic02 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:NULL];
    NSArray <NSDictionary *> * dic0201 = [dic02 objectForKey:@"frames"];
    
    NSMutableDictionary * dicM = [NSMutableDictionary dictionary];
    
    for (int i = 1; i < 13; i++) {
        GoldEventsModel * goldEventsModel = [[GoldEventsModel alloc] init];
        goldEventsModel.participantId = [NSString stringWithFormat:@"%d", i];
        [dicM setObject:goldEventsModel forKey:goldEventsModel.participantId];
    }
    
    [dic0201 enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary * dic020124 = obj;
        NSString * timeStampStr = [NSString stringWithFormat:@"%@", [dic020124 objectForKey:@"timestamp"]];
        NSDictionary * pars = [dic020124 objectForKey:@"participantFrames"];
        int __block team100Gold = 0;
        int __block team200Gold = 0;
        [pars enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSDictionary * par = ((NSDictionary *)obj);
            GoldEventsModel * subGoldEventsModel = [dicM objectForKey:key];
            [subGoldEventsModel.goldDic setObject:[NSString stringWithFormat:@"%@", [par objectForKey:@"totalGold"]] forKey:timeStampStr];
            if (((NSString *)key).intValue < 6) {
                team100Gold += [NSString stringWithFormat:@"%@", [par objectForKey:@"totalGold"]].intValue;
            }else
            {
                team200Gold += [NSString stringWithFormat:@"%@", [par objectForKey:@"totalGold"]].intValue;
            }
        }];
        GoldEventsModel * team100GoldEventsModel = [dicM objectForKey:@"11"];
        [team100GoldEventsModel.goldDic setObject:[NSString stringWithFormat:@"%d", team100Gold] forKey:timeStampStr];
        GoldEventsModel * team200GoldEventsModel = [dicM objectForKey:@"12"];
        [team200GoldEventsModel.goldDic setObject:[NSString stringWithFormat:@"%d", team200Gold] forKey:timeStampStr];
        
        
        NSArray <NSDictionary*>* eventsArr = [dic020124 objectForKey:@"events"];
        [eventsArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([((NSString *)[obj objectForKey:@"type"]) isEqualToString:@"CHAMPION_KILL"]) {
                NSString * strX = [NSString stringWithFormat:@"%@", [((NSDictionary *)[obj objectForKey:@"position"]) objectForKey:@"x"]];
                NSString * strY = [NSString stringWithFormat:@"%@", [((NSDictionary *)[obj objectForKey:@"position"]) objectForKey:@"y"]];
                NSValue * pointValue = [NSValue valueWithCGPoint:CGPointMake(strX.floatValue, strY.floatValue)];
                GoldEventsModel * killerGoldEventsModel = [dicM objectForKey:[NSString stringWithFormat:@"%@", [obj objectForKey:@"killerId"]]];
                [killerGoldEventsModel.killerArrM addObject:pointValue];
                GoldEventsModel * victimGoldEventsModel = [dicM objectForKey:[NSString stringWithFormat:@"%@", [obj objectForKey:@"victimId"]]];
                [victimGoldEventsModel.victimArrM addObject:pointValue];
            }
        }];
    }];
    
    return dicM;
}

+(BOOL)allowsReverseTransformation
{
    return YES;
}
+(Class)transformedValueClass
{
    return [NSData class];
}
-(id)transformedValue:(id)value
{
    NSMutableDictionary * dicM = [GoldEventsModel createModelsDicWithData:(NSData *)value];
    
    NSData * dataFromDicM =  [NSKeyedArchiver archivedDataWithRootObject:dicM];
    return dataFromDicM;
}
-(id)reverseTransformedValue:(id)value
{
    NSData *data = (NSData *)value;
    NSMutableDictionary *dicM =[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return dicM;
}

//每个属性变量分别转码
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.goldDic forKey:@"goldDic"];
    [aCoder encodeObject:self.killerArrM forKey:@"killerArrM"];
    [aCoder encodeObject:self.victimArrM forKey:@"victimArrM"];
    [aCoder encodeObject:self.participantId forKey:@"participantId"];
}

//分别把每个属性变量根据关键字进行逆转码，最后返回一个Student类的对象
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.goldDic = [aDecoder decodeObjectForKey:@"goldDic"];
        self.killerArrM= [aDecoder decodeObjectForKey:@"killerArrM"];
        self.victimArrM= [aDecoder decodeObjectForKey:@"victimArrM"];
        self.participantId= [aDecoder decodeObjectForKey:@"participantId"];
    }
    return self;
}
@end
