//
//  ChampDetailViewController.m
//  LOLHelper
//
//  Created by Easer Liu on 28/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "ChampDetailViewController.h"
#import "PerCategory.h"
#import "ChampDetailModel.h"
#import "SKFlowLayout.h"

@interface ChampDetailViewController ()

@property (strong, nonatomic) ChampDetailModel * champDetailModel;

@end

@implementation ChampDetailViewController
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}



-(void)defaultSubviews
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.championIcon.bounds = CGRectMake(0, 0, 60, 60);
    self.championIcon.layer.cornerRadius = 30;
    self.championIcon.clipsToBounds = YES;
    self.infoView.bounds = CGRectMake(0, 0, screenSize.width/3, screenSize.width/3);
    self.skillsView.clipsToBounds = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.SkinsView.dataSource = self;
    self.SkinsView.delegate = self;
    // 创建自定义FKFlowLayout布局管理器对象
    SKFlowLayout* flowLayout = [[SKFlowLayout alloc] init];
    // 指定使用FKFlowLayout布局管理器
    self.SkinsView.collectionViewLayout = flowLayout;
    self.SkinsView.showsHorizontalScrollIndicator = NO;
    
    self.loreWebView.delegate = self;
    self.loreWebView.scrollView.bounces = NO;
    self.loreWebView.scrollView.showsHorizontalScrollIndicator = NO;
    self.loreWebView.scrollView.scrollEnabled = NO;
    [self.loreWebView sizeToFit];
    
    self.allytipsWebView.delegate = self;
    self.allytipsWebView.scrollView.scrollEnabled = NO;
    self.enemytipsWebView.delegate = self;
    self.enemytipsWebView.scrollView.scrollEnabled = NO;
    
    
    [self resetWithChampDetailModel];
    [self defaultSubviews];
    [self layoutPersubviews];
    
    
    [self configureActions];
    UIImage * im =[UIImage imageNamed:@"brownPaperBG"];
    UIColor *bgColor = [UIColor colorWithPatternImage: im];
    
    
    self.view.backgroundColor = bgColor;
    
    self.perScrollView.scrollsToTop = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.perScrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

