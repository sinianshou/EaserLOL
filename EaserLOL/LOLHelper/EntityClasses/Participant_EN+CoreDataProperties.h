//
//  Participant_EN+CoreDataProperties.h
//  LOLHelper
//
//  Created by Easer Liu on 08/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "Participant_EN+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Participant_EN (CoreDataProperties)

+ (NSFetchRequest<Participant_EN *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *accountId;
@property (nullable, nonatomic, copy) NSString *assistMost;
@property (nullable, nonatomic, copy) NSString *assists;
@property (nullable, nonatomic, copy) NSString *championId;
@property (nullable, nonatomic, copy) NSString *champLevel;
@property (nullable, nonatomic, copy) NSString *chaoshen;
@property (nullable, nonatomic, copy) NSString *combatPlayerScore;
@property (nullable, nonatomic, copy) NSString *damageDealtToObjectives;
@property (nullable, nonatomic, copy) NSString *damageDealtToTurrets;
@property (nullable, nonatomic, copy) NSString *damageMost;
@property (nullable, nonatomic, copy) NSString *damageSelfMitigated;
@property (nullable, nonatomic, copy) NSString *deaths;
@property (nullable, nonatomic, copy) NSString *doubleKills;
@property (nullable, nonatomic, copy) NSString *firstBloodAssist;
@property (nullable, nonatomic, copy) NSString *firstBloodKill;
@property (nullable, nonatomic, copy) NSString *firstInhibitorAssist;
@property (nullable, nonatomic, copy) NSString *firstInhibitorKill;
@property (nullable, nonatomic, copy) NSString *firstTowerAssist;
@property (nullable, nonatomic, copy) NSString *firstTowerKill;
@property (nullable, nonatomic, copy) NSString *gameId;
@property (nullable, nonatomic, copy) NSString *goldEarned;
@property (nullable, nonatomic, copy) NSString *goldSpent;
@property (nullable, nonatomic, copy) NSString *highestAchievedSeasonTier;
@property (nullable, nonatomic, copy) NSString *inhibitorKills;
@property (nullable, nonatomic, copy) NSString *item0;
@property (nullable, nonatomic, copy) NSString *item1;
@property (nullable, nonatomic, copy) NSString *item2;
@property (nullable, nonatomic, copy) NSString *item3;
@property (nullable, nonatomic, copy) NSString *item4;
@property (nullable, nonatomic, copy) NSString *item5;
@property (nullable, nonatomic, copy) NSString *item6;
@property (nullable, nonatomic, copy) NSString *kda;
@property (nullable, nonatomic, copy) NSString *killingSprees;
@property (nullable, nonatomic, copy) NSString *killMost;
@property (nullable, nonatomic, copy) NSString *kills;
@property (nullable, nonatomic, copy) NSString *largestCriticalStrike;
@property (nullable, nonatomic, copy) NSString *largestKillingSpree;
@property (nullable, nonatomic, copy) NSString *largestMultiKill;
@property (nullable, nonatomic, copy) NSString *longestTimeSpentLiving;
@property (nullable, nonatomic, copy) NSString *magicalDamageTaken;
@property (nullable, nonatomic, copy) NSString *magicDamageDealt;
@property (nullable, nonatomic, copy) NSString *magicDamageDealtToChampions;
@property (nullable, nonatomic, copy) NSString *minionMost;
@property (nullable, nonatomic, copy) NSString *moneyMost;
@property (nullable, nonatomic, copy) NSString *mvp;
@property (nullable, nonatomic, copy) NSString *neutralMinionsKilled;
@property (nullable, nonatomic, copy) NSString *neutralMinionsKilledEnemyJungle;
@property (nullable, nonatomic, copy) NSString *neutralMinionsKilledTeamJungle;
@property (nullable, nonatomic, copy) NSString *objectivePlayerScore;
@property (nullable, nonatomic, copy) NSString *participantId;
@property (nullable, nonatomic, copy) NSString *pentaKills;
@property (nullable, nonatomic, copy) NSString *physicalDamageDealt;
@property (nullable, nonatomic, copy) NSString *physicalDamageDealtToChampions;
@property (nullable, nonatomic, copy) NSString *physicalDamageTaken;
@property (nullable, nonatomic, copy) NSString *quadraKills;
@property (nullable, nonatomic, copy) NSString *sightWardsBoughtInGame;
@property (nullable, nonatomic, copy) NSString *spell1Id;
@property (nullable, nonatomic, copy) NSString *spell2Id;
@property (nullable, nonatomic, copy) NSString *summonerName;
@property (nullable, nonatomic, copy) NSString *takenMost;
@property (nullable, nonatomic, copy) NSString *teamId;
@property (nullable, nonatomic, copy) NSString *timeCCingOthers;
@property (nullable, nonatomic, copy) NSString *totalDamageDealt;
@property (nullable, nonatomic, copy) NSString *totalDamageDealtToChampions;
@property (nullable, nonatomic, copy) NSString *totalDamageTaken;
@property (nullable, nonatomic, copy) NSString *totalHeal;
@property (nullable, nonatomic, copy) NSString *totalMinionsKilled;
@property (nullable, nonatomic, copy) NSString *totalPlayerScore;
@property (nullable, nonatomic, copy) NSString *totalScoreRank;
@property (nullable, nonatomic, copy) NSString *totalTimeCrowdControlDealt;
@property (nullable, nonatomic, copy) NSString *totalUnitsHealed;
@property (nullable, nonatomic, copy) NSString *tripleKills;
@property (nullable, nonatomic, copy) NSString *trueDamageDealt;
@property (nullable, nonatomic, copy) NSString *trueDamageDealtToChampions;
@property (nullable, nonatomic, copy) NSString *trueDamageTaken;
@property (nullable, nonatomic, copy) NSString *turretKills;
@property (nullable, nonatomic, copy) NSString *turretMost;
@property (nullable, nonatomic, copy) NSString *unrealKills;
@property (nullable, nonatomic, copy) NSString *visionScore;
@property (nullable, nonatomic, copy) NSString *visionWardsBoughtInGame;
@property (nullable, nonatomic, copy) NSString *wardsKilled;
@property (nullable, nonatomic, copy) NSString *wardsPlaced;
@property (nullable, nonatomic, copy) NSString *win;
@property (nullable, nonatomic, copy) NSString *playerScore8;
@property (nullable, nonatomic, copy) NSString *playerScore5;
@property (nullable, nonatomic, copy) NSString *playerScore9;
@property (nullable, nonatomic, copy) NSString *playerScore2;
@property (nullable, nonatomic, copy) NSString *playerScore6;
@property (nullable, nonatomic, copy) NSString *playerScore3;
@property (nullable, nonatomic, copy) NSString *playerScore7;
@property (nullable, nonatomic, copy) NSString *playerScore0;
@property (nullable, nonatomic, copy) NSString *playerScore4;
@property (nullable, nonatomic, copy) NSString *playerScore1;
@property (nullable, nonatomic, retain) NSSet<Mastery_EN *> *participantToMasteries;
@property (nullable, nonatomic, retain) Player_EN *participantToPlay;
@property (nullable, nonatomic, retain) NSSet<Rune_EN *> *participantToRunes;
@property (nullable, nonatomic, retain) Team_EN *participantToTeam;

@end

@interface Participant_EN (CoreDataGeneratedAccessors)

- (void)addParticipantToMasteriesObject:(Mastery_EN *)value;
- (void)removeParticipantToMasteriesObject:(Mastery_EN *)value;
- (void)addParticipantToMasteries:(NSSet<Mastery_EN *> *)values;
- (void)removeParticipantToMasteries:(NSSet<Mastery_EN *> *)values;

- (void)addParticipantToRunesObject:(Rune_EN *)value;
- (void)removeParticipantToRunesObject:(Rune_EN *)value;
- (void)addParticipantToRunes:(NSSet<Rune_EN *> *)values;
- (void)removeParticipantToRunes:(NSSet<Rune_EN *> *)values;

@end

NS_ASSUME_NONNULL_END
