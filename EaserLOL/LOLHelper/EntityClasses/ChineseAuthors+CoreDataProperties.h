//
//  ChineseAuthors+CoreDataProperties.h
//  LOLHelper
//
//  Created by Easer Liu on 16/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "ChineseAuthors+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ChineseAuthors (CoreDataProperties)

+ (NSFetchRequest<ChineseAuthors *> *)fetchRequest;

@property (nonatomic) float count;
@property (nullable, nonatomic, copy) NSString *desc;
@property (nullable, nonatomic, copy) NSString *id;
@property (nullable, nonatomic, copy) NSString *img;
@property (nullable, nonatomic, copy) NSString *isex;
@property (nullable, nonatomic, copy) NSString *ivideo;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *usernum;
@property (nullable, nonatomic, copy) NSString *videonum;
@property (nullable, nonatomic, retain) ChineseNewestVideos *owns;

@end

NS_ASSUME_NONNULL_END
