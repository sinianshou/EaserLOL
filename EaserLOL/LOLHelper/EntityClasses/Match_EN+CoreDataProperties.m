//
//  Match_EN+CoreDataProperties.m
//  LOLHelper
//
//  Created by Easer Liu on 24/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "Match_EN+CoreDataProperties.h"

@implementation Match_EN (CoreDataProperties)

+ (NSFetchRequest<Match_EN *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Match_EN"];
}

@dynamic gameCreation;
@dynamic gameDuration;
@dynamic gameId;
@dynamic gameMode;
@dynamic gameType;
@dynamic gameVersion;
@dynamic mapId;
@dynamic platformId;
@dynamic queueId;
@dynamic seasonId;
@dynamic goldEventsDicM;
@dynamic matchToLists;
@dynamic matchToTeams;

@end
