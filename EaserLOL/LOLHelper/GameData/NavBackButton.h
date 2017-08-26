//
//  NavBackButton.h
//  LOLHelper
//
//  Created by Easer Liu on 11/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
#ifndef NavBackButton_h
#define NavBackButton_h

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, BackButtonType) {
    BackButtonTypeNav = 0,
};

@interface NavBackButton : UIButton

-(instancetype)initWithBackButtonType:(BackButtonType) backButtonType;

@end
#endif /* NavBackButton_h */
