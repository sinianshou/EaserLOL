//
//  ChampionsBrief_EN+CoreDataProperties.m
//  LOLHelper
//
//  Created by Easer Liu on 03/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "ChampionsBrief_EN+CoreDataProperties.h"

@implementation ChampionsBrief_EN (CoreDataProperties)

+ (NSFetchRequest<ChampionsBrief_EN *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ChampionsBrief_EN"];
}

@dynamic id;
@dynamic key;
@dynamic name;
@dynamic tags;
@dynamic title;
@dynamic square;

@end
