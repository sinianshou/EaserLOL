//
//  MasteriesVC.m
//  LOLHelper
//
//  Created by Easer Liu on 11/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "MasteriesVC.h"
#import "NavBackButton.h"
#import "SpotlightView.h"
#import "MasteryPageV.h"
#import "GetData.h"

@interface MasteriesVC ()


@property (strong, nonatomic) NSString * cachesDir;
@property (assign, nonatomic) NSString * availablePoint;
//@property (assign, nonatomic) CGFloat contentHeight;
@property (assign, nonatomic) CGSize screenSize;
@property (strong, nonatomic) UIImageView * nav_bg;
@property (strong, nonatomic) UIView * headerButtonsV;
@property (strong, nonatomic) UIImageView * selectedImgV;
@property (strong, nonatomic) SpotlightView * spotLightV;
@property (strong, nonatomic) UIScrollView * ContentScrollV;
@property (strong, nonatomic) MasteryPageV * page01;
@property (strong, nonatomic) MasteryPageV * page02;
@property (strong, nonatomic) MasteryPageV * page03;

@end

@implementation MasteriesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cachesDir =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    self.screenSize = [UIScreen mainScreen].bounds.size;
    
    //640*1136
    UIImageView * bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bkgs"]];
    bg.bounds = CGRectMake(0, 0, self.screenSize.width, self.screenSize.width*1136/640);
    bg.center = CGPointMake(bg.bounds.size.width/2, self.screenSize.height - bg.bounds.size.height/2);
    [self.view addSubview:bg];
    
    self.spotLightV = [[SpotlightView alloc] init];
    self.spotLightV.frame = CGRectMake(0, 0, self.screenSize.width, self.screenSize.height);
    [self.view addSubview:self.spotLightV];
    
    
    [self setNavigationView];
    [self setHeaderButtonsV];
    
    self.ContentScrollV = [[UIScrollView alloc] init];
    self.ContentScrollV.frame = CGRectMake(0, self.self.headerButtonsV.frame.origin.y + self.self.headerButtonsV.frame.size.height, self.screenSize.width, self.screenSize.height - (self.self.headerButtonsV.frame.origin.y + self.self.headerButtonsV.frame.size.height));
    self.ContentScrollV.contentSize = CGSizeMake(self.ContentScrollV.frame.size.width*3, self.ContentScrollV.frame.size.height);
    self.ContentScrollV.pagingEnabled = YES;
    self.ContentScrollV.delegate = self;
    [self.view addSubview:self.ContentScrollV];
    
    self.availablePoint = [NSString stringWithFormat:@"10"];
    NSArray<MasteryData_EN *>* masteryDataArr01 = [GetData getMasteryData_ENWithId:NULL masteryTree:@"Ferocity"];
    if (masteryDataArr01.count > 0) {
        self.page01 = [[MasteryPageV alloc] initWithFrame:CGRectMake(self.ContentScrollV.bounds.size.width*0, 0, self.ContentScrollV.bounds.size.width, self.ContentScrollV.bounds.size.height) masteriesArr:masteryDataArr01];
        [self.page01.addButton addTarget:self action:@selector(checkAvailablePoint) forControlEvents:UIControlEventTouchUpInside];
        [self.page01.reduceButton addTarget:self action:@selector(checkAvailablePoint) forControlEvents:UIControlEventTouchUpInside];
        [self.page01.addButton addTarget:self action:@selector(checkAvailablePoint) forControlEvents:UIControlEventTouchDownRepeat];
        [self.page01.reduceButton addTarget:self action:@selector(checkAvailablePoint) forControlEvents:UIControlEventTouchDownRepeat];
        [self.ContentScrollV addSubview:self.page01];
    }
    
    NSArray<MasteryData_EN *>* masteryDataArr02 = [GetData getMasteryData_ENWithId:NULL masteryTree:@"Cunning"];
    if (masteryDataArr02.count > 0) {
        self.page02 = [[MasteryPageV alloc] initWithFrame:CGRectMake(self.ContentScrollV.bounds.size.width*1, 0, self.ContentScrollV.bounds.size.width, self.ContentScrollV.bounds.size.height) masteriesArr:masteryDataArr02];
        [self.page02.addButton addTarget:self action:@selector(checkAvailablePoint) forControlEvents:UIControlEventTouchUpInside];
        [self.page02.reduceButton addTarget:self action:@selector(checkAvailablePoint) forControlEvents:UIControlEventTouchUpInside];
        [self.page02.addButton addTarget:self action:@selector(checkAvailablePoint) forControlEvents:UIControlEventTouchDownRepeat];
        [self.page02.reduceButton addTarget:self action:@selector(checkAvailablePoint) forControlEvents:UIControlEventTouchDownRepeat];
        [self.ContentScrollV addSubview:self.page02];
    }
    
    NSArray<MasteryData_EN *>* masteryDataArr03 = [GetData getMasteryData_ENWithId:NULL masteryTree:@"Resolve"];
    if (masteryDataArr03.count > 0) {
        self.page03 = [[MasteryPageV alloc] initWithFrame:CGRectMake(self.ContentScrollV.bounds.size.width*2, 0, self.ContentScrollV.bounds.size.width, self.ContentScrollV.bounds.size.height) masteriesArr:masteryDataArr03];
        [self.page03.addButton addTarget:self action:@selector(checkAvailablePoint) forControlEvents:UIControlEventTouchUpInside];
        [self.page03.reduceButton addTarget:self action:@selector(checkAvailablePoint) forControlEvents:UIControlEventTouchUpInside];
        [self.page03.addButton addTarget:self action:@selector(checkAvailablePoint) forControlEvents:UIControlEventTouchDownRepeat];
        [self.page03.reduceButton addTarget:self action:@selector(checkAvailablePoint) forControlEvents:UIControlEventTouchDownRepeat];
        [self.ContentScrollV addSubview:self.page03];
    }
    
    
    // Do any additional setup after loading the view.
}

