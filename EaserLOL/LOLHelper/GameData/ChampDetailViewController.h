//
//  ChampDetailViewController.h
//  LOLHelper
//
//  Created by Easer Liu on 28/07/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//
#ifndef ChampDetailViewController_h
#define ChampDetailViewController_h

#import <UIKit/UIKit.h>

@interface ChampDetailViewController : UIViewController <UICollectionViewDataSource,
UICollectionViewDelegate, UIWebViewDelegate>

@property (strong, nonatomic) NSDictionary * dataDic;
@property (strong, nonatomic) IBOutlet UIScrollView *perScrollView;

@property (strong, nonatomic) IBOutlet UIImageView *championIcon;
@property (strong, nonatomic) IBOutlet UIImage *championIconImage;
@property (strong, nonatomic) IBOutlet UIImageView *BGP;

@property (strong, nonatomic) IBOutlet UIView *infoView;
@property (strong, nonatomic) IBOutlet UILabel *difficutyLa;
@property (strong, nonatomic) IBOutlet UIProgressView *difficulty;
@property (strong, nonatomic) IBOutlet UILabel *attackLa;
@property (strong, nonatomic) IBOutlet UIProgressView *attack;
@property (strong, nonatomic) IBOutlet UILabel *defenseLa;
@property (strong, nonatomic) IBOutlet UIProgressView *defense;
@property (strong, nonatomic) IBOutlet UILabel *magicLa;
@property (strong, nonatomic) IBOutlet UIProgressView *magic;

@property (strong, nonatomic) IBOutlet UIView *statsView;
@property (strong, nonatomic) IBOutlet UILabel *HP;
@property (strong, nonatomic) IBOutlet UILabel *HPR;
@property (strong, nonatomic) IBOutlet UILabel *MP;
@property (strong, nonatomic) IBOutlet UILabel *MPR;
@property (strong, nonatomic) IBOutlet UILabel *MS;
@property (strong, nonatomic) IBOutlet UILabel *AD;
@property (strong, nonatomic) IBOutlet UILabel *AS;
@property (strong, nonatomic) IBOutlet UILabel *AR;
@property (strong, nonatomic) IBOutlet UILabel *Armor;
@property (strong, nonatomic) IBOutlet UILabel *SB;

@property (strong, nonatomic) IBOutlet UILabel *titleName;

@property (strong, nonatomic) IBOutlet UIView *skillsView;
@property (strong, nonatomic) IBOutlet UILabel *AbilitiesLa;
@property (strong, nonatomic) IBOutlet UIButton *PSkill;
@property (strong, nonatomic) IBOutlet UIButton *QSkill;
@property (strong, nonatomic) IBOutlet UIButton *WSkill;
@property (strong, nonatomic) IBOutlet UIButton *ESkill;
@property (strong, nonatomic) IBOutlet UIButton *RSkill;
@property (strong, nonatomic) IBOutlet UITextView *SkillTextView;

@property (strong, nonatomic) IBOutlet UILabel *SkinLa;
@property (strong, nonatomic) IBOutlet UICollectionView *SkinsView;
@property (strong, nonatomic) IBOutlet UIWebView *allytipsWebView;
@property (strong, nonatomic) IBOutlet UIWebView *enemytipsWebView;

@property (strong, nonatomic) IBOutlet UIWebView *loreWebView;


-(void)resetWithDic:(NSDictionary *)dic;
-(void)layoutPersubviews;


- (IBAction)changeSkillTextVIewContent:(UIButton *)sender;

@end
#endif /* ChampDetailViewController_h */
