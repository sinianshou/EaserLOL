//
//  UIButton+CacheImg.h
//  LOLHelper
//
//  Created by Easer Liu on 08/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (CacheImg)

-(void)setImageWithContentsOfFile:(NSString *)imgPath cacheFromURL:(NSURL *)url forState:(UIControlState)state;
-(void)setBackGroundImageWithContentsOfFile:(NSString *)imgPath cacheFromURL:(NSURL *)url forState:(UIControlState)state;
-(void)setImage:(nullable UIImage *) img NameKey:(nonnull NSString *)key inCache:(nullable NSMutableDictionary *)cacheDic named:(nullable NSString *)name WithContentsOfFile:(nullable NSString *)imgPath cacheFromURL:(nullable NSURL *)url forState:(UIControlState)state;
-(void)setBackGroundImage:(nullable UIImage *) img NameKey:(nonnull NSString *)key inCache:(nullable NSMutableDictionary *)cacheDic named:(nullable NSString *)name WithContentsOfFile:(nullable NSString *)imgPath cacheFromURL:(nullable NSURL *)url forState:(UIControlState)state;

@end
