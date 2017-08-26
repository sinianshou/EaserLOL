//
//  RuneData_EN+CoreDataProperties.m
//  LOLHelper
//
//  Created by Easer Liu on 18/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "RuneData_EN+CoreDataProperties.h"

@implementation RuneData_EN (CoreDataProperties)

+ (NSFetchRequest<RuneData_EN *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"RuneData_EN"];
}

@dynamic descriptions;
@dynamic id;
@dynamic isRune;
@dynamic name;
@dynamic sanitizedDescription;
@dynamic square;
@dynamic stats;
@dynamic tags;
@dynamic tier;
@dynamic type;

@end
