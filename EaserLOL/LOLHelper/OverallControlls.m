//
//  OverallControlls.m
//  LOLHelper
//
//  Created by Easer Liu on 03/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "OverallControlls.h"

@implementation OverallControlls

-(instancetype)init
{
    self = [super init];
    
    self.frame = CGRectMake(0, 0, 1, 1);
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    self.controlMode = NoneMode;
    [self makeKeyAndVisible];
    
    return self;
}

-(void)changeIntoLoginputMode
{
    if (self.controlMode != LogInputMode) {
        self.controlMode = LogInputMode;
        UIView * subV = nil;
        for (subV in self.subviews) {
            [subV removeFromSuperview];
        }
        self.frame = CGRectMake(0, 0, 150, 50);
        self.bounds = CGRectMake(0, 0, 150, 50);
        self.layer.cornerRadius = 5;
        self.backgroundColor = [UIColor grayColor];
        self.logInput = [[UITextField alloc] init];
        self.logInput.bounds = CGRectMake(0, 0, self.bounds.size.width-15, self.bounds.size.height-15);
        self.logInput.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        self.logInput.layer.cornerRadius = 5;
        self.logInput.backgroundColor = [UIColor whiteColor];
        self.logInput.placeholder = [NSString stringWithFormat:@"UserName"];
        self.logInput.borderStyle = UITextBorderStyleRoundedRect;
        self.logInput.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.logInput.adjustsFontSizeToFitWidth = YES;
        self.logInput.keyboardType = UIKeyboardTypeDefault;
        self.logInput.enablesReturnKeyAutomatically = YES;
        [self addSubview:self.logInput];
    }
}

@end
