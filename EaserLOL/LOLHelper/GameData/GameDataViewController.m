//
//  GameDataViewController.m
//  LOLHelper
//
//  Created by Easer Liu on 24/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "GameDataViewController.h"
#import "ChampionsCollectionCell.h"
#import "GetData.h"
#import "ChampionsBrief_EN+CoreDataClass.h"
#import "PerCategory.h"
#import "MymagicMove.h"
#import "ChampDetailViewController.h"
#import "ItemsCollectionVC.h"
#import "MyTransitionAnimator.h"
#import "MasteriesVC.h"
#import "RunesVC.h"

@interface GameDataViewController ()

@property (strong, nonatomic) NSArray<ChampionsBrief_EN *> * dataSourceArr;
@property (strong, nonatomic) NSMutableDictionary * imgCache;
@property (strong, nonatomic) NSString * cachesDir;
@property (assign, nonatomic) UIEdgeInsets defaultInset;
@property (strong, nonatomic) MymagicMove * animator;

@end

@implementation GameDataViewController

static NSString * const reuseIdentifier = @"ChampionsCollectionCell";
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self setTarBarItem];
    return self;
}
-(void)setTarBarItem
{
    UITabBarItem * perInfoTabBarItem = [[UITabBarItem alloc] initWithTitle:@"GameData" image:[[UIImage imageNamed:@"tab_icon_quiz_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:102];
    [perInfoTabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_icon_quiz_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBarItem = perInfoTabBarItem;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[ChampionsCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.dataSourceArr = [NSMutableArray array];
    self.imgCache = [NSMutableDictionary dictionary];
    self.cachesDir =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(70, 70);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    flowLayout.sectionInset = UIEdgeInsetsMake(0, 2, 0, 0);
    self.collectionView.collectionViewLayout = flowLayout;
    [self loadChampionsBriefDataFinishedWithTag:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadChampionsBriefDataFinishedNotification:) name:@"UpdateChampionsBrief_ENFinished" object:NULL];
    UIButton * bu = [[UIButton alloc] initWithFrame:CGRectMake(60, 60, 40, 40)];
    [bu.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [bu setTitle:@"刷新" forState:UIControlStateNormal];
    [bu setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [bu addTarget:self action:@selector(loadChampionsBriefData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bu];
    [self setHeaderView];
    
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.defaultInset = UIEdgeInsetsMake(self.headerView.bounds.size.height, 0, app.rootTabBarController.tabBar.bounds.size.height, 0);
    self.collectionView.contentInset = self.defaultInset;
    [self resetAnimator];
    // Do any additional setup after loading the view.
}

-(void)setHeaderView
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 60)];
    self.headerView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:self.headerView];
    self.items = [[UIButton alloc] initWithName:@"items"];
    [self.items setTitle:@"Items" forState:UIControlStateNormal];
    self.items.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.items addTarget:self action:@selector(presentItemVC) forControlEvents:UIControlEventTouchUpInside];
    self.masteries = [[UIButton alloc] initWithName:@"masteries"];
    [self.masteries setTitle:@"Masteries" forState:UIControlStateNormal];
    self.masteries.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.masteries addTarget:self action:@selector(presentMasteriesVC) forControlEvents:UIControlEventTouchUpInside];
    self.runes = [[UIButton alloc] initWithName:@"runes"];
    [self.runes setTitle:@"Runes" forState:UIControlStateNormal];
    self.runes.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.runes addTarget:self action:@selector(presentRunesVC) forControlEvents:UIControlEventTouchUpInside];
    self.champFilter = [[UIButton alloc] initWithName:@"champFilter"];
    [self.champFilter setTitle:@"AllChamps" forState:UIControlStateNormal];
    self.champFilter.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.champFilter addTarget:self action:@selector(filterChampions:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView perAddSubviews:self.items, self.masteries, self.runes, self.champFilter, nil];
    NSString * vflV01 = [NSString stringWithFormat:@"V:|-5-[%@]-5-|", self.items.perViewName];
    NSString * vflV02 = [NSString stringWithFormat:@"V:|-5-[%@]-5-|", self.masteries.perViewName];
    NSString * vflV03 = [NSString stringWithFormat:@"V:|-5-[%@]-5-|", self.runes.perViewName];
    NSString * vflV04 = [NSString stringWithFormat:@"V:|-5-[%@]-5-|", self.champFilter.perViewName];
    NSString * vflH01 = [NSString stringWithFormat:@"H:|-5-[%@]-5-[%@(==%@)]-5-[%@(==%@)]-5-[%@(==%@)]-5-|", self.items.perViewName, self.masteries.perViewName, self.items.perViewName, self.runes.perViewName, self.items.perViewName, self.champFilter.perViewName, self.items.perViewName];
    [self.headerView perAddConstraints:vflV01, vflV02, vflV03, vflV04, vflH01, nil];
}

