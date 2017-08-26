//
//  MatchList_EN+CoreDataProperties.m
//  LOLHelper
//
//  Created by Easer Liu on 19/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "MatchList_EN+CoreDataProperties.h"

@implementation MatchList_EN (CoreDataProperties)

+ (NSFetchRequest<MatchList_EN *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MatchList_EN"];
}

@dynamic accountId;
@dynamic assistMost;
@dynamic assists;
@dynamic champion;
@dynamic chaoshen;
@dynamic damageMost;
@dynamic deaths;
@dynamic doubleKills;
@dynamic endIndex;
@dynamic gameCreation;
@dynamic gameId;
@dynamic gameMode;
@dynamic gameType;
@dynamic killMost;
@dynamic kills;
@dynamic lane;
@dynamic minionMost;
@dynamic moneyMost;
@dynamic mvp;
@dynamic pentaKills;
@dynamic platformId;
@dynamic quadraKills;
@dynamic queue;
@dynamic role;
@dynamic season;
@dynamic startIndex;
@dynamic summonerName;
@dynamic takenMost;
@dynamic timestamp;
@dynamic totalGames;
@dynamic tripleKills;
@dynamic turretMost;
@dynamic win;
@dynamic listToMatch;

@end
