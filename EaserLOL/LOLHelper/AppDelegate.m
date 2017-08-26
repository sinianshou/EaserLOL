//
//  AppDelegate.m
//  LOLHelper
//
//  Created by Easer Liu on 5/27/17.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "AppDelegate.h"
#import "GetData.h"
#import "PerCategory.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//设置自定义悬浮框坐标

-(void)setNew

{
    self.circleMenu= [[AssistiveTouch alloc]initWithFrame:CGRectMake(50,50,50,50)];
    
    self.circleMenu.ciecleColor = [UIColor yellowColor];
    
    self.circleMenu.centerButton.backgroundColor = [UIColor orangeColor];
    [self.circleMenu.centerButton setImage:[UIImage imageNamed:@"default_head"] forState:UIControlStateNormal];
    [self setCircleMenuCenterImg];
    NSArray * iconArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"icon_can"],
                           [UIImage imageNamed:@"icon_pos"],
                           [UIImage imageNamed:@"icon_img"],
                           [UIImage imageNamed:@"icon_can"], nil];
    [self.circleMenu setCircleButtonsWithImgs:iconArray Radius:25];
    [self.circleMenu.circleButtons[0] addTarget:self action:@selector(loginUsername) forControlEvents:UIControlEventTouchUpInside];
    [self.circleMenu.circleButtons[1] addTarget:self action:@selector(updateAccessKeys) forControlEvents:UIControlEventTouchUpInside];
    [self.circleMenu.circleButtons[2] addTarget:self action:@selector(cleanCoreData) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.OverallControlls = [[OverallControlls alloc] init];
    self.logInViewExpend = 0;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //这句话很重要，要先将rootview加载完成之后在显示悬浮框，如没有这句话，将可能造成程序崩溃
    [self performSelector:@selector(setNew) withObject:nil afterDelay:3];
    
    // 创建程序窗口
    self.window = [[UIWindow alloc] initWithFrame:
                   [[UIScreen mainScreen] bounds]];
    // 创建UITabBarController
    self.rootTabBarController = [[UITabBarController alloc] init];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // 创建newInfoViewController对象
    UIViewController * newInfoViewController = [sb instantiateViewControllerWithIdentifier:@"ViewController"];
    
    
    // 创建GameDataViewController对象对象
    UICollectionViewController * gameDataViewController = [sb instantiateViewControllerWithIdentifier:@"GameDataViewController"];
    
    
    
    // 创建perInfoTBController对象对象
    UITableViewController * perInfoTBController = [sb instantiateViewControllerWithIdentifier:@"PerInfoTableVC"];
    
    // 为UITabBarController设置多个视图控制器
    // 如果希望UITabBarController显示几个Tab页，
    // 就为UITabBarController添加几个视图控制器
    
    
    self.rootTabBarController.viewControllers = [NSArray
                                                 arrayWithObjects:newInfoViewController
                                                 , gameDataViewController, perInfoTBController, nil];
    
    
    
    // 将UITabBarController设置为窗口的根控制器
    self.window.rootViewController = self.rootTabBarController;
    
    [self.window makeKeyAndVisible];
    
    [self registerDefaultsSettingBundle];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"LOLHelper"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


#pragma mark - cycleButtonMethods
-(void)loginUsername
{
    NSLog(@"username is %@", self.OverallControlls.logInput.text);
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [self.OverallControlls changeIntoLoginputMode];
    switch (self.logInViewExpend + [userDefault stringForKey:@"origin_preference"].integerValue) {
            
        case 10: case 20:
            if (self.circleMenu.center.x <= [UIScreen mainScreen].bounds.size.width/2) {
                if (self.circleMenu.center.y <= [UIScreen mainScreen].bounds.size.height/2) {
                    self.OverallControlls.center = CGPointMake(self.circleMenu.center.x + (self.circleMenu.bounds.size.width/2)/sqrt(2) + self.OverallControlls.bounds.size.width/2, self.circleMenu.center.y + (self.circleMenu.bounds.size.width/2)/sqrt(2) + self.OverallControlls.bounds.size.height/2);
                }else
                {
                    self.OverallControlls.center = CGPointMake(self.circleMenu.center.x + (self.circleMenu.bounds.size.width/2)/sqrt(2) + self.OverallControlls.bounds.size.width/2, self.circleMenu.center.y - (self.circleMenu.bounds.size.width/2)/sqrt(2) - self.OverallControlls.bounds.size.height/2);
                }
            }else
            {
                if (self.circleMenu.center.y <= [UIScreen mainScreen].bounds.size.height/2) {
                    self.OverallControlls.center = CGPointMake(self.circleMenu.center.x - (self.circleMenu.bounds.size.width/2)/sqrt(2) - self.OverallControlls.bounds.size.width/2, self.circleMenu.center.y + (self.circleMenu.bounds.size.width/2)/sqrt(2) + self.OverallControlls.bounds.size.height/2);
                }else
                {
                    self.OverallControlls.center = CGPointMake(self.circleMenu.center.x - (self.circleMenu.bounds.size.width/2)/sqrt(2) - self.OverallControlls.bounds.size.width/2, self.circleMenu.center.y - (self.circleMenu.bounds.size.width/2)/sqrt(2) - self.OverallControlls.bounds.size.height/2);
                }
            }
            self.OverallControlls.hidden = NO;
            self.logInViewExpend = 1;
            
            break;
            
        case 11:
            break;
            
        case 21:
            [GetData updateUserName_EN:self.OverallControlls.logInput.text];
            self.OverallControlls.hidden = YES;
            self.logInViewExpend = 0;
            [self performSelector:@selector(setCircleMenuCenterImg) withObject:nil afterDelay:2];
            break;
            
        default:
            break;
    }
    
}

-(void)updateAccessKeys
{
    [GetData updateAccessKeys];
}

-(void)cleanCoreData
{
    [GetData deleteCoreData];
}
-(void)setCircleMenuCenterImg
{
    NSString * cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString * __block profileIconPath = nil;
    UIImage * __block profileIcon = nil;
    NSURL * profileIconURL = nil;
    NSLog(@"Origin is %ld",[[NSUserDefaults standardUserDefaults] stringForKey:@"origin_preference"].integerValue);
    switch ([[NSUserDefaults standardUserDefaults] stringForKey:@"origin_preference"].integerValue) {
        case 10:
            
            break;
            
        case 20:
            profileIconPath = [cachesDir stringByAppendingPathComponent:[NSString stringWithFormat:@"profileIcon_EN_%@.png", [[GetData getSummonerInfo_EN] objectForKey:@"profileIconId"]]];
            profileIcon = [UIImage imageWithContentsOfFile:profileIconPath];
            profileIconURL = [GetData getProfileIconURL_EN];
            break;
            
        default:
            break;
    }
    
    NSLog(@"profileIconPath is %@", profileIconPath);
    [self.circleMenu.centerButton setImageWithContentsOfFile:profileIconPath cacheFromURL:profileIconURL forState:UIControlStateNormal];
}

-(void)registerDefaultsSettingBundle
{
    NSString * settingBundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Settings.bundle/Root.plist"];
    NSDictionary * propertiesList = [NSDictionary dictionaryWithContentsOfFile:settingBundlePath];
    NSArray * preferences =[propertiesList objectForKey:@"PreferenceSpecifiers"];
    NSDictionary * preference = nil;
    NSMutableDictionary * defaultValues = [NSMutableDictionary dictionary];
    
    for ( preference in preferences ) {
        if ([preference objectForKey:@"Key"]) {
            [defaultValues setObject:[preference objectForKey:@"DefaultValue"] forKey:[preference objectForKey:@"Key"]];
        }
        
    }
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:defaultValues];
    [defaults synchronize];
}

@end
