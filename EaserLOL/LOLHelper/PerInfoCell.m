//
//  PerInfoCell.m
//  LOLHelper
//
//  Created by Easer Liu on 25/06/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "PerInfoCell.h"
#import "HonorView.h"
#import "PerCategory.h"
#import "OptimizeLog.h"


@implementation PerInfoCell

-(instancetype)initStatsCellWithIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            self= [super init];
            [self createStatsCell];
            self.celltype = StatsCellType;
            break;
            
        case 1:
            self= [super init];
            [self createMatchListHeaderCell];
            self.celltype = MatchListHeaderCellType;
            break;
            
        default:
            self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MatchListCellType"];
            [self createMatchListCell];
            self.celltype = MatchListCellType;
            break;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    switch (self.celltype) {
        case StatsCellType:
            [self layoutStatsCell];
            break;

        case MatchListHeaderCellType:
            [self layoutMatchListHeaderCell];
            break;
            
        case MatchListCellType:
            [self layoutMatchListCell];
            break;

        default:
            break;
    }
}

-(void)configueStatsCellWithDic:(NSDictionary *)dic atIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self configueStatsCellWithDic:dic];
            break;
            
        case 1:
            [self configueMatchListHeaderCellWithDic:dic];
            break;
            
        default:
            [self configueMatchListCellWithDic:dic];
            break;
    }
}

-(void)createStatsCell
{
    HonorView * leagueV = [[HonorView alloc] initWithName:@"leagueV" viewType:LeagueViewType];
    leagueV.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView * rightV = [[UIView alloc] initWithName:@"rightV"];
    rightV.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel * rateLa = [[UILabel alloc] initWithName:@"rateLa"];
    rateLa.textAlignment = NSTextAlignmentCenter;
    rateLa.translatesAutoresizingMaskIntoConstraints = NO;
    HonorView * honorV01 = [[HonorView alloc] initWithName:@"honorV01" viewType:HonorViewType];
    honorV01.translatesAutoresizingMaskIntoConstraints = NO;
    HonorView * honorV02 = [[HonorView alloc] initWithName:@"honorV02" viewType:HonorViewType];
    honorV02.translatesAutoresizingMaskIntoConstraints = NO;
    HonorView * honorV03 = [[HonorView alloc] initWithName:@"honorV03" viewType:HonorViewType];
    honorV03.translatesAutoresizingMaskIntoConstraints = NO;
    
    [rightV perAddSubviews:rateLa, honorV01, honorV02, honorV03, nil];
    
    [self perAddSubviews:leagueV, rightV, nil];
    
    [self layoutStatsCell];
}


-(void)configueStatsCellWithDic:(NSDictionary *)dic
{
    HonorView * leagueV = [self.perSubviews objectForKey:@"leagueV"];
    UIView * rightV = [self.perSubviews objectForKey:@"rightV"];
    UILabel * rateLa = [rightV.perSubviews objectForKey:@"rateLa"];
    HonorView * honorV01 = [rightV.perSubviews objectForKey:@"honorV01"];
    HonorView * honorV02 = [rightV.perSubviews objectForKey:@"honorV02"];
    HonorView * honorV03 = [rightV.perSubviews objectForKey:@"honorV03"];
    
    NSArray * leagueVDic = [dic objectForKey:@"leagueV"];
    NSArray * rateLaDic = [dic objectForKey:@"rateLa"];
    NSArray * honorV01Dic = [dic objectForKey:@"honorV01"];
    NSArray * honorV02Dic = [dic objectForKey:@"honorV02"];
    NSArray * honorV03Dic = [dic objectForKey:@"honorV03"];
//    NSString * type0 = leagueVDic[0];
//    NSString * type1 = honorV01Dic[0];
//    NSString * type2 = honorV02Dic[0];
//    NSString * type3 = honorV03Dic[0];
//    [leagueV setLeagueViewWithType:type0.intValue duanwei:leagueVDic[1]];
    [leagueV setLeagueStr:leagueVDic[0] duanwei:leagueVDic[1]];
    
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"胜率：%@ 近期局数：%@", rateLaDic[0], rateLaDic[1]]];
    NSInteger firstLocal = 4+((NSString *)rateLaDic[0]).length;
    NSInteger secondLocal = firstLocal + 5;
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,3)];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0,3)];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(3,((NSString *)rateLaDic[0]).length)];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(3,((NSString *)rateLaDic[0]).length)];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(firstLocal,5)];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(firstLocal,5)];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(secondLocal,((NSString *)rateLaDic[1]).length)];
    [att addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(secondLocal,((NSString *)rateLaDic[1]).length)];
    rateLa.attributedText = att;
    
//    rateLa.text = [NSString stringWithFormat:@"胜率：%@ 总局数：%@", rateLaDic[0], rateLaDic[1]];
    
