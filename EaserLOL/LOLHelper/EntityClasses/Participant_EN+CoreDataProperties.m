//
//  Participant_EN+CoreDataProperties.m
//  LOLHelper
//
//  Created by Easer Liu on 08/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "Participant_EN+CoreDataProperties.h"

@implementation Participant_EN (CoreDataProperties)

+ (NSFetchRequest<Participant_EN *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Participant_EN"];
}

@dynamic accountId;
@dynamic assistMost;
@dynamic assists;
@dynamic championId;
@dynamic champLevel;
@dynamic chaoshen;
@dynamic combatPlayerScore;
@dynamic damageDealtToObjectives;
@dynamic damageDealtToTurrets;
@dynamic damageMost;
@dynamic damageSelfMitigated;
@dynamic deaths;
@dynamic doubleKills;
@dynamic firstBloodAssist;
@dynamic firstBloodKill;
@dynamic firstInhibitorAssist;
@dynamic firstInhibitorKill;
@dynamic firstTowerAssist;
@dynamic firstTowerKill;
@dynamic gameId;
@dynamic goldEarned;
@dynamic goldSpent;
@dynamic highestAchievedSeasonTier;
@dynamic inhibitorKills;
@dynamic item0;
@dynamic item1;
@dynamic item2;
@dynamic item3;
@dynamic item4;
@dynamic item5;
@dynamic item6;
@dynamic kda;
@dynamic killingSprees;
@dynamic killMost;
@dynamic kills;
@dynamic largestCriticalStrike;
@dynamic largestKillingSpree;
@dynamic largestMultiKill;
@dynamic longestTimeSpentLiving;
@dynamic magicalDamageTaken;
@dynamic magicDamageDealt;
@dynamic magicDamageDealtToChampions;
@dynamic minionMost;
@dynamic moneyMost;
@dynamic mvp;
@dynamic neutralMinionsKilled;
@dynamic neutralMinionsKilledEnemyJungle;
@dynamic neutralMinionsKilledTeamJungle;
@dynamic objectivePlayerScore;
@dynamic participantId;
@dynamic pentaKills;
@dynamic physicalDamageDealt;
@dynamic physicalDamageDealtToChampions;
@dynamic physicalDamageTaken;
@dynamic quadraKills;
@dynamic sightWardsBoughtInGame;
@dynamic spell1Id;
@dynamic spell2Id;
@dynamic summonerName;
@dynamic takenMost;
@dynamic teamId;
@dynamic timeCCingOthers;
@dynamic totalDamageDealt;
@dynamic totalDamageDealtToChampions;
@dynamic totalDamageTaken;
@dynamic totalHeal;
@dynamic totalMinionsKilled;
@dynamic totalPlayerScore;
@dynamic totalScoreRank;
@dynamic totalTimeCrowdControlDealt;
@dynamic totalUnitsHealed;
@dynamic tripleKills;
@dynamic trueDamageDealt;
@dynamic trueDamageDealtToChampions;
@dynamic trueDamageTaken;
@dynamic turretKills;
@dynamic turretMost;
@dynamic unrealKills;
@dynamic visionScore;
@dynamic visionWardsBoughtInGame;
@dynamic wardsKilled;
@dynamic wardsPlaced;
@dynamic win;
@dynamic playerScore8;
@dynamic playerScore5;
@dynamic playerScore9;
@dynamic playerScore2;
@dynamic playerScore6;
@dynamic playerScore3;
@dynamic playerScore7;
@dynamic playerScore0;
@dynamic playerScore4;
@dynamic playerScore1;
@dynamic participantToMasteries;
@dynamic participantToPlay;
@dynamic participantToRunes;
@dynamic participantToTeam;

@end
