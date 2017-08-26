//
//  AppDelegate.h
//  LOLHelper
//
//  Created by Easer Liu on 5/27/17.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
#ifndef AppDelegate_h
#define AppDelegate_h

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AssistiveTouch.h"
#import "OverallControlls.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *rootTabBarController;
@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (assign, nonatomic) int logInViewExpend;
@property (strong, nonatomic) OverallControlls * OverallControlls;
@property (strong, nonatomic) AssistiveTouch* circleMenu;

- (void)saveContext;


@end


#endif /* AppDelegate_h */
