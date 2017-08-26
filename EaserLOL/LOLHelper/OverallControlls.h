//
//  OverallControlls.h
//  LOLHelper
//
//  Created by Easer Liu on 03/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, ControlMode) {
    
    NoneMode = 0,
    LogInputMode,
};

@interface OverallControlls : UIWindow

@property (assign, nonatomic) ControlMode controlMode;
@property (strong, nonatomic) UITextField * logInput;

-(void)changeIntoLoginputMode;

@end
