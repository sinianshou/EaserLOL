//
//  SlotButton.m
//  LOLHelper
//
//  Created by Easer Liu on 16/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "SlotButton.h"

@implementation SlotButton

-(void)resetSlotButton
{
    self.name = nil;
    self.stats = nil;
    [self setImage:NULL forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