//    [honorV01 setHonorViewWithType:type1.intValue Num:honorV01Dic[1]];
//    [honorV02 setHonorViewWithType:type2.intValue Num:honorV02Dic[1]];
//    [honorV03 setHonorViewWithType:type3.intValue Num:honorV03Dic[1]];
    [honorV01 setHonorStr:honorV01Dic[0] Num:honorV01Dic[1]];
    [honorV02 setHonorStr:honorV02Dic[0] Num:honorV02Dic[1]];
    [honorV03 setHonorStr:honorV03Dic[0] Num:honorV03Dic[1]];
    
    self.lastHeight = leagueV.frame.origin.y + leagueV.frame.size.height + 8;
}
-(void)layoutStatsCell
{
    if (self) {
        
        HonorView * leagueV = [self.perSubviews objectForKey:@"leagueV"];
        UIView * rightV = [self.perSubviews objectForKey:@"rightV"];
        UILabel * rateLa = [rightV.perSubviews objectForKey:@"rateLa"];
        HonorView * honorV01 = [rightV.perSubviews objectForKey:@"honorV01"];
        HonorView * honorV02 = [rightV.perSubviews objectForKey:@"honorV02"];
        HonorView * honorV03 = [rightV.perSubviews objectForKey:@"honorV03"];
        
        NSString * vflV01 = [NSString stringWithFormat:@"V:|-5-[%@(15)]-5-[%@(60)]-5-|",rateLa.perViewName,honorV01.perViewName];
        NSString * vflV02 = [NSString stringWithFormat:@"V:|-5-[%@(15)]-5-[%@(60)]-5-|",rateLa.perViewName,honorV02.perViewName];
        NSString * vflV03 = [NSString stringWithFormat:@"V:|-5-[%@(15)]-5-[%@(60)]-5-|",rateLa.perViewName,honorV03.perViewName];
        NSString * vflH01 = [NSString stringWithFormat:@"H:|-[%@]-|",rateLa.perViewName];
        NSString * vflH02 = [NSString stringWithFormat:@"H:|-[%@]-[%@(==%@)]-[%@(==%@)]-|",honorV01.perViewName,honorV02.perViewName,honorV01.perViewName,honorV03.perViewName,honorV01.perViewName];
        [rightV perAddConstraints:vflV01,vflV02,vflV03,vflH01,vflH02, nil];
        
        NSString * wid02 = [NSString stringWithFormat:@"%d",(int)(self.bounds.size.width)/4];
        NSString * vflV11 = [NSString stringWithFormat:@"V:|[%@(90)]|",leagueV.perViewName];
        NSString * vflV12 = [NSString stringWithFormat:@"V:|[%@(90)]|",rightV.perViewName];
        NSString * vflH11 = [NSString stringWithFormat:@"H:|-5-[%@(%@)][%@]-5-|",leagueV.perViewName,wid02,rightV.perViewName];
        [self perAddConstraints:vflV11,vflV12,vflH11, nil];
        
        self.lastHeight = leagueV.frame.origin.y + leagueV.frame.size.height;
    }else
    {
        NSLog(@"cell 不存在");
    }
    
    
}

