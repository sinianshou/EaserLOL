//
//  UIImageView+CacheImg.h
//  LOLHelper
//
//  Created by Easer Liu on 08/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CacheImg)

-(void)setImage:(nullable UIImage *) img NameKey:(nonnull NSString *)key inCache:(nullable NSMutableDictionary *)cacheDic named:(nullable NSString *)name WithContentsOfFile:(nullable NSString *)imgPath cacheFromURL:(nullable NSURL *)url;

@end
