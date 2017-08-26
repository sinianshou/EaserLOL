//
//  Mastery_EN+CoreDataProperties.h
//  LOLHelper
//
//  Created by Easer Liu on 18/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "Mastery_EN+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Mastery_EN (CoreDataProperties)

+ (NSFetchRequest<Mastery_EN *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *masteryId;
@property (nullable, nonatomic, copy) NSString *rank;
@property (nullable, nonatomic, retain) Participant_EN *masteryToParticipant;

@end

NS_ASSUME_NONNULL_END