-(void)createMatchListHeaderCell
{
    UIControl * leftV = [[UIControl alloc] initWithName:@"leftV"];
    UIImageView * lostOrWinImgV = [[UIImageView alloc] initWithName:@"lostOrWinImgV"];
    
    UILabel * myMatchListLa = [[UILabel alloc] initWithName:@"myMatchListLa"];
    myMatchListLa.text = [NSString stringWithFormat:@"我的战绩"];
    myMatchListLa.font = [UIFont systemFontOfSize:14];
    UIImageView * myMatchListImgV = [[UIImageView alloc] initWithName:@"myMatchListImgV"];
    //逻辑大小为15x15
    myMatchListImgV.image = [UIImage imageNamed:@"friend_region_arrow_down"];
    [leftV perAddSubviews:myMatchListLa, myMatchListImgV, nil];
    
    [self perAddSubviews:leftV, lostOrWinImgV, nil];
}
-(void)configueMatchListHeaderCellWithDic:(NSDictionary *)dic
{
    UIImageView * lostOrWinImgV = [self.perSubviews objectForKey:@"lostOrWinImgV"];
    
    lostOrWinImgV.image = [UIImage imageNamed:[dic objectForKey:@"lostOrWinImgV"]];
    
    [self layoutMatchListHeaderCell];
}
-(void)layoutMatchListHeaderCell
{
    UIControl * leftV = [self.perSubviews objectForKey:@"leftV"];
    UIImageView * lostOrWinImgV = [self.perSubviews objectForKey:@"lostOrWinImgV"];
    UILabel * myMatchListLa = [leftV.perSubviews objectForKey:@"myMatchListLa"];
    UIImageView * myMatchListImgV = [leftV.perSubviews objectForKey:@"myMatchListImgV"];
    
    [myMatchListLa sizeToFit];
    int myMLLaWid = myMatchListLa.bounds.size.width+1;
    int leftVWid = myMLLaWid + 31;
    int rightHeiRest = ((self.bounds.size.height - 32)/2);
    
    rightHeiRest = rightHeiRest>0?rightHeiRest:0;
    NSString * vflV01 = [NSString stringWithFormat:@"V:|[%@]|",leftV.perViewName];
    NSString * vflV02 = [NSString stringWithFormat:@"V:|-%d-[%@(32)]",rightHeiRest, lostOrWinImgV.perViewName];
    NSString * vflH01 = [NSString stringWithFormat:@"H:|-[%@(%d)]",leftV.perViewName, leftVWid];
    NSString * vflH02 = [NSString stringWithFormat:@"H:[%@(67)]-|",lostOrWinImgV.perViewName];
    [self perAddConstraints:vflV01, vflV02, vflH01, vflH02, nil];
    
    int leftHeiRest = ((self.bounds.size.height - 15)/2);
    leftHeiRest = leftHeiRest>0?leftHeiRest:0;
    
    NSString * vflVL01 = [NSString stringWithFormat:@"V:|-%d-[%@(15)]",leftHeiRest,myMatchListLa.perViewName];
    NSString * vflVL02 = [NSString stringWithFormat:@"V:|-%d-[%@(15)]",leftHeiRest,myMatchListImgV.perViewName];
    NSString * vflHL01 = [NSString stringWithFormat:@"H:|-[%@(%d)]-[%@(15)]",myMatchListLa.perViewName,myMLLaWid,myMatchListImgV.perViewName];
    [leftV perAddConstraints:vflVL01, vflVL02, vflHL01, nil];
    
    
    self.lastHeight = lostOrWinImgV.frame.origin.y + lostOrWinImgV.frame.size.height + 5;
}

-(void)createMatchListCell
{
    UIImageView * heroImgV = [[UIImageView alloc] initWithName:@"heroImgV"];
    heroImgV.layer.cornerRadius = 25;
    heroImgV.clipsToBounds = YES;
    UILabel * resultLa = [[UILabel alloc] initWithName:@"resultLa"];
    UILabel * matchTypeLa = [[UILabel alloc] initWithName:@"matchTypeLa"];
    UILabel * killLa = [[UILabel alloc] initWithName:@"killLa"];
    killLa.textAlignment = NSTextAlignmentCenter;
    UILabel * timeLa = [[UILabel alloc] initWithName:@"timeLa"];
    UIImageView * stateImgV01 = [[UIImageView alloc] initWithName:@"stateImgV01"];
    UIImageView * stateImgV02 = [[UIImageView alloc] initWithName:@"stateImgV02"];
    UIImageView * stateImgV03 = [[UIImageView alloc] initWithName:@"stateImgV03"];
    [self perAddSubviews:heroImgV, resultLa, matchTypeLa, killLa, timeLa, stateImgV01, stateImgV02, stateImgV03, nil];
    
    [self layoutMatchListCell];
}

