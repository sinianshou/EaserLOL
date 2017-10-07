//
//  ItemsCollectionVC.m
//  LOLHelper
//
//  Created by Easer Liu on 07/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "ItemsCollectionVC.h"
#import "Item_EN+CoreDataClass.h"
#import "PerCategory.h"
#import "GetData.h"
#import "ItemsVCCell.h"
#import "ItemDetailVC.h"

@interface ItemsCollectionVC ()


@property (strong, nonatomic) NSString * cachesDir;
@property (strong, nonatomic) UIColor * perColor;
@property (strong, nonatomic) UIColor * perGrayColor;
@property (assign, nonatomic) CGSize screenSize;
@property (strong, nonatomic) ItemDetailVC * itemDetailV;
@property (strong, nonatomic) UIView * mapFilterView;
@property (strong, nonatomic) UIView * TagFilterView;
@property (strong, nonatomic) UIButton * mapFilter;
@property (strong, nonatomic) UIButton * tagFilter;

@end

@implementation ItemsCollectionVC

static NSString * const reuseIdentifier = @"ItemsVCCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cachesDir =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    self.perColor = [UIColor colorWithRed:205/255.00 green:185/255.00 blue:130/255.00 alpha:1];
    self.perGrayColor = [UIColor colorWithRed:230/255.00 green:230/255.00 blue:230/255.00 alpha:1];
    self.screenSize = [UIScreen mainScreen].bounds.size;
    
    // Register cell classes
    [self.collectionView registerClass:[ItemsVCCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    
    
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self setHeader];
}
-(void)setHeader
{
    UIColor  *perColor = [UIColor colorWithRed:205/255.00 green:185/255.00 blue:130/255.00 alpha:1];
    //640*128 nav_bar_bg_for_seven
    UIImageView * nav_bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenSize.width, self.screenSize.width*128/640)];
    nav_bg.image = [UIImage imageNamed:@"nav_bar_bg_for_seven"];
    [self.view addSubview:nav_bg];
    
    UIButton * backB = [[UIButton alloc] init];
    backB.bounds = CGRectMake(0, 0, 50, 32);
    backB.center = CGPointMake(nav_bg.frame.origin.x + 10 + backB.bounds.size.width/2, nav_bg.frame.origin.y + nav_bg.frame.size.height/2);
    [backB setTitle:@"    Back" forState:UIControlStateNormal];
    [backB setTitleColor:self.perColor forState:UIControlStateNormal];
    backB.titleLabel.font = [UIFont systemFontOfSize:15];
    [backB setBackgroundImage:[UIImage imageNamed:@"nav_btn_back_normal"] forState:UIControlStateNormal];
    [backB addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backB];
    
    UILabel * title = [[UILabel alloc] init];
    title.bounds = CGRectMake(0, 0, 60, 20);
    title.center = CGPointMake(self.screenSize.width/2, backB.center.y);
    title.textAlignment = NSTextAlignmentCenter;
    title.adjustsFontSizeToFitWidth = YES;
    title.text = @"Items";
    title.textColor =perColor;
    [self.view addSubview:title];
    
    self.mapFilter = [[UIButton alloc] initWithFrame:CGRectMake(0, nav_bg.frame.origin.y + nav_bg.frame.size.height, self.screenSize.width/2, 30)];
    [self.mapFilter setTitle:@"All Maps" forState:UIControlStateNormal];
    [self.mapFilter setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.mapFilter.layer.borderWidth = 0.25;
    self.mapFilter.layer.borderColor = self.perGrayColor.CGColor;
    [self.mapFilter addTarget:self action:@selector(expordFilterView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mapFilter];
    
    
    NSArray <NSString *>* mapsArr = [NSArray arrayWithObjects:@"All Maps", @"Crystal Scar", @"Twisted Treeline",  @"Summoner's Rift", @"Howling Abyss", nil];
    self.mapFilterView = [self createFilterViewWithButtonTitlesArr:mapsArr right:NO topY:self.mapFilter.frame.origin.y + self.mapFilter.frame.size.height];
    [self.view addSubview:self.mapFilterView];
    
    self.tagFilter = [[UIButton alloc] initWithFrame:CGRectMake(self.screenSize.width/2, self.mapFilter.frame.origin.y , self.screenSize.width/2, self.mapFilter.frame.size.height)];
    [self.tagFilter setTitle:@"All Items" forState:UIControlStateNormal];
    [self.tagFilter setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.tagFilter.layer.borderWidth = 0.25;
    self.tagFilter.layer.borderColor = self.perGrayColor.CGColor;
    [self.tagFilter addTarget:self action:@selector(expordFilterView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tagFilter];
    
    NSArray <NSString *>* tagsArr = [NSArray arrayWithObjects:@"All Items", @"Boots",  @"Mana", @"ManaRegen", @"Health",  @"HealthRegen", @"CriticalStrike", @"SpellDamage",  @"Armor", @"SpellBlock", @"Damage", @"Lane", @"LifeSteal", @"OnHit", @"Jungle", @"AttackSpeed", @"Consumable", @"Active", @"Vision", @"Stealth", @"NonbootsMovement", @"Tenacity", @"SpellVamp", @"GoldPer", @"CooldownReduction", @"Aura", @"MagicPenetration", @"Slow", @"ArmorPenetration", @"Trinket", @"Bilgewater", nil];
    self.TagFilterView = [self createFilterViewWithButtonTitlesArr:tagsArr right:YES topY:self.tagFilter.frame.origin.y + self.tagFilter.frame.size.height];
    [self.view addSubview:self.TagFilterView];
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(self.mapFilter.frame.origin.y + self.mapFilter.frame.size.height, 0, 0, 0)];
}

-(UIView *)createFilterViewWithButtonTitlesArr:(NSArray<NSString *> *) titlesArr right:(BOOL) right topY:(CGFloat) topY
{
    UIView *  filterView = [[UIView alloc] init];
    filterView.backgroundColor = [UIColor whiteColor];
    filterView.alpha = 0;
    filterView.hidden = YES;
    
    CGFloat __block rows = 0;
    CGFloat rest = 5;
    [titlesArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(FilterAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundColor:self.perGrayColor];
        [button.titleLabel sizeToFit];
        button.bounds = CGRectMake(0, 0, button.titleLabel.bounds.size.width + 12, button.titleLabel.bounds.size.height + 8);
        button.layer.cornerRadius = button.bounds.size.height/2;
        button.clipsToBounds = YES;
        if (idx == 0) {
            button.center =  CGPointMake(10 + button.bounds.size.width/2 , button.bounds.size.height/2 + rest + (button.bounds.size.height + rest)*rows);
        }else
        {
            CGFloat xo = filterView.subviews.lastObject.frame.origin.x + filterView.subviews.lastObject.frame.size.width + rest;
            if (xo + button.frame.size.width + 10 < self.screenSize.width) {
                button.center =  CGPointMake( xo + button.bounds.size.width/2, button.bounds.size.height/2 + rest + (button.bounds.size.height + rest)*rows);
            }else
            {
                rows += 1;
                button.center =  CGPointMake( 10 + button.bounds.size.width/2, button.bounds.size.height/2 + rest + (button.bounds.size.height + rest)*rows);
            }
        }
        [filterView addSubview:button];
    }];
    filterView.bounds = CGRectMake(0, 0, self.screenSize.width, filterView.subviews.lastObject.frame.origin.y + filterView.subviews.lastObject.frame.size.height + rest);
    filterView.transform = CGAffineTransformMakeScale(0.25, 0.25);
    if (right) {
        filterView.center = CGPointMake(self.screenSize.width - filterView.bounds.size.width*0.5*0.25, topY + filterView.bounds.size.height*0.5*0.25);
    }else
    {
        filterView.center = CGPointMake(filterView.bounds.size.width*0.5*0.25, topY + filterView.bounds.size.height*0.5*0.25);
    }
    
    return filterView;
}

-(void)expordFilterView:(UIButton *)button
{
    if ([button isEqual:self.mapFilter]) {
        [self expordMapFilterView];
        if (!self.TagFilterView.hidden) {
            [self expordTagFilterView];
        }
    }else
    {
        [self expordTagFilterView];
        if (!self.mapFilterView.hidden) {
            [self expordMapFilterView];
        }
    }
}

-(void)expordMapFilterView
{
    if (self.mapFilterView.hidden) {
        self.mapFilterView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.mapFilterView.center = CGPointMake(self.mapFilterView.bounds.size.width/2,self.mapFilter.frame.origin.y + self.mapFilter.frame.size.height + self.mapFilterView.bounds.size.height/2);
            self.mapFilterView.transform = CGAffineTransformMakeScale(1, 1 );
            self.mapFilterView.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }else
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.mapFilterView.transform = CGAffineTransformMakeScale(0.25, 0.25);
            self.mapFilterView.center = CGPointMake(self.mapFilterView.bounds.size.width*0.25*0.5, self.mapFilter.frame.origin.y + self.mapFilter.frame.size.height + self.mapFilterView.bounds.size.height*0.25*0.5);
            self.mapFilterView.alpha = 0;
        } completion:^(BOOL finished) {
            self.mapFilterView.hidden = YES;
        }];
    }
}
-(void)expordTagFilterView
{
    if (self.TagFilterView.hidden) {
        self.TagFilterView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.TagFilterView.transform = CGAffineTransformMakeScale(1, 1);
            self.TagFilterView.center = CGPointMake(self.TagFilterView.bounds.size.width/2, self.tagFilter.frame.origin.y + self.tagFilter.frame.size.height + self.TagFilterView.bounds.size.height/2);
            self.TagFilterView.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }else
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.TagFilterView.transform = CGAffineTransformMakeScale(0.25, 0.25);
            self.TagFilterView.center = CGPointMake(self.screenSize.width - self.TagFilterView.bounds.size.width*0.5*0.25, self.tagFilter.frame.origin.y + self.tagFilter.frame.size.height + self.TagFilterView.bounds.size.height*0.5*0.25);
            self.TagFilterView.alpha = 0;
        } completion:^(BOOL finished) {
            self.TagFilterView.hidden = YES;
        }];
    }
}

