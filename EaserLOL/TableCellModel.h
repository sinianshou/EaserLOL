//
//  TableCellModel.h
//  LOLHelper
//
//  Created by Easer Liu on 5/27/17.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#ifndef TableCellModel_h
#define TableCellModel_h


#endif /* TableCellModel_h */

#import <UIKit/UIKit.h>

@interface  TableCellModel : UITableViewCell

+(UITableViewCell *) getCellOfFreeChampionsList;
+(UITableViewCell *) getCellOfChineseNewestVideosWithIdentifier:(NSString *) identifier;
+(UITableViewCell *) getCellOfChineseAuthorsWithIdentifier:(NSString *) identifier;
@end