-(void)layoutMatchListCell
{
    UIImageView * heroImgV = [self.perSubviews objectForKey:@"heroImgV"];
    UILabel * resultLa = [self.perSubviews objectForKey:@"resultLa"];
    UILabel * matchTypeLa = [self.perSubviews objectForKey:@"matchTypeLa"];
    UILabel * killLa = [self.perSubviews objectForKey:@"killLa"];
    UILabel * timeLa = [self.perSubviews objectForKey:@"timeLa"];
    UIImageView * stateImgV01 = [self.perSubviews objectForKey:@"stateImgV01"];
    UIImageView * stateImgV02 = [self.perSubviews objectForKey:@"stateImgV02"];
    UIImageView * stateImgV03 = [self.perSubviews objectForKey:@"stateImgV03"];
    
    NSString * vflV01 = [NSString stringWithFormat:@"V:|-5-[%@(50)]-5-|",heroImgV.perViewName];
    NSString * vflV02 = [NSString stringWithFormat:@"V:|-12-[%@(15)]-11-[%@(10)]-12-|",resultLa.perViewName,matchTypeLa.perViewName];
    NSString * vflV03 = [NSString stringWithFormat:@"V:|-13-[%@(10)]-11-[%@(13)]-13-|",killLa.perViewName,stateImgV01.perViewName];
    NSString * vflV04= [NSString stringWithFormat:@"V:|-13-[%@(10)]-11-[%@(13)]-13-|",killLa.perViewName,stateImgV02.perViewName];
    NSString * vflV05 = [NSString stringWithFormat:@"V:|-13-[%@(10)]-11-[%@(13)]-13-|",killLa.perViewName,stateImgV03.perViewName];
    NSString * vflV06 = [NSString stringWithFormat:@"V:|-25-[%@(10)]",timeLa.perViewName];
    
    int screenWid = [UIScreen mainScreen].bounds.size.width;
    
    NSString * vflH01 = [NSString stringWithFormat:@"H:|-5-[%@(50)]-5-[%@]",heroImgV.perViewName,resultLa.perViewName];
    NSString * vflH02 = [NSString stringWithFormat:@"H:|-5-[%@(50)]-5-[%@]",heroImgV.perViewName,matchTypeLa.perViewName];
    NSString * vflH03 = [NSString stringWithFormat:@"H:|-%d-[%@(80)]",(screenWid - 80)/2,killLa.perViewName];
    NSString * vflH04 = [NSString stringWithFormat:@"H:|-%d-[%@(13)]-2-[%@(13)]-2-[%@(13)]",(screenWid-43)/2,stateImgV01.perViewName,stateImgV02.perViewName,stateImgV03.perViewName];
//    NSString * vflH03 = [NSString stringWithFormat:@"H:|-%d-[%@(45)]",killLaLeftDis,killLa.perViewName];
//    NSString * vflH04 = [NSString stringWithFormat:@"H:|-%d-[%@(13)]-2-[%@(13)]-2-[%@(13)]",killLaLeftDis,stateImgV01.perViewName,stateImgV02.perViewName,stateImgV03.perViewName];
    NSString * vflH05 = [NSString stringWithFormat:@"H:[%@]-5-|",timeLa.perViewName];
    [self perAddConstraints:vflV01, vflV02, vflV03, vflV04, vflV05, vflV06, vflH01, vflH02, vflH03, vflH04, vflH05, nil];
    NSLog(@"x is %f,y is %f",heroImgV.frame.origin.x,heroImgV.frame.origin.y);
    
    self.lastHeight = heroImgV.frame.origin.y + heroImgV.frame.size.height + 5;
}
-(void)configueMatchListCellWithDic:(NSDictionary *)dic
{
    UIImageView * heroImgV = [self.perSubviews objectForKey:@"heroImgV"];
    UILabel * resultLa = [self.perSubviews objectForKey:@"resultLa"];
    UILabel * matchTypeLa = [self.perSubviews objectForKey:@"matchTypeLa"];
    UILabel * killLa = [self.perSubviews objectForKey:@"killLa"];
    UILabel * timeLa = [self.perSubviews objectForKey:@"timeLa"];
    UIImageView * stateImgV01 = [self.perSubviews objectForKey:@"stateImgV01"];
    UIImageView * stateImgV02 = [self.perSubviews objectForKey:@"stateImgV02"];
    UIImageView * stateImgV03 = [self.perSubviews objectForKey:@"stateImgV03"];
    
    if ([[dic objectForKey:@"heroImgV"] isKindOfClass:[UIImage class]]) {
        heroImgV.image = [dic objectForKey:@"heroImgV"];
    }else if ([[dic objectForKey:@"heroImgV"] isKindOfClass:[NSDictionary class]])
    {
        heroImgV.image = [UIImage imageNamed:@"default_head"];
        [heroImgV setImageWithContentsOfFile:[[dic objectForKey:@"heroImgV"] objectForKey:@"championIconPath"] cacheFromURL:[[dic objectForKey:@"heroImgV"] objectForKey:@"championIconURL"]];
    }
    
    resultLa.text = [dic objectForKey:@"resultLa"];
    resultLa.textColor = [UIColor redColor];
    resultLa.font = [UIFont systemFontOfSize:15];
    matchTypeLa.text = [dic objectForKey:@"matchTypeLa"];
    matchTypeLa.textColor = [UIColor grayColor];
    matchTypeLa.font = [UIFont systemFontOfSize:10];
    killLa.text = [dic objectForKey:@"killLa"];
    killLa.textColor = [UIColor redColor];
    killLa.font = [UIFont systemFontOfSize:12];
    timeLa.text = [dic objectForKey:@"timeLa"];
    timeLa.textColor = [UIColor grayColor];
    timeLa.font = [UIFont systemFontOfSize:10];
    if([dic objectForKey:@"stateImgV01"])
    {stateImgV01.image = [dic objectForKey:@"stateImgV01"];}
    if([dic objectForKey:@"stateImgV01"])
    {stateImgV02.image = [dic objectForKey:@"stateImgV02"];}
    if([dic objectForKey:@"stateImgV01"])
    {stateImgV03.image = [dic objectForKey:@"stateImgV03"];}
//    stateImgV01.image = [dic objectForKey:@"stateImgV01"];
//    stateImgV02.image = [dic objectForKey:@"stateImgV02"];
//    stateImgV03.image = [dic objectForKey:@"stateImgV03"];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
