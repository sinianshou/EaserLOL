//
//  PerInfoTableVC.m
//  LOLHelper
//
//  Created by Easer Liu on 19/06/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "PerInfoTableVC.h"
#import "PerInfoCell.h"
#import "PerCategory.h"
#import "MenuControlH.h"
#import "BattleDetailVC.h"
#import "OptimizeLog.h"
#import "GetData.h"
#import "MatchList_CN+CoreDataClass.h"
#import "MatchListEntites_ENHeader.h"
#import "RefreshView.h"
#import "ChampionsBrief_EN+CoreDataClass.h"


@interface PerInfoTableVC ()

@property NSString * cellIdentifier;
@property (nonatomic,strong) UIView * perSectionHeader;
@property (nonatomic,strong) NSMutableDictionary * imgCache;
@property (nonatomic,strong) Player_EN * currentPlayer;
@property (nonatomic,strong) UIView * playerIconV;
@property (nonatomic,strong) RefreshView * perRefreshView;
@property (nonatomic,strong) UIButton * selectedButton;

@end

@implementation PerInfoTableVC
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self setTarBarItem];
    return self;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MatchList_EN * matchListResult = nil;
    BattleDetailVC * battleDetailVC = nil;
    switch (self.tableType) {
        case StatsType:
            if (indexPath.row > 1) {
                matchListResult = [self.fetchResults objectAtIndex:indexPath.row - 2];
                battleDetailVC = [[BattleDetailVC alloc] init];
                NSArray * gameArr = [GetData getMatchsWithGameId_EN:matchListResult.gameId];
                battleDetailVC.MatchResouce = gameArr.firstObject;
                [self presentViewController:battleDetailVC animated:YES completion:nil];
            }
            break;
        case AbilityType:
            
            break;
        case AssetType:
            
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgCache = [NSMutableDictionary dictionary];
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.defaultEdgeInsets = UIEdgeInsetsMake(0, 0, app.rootTabBarController.tabBar.bounds.size.height, 0);
    self.tableView.contentInset = self.defaultEdgeInsets;
    self.Origin = [[NSUserDefaults standardUserDefaults] stringForKey:@"origin_preference"].integerValue;
    
    [self setPerHeader];
    [self setNavigation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfoFinished:) name:@"UserInfoUpdateFinished" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (self.tableType) {
        case StatsType:
            return self.fetchResults.count + 2;
            break;
            
        case AbilityType:
            return 5;
            break;
            
        case AssetType:
            return 10;
            break;
            
        default:
            return 10;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PerInfoCell * cell = nil;
    
    switch (self.tableType) {
        case StatsType:
            cell = [self configueStatsTypeCell:cell atIndexPath:indexPath inTableView:tableView];
            
            break;
            
        case AbilityType:
            cell = [self configueAbilityTypeCell:cell atIndexPath:indexPath inTableView:tableView];
            break;
            
        case AssetType:
            
            break;
            
        default:
            break;
    }
    

    return cell;
}

-(PerInfoCell *)configueStatsTypeCell:(PerInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
    MatchList_EN * matchListResult = nil;
    NSMutableDictionary * dic = nil;
    NSArray * arr04 = [NSArray arrayWithObjects:@"0",@"None", nil];
    NSArray * arr05 = [NSArray arrayWithObjects:@"50%",@"500", nil];
    NSArray * __block arr01 = [NSArray arrayWithObjects:@"0",@"100", nil];
    NSArray * __block arr02 = [NSArray arrayWithObjects:@"1",@"100", nil];
    NSArray * __block arr03 = [NSArray arrayWithObjects:@"2",@"100", nil];
    NSArray * currentAcountArr = [GetData getSummonerEntityArr_EN];
    Player_EN * currentAcount = nil;
    NSMutableDictionary * defaultDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"default_head"],@"heroImgV", @"胜利",@"resultLa", @"经典匹配",@"matchTypeLa", @"9 / 9 / 9",@"killLa", @"06-22 16:45", @"timeLa", nil];
    NSArray *  stats_ENHonorkeys = [NSArray arrayWithObjects: @"mvpNum", @"chaoshenNum", @"pentaKNum", @"quadraKNum", @"tripleKNum", @"killsNum", @"assistsNum", @"wardsNum", nil];
    NSArray *  list_ENHonorkeys = [NSArray arrayWithObjects:@"chaoshen", @"quadraKills", @"killMost", @"tripleKills", @"damageMost", @"assistMost", @"minionMost", @"moneyMost",  @"takenMost", @"turretMost", nil];
    switch (indexPath.row) {
        case 0:
            dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:arr01,@"honorV01",arr02,@"honorV02",arr03,@"honorV03",arr04,@"leagueV",arr05,@"rateLa", nil];
            if (currentAcountArr) {
                currentAcount = currentAcountArr[0];
                int __block i = 1;
                [stats_ENHonorkeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (((NSString *)[currentAcount valueForKey:obj]).intValue > 0) {
                        switch (i) {
                            case 1:
                                arr01=[NSArray arrayWithObjects:obj,[currentAcount valueForKey:obj], nil];;
                                [dic setObject:arr01 forKey:@"honorV01"];
                                break;
                            case 2:
                                arr02=[NSArray arrayWithObjects:obj,[currentAcount valueForKey:obj], nil];;
                                [dic setObject:arr02 forKey:@"honorV02"];
                                break;
                            case 3:
                                arr03=[NSArray arrayWithObjects:obj,[currentAcount valueForKey:obj], nil];;
                                [dic setObject:arr03 forKey:@"honorV03"];
                                break;
                            default:
                                *stop = YES;
                                break;
                        }
                        i += 1;
                    }
                }];
                
                arr04 = [NSArray arrayWithObjects:currentAcount.ranked,currentAcount.ranked, nil];
                [dic setObject:arr04 forKey:@"leagueV"];
                arr05 = [NSArray arrayWithObjects:currentAcount.winRate,@"20", nil];
                [dic setObject:arr05 forKey:@"rateLa"];
            }
            break;
            
        case 1:
            dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"personal_win_4",@"lostOrWinImgV", nil];
            if (currentAcountArr) {
                currentAcount = currentAcountArr[0];
                [dic setObject:currentAcount.largestMultiWins forKey:@"lostOrWinImgV"];
            }
            break;
            
        default:
            cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
            dic = [NSMutableDictionary dictionaryWithDictionary:defaultDic];
            if (self.Origin == 20) {
                NSLog(@"self.Origin 为 EN，设置dic");
                if (self.fetchResults.count > 0) {
                    matchListResult = [self.fetchResults objectAtIndex:indexPath.row - 2];
                    [self updateMatchListChampionIconWithID:matchListResult.champion atIndexPath:indexPath inTableView:tableView];
                    if (matchListResult) {
                        if (matchListResult.gameMode != nil) {
                            [dic setObject:matchListResult.gameMode forKey:@"matchTypeLa"];
                        }else
                        {
                            NSLog(@"matchListResult.gameMode is nil");
                        }
                        
                        NSString * timeLa = [GetData convertTimeIntervalStrToString:matchListResult.gameCreation];
                        [dic setObject:timeLa forKey:@"timeLa"];
                        if (matchListResult.kills) {
                            [dic setObject:[NSString stringWithFormat:@"%@ / %@ / %@", matchListResult.kills, matchListResult.deaths, matchListResult.assists] forKey:@"killLa"];
                        }else
                        {
                            [dic setObject:[NSString stringWithFormat:@""] forKey:@"killLa"];
                        }
                        if (matchListResult.win) {
                            NSString * str = [matchListResult.win isEqualToString:@"1"]?@"Win":@"Defeat";
                            [dic setObject:str forKey:@"resultLa"];
                        }else
                        {
                            [dic setObject:@"ClickForDetail" forKey:@"resultLa"];
                        }
                        
                        int __block honorNum = 1;
                        NSString * __block honorKey = nil;
                        UIImage * __block honorImg = nil;
                        [list_ENHonorkeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([[matchListResult valueForKey:obj] intValue] > 0) {
                                honorKey = [NSString stringWithFormat:@"stateImgV0%d", honorNum];
                                honorImg = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@", obj]];
                                [dic setObject:honorImg forKey:honorKey];
                                if (honorNum == 3) {
                                    *stop = YES;
                                }
                                honorNum += 1;
                            }
                        }];
                    }
                }
            }else
            {
                NSLog(@"self.Origin 为 CN，设置dic");
            }
            
            break;
    }
    if (cell == nil) {
        cell = [[PerInfoCell alloc] initStatsCellWithIndexPath:indexPath];
    }
    if (cell.celltype == MatchListCellType) {
        self.cellIdentifier = cell.reuseIdentifier;
    }
    [cell configueStatsCellWithDic:dic atIndexPath:indexPath];
    
    self.tableView.estimatedRowHeight = cell.lastHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    return cell;
}

