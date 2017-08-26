//
//  SlotButton.h
//  LOLHelper
//
//  Created by Easer Liu on 16/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlotButton : UIButton

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * type;
@property (strong, nonatomic) NSString * stats;

-(void)resetSlotButton;
@end
