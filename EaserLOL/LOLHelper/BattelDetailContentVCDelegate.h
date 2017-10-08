//
//  BattelDetailContentVCDelegate.h
//  LOLHelper
//
//  Created by Easer Liu on 04/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
#ifndef BattelDetailContentVCDelegate_h
#define BattelDetailContentVCDelegate_h

#import <UIKit/UIKit.h>

@protocol ContentVCDelegatePro

-(void)changeWhenScrollByRate:(CGFloat)rate;

@end

@interface BattelDetailContentVCDelegate : NSObject <UIScrollViewDelegate>

@property (strong, nonatomic) id<ContentVCDelegatePro> contentVCDelegatePro;

@end

#endif /* BattelDetailContentVCDelegate_h */
