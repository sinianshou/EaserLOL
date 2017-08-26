//
//  ChineseNewestVideos+CoreDataProperties.h
//  LOLHelper
//
//  Created by Easer Liu on 16/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "ChineseNewestVideos+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ChineseNewestVideos (CoreDataProperties)

+ (NSFetchRequest<ChineseNewestVideos *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *bigimg;
@property (nullable, nonatomic, copy) NSString *catalog;
@property (nullable, nonatomic, copy) NSString *comments;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *createdate;
@property (nonatomic) BOOL exestatus;
@property (nullable, nonatomic, copy) NSString *guid;
@property (nonatomic) BOOL headlines;
@property (nullable, nonatomic, copy) NSString *hero;
@property (nullable, nonatomic, copy) NSString *img;
@property (nullable, nonatomic, copy) NSString *physicalpath;
@property (nullable, nonatomic, copy) NSString *play;
@property (nullable, nonatomic, copy) NSString *source;
@property (nullable, nonatomic, copy) NSString *tag;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSString *url;
@property (nullable, nonatomic, copy) NSString *uuid;
@property (nullable, nonatomic, copy) NSString *vid;
@property (nullable, nonatomic, copy) NSString *virtualpath;
@property (nonatomic) BOOL writefilestatus;
@property (nullable, nonatomic, retain) ChineseAuthors *author;

@end

NS_ASSUME_NONNULL_END
