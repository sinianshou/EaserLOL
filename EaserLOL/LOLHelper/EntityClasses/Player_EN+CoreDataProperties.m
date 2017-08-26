//
//  Player_EN+CoreDataProperties.m
//  LOLHelper
//
//  Created by Easer Liu on 21/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "Player_EN+CoreDataProperties.h"

@implementation Player_EN (CoreDataProperties)

+ (NSFetchRequest<Player_EN *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Player_EN"];
}

@dynamic accountId;
@dynamic assistsNum;
@dynamic assistsNum_ability;
@dynamic chaoshenNum;
@dynamic currentAccountId;
@dynamic currentPlatformId;
@dynamic deathsNum;
@dynamic deathsNum_ability;
@dynamic doubleKNum;
@dynamic goldEarnedNum;
@dynamic goldEarnedNum_ability;
@dynamic goodHero01ID;
@dynamic goodHero01totalNum;
@dynamic goodHero01winRate;
@dynamic goodHero02ID;
@dynamic goodHero02totalNum;
@dynamic goodHero02winRate;
@dynamic goodHero03ID;
@dynamic goodHero03totalNum;
@dynamic goodHero03winRate;
@dynamic goodHero04ID;
@dynamic goodHero04totalNum;
@dynamic goodHero04winRate;
@dynamic goodHero05ID;
@dynamic goodHero05totalNum;
@dynamic goodHero05winRate;
@dynamic killsNum;
@dynamic killsNum_ability;
@dynamic largestMultiWins;
@dynamic magicDamageDealtToChampionsNum;
@dynamic magicDamageDealtToChampionsNum_ability;
@dynamic matchHistoryUri;
@dynamic mvpNum;
@dynamic pentaKNum;
@dynamic physicalDamageDealtToChampionsNum;
@dynamic physicalDamageDealtToChampionsNum_ability;
@dynamic platformId;
@dynamic profileIcon;
@dynamic quadraKNum;
@dynamic ranked;
@dynamic summonerId;
@dynamic summonerName;
@dynamic totalDamageTakenNum;
@dynamic totalDamageTakenNum_ability;
@dynamic tripleKNum;
@dynamic wardsNum;
@dynamic winRate;
@dynamic playToParticipants;

@end
