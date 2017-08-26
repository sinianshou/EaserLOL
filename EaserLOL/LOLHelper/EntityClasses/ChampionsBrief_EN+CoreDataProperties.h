//
//  ChampionsBrief_EN+CoreDataProperties.h
//  LOLHelper
//
//  Created by Easer Liu on 03/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "ChampionsBrief_EN+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ChampionsBrief_EN (CoreDataProperties)

+ (NSFetchRequest<ChampionsBrief_EN *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, copy) NSString *key;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *tags;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *square;

@end

NS_ASSUME_NONNULL_END
