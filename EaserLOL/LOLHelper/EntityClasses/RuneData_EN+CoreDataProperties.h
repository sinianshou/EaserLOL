//
//  RuneData_EN+CoreDataProperties.h
//  LOLHelper
//
//  Created by Easer Liu on 18/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "RuneData_EN+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RuneData_EN (CoreDataProperties)

+ (NSFetchRequest<RuneData_EN *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *descriptions;
@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, copy) NSString *isRune;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *sanitizedDescription;
@property (nullable, nonatomic, copy) NSString *square;
@property (nullable, nonatomic, copy) NSString *stats;
@property (nullable, nonatomic, copy) NSString *tags;
@property (nullable, nonatomic, copy) NSString *tier;
@property (nullable, nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
