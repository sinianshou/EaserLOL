//
//  BattleDetailVC.m
//  LOLHelper
//
//  Created by Easer Liu on 03/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "BattleDetailVC.h"
#import "BattelDetailContentVCDelegate.h"
#import "GetData.h"
#import "ParticipantDetailV.h"
#import "PerScrollView.h"
#import "PerCategory.h"
#import "GoldEventsModel.h"
#import "TimeLineHeaderControl.h"
#import "ChampIconButton.h"


@interface BattleDetailVC ()<ContentVCDelegatePro, UIScrollViewDelegate>


@property (strong, nonatomic)  UIView *HeaderV;
@property (strong, nonatomic)  UIScrollView *ContentV;
@property (strong, nonatomic)  UIScrollView *DetailV;
@property (strong, nonatomic)  UIScrollView *DataV;
@property (strong, nonatomic)  UIScrollView *BriefV;

@property (strong, nonatomic)  UIView *LastDetailV;
@property (strong, nonatomic)  UIView *LastDataV;
@property (strong, nonatomic)  UIView *LastKillsmapV;

@property (assign, nonatomic) CGSize ScreenSize;
@property (strong, nonatomic) NSString * cachesDir;
@property (strong, nonatomic) NSMutableDictionary * picCache;

@property (strong, nonatomic) BattelDetailContentVCDelegate * battelDetailContentVCDelegate;
@property (strong, nonatomic) UIImageView * slipV;
@property (strong, nonatomic) UILabel * timeLa;
@property (strong, nonatomic) UIButton * DetailBut;
@property (strong, nonatomic) UIButton * DataBut;
@property (strong, nonatomic) UIButton * BriefBut;

@property (strong, nonatomic) UILabel * winTeamGoldEarned;
@property (strong, nonatomic) UILabel * failTeamGoldEarned;

@property (strong, nonatomic) NSMutableDictionary * ParticipantDetailVDicM;
@property (strong, nonatomic) NSMutableDictionary * goldEventsModelDicM;
@property (strong, nonatomic) UIView * TimeLineImgVHeader;
@property (strong, nonatomic) NSMutableArray <TimeLineHeaderControl *> * timeLineHeaderControlArr;
@property (strong, nonatomic) NSMutableArray <UIButton *>* timeLineButtonsArrM;
@property (strong, nonatomic) UIImageView * timeLineImgV;


@property (strong, nonatomic) UIImageView * killsMapImgV;
@property (strong, nonatomic) NSMutableArray <UIButton *>* killedButtonsArrM;

@end

@implementation BattleDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initControlls];
    [self configureControls];
    [self layoutViews];
    
    
}

-(void)initControlls
{
    self.cachesDir =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    self.ScreenSize = [UIScreen mainScreen].bounds.size;
    self.picCache = [NSMutableDictionary dictionary];
    self.timeLineHeaderControlArr = [NSMutableArray array];
    self.timeLineButtonsArrM = [NSMutableArray array];
    self.ParticipantDetailVDicM = [NSMutableDictionary dictionary];
    self.killedButtonsArrM = [NSMutableArray array];
    
    self.HeaderV = [[UIView alloc] init];
    self.ContentV = [[UIScrollView alloc] init];
    self.DetailV = [[UIScrollView alloc] init];
    self.DataV = [[UIScrollView alloc] init];
    self.BriefV = [[UIScrollView alloc] init];
    
    self.ContentV.pagingEnabled = YES;
    self.ContentV.delegate = self;
    self.ContentV.showsHorizontalScrollIndicator = NO;
    //    self.battelDetailContentVCDelegate = [[BattelDetailContentVCDelegate alloc] init];
    //    self.battelDetailContentVCDelegate.contentVCDelegatePro = self;
    //    self.ContentV.delegate = self.battelDetailContentVCDelegate;
    
    [self.view addSubview:self.HeaderV];
    [self.view addSubview:self.ContentV];
    [self.ContentV addSubview:self.DetailV];
    [self.ContentV addSubview:self.DataV];
    [self.ContentV addSubview:self.BriefV];
}

-(void)click01
{
    NSLog(@"touch participantDetailV01");
    NSLog(@"picCache counts is %d", (int)self.picCache.count);
    
}
-(void)click02
{
    NSLog(@"touch participantDetailV02");
}

-(UIButton *)creatButtonWithTitle:(NSString *)title Frame:(CGRect)frame SEL:(SEL)selector
{
    UIButton * but = [[UIButton alloc] init];
    but.frame = frame;
    [but setTitle:title forState:UIControlStateNormal];
    [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [but setTitleColor:[UIColor colorWithRed:205/255.00 green:185/255.00 blue:130/255.00 alpha:1] forState:UIControlStateSelected];
    but.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [but addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return but;
}

-(void)configureControls
{
    
    [self configureHeaderV];
    [self configureContentV];
    [self configureDetailV];
    [self configureDataV];
    [self configureBriefV];
}
-(void)configureHeaderV
{
    UIButton * backButton =[self creatButtonWithTitle:@"    Back"  Frame:CGRectMake(0, 0, 50, 32) SEL:@selector(backViewAction)];
    [backButton setTitleColor:[UIColor colorWithRed:205/255.00 green:185/255.00 blue:130/255.00 alpha:1] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"nav_btn_back_normal"] forState:UIControlStateNormal];
//    [self.HeaderV addSubview:backButton];
    self.timeLa = [[UILabel alloc] initWithFrame:CGRectMake(backButton.frame.origin.x + backButton.frame.size.width, backButton.frame.origin.y, self.ScreenSize.width - backButton.frame.size.width, backButton.frame.size.height)];
    self.timeLa.adjustsFontSizeToFitWidth = YES;
    NSString * timeSre = [NSString stringWithFormat:@"    %@   |   %dmins   |   %@    ",[GetData convertTimeIntervalStrToString:self.MatchResouce.gameCreation],self.MatchResouce.gameDuration.intValue/60,self.MatchResouce.gameMode];
    NSDictionary *attrDict01 = @{NSBaselineOffsetAttributeName: @(1),//设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏，解决UILabel文本竖直居中
                                 NSStrokeWidthAttributeName: @(-2),
                                 NSForegroundColorAttributeName: [UIColor grayColor],
                                 NSFontAttributeName: [UIFont systemFontOfSize: 15] };
    self.timeLa.attributedText = [[NSAttributedString alloc] initWithString: timeSre attributes: attrDict01];
//    [self.HeaderV addSubview:self.timeLa];
    UIView * subHeaderV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ScreenSize.width, self.timeLa.frame.origin.y + self.timeLa.frame.size.height)];
    subHeaderV.backgroundColor = [UIColor colorWithRed:210/225.00 green:210/225.00 blue:210/225.00 alpha:1];
    [subHeaderV addSubview:backButton];
    [subHeaderV addSubview:self.timeLa];
    [self.HeaderV addSubview:subHeaderV];
    
    self.DetailBut =[self creatButtonWithTitle:@"Detail"  Frame:CGRectMake(self.ScreenSize.width*0/3,backButton.frame.origin.y + backButton.frame.size.height, self.ScreenSize.width/3, 20) SEL:@selector(ContentVtoDetail)];
    self.DetailBut.selected = YES;
    [self.HeaderV addSubview:self.DetailBut];
    self.DataBut =[self creatButtonWithTitle:@"Data"  Frame:CGRectMake(self.ScreenSize.width*1/3,backButton.frame.origin.y + backButton.frame.size.height, self.ScreenSize.width/3, 20) SEL:@selector(ContentVtoData)];
    [self.HeaderV addSubview:self.DataBut];
    self.BriefBut =[self creatButtonWithTitle:@"Brief"  Frame:CGRectMake(self.ScreenSize.width*2/3,backButton.frame.origin.y + backButton.frame.size.height, self.ScreenSize.width/3, 20) SEL:@selector(ContentVtoBrief)];
    [self.HeaderV addSubview:self.BriefBut];
    self.slipV = [[UIImageView alloc] init];
    self.slipV.bounds = CGRectMake(0, 0, 39, 5.5);
    UIImage * slipI = [UIImage imageNamed:@"tab_selected"];
    self.slipV.image = slipI;
    self.slipV.center = CGPointMake(self.DetailBut.center.x, self.DetailBut.center.y + self.DetailBut.bounds.size.height/2 + self.slipV.bounds.size.height/2);
    [self.HeaderV addSubview:self.slipV];
    NSLog(@"self.HeaderV.bounds is %f %f %f %f",self.HeaderV.bounds.origin.x, self.HeaderV.bounds.origin.y, self.HeaderV.bounds.size.width, self.HeaderV.bounds.size.height);
    NSLog(@"self.HeaderV subViews has %d count",(int)self.HeaderV.subviews.count);
    
    self.HeaderV.backgroundColor = [UIColor whiteColor];
    self.HeaderV.layer.borderWidth = 1;
    self.HeaderV.layer.borderColor = [UIColor colorWithRed:210/225.00 green:210/225.00 blue:210/225.00 alpha:1].CGColor;
