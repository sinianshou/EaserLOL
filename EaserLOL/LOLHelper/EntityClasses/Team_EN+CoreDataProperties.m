//
//  Team_EN+CoreDataProperties.m
//  LOLHelper
//
//  Created by Easer Liu on 16/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "Team_EN+CoreDataProperties.h"

@implementation Team_EN (CoreDataProperties)

+ (NSFetchRequest<Team_EN *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Team_EN"];
}

@dynamic ban0;
@dynamic ban1;
@dynamic ban2;
@dynamic ban3;
@dynamic ban4;
@dynamic baronKills;
@dynamic dominionVictoryScore;
@dynamic dragonKills;
@dynamic firstBaron;
@dynamic firstBlood;
@dynamic firstDragon;
@dynamic firstInhibitor;
@dynamic firstRiftHerald;
@dynamic firstTower;
@dynamic gameId;
@dynamic inhibitorKills;
@dynamic riftHeraldKills;
@dynamic teamId;
@dynamic towerKills;
@dynamic vilemawKills;
@dynamic win;
@dynamic teamToMatch;
@dynamic teamToParticipants;

@end
