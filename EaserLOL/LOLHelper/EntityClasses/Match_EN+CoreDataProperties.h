//
//  Match_EN+CoreDataProperties.h
//  LOLHelper
//
//  Created by Easer Liu on 24/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "Match_EN+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Match_EN (CoreDataProperties)

+ (NSFetchRequest<Match_EN *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *gameCreation;
@property (nullable, nonatomic, copy) NSString *gameDuration;
@property (nullable, nonatomic, copy) NSString *gameId;
@property (nullable, nonatomic, copy) NSString *gameMode;
@property (nullable, nonatomic, copy) NSString *gameType;
@property (nullable, nonatomic, copy) NSString *gameVersion;
@property (nullable, nonatomic, copy) NSString *mapId;
@property (nullable, nonatomic, copy) NSString *platformId;
@property (nullable, nonatomic, copy) NSString *queueId;
@property (nullable, nonatomic, copy) NSString *seasonId;
@property (nullable, nonatomic, retain) NSObject *goldEventsDicM;
@property (nullable, nonatomic, retain) NSSet<MatchList_EN *> *matchToLists;
@property (nullable, nonatomic, retain) NSSet<Team_EN *> *matchToTeams;

@end

@interface Match_EN (CoreDataGeneratedAccessors)

- (void)addMatchToListsObject:(MatchList_EN *)value;
- (void)removeMatchToListsObject:(MatchList_EN *)value;
- (void)addMatchToLists:(NSSet<MatchList_EN *> *)values;
- (void)removeMatchToLists:(NSSet<MatchList_EN *> *)values;

- (void)addMatchToTeamsObject:(Team_EN *)value;
- (void)removeMatchToTeamsObject:(Team_EN *)value;
- (void)addMatchToTeams:(NSSet<Team_EN *> *)values;
- (void)removeMatchToTeams:(NSSet<Team_EN *> *)values;

@end

NS_ASSUME_NONNULL_END