-(void)checkAvailablePoint
{
//    int p = self.availablePoint.intValue;
//    p -= (self.page01.totalPoint.intValue + self.page02.totalPoint.intValue + self.page03.totalPoint.intValue);
    self.availablePoint = [NSString stringWithFormat:@"%d",30- (self.page01.totalPoint.intValue + self.page02.totalPoint.intValue + self.page03.totalPoint.intValue)];
    NSLog(@" availablePoint is %@ page01.totalPoint is %@ page02.totalPoint is %@ page03.totalPoint is %@", self.availablePoint, self.page01.totalPoint, self.page02.totalPoint, self.page03.totalPoint);
    [self.page01 updateAvailablePoint:self.availablePoint];
    [self.page02 updateAvailablePoint:self.availablePoint];
    [self.page03 updateAvailablePoint:self.availablePoint];
    [self.headerButtonsV.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton * button = obj;
            if ([button.currentTitle containsString:@"Ferocity"]) {
                [button setTitle:[NSString stringWithFormat:@"Ferocity:%@", self.page01.totalPoint] forState:UIControlStateNormal];
            }else if ([button.currentTitle containsString:@"Cunning"])
            {
                [button setTitle:[NSString stringWithFormat:@"Cunning:%@", self.page02.totalPoint] forState:UIControlStateNormal];
            }else if ([button.currentTitle containsString:@"Resolve"])
            {
                [button setTitle:[NSString stringWithFormat:@"Resolve:%@", self.page03.totalPoint] forState:UIControlStateNormal];
            }else if ([button.currentTitle containsString:@"Points"])
            {
                [button setTitle:[NSString stringWithFormat:@"Points:%@", self.availablePoint] forState:UIControlStateNormal];
            }
        }
    }];
}

-(void)resetAllPoints
{
    [self.page01 resetPoints];
    [self.page02 resetPoints];
    [self.page03 resetPoints];
    [self checkAvailablePoint];
}