//    self.HeaderV.backgroundColor = [UIColor colorWithRed:210/225.00 green:210/225.00 blue:210/225.00 alpha:1];
}
-(void)configureContentV
{
    self.ContentV.backgroundColor = [UIColor colorWithRed:210/225.00 green:210/225.00 blue:210/225.00 alpha:1];
}
-(void)configureDetailV
{
//    self.DetailV.backgroundColor = [UIColor redColor];
    
    UIView * Br = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ScreenSize.width, 45)];
    Br.backgroundColor = [UIColor whiteColor];
    [self.DetailV addSubview:Br];
    CGRect __block rect = Br.frame;
    
    [self.MatchResouce.matchToTeams enumerateObjectsUsingBlock:^(Team_EN * _Nonnull obj, BOOL * _Nonnull stop) {
        Team_EN * team = obj;
        NSArray <NSString *>* brImgStrArr = [NSArray arrayWithObjects:@"baronKills", @"dragonKills", @"towerKills", @"inhibitorKills", nil];
        NSEnumerator *enumerator = [brImgStrArr objectEnumerator];
        NSString * brImgStr = nil;
        int perIndex = 0;
        if (CGRectEqualToRect(rect, Br.frame)) {
            UIImageView * midV = [[UIImageView alloc] init];
            midV.bounds = CGRectMake(0, 0, 25, 16);
            midV.image = [UIImage imageNamed:[NSString stringWithFormat:@"battle_detail_score_we_%@", obj.win]];
            midV.center = CGPointMake(Br.bounds.size.width/2, Br.bounds.size.height/2);
            [Br addSubview:midV];
            
            while(brImgStr = [enumerator nextObject]){
                UIImageView * dragonV = [[UIImageView alloc] init];
                dragonV.bounds = CGRectMake(0, 0, 13, 13);
                dragonV.center = CGPointMake(self.ScreenSize.width/20+self.ScreenSize.width/10*perIndex, 10 + dragonV.bounds.size.height/2);
                perIndex+=1;
                dragonV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@", brImgStr, obj.win]];
                [Br addSubview:dragonV];
                UILabel * numLa = [[UILabel alloc] init];
                numLa.font = [UIFont systemFontOfSize:8];
                numLa.text = [obj valueForKey:brImgStr];
                [numLa sizeToFit];
                numLa.center = CGPointMake(dragonV.center.x, dragonV.center.y + dragonV.bounds.size.height/2 + 5 + numLa.bounds.size.height/2);
                [Br addSubview:numLa];
            }
        }else
        {
            while(brImgStr = [enumerator nextObject]){
                UIImageView * dragonV = [[UIImageView alloc] init];
                dragonV.bounds = CGRectMake(0, 0, 13, 13);
                dragonV.center = CGPointMake(self.ScreenSize.width*19/20-self.ScreenSize.width/10*perIndex, 10 + dragonV.bounds.size.height/2);
                perIndex+=1;
                dragonV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%@", brImgStr, obj.win]];
                [Br addSubview:dragonV];
                UILabel * numLa = [[UILabel alloc] init];
                numLa.font = [UIFont systemFontOfSize:8];
                numLa.text = [obj valueForKey:brImgStr];
                [numLa sizeToFit];
                numLa.center = CGPointMake(dragonV.center.x, dragonV.center.y + dragonV.bounds.size.height/2 + 5 + numLa.bounds.size.height/2);
                [Br addSubview:numLa];
            }
        }
        
        UIView * team100 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.ScreenSize.width, 28)];
        team100.backgroundColor = [UIColor colorWithRed:210/225.00 green:210/225.00 blue:210/225.00 alpha:1];
        [self.DetailV addSubview:team100];
        team100.center = CGPointMake(rect.size.width/2, rect.origin.y + rect.size.height + team100.frame.size.height/2);
        rect = team100.frame;
        int __block totalKills = 0;
        int __block totalDeathes = 0;
        int __block totalAssists = 0;
        int __block totalMoney = 0;
        [team.teamToParticipants enumerateObjectsUsingBlock:^(Participant_EN * _Nonnull obj, BOOL * _Nonnull stop) {
            ParticipantDetailV * par01 = [[ParticipantDetailV alloc] init];
            par01.teamId = team.teamId;
            par01.participantId = obj.participantId;
            par01.win = team.win;
            [self.ParticipantDetailVDicM setObject:par01 forKey:obj.participantId];
            par01.center = CGPointMake(rect.size.width/2, rect.origin.y + rect.size.height +  par01.frame.size.height/2);
            [par01 addTarget:self action:@selector(changeDetailVBounds:) forControlEvents:UIControlEventTouchUpInside];
            rect = par01.frame;
            [self.DetailV addSubview:par01];
            self.LastDetailV = par01;
            
            if (obj.summonerName == nil) {
                NSArray <ChampionsBrief_EN *>* briefArr = [GetData getChampionsBrife_ENWithId:obj.championId];
                if (briefArr.count > 0) {
                    ChampionsBrief_EN * brief = [briefArr firstObject];
                    par01.summonerName.text = brief.name;
                }
            }else
            {
                par01.summonerName.text = obj.summonerName;
            }
            
            NSArray * arr = [GetData getChampionsBrife_ENWithId:obj.championId];
            if (arr.count >0) {
                ChampionsBrief_EN * championsBrief_EN = [arr firstObject];
                NSDictionary * picDic = [GetData getChampPicDicImageName_EN:championsBrief_EN.square];
                [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                    [par01.ChampIcon setImage:NULL NameKey:[picDic objectForKey:@"NameKey"] inCache:self.picCache named:[picDic objectForKey:@"NameKey"] WithContentsOfFile:[picDic objectForKey:@"Path"] cacheFromURL:[picDic objectForKey:@"URL"]];
                }];
                
            }
            par01.goldEarned.text = obj.goldEarned;
            par01.kda.text = [NSString stringWithFormat:@"%@/%@/%@", obj.kills, obj.deaths, obj.assists];
            totalMoney += obj.goldEarned.intValue;
            totalKills += obj.kills.intValue;
            totalDeathes += obj.deaths.intValue;
            totalAssists += obj.assists.intValue;
            
            if (obj.item0 != nil) {
                NSArray <Item_EN *>* itemsArr0 = [GetData getItem_ENWithId:obj.item0 tag:NULL map:NULL];
                if (itemsArr0.count > 0) {
                    //NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:iconNameKey, @"NameKey", iconPath, @"Path", iconURL, @"URL", nil];
                    Item_EN * item =[itemsArr0 firstObject];
                    NSDictionary * dic = [GetData getItemPicDicImageName_EN:item.square];
                    [par01.item0 setImage:NULL NameKey:[dic objectForKey:@"NameKey"] inCache:NULL named:[dic objectForKey:@"NameKey"] WithContentsOfFile:[dic objectForKey:@"Path"] cacheFromURL:[dic objectForKey:@"URL"]];
                }
            }
            
            if (obj.item1 != nil) {
                NSArray <Item_EN *>* itemsArr1 = [GetData getItem_ENWithId:obj.item1 tag:NULL map:NULL];
                if (itemsArr1.count > 0) {
                    //NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:iconNameKey, @"NameKey", iconPath, @"Path", iconURL, @"URL", nil];
                    Item_EN * item =[itemsArr1 firstObject];
                    NSDictionary * dic = [GetData getItemPicDicImageName_EN:item.square];
                    [par01.item1 setImage:NULL NameKey:[dic objectForKey:@"NameKey"] inCache:NULL named:[dic objectForKey:@"NameKey"] WithContentsOfFile:[dic objectForKey:@"Path"] cacheFromURL:[dic objectForKey:@"URL"]];
                }
            }
            if (obj.item2 != nil) {
                NSArray <Item_EN *>* itemsArr2 = [GetData getItem_ENWithId:obj.item2 tag:NULL map:NULL];
                if (itemsArr2.count > 0) {
                    //NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:iconNameKey, @"NameKey", iconPath, @"Path", iconURL, @"URL", nil];
                    Item_EN * item =[itemsArr2 firstObject];
                    NSDictionary * dic = [GetData getItemPicDicImageName_EN:item.square];
                    [par01.item2 setImage:NULL NameKey:[dic objectForKey:@"NameKey"] inCache:NULL named:[dic objectForKey:@"NameKey"] WithContentsOfFile:[dic objectForKey:@"Path"] cacheFromURL:[dic objectForKey:@"URL"]];
                }
            }
            if (obj.item3 != nil) {
                NSArray <Item_EN *>* itemsArr3 = [GetData getItem_ENWithId:obj.item3 tag:NULL map:NULL];
                if (itemsArr3.count > 0) {
                    //NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:iconNameKey, @"NameKey", iconPath, @"Path", iconURL, @"URL", nil];
                    Item_EN * item =[itemsArr3 firstObject];
                    NSDictionary * dic = [GetData getItemPicDicImageName_EN:item.square];
                    [par01.item3 setImage:NULL NameKey:[dic objectForKey:@"NameKey"] inCache:NULL named:[dic objectForKey:@"NameKey"] WithContentsOfFile:[dic objectForKey:@"Path"] cacheFromURL:[dic objectForKey:@"URL"]];
                }
            }
            if (obj.item4 != nil) {
                NSArray <Item_EN *>* itemsArr4 = [GetData getItem_ENWithId:obj.item4 tag:NULL map:NULL];
                if (itemsArr4.count > 0) {
                    //NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:iconNameKey, @"NameKey", iconPath, @"Path", iconURL, @"URL", nil];
                    Item_EN * item =[itemsArr4 firstObject];
                    NSDictionary * dic = [GetData getItemPicDicImageName_EN:item.square];
                    [par01.item4 setImage:NULL NameKey:[dic objectForKey:@"NameKey"] inCache:NULL named:[dic objectForKey:@"NameKey"] WithContentsOfFile:[dic objectForKey:@"Path"] cacheFromURL:[dic objectForKey:@"URL"]];
                }
            }
            if (obj.item5 != nil) {
                NSArray <Item_EN *>* itemsArr5 = [GetData getItem_ENWithId:obj.item5 tag:NULL map:NULL];
                if (itemsArr5.count > 0) {
                    //NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:iconNameKey, @"NameKey", iconPath, @"Path", iconURL, @"URL", nil];
                    Item_EN * item =[itemsArr5 firstObject];
                    NSDictionary * dic = [GetData getItemPicDicImageName_EN:item.square];
                    [par01.item5 setImage:NULL NameKey:[dic objectForKey:@"NameKey"] inCache:NULL named:[dic objectForKey:@"NameKey"] WithContentsOfFile:[dic objectForKey:@"Path"] cacheFromURL:[dic objectForKey:@"URL"]];
                }
            }
            if (obj.item6 != nil) {
                NSArray <Item_EN *>* itemsArr6 = [GetData getItem_ENWithId:obj.item6 tag:NULL map:NULL];
                if (itemsArr6.count > 0) {
                    //NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:iconNameKey, @"NameKey", iconPath, @"Path", iconURL, @"URL", nil];
                    Item_EN * item =[itemsArr6 firstObject];
                    NSDictionary * dic = [GetData getItemPicDicImageName_EN:item.square];
                    [par01.item6 setImage:NULL NameKey:[dic objectForKey:@"NameKey"] inCache:NULL named:[dic objectForKey:@"NameKey"] WithContentsOfFile:[dic objectForKey:@"Path"] cacheFromURL:[dic objectForKey:@"URL"]];
                }
            }
            
            NSArray *  list_ENHonorkeys = [NSArray arrayWithObjects:@"chaoshen", @"quadraKills", @"killMost", @"tripleKills", @"damageMost", @"assistMost", @"minionMost", @"moneyMost",  @"takenMost", @"turretMost", @"pentaKills", @"mvp", nil];
            UIImage * __block honorImg = nil;
            Participant_EN * parClass = obj;
            CGRect __block statsImgVRect = CGRectZero;
            [list_ENHonorkeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[parClass valueForKey:obj] intValue] > 0) {
                    honorImg = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@", obj]];
                    UIImageView * statsImgV = [[UIImageView alloc] init];
                    statsImgV.image = honorImg;
                    if (honorImg == nil) {
                        NSLog(@"null honorImg is %@",[NSString stringWithFormat:@"icon_%@", obj]);
                    }
                    //  59*38 63*38
                    if (idx < list_ENHonorkeys.count - 2) {
                        statsImgV.bounds = CGRectMake(0, 0, 13, 13);
                    }else if(idx == list_ENHonorkeys.count - 2)
                    {
                        statsImgV.bounds = CGRectMake(0, 0, 20, 13);
                    }else
                    {
                        statsImgV.bounds = CGRectMake(0, 0, 21, 13);
                    }
                    if (CGRectEqualToRect(statsImgVRect, CGRectZero)) {
                        statsImgV.center = CGPointMake(par01.ChampIcon.frame.origin.x + par01.ChampIcon.frame.size.width + 10 + statsImgV.bounds.size.width/2,par01.summonerName.frame.origin.y + par01.summonerName.frame.size.height + 10);
                    }else
                    {
                        statsImgV.center = CGPointMake(statsImgVRect.origin.x + statsImgVRect.size.width + 5 + statsImgV.bounds.size.width/2, statsImgVRect.origin.y + statsImgVRect.size.height - statsImgV.bounds.size.height/2);
                    }
                    
                    statsImgVRect = statsImgV.frame;
                    [par01.View01 addSubview:statsImgV];
                }
            }];
            
            par01.View02Text = [NSString stringWithFormat:@"TotalMinionsKilled: %@ \nLargestMultiKill:%@ \nTotalHeal: %@\nTotalDamageDealt: %@\nTotalDamageTaken: %@\nWardsPlaced/Killed: %@/%@", obj.totalMinionsKilled, obj.largestMultiKill, obj.totalHeal, obj.totalDamageDealt, obj.totalDamageTaken, obj.wardsPlaced, obj.wardsKilled];
            par01.View02La.text = par01.View02Text;
            [par01.spell1Id setImage:[UIImage imageNamed:[NSString stringWithFormat:@"SummonerSpell_%@", obj.spell1Id]]];
            [par01.spell2Id setImage:[UIImage imageNamed:[NSString stringWithFormat:@"SummonerSpell_%@", obj.spell2Id]]];
            [par01 layoutView02];
        }];
        //78*56
        
        UIImageView * headImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 39, 28)];
        UILabel * teamKDA = [[UILabel alloc] init];
        teamKDA.bounds = CGRectMake(0, 0, 50, 10);
        teamKDA.font = [UIFont systemFontOfSize:8];
        teamKDA.text = [NSString stringWithFormat:@"%d/%d/%d", totalKills, totalDeathes, totalAssists];
        
         NSLog(@" teamKDA.frame.origin.x is %f teamKDA.frame.size.width is %f ",teamKDA.frame.origin.x,teamKDA.frame.size.width );
        [teamKDA sizeToFit];
        teamKDA.center = CGPointMake(team100.bounds.size.width - (10 + teamKDA.bounds.size.width/2), team100.bounds.size.height/2);
        UIImageView * kdaImg = [[UIImageView alloc] initWithFrame:CGRectMake(teamKDA.frame.origin.x-20, teamKDA.frame.origin.y, 10, 10)];
        NSLog(@" teamKDA.frame.origin.x is %f teamKDA.frame.size.width is %f kdaImg.frame.origin.x is %f",teamKDA.frame.origin.x,teamKDA.frame.size.width, kdaImg.frame.origin.x );
        UILabel * teamGoldEarned = [[UILabel alloc] init];
        teamGoldEarned.font = [UIFont systemFontOfSize:8];
        teamKDA.bounds = CGRectMake(0, 0, 50, 10);
        teamGoldEarned.text = [NSString stringWithFormat:@"%d", totalMoney];
        [teamGoldEarned sizeToFit];
        teamGoldEarned.center = CGPointMake(kdaImg.frame.origin.x - 10 - teamGoldEarned.bounds.size.width/2, kdaImg.center.y);
        UIImageView * goldImg = [[UIImageView alloc] initWithFrame:CGRectMake(teamGoldEarned.frame.origin.x - 14, teamGoldEarned.frame.origin.y, 10, 10)];
        [team100 addSubview:headImgV];
        [team100 addSubview:teamKDA];
        [team100 addSubview:kdaImg];
        [team100 addSubview:teamGoldEarned];
        [team100 addSubview:goldImg];
        if ([obj.win isEqualToString:@"Win"]) {
            headImgV.image = [UIImage imageNamed:@"battle_detail_header_win"];
            kdaImg.image = [UIImage imageNamed:@"battle_detail_win_kill_icon"];
            goldImg.image = [UIImage imageNamed:@"battle_detail_win_money_icon"];
            self.winTeamGoldEarned = teamGoldEarned;
        }else
        {
            headImgV.image = [UIImage imageNamed:@"battle_detail_header_lose"];
            kdaImg.image = [UIImage imageNamed:@"battle_detail_lose_kill_icon"];
            goldImg.image = [UIImage imageNamed:@"battle_detail_lose_money_icon"];
            self.failTeamGoldEarned = teamGoldEarned;
        }
        
        NSLog(@"obj.win is %@", obj.win);
    }];
    
}
-(void)configureDataV
{
    UIColor * blueColor = [UIColor colorWithRed:0/255.00 green:169/255.00 blue:184/255.00 alpha:1];
    UIColor * lightblueColor = [UIColor colorWithRed:139/255.00 green:226/255.00 blue:226/255.00 alpha:0.8];
    UIColor * redColor = [UIColor colorWithRed:255/255.00 green:105/255.00 blue:109/255.00 alpha:1];
    UIColor * lightredColor = [UIColor colorWithRed:240/255.00 green:150/255.00 blue:150/255.00 alpha:0.8];
    UIColor * lightGray = [UIColor colorWithRed:210/225.00 green:210/225.00 blue:210/225.00 alpha:1];
    self.DataV.backgroundColor = [UIColor whiteColor];
    
    UIImageView * teamGoldimgV = [[UIImageView alloc] init];
    teamGoldimgV.bounds = CGRectMake(0, 0, self.ScreenSize.width, 20);
    teamGoldimgV.center = CGPointMake(CGRectGetMidX(teamGoldimgV.bounds), CGRectGetMidY(teamGoldimgV.bounds));
    for (int i = 0; i < 2; i++) {
        UILabel * goldLa = [[UILabel alloc] init];
        goldLa.textColor = [UIColor whiteColor];
        goldLa.font = [UIFont systemFontOfSize:teamGoldimgV.bounds.size.height*0.6];
        [teamGoldimgV addSubview:goldLa];
        switch (i) {
            case 0:
                goldLa.text = [NSString stringWithFormat:@"Victory %@", self.winTeamGoldEarned.text];
                [goldLa sizeToFit];
                goldLa.center = CGPointMake(CGRectGetMidX(goldLa.bounds) + 10, CGRectGetMidY(teamGoldimgV.bounds));
                break;
                
            default:
                goldLa.text = [NSString stringWithFormat:@"%@ Defeated",self.failTeamGoldEarned.text];
                [goldLa sizeToFit];
                goldLa.center = CGPointMake(CGRectGetMaxX(teamGoldimgV.bounds) - (CGRectGetMidX(goldLa.bounds) + 10), CGRectGetMidY(teamGoldimgV.bounds));
                break;
        }
    }
    teamGoldimgV.image = [self createTeamGoldRateImgWithBlueGold:self.winTeamGoldEarned.text RedGold:self.failTeamGoldEarned.text Size:teamGoldimgV.bounds.size];
    [self.DataV addSubview:teamGoldimgV];
    self.LastDataV =teamGoldimgV;
    
    
    for (int i = 0; i < 2; i++) {
        TimeLineHeaderControl * timeLineHeaderControl = [[TimeLineHeaderControl alloc] initWithFrame:CGRectMake(self.ScreenSize.width/2*i, CGRectGetMaxY(teamGoldimgV.frame), self.ScreenSize.width/2, 40)];
        [timeLineHeaderControl addTarget:self action:@selector(showTimeLineImgVHeader:) forControlEvents:UIControlEventTouchUpInside];
        [self.DataV addSubview:timeLineHeaderControl];
        [self.timeLineHeaderControlArr addObject:timeLineHeaderControl];
        self.LastDataV =timeLineHeaderControl;
    }
    [self.MatchResouce.matchToTeams enumerateObjectsUsingBlock:^(Team_EN * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.win isEqualToString:@"Win"]) {
            [self.timeLineHeaderControlArr firstObject].teamId = obj.teamId;
            [self.timeLineHeaderControlArr firstObject].participantId = [NSString stringWithFormat:@"%d", ((NSString *)obj.teamId).intValue/100+10];
            [self.timeLineHeaderControlArr firstObject].iconV.backgroundColor = blueColor;
            [self.timeLineHeaderControlArr firstObject].iconV.layer.borderColor = blueColor.CGColor;
            [self.timeLineHeaderControlArr firstObject].iconV.layer.borderWidth = 3.00;
            [self.timeLineHeaderControlArr firstObject].nameLa.text = [NSString stringWithFormat:@"Victory"];
            [self.timeLineHeaderControlArr firstObject].nameLa.textColor = blueColor;
        }else
        {
            [self.timeLineHeaderControlArr lastObject].teamId = obj.teamId;
            [self.timeLineHeaderControlArr lastObject].participantId = [NSString stringWithFormat:@"%d", ((NSString *)obj.teamId).intValue/100+10];
            [self.timeLineHeaderControlArr lastObject].iconV.backgroundColor = redColor;
            [self.timeLineHeaderControlArr lastObject].iconV.layer.borderColor = redColor.CGColor;
            [self.timeLineHeaderControlArr lastObject].iconV.layer.borderWidth = 3.00;
            [self.timeLineHeaderControlArr lastObject].nameLa.text = [NSString stringWithFormat:@"Defeated"];
            [self.timeLineHeaderControlArr lastObject].nameLa.textColor = redColor;
        }
    }];
    self.TimeLineImgVHeader = [[UIView alloc] init];
    self.TimeLineImgVHeader.bounds = CGRectMake(0, 0, self.ScreenSize.width, 60);
    self.TimeLineImgVHeader.backgroundColor = lightGray;
    self.TimeLineImgVHeader.center = CGPointMake(CGRectGetMidX(self.TimeLineImgVHeader.bounds), CGRectGetMaxY(self.LastDataV.frame) + CGRectGetMidY(self.TimeLineImgVHeader.bounds));
    for (int i = 0; i < 6; i++) {
        UIButton * button = [[UIButton alloc] init];
        button.bounds = CGRectMake(0, 0, 40, 40);
        button.layer.cornerRadius = CGRectGetMidY(button.bounds);
        button.layer.masksToBounds = YES;
        button.center = CGPointMake(self.TimeLineImgVHeader.bounds.size.width*(1/12.00 + 1/6.00*i), CGRectGetMidY(self.TimeLineImgVHeader.bounds));
        NSLog(@"button.center is %f %f", button.center.x, button.center.y);
        [self.TimeLineImgVHeader addSubview:button];
        [button addTarget:self action:@selector(configureTimeLineImgV:) forControlEvents:UIControlEventTouchUpInside];
        [self.timeLineButtonsArrM addObject:button];
    }
    self.TimeLineImgVHeader.hidden = YES;
    [self.DataV addSubview:self.TimeLineImgVHeader];
    
    self.goldEventsModelDicM = (NSMutableDictionary *)self.MatchResouce.goldEventsDicM;
    NSLog(@"self.goldEventsModelDicM is %@", NSStringFromClass(self.goldEventsModelDicM.class));
    
    if (![self.goldEventsModelDicM isKindOfClass:[NSMutableDictionary class]]) {
        self.goldEventsModelDicM = [GoldEventsModel createModelsDicWithData:self.goldEventsModelDicM];
    }
    /* OS_dispatch_data
     NSMutableDictionary *dicM =[NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self.timeLineHeaderControlArr firstObject].teamId = obj.teamId;
    [self.timeLineHeaderControlArr firstObject].participantId = [NSString stringWithFormat:@"%d", ((NSString *)obj.teamId).intValue/100+10];
    */
    GoldEventsModel * goldEventsModel01 = [self.goldEventsModelDicM objectForKey:[self.timeLineHeaderControlArr firstObject].participantId];
    GoldEventsModel * goldEventsModel02 = [self.goldEventsModelDicM objectForKey:[self.timeLineHeaderControlArr lastObject].participantId];
    
    self.timeLineImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.LastDataV.frame), self.ScreenSize.width, self.ScreenSize.width)];
    self.timeLineImgV.backgroundColor = [UIColor whiteColor];
    UIImage * timeLineImg = [self drawTimeLineImgWithGoldDic01:goldEventsModel01.goldDic GoldDic02:goldEventsModel02.goldDic];
    self.timeLineImgV.image = timeLineImg;
    [self.DataV addSubview:self.timeLineImgV];
    self.LastDataV =self.timeLineImgV;
    
    
    [self.DataV bringSubviewToFront:self.TimeLineImgVHeader];
}
-(void)showTimeLineImgVHeader:(TimeLineHeaderControl *)control
{
    
    [self.timeLineHeaderControlArr enumerateObjectsUsingBlock:^(TimeLineHeaderControl * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:control] && obj.selected) {
            [obj didNotSelected];
        }
    }];
    if (control.selected) {
        self.TimeLineImgVHeader.hidden = YES;
    }else
    {
        UIColor * blueColor = [UIColor colorWithRed:0/255.00 green:169/255.00 blue:184/255.00 alpha:1];
        UIColor * lightblueColor = [UIColor colorWithRed:139/255.00 green:226/255.00 blue:226/255.00 alpha:0.8];
        UIColor * redColor = [UIColor colorWithRed:255/255.00 green:105/255.00 blue:109/255.00 alpha:1];
        UIColor * lightredColor = [UIColor colorWithRed:240/255.00 green:150/255.00 blue:150/255.00 alpha:0.8];
        
        
        [self.MatchResouce.matchToTeams enumerateObjectsUsingBlock:^(Team_EN * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj.teamId isEqualToString:control.teamId]) {
                Team_EN * team = obj;
                NSEnumerator * enumerator = [self.timeLineButtonsArrM objectEnumerator];
                [team.teamToParticipants enumerateObjectsUsingBlock:^(Participant_EN * _Nonnull obj, BOOL * _Nonnull stop) {
                    UIButton * button = [enumerator nextObject];
                    UIImage * backImg = ((ParticipantDetailV*)[self.ParticipantDetailVDicM objectForKey:obj.participantId]).ChampIcon.image;
                    [button setBackgroundImage:backImg forState:UIControlStateNormal];
                    [button setTitle:obj.participantId forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                    if ([control.participantId isEqualToString:obj.participantId]) {
                        button.layer.borderWidth = 3.00;
                        button.layer.borderColor = [team.win isEqualToString:@"Win"]?blueColor.CGColor:redColor.CGColor;
                    }else
                    {
                        button.layer.borderWidth = 0;
                        button.layer.borderColor = nil;
                    }
                }];
                
                UIButton * button = [self.timeLineButtonsArrM lastObject];
                if ([obj.win isEqualToString:@"Win"]) {
                    [button setBackgroundColor:blueColor];
                    [button setTitle:@"V" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }else
                {
                    [button setBackgroundColor:redColor];
                    [button setTitle:@"D" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
            }
        }];
        self.TimeLineImgVHeader.hidden = NO;
    }
    [control changeSelected];
}
         
-(void)configureTimeLineImgV:(UIButton *)button
{
    NSLog(@"button.currentTitle.intValue is %d", button.currentTitle.intValue);
    if (button.currentTitle.intValue > 0) {
        ParticipantDetailV * par = [self.ParticipantDetailVDicM objectForKey:button.currentTitle];
        TimeLineHeaderControl * timeLineHeaderControlArr = nil;
        if ([par.win isEqualToString:@"Win"]) {
            timeLineHeaderControlArr = [self.timeLineHeaderControlArr firstObject];
        }else
        {
            timeLineHeaderControlArr = [self.timeLineHeaderControlArr lastObject];
        }
        timeLineHeaderControlArr.iconV.image = button.currentBackgroundImage;
        timeLineHeaderControlArr.nameLa.text = par.summonerName.text;
        timeLineHeaderControlArr.participantId = par.participantId;
        [self showTimeLineImgVHeader:timeLineHeaderControlArr];
    }else
    {
        [self.timeLineHeaderControlArr firstObject].iconV.image = NULL;
        [self.timeLineHeaderControlArr firstObject].nameLa.text = [NSString stringWithFormat:@"Victory"];
        [self.timeLineHeaderControlArr firstObject].participantId = [NSString stringWithFormat:@"%d", [self.timeLineHeaderControlArr firstObject].teamId.intValue/100+10];
        [[self.timeLineHeaderControlArr firstObject] didNotSelected];
        
        [self.timeLineHeaderControlArr lastObject].iconV.image = NULL;
        [self.timeLineHeaderControlArr lastObject].nameLa.text = [NSString stringWithFormat:@"Defeated"];
        [self.timeLineHeaderControlArr lastObject].participantId = [NSString stringWithFormat:@"%d", [self.timeLineHeaderControlArr lastObject].teamId.intValue/100+10];
        [[self.timeLineHeaderControlArr lastObject] didNotSelected];
        self.TimeLineImgVHeader.hidden = YES;
    }
    GoldEventsModel *  goldEventsModel01 = nil;
    GoldEventsModel *  goldEventsModel02 = nil;
    
    NSString * id01 = [self.timeLineHeaderControlArr firstObject].participantId;
    NSString * id02 = [self.timeLineHeaderControlArr lastObject].participantId;
    if (id01.intValue > 10 && id02.intValue <= 10) {
        goldEventsModel02 = [self.goldEventsModelDicM objectForKey:id02];
    }else if (id01.intValue <= 10 && id02.intValue > 10)
    {
        goldEventsModel01 = [self.goldEventsModelDicM objectForKey:id01];
    }else
    {
        goldEventsModel01 = [self.goldEventsModelDicM objectForKey:id01];
        goldEventsModel02 = [self.goldEventsModelDicM objectForKey:id02];
    }
    
    self.timeLineImgV.image = [self drawTimeLineImgWithGoldDic01:goldEventsModel01.goldDic GoldDic02:goldEventsModel02.goldDic];
}

-(UIImage *)createTeamGoldRateImgWithBlueGold:(NSString *) blueGold RedGold:(NSString *) redGold Size:(CGSize) drawSize
{
    UIColor * blueColor = [UIColor colorWithRed:0/255.00 green:169/255.00 blue:184/255.00 alpha:1];
    UIColor * redColor = [UIColor colorWithRed:255/255.00 green:105/255.00 blue:109/255.00 alpha:1];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(drawSize.width, drawSize.height), NO, 0);
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat rate = blueGold.floatValue/(blueGold.floatValue+redGold.floatValue);
    CGFloat colorLocations[2] = {0.0,1.0};
    
    //创建CGMutablePathRef
    CGMutablePathRef path01 = CGPathCreateMutable();
    CGPathMoveToPoint(path01, NULL, 0, 0);
    CGPathAddLineToPoint(path01, NULL, drawSize.width*rate - 10, 0);
    CGPathAddLineToPoint(path01, NULL, drawSize.width*rate + 10, drawSize.height);
    CGPathAddLineToPoint(path01, NULL, 0, drawSize.height);
    CGPathCloseSubpath(path01);
    NSArray * blueColors = @[(__bridge id) blueColor.CGColor, (__bridge id) blueColor.CGColor];
    CGGradientRef gradient01 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) blueColors, colorLocations);
    CGRect pathRect01 = CGPathGetBoundingBox(path01);
    CGPoint startPoint01 = CGPointMake(CGRectGetMaxX(pathRect01), CGRectGetMinY(pathRect01));
    CGPoint endPoint01 = CGPointMake(CGRectGetMaxX(pathRect01), CGRectGetMaxY(pathRect01));
    CGContextSaveGState(con);
    CGContextAddPath(con, path01);
    CGContextClip(con);
    CGContextDrawLinearGradient(con, gradient01, startPoint01, endPoint01, 0);
    CGGradientRelease(gradient01);
    CGContextRestoreGState(con);
    
    CGMutablePathRef path02 = CGPathCreateMutable();
    CGPathMoveToPoint(path02, NULL, drawSize.width, 0);
    CGPathAddLineToPoint(path02, NULL, drawSize.width*rate - 10, 0);
    CGPathAddLineToPoint(path02, NULL, drawSize.width*rate + 10, drawSize.height);
    CGPathAddLineToPoint(path02, NULL, drawSize.width, drawSize.height);
    CGPathCloseSubpath(path02);
    NSArray * redColors = @[(__bridge id) redColor.CGColor, (__bridge id) redColor.CGColor];
    CGGradientRef gradient02 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) redColors, colorLocations);
    CGRect pathRect02 = CGPathGetBoundingBox(path02);
    CGPoint startPoint02 = CGPointMake(CGRectGetMaxX(pathRect02), CGRectGetMinY(pathRect02));
    CGPoint endPoint02 = CGPointMake(CGRectGetMaxX(pathRect02), CGRectGetMaxY(pathRect02));
    CGContextSaveGState(con);
    CGContextAddPath(con, path02);
    CGContextClip(con);
    CGContextDrawLinearGradient(con, gradient02, startPoint02, endPoint02, 0);
    CGGradientRelease(gradient02);
    CGContextRestoreGState(con);
    
    CGColorSpaceRelease(colorSpace);
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return im;
}
-(UIImage *)drawTimeLineImgWithGoldDic01:(nullable NSMutableDictionary *) goldDic01 GoldDic02:(nullable NSMutableDictionary *) goldDic02
{
    CGSize drawSize = CGSizeMake(self.ScreenSize.width, self.ScreenSize.width);
    CGPoint point0 = CGPointMake(drawSize.width*3/16, drawSize.height*12.5/16);
    CGFloat wid = drawSize.width*3/4;
    CGFloat hei = wid*3/4;
    CGFloat lineHei = hei*16/17;
    UIColor * lightGray = [UIColor colorWithRed:190/225.00 green:190/225.00 blue:190/225.00 alpha:1];
    
    NSArray * timeArr = nil;
    CGFloat glodFloatMost = 0;
    CGFloat glodFloatMost02 = 0;
    int timeIntMost = 0 ;
    if (goldDic01 != NULL) {
        timeArr = [goldDic01.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
            NSNumber *number1 = [NSNumber numberWithInt:obj1.intValue ];
            NSNumber *number2 = [NSNumber numberWithInt:obj2.intValue ];
            NSComparisonResult result = [number1 compare:number2];
            return result == NSOrderedDescending; // 升序
        }];
        glodFloatMost = ((NSString *)[goldDic01 objectForKey:[timeArr lastObject]]).floatValue;
        timeIntMost = ((NSString *)[timeArr lastObject]).intValue;
    }
    if (goldDic02 != NULL) {
        timeArr = [goldDic02.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
            NSNumber *number1 = [NSNumber numberWithInt:obj1.intValue ];
            NSNumber *number2 = [NSNumber numberWithInt:obj2.intValue ];
            NSComparisonResult result = [number1 compare:number2];
            return result == NSOrderedDescending; // 升序
        }];
        glodFloatMost02 = ((NSString *)[goldDic02 objectForKey:[timeArr lastObject]]).floatValue;
        timeIntMost = ((NSString *)[timeArr lastObject]).intValue;
    }
    glodFloatMost = glodFloatMost > glodFloatMost02 ?glodFloatMost:glodFloatMost02;
    
    UIColor * blueColor = [UIColor colorWithRed:0/255.00 green:169/255.00 blue:184/255.00 alpha:1];
    UIColor * lightblueColor = [UIColor colorWithRed:139/255.00 green:226/255.00 blue:226/255.00 alpha:0.8];
    UIColor * redColor = [UIColor colorWithRed:255/255.00 green:105/255.00 blue:109/255.00 alpha:1];
    UIColor * lightredColor = [UIColor colorWithRed:240/255.00 green:150/255.00 blue:150/255.00 alpha:0.8];
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(drawSize.width, drawSize.height), NO, 0);
    CGContextRef con = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i < 9; i ++) {
        CGContextMoveToPoint(con, point0.x, point0.y - hei*2/17*i);
        CGContextAddLineToPoint(con, point0.x + wid, point0.y - hei*2/17*i);
        CGContextSetLineWidth(con, 1.0f);
        CGContextSetStrokeColorWithColor(con, lightGray.CGColor);
        CGContextStrokePath(con);
    }
    for (int i = 0; i < 4; i ++) {
        CGContextMoveToPoint(con, point0.x + wid/4*i, point0.y);
        CGContextAddLineToPoint(con, point0.x + wid/4*i, point0.y - hei);
        CGContextSetLineWidth(con, 1.0f);
        CGContextSetStrokeColorWithColor(con, lightGray.CGColor);
        CGContextStrokePath(con);
    }
    
    //设置字体样式
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    //NSFontAttributeName:字体大小
    CGFloat fontSize = 9;
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:fontSize];
    //字体前景色
    dict[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    
    
    [[NSString stringWithFormat:@"0"] drawAtPoint:CGPointMake(point0.x - 18, point0.y + 9) withAttributes:dict];
    [[UIImage imageNamed:@"battle_overview_gold"] drawInRect:CGRectMake(point0.x - fontSize*2 - 2, point0.y - fontSize, 9, 9)];
    [[UIImage imageNamed:@"battle_overview_time"] drawInRect:CGRectMake(point0.x , point0.y + fontSize + 1, 9, 9)];
    
    if (timeIntMost != 0) {
        NSString * timeStr01 = [NSString stringWithFormat:@"%d:00", timeIntMost*1/4/60000];
        NSString * timeStr02 = [NSString stringWithFormat:@"%d:00", timeIntMost*2/4/60000];
        NSString * timeStr03 = [NSString stringWithFormat:@"%d:00", timeIntMost*3/4/60000];
        NSString * timeStr04 = [NSString stringWithFormat:@"%d:00", timeIntMost*4/4/60000];
        [timeStr01 drawAtPoint:CGPointMake(point0.x + wid/4 - timeStr01.length/4*fontSize, point0.y + fontSize) withAttributes:dict];
        [timeStr02 drawAtPoint:CGPointMake(point0.x + wid*2/4 - timeStr02.length/4*fontSize, point0.y + fontSize) withAttributes:dict];
        [timeStr03 drawAtPoint:CGPointMake(point0.x + wid*3/4 - timeStr03.length/4*fontSize, point0.y + fontSize) withAttributes:dict];
        [timeStr04 drawAtPoint:CGPointMake(point0.x + wid*4/4 - timeStr04.length/4*fontSize, point0.y + fontSize) withAttributes:dict];
    }
    
    
    if (glodFloatMost != 0) {
        NSString * goldStr01 = [NSString stringWithFormat:@"%.1fk", glodFloatMost/1000];
        NSString * goldStr02 = [NSString stringWithFormat:@"%.1fk", glodFloatMost*3/4/1000];
        NSString * goldStr03 = [NSString stringWithFormat:@"%.1fk", glodFloatMost*2/4/1000];
        NSString * goldStr04 = [NSString stringWithFormat:@"%.1fk", glodFloatMost/4/1000];
        [goldStr01 drawAtPoint:CGPointMake(point0.x*2/5, point0.y - fontSize/2  - lineHei/4*4) withAttributes:dict];
        [goldStr02 drawAtPoint:CGPointMake(point0.x*2/5, point0.y - fontSize/2  - lineHei/4*3) withAttributes:dict];
        [goldStr03 drawAtPoint:CGPointMake(point0.x*2/5, point0.y - fontSize/2  - lineHei/4*2) withAttributes:dict];
        [goldStr04 drawAtPoint:CGPointMake(point0.x*2/5, point0.y - fontSize/2  - lineHei/4*1) withAttributes:dict];
    }
    
    
    //设置字体样式
    NSMutableDictionary * titleDict = [NSMutableDictionary dictionary];
    //NSFontAttributeName:字体大小
    CGFloat titleFontSize = 25;
    titleDict[NSFontAttributeName] = [UIFont systemFontOfSize:titleFontSize];
    //字体前景色
    titleDict[NSForegroundColorAttributeName] = [UIColor colorWithRed:205/255.00 green:185/255.00 blue:130/255.00 alpha:1];
    NSString * title = [NSString stringWithFormat:@"Gold Chart"];
    [title drawAtPoint:CGPointMake(drawSize.width/2 - title.length*titleFontSize/4, (point0.y - lineHei)/2 - titleFontSize) withAttributes:titleDict];
//    [title drawAtPoint:CGPointMake(drawSize.width/2 - title.length*titleFontSize/2, (point0.y - lineHei)/2 - title.length*titleFontSize/2) withAttributes:titleDict];
    
    UIImage * blueImg = [UIImage imageNamed:@"battle_overview_golden_point_win"];
    UIImage * redImg = [UIImage imageNamed:@"battle_overview_golden_point_lose"];
    [blueImg drawInRect:CGRectMake(drawSize.width/3, point0.y+(drawSize.height-point0.y)/2, 9, 9)];
    [redImg drawInRect:CGRectMake(drawSize.width*2/3, point0.y+(drawSize.height-point0.y)/2, 9, 9)];
    
    //创建色彩空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (glodFloatMost > glodFloatMost02) {
        if (goldDic01 != NULL) {
            [self drawLinesWithPoint0:point0 ColorSpaceRef:colorSpace lineColor:blueColor startColor:lightblueColor goldDic:goldDic01 timeArr:timeArr GlodFloatMost:glodFloatMost ContextRef:con lineWidth:wid lineHeight:lineHei];
        }
        if (goldDic02 != NULL) {
            [self drawLinesWithPoint0:point0 ColorSpaceRef:colorSpace lineColor:redColor startColor:lightredColor goldDic:goldDic02 timeArr:timeArr GlodFloatMost:glodFloatMost ContextRef:con lineWidth:wid lineHeight:lineHei];
        }
    }else
    {
        if (goldDic02 != NULL) {
            [self drawLinesWithPoint0:point0 ColorSpaceRef:colorSpace lineColor:redColor startColor:lightredColor goldDic:goldDic02 timeArr:timeArr GlodFloatMost:glodFloatMost ContextRef:con lineWidth:wid lineHeight:lineHei];
        }
        if (goldDic01 != NULL) {
            [self drawLinesWithPoint0:point0 ColorSpaceRef:colorSpace lineColor:blueColor startColor:lightblueColor goldDic:goldDic01 timeArr:timeArr GlodFloatMost:glodFloatMost ContextRef:con lineWidth:wid lineHeight:lineHei];
        }
    }
    
