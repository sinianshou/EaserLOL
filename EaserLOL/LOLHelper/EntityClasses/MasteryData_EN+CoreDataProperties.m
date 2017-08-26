//
//  MasteryData_EN+CoreDataProperties.m
//  LOLHelper
//
//  Created by Easer Liu on 18/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "MasteryData_EN+CoreDataProperties.h"

@implementation MasteryData_EN (CoreDataProperties)

+ (NSFetchRequest<MasteryData_EN *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MasteryData_EN"];
}

@dynamic descriptions;
@dynamic id;
@dynamic masteryTree;
@dynamic name;
@dynamic prereq;
@dynamic ranks;
@dynamic sanitizedDescription;
@dynamic square;

@end