-(void)setNavigationView
{
    //640*128 nav_bar_bg_for_seven
    self.nav_bg = [[UIImageView alloc] init];
    self.nav_bg.frame = CGRectMake(0, 0, self.screenSize.width, self.screenSize.width*128/640);
    self.nav_bg.image = [UIImage imageNamed:@"nav_bar_bg_for_seven"];
    self.nav_bg.userInteractionEnabled = YES;
    [self.view addSubview:self.nav_bg];
    
    NavBackButton * backB = [[NavBackButton alloc] initWithBackButtonType:BackButtonTypeNav];
    backB.center = CGPointMake(10 + backB.bounds.size.width/2, self.nav_bg.bounds.size.height - (20 + backB.bounds.size.height/2));
    [backB addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [self.nav_bg addSubview:backB];
    
    UILabel * titleLa = [[UILabel alloc] init];
    titleLa.text = [NSString stringWithFormat:@"Mastery Simulator"];
    titleLa.textColor = backB.currentTitleColor;
    [titleLa sizeToFit];
    titleLa.center = CGPointMake(self.screenSize.width/2, backB.center.y);
    [self.nav_bg addSubview:titleLa];
    
    UIButton * resetB = [[UIButton alloc] initWithFrame:CGRectMake(self.screenSize.width - (backB.frame.size.width + 10), backB.frame.origin.y, backB.frame.size.width, backB.frame.size.height)];
    [resetB setTitle:@"Reset" forState:UIControlStateNormal];
    [resetB setTitleColor:backB.currentTitleColor forState:UIControlStateNormal];
    [resetB addTarget:self action:@selector(resetAllPoints) forControlEvents:UIControlEventTouchUpInside];
    [self.nav_bg addSubview:resetB];
}

-(void)setHeaderButtonsV
{
    self.headerButtonsV = [[UIView alloc] init];
    self.headerButtonsV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    NSArray <NSString *>* titlesArr = [NSArray arrayWithObjects:@"Ferocity:0", @"Cunning:0", @"Resolve:0", @"Points:30", nil];
    [titlesArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * b = [[UIButton alloc] init];
        b.bounds = CGRectMake(0, 0, (self.screenSize.width-50)/4, 15);
        b.titleLabel.font = [UIFont systemFontOfSize:12];
        [b setTitle:obj forState:UIControlStateNormal];
        if (idx == titlesArr.count-1) {
            [b setBackgroundColor:[UIColor colorWithRed:60/255.00 green:60/255.00 blue:60/255.00 alpha:0.5]];
            [b setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }else
        {
            if (idx == 0) {
                b.selected = YES;
            }
            [b setTitleColor:[UIColor colorWithRed:205/255.00 green:149/255.00 blue:12/255.00 alpha:1] forState:UIControlStateNormal];
            [b setTitleColor:[UIColor colorWithRed:205/255.00 green:185/255.00 blue:130/255.00 alpha:1] forState:UIControlStateSelected];
            [b addTarget:self action:@selector(scrollIntoMasterPage:) forControlEvents:UIControlEventTouchUpInside];
        }
        b.center = CGPointMake((b.bounds.size.width/2 + 10) + (b.bounds.size.width + 10)*idx, b.bounds.size.height/2+10);
        [self.headerButtonsV addSubview:b];
        
    }];
    self.selectedImgV = [[UIImageView alloc] init];
    self.selectedImgV.bounds = CGRectMake(0, 0, 39, 5.5);
    //78*11 tab_selected
    self.selectedImgV.image = [UIImage imageNamed:@"tab_selected"];
    self.selectedImgV.center = CGPointMake(self.headerButtonsV.subviews.firstObject.center.x, self.headerButtonsV.subviews.firstObject.center.y + self.headerButtonsV.subviews.firstObject.bounds.size.height/2 + 3 + self.selectedImgV.bounds.size.height/2);
    [self.headerButtonsV addSubview:self.selectedImgV];
    self.headerButtonsV.frame = CGRectMake(0, self.nav_bg.frame.origin.y + self.nav_bg.frame.size.height, self.screenSize.width, self.selectedImgV.frame.origin.y + self.selectedImgV.frame.size.height + 3);
    [self.view addSubview:self.headerButtonsV];
}

-(void)scrollIntoMasterPage:(UIButton *)button
{
//     NSArray <NSString *>* titlesArr = [NSArray arrayWithObjects:@"Ferocity:0", @"Cunning:0", @"Resolve:0", @"Points:30", nil];
    [self.headerButtonsV.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]] && ((UIButton *)obj).selected) {
            ((UIButton *)obj).selected = NO;
        }
    }];
    button.selected = YES;
    if ([button.currentTitle containsString:@"Ferocity"]) {
        [self.ContentScrollV scrollRectToVisible:CGRectMake(0, 0, self.ContentScrollV.bounds.size.width, self.ContentScrollV.bounds.size.height) animated:YES];
    }else if ([button.currentTitle containsString:@"Cunning"])
    {
        [self.ContentScrollV scrollRectToVisible:CGRectMake(self.ContentScrollV.bounds.size.width, 0, self.ContentScrollV.bounds.size.width, self.ContentScrollV.bounds.size.height) animated:YES];
    }else if ([button.currentTitle containsString:@"Resolve"])
    {
        [self.ContentScrollV scrollRectToVisible:CGRectMake(self.ContentScrollV.bounds.size.width*2, 0, self.ContentScrollV.bounds.size.width, self.ContentScrollV.bounds.size.height) animated:YES];
    }
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
#pragma mark - dismissAction
-(void)dismissAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegrate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat rate = scrollView.contentOffset.x/scrollView.bounds.size.width;
    CGFloat red = 255;
    CGFloat green = 0;
    CGFloat blue = 0;
    if (rate <=1) {
        blue = 255 * rate;
    }else
    {
        blue = 255;
        red = 255 - 255 * (rate-1);
        green = 255 * (rate-1);
    }
    NSLog(@"scrollView.contentOffset.x is %f", scrollView.contentOffset.x);
    self.spotLightV.startColor = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f", red], [NSString stringWithFormat:@"%f", green], [NSString stringWithFormat:@"%f", blue], @"1", nil];
    [self.spotLightV setNeedsDisplay];
    self.selectedImgV.center = CGPointMake(self.screenSize.width/8 + self.screenSize.width*rate/4, self.selectedImgV.center.y);
    if (rate == 0) {
        [self performSelector:@selector(scrollIntoMasterPage:) withObject:((UIButton *)[self.headerButtonsV.subviews objectAtIndex:0])];
    }else if (rate == 1)
    {
        [self performSelector:@selector(scrollIntoMasterPage:) withObject:((UIButton *)[self.headerButtonsV.subviews objectAtIndex:1])];
    }else if (rate == 2)
    {
        [self performSelector:@selector(scrollIntoMasterPage:) withObject:((UIButton *)[self.headerButtonsV.subviews objectAtIndex:2])];
    }
}
@end