//    CGContextRestoreGState(con);
    CGColorSpaceRelease(colorSpace);
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return im;
}

-(void)drawLinesWithPoint0:(CGPoint)point0 ColorSpaceRef:(CGColorSpaceRef) colorSpace lineColor:(UIColor *)lineColor startColor:(UIColor *)startColor goldDic:(NSMutableDictionary *) goldDic timeArr:(NSArray *) timeArr GlodFloatMost:(CGFloat) glodFloatMost ContextRef:(CGContextRef) con lineWidth:(CGFloat)wid lineHeight:(CGFloat)lineHei
{
    CGFloat timeIntMost = ((NSString *)[timeArr lastObject]).floatValue;
    
    CGContextMoveToPoint(con, point0.x, point0.y);
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    //绘制Path
    CGPathMoveToPoint(path, NULL, point0.x, point0.y);
    [timeArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat timeInt = obj.intValue;
        CGFloat glodFloat = ((NSString *)[goldDic objectForKey:obj]).floatValue;
        CGContextAddLineToPoint(con, point0.x + wid*timeInt/timeIntMost, point0.y - lineHei*glodFloat/glodFloatMost);
        CGPathAddLineToPoint(path, NULL, point0.x + wid*timeInt/timeIntMost, point0.y - lineHei*glodFloat/glodFloatMost);
    }];
    CGContextSetLineWidth(con, 1.0f);
    CGContextSetStrokeColorWithColor(con, lineColor.CGColor);
    CGContextStrokePath(con);
    
    CGPathAddLineToPoint(path, NULL, point0.x + wid, point0.y );
    CGPathCloseSubpath(path);
    
    CGFloat colorLocations[2] = {0.0,1.0};
    CGFloat * endColorCs = CGColorGetComponents(startColor.CGColor);
    NSArray * colors = @[(__bridge id) startColor.CGColor, (__bridge id) [UIColor colorWithRed:endColorCs[0] green:endColorCs[1] blue:endColorCs[2] alpha:0].CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, colorLocations);
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint startPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMinY(pathRect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMaxY(pathRect));
    
    CGContextAddPath(con, path);
    CGContextClip(con);
    CGContextDrawLinearGradient(con, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
//    CGContextSaveGState(con);
}
-(void)configureBriefV
{
    UIColor * blueColor = [UIColor colorWithRed:0/255.00 green:169/255.00 blue:184/255.00 alpha:1];
    UIColor * redColor = [UIColor colorWithRed:255/255.00 green:105/255.00 blue:109/255.00 alpha:1];
    int __block hi = 0;
    [self.MatchResouce.matchToTeams enumerateObjectsUsingBlock:^(Team_EN * _Nonnull obj, BOOL * _Nonnull stop) {
        Team_EN * team = obj;
        int __block wi = 0;
        [team.teamToParticipants enumerateObjectsUsingBlock:^(Participant_EN * _Nonnull obj, BOOL * _Nonnull stop) {
            UIButton * iconButton = [[UIButton alloc] init];
            iconButton.bounds = CGRectMake(0, 0, 40, 40);
            iconButton.layer.cornerRadius = CGRectGetMidY(iconButton.bounds);
            iconButton.layer.masksToBounds = YES;
            iconButton.center = CGPointMake(self.ScreenSize.width/10 + self.ScreenSize.width/5*wi, iconButton.bounds.size.width/2 + 20 + (iconButton.bounds.size.width + 10)*hi);
            iconButton.selected = NO;
            [iconButton setTitle:obj.participantId forState:UIControlStateNormal];
            [iconButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [iconButton setBackgroundColor:[team.win isEqualToString:@"Win"]?blueColor:redColor];
            iconButton.layer.borderColor = iconButton.backgroundColor.CGColor;
            iconButton.layer.borderWidth = 1;
            
            [iconButton addTarget:self action:@selector(refreshKilledMapImgV:) forControlEvents:UIControlEventTouchUpInside];
            [self.killedButtonsArrM addObject:iconButton];
            [self.BriefV addSubview:iconButton];
            self.LastKillsmapV = iconButton;
//            iconButton.backgroundColor = [UIColor whiteColor];
            wi++;
        }];
        hi++;
    }];
    [self performSelector:@selector(setKilledButtonsBackImg) withObject:NULL afterDelay:1.50];
    self.killsMapImgV = [[UIImageView alloc] init];
    self.killsMapImgV.bounds = CGRectMake(0, 0, 256, 256);
    self.killsMapImgV.center = CGPointMake(self.ScreenSize.width/2, CGRectGetMaxY(self.LastKillsmapV.frame) + 20 +  CGRectGetMidY(self.killsMapImgV.bounds));
    
    
    NSLog(@"self.BriefV.bounds is %f %f %f %f", self.BriefV.bounds.origin.x, self.BriefV.bounds.origin.y, self.BriefV.bounds.size.width, self.BriefV.bounds.size.height);
    NSLog(@"self.killsMapImgV.center is %f %f", self.killsMapImgV.center.x, self.killsMapImgV.center.y);
    self.killsMapImgV.image = [self drawKillsMapWithParticipantId:NULL];
    [self.BriefV addSubview:self.killsMapImgV];
    self.LastKillsmapV = self.killsMapImgV;
    self.BriefV.backgroundColor = [UIColor blackColor];
}
-(void)setKilledButtonsBackImg
{
    [self.killedButtonsArrM enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ParticipantDetailV * par = [self.ParticipantDetailVDicM objectForKey:obj.currentTitle];
        [obj setBackgroundImage:par.ChampIcon.image forState:UIControlStateNormal];
    }];
}
-(void)refreshKilledMapImgV:(UIButton *)button
{
    [self.killedButtonsArrM enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:button] && obj.selected) {
            obj.selected = NO;
            obj.layer.borderWidth = 1;
        }
    }];
    button.selected = YES;
    button.layer.borderWidth = 5;
    self.killsMapImgV.image = [self drawKillsMapWithParticipantId:button.currentTitle];
}
-(UIImage *)drawKillsMapWithParticipantId:(nullable NSString *) participantId
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.killsMapImgV.bounds.size.width, self.killsMapImgV.bounds.size.height), NO, 0);
    
    UIImage * mapImg = [UIImage imageNamed:[NSString stringWithFormat:@"map%@", self.MatchResouce.mapId]];
    [mapImg drawAtPoint:CGPointMake(0, 0)];
    
    if (participantId != NULL) {
        GoldEventsModel * goldEvent = [self.goldEventsModelDicM objectForKey:participantId];
        ParticipantDetailV * participantDetailV = [self.ParticipantDetailVDicM objectForKey:participantId];
        //24*24
        UIImage * killedImg = [UIImage imageNamed:[NSString stringWithFormat:@"battle_detail_map_%@_killed_normal", participantDetailV.win]];
        UIImage * beKilledImg = [UIImage imageNamed:[NSString stringWithFormat:@"battle_detail_map_%@_be_killed_normal", participantDetailV.win]];
        [goldEvent.killerArrM enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"obj.CGPointValue is %f %f , self.killsMapImgV.bounds.size is %f %f", obj.CGPointValue.x, obj.CGPointValue.y, self.killsMapImgV.bounds.size.width, self.killsMapImgV.bounds.size.height);
            CGPoint  p = CGPointMake(obj.CGPointValue.x/15000*self.killsMapImgV.bounds.size.width - 12, obj.CGPointValue.y/15000*self.killsMapImgV.bounds.size.height - 12);
            [killedImg drawAtPoint:p];
        }];
        [goldEvent.victimArrM enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGPoint  p = CGPointMake(obj.CGPointValue.x/15000*self.killsMapImgV.bounds.size.width - 12, obj.CGPointValue.y/15000*self.killsMapImgV.bounds.size.height - 12);
            [beKilledImg drawAtPoint:p];
        }];
    }
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return im;
}

