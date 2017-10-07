//
//  UIImageView+CacheImg.m
//  LOLHelper
//
//  Created by Easer Liu on 08/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "UIImageView+CacheImg.h"

@implementation UIImageView (CacheImg)

-(void)setImage:(nullable UIImage *) img NameKey:(nonnull NSString *)key inCache:(nullable NSMutableDictionary *)cacheDic named:(nullable NSString *)name WithContentsOfFile:(nullable NSString *)imgPath cacheFromURL:(nullable NSURL *)url
{
    UIImage * __block image = img;
    if (image != nil) {
        [self setImage:image];
    }else
    {
        if (cacheDic && key) {
            image = [cacheDic objectForKey:key];
        }
        if (image != nil) {
            [self setImage:image];
        }else
        {
            image = [UIImage imageNamed:name];
            if (image != nil) {
                [self setImage:image];
            }else
            {
                image = [UIImage imageWithContentsOfFile:imgPath];
                if (image != nil) {
                    [self setImage:image];
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
                                    [self setImage:image];
                                    if (image != nil && cacheDic != nil && [cacheDic objectForKey:key] != nil) {
                                        [cacheDic setObject:image forKey:key];
                                        NSLog(@" cacheDic count is %d", (int)cacheDic.count);
                                    }
                                }else
                                {
                                    [self setImage:[UIImage imageNamed:@"default_head"]];
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
    }
}

@end
