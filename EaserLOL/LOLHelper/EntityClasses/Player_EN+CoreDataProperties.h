//
//  Player_EN+CoreDataProperties.h
//  LOLHelper
//
//  Created by Easer Liu on 21/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "Player_EN+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Player_EN (CoreDataProperties)

+ (NSFetchRequest<Player_EN *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *accountId;
@property (nullable, nonatomic, copy) NSString *assistsNum;
@property (nullable, nonatomic, copy) NSString *assistsNum_ability;
@property (nullable, nonatomic, copy) NSString *chaoshenNum;
@property (nullable, nonatomic, copy) NSString *currentAccountId;
@property (nullable, nonatomic, copy) NSString *currentPlatformId;
@property (nullable, nonatomic, copy) NSString *deathsNum;
@property (nullable, nonatomic, copy) NSString *deathsNum_ability;
@property (nullable, nonatomic, copy) NSString *doubleKNum;
@property (nullable, nonatomic, copy) NSString *goldEarnedNum;
@property (nullable, nonatomic, copy) NSString *goldEarnedNum_ability;
@property (nullable, nonatomic, copy) NSString *goodHero01ID;
@property (nullable, nonatomic, copy) NSString *goodHero01totalNum;
@property (nullable, nonatomic, copy) NSString *goodHero01winRate;
@property (nullable, nonatomic, copy) NSString *goodHero02ID;
@property (nullable, nonatomic, copy) NSString *goodHero02totalNum;
@property (nullable, nonatomic, copy) NSString *goodHero02winRate;
@property (nullable, nonatomic, copy) NSString *goodHero03ID;
@property (nullable, nonatomic, copy) NSString *goodHero03totalNum;
@property (nullable, nonatomic, copy) NSString *goodHero03winRate;
@property (nullable, nonatomic, copy) NSString *goodHero04ID;
@property (nullable, nonatomic, copy) NSString *goodHero04totalNum;
@property (nullable, nonatomic, copy) NSString *goodHero04winRate;
@property (nullable, nonatomic, copy) NSString *goodHero05ID;
@property (nullable, nonatomic, copy) NSString *goodHero05totalNum;
@property (nullable, nonatomic, copy) NSString *goodHero05winRate;
@property (nullable, nonatomic, copy) NSString *killsNum;
@property (nullable, nonatomic, copy) NSString *killsNum_ability;
@property (nullable, nonatomic, copy) NSString *largestMultiWins;
@property (nullable, nonatomic, copy) NSString *magicDamageDealtToChampionsNum;
@property (nullable, nonatomic, copy) NSString *magicDamageDealtToChampionsNum_ability;
@property (nullable, nonatomic, copy) NSString *matchHistoryUri;
@property (nullable, nonatomic, copy) NSString *mvpNum;
@property (nullable, nonatomic, copy) NSString *pentaKNum;
@property (nullable, nonatomic, copy) NSString *physicalDamageDealtToChampionsNum;
@property (nullable, nonatomic, copy) NSString *physicalDamageDealtToChampionsNum_ability;
@property (nullable, nonatomic, copy) NSString *platformId;
@property (nullable, nonatomic, copy) NSString *profileIcon;
@property (nullable, nonatomic, copy) NSString *quadraKNum;
@property (nullable, nonatomic, copy) NSString *ranked;
@property (nullable, nonatomic, copy) NSString *summonerId;
@property (nullable, nonatomic, copy) NSString *summonerName;
@property (nullable, nonatomic, copy) NSString *totalDamageTakenNum;
@property (nullable, nonatomic, copy) NSString *totalDamageTakenNum_ability;
@property (nullable, nonatomic, copy) NSString *tripleKNum;
@property (nullable, nonatomic, copy) NSString *wardsNum;
@property (nullable, nonatomic, copy) NSString *winRate;
@property (nullable, nonatomic, retain) NSSet<Participant_EN *> *playToParticipants;

@end

@interface Player_EN (CoreDataGeneratedAccessors)

- (void)addPlayToParticipantsObject:(Participant_EN *)value;
- (void)removePlayToParticipantsObject:(Participant_EN *)value;
- (void)addPlayToParticipants:(NSSet<Participant_EN *> *)values;
- (void)removePlayToParticipants:(NSSet<Participant_EN *> *)values;

@end

NS_ASSUME_NONNULL_END
