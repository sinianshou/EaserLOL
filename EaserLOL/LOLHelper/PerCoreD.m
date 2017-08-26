//
//  PerCoreD.m
//  LOLHelper
//
//  Created by Easer Liu on 24/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "PerCoreD.h"

@implementation PerCoreD
- (instancetype)init
{
    self = [super init];
//    if (self) {
//        NSInteger majorVersion = [NSProcessInfo processInfo].operatingSystemVersion.majorVersion;
//        if (majorVersion < 10) {
//            // iOS10以下的系统, 用旧有的方法初始化Core Data Stack
//            [self initializeCoreDataLessThaniOS10];
//        }
//        else {
//            // iOS10的系统, 用新的方法(详见上面介绍的情况1)
//            [self initializeCoreData];
//        }
//    }
    [self initializeCoreDataLessThaniOS10];
    return self;
}

-(void)initializeCoreData
{
    // 我们先声明了一个NSPersistentContainer类型的属性：persistentContainer，在适合的时间调用initWithName:对其初始化
    // 这里的Name参数，需要和后续创建的.xcdatamodeld模型文件名称一致。
    self.mainContainer = [[NSPersistentContainer alloc] initWithName:@"LOLHelper"];
    
    // 调用loadPersistentStoresWithCompletionHandler:方法，完成Core Data Stack的最中初始化。
    // 如果不能初始化成功，在Block回调中打印错误，方便调试
    [self.mainContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull description, NSError * _Nullable error) {
        
        if (error != nil) {
            NSLog(@"Fail to load Core Data Stack : %@", error);
            abort();
        }
        else {
        }
    }];
    
}

- (void)initializeCoreDataLessThaniOS10 {
    // Get managed object model(拿到模型文件,也就是.xcdatamodeld文件(我们会在初始化完Core data Stack后创建))
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LOLHelper" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom != nil, @"Error initalizing Managed Object Model");
    
    // Create persistent store coordinator(创建NSPersistentStoreCoordinator对象(需要传入上述创建的NSManagedObjectModel对象))
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    
    // Creat managed object context(创建NSManagedObjectContext对象(_context是声明在.h文件的属性——因为其他类也要用到这个属性))
    self.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    // assgin persistent store coordinator(赋值persistentStoreCoordinator)
    self.mainContext.persistentStoreCoordinator = psc;
    
    // Create .sqlite file(在沙盒中创建.sqlite文件)
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"LOLHelper.sqlite"];
    NSLog(@"LOLHelper.sqlite is at %@", storeURL);
    
    // Create persistent store(异步创建NSPersistentStore并add到NSPersistentStoreCoordinator对象中，作用是设置保存的数据类型(NSSQLiteStoreType)、保存路径、是否支持版本迁移等)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 用于支持版本迁移的参数
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        NSError *error = nil;
        NSPersistentStoreCoordinator *psc = self.mainContext.persistentStoreCoordinator;
        
        // 备注，如果options参数传nil，表示不支持版本迁移
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                                     configuration:nil
                                                               URL:storeURL
                                                           options:options
                                                             error:&error];
        NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
    });
}

@end
