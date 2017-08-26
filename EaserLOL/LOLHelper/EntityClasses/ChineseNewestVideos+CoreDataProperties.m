//
//  ChineseNewestVideos+CoreDataProperties.m
//  LOLHelper
//
//  Created by Easer Liu on 16/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
//

#import "ChineseNewestVideos+CoreDataProperties.h"

@implementation ChineseNewestVideos (CoreDataProperties)

+ (NSFetchRequest<ChineseNewestVideos *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ChineseNewestVideos"];
}

@dynamic bigimg;
@dynamic catalog;
@dynamic comments;
@dynamic content;
@dynamic createdate;
@dynamic exestatus;
@dynamic guid;
@dynamic headlines;
@dynamic hero;
@dynamic img;
@dynamic physicalpath;
@dynamic play;
@dynamic source;
@dynamic tag;
@dynamic title;
@dynamic type;
@dynamic url;
@dynamic uuid;
@dynamic vid;
@dynamic virtualpath;
@dynamic writefilestatus;
@dynamic author;

@end
