//
//  UIButton+CacheImg.m
//  LOLHelper
//
//  Created by Easer Liu on 08/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "UIButton+CacheImg.h"

@implementation UIButton (CacheImg)

-(void)setImageWithContentsOfFile:(NSString *)imgPath cacheFromURL:(NSURL *)url forState:(UIControlState)state
{
    UIImage * image = [UIImage imageWithContentsOfFile:imgPath];
    if (image == nil) {
        NSURLSession * session = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                [NSException raise:[NSString stringWithFormat:@"%@网络通信错误",imgPath] format:@"错误是%@",[error localizedDescription]];
            }else
            {
                [data writeToFile:imgPath atomically:YES];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    UIImage * img = [UIImage imageWithContentsOfFile:imgPath];
                    if (img != nil) {
                        [self setImage:img forState:state];
                    }
                }];
            }
        }];
        [dataTask resume];
    }else
    {
        [self setImage:image forState:state];
    }
}

-(void)setBackGroundImageWithContentsOfFile:(NSString *)imgPath cacheFromURL:(NSURL *)url forState:(UIControlState)state
{
    UIImage * image = [UIImage imageWithContentsOfFile:imgPath];
    if (image == nil) {
        NSURLSession * session = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                [NSException raise:[NSString stringWithFormat:@"%@网络通信错误",imgPath] format:@"错误是%@",[error localizedDescription]];
            }else
            {
                [data writeToFile:imgPath atomically:YES];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    UIImage * img = [UIImage imageWithContentsOfFile:imgPath];
                    if (img != nil) {
                        [self setBackgroundImage:img forState:state];
                    }
                }];
            }
        }];
        [dataTask resume];
    }else
    {
        [self setBackgroundImage:image forState:state];
    }
}

-(void)setImage:(nullable UIImage *) img NameKey:(nonnull NSString *)key inCache:(nullable NSMutableDictionary *)cacheDic named:(nullable NSString *)name WithContentsOfFile:(nullable NSString *)imgPath cacheFromURL:(nullable NSURL *)url forState:(UIControlState)state
{
    UIImage * __block image = img;
    if (image != nil) {
        [self setImage:image forState:state];
        [self addImage:image NameKey:key toCacheDIc:cacheDic];
    }else
    {
        if (cacheDic && key) {
            image = [cacheDic objectForKey:key];
        }
        if (image != nil) {
            [self setImage:image forState:state];
        }else
        {
            image = [UIImage imageNamed:name];
            if (image != nil) {
                [self setImage:image forState:state];
                [self addImage:image NameKey:key toCacheDIc:cacheDic];
            }else
            {
                image = [UIImage imageWithContentsOfFile:imgPath];
                if (image != nil) {
                    [self setImage:image forState:state];
                    [self addImage:image NameKey:key toCacheDIc:cacheDic];
                }else if(url != nil)
                {
                    NSURLSession * session = [NSURLSession sharedSession];
                    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        if (error) {
                            [NSException raise:[NSString stringWithFormat:@"%@网络通信错误",imgPath] format:@"错误是%@",[error localizedDescription]];
                        }else
                        {
                            if (imgPath) {
                                [data writeToFile:imgPath atomically:YES];
                            }else
                            {
                                image = [UIImage imageWithData:data];
                            }
                            
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                if (image == nil) {
                                    image = [UIImage imageWithContentsOfFile:imgPath];
                                }
                                if (image != nil) {
                                    [self setImage:image forState:state];
                                    if (image != nil && cacheDic != nil && [cacheDic objectForKey:key] == nil) {
                                        [cacheDic setObject:image forKey:key];
                                        NSLog(@" cacheDic count is %d", (int)cacheDic.count);
                                        //        [self addImage:image NameKey:key toCacheDIc:cacheDic];
                                    }
                                }else
                                {
                                    [self setImage:[UIImage imageNamed:@"default_head"] forState:state];
                                    NSLog(@"can not get img %@, url is %@ set default_head", key, url);
                                }
                            }];
                        }
                        
                    }];
                    [dataTask resume];
                }
            }
        }
    }
    if (image != nil && cacheDic != nil && [cacheDic objectForKey:key] == nil) {
        [cacheDic setObject:image forKey:key];
        NSLog(@" cacheDic count is %d", (int)cacheDic.count);
        //        [self addImage:image NameKey:key toCacheDIc:cacheDic];
    }
}
-(void)setBackGroundImage:(nullable UIImage *) img NameKey:(nonnull NSString *)key inCache:(nullable NSMutableDictionary *)cacheDic named:(nullable NSString *)name WithContentsOfFile:(nullable NSString *)imgPath cacheFromURL:(nullable NSURL *)url forState:(UIControlState)state
{
    UIImage * __block image = img;
    if (image != nil) {
        [self setBackgroundImage:image forState:state];
        [self addImage:image NameKey:key toCacheDIc:cacheDic];
    }else
    {
        if (cacheDic && key) {
            image = [cacheDic objectForKey:key];
        }
        if (image != nil) {
            [self setBackgroundImage:image forState:state];
        }else
        {
            image = [UIImage imageNamed:name];
            if (image != nil) {
                [self setBackgroundImage:image forState:state];
                [self addImage:image NameKey:key toCacheDIc:cacheDic];
            }else
            {
                image = [UIImage imageWithContentsOfFile:imgPath];
                if (image != nil) {
                    [self setBackgroundImage:image forState:state];
                    [self addImage:image NameKey:key toCacheDIc:cacheDic];
                }else if(url != nil)
                {
                    NSURLSession * session = [NSURLSession sharedSession];
                    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                        if (error) {
                            [NSException raise:[NSString stringWithFormat:@"%@网络通信错误",imgPath] format:@"错误是%@",[error localizedDescription]];
                        }else
                        {
                            if (imgPath) {
                                [data writeToFile:imgPath atomically:YES];
                            }else
                            {
                                image = [UIImage imageWithData:data];
                            }
                            
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                if (image == nil) {
                                    image = [UIImage imageWithContentsOfFile:imgPath];
                                }
                                if (image != nil) {
                                    [self setBackgroundImage:image forState:state];
                                    if (image != nil && cacheDic != nil && [cacheDic objectForKey:key] == nil) {
                                        [cacheDic setObject:image forKey:key];
                                        NSLog(@" cacheDic count is %d", (int)cacheDic.count);
                                        //        [self addImage:image NameKey:key toCacheDIc:cacheDic];
                                    }
                                }else
                                {
                                    [self setBackgroundImage:[UIImage imageNamed:@"default_head"] forState:state];
                                    NSLog(@"can not get img %@, url is %@ set default_head", key, url);
                                }
                            }];
                        }
                        
                    }];
                    [dataTask resume];
                }
            }
        }
    }
    if (image != nil && cacheDic != nil && [cacheDic objectForKey:key] == nil) {
        [cacheDic setObject:image forKey:key];
        NSLog(@" cacheDic count is %d", (int)cacheDic.count);
        //        [self addImage:image NameKey:key toCacheDIc:cacheDic];
    }
}

-(void)addImage:(nullable UIImage *)image NameKey:(nullable NSString *)key toCacheDIc:(nullable NSMutableDictionary *)cacheDic
{
    if (image && cacheDic && key) {
        [cacheDic setObject:image forKey:key];
    }
}

@end
