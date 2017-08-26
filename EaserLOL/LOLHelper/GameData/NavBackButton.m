//
//  NavBackButton.m
//  LOLHelper
//
//  Created by Easer Liu on 11/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//



#import "NavBackButton.h"

@interface NavBackButton()
@end


@implementation NavBackButton

-(instancetype)initWithBackButtonType:(BackButtonType) backButtonType
{
    self = [super init];
    
    switch (backButtonType) {
        case BackButtonTypeNav:
            [self creatNavBackButton];
            break;
            
        default:
            break;
    }
    
    
    return self;
}

-(void)creatNavBackButton
{
    self.bounds = CGRectMake(0, 0, 50, 32);
    [self setTitle:@"    Back" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithRed:205/255.00 green:185/255.00 blue:130/255.00 alpha:1] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self setBackgroundImage:[UIImage imageNamed:@"nav_btn_back_normal"] forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
