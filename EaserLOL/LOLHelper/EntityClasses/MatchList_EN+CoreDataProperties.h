//
//  MatchList_EN+CoreDataProperties.h
//  LOLHelper
//
//  Created by Easer Liu on 19/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "MatchList_EN+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MatchList_EN (CoreDataProperties)

+ (NSFetchRequest<MatchList_EN *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *accountId;
@property (nullable, nonatomic, copy) NSString *assistMost;
@property (nullable, nonatomic, copy) NSString *assists;
@property (nullable, nonatomic, copy) NSString *champion;
@property (nullable, nonatomic, copy) NSString *chaoshen;
@property (nullable, nonatomic, copy) NSString *damageMost;
@property (nullable, nonatomic, copy) NSString *deaths;
@property (nullable, nonatomic, copy) NSString *doubleKills;
@property (nullable, nonatomic, copy) NSString *endIndex;
@property (nullable, nonatomic, copy) NSString *gameCreation;
@property (nullable, nonatomic, copy) NSString *gameId;
@property (nullable, nonatomic, copy) NSString *gameMode;
@property (nullable, nonatomic, copy) NSString *gameType;
@property (nullable, nonatomic, copy) NSString *killMost;
@property (nullable, nonatomic, copy) NSString *kills;
@property (nullable, nonatomic, copy) NSString *lane;
@property (nullable, nonatomic, copy) NSString *minionMost;
@property (nullable, nonatomic, copy) NSString *moneyMost;
@property (nullable, nonatomic, copy) NSString *mvp;
@property (nullable, nonatomic, copy) NSString *pentaKills;
@property (nullable, nonatomic, copy) NSString *platformId;
@property (nullable, nonatomic, copy) NSString *quadraKills;
@property (nullable, nonatomic, copy) NSString *queue;
@property (nullable, nonatomic, copy) NSString *role;
@property (nullable, nonatomic, copy) NSString *season;
@property (nullable, nonatomic, copy) NSString *startIndex;
@property (nullable, nonatomic, copy) NSString *summonerName;
@property (nullable, nonatomic, copy) NSString *takenMost;
@property (nullable, nonatomic, copy) NSString *timestamp;
@property (nullable, nonatomic, copy) NSString *totalGames;
@property (nullable, nonatomic, copy) NSString *tripleKills;
@property (nullable, nonatomic, copy) NSString *turretMost;
@property (nullable, nonatomic, copy) NSString *win;
@property (nullable, nonatomic, retain) Match_EN *listToMatch;

@end

NS_ASSUME_NONNULL_END
