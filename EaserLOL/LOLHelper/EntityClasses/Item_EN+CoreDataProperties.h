//
//  Item_EN+CoreDataProperties.h
//  LOLHelper
//
//  Created by Easer Liu on 08/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "Item_EN+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Item_EN (CoreDataProperties)

+ (NSFetchRequest<Item_EN *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *base;
@property (nullable, nonatomic, copy) NSString *colloq;
@property (nullable, nonatomic, copy) NSString *consumed;
@property (nullable, nonatomic, copy) NSString *consumeOnFull;
@property (nullable, nonatomic, copy) NSString *depth;
@property (nullable, nonatomic, copy) NSString *descriptions;
@property (nullable, nonatomic, copy) NSString *hideFromAll;
@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, copy) NSString *inStore;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *plaintext;
@property (nullable, nonatomic, copy) NSString *purchasable;
@property (nullable, nonatomic, copy) NSString *requiredChampion;
@property (nullable, nonatomic, copy) NSString *sanitizedDescription;
@property (nullable, nonatomic, copy) NSString *sell;
@property (nullable, nonatomic, copy) NSString *specialRecipe;
@property (nullable, nonatomic, copy) NSString *square;
@property (nullable, nonatomic, copy) NSString *stacks;
@property (nullable, nonatomic, copy) NSString *stats;
@property (nullable, nonatomic, copy) NSString *tags;
@property (nullable, nonatomic, copy) NSString *total;
@property (nullable, nonatomic, copy) NSString *maps;
@property (nullable, nonatomic, copy) NSString *into;
@property (nullable, nonatomic, copy) NSString *effect;
@property (nullable, nonatomic, copy) NSString *from;

@end

NS_ASSUME_NONNULL_END
