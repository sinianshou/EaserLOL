//
//  MatchList_CN+CoreDataProperties.h
//  LOLHelper
//
//  Created by Easer Liu on 16/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "MatchList_CN+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MatchList_CN (CoreDataProperties)

+ (NSFetchRequest<MatchList_CN *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *battle_map;
@property (nullable, nonatomic, copy) NSString *battle_time;
@property (nullable, nonatomic, copy) NSString *champion_id;
@property (nullable, nonatomic, copy) NSString *flag;
@property (nullable, nonatomic, copy) NSString *game_id;
@property (nullable, nonatomic, copy) NSString *game_type;
@property (nullable, nonatomic, copy) NSString *win;

@end

NS_ASSUME_NONNULL_END
