//
//  ViewController.m
//  LOLHelper
//
//  Created by Easer Liu on 5/27/17.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "ViewController.h"


#import "AppDelegate.h"
#import "RefreshView.h"
#import "MyTransitionAnimator.h"
#import "PageViewController.h"
#import "TableHeaderViewModel.h"
#import "GetData.h"
#import "OptimizeLog.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UINavigationBar *LHNavigation;
@property (strong, nonatomic) IBOutlet UITableView *LHTable;
@property NSMutableArray * dataTemp;
@property (strong, nonatomic) TableViewDataSource * LHTableViewDataSource ;
@property (strong, nonatomic) MyTransitionAnimator * animator;
@end

@implementation ViewController

-(instancetype)init
{
    self = [super init];
    [self setTarBarItem];
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setTarBarItem];
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self setTarBarItem];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.LHTableViewDataSource = [[TableViewDataSource alloc] initWithTableView:self.LHTable];
    self.LHTableViewDataSource.myLHUpDropDelegate = self;
    UIView * header01 = [TableHeaderViewModel getTableHeaderView];
    header01.tag = 31;
    header01.translatesAutoresizingMaskIntoConstraints = YES;
    header01.frame = CGRectMake(0, 0, header01.frame.size.width, header01.frame.size.height);
    
    UIView * MC = [header01 viewWithTag:11];
    for (UIButton * b in [MC subviews]) {
        [b addTarget:self action:@selector(showDateOfTable:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView * hv1 = [[UIView alloc]initWithFrame:header01.frame];
    self.LHTable.tableHeaderView = hv1;
    [self.LHTable addSubview:header01];
    [self.LHTable bringSubviewToFront:header01];
    self.LHTable.dataSource = self.LHTableViewDataSource;
    self.LHTable.delegate = self.LHTableViewDataSource;
    
    
    [self showNewestVideosCN];
    RefreshView * refreshView = [RefreshView getRefreshView];
    [self.view addSubview:refreshView];
    [self.view sendSubviewToBack:refreshView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showNewestVideosCN
{
    [self.LHTableViewDataSource dataSourceWithChineseNewestVideosFetchedResultsController];
    [self resizingSubView];
    
}

-(void)showDateOfTable:(UIButton *)button
{
    switch (button.tag) {
        case 0:
            self.dataTemp = [GetData getDataWithTag:0];
            [self.LHTableViewDataSource dataSourceWithFetchedResultsController:button.tag];
            
            break;
        case 1:
            self.dataTemp = [GetData getDataWithTag:1];
            [self.LHTableViewDataSource dataSourceWithFetchedResultsController:button.tag];
            
            break;
        case 2:
            self.dataTemp = [GetData getDataWithTag:2];
            [self.LHTableViewDataSource dataSourceWithFetchedResultsController:button.tag];
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
        default:
            break;
    }
}

-(void)resizingSubView
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    self.LHTable.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView * view01 = [self.LHTable viewWithTag:31];
    UIImageView * imgView = [view01 viewWithTag:12];
    CGFloat sectionHeaderHeight = imgView.bounds.size.height*1/3;
    AppDelegate * appDe = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    appDe.rootTabBarController.tabBar.bounds.size.height;
//    self.tabBarItem.accessibilityFrame.size.height;
    
    self.LHNavigation.bounds = CGRectMake(0,0,screenSize.width, sectionHeaderHeight);
    self.LHNavigation.translatesAutoresizingMaskIntoConstraints = NO;
    //添加垂直方向的约束
    NSString *vflV01 = [NSString stringWithFormat:@"V:|[LHTable]-%f-|", appDe.rootTabBarController.tabBar.bounds.size.height];
    NSDictionary * views = [NSDictionary dictionaryWithObjectsAndKeys:self.LHNavigation,@"LHNavigation",self.LHTable,@"LHTable", nil];
    NSArray * constraintsV01 = [NSLayoutConstraint constraintsWithVisualFormat:vflV01 options:0 metrics:nil views:views];
    [self.view addConstraints:constraintsV01] ;
    
    
    NSString *vflV02 = [NSString stringWithFormat:@"V:|[LHNavigation(%f)]",sectionHeaderHeight];
    NSArray * constraintsV02 = [NSLayoutConstraint constraintsWithVisualFormat:vflV02 options:0 metrics:nil views:views];
    [self.view addConstraints:constraintsV02] ;
    
    //水平方向的约束
    NSString *vflHNvigation = @"H:|[LHNavigation]|";
    NSArray * constraintsHNvigation = [NSLayoutConstraint constraintsWithVisualFormat:vflHNvigation options:0 metrics:nil views:views];
    [self.view addConstraints:constraintsHNvigation] ;
    NSString *vflHTable = @"H:|[LHTable]|";
    NSArray * constraintsHTable = [NSLayoutConstraint constraintsWithVisualFormat:vflHTable options:0 metrics:nil views:views];
    [self.view addConstraints:constraintsHTable] ;
    
    [self reloadInputViews];
    
}

#pragma mark - LHUpDropDelegate Methods

-(void)changeNavigationStatu:(NSString *)headerStatue
{
    if ([headerStatue  isEqual: @"UpToTop"]) {
        self.LHNavigation.hidden = NO;
        [self.view bringSubviewToFront:self.LHNavigation];
    }else
    {
        self.LHNavigation.hidden = YES;
    }
}

-(void)didSelectedCell:(NSString *)str
{
    PageViewController * pageController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    pageController.modalPresentationStyle = UIModalPresentationCustom;
    pageController.content = [NSMutableString stringWithFormat:@"%@",str];
    NSLog(@"page content is %@", str);
    
    self.animator = [[MyTransitionAnimator alloc] initWithModalViewController:pageController];
    self.animator.behindViewAlpha = 0.5f;
    self.animator.behindViewScale = 0.5f;
    
    pageController.transitioningDelegate = self.animator;
    [self presentViewController:pageController animated:YES completion:nil];
}

-(void)setTarBarItem
{
    UITabBarItem * perNewsTabBarItem = [[UITabBarItem alloc] initWithTitle:@"NewInfo" image:[[UIImage imageNamed:@"tab_icon_news_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:102];
    perNewsTabBarItem.badgeValue = @"New";
    [perNewsTabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_icon_news_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBarItem = perNewsTabBarItem;
    
}
@end
