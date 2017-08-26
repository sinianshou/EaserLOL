//
//  ChineseAuthors+CoreDataProperties.m
//  LOLHelper
//
//  Created by Easer Liu on 16/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "ChineseAuthors+CoreDataProperties.h"

@implementation ChineseAuthors (CoreDataProperties)

+ (NSFetchRequest<ChineseAuthors *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ChineseAuthors"];
}

@dynamic count;
@dynamic desc;
@dynamic id;
@dynamic img;
@dynamic isex;
@dynamic ivideo;
@dynamic name;
@dynamic usernum;
@dynamic videonum;
@dynamic owns;

@end