-(PerInfoCell *)configueAbilityTypeCell:(PerInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
    NSMutableDictionary * dic = nil;
    switch (indexPath.row) {
        case 0:
            dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"5", @"killsNum_ability", @"5", @"deathsNum_ability", @"5", @"assistsNum_ability", @"5", @"goldEarnedNum_ability", @"5", @"totalDamageTakenNum_ability", @"5", @"physicalDamageDealtToChampionsNum_ability", @"5", @"magicDamageDealtToChampionsNum_ability",@"ADC",@"goodRole", nil];
            if (self.currentPlayer) {
                [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if (![((NSString *)key) isEqualToString:@"goodRole"]) {
                        if ([self.currentPlayer valueForKey:key]) {
                            [dic setObject:[self.currentPlayer valueForKey:key] forKey:key];
                        }
                    }
                }];
            }
            break;
            
        case 1:
            dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"52", @"goodHero01ID", @"2000", @"goodHero01totalNum", @"50%", @"goodHero01winRate", @"52", @"goodHero02ID", @"2000", @"goodHero02totalNum", @"50%", @"goodHero02winRate", @"52", @"goodHero03ID", @"2000", @"goodHero03totalNum", @"50%", @"goodHero03winRate", @"52", @"goodHero04ID", @"2000", @"goodHero04totalNum", @"50%", @"goodHero04winRate", @"52", @"goodHero05ID", @"2000", @"goodHero05totalNum", @"50%", @"goodHero05winRate", nil];
            if (self.currentPlayer) {
                [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([self.currentPlayer valueForKey:key]) {
                        [dic setObject:[self.currentPlayer valueForKey:key] forKey:key];
                    }
                }];
            }
            break;
            
        case 2:
            dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"gameAlbumDes", @"0", @"gameAlbumButton01", @"0", @"gameAlbumButton02", @"0", @"gameAlbumButton03", @"0", @"gameAlbumButton04", nil];
            if (self.currentPlayer) {
                if (self.currentPlayer.doubleKNum.intValue > 0) {
                    [dic setObject:self.currentPlayer.doubleKNum forKey:@"gameAlbumButton04"];
                    [dic setObject:@"Double Kills !!!" forKey:@"gameAlbumDes"];
                }
                if (self.currentPlayer.tripleKNum.intValue > 0) {
                    [dic setObject:self.currentPlayer.tripleKNum forKey:@"gameAlbumButton03"];
                    [dic setObject:@"Triple Kills !!!" forKey:@"gameAlbumDes"];
                }
                if (self.currentPlayer.quadraKNum.intValue > 0) {
                    [dic setObject:self.currentPlayer.quadraKNum forKey:@"gameAlbumButton02"];
                    [dic setObject:@"Quadra Kills !!!" forKey:@"gameAlbumDes"];
                }
                if (self.currentPlayer.pentaKNum.intValue > 0) {
                    [dic setObject:self.currentPlayer.pentaKNum forKey:@"gameAlbumButton01"];
                    [dic setObject:@"Penta Kills !!!" forKey:@"gameAlbumDes"];
                }
            }
            break;
            
        case 3:
            dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"personal_win_3",@"lostOrWinImgV", nil];
            break;
            
        case 4:
            dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"personal_win_3",@"lostOrWinImgV", nil];
            break;
            
        default:
            break;
    }
    if (cell == nil) {
        cell = [[PerInfoCell alloc] initAbilityTypeCellWithIndexPath:indexPath];
    }
    [cell configueAbilityTypeCellWithDic:dic atIndexPath:indexPath];
    
    self.tableView.estimatedRowHeight = cell.lastHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    return cell;
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    UIView * perNaBar = [self.tableView.perSubviews objectForKey:@"perNaBar"];
    UILabel * prefile = [perNaBar.perSubviews objectForKey:@"prefile"];
    UIButton * areaBut = [perNaBar.perSubviews objectForKey:@"areaBut"];
    
    NSLog(@"contentOffset.y is %f",scrollView.contentOffset.y);
    CGSize scZ = [UIScreen mainScreen].bounds.size;
    CGFloat hei = scZ.width * 176 / 320 ;
    if (scrollView.contentOffset.y <= 0) {
        UIImageView * perInfoHeaderImgV = [self.perSectionHeader.perSubviews objectForKey:@"perInfoHeaderImgV"];
        CGFloat wid = (hei - scrollView.contentOffset.y)/ perInfoHeaderImgV.bounds.size.height;
        perInfoHeaderImgV.transform = CGAffineTransformMake(wid, 0,-0, wid, 0, scrollView.contentOffset.y/2);
        
        perNaBar.frame = CGRectMake(0, scrollView.contentOffset.y, perNaBar.frame.size.width, perNaBar.frame.size.height);
        areaBut.alpha = 1;
        self.playerIconV.alpha = 1;
        
        
        if (scrollView.contentOffset.y > -30) {
            self.perRefreshView.alpha = -scrollView.contentOffset.y/30;
            [self.perRefreshView downToRefresh];
        }else
        {
            [self.perRefreshView releaseToRefresh];
        }
    }else if (scrollView.contentOffset.y >= hei*2/3)
    {
        self.perSectionHeader.transform = CGAffineTransformMakeTranslation(0, scrollView.contentOffset.y - hei*2/3);
        areaBut.hidden = YES;
        prefile.hidden = NO;
        perNaBar.frame = CGRectMake(0, scrollView.contentOffset.y, perNaBar.frame.size.width, perNaBar.frame.size.height);
        self.playerIconV.hidden = YES;
    }else
    {
        self.perSectionHeader.transform = CGAffineTransformMakeTranslation(0, 0);
        perNaBar.frame = CGRectMake(0, scrollView.contentOffset.y, perNaBar.frame.size.width, perNaBar.frame.size.height);
        
        areaBut.hidden = NO;
        areaBut.alpha = 1-scrollView.contentOffset.y/(hei*2/3);
        prefile.hidden = YES;
        self.playerIconV.alpha = 1-scrollView.contentOffset.y/(hei*2/3);
        self.playerIconV.hidden = NO;
    }
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (self.perRefreshView.statu == ReleaseToRefresh) {
        self.tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
        [self refreshTableData];
    }
}
-(void)updateUserInfoFinished:(NSNotification *)notification
{
    if ([[NSThread currentThread] isMainThread]) {
        [self.perRefreshView finishRefreshing];
        self.tableView.contentInset = self.defaultEdgeInsets;
        [self performSelector:@selector(clickMenuButton:) withObject:self.selectedButton];
        [self refreshIconView];
        NSLog(@"刷新PerInfoTable界面");
    }else
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.perRefreshView finishRefreshing];
            self.tableView.contentInset = self.defaultEdgeInsets;
            [self performSelector:@selector(clickMenuButton:) withObject:self.selectedButton];
            [self refreshIconView];
            NSLog(@"刷新PerInfoTable界面");
        }];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisplayNotification" object:@"updateUserInfoFinished" userInfo:NULL];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.perRefreshView.statu == ReleaseToRefresh) {
        [self.perRefreshView refreshing];
    }
}