-(void)resetWithDic:(NSDictionary *)dic
{
    if (self.champDetailModel == nil) {
        self.champDetailModel = [[ChampDetailModel alloc] initWithDic:dic];
    }else
    {
        [self.champDetailModel resetWithDic:dic];
        [self defaultReset];
        [self resetWithChampDetailModel];
    }
    
}
-(void)defaultReset
{}
-(void)resetWithChampDetailModel
{
    self.championIcon.image = self.championIconImage;
    if (self.champDetailModel != nil) {
        
        [self.BGP setImage:NULL NameKey:self.champDetailModel.BGPnameKey inCache:NULL named:NULL WithContentsOfFile:self.champDetailModel.BGPpath cacheFromURL:self.champDetailModel.BGPURL];
        [self.difficulty setProgress:self.champDetailModel.difficulty animated:YES];
        [self.attack setProgress:self.champDetailModel.attack animated:YES];
        [self.defense setProgress:self.champDetailModel.defense animated:YES];
        [self.magic setProgress:self.champDetailModel.magic animated:YES];
        
        NSMutableAttributedString * attTitleName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", self.champDetailModel.name, self.champDetailModel.title]];
        [attTitleName addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0,self.champDetailModel.name.length)];
        [attTitleName addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(self.champDetailModel.name.length+1,self.champDetailModel.title.length)];
        self.titleName.attributedText = attTitleName;
        
        self.HP.text = [NSString stringWithFormat:@"HP：\n%.2f(+%.2f per level)", self.champDetailModel.hp , self.champDetailModel.hpperlevel];
        self.HPR.text = [NSString stringWithFormat:@"HP Regen：\n%.2f(+%.2f per level)", self.champDetailModel.hpregen , self.champDetailModel.hpregenperlevel];
        self.MP.text = [NSString stringWithFormat:@"MP：\n%.2f(+%.2f per level)", self.champDetailModel.mp , self.champDetailModel.mpperlevel];
        self.MPR.text = [NSString stringWithFormat:@"MP Regen：\n%.2f(+%.2f per level)", self.champDetailModel.mpregen , self.champDetailModel.mpregenperlevel];
        self.MS.text = [NSString stringWithFormat:@"Move Speed：\n%.2f", self.champDetailModel.movespeed ];
        
        self.AD.text = [NSString stringWithFormat:@"Attack Damage： \n%.2f(+%.2f per level)", self.champDetailModel.attackdamage , self.champDetailModel.attackdamageperlevel];
        self.AS.text = [NSString stringWithFormat:@"Attack Speed：\n%.2f(+%.2f per level)", self.champDetailModel.attackspeedoffset , self.champDetailModel.attackspeedperlevel];
        self.AR.text = [NSString stringWithFormat:@"Attack Range：\n%.2f", self.champDetailModel.attackrange];
        self.Armor.text = [NSString stringWithFormat:@"Armor：\n%.2f(+%.2f per level)", self.champDetailModel.armor , self.champDetailModel.armorperlevel];
        self.SB.text = [NSString stringWithFormat:@"Magic Resist：\n%.2f(+%.2f per level)", self.champDetailModel.spellblock , self.champDetailModel.spellblockperlevel];
        
        [self.PSkill setImage:NULL NameKey:self.champDetailModel.PSkillnameKey inCache:NULL named:NULL WithContentsOfFile:self.champDetailModel.PSkillpath cacheFromURL:self.champDetailModel.PSkillURL forState:UIControlStateNormal];
        self.SkillTextView.text = self.champDetailModel.PSkilltext;
        [self.QSkill setImage:NULL NameKey:self.champDetailModel.QSkillnameKey inCache:NULL named:NULL WithContentsOfFile:self.champDetailModel.QSkillpath cacheFromURL:self.champDetailModel.QSkillURL forState:UIControlStateNormal];
        [self.WSkill setImage:NULL NameKey:self.champDetailModel.WSkillnameKey inCache:NULL named:NULL WithContentsOfFile:self.champDetailModel.WSkillpath cacheFromURL:self.champDetailModel.WSkillURL forState:UIControlStateNormal];
        [self.ESkill setImage:NULL NameKey:self.champDetailModel.ESkillnameKey inCache:NULL named:NULL WithContentsOfFile:self.champDetailModel.ESkillpath cacheFromURL:self.champDetailModel.ESkillURL forState:UIControlStateNormal];
        [self.RSkill setImage:NULL NameKey:self.champDetailModel.RSkillnameKey inCache:NULL named:NULL WithContentsOfFile:self.champDetailModel.RSkillpath cacheFromURL:self.champDetailModel.RSkillURL forState:UIControlStateNormal];
        
        [self.SkinsView reloadData];
        
        
        ///////////////////////////////设置内容，这里包装一层div，用来获取内容实际高度（像素），htmlcontent是html格式的字符串//////////////
        NSString * allytipscontent = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", self.champDetailModel.allytips];
        [self.allytipsWebView loadHTMLString:allytipscontent baseURL:nil];
        NSString * enemytipscontent = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", self.champDetailModel.enemytips];
        [self.enemytipsWebView loadHTMLString:enemytipscontent baseURL:nil];
        NSString * loreWebViewcontent = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>", self.champDetailModel.lore];
        [self.loreWebView loadHTMLString:loreWebViewcontent baseURL:nil];
        
    }
}