-(void)filterChampions:(UIButton *) button
{
    if (self.filterView == nil) {
        [self setFilterView];
    }
    if (self.filterView.hidden == YES) {
        self.filterView.hidden = NO;
    }else
    {
        self.filterView.hidden = YES;
    }
}

-(void)setFilterView
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat length = (screenSize.width - 25)/4;
    self.filterView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.bounds.size.height, screenSize.width, 35)];
    NSArray * tags = [NSArray arrayWithObjects:@"AllChamps", @"Fighter", @"Assassin", @"Tank", @"Mage", @"Support", @"Marksman", nil];
    [tags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * button = [[UIButton alloc] init];
        button.layer.cornerRadius = 5;
        button.clipsToBounds = YES;
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:8];
        [button addTarget:self action:@selector(clickFilterButton:) forControlEvents:UIControlEventTouchUpInside];
        if (idx == 0) {
            [self performSelector:@selector(clickFilterButton:) withObject:button];
        }
        if (idx < 4) {
            button.frame = CGRectMake(5+(length+5)*idx, 5, length, 10);
        }else
        {
            button.frame = CGRectMake(5+(length+5)*(idx-4), 20, length, 10);
        }
        [self.filterView addSubview:button];
    }];
    self.filterView.backgroundColor = [UIColor greenColor];
    self.filterView.hidden = YES;
    [self.view addSubview:self.filterView];
}

-(void)clickFilterButton:(UIButton *)button
{
    [self.filterView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (((UIButton*)obj).selected) {
            ((UIButton*)obj).selected = NO;
            [((UIButton*)obj) setBackgroundColor:[UIColor whiteColor]];
        }
    }];
    self.filterView.hidden = YES;
    [self.champFilter setTitle:button.currentTitle forState:UIControlStateNormal];
    button.selected = YES;
    button.backgroundColor = [UIColor brownColor];
    if ([button.currentTitle isEqualToString:@"AllChamps"]) {
        [self loadChampionsBriefDataFinishedWithTag:NULL];
    }else
    {
        [self loadChampionsBriefDataFinishedWithTag:button.currentTitle];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChampionsCollectionCell * cell = (ChampionsCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self resetAnimator];
    ChampDetailViewController * ChampDetailController = (ChampDetailViewController *)self.animator.modalController;
    ChampDetailController.championIconImage = cell.championIcon.image;
    
    NSDictionary * dic = [GetData getChampionDetailWithId:cell.championId andName:cell.championKey];
    
    [ChampDetailController resetWithDic:dic];
    
    [self presentViewController:ChampDetailController animated:YES completion:nil];
}