-(void)FilterAction:(UIButton *) button
{
    if ([self.mapFilterView.subviews containsObject:button]) {
        [self.mapFilter setTitle:button.currentTitle forState:UIControlStateNormal];
        [self.mapFilterView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]] && ((UIButton *)obj).selected) {
                ((UIButton *)obj).selected = NO;
                [((UIButton *)obj) setBackgroundColor:self.perGrayColor];
            }
        }];
        button.selected = YES;
        [button setBackgroundColor:self.perColor];
        [self expordMapFilterView];
    }else
    {
        [self.tagFilter setTitle:button.currentTitle forState:UIControlStateNormal];
        [self.TagFilterView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]] && ((UIButton *)obj).selected) {
                ((UIButton *)obj).selected = NO;
                [((UIButton *)obj) setBackgroundColor:self.perGrayColor];
            }
        }];
        button.selected = YES;
        [button setBackgroundColor:self.perColor];
        [self expordTagFilterView];
    }
    self.ItemsArrResouce = [GetData getItem_ENWithId:NULL tag:self.tagFilter.currentTitle map:self.mapFilter.currentTitle];
    [self.collectionView reloadData];
}

-(void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    if (self.ItemsArrResouce.count > 0) {
        return self.ItemsArrResouce.count;
    }else
    {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemsVCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    Item_EN * item = [self.ItemsArrResouce objectAtIndex:indexPath.row];
    
    NSString * iconNameKey = [NSString stringWithFormat:@"item_EN_%@", item.square];
    NSString * iconPath = [self.cachesDir stringByAppendingPathComponent:iconNameKey];
    NSURL * iconURL = [GetData getItemSquareWithImageName_EN:item.square];
    
    [cell.icon setImage:NULL NameKey:iconNameKey inCache:NULL named:NULL WithContentsOfFile:iconPath cacheFromURL:iconURL];
    cell.la.text = item.name;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemsVCCell * cell = (ItemsVCCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.itemDetailV == nil) {
        self.itemDetailV = [[ItemDetailVC alloc] initVoid];
        [self.view bringSubviewToFront:self.itemDetailV];
        self.itemDetailV.hidden = YES;
        [self.view addSubview:self.itemDetailV];
    }
    CGRect startRect = [self.view convertRect:cell.frame fromView:cell.superview];
    Item_EN * item = [self.ItemsArrResouce objectAtIndex:indexPath.row];
    [self setItemDetailVWithItem:item startRect:startRect];
    
    self.itemDetailV.transform = CGAffineTransformMakeScale(self.itemDetailV.startRect.size.width/self.screenSize.width, self.itemDetailV.startRect.size.height/self.screenSize.height);
    self.itemDetailV.center = CGPointMake(self.itemDetailV.startRect.origin.x + self.itemDetailV.startRect.size.width/2, self.itemDetailV.startRect.origin.y + self.itemDetailV.startRect.size.height/2);
    self.itemDetailV.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.itemDetailV.center = CGPointMake(self.screenSize.width/2, self.screenSize.height/2);
        self.itemDetailV.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
    }];
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
#pragma mark <ItemDetailV>
-(void)changeItemDetailV:(UIButton *) button
{
    BOOL __block unDone = YES;
    [self.ItemsArrResouce enumerateObjectsUsingBlock:^(Item_EN * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.id isEqualToString:button.currentTitle]) {
            
            
            NSIndexPath *idxPath = [NSIndexPath indexPathForRow:idx inSection:0];
            ItemsVCCell * __block cell = nil;
            CGRect __block startRect;
            if ([self.collectionView.indexPathsForVisibleItems containsObject:idxPath]) {
                cell = (ItemsVCCell *)[self.collectionView cellForItemAtIndexPath:idxPath];
                startRect = [self.view convertRect:cell.frame fromView:cell.superview];
                
                [self setItemDetailVWithItem:obj startRect:startRect];
                
            }else
            {
                [UIView animateWithDuration:0 animations:^{
                    [self.collectionView scrollToItemAtIndexPath:idxPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
                } completion:^(BOOL finished) {
                    cell = (ItemsVCCell *)[self.collectionView cellForItemAtIndexPath:idxPath];
                    startRect = [self.view convertRect:cell.frame fromView:cell.superview];
                    [self setItemDetailVWithItem:obj startRect:startRect];
                }];
            }
            unDone = NO;
            *stop = YES;
        }
    }];
    
    if (unDone) {
        NSArray * itemsArr = [GetData getItem_ENWithId:button.currentTitle tag:NULL map:NULL];
        if (itemsArr.count > 0) {
            Item_EN * item = itemsArr.firstObject;
            [self setItemDetailVWithItem:item startRect:CGRectMake(self.screenSize.width, self.screenSize.height, 32, 56)];
        }
    }
    
}

-(void)setItemDetailVWithItem:(Item_EN *) item startRect:(CGRect)startRect
{
    [self.itemDetailV resetWithItem:item startRect:startRect];
    
    if (self.itemDetailV.fromArrM.count > 0) {
        [self.itemDetailV.fromArrM enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj addTarget:self action:@selector(changeItemDetailV:) forControlEvents:UIControlEventTouchUpInside];
            NSLog(@"fromArrM add target");
        }];
    }
    if (self.itemDetailV.intoArrM.count > 0) {
        [self.itemDetailV.intoArrM enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj addTarget:self action:@selector(changeItemDetailV:) forControlEvents:UIControlEventTouchUpInside];
            NSLog(@"intoArrM add target");
        }];
    }
}
@end
