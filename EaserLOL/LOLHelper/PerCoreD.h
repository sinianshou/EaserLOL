//
//  PerCoreD.h
//  LOLHelper
//
//  Created by Easer Liu on 24/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
#ifndef PerCoreD_h
#define PerCoreD_h
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PerCoreD : NSObject

@property (strong, nonatomic) NSManagedObjectContext * mainContext;
@property (nonatomic, strong) NSPersistentContainer * mainContainer;

@end

#endif /* PerCoreD_h */
