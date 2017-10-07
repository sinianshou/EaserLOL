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
#import "PersonalTransitionAnimator.h"

@interface GameDataViewController ()

@property (strong, nonatomic) NSArray<ChampionsBrief_EN *> * dataSourceArr;
@property (strong, nonatomic) NSMutableDictionary * imgCache;
@property (strong, nonatomic) NSString * cachesDir;
@property (assign, nonatomic) UIEdgeInsets defaultInset;
@property (strong, nonatomic) MymagicMove * animator;
@property (strong, nonatomic) PersonalTransitionAnimator * transition;

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
    
    // Register cell classes
    [self.collectionView registerClass:[ChampionsCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.dataSourceArr = [NSMutableArray array];
    self.imgCache = [NSMutableDictionary dictionary];
    self.cachesDir =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(70, 70);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = flowLayout;
    [self loadChampionsBriefDataFinishedWithTag:NULL];
    
    if (!(self.dataSourceArr.count > 0)) {
        [self loadChampionsBriefData];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadChampionsBriefDataFinishedNotification:) name:@"UpdateChampionsBrief_ENFinished" object:NULL];
    UIButton * bu = [[UIButton alloc] initWithFrame:CGRectMake(60, 60, 40, 40)];
    [bu.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [bu setTitle:@"刷新" forState:UIControlStateNormal];
    [bu setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [bu addTarget:self action:@selector(loadChampionsBriefData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bu];
    [self setHeaderView];
    
    NSLog(@"item img bound is %@ %@ %@ ",NSStringFromCGRect(self.items.frame),NSStringFromCGRect(self.items.imageView.frame), NSStringFromCGRect(self.items.titleLabel.frame));
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
    self.headerView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.headerView];
    self.items = [[UIButton alloc] initWithName:@"items"];
    [self.items setImage:[UIImage imageNamed:@"gamedataHeaderIcon"] forState:UIControlStateNormal];
    [self.items setTitle:@"Items" forState:UIControlStateNormal];
    self.items.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.items addTarget:self action:@selector(presentItemVC) forControlEvents:UIControlEventTouchUpInside];
    self.masteries = [[UIButton alloc] initWithName:@"masteries"];
    [self.masteries setImage:[UIImage imageNamed:@"gamedataHeaderIcon"] forState:UIControlStateNormal];
    [self.masteries setTitle:@"Masteries" forState:UIControlStateNormal];
    self.masteries.titleLabel.font = self.items.titleLabel.font;
    [self.masteries addTarget:self action:@selector(presentMasteriesVC) forControlEvents:UIControlEventTouchUpInside];
    self.runes = [[UIButton alloc] initWithName:@"runes"];
    [self.runes setImage:[UIImage imageNamed:@"gamedataHeaderIcon"] forState:UIControlStateNormal];
    [self.runes setTitle:@"Runes" forState:UIControlStateNormal];
    self.runes.titleLabel.font = self.items.titleLabel.font;
    [self.runes addTarget:self action:@selector(presentRunesVC) forControlEvents:UIControlEventTouchUpInside];
    self.champFilter = [[UIButton alloc] initWithName:@"champFilter"];
    [self.champFilter setImage:[UIImage imageNamed:@"gamedataHeaderIcon"] forState:UIControlStateNormal];
    [self.champFilter setTitle:@"AllChamps" forState:UIControlStateNormal];
    self.champFilter.titleLabel.font = self.items.titleLabel.font;
    [self.champFilter addTarget:self action:@selector(filterChampions:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView perAddSubviews:self.items, self.masteries, self.runes, self.champFilter, nil];
    NSString * vflV01 = [NSString stringWithFormat:@"V:|-5-[%@]-5-|", self.items.perViewName];
    NSString * vflV02 = [NSString stringWithFormat:@"V:|-5-[%@]-5-|", self.masteries.perViewName];
    NSString * vflV03 = [NSString stringWithFormat:@"V:|-5-[%@]-5-|", self.runes.perViewName];
    NSString * vflV04 = [NSString stringWithFormat:@"V:|-5-[%@]-5-|", self.champFilter.perViewName];
    NSString * vflH01 = [NSString stringWithFormat:@"H:|-5-[%@]-5-[%@(==%@)]-5-[%@(==%@)]-5-[%@(==%@)]-5-|", self.items.perViewName, self.masteries.perViewName, self.items.perViewName, self.runes.perViewName, self.items.perViewName, self.champFilter.perViewName, self.items.perViewName];
    [self.headerView perAddConstraints:vflV01, vflV02, vflV03, vflV04, vflH01, nil];
    
    
    self.champFilter.imageEdgeInsets = UIEdgeInsetsMake(                                                  CGRectGetMinY(self.champFilter.bounds)-CGRectGetMinY(self.champFilter.imageView.frame)+5,                                                  CGRectGetMidX(self.champFilter.bounds)-CGRectGetMidX(self.champFilter.imageView.frame),                                                  CGRectGetMinY(self.champFilter.imageView.frame)-CGRectGetMinY(self.champFilter.bounds)-5,                                                  CGRectGetMidX(self.champFilter.imageView.frame)-CGRectGetMidX(self.champFilter.bounds));
    self.items.imageEdgeInsets = UIEdgeInsetsMake(                                                  CGRectGetMinY(self.items.bounds)-CGRectGetMinY(self.items.imageView.frame)+5,                                                  CGRectGetMidX(self.items.bounds)-CGRectGetMidX(self.items.imageView.frame),                                                  CGRectGetMinY(self.items.imageView.frame)-CGRectGetMinY(self.items.bounds)-5,                                                  CGRectGetMidX(self.items.imageView.frame)-CGRectGetMidX(self.items.bounds));
    self.masteries.imageEdgeInsets = UIEdgeInsetsMake(                                                  CGRectGetMinY(self.masteries.bounds)-CGRectGetMinY(self.masteries.imageView.frame)+5,                                                  CGRectGetMidX(self.masteries.bounds)-CGRectGetMidX(self.masteries.imageView.frame),                                                  CGRectGetMinY(self.masteries.imageView.frame)-CGRectGetMinY(self.masteries.bounds)-5,                                                  CGRectGetMidX(self.masteries.imageView.frame)-CGRectGetMidX(self.masteries.bounds));
    self.runes.imageEdgeInsets = UIEdgeInsetsMake(                                                  CGRectGetMinY(self.runes.bounds)-CGRectGetMinY(self.runes.imageView.frame)+5,                                                  CGRectGetMidX(self.runes.bounds)-CGRectGetMidX(self.runes.imageView.frame),                                                  CGRectGetMinY(self.runes.imageView.frame)-CGRectGetMinY(self.runes.bounds)-5,                                                  CGRectGetMidX(self.runes.imageView.frame)-CGRectGetMidX(self.runes.bounds));
    
    self.champFilter.titleEdgeInsets = UIEdgeInsetsMake(                                                  CGRectGetMaxY(self.champFilter.bounds)-CGRectGetMaxY(self.champFilter.titleLabel.frame),                                                  CGRectGetMinX(self.champFilter.bounds)-CGRectGetMinX(self.champFilter.titleLabel.frame),                                                  CGRectGetMaxY(self.champFilter.titleLabel.frame)-CGRectGetMaxY(self.champFilter.bounds),                                                  CGRectGetMaxX(self.champFilter.titleLabel.frame)-CGRectGetMaxX(self.champFilter.bounds));
    self.items.titleEdgeInsets = self.champFilter.titleEdgeInsets;
    self.masteries.titleEdgeInsets = self.champFilter.titleEdgeInsets;
    self.runes.titleEdgeInsets = self.champFilter.titleEdgeInsets;
    
    
    NSLog(@"item img bound is %@ %@ %@", NSStringFromCGRect(self.items.frame),NSStringFromCGRect(self.items.imageView.frame), NSStringFromCGRect(self.items.titleLabel.frame));
    
    NSLog(@"self.champFilter bounds is %@ %@ %@", NSStringFromCGRect(self.champFilter.frame), NSStringFromCGRect(self.champFilter.imageView.frame), NSStringFromCGRect(self.champFilter.titleLabel.frame));
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
    self.filterView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.bounds.size.height, screenSize.width, 70)];
    NSArray * tags = [NSArray arrayWithObjects:@"AllChamps", @"Fighter", @"Assassin", @"Tank", @"Mage", @"Support", @"Marksman", nil];
    [tags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * button = [[UIButton alloc] init];
        button.layer.cornerRadius = 10;
        button.clipsToBounds = YES;
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button addTarget:self action:@selector(clickFilterButton:) forControlEvents:UIControlEventTouchUpInside];
        if (idx == 0) {
            [self performSelector:@selector(clickFilterButton:) withObject:button];
        }
        if (idx < 4) {
            button.frame = CGRectMake(5+(length+5)*idx, 10, length, 20);
        }else
        {
            button.frame = CGRectMake(5+(length+5)*(idx-4), 40, length, 20);
        }
        [self.filterView addSubview:button];
    }];
    self.filterView.backgroundColor = [UIColor colorWithRed:0/255.00 green:0/255.00 blue:0/255.00 alpha:0.5];
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
    
    self.champFilter.imageEdgeInsets = UIEdgeInsetsZero;
    self.champFilter.imageEdgeInsets = UIEdgeInsetsMake(                                                  CGRectGetMinY(self.champFilter.bounds)-CGRectGetMinY(self.champFilter.imageView.frame)+5,                                                  CGRectGetMidX(self.champFilter.bounds)-CGRectGetMidX(self.champFilter.imageView.frame),                                                  CGRectGetMinY(self.champFilter.imageView.frame)-CGRectGetMinY(self.champFilter.bounds)-5,                                                  CGRectGetMidX(self.champFilter.imageView.frame)-CGRectGetMidX(self.champFilter.bounds));
    
    button.selected = YES;
    button.backgroundColor = [UIColor colorWithRed:205/255.00 green:185/255.00 blue:130/255.00 alpha:1];
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
    if (self.dataSourceArr.count > 0) {
        return self.dataSourceArr.count;
    }else
    {
        return 0;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayNotification" object:@"loadChampionsBriefDataFinished" userInfo:NULL];
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
    itemsCollectionVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self updatePersonalTransitionAnimator];
    self.transition.modelVC = itemsCollectionVC;
    self.transition.animatorStyle = TransitionAnimatorStyleBreak;
    itemsCollectionVC.transitioningDelegate = self.transition;
    
    [self presentViewController:itemsCollectionVC animated:YES completion:^{
        
        NSLog(@"items count is %d", (int)itemsCollectionVC.ItemsArrResouce.count);
    }];
    
}

