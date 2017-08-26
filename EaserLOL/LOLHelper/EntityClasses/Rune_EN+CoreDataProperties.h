//
//  Rune_EN+CoreDataProperties.h
//  LOLHelper
//
//  Created by Easer Liu on 18/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "Rune_EN+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Rune_EN (CoreDataProperties)

+ (NSFetchRequest<Rune_EN *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *rank;
@property (nullable, nonatomic, copy) NSString *runeId;
@property (nullable, nonatomic, retain) Participant_EN *runeToParticipant;

@end

NS_ASSUME_NONNULL_END
