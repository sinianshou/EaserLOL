//
//  PerInfoCell+Ability.h
//  LOLHelper
//
//  Created by Easer Liu on 26/06/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

//#ifndef PerInfoCell+Ability_h
//#define PerInfoCell+Ability_h

#import "PerInfoCell.h"

@interface PerInfoCell (Ability)

-(instancetype)initAbilityTypeCellWithIndexPath:(NSIndexPath *)indexPath;
-(void)configueAbilityTypeCellWithDic:(NSDictionary *)dic atIndexPath:(NSIndexPath *)indexPath;

@end

//#endif /* PerInfoCell+Ability_h */