-(void)presentMasteriesVC
{
    MasteriesVC * masteriesVC = [[MasteriesVC alloc] init];
    
    [self updatePersonalTransitionAnimator];
    self.transition.modelVC = masteriesVC;
    self.transition.animatorStyle = TransitionAnimatorStyleFire;
    masteriesVC.transitioningDelegate = self.transition;
    masteriesVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:masteriesVC animated:YES completion:nil];
}
-(void)presentRunesVC
{
    RunesVC * runesVC = [[RunesVC alloc] init];
    [self updatePersonalTransitionAnimator];
    self.transition.modelVC = runesVC;
    self.transition.animatorStyle = TransitionAnimatorStyle3DTransform;
    runesVC.transitioningDelegate = self.transition;
    runesVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:runesVC animated:YES completion:nil];
}
-(void)updatePersonalTransitionAnimator
{
    if (self.transition == nil) {
        self.transition = [[PersonalTransitionAnimator alloc] init];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > -80) {
        NSLog(@"drop to refresh");
    }else if (scrollView.contentOffset.x <= -80)
    {
        NSLog(@"release to refresh");
    }
    
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x <= -80)
    {
        NSLog(@"release to refresh");
        scrollView.contentInset = UIEdgeInsetsMake(0, 50, 0, 0);
        [self performSelector:@selector(loadChampionsBriefData) withObject:NULL afterDelay:3];
    }
}
@end