-(void)setTarBarItem
{
    UITabBarItem * perInfoTabBarItem = [[UITabBarItem alloc] initWithTitle:@"PerInfo" image:[[UIImage imageNamed:@"tab_icon_more_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:103];
    [perInfoTabBarItem setSelectedImage:[[UIImage imageNamed:@"tab_icon_more_press"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.tabBarItem = perInfoTabBarItem;
}

-(void)setPerHeader
{
    UIColor  *perColor = [UIColor colorWithRed:205/255.00 green:185/255.00 blue:130/255.00 alpha:1];
    UIImageView * perInfoHeaderImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_info_share_back_ground"]];
    perInfoHeaderImgV.perViewName = @"perInfoHeaderImgV";
    perInfoHeaderImgV.translatesAutoresizingMaskIntoConstraints =NO;
    
    NSArray * arr = [NSArray arrayWithObjects:@"Match", @"Ability", nil];
    MenuControlH * perInfoMenuControl = (MenuControlH *) [MenuControlH menuControlHWithNormalTitles:arr SelectedTitles:nil Images:nil];
    perInfoMenuControl.perViewName = @"perInfoMenuControl";
    perInfoMenuControl.translatesAutoresizingMaskIntoConstraints =NO;
    perInfoMenuControl.backgroundColor = [UIColor whiteColor];
    for (UIButton * b in perInfoMenuControl.subviews) {
        [b addTarget:self action:@selector(clickMenuButton:) forControlEvents:UIControlEventTouchUpInside];
        [b setTitleColor:perColor forState:UIControlStateSelected];
        if (b.tag == 0) {
            [self performSelector:@selector(clickMenuButton:) withObject:b];
        }
    }
    
    NSDictionary * summonerDic = [GetData getSummonerInfo_EN];
    NSString * summonerName = [NSString stringWithFormat:@"%@",[summonerDic objectForKey:@"name"]];
    NSString * summonerLevel = [NSString stringWithFormat:@"%@",[summonerDic objectForKey:@"summonerLevel"]];
    UILabel * nameLa = [[UILabel alloc] initWithName:@"nameLa"];
    nameLa.textAlignment = NSTextAlignmentCenter;
    [nameLa setTextColor:[UIColor whiteColor]];
    [nameLa setFont:[UIFont systemFontOfSize:10.0]];
    [nameLa setText:summonerName];
    UIButton * iconV = [[UIButton alloc] initWithName:@"iconV"];
    iconV.translatesAutoresizingMaskIntoConstraints = YES;
    iconV.frame = CGRectMake(0, 0, 57, 57);
    iconV.layer.cornerRadius = 28.5;
    iconV.layer.masksToBounds = YES;
    [iconV setBackgroundImage:[UIImage imageNamed:@"default_head"] forState:UIControlStateNormal];
    [iconV setImage:[UIImage imageNamed:@"personal_head_background"] forState:UIControlStateNormal];
    NSDictionary * accountPicDic = [GetData getSummonerPicDic_EN];
    [iconV setBackGroundImage:NULL NameKey:[accountPicDic objectForKey:@"NameKey"] inCache:NULL named:[accountPicDic objectForKey:@"NameKey"] WithContentsOfFile:[accountPicDic objectForKey:@"Path"] cacheFromURL:[accountPicDic objectForKey:@"URL"] forState:UIControlStateNormal];
    
    UIButton * levelV = [[UIButton alloc] initWithName:@"levelV"];
    levelV.translatesAutoresizingMaskIntoConstraints = YES;
    levelV.frame = CGRectMake(42, 42, 15 , 15);
    levelV.layer.cornerRadius = 7.5;
    levelV.layer.masksToBounds = YES;
    [levelV setBackgroundImage:[UIImage imageNamed:@"personal_Lv_background"] forState:UIControlStateNormal];
    [levelV setBackgroundColor:[UIColor blackColor]];
    [levelV setTitle:summonerLevel forState:UIControlStateNormal];
    [levelV.titleLabel setFont:[UIFont systemFontOfSize:7]];
    UIView * playerHeaderV = [[UIView alloc] initWithName:@"playerHeaderV"];
    playerHeaderV.bounds = CGRectMake(0, 0, 57, 77);
    nameLa.translatesAutoresizingMaskIntoConstraints = YES;
    nameLa.frame = CGRectMake(0, 67, 57, 10);
    [playerHeaderV perAddSubviews:iconV, levelV, nameLa,nil];
    self.playerIconV = playerHeaderV;
    
    RefreshView * refreshView = [RefreshView getRefreshView];
    refreshView.perViewName = [NSString stringWithFormat:@"refreshView"];
    refreshView.bounds = CGRectMake(0, 0, 100, 45);
    refreshView.translatesAutoresizingMaskIntoConstraints = NO;
    refreshView.alpha = 0;
    self.perRefreshView =refreshView;
    
    UIView * perInfoHeader = [[UIView alloc] initWithName:@"perInfoHeader"];
    [perInfoHeader perAddSubviews:perInfoHeaderImgV, perInfoMenuControl, playerHeaderV, refreshView, nil];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSString * vflV01 = [NSString stringWithFormat:@"V:|[%@(176)][%@(24)]|", perInfoHeaderImgV.perViewName, perInfoMenuControl.perViewName];
    NSString * vflV02 = [NSString stringWithFormat:@"V:|-24-[%@(45)]-10-[%@(77)]-20-[%@(24)]|", refreshView.perViewName, playerHeaderV.perViewName, perInfoMenuControl.perViewName];
    NSString * vflH01 = [NSString stringWithFormat:@"H:|[%@]|", perInfoHeaderImgV.perViewName];
    NSString * vflH02 = [NSString stringWithFormat:@"H:|[%@]|", perInfoMenuControl.perViewName];
    NSString * vflH03 = [NSString stringWithFormat:@"H:|-%d-[%@]", (int)((screenWidth - 57)/2), playerHeaderV.perViewName];
    NSString * vflH04 = [NSString stringWithFormat:@"H:|[%@]|", refreshView.perViewName];
    [perInfoHeader perAddConstraints:vflV01, vflV02, vflH01, vflH02, vflH03, vflH04, nil];
    
    self.perSectionHeader = perInfoHeader;
    [self.tableView perAddSubviews:perInfoHeader, nil];
    UIView * HV = [[UIView alloc] initWithName:@"HV"];
    HV.bounds = CGRectMake(0, 0, 320, 196);
    self.tableView.tableHeaderView = HV;
}
-(void)refreshIconView
{
    NSDictionary * summonerDic = [GetData getSummonerInfo_EN];
    NSString * summonerName = [NSString stringWithFormat:@"%@",[summonerDic objectForKey:@"name"]];
    NSString * summonerLevel = [NSString stringWithFormat:@"%@",[summonerDic objectForKey:@"summonerLevel"]];
    NSDictionary * accountPicDic = [GetData getSummonerPicDic_EN];
    UILabel * nameLa = [self.playerIconV.perSubviews objectForKey:@"nameLa"];
    UIButton * iconV = [self.playerIconV.perSubviews objectForKey:@"iconV"];
    UIButton * levelV = [self.playerIconV.perSubviews objectForKey:@"levelV"];
    nameLa.text =summonerName;
    [iconV setBackGroundImage:NULL NameKey:[accountPicDic objectForKey:@"NameKey"] inCache:NULL named:[accountPicDic objectForKey:@"NameKey"] WithContentsOfFile:[accountPicDic objectForKey:@"Path"] cacheFromURL:[accountPicDic objectForKey:@"URL"] forState:UIControlStateNormal];
    [levelV setTitle:summonerLevel forState:UIControlStateNormal];
}
-(void)clickMenuButton: (UIButton *) button
{
    switch (button.tag) {
        case 0:
            self.tableType = StatsType;
            self.fetchResults = [NSMutableArray arrayWithArray:[GetData getMatchListWithAccountId_EN:[[GetData getSummonerInfo_EN] objectForKey:@"accountId"]]];
            [self.tableView reloadData];
            
            break;
            
        case 1:
            self.tableType = AbilityType;
            self.fetchResults = [NSMutableArray arrayWithArray:[GetData getSummonerEntityArr_EN]];
            if (self.fetchResults.count > 0) {
                self.currentPlayer = [self.fetchResults firstObject];
            }
            [self.tableView reloadData];
            break;
            
        default:
            break;
            
    }
    self.selectedButton = button;
    NSLog(@"button tag is %ld",(long)button.tag);
}
-(void)setNavigation
{
    UIColor  *perColor = [UIColor colorWithRed:205/255.00 green:185/255.00 blue:130/255.00 alpha:1];
    CGSize scZ = [UIScreen mainScreen].bounds.size;
    CGFloat hei = scZ.width * 176 / 320 ;
    NSDictionary * summonerDic = [GetData getSummonerInfo_EN];
    NSString * summonerName = [NSString stringWithFormat:@"%@",[summonerDic objectForKey:@"name"]];
    NSString * summonerLevel = [NSString stringWithFormat:@"%@",[summonerDic objectForKey:@"summonerLevel"]];
    
    UIView * perNaBar =[[UIView alloc] initWithName:@"perNaBar"];
    perNaBar.translatesAutoresizingMaskIntoConstraints = YES;
    perNaBar.bounds = CGRectMake(0, 0, scZ.width, hei/3);
    perNaBar.frame = perNaBar.bounds;
    UILabel * prefile = [[UILabel alloc] initWithName:@"prefile"];
    prefile.textAlignment = NSTextAlignmentCenter;
    prefile.lineBreakMode = NSLineBreakByWordWrapping;
    prefile.numberOfLines = 2;
    NSString * prefileStr = [NSString stringWithFormat:@"%@ \n Lv%@ | TwistyForest", summonerName, summonerLevel];
    NSMutableAttributedString * prefileAttStr = [[NSMutableAttributedString alloc] initWithString:prefileStr];
    [prefileAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,summonerName.length + 3)];
    [prefileAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(summonerName.length + 3,prefileAttStr.length-summonerName.length - 3)];
    prefile.attributedText = prefileAttStr;
    prefile.textColor = perColor;
    prefile.translatesAutoresizingMaskIntoConstraints = YES;
    prefile.frame = perNaBar.bounds;
    prefile.hidden = YES;
    
    UIButton * areaBut = [[UIButton alloc] initWithName:@"areaBut"];
    [areaBut setTitle:@"TwistyForest" forState:UIControlStateNormal];
    [areaBut setTitleColor:perColor forState:UIControlStateNormal];
    areaBut.titleLabel.textAlignment = NSTextAlignmentCenter;
    areaBut.translatesAutoresizingMaskIntoConstraints = YES;
    areaBut.frame = perNaBar.bounds;
    [perNaBar perAddSubviews:prefile, areaBut, nil];
    
    UIButton * shareBut = [[UIButton alloc] initWithName:@"shareBut"];
    shareBut.bounds = CGRectMake(0, 0, 17.5, 19.5);
    [shareBut setImage:[UIImage imageNamed:@"businesscard_share"] forState:UIControlStateNormal];
    [perNaBar perAddSubviews:shareBut, nil];
    CGFloat rest = (perNaBar.bounds.size.height - 19.5)/2;
    NSString * vflVshareBut01 = [NSString stringWithFormat:@"V:|-%f-[%@(19.5)]", rest, shareBut.perViewName];
    NSString * vflHshareBut01 = [NSString stringWithFormat:@"H:[%@(17.5)]-%f-|", shareBut.perViewName, rest];
    [perNaBar perAddConstraints:vflVshareBut01, vflHshareBut01, nil];
    
    
    [self.tableView perAddSubviews:perNaBar, nil];
    [self.tableView bringSubviewToFront:perNaBar];
}


-(void)refreshTableData
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    self.Origin = [userDefault stringForKey:@"origin_preference"].integerValue;
    [GetData updateMatchListWithAccountId_EN:[[GetData getSummonerInfo_EN] objectForKey:@"accountId"]];
    NSLog(@"更新PerInfoTable数据");
}

-(void)updateMatchListChampionIconWithID:(NSString *)ID atIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
    NSString * cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSArray * arr = [GetData getChampionsBrife_ENWithId:ID];
    
    if (arr.count >0) {
        ChampionsBrief_EN * championsBrief_EN = [arr firstObject];
        
        NSURL * championIconURL = [GetData getChampionIconURLWithName_EN:championsBrief_EN.square];
        NSString * nameKey = [NSString stringWithFormat:@"championIcon_EN_%@.png", championsBrief_EN.id];
        NSString * championIconPath = [cachesDir stringByAppendingPathComponent:nameKey];
        UIImage * championIcon = [self.imgCache objectForKey:nameKey];
        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
            PerInfoCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
            UIImageView * championImgV = [cell.perSubviews objectForKey:@"heroImgV"];
            
            [championImgV setImage:championIcon NameKey:nameKey inCache:self.imgCache named:nameKey WithContentsOfFile:championIconPath cacheFromURL:championIconURL];
            if (![self.imgCache objectForKey:nameKey] && [UIImage imageWithContentsOfFile:championIconPath]) {
                [self.imgCache setObject:[UIImage imageWithContentsOfFile:championIconPath] forKey:nameKey];
            }
        }];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
