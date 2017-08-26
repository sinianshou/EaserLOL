//
//  MatchList_CN+CoreDataProperties.m
//  LOLHelper
//
//  Created by Easer Liu on 16/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "MatchList_CN+CoreDataProperties.h"

@implementation MatchList_CN (CoreDataProperties)

+ (NSFetchRequest<MatchList_CN *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MatchList_CN"];
}

@dynamic battle_map;
@dynamic battle_time;
@dynamic champion_id;
@dynamic flag;
@dynamic game_id;
@dynamic game_type;
@dynamic win;

@end
