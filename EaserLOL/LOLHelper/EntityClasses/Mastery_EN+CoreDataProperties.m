//
//  Mastery_EN+CoreDataProperties.m
//  LOLHelper
//
//  Created by Easer Liu on 18/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "Mastery_EN+CoreDataProperties.h"

@implementation Mastery_EN (CoreDataProperties)

+ (NSFetchRequest<Mastery_EN *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Mastery_EN"];
}

@dynamic masteryId;
@dynamic rank;
@dynamic masteryToParticipant;

@end