-(void)layoutViews
{
    
    [self layoutHeaderV];
    [self layoutContentV];
}
-(void)layoutHeaderV
{
    self.HeaderV.frame = CGRectMake(0, 0, self.ScreenSize.width, self.slipV.frame.origin.y + self.slipV.frame.size.height +5);
}
-(void)layoutContentV
{
    self.ContentV.frame = CGRectMake(0, self.HeaderV.frame.origin.y + self.HeaderV.frame.size.height, self.ScreenSize.width, self.ScreenSize.height - (self.HeaderV.frame.origin.y + self.HeaderV.frame.size.height));
    self.ContentV.contentSize = CGSizeMake(self.ScreenSize.width*3, self.ContentV.frame.size.height);
    
    [self layoutDetailV];
    [self layoutDataV];
    [self layoutBriefV];
}
-(void)layoutDetailV
{
    self.DetailV.frame = CGRectMake(0, 0, self.ScreenSize.width, self.ContentV.frame.size.height);
    CGRect __block rect = CGRectZero;
    [self.DetailV.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.center =CGPointMake(self.ScreenSize.width/2, rect.origin.y + rect.size.height +  obj.frame.size.height/2);
        rect = obj.frame;
        if ([obj isEqual:self.LastDetailV]) {
            *stop = YES;
        }
    }];
    self.DetailV.contentSize =CGSizeMake(self.LastDetailV.frame.size.width, self.LastDetailV.frame.origin.y + self.LastDetailV.frame.size.height);
    
}
-(void)layoutDataV
{
    self.DataV.frame = CGRectMake(self.DetailV.frame.origin.x + self.DetailV.frame.size.width, 0, self.ScreenSize.width, self.ContentV.frame.size.height);
    self.DataV.contentSize =CGSizeMake(self.DataV.frame.size.width, self.LastDataV.frame.origin.y + self.LastDataV.frame.size.height);
    
}
-(void)layoutBriefV
{
    self.BriefV.frame = CGRectMake(self.DataV.frame.origin.x + self.DataV.frame.size.width, 0, self.ScreenSize.width, self.ContentV.frame.size.height);
    self.BriefV.contentSize =CGSizeMake(self.BriefV.frame.size.width, CGRectGetMaxY(self.LastKillsmapV.frame));
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)backViewAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)ContentVtoDetail
{
    [self.ContentV setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)ContentVtoData
{
    [self.ContentV setContentOffset:CGPointMake(self.ContentV.contentSize.width/3, 0) animated:YES];
}
-(void)ContentVtoBrief
{
    [self.ContentV setContentOffset:CGPointMake(self.ContentV.contentSize.width*2/3, 0) animated:YES];
}


-(void)changeDetailVBounds:(ParticipantDetailV *) par
{
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutDetailV];
        if (par.frame.origin.y+par.frame.size.height>self.DetailV.contentOffset.y+self.DetailV.frame.size.height) {
            [self.DetailV setContentOffset:CGPointMake(0, par.frame.origin.y+par.frame.size.height - self.DetailV.frame.size.height) animated:NO];
        }
    } completion:^(BOOL finished) {
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - ContentVCDelegatePro
-(void)changeWhenScrollByRate:(CGFloat)rate
{
    self.slipV.center = CGPointMake(self.HeaderV.bounds.size.width/6+(self.HeaderV.bounds.size.width*2/3)*rate, self.slipV.center.y);
    switch ((int)(rate*100)) {
        case 0:
            self.DetailBut.selected = YES;
            self.DataBut.selected = NO;
            self.BriefBut.selected = NO;
            break;
            
        case 50:
            self.DetailBut.selected = NO;
            self.DataBut.selected = YES;
            self.BriefBut.selected = NO;
            break;
            
        case 100:
            self.DetailBut.selected = NO;
            self.DataBut.selected = NO;
            self.BriefBut.selected = YES;
            break;
            
        default:
            break;
    }
}

#pragma mark - UIScrollViewDelegate 委托

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeWhenScrollByRate:scrollView.contentOffset.x/(scrollView.contentSize.width*2/3)];
}
@end
