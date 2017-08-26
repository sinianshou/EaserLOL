//
//  Team_EN+CoreDataProperties.h
//  LOLHelper
//
//  Created by Easer Liu on 16/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "Team_EN+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Team_EN (CoreDataProperties)

+ (NSFetchRequest<Team_EN *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *ban0;
@property (nullable, nonatomic, copy) NSString *ban1;
@property (nullable, nonatomic, copy) NSString *ban2;
@property (nullable, nonatomic, copy) NSString *ban3;
@property (nullable, nonatomic, copy) NSString *ban4;
@property (nullable, nonatomic, copy) NSString *baronKills;
@property (nullable, nonatomic, copy) NSString *dominionVictoryScore;
@property (nullable, nonatomic, copy) NSString *dragonKills;
@property (nullable, nonatomic, copy) NSString *firstBaron;
@property (nullable, nonatomic, copy) NSString *firstBlood;
@property (nullable, nonatomic, copy) NSString *firstDragon;
@property (nullable, nonatomic, copy) NSString *firstInhibitor;
@property (nullable, nonatomic, copy) NSString *firstRiftHerald;
@property (nullable, nonatomic, copy) NSString *firstTower;
@property (nullable, nonatomic, copy) NSString *gameId;
@property (nullable, nonatomic, copy) NSString *inhibitorKills;
@property (nullable, nonatomic, copy) NSString *riftHeraldKills;
@property (nullable, nonatomic, copy) NSString *teamId;
@property (nullable, nonatomic, copy) NSString *towerKills;
@property (nullable, nonatomic, copy) NSString *vilemawKills;
@property (nullable, nonatomic, copy) NSString *win;
@property (nullable, nonatomic, retain) Match_EN *teamToMatch;
@property (nullable, nonatomic, retain) NSSet<Participant_EN *> *teamToParticipants;

@end

@interface Team_EN (CoreDataGeneratedAccessors)

- (void)addTeamToParticipantsObject:(Participant_EN *)value;
- (void)removeTeamToParticipantsObject:(Participant_EN *)value;
- (void)addTeamToParticipants:(NSSet<Participant_EN *> *)values;
- (void)removeTeamToParticipants:(NSSet<Participant_EN *> *)values;

@end

NS_ASSUME_NONNULL_END