-(void)resetAnimator
{
    if (self.animator == nil) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        // 创建newInfoViewController对象
        ChampDetailViewController * ChampDetailController = [sb instantiateViewControllerWithIdentifier:@"ChampDetailViewController"];
        ChampDetailController.modalPresentationStyle = UIModalPresentationCustom;
//        [ChampDetailController layoutPersubviews];
        
        self.animator = [[MymagicMove alloc] initWithModalViewController:ChampDetailController];
        
        ChampDetailController.transitioningDelegate = self.animator;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    if (self.dataSourceArr.count > 0) {
        return self.dataSourceArr.count;
    }else
    {
        return 10;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChampionsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[ChampionsCollectionCell alloc] init];
    }
    if (self.dataSourceArr.count > 0) {
        ChampionsBrief_EN * championsBrief_EN = [self.dataSourceArr objectAtIndex:indexPath.row];
        NSURL * championIconURL = [GetData getChampionIconURLWithName_EN:championsBrief_EN.square];
        NSString * nameKey = [NSString stringWithFormat:@"championIcon_EN_%@.png", championsBrief_EN.id];
        NSString * championIconPath = [self.cachesDir stringByAppendingPathComponent:nameKey];
        UIImage * championIcon = [self.imgCache objectForKey:nameKey];
        [cell.championIcon setImage:championIcon NameKey:nameKey inCache:self.imgCache named:NULL WithContentsOfFile:championIconPath cacheFromURL:championIconURL];
        cell.championId = championsBrief_EN.id;
        cell.championName = championsBrief_EN.name;
        cell.championKey = championsBrief_EN.key;
//        NSMutableAttributedString * prefileAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n%@", championsBrief_EN.name, championsBrief_EN.tags]];
//        [prefileAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0,championsBrief_EN.name.length)];
//        [prefileAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(championsBrief_EN.name.length + 2,championsBrief_EN.tags.length)];
//        cell.briefLa.attributedText = prefileAttStr;
//        [cell.backgroundView addSubview:[UIImage imageNamed:nameKey]];
    }else
    {
        UIImage * championIcon = [UIImage imageNamed:@"default_head"];
        
        [cell.championIcon setImage:championIcon NameKey:NULL inCache:NULL named:NULL WithContentsOfFile:NULL cacheFromURL:NULL];
        cell.briefLa.text = @"1234";
        cell.championId = [NSString stringWithFormat:@"62"];
        cell.championName = @"Wukong";
    }
    
    return cell;
}

-(void)loadChampionsBriefData
{
    [GetData updateChampionsBrife_EN];
}

-(void)loadChampionsBriefDataFinishedNotification:(NSNotification *)Notification
{
    [self loadChampionsBriefDataFinishedWithTag:NULL];
}
-(void)loadChampionsBriefDataFinishedWithTag:(NSString *)tagStr
{
    self.dataSourceArr = [GetData getChampionsBrife_ENWithTag:tagStr];
    if ([[NSThread currentThread] isMainThread]) {
        self.collectionView.contentInset = self.defaultInset;
        [self.collectionView reloadData];
    }else
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.collectionView.contentInset = self.defaultInset;
            [self.collectionView reloadData];
        }];
    }
    NSLog(@"刷新完了");
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark presentViewController method

-(void)presentItemVC
{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(32, 48);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    ItemsCollectionVC * itemsCollectionVC = [[ItemsCollectionVC alloc] initWithCollectionViewLayout:flowLayout];
    itemsCollectionVC.ItemsArrResouce = [GetData getItem_ENWithId:NULL tag:NULL map:NULL];
    [self presentViewController:itemsCollectionVC animated:YES completion:^{
        
        NSLog(@"items count is %d", (int)itemsCollectionVC.ItemsArrResouce.count);
    }];
    
}

-(void)presentMasteriesVC
{
    MasteriesVC * masteriesVC = [[MasteriesVC alloc] init];
    [self presentViewController:masteriesVC animated:YES completion:nil];
}
-(void)presentRunesVC
{
    RunesVC * runesVC = [[RunesVC alloc] init];
    [self presentViewController:runesVC animated:YES completion:nil];
}

@end
