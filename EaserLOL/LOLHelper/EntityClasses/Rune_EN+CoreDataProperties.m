//
//  Rune_EN+CoreDataProperties.m
//  LOLHelper
//
//  Created by Easer Liu on 18/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "Rune_EN+CoreDataProperties.h"

@implementation Rune_EN (CoreDataProperties)

+ (NSFetchRequest<Rune_EN *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Rune_EN"];
}

@dynamic rank;
@dynamic runeId;
@dynamic runeToParticipant;

@end
