//
//  PerInfoCell+Ability.m
//  LOLHelper
//
//  Created by Easer Liu on 26/06/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "PerInfoCell+Ability.h"
#import "PerCategory.h"
#import "OptimizeLog.h"
#import "GetData.h"

#import "ChampionsBrief_EN+CoreDataClass.h"

@interface GoodHero:UIControl

-(instancetype)initWithName:(NSString *)name;
-(void)configueGoodHeroWithheroId:(NSString *) heroID totalNum:(NSString *)totalNum winRate:(NSString *)winRate;

@end

@implementation PerInfoCell (Ability)

-(instancetype)initAbilityTypeCellWithIndexPath:(NSIndexPath *)indexPath
{
    self = [super init];
    
    NSString * abilityTypeCellSelecter = [NSString stringWithFormat:@"createAbilityTypeCellIndexPathRow%d", (int)indexPath.row];
//    NSString * abilityTypeCellSelecter = [NSString stringWithFormat:@"createAbilityTypeCellIndexPathRow%d", (int)indexPath.row];
    SEL methodSEL = NSSelectorFromString(abilityTypeCellSelecter);
    if ([self respondsToSelector:methodSEL]) {
        
//        [self performSelector:methodSEL];
        
        IMP imp = [self methodForSelector:methodSEL];
        void (* func)(id, SEL) = (void *)imp;
        func(self, methodSEL);
        
    }
    [self setNeedsDisplay];
    [self layoutIfNeeded];
    return self;
}

