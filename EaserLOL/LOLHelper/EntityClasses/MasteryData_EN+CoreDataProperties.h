//
//  MasteryData_EN+CoreDataProperties.h
//  LOLHelper
//
//  Created by Easer Liu on 18/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "MasteryData_EN+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MasteryData_EN (CoreDataProperties)

+ (NSFetchRequest<MasteryData_EN *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *descriptions;
@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, copy) NSString *masteryTree;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *prereq;
@property (nullable, nonatomic, copy) NSString *ranks;
@property (nullable, nonatomic, copy) NSString *sanitizedDescription;
@property (nullable, nonatomic, copy) NSString *square;

@end

NS_ASSUME_NONNULL_END
