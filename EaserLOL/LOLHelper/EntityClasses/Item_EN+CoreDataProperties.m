//
//  Item_EN+CoreDataProperties.m
//  LOLHelper
//
//  Created by Easer Liu on 08/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "Item_EN+CoreDataProperties.h"

@implementation Item_EN (CoreDataProperties)

+ (NSFetchRequest<Item_EN *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Item_EN"];
}

@dynamic base;
@dynamic colloq;
@dynamic consumed;
@dynamic consumeOnFull;
@dynamic depth;
@dynamic descriptions;
@dynamic hideFromAll;
@dynamic id;
@dynamic inStore;
@dynamic name;
@dynamic plaintext;
@dynamic purchasable;
@dynamic requiredChampion;
@dynamic sanitizedDescription;
@dynamic sell;
@dynamic specialRecipe;
@dynamic square;
@dynamic stacks;
@dynamic stats;
@dynamic tags;
@dynamic total;
@dynamic maps;
@dynamic into;
@dynamic effect;
@dynamic from;

@end