-(void)createAbilityTypeCellIndexPathRow0
{
    self.celltype = AbilityCellRow0Type;
    UIImageView * ablilityPicV = [[UIImageView alloc] initWithName:@"ablilityPicV"];
    UIButton * goodRole = [[UIButton alloc] initWithName:@"goodRole"];
    UIButton * ablilityPicDes = [[UIButton alloc] initWithName:@"ablilityPicDes"];
    
    [self perAddSubviews:ablilityPicV, goodRole, ablilityPicDes, nil];
}
-(void)layoutAbilityTypeCellIndexPathRow0
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIImageView * ablilityPicV = [self.perSubviews objectForKey:@"ablilityPicV"];
    UIButton * goodRole = [self.perSubviews objectForKey:@"goodRole"];
    UIButton * ablilityPicDes = [self.perSubviews objectForKey:@"ablilityPicDes"];
    
    
    NSString * vflVAPV = [NSString stringWithFormat:@"V:|-5-[%@(215)]-5-[%@(10)]-5-|",ablilityPicV.perViewName,goodRole.perViewName];
    NSString * vflHAPV = [NSString stringWithFormat:@"H:|-%d-[%@(215)]",(int)(screenSize.width-215)/2,ablilityPicV.perViewName];
    NSString * vflHGR = [NSString stringWithFormat:@"H:|-5-[%@(%d)]",goodRole.perViewName, (int)screenSize.width/3];
    NSString * vflVAPD = [NSString stringWithFormat:@"V:|-10-[%@(24)]",ablilityPicDes.perViewName];
    NSString * vflHAPD = [NSString stringWithFormat:@"H:[%@(24)]-10-|",ablilityPicDes.perViewName];
    [self perAddConstraints:vflVAPV, vflHAPV, vflHGR, vflVAPD, vflHAPD, nil];
    self.lastHeight = goodRole.frame.origin.y + goodRole.frame.size.height + 5;
}
-(void)configueAbilityTypeCellIndexPathRow0WithDic:(NSDictionary *) dic
{
    UIImageView * ablilityPicV = [self.perSubviews objectForKey:@"ablilityPicV"];
    UIButton * goodRole = [self.perSubviews objectForKey:@"goodRole"];
    UIButton * ablilityPicDes = [self.perSubviews objectForKey:@"ablilityPicDes"];
    
    UIImage * nenglituIm = [UIImage imageNamed:@"nenglitu_rd75"];
    UIGraphicsBeginImageContextWithOptions(ablilityPicV.bounds.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
//    CGContextSetFillColorWithColor(ctx, UIColorHex(0x1b29b4,0.5).CGColor);
//
//    CGContextSetStrokeColorWithColor(ctx, UIColorHex(0x2b38bc,1).CGColor);
    [nenglituIm drawAtPoint:CGPointZero];
    CGMutablePathRef path1=CGPathCreateMutable();
    
    NSArray *  abRs = [NSArray arrayWithObjects:[dic objectForKey:@"killsNum_ability"], [dic objectForKey:@"goldEarnedNum_ability"], [dic objectForKey:@"totalDamageTakenNum_ability"], [dic objectForKey:@"magicDamageDealtToChampionsNum_ability"], [dic objectForKey:@"physicalDamageDealtToChampionsNum_ability"], [dic objectForKey:@"assistsNum_ability"], [dic objectForKey:@"deathsNum_ability"], nil];
    CGFloat centerWid = ablilityPicV.bounds.size.height/2;
    CGFloat rd = 0.75 *centerWid;
    NSString * abR = nil;
    double angle = 0;
    CGPoint point01 = CGPointZero;
    UIColor * fillColor = [UIColor colorWithRed:0 green:0 blue:(255/255.0) alpha:0.5];
//    NSArray * abD = [NSArray arrayWithObjects:@"击杀", @"金钱", @"防御", @"魔法",  @"物理", @"助攻", @"生存", nil];
//    NSDictionary * dict=@{NSFontAttributeName:[UIFont systemFontOfSize:10]};
//    NSDictionary * dict=@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor brownColor]};
    for (int i = 0; i < abRs.count ; i++) {
        if (i == 0) {
            abR = abRs[i];
            angle = -M_PI*0.5;
            point01 = CGPointMake((centerWid + rd * (abR.floatValue / 100 * cos(angle))), (centerWid + rd * (abR.floatValue / 100 * sin(angle))));
            CGContextSetStrokeColorWithColor(ctx, fillColor.CGColor);
            CGPathMoveToPoint(path1, nil, point01.x, point01.y);//移动到指定位置（设置路径起点）
//            point01 = CGPointMake((rd + 0.9*rd * cos(angle)-10), (rd + 0.9*rd * sin(angle))-5);
//            [abD[i] drawAtPoint:point01 withAttributes:dict];
        }else
        {
            abR = abRs[i];
            angle += M_PI*2/7;
            point01 = CGPointMake((centerWid + rd * (abR.floatValue / 100 * cos(angle))), (centerWid + rd * (abR.floatValue / 100 * sin(angle))));
            CGContextSetStrokeColorWithColor(ctx, fillColor.CGColor);
            CGPathAddLineToPoint(path1, nil,  point01.x, point01.y);//绘制直线
//            point01 = CGPointMake((rd + 0.9*rd * cos(angle)-10), (rd + 0.9*rd * sin(angle))-5);
//            [abD[i] drawAtPoint:point01 withAttributes:dict];
        }
    }
    CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    CGPathCloseSubpath(path1);
    
    
    //2.b.3把圆的路径添加到图形上下文中
    CGContextAddPath(ctx, path1);
    
    //CGContextStrokePath(ctx);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //6.释放对象
    CGPathRelease(path1);
    
    ablilityPicV.image = im;
    
    NSString * goodAtRole = [NSString stringWithFormat:@"Adept："];
    NSMutableAttributedString * goodRoleTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", goodAtRole, [dic objectForKey:@"goodRole"]]];
    [goodRoleTitle addAttribute:NSForegroundColorAttributeName value:[UIColor brownColor] range:NSMakeRange(goodAtRole.length, goodRoleTitle.length-goodAtRole.length)];
    [goodRoleTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, goodRoleTitle.length)];
    [goodRole setAttributedTitle:goodRoleTitle forState:UIControlStateNormal];
    
    [ablilityPicDes setImage:[UIImage imageNamed:@"btn_description_normal"] forState:UIControlStateNormal];
    [ablilityPicDes setImage:[UIImage imageNamed:@"btn_description_press"] forState:UIControlStateSelected];
    
}
-(void)createAbilityTypeCellIndexPathRow1
{
    self.celltype = AbilityCellRow1Type;
    UILabel * goodHeroHeader = [[UILabel alloc] initWithName:@"goodHeroHeader"];
    goodHeroHeader.font = [UIFont systemFontOfSize:13];
    goodHeroHeader.text = [NSString stringWithFormat:@"Champs Recently："];
    GoodHero * goodHero01 = [[GoodHero alloc] initWithName:@"goodHero01"];
    GoodHero * goodHero02 = [[GoodHero alloc] initWithName:@"goodHero02"];
    GoodHero * goodHero03 = [[GoodHero alloc] initWithName:@"goodHero03"];
    GoodHero * goodHero04 = [[GoodHero alloc] initWithName:@"goodHero04"];
    GoodHero * goodHero05 = [[GoodHero alloc] initWithName:@"goodHero05"];
    [self perAddSubviews:goodHeroHeader, goodHero01, goodHero02, goodHero03, goodHero04, goodHero05, nil];
}
-(void)layoutAbilityTypeCellIndexPathRow1
{
    UILabel * goodHeroHeader = [self.perSubviews objectForKey:@"goodHeroHeader"];
    GoodHero * goodHero01 = [self.perSubviews objectForKey:@"goodHero01"];
    GoodHero * goodHero02 = [self.perSubviews objectForKey:@"goodHero02"];
    GoodHero * goodHero03 = [self.perSubviews objectForKey:@"goodHero03"];
    GoodHero * goodHero04 = [self.perSubviews objectForKey:@"goodHero04"];
    GoodHero * goodHero05 = [self.perSubviews objectForKey:@"goodHero05"];
    
    NSString * vflV01 = [NSString stringWithFormat:@"V:|-5-[%@(15)]-5-[%@(75)]-5-|", goodHeroHeader.perViewName, goodHero01.perViewName];
    NSString * vflV02 = [NSString stringWithFormat:@"V:|-5-[%@(15)]-5-[%@(75)]-5-|", goodHeroHeader.perViewName, goodHero02.perViewName];
    NSString * vflV03 = [NSString stringWithFormat:@"V:|-5-[%@(15)]-5-[%@(75)]-5-|", goodHeroHeader.perViewName, goodHero03.perViewName];
    NSString * vflV04 = [NSString stringWithFormat:@"V:|-5-[%@(15)]-5-[%@(75)]-5-|", goodHeroHeader.perViewName, goodHero04.perViewName];
    NSString * vflV05 = [NSString stringWithFormat:@"V:|-5-[%@(15)]-5-[%@(75)]-5-|", goodHeroHeader.perViewName, goodHero05.perViewName];
    NSString * vflH01 = [NSString stringWithFormat:@"H:|-10-[%@]-10-|",goodHeroHeader.perViewName];
    NSString * vflH02 = [NSString stringWithFormat:@"H:|-10-[%@]-5-[%@(==%@)]-5-[%@(==%@)]-5-[%@(==%@)]-5-[%@(==%@)]-10-|", goodHero01.perViewName, goodHero02.perViewName, goodHero01.perViewName, goodHero03.perViewName, goodHero01.perViewName, goodHero04.perViewName , goodHero01.perViewName, goodHero05.perViewName , goodHero01.perViewName];
    [self perAddConstraints: vflV01, vflV02, vflV03, vflV04, vflV05, vflH01, vflH02, nil];
    self.lastHeight = goodHero05.frame.origin.y + goodHero05.frame.size.height + 5;
}
-(void)configueAbilityTypeCellIndexPathRow1WithDic:(NSDictionary *) dic
{
    GoodHero * goodHero01 = [self.perSubviews objectForKey:@"goodHero01"];
    GoodHero * goodHero02 = [self.perSubviews objectForKey:@"goodHero02"];
    GoodHero * goodHero03 = [self.perSubviews objectForKey:@"goodHero03"];
    GoodHero * goodHero04 = [self.perSubviews objectForKey:@"goodHero04"];
    GoodHero * goodHero05 = [self.perSubviews objectForKey:@"goodHero05"];
    
    [goodHero01 configueGoodHeroWithheroId:[dic objectForKey:@"goodHero01ID"] totalNum:[dic objectForKey:@"goodHero01totalNum"] winRate:[dic objectForKey:@"goodHero01winRate"]];
    [goodHero02 configueGoodHeroWithheroId:[dic objectForKey:@"goodHero02ID"] totalNum:[dic objectForKey:@"goodHero02totalNum"] winRate:[dic objectForKey:@"goodHero02winRate"]];
    [goodHero03 configueGoodHeroWithheroId:[dic objectForKey:@"goodHero03ID"] totalNum:[dic objectForKey:@"goodHero03totalNum"] winRate:[dic objectForKey:@"goodHero03winRate"]];
    [goodHero04 configueGoodHeroWithheroId:[dic objectForKey:@"goodHero04ID"] totalNum:[dic objectForKey:@"goodHero04totalNum"] winRate:[dic objectForKey:@"goodHero04winRate"]];
    [goodHero05 configueGoodHeroWithheroId:[dic objectForKey:@"goodHero05ID"] totalNum:[dic objectForKey:@"goodHero05totalNum"] winRate:[dic objectForKey:@"goodHero05winRate"]];
}
-(void)createAbilityTypeCellIndexPathRow2
{
    self.celltype = AbilityCellRow2Type;
    
    //高15
    UILabel * gameAlbumHeader = [[UILabel alloc] initWithName:@"gameAlbumHeader"];
    gameAlbumHeader.font = [UIFont systemFontOfSize:13];
    gameAlbumHeader.text = [NSString stringWithFormat:@"GameAlbums："];
    UILabel * gameAlbumDes = [[UILabel alloc] initWithName:@"gameAlbumDes"];
    gameAlbumDes.font = [UIFont systemFontOfSize:8];
    gameAlbumDes.layer.contents = [UIImage imageNamed:@"personal_honor_event_desc_bg_view"];
//    gameAlbumDes.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"personal_honor_event_desc_bg_view"].CGImage);
    gameAlbumDes.contentMode = UIViewContentModeScaleAspectFit;
    //60x41
    UIButton * gameAlbumButton01 = [[UIButton alloc] initWithName:@"gameAlbumButton01"];
    UIButton * gameAlbumButton02 = [[UIButton alloc] initWithName:@"gameAlbumButton02"];
    UIButton * gameAlbumButton03 = [[UIButton alloc] initWithName:@"gameAlbumButton03"];
    UIButton * gameAlbumButton04 = [[UIButton alloc] initWithName:@"gameAlbumButton04"];
    gameAlbumButton01.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    gameAlbumButton01.titleLabel.textAlignment = NSTextAlignmentCenter;
    gameAlbumButton01.titleLabel.font = [UIFont systemFontOfSize:15];
    gameAlbumButton02.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    gameAlbumButton02.titleLabel.textAlignment = NSTextAlignmentCenter;
    gameAlbumButton02.titleLabel.font = [UIFont systemFontOfSize:15];
    gameAlbumButton03.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    gameAlbumButton03.titleLabel.textAlignment = NSTextAlignmentCenter;
    gameAlbumButton03.titleLabel.font = [UIFont systemFontOfSize:15];
    gameAlbumButton04.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    gameAlbumButton04.titleLabel.textAlignment = NSTextAlignmentCenter;
    gameAlbumButton04.titleLabel.font = [UIFont systemFontOfSize:15];
    UIControl * allGameAlbums = [[UIControl alloc] initWithName:@"allGameAlbums"];
    
    UILabel * all = [[UILabel alloc] initWithName:@"all"];
    all.font = [UIFont systemFontOfSize:8];
    all.text = [NSString stringWithFormat:@"All"];
    all.textColor = [UIColor grayColor];
    all.textAlignment = NSTextAlignmentRight;
    //5x8
    UIImageView * gameAlbumArrow = [[UIImageView alloc] initWithName:@"gameAlbumArrow"];
    gameAlbumArrow.image = [UIImage imageNamed:@"battle_detail_hero_time_arrow"];
    [allGameAlbums perAddSubviews:all, gameAlbumArrow, nil];
    NSString * vflV01 = [NSString stringWithFormat:@"V:|-3.5-[%@(8)]-3.5-|",all.perViewName];
    NSString * vflV02 = [NSString stringWithFormat:@"V:|-3.5-[%@(8)]-3.5-|",gameAlbumArrow.perViewName];
    NSString * vflH01 = [NSString stringWithFormat:@"H:[%@]-5-[%@(5)]|",all.perViewName,gameAlbumArrow.perViewName];
    [allGameAlbums perAddConstraints:vflV01, vflV02, vflH01, nil];
    
    [self perAddSubviews:gameAlbumHeader, gameAlbumDes, gameAlbumButton01, gameAlbumButton02, gameAlbumButton03, gameAlbumButton04, allGameAlbums, nil];
}
-(void)layoutAbilityTypeCellIndexPathRow2
{
    UILabel * gameAlbumHeader = [self.perSubviews objectForKey:@"gameAlbumHeader"];
    UILabel * gameAlbumDes = [self.perSubviews objectForKey:@"gameAlbumDes"];
    //60x41
    UIButton * gameAlbumButton01 = [self.perSubviews objectForKey:@"gameAlbumButton01"];
    UIButton * gameAlbumButton02 = [self.perSubviews objectForKey:@"gameAlbumButton02"];
    UIButton * gameAlbumButton03 = [self.perSubviews objectForKey:@"gameAlbumButton03"];
    UIButton * gameAlbumButton04 = [self.perSubviews objectForKey:@"gameAlbumButton04"];
    UIControl * allGameAlbums = [self.perSubviews objectForKey:@"allGameAlbums"];
    
    NSString * vflV01 = [NSString stringWithFormat:@"V:|-10-[%@(15)]-5-[%@(41)]-10-|", gameAlbumHeader.perViewName, gameAlbumButton01.perViewName];
    NSString * vflV02 = [NSString stringWithFormat:@"V:|-10-[%@(15)]-5-[%@(41)]-10-|", gameAlbumHeader.perViewName, gameAlbumButton02.perViewName];
    NSString * vflV03 = [NSString stringWithFormat:@"V:|-10-[%@(15)]-5-[%@(41)]-10-|", gameAlbumDes.perViewName, gameAlbumButton03.perViewName];
    NSString * vflV04 = [NSString stringWithFormat:@"V:|-10-[%@(15)]-5-[%@(41)]-10-|", allGameAlbums.perViewName, gameAlbumButton04.perViewName];
    NSString * vflH01 = [NSString stringWithFormat:@"H:|-10-[%@]-5-[%@]", gameAlbumHeader.perViewName, gameAlbumDes.perViewName];
    NSString * vflH02 = [NSString stringWithFormat:@"H:[%@]-10-|", allGameAlbums.perViewName];
    CGFloat hRest = ([UIScreen mainScreen].bounds.size.width - 260)/3;
    NSString * vflH03 = [NSString stringWithFormat:@"H:|-10-[%@(60)]-%f-[%@(60)]-%f-[%@(60)]-%f-[%@(60)]-10-|", gameAlbumButton01.perViewName, hRest, gameAlbumButton02.perViewName, hRest, gameAlbumButton03.perViewName, hRest, gameAlbumButton04.perViewName];
    [self perAddConstraints:vflV01, vflV02, vflV03, vflV04, vflH01, vflH02, vflH03, nil];
    self.lastHeight = gameAlbumButton01.frame.origin.y + gameAlbumButton01.frame.size.height + 10;
}
-(void)configueAbilityTypeCellIndexPathRow2WithDic:(NSDictionary *) dic
{
    UILabel * gameAlbumDes = [self.perSubviews objectForKey:@"gameAlbumDes"];
    UIButton * gameAlbumButton01 = [self.perSubviews objectForKey:@"gameAlbumButton01"];
    UIButton * gameAlbumButton02 = [self.perSubviews objectForKey:@"gameAlbumButton02"];
    UIButton * gameAlbumButton03 = [self.perSubviews objectForKey:@"gameAlbumButton03"];
    UIButton * gameAlbumButton04 = [self.perSubviews objectForKey:@"gameAlbumButton04"];
    
    gameAlbumDes.text = [dic objectForKey:@"gameAlbumDes"];
    NSString * str = nil;
    if ([dic objectForKey:@"gameAlbumButton01"]) {
        str = [NSString stringWithFormat:@"%@\nPentaKill",[dic objectForKey:@"gameAlbumButton01"]];
        [gameAlbumButton01 setTitle:str forState:UIControlStateNormal];
        [gameAlbumButton01 setBackgroundImage:[UIImage imageNamed:@"personal_ability_honor_1"] forState:UIControlStateNormal];
        gameAlbumButton01.titleLabel.font = [UIFont systemFontOfSize:10];
//        [gameAlbumButton01 setImage:[UIImage imageNamed:@"personal_ability_honor_1"] forState:UIControlStateNormal];
    }
    if ([dic objectForKey:@"gameAlbumButton02"]) {
        str = [NSString stringWithFormat:@"%@\nQuadraKill",[dic objectForKey:@"gameAlbumButton02"]];
        [gameAlbumButton02 setTitle:str forState:UIControlStateNormal];
        [gameAlbumButton02 setBackgroundImage:[UIImage imageNamed:@"personal_ability_honor_2"] forState:UIControlStateNormal];
        gameAlbumButton02.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    if ([dic objectForKey:@"gameAlbumButton03"]) {
        str = [NSString stringWithFormat:@"%@\nTrilpeKill",[dic objectForKey:@"gameAlbumButton03"]];
        [gameAlbumButton03 setTitle:str forState:UIControlStateNormal];
        [gameAlbumButton03 setBackgroundImage:[UIImage imageNamed:@"personal_ability_honor_3"] forState:UIControlStateNormal];
        gameAlbumButton03.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    if ([dic objectForKey:@"gameAlbumButton04"]) {
        str = [NSString stringWithFormat:@"%@\nDoubleKill",[dic objectForKey:@"gameAlbumButton04"]];
        [gameAlbumButton04 setTitle:str forState:UIControlStateNormal];
        [gameAlbumButton04 setBackgroundImage:[UIImage imageNamed:@"personal_ability_honor_4"] forState:UIControlStateNormal];
        gameAlbumButton04.titleLabel.font = [UIFont systemFontOfSize:10];
    }
}
-(void)createAbilityTypeCellIndexPathRow3
{
    self.celltype = AbilityCellRow3Type;
    
    UIImageView * heroTimeIconV = [[UIImageView alloc] initWithName:@"heroTimeIconV"];
    heroTimeIconV.image = [UIImage imageNamed:@"ability_lol_hero_time"];
    heroTimeIconV.layer.cornerRadius = 14.5;
    heroTimeIconV.clipsToBounds = YES;
    UILabel * myHeroTimeLa = [[UILabel alloc] initWithName:@"myHeroTimeLa"];
    myHeroTimeLa.text = [NSString stringWithFormat:@"My Moment(Video)"];
    myHeroTimeLa.font = [UIFont systemFontOfSize:13];
    UILabel * all = [[UILabel alloc] initWithName:@"all"];
    all.text = [NSString stringWithFormat:@"None(Guide)"];
    all.font = [UIFont systemFontOfSize:10];
    all.textColor = [UIColor grayColor];
    UIImageView * myHeroTimeArrow = [[UIImageView alloc] initWithName:@"myHeroTimeArrow"];
    
    [self perAddSubviews:heroTimeIconV, myHeroTimeLa, all, myHeroTimeArrow, nil];
}
-(void)layoutAbilityTypeCellIndexPathRow3
{
    UIImageView * heroTimeIconV = [self.perSubviews objectForKey:@"heroTimeIconV"];
    UILabel * myHeroTimeLa = [self.perSubviews objectForKey:@"myHeroTimeLa"];
    UILabel * all = [self.perSubviews objectForKey:@"all"];
    UIImageView * myHeroTimeArrow = [self.perSubviews objectForKey:@"myHeroTimeArrow"];
    
    NSString * vflV01 = [NSString stringWithFormat:@"V:|-10-[%@(29)]", heroTimeIconV.perViewName];
    NSString * vflV02 = [NSString stringWithFormat:@"V:|-10-[%@(29)]", myHeroTimeLa.perViewName];
    NSString * vflV03 = [NSString stringWithFormat:@"V:|-10-[%@(29)]", all.perViewName];
    NSString * vflV04 = [NSString stringWithFormat:@"V:|-20.5-[%@(8)]", myHeroTimeArrow.perViewName];
    NSString * vflH01 = [NSString stringWithFormat:@"H:|-10-[%@(29)]-10-[%@]", heroTimeIconV.perViewName, myHeroTimeLa.perViewName];
    NSString * vflH02 = [NSString stringWithFormat:@"H:[%@]-5-[%@(5)]-10-|", all.perViewName, myHeroTimeArrow.perViewName];
    [self perAddConstraints:vflV01, vflV02, vflV03, vflV04, vflH01, vflH02, nil];
    self.lastHeight = heroTimeIconV.frame.origin.y + heroTimeIconV.frame.size.height +10;
}
-(void)configueAbilityTypeCellIndexPathRow3WithDic:(NSDictionary *) dic
{
//    UIImageView * heroTimeIconV = [self.perSubviews objectForKey:@"heroTimeIconV"];
//    UILabel * myHeroTimeLa = [self.perSubviews objectForKey:@"myHeroTimeLa"];
//    UILabel * all = [self.perSubviews objectForKey:@"all"];
//    UIImageView * myHeroTimeArrow = [self.perSubviews objectForKey:@"myHeroTimeArrow"];
}
-(void)createAbilityTypeCellIndexPathRow4
{
    self.celltype = AbilityCellRow4Type;
    
    UIImageView * preHeroV = [[UIImageView alloc] initWithName:@"preHeroV"];
    UILabel * winRateRank = [[UILabel alloc] initWithName:@"winRateRank"];
    UIButton * winRateRankDes = [[UIButton alloc] initWithName:@"winRateRankDes"];
    
    preHeroV.layer.cornerRadius = 14.5;
    preHeroV.clipsToBounds = YES;
    winRateRank.font = [UIFont systemFontOfSize:13];
    [winRateRankDes setImage:[UIImage imageNamed:@"btn_description_normal"] forState:UIControlStateNormal];
    [winRateRankDes setImage:[UIImage imageNamed:@"btn_description_press"] forState:UIControlStateSelected];
    
    [self perAddSubviews:preHeroV, winRateRank, winRateRankDes, nil];
}
-(void)layoutAbilityTypeCellIndexPathRow4
{
    UIImageView * preHeroV = [self.perSubviews objectForKey:@"preHeroV"];
    UILabel * winRateRank = [self.perSubviews objectForKey:@"winRateRank"];
    UIButton * winRateRankDes = [self.perSubviews objectForKey:@"winRateRankDes"];
    
    NSString * vflV01 = [NSString stringWithFormat:@"V:|-10-[%@(29)]", preHeroV.perViewName];
    NSString * vflV02 = [NSString stringWithFormat:@"V:|-17-[%@(15)]", winRateRank.perViewName];
    NSString * vflV03 = [NSString stringWithFormat:@"V:|-12.5-[%@(24)]", winRateRankDes.perViewName];
    NSString * vflH01 = [NSString stringWithFormat:@"H:|-10-[%@(29)]-10-[%@]-10-[%@(24)]", preHeroV.perViewName, winRateRank.perViewName, winRateRankDes.perViewName];
    [self perAddConstraints:vflV01, vflV02, vflV03, vflH01, nil];
    self.lastHeight = preHeroV.frame.origin.y + preHeroV.frame.size.height +10;
}
-(void)configueAbilityTypeCellIndexPathRow4WithDic:(NSDictionary *) dic
{
    UIImageView * preHeroV = [self.perSubviews objectForKey:@"preHeroV"];
    UILabel * winRateRank = [self.perSubviews objectForKey:@"winRateRank"];
    
    preHeroV.image = [UIImage imageNamed:@"default_head"];
    winRateRank.text = [NSString stringWithFormat:@"My Winning Rate Rank：None"];
}
-(void)configueAbilityTypeCellWithDic:(NSDictionary *)dic atIndexPath:(NSIndexPath *)indexPath
{
    NSString * configueMethodStr = [NSString stringWithFormat:@"configueAbilityTypeCellIndexPathRow%dWithDic:",(int)indexPath.row];
    SEL sec = NSSelectorFromString(configueMethodStr);
//    [self performSelector:sec withObject:dic];
    IMP imp = [self methodForSelector:sec];
    void (* func)(id, SEL, NSDictionary *) = (void *)imp;
    func(self, sec, dic);
}

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    switch (self.celltype) {
//            
//        case AbilityCellRow0Type:
//            [self layoutAbilityTypeCellIndexPathRow0];
//            break;
//            
//        case AbilityCellRow1Type:
//            [self layoutAbilityTypeCellIndexPathRow1];
//            break;
//            
//        case AbilityCellRow2Type:
//            [self layoutAbilityTypeCellIndexPathRow2];
//            break;
//            
//        case AbilityCellRow3Type:
//            [self layoutAbilityTypeCellIndexPathRow3];
//            break;
//            
//        case AbilityCellRow4Type:
//            [self layoutAbilityTypeCellIndexPathRow4];
//            break;
//            
//        default:
//            break;
//    }
//}

@end


@implementation GoodHero:UIControl

-(instancetype)initWithName:(NSString *)name
{
    self = [super initWithName:name];
    
    UIImageView * heroImgV = [[UIImageView alloc] initWithName:@"heroImgV"];
    UILabel * des = [[UILabel alloc] initWithName:@"des"];
    [self perAddSubviews:heroImgV, des, nil];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    return self;
}
-(void)layoutSubviews
{
    UIImageView * heroImgV = [self.perSubviews objectForKey:@"heroImgV"];
    UILabel * des = [self.perSubviews objectForKey:@"des"];
    int heiRest = (self.bounds.size.height -75)/2;
    heiRest = heiRest>0?heiRest:0;
    int widRest = (self.bounds.size.width -50)/2;
    widRest = widRest>0?widRest:0;
    NSString * vflV01 = [NSString stringWithFormat:@"V:|-%d-[%@(50)]-5-[%@(20)]", heiRest, heroImgV.perViewName, des.perViewName];
    NSString * vflH01 = [NSString stringWithFormat:@"H:|-%d-[%@(50)]", widRest, heroImgV.perViewName];
    NSString * vflH02 = [NSString stringWithFormat:@"H:|-%d-[%@(50)]", widRest, des.perViewName];
    [self perAddConstraints:vflV01, vflH01, vflH02, nil];
}
-(void)configueGoodHeroWithheroId:(NSString *) heroID totalNum:(NSString *)totalNum winRate:(NSString *)winRate
{
    UIImageView * heroImgV = [self.perSubviews objectForKey:@"heroImgV"];
    UILabel * des = [self.perSubviews objectForKey:@"des"];
    
    heroImgV.layer.cornerRadius = 25;
    heroImgV.clipsToBounds = YES;
    heroImgV.image = [UIImage imageNamed:@"default_head"];
//    NSURL * championAPIURL = [GetData getChampionURLWithID_EN:heroID];
//    NSURLSession * session = [NSURLSession sharedSession];
//    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:championAPIURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"%@",[error userInfo]);
//        }else
//        {
//            NSString * cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//            NSDictionary * championIdc = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:NULL];
//            NSURL * championIconURL = [GetData getChampionIconURLWithName_EN:[championIdc objectForKey:@"name"]];
//            NSString * iconName = [NSString stringWithFormat:@"championIcon_EN_%@.png", [championIdc objectForKey:@"name"]];
//            NSString * championIconPath = [cachesDir stringByAppendingPathComponent:iconName];
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                [heroImgV setImage:NULL WithContentsOfFile:championIconPath cacheFromURL:championIconURL];
//            }];
//        }
//    }];
//    [dataTask resume];
    
    NSString * cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSArray * arr = [GetData getChampionsBrife_ENWithId:heroID];
    ChampionsBrief_EN * championsBrief_EN = [arr firstObject];
    NSURL * championIconURL = [GetData getChampionIconURLWithName_EN:championsBrief_EN.square];
    NSString * nameKey = [NSString stringWithFormat:@"championIcon_EN_%@.png", championsBrief_EN.id];
    NSString * championIconPath = [cachesDir stringByAppendingPathComponent:nameKey];
    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
        [heroImgV setImage:NULL NameKey:nameKey inCache:NULL named:nameKey WithContentsOfFile:championIconPath cacheFromURL:championIconURL];
    }];
    
    des.numberOfLines = 2;
    des.textAlignment = NSTextAlignmentCenter;
    des.font = [UIFont systemFontOfSize:8];
    des.text = [NSString stringWithFormat:@"%@ Matches \n %@ Wins", totalNum, winRate];
}
@end