-(void)layoutPersubviews
{
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    //1215x717
    self.BGP.frame = CGRectMake(0, 0, screenSize.width, screenSize.width*717/1215);
    self.championIcon.center = CGPointMake(screenSize.width/4, self.BGP.frame.size.height);
    self.infoView.bounds = CGRectMake(0, 0, screenSize.width/3, screenSize.width/3);
    self.infoView.center = CGPointMake(self.infoView.bounds.size.width/2 + 20, self.BGP.center.y+20);
    [self.infoView setBackgroundColor:[UIColor clearColor]];
    
    CGRect titleNameFrame =CGRectMake(self.championIcon.frame.origin.x + self.championIcon.frame.size.width + 10, self.BGP.frame.size.height, screenSize.width-(self.championIcon.frame.origin.x + self.championIcon.frame.size.width + 10), MAXFLOAT);
    //计算attributedString的rect
    CGRect contentRect = [self.titleName.attributedText boundingRectWithSize:titleNameFrame.size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    titleNameFrame = CGRectMake(titleNameFrame.origin.x, titleNameFrame.origin.y, titleNameFrame.size.width, contentRect.size.height);
    self.titleName.frame = titleNameFrame;
    
    self.statsView.frame = CGRectMake(0, self.titleName.frame.origin.y + self.titleName.frame.size.height, screenSize.width, screenSize.width/2);
    
    self.skillsView.frame = CGRectMake(10, self.statsView.frame.origin.y + self.statsView.frame.size.height, screenSize.width - 20, screenSize.height - self.statsView.frame.origin.y - self.statsView.frame.size.height);
    self.SkinLa.frame = CGRectMake(10, self.skillsView.frame.origin.y + self.skillsView.frame.size.height, screenSize.width, 20);
    self.SkinsView.frame = CGRectMake(0, self.SkinLa.frame.origin.y + self.SkinLa.frame.size.height, screenSize.width, 280);
    
    self.allytipsWebView.frame = CGRectMake(0, self.SkinsView.frame.origin.y + self.SkinsView.frame.size.height, screenSize.width, self.allytipsWebView.frame.size.height);
    self.enemytipsWebView.frame = CGRectMake(0, self.allytipsWebView.frame.origin.y + self.allytipsWebView.frame.size.height, screenSize.width, self.enemytipsWebView.frame.size.height);
    self.loreWebView.frame = CGRectMake(0, self.enemytipsWebView.frame.origin.y + self.enemytipsWebView.frame.size.height, screenSize.width, self.loreWebView.frame.size.height);
    NSLog(@" self.allytipsWebView.frame.size.height is %f, self.enemytipsWebView.frame.size.height is %f, self.loreWebView.frame.size.height is %f", self.allytipsWebView.frame.size.height,self.enemytipsWebView.frame.size.height, self.loreWebView.frame.size.height);
    
    
    [self layoutInfoView];
    [self layoutStatsView];
    [self layoutSkillsView];
    CGFloat hei = self.loreWebView.frame.origin.y + self.loreWebView.frame.size.height +10>screenSize.height?self.loreWebView.frame.origin.y + self.loreWebView.frame.size.height +10:screenSize.height;
    
    
    self.perScrollView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    self.perScrollView.contentSize = CGSizeMake(screenSize.width, hei);
    
}

- (IBAction)changeSkillTextVIewContent:(UIButton *)sender
{
    switch (sender.restorationIdentifier.intValue) {
        case 1:
            self.SkillTextView.text = self.champDetailModel.QSkilltext;
            break;
            
        case 2:
            self.SkillTextView.text = self.champDetailModel.WSkilltext;
            break;
            
        case 3:
            self.SkillTextView.text = self.champDetailModel.ESkilltext;
            break;
            
        case 4:
            self.SkillTextView.text = self.champDetailModel.RSkilltext;
            break;
            
        default:
            self.SkillTextView.text = self.champDetailModel.PSkilltext;
            break;
    }
}
-(void)layoutInfoView
{
    CGSize infoViewSize = self.infoView.bounds.size;
    self.difficutyLa.frame = CGRectMake(0, 0, infoViewSize.width, infoViewSize.height/8);
    self.difficulty.frame= CGRectMake(0, self.difficutyLa.frame.origin.y+self.difficutyLa.frame.size.height + infoViewSize.height/32, infoViewSize.width, infoViewSize.height/16);
    self.attackLa.frame = CGRectMake(0, self.difficulty.frame.origin.y+self.difficulty.frame.size.height + infoViewSize.height/32, infoViewSize.width, infoViewSize.height/8);
    self.attack.frame= CGRectMake(0, self.attackLa.frame.origin.y+self.attackLa.frame.size.height + infoViewSize.height/32, infoViewSize.width, infoViewSize.height/16-1);
    self.defenseLa.frame = CGRectMake(0, self.attack.frame.origin.y+self.attack.frame.size.height + infoViewSize.height/32, infoViewSize.width, infoViewSize.height/8);
    self.defense.frame= CGRectMake(0, self.defenseLa.frame.origin.y+self.defenseLa.frame.size.height + infoViewSize.height/32, infoViewSize.width, infoViewSize.height/16-1);
    self.magicLa.frame = CGRectMake(0, self.defense.frame.origin.y+self.defense.frame.size.height + infoViewSize.height/32, infoViewSize.width, infoViewSize.height/8);
    self.magic.frame= CGRectMake(0, self.magicLa.frame.origin.y+self.magicLa.frame.size.height + infoViewSize.height/32, infoViewSize.width, infoViewSize.height/16-1);
}
-(void)layoutStatsView
{
    CGSize statsViewSize = self.statsView.bounds.size;
    self.HP.frame = CGRectMake(statsViewSize.width/18, 0, statsViewSize.width*4/9, statsViewSize.height/5);
    self.HPR.frame = CGRectMake(statsViewSize.width/18, self.HP.frame.origin.y+self.HP.frame.size.height, statsViewSize.width*4/9, statsViewSize.height/5);
    self.MP.frame = CGRectMake(statsViewSize.width/18, self.HPR.frame.origin.y+self.HPR.frame.size.height, statsViewSize.width*4/9, statsViewSize.height/5);
    self.MPR.frame = CGRectMake(statsViewSize.width/18, self.MP.frame.origin.y+self.MP.frame.size.height, statsViewSize.width*4/9, statsViewSize.height/5);
    self.MS.frame = CGRectMake(statsViewSize.width/18, self.MPR.frame.origin.y+self.MPR.frame.size.height, statsViewSize.width*4/9, statsViewSize.height/5);
    
    self.AD.frame = CGRectMake(self.HP.frame.origin.x + self.HP.frame.size.width + 5, 0, statsViewSize.width*4/9, statsViewSize.height/5);
    self.AS.frame = CGRectMake(self.HPR.frame.origin.x + self.HPR.frame.size.width + 5, self.AD.frame.origin.y+self.AD.frame.size.height, statsViewSize.width*4/9, statsViewSize.height/5);
    self.AR.frame = CGRectMake(self.MP.frame.origin.x + self.MP.frame.size.width + 5, self.AS.frame.origin.y+self.AS.frame.size.height, statsViewSize.width*4/9, statsViewSize.height/5);
    self.Armor.frame = CGRectMake(self.MPR.frame.origin.x + self.MPR.frame.size.width + 5, self.AR.frame.origin.y+self.AR.frame.size.height, statsViewSize.width*4/9, statsViewSize.height/5);
    self.SB.frame = CGRectMake(self.MS.frame.origin.x + self.MS.frame.size.width + 5, self.Armor.frame.origin.y+self.Armor.frame.size.height, statsViewSize.width*4/9, statsViewSize.height/5);
    
    CGFloat fontHei = statsViewSize.height/10 - 1;
    NSLog(@"fontHei is %f", fontHei);
    self.HP.font = [UIFont systemFontOfSize:10];
    self.HPR.font = [UIFont systemFontOfSize:10];
    self.MP.font = [UIFont systemFontOfSize:10];
    self.MPR.font = [UIFont systemFontOfSize:10];
    self.MS.font = [UIFont systemFontOfSize:10];
    self.AD.font = [UIFont systemFontOfSize:10];
    self.AS.font = [UIFont systemFontOfSize:10];
    self.AR.font = [UIFont systemFontOfSize:10];
    self.Armor.font = [UIFont systemFontOfSize:10];
    self.SB.font = [UIFont systemFontOfSize:10];
}
-(void)layoutSkillsView
{
    self.AbilitiesLa.frame = CGRectMake(0, 0, self.skillsView.bounds.size.width, 15);
    self.PSkill.frame = CGRectMake(0, self.AbilitiesLa.frame.size.height + 5, 32, 32);
    self.QSkill.frame = CGRectMake(37*1, self.AbilitiesLa.frame.size.height + 5, 32, 32);
    self.WSkill.frame = CGRectMake(37*2, self.AbilitiesLa.frame.size.height + 5, 32, 32);
    self.ESkill.frame = CGRectMake(37*3, self.AbilitiesLa.frame.size.height + 5, 32, 32);
    self.RSkill.frame = CGRectMake(37*4, self.AbilitiesLa.frame.size.height + 5, 32, 32);
    self.SkillTextView.frame = CGRectMake(0, self.PSkill.frame.origin.y+self.PSkill.frame.size.height +5, self.skillsView.bounds.size.width, self.skillsView.bounds.size.height - 37);
}

-(void)configureActions
{
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
 #pragma mark - SkinsCollectionView
-(nonnull __kindof UICollectionViewCell *) collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString * reuseIdentifier = [NSString stringWithFormat:@"detailCoId"];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSDictionary * skinDic = self.champDetailModel.loadingScreenArts[indexPath.row];
    UIImageView * skin = [cell viewWithTag:111];
    [skin setImage:NULL NameKey:[skinDic objectForKey:@"loadingArtnameKey"] inCache:NULL named:NULL WithContentsOfFile:[skinDic objectForKey:@"loadingArtpath"] cacheFromURL:[skinDic objectForKey:@"loadingArtURL"]];
    return cell;
}

-(NSInteger) collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.champDetailModel != nil) {
        return self.champDetailModel.skins.count;
    }else
    {
        return 0;
    }
}


 #pragma mark - WebView
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    //获取内容实际高度（像素）
    NSString * height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
    float height = [height_str floatValue];
    
    //再次设置WebView高度（点）
    webView.bounds = CGRectMake(0, 0, self.view.frame.size.width, height);
    
    NSLog(@"webView.restorationIdentifier is %@",webView.restorationIdentifier );
    
    
    
    if ([webView.restorationIdentifier isEqualToString:@"loreWebView"]) {
        [self layoutPersubviews];
    }
    
}

@end
