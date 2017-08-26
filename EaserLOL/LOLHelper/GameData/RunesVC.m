//
//  RunesVC.m
//  LOLHelper
//
//  Created by Easer Liu on 11/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "RunesVC.h"
#import "NavBackButton.h"
#import "RuneTableCell.h"
#import "GetData.h"
#import "MatchListEntites_ENHeader.h"
#import "PerCategory.h"
#import "SlotButton.h"

@interface RunesVC ()

@property (strong, nonatomic) NSString * cachesDir;
@property (assign, nonatomic) CGSize screenSize;
@property (strong, nonatomic) UIImageView * headImgV;
@property (strong, nonatomic) UIView * BottomV;
@property (strong, nonatomic) UITableView * runeTable;
@property (strong, nonatomic) NavBackButton * backB;
@property (strong, nonatomic) NSMutableArray<SlotButton *> * buttonArrM;
@property (strong, nonatomic) NSMutableDictionary * effectDicM;
@property (strong, nonatomic) NSMutableDictionary * runesDicM;
@property (strong, nonatomic) NSArray<RuneData_EN *> * runesDataArr;
@property (strong, nonatomic) UIView * filterV;
@property (strong, nonatomic) NSMutableArray * tagsArrM;
@property (strong, nonatomic) NSMutableArray * typesArrM;
@property (strong, nonatomic) NSMutableArray * tiersArrM;
@property (strong, nonatomic) UIButton * selectedTag;
@property (strong, nonatomic) UIButton * selectedType;
@property (strong, nonatomic) UIButton * selectedTier;
@property (strong, nonatomic) UIScrollView * effectScrollV;


@end

@implementation RunesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cachesDir =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    self.screenSize = [UIScreen mainScreen].bounds.size;
    self.buttonArrM = [NSMutableArray array];
    self.effectDicM = [NSMutableDictionary dictionary];
    self.runesDicM = [NSMutableDictionary dictionary];
    self.runesDataArr = [GetData getRuneData_ENWithId:NULL tags:NULL tier:NULL type:NULL];
    self.tagsArrM = [NSMutableArray array];
    self.typesArrM = [NSMutableArray array];
    self.tiersArrM = [NSMutableArray array];
//    NSMutableDictionary * statsDicM = [NSMutableDictionary dictionary];
    [self.runesDataArr enumerateObjectsUsingBlock:^(RuneData_EN * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[obj.tags componentsSeparatedByString:@"<br>"] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![self.tagsArrM containsObject:obj]) {
                [self.tagsArrM addObject:obj];
            }
        }];
        if (![self.typesArrM containsObject:[NSString stringWithFormat:@"%@", obj.type]]) {
            [self.typesArrM addObject:obj.type];
        }
        if (![self.tiersArrM containsObject:[NSString stringWithFormat:@"%@", obj.tier]]) {
            [self.tiersArrM addObject:obj.tier];
        }
//        NSArray * statsArrM =[obj.stats componentsSeparatedByString:@"<br>"];
//        [statsArrM enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            if (idx%2 == 1 && ![statsDicM.allKeys containsObject:obj]) {
//
//
//
//                [statsDicM setObject:obj forKey:[statsArrM objectAtIndex:idx-1]];
//
//
//            }
//        }];
    }];
    
    
    
    [self setHeaderV];
    self.runeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headImgV.frame.origin.y + self.headImgV.frame.size.height, self.screenSize.width, self.screenSize.height - (self.headImgV.frame.origin.y + self.headImgV.frame.size.height))];
    self.runeTable.backgroundColor = [UIColor blackColor];
    self.runeTable.dataSource = self;
    self.runeTable.delegate = self;
    [self.view addSubview:self.runeTable];
    
    [self createBottomV];
    [self creatEffectScrollV];
    [self createfilterView];
    self.runeTable.contentInset = UIEdgeInsetsMake(0, 0, self.BottomV.bounds.size.height, 0);
    
    // Do any additional setup after loading the view.
}

-(void)setHeaderV
{
    //64*64  118*118 640*532
    self.headImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenSize.width, self.screenSize.width*532/640)];
    self.headImgV.userInteractionEnabled = YES;
    self.headImgV.image = [UIImage imageNamed:@"rune_slots_bg"];
    [self.view addSubview:self.headImgV];
    
    self.backB = [[NavBackButton alloc] initWithBackButtonType:BackButtonTypeNav];
    self.backB.center = CGPointMake(self.backB.bounds.size.width/2 + 10, self.backB.bounds.size.height/2 + 10);
    [self.backB addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headImgV addSubview:self.backB];
    
    UILabel * titleLa = [[UILabel alloc] init];
    titleLa.bounds = self.backB.bounds;
    titleLa.textColor = self.backB.currentTitleColor;
    titleLa.text = [NSString stringWithFormat:@"Rune Simulator"];
    [titleLa sizeToFit];
    titleLa.center = CGPointMake(CGRectGetMidX(self.headImgV.bounds), self.backB.center.y);
    [self.headImgV addSubview:titleLa];
    
    //red_slot_bg yellow_slot_bg blue_slot_bg
    for (int i = 0; i < 30; i++) {
        SlotButton * slot = [[SlotButton alloc] init];
        slot.bounds = CGRectMake(0, 0, 32, 32);
        [slot addTarget:self action:@selector(removeRune:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i < 9) {
            [slot setBackgroundImage:[UIImage imageNamed:@"red_slot_bg"] forState:UIControlStateNormal];
            slot.type = [NSString stringWithFormat:@"mark"];
            slot.center = CGPointMake(self.screenSize.width/18 + self.screenSize.width/9*i, self.headImgV.bounds.size.height - (42 * 2 + 96));
            
        }else if (i < 18)
        {
            [slot setBackgroundImage:[UIImage imageNamed:@"yellow_slot_bg"] forState:UIControlStateNormal];
            slot.type = [NSString stringWithFormat:@"seal"];
            slot.center = CGPointMake(self.screenSize.width/18 + self.screenSize.width/9*(i - 9), self.headImgV.bounds.size.height - (42 * 1 + 96));
        }else if (i < 27)
        {
            [slot setBackgroundImage:[UIImage imageNamed:@"blue_slot_bg"] forState:UIControlStateNormal];
            slot.type = [NSString stringWithFormat:@"glyph"];
            slot.center = CGPointMake(self.screenSize.width/18 + self.screenSize.width/9*(i - 18), self.headImgV.bounds.size.height - 96);
        }else
        {
            slot.bounds = CGRectMake(0, 0, 60, 60);
            [slot setBackgroundImage:[UIImage imageNamed:@"black_slot_bg"] forState:UIControlStateNormal];
            slot.type = [NSString stringWithFormat:@"quintessence"];
            slot.center = CGPointMake(self.screenSize.width/9 + self.screenSize.width*2/9*(i - 27), self.headImgV.bounds.size.height - 40);
        }
        [self.buttonArrM addObject:slot];
        [self.headImgV addSubview:slot];
    }
}
-(void)createBottomV
{
    self.BottomV = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - (self.backB.bounds.size.height), [UIScreen mainScreen].bounds.size.width, self.backB.bounds.size.height)];
    self.BottomV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    UIButton * resetB = [[UIButton alloc] init];
    resetB.bounds = self.backB.bounds;
    resetB.center = CGPointMake(self.BottomV.bounds.size.width/6,self.BottomV.bounds.size.height/2);
    [resetB setTitle:@"Reset" forState:UIControlStateNormal];
    [resetB setTitleColor:self.backB.currentTitleColor forState:UIControlStateNormal];
    [resetB addTarget:self action:@selector(resetRunes) forControlEvents:UIControlEventTouchUpInside];
    [self.BottomV addSubview:resetB];
    
    UIButton * effectB = [[UIButton alloc] init];
    effectB.bounds = self.backB.bounds;
    effectB.center = CGPointMake(self.BottomV.bounds.size.width/2,self.BottomV.bounds.size.height/2);
    [effectB setTitle:@"Effect" forState:UIControlStateNormal];
    [effectB setTitleColor:self.backB.currentTitleColor forState:UIControlStateNormal];
    [effectB addTarget:self action:@selector(showEffectScrollV) forControlEvents:UIControlEventTouchUpInside];
    [self.BottomV addSubview:effectB];
    
    UIButton * filterB = [[UIButton alloc] initWithName:@"filterB"];
    filterB.bounds = self.backB.bounds;
    filterB.center = CGPointMake(self.BottomV.bounds.size.width*5/6,self.BottomV.bounds.size.height/2);
    [filterB setTitle:@"Filter" forState:UIControlStateNormal];
    [filterB setTitleColor:self.backB.currentTitleColor forState:UIControlStateNormal];
    [filterB addTarget:self action:@selector(showFilterV:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.BottomV perAddSubviews:filterB, nil];
    [self.view addSubview:self.BottomV];
//    return view;
}
-(void)creatEffectScrollV
{
    self.effectScrollV = [[UIScrollView alloc] init];
    self.effectScrollV.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    self.effectScrollV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    self.effectScrollV.bounds = CGRectMake(0, 0, self.view.bounds.size.width*2/3, self.view.bounds.size.height*2/3);
    UILabel * titlela01 = [[UILabel alloc] initWithName:@"titlela01"];
    titlela01.bounds = CGRectMake(0, 0, self.effectScrollV.bounds.size.width-10, 20);
    titlela01.font = [UIFont systemFontOfSize:18];
    titlela01.textColor = [UIColor whiteColor];
    titlela01.text = @"Effect";
    UILabel * contentla01 = [[UILabel alloc] initWithName:@"contentla01"];
//    contentla01.bounds = CGRectMake(0, 0, self.effectScrollV.bounds.size.width-10, 20);
    contentla01.font = [UIFont systemFontOfSize:13];
    contentla01.numberOfLines = 0;
    contentla01.lineBreakMode = NSLineBreakByWordWrapping;
    contentla01.textColor = [UIColor grayColor];
    UILabel * titlela02 = [[UILabel alloc] initWithName:@"titlela02"];
    titlela02.bounds = CGRectMake(0, 0, self.effectScrollV.bounds.size.width-10, 20);
    titlela02.font = [UIFont systemFontOfSize:18];
    titlela02.textColor = [UIColor whiteColor];
    titlela02.text = @"Runes";
    UILabel * contentla02 = [[UILabel alloc] initWithName:@"contentla02"];
//    contentla02.bounds = CGRectMake(0, 0, self.effectScrollV.bounds.size.width-10, 20);
    contentla02.font = [UIFont systemFontOfSize:13];
    contentla02.numberOfLines = 0;
    contentla02.lineBreakMode = NSLineBreakByWordWrapping;
    contentla02.textColor = [UIColor grayColor];
    [self.effectScrollV perAddSubviews:titlela01, contentla01, titlela02, contentla02, nil];
    [self layoutEffectScrollV];
    self.effectScrollV.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.effectScrollV.alpha = 0;
    self.effectScrollV.hidden = YES;
    [self.view addSubview:self.effectScrollV];
}
-(void)showEffectScrollV
{
    if (self.effectScrollV.hidden) {
        if (!self.filterV.hidden) {
            [self showFilterV:[self.BottomV.perSubviews objectForKey:@"filterB"]];
        }
        UILabel * contentla01 = [self.effectScrollV.perSubviews objectForKey:@"contentla01"];
        NSMutableString * effectStrM = [NSMutableString string];
        [self.effectDicM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [effectStrM appendFormat:@"%@ +%@\n", key, obj];
        }];
        if (effectStrM.length == 0) {
            [effectStrM appendString:@"Effect is Empty\n"];
        }
        contentla01.text = effectStrM;
        contentla01.bounds = CGRectMake(0, 0, self.effectScrollV.bounds.size.width-10, 20);
        [contentla01 sizeToFit];
        
        UILabel * contentla02 = [self.effectScrollV.perSubviews objectForKey:@"contentla02"];
        NSMutableString * runesStrM = [NSMutableString string];
        [self.runesDicM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [runesStrM appendFormat:@"%@ x %@\n", key, obj];
        }];
        if (runesStrM.length == 0) {
            [runesStrM appendString:@"Runes is Empty\n"];
        }
        contentla02.text = runesStrM;
        contentla02.bounds = CGRectMake(0, 0, self.effectScrollV.bounds.size.width-10, 20);
        [contentla02 sizeToFit];
        [self layoutEffectScrollV];
        self.effectScrollV.hidden = NO;
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.5
              initialSpringVelocity:20
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.effectScrollV.transform = CGAffineTransformMakeScale(1, 1);
                             self.effectScrollV.alpha = 1;
                         } completion:^(BOOL finished) {
                         }];
    }else
    {
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:5
              initialSpringVelocity:5
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.effectScrollV.transform = CGAffineTransformMakeScale(0.5, 0.5);
                             self.effectScrollV.alpha = 0;
                         } completion:^(BOOL finished) {
                             self.effectScrollV.hidden = YES;
                         }];
    }
    
}
-(void)layoutEffectScrollV
{
    
    UILabel * titlela01 = [self.effectScrollV.perSubviews objectForKey:@"titlela01"];
    titlela01.center = CGPointMake(titlela01.bounds.size.width/2+5, titlela01.bounds.size.height/2+10);
    UILabel * contentla01 = [self.effectScrollV.perSubviews objectForKey:@"contentla01"];
    contentla01.center = CGPointMake(contentla01.bounds.size.width/2+5, titlela01.frame.origin.y + titlela01.frame.size.height + contentla01.bounds.size.height/2);
    UILabel * titlela02 = [self.effectScrollV.perSubviews objectForKey:@"titlela02"];
    titlela02.center = CGPointMake(titlela02.bounds.size.width/2+5,contentla01.frame.origin.y + contentla01.frame.size.height + titlela02.bounds.size.height/2);
    UILabel * contentla02 = [self.effectScrollV.perSubviews objectForKey:@"contentla02"];
    contentla02.center = CGPointMake(contentla02.bounds.size.width/2+5,titlela02.frame.origin.y + titlela02.frame.size.height + contentla02.bounds.size.height/2);
    self.effectScrollV.contentSize = CGSizeMake(self.effectScrollV.bounds.size.width, contentla02.frame.origin.y + contentla02.frame.size.height);
    if (self.effectScrollV.contentSize.height < self.view.bounds.size.height*2/3) {
        self.effectScrollV.bounds = CGRectMake(0, 0, self.view.bounds.size.width*2/3, self.effectScrollV.contentSize.height);
    }else
    {
        self.effectScrollV.bounds = CGRectMake(0, 0, self.view.bounds.size.width*2/3, self.view.bounds.size.height*2/3);
    }
}
-(void)removeRune:(SlotButton *)slot
{
    [slot setImage:nil forState:UIControlStateNormal];
    slot.name = nil;
    slot.stats = nil;
    [self refreshRuneEffect];
    NSLog(@"name is %@ stats is %@", slot.name, slot.stats);
}
-(void)refreshRuneEffect
{
    [self.runesDicM removeAllObjects];
    [self.effectDicM removeAllObjects];
    [self.buttonArrM enumerateObjectsUsingBlock:^(SlotButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.name != nil) {
            if ([self.runesDicM objectForKey:obj.name] == nil) {
                [self.runesDicM setObject:[NSString stringWithFormat:@"1"] forKey:obj.name];
            }else
            {
                [self.runesDicM setObject:[NSString stringWithFormat:@"%d", ((NSString *)[self.runesDicM objectForKey:obj.name]).intValue + 1] forKey:obj.name];
            }
            NSArray * effectArr = [obj.stats componentsSeparatedByString:@"<br>"];
            [effectArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx%2 == 1) {
                    if ([self.effectDicM objectForKey:[effectArr objectAtIndex:idx - 1]] == nil) {
                        [self.effectDicM setObject:[NSString stringWithFormat:@"%@", obj] forKey:[effectArr objectAtIndex:idx - 1]];
                    }else
                    {
                        [self.effectDicM setObject:[NSString stringWithFormat:@"%f", ((NSString *)[self.effectDicM objectForKey:[effectArr objectAtIndex:idx - 1]]).floatValue + [NSString stringWithFormat:@"%@", obj].floatValue] forKey:[effectArr objectAtIndex:idx - 1]];
                    }
                }
            }];
        }
    }];
}
-(void)createfilterView
{
    
    //    +(NSArray*)getRuneData_ENWithId:(nullable NSString *)identifyty tags:(nullable NSString *)tag tier:(nullable NSString *)tier type:(nullable NSString *)type;
    self.filterV = [[UIView alloc] init];
    self.filterV.bounds = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width);
    self.filterV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    //Tags Types Tiers
    UILabel * tagLa = [[UILabel alloc] init];
    tagLa.text = [NSString stringWithFormat:@"Tags:"];
    tagLa.textColor = [UIColor whiteColor];
    tagLa.font = [UIFont systemFontOfSize:10];
    [tagLa sizeToFit];
    tagLa.center = CGPointMake(tagLa.bounds.size.width/2+10, tagLa.bounds.size.height/2+10);
    CGRect __block rect = tagLa.frame;
    [self.filterV addSubview:tagLa];
    [self.tagsArrM enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * button = [[UIButton alloc] init];
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor grayColor]];
        button.titleLabel.font = tagLa.font;
        [button.titleLabel sizeToFit];
        button.bounds = CGRectMake(0, 0, button.titleLabel.bounds.size.width+10, button.titleLabel.bounds.size.height+5);
        button.layer.cornerRadius = button.bounds.size.height/2;
        button.layer.masksToBounds = YES;
        button.center = CGPointMake(rect.origin.x + rect.size.width + 5 + button.bounds.size.width/2, rect.origin.y + rect.size.height/2);
        if(button.frame.origin.x + button.frame.size.width + 10 > self.filterV.bounds.size.width)
        {
            button.center = CGPointMake(tagLa.frame.origin.x + tagLa.frame.size.width + 5 + button.bounds.size.width/2, button.center.y + button.bounds.size.height + 5);
        }
        
        [button addTarget:self action:@selector(filterTags:) forControlEvents:UIControlEventTouchUpInside];
        rect = button.frame;
        [self.filterV addSubview:button];
    }];
    
    UILabel * typeLa = [[UILabel alloc] init];
    typeLa.text = [NSString stringWithFormat:@"Types:"];
    typeLa.textColor = tagLa.textColor;
    typeLa.font = tagLa.font;
    [typeLa sizeToFit];
    typeLa.center = CGPointMake(typeLa.bounds.size.width/2+10,rect.origin.y + rect.size.height + typeLa.bounds.size.height/2+10);
    rect = typeLa.frame;
    [self.filterV addSubview:typeLa];
    [self.typesArrM enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * button = [[UIButton alloc] init];
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor grayColor]];
        button.titleLabel.font = tagLa.font;
        [button.titleLabel sizeToFit];
        button.bounds = CGRectMake(0, 0, button.titleLabel.bounds.size.width+10, button.titleLabel.bounds.size.height+5);
        button.layer.cornerRadius = button.bounds.size.height/2;
        button.layer.masksToBounds = YES;
        button.center = CGPointMake(rect.origin.x + rect.size.width + 5 + button.bounds.size.width/2, rect.origin.y + rect.size.height/2);
        if(button.frame.origin.x + button.frame.size.width + 10 > self.filterV.bounds.size.width)
        {
            button.center = CGPointMake(typeLa.frame.origin.x + typeLa.frame.size.width + 5 + button.bounds.size.width/2, button.center.y + button.bounds.size.height + 5);
        }
        [button addTarget:self action:@selector(filterTypes:) forControlEvents:UIControlEventTouchUpInside];
        rect = button.frame;
        [self.filterV addSubview:button];
    }];
    
    UILabel * tierLa = [[UILabel alloc] init];
    tierLa.text = [NSString stringWithFormat:@"Tiers:"];
    tierLa.textColor = tagLa.textColor;
    tierLa.font = tagLa.font;
    [tierLa sizeToFit];
    tierLa.center = CGPointMake(tierLa.bounds.size.width/2+10,rect.origin.y + rect.size.height + tierLa.bounds.size.height/2+10);
    rect = tierLa.frame;
    [self.filterV addSubview:tierLa];
    [self.tiersArrM enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * button = [[UIButton alloc] init];
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor grayColor]];
        button.titleLabel.font = tagLa.font;
        [button.titleLabel sizeToFit];
        button.bounds = CGRectMake(0, 0, button.titleLabel.bounds.size.height+5, button.titleLabel.bounds.size.height+5);
        button.layer.cornerRadius = button.bounds.size.height/2;
        button.layer.masksToBounds = YES;
        button.center = CGPointMake(rect.origin.x + rect.size.width + 5 + button.bounds.size.width/2, rect.origin.y + rect.size.height/2);
        if(button.frame.origin.x + button.frame.size.width + 10 > self.filterV.bounds.size.width)
        {
            button.center = CGPointMake(tierLa.frame.origin.x + tierLa.frame.size.width + 5 + button.bounds.size.width/2, button.center.y + button.bounds.size.height + 5);
        }
        
        [button addTarget:self action:@selector(filterTiers:) forControlEvents:UIControlEventTouchUpInside];
        rect = button.frame;
        [self.filterV addSubview:button];
    }];
    
    self.filterV.bounds = CGRectMake(0, 0, self.view.bounds.size.width, rect.origin.y + rect.size.height + 10);
    self.filterV.transform = CGAffineTransformMakeScale(0.3, 0.3);
    self.filterV.center = CGPointMake(self.view.bounds.size.width*0.85, self.BottomV.frame.origin.y - self.filterV.bounds.size.height/2*0.3);
    self.filterV.alpha = 0;
    self.filterV.hidden = YES;
    [self.view addSubview:self.filterV];
}
-(void)showFilterV:(UIButton *)button
{
    if (self.filterV.hidden) {
        if (!self.effectScrollV.hidden) {
            [self showEffectScrollV];
        }
        self.filterV.hidden = NO;
        [button setTitle:@"Catch" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.filterV.transform = CGAffineTransformMakeScale(1, 1);
            self.filterV.center = CGPointMake(self.view.bounds.size.width*0.5, self.BottomV.frame.origin.y - self.filterV.bounds.size.height/2);
            self.filterV.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }else
    {
        [button setTitle:@"Filter" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.filterV.transform = CGAffineTransformMakeScale(0.3, 0.3);
            self.filterV.center = CGPointMake(self.view.bounds.size.width*0.85, self.BottomV.frame.origin.y - self.filterV.bounds.size.height/2*0.3);
            self.filterV.alpha = 0;
        } completion:^(BOOL finished) {
            self.filterV.hidden = YES;
        }];
        
        self.runesDataArr = [GetData getRuneData_ENWithId:NULL tags:self.selectedTag.selected?self.selectedTag.currentTitle:NULL tier:self.selectedTier.selected?self.selectedTier.currentTitle:NULL type:self.selectedType.selected?self.selectedType.currentTitle:NULL];
        [self.runeTable reloadData];
    }
}
-(void)filterTags:(UIButton *)button
{
    if (self.selectedTag == nil) {
        self.selectedTag = button;
        self.selectedTag.selected = YES;
        self.selectedTag.backgroundColor = self.backB.currentTitleColor;
    }else if([button isEqual:self.selectedTag])
    {
        if (self.selectedTag.selected) {
            self.selectedTag.selected = NO;
            self.selectedTag.backgroundColor = [UIColor grayColor];
        }else
        {
            self.selectedTag.selected = YES;
            self.selectedTag.backgroundColor = self.backB.currentTitleColor;
        }
    }else
    {
        self.selectedTag.selected = NO;
        self.selectedTag.backgroundColor = [UIColor grayColor];
        self.selectedTag = button;
        self.selectedTag.selected = YES;
        self.selectedTag.backgroundColor = self.backB.currentTitleColor;
    }
}
-(void)filterTypes:(UIButton *)button
{
    if (self.selectedType == nil) {
        self.selectedType = button;
        self.selectedType.selected = YES;
        self.selectedType.backgroundColor = self.backB.currentTitleColor;
    }else if([button isEqual:self.selectedType])
    {
        if (self.selectedType.selected) {
            self.selectedType.selected = NO;
            self.selectedType.backgroundColor = [UIColor grayColor];
        }else
        {
            self.selectedType.selected = YES;
            self.selectedType.backgroundColor = self.backB.currentTitleColor;
        }
    }else
    {
        self.selectedType.selected = NO;
        self.selectedType.backgroundColor = [UIColor grayColor];
        self.selectedType = button;
        self.selectedType.selected = YES;
        self.selectedType.backgroundColor = self.backB.currentTitleColor;
    }
}
-(void)filterTiers:(UIButton *)button
{
    if (self.selectedTier == nil) {
        self.selectedTier = button;
        self.selectedTier.selected = YES;
        self.selectedTier.backgroundColor = self.backB.currentTitleColor;
    }else if([button isEqual:self.selectedTier])
    {
        if (self.selectedTier.selected) {
            self.selectedTier.selected = NO;
            self.selectedTier.backgroundColor = [UIColor grayColor];
        }else
        {
            self.selectedTier.selected = YES;
            self.selectedTier.backgroundColor = self.backB.currentTitleColor;
        }
    }else
    {
        self.selectedTier.selected = NO;
        self.selectedTier.backgroundColor = [UIColor grayColor];
        self.selectedTier = button;
        self.selectedTier.selected = YES;
        self.selectedTier.backgroundColor = self.backB.currentTitleColor;
    }
}
-(void)resetRunes
{
    if (!self.effectScrollV.hidden) {
        [self showEffectScrollV];
    }
    if (!self.filterV.hidden) {
        [self showFilterV:[self.BottomV.perSubviews objectForKey:@"filterB"]];
    }
    [self.buttonArrM enumerateObjectsUsingBlock:^(SlotButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.name != nil) {
            [obj resetSlotButton];
        }
    }];
    [self.effectDicM removeAllObjects];
    [self.runesDicM removeAllObjects];
}
-(void)dismissAction
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
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
#pragma mark - TableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RuneTableCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.buttonArrM enumerateObjectsUsingBlock:^(SlotButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([cell.type isEqualToString:obj.type] && obj.currentImage == Nil)
        {
            [obj setImage:cell.iconImgV.image forState:UIControlStateNormal];
            obj.name = cell.name.text;
            obj.stats = cell.stats;
            NSLog(@"name is %@ stats is %@", obj.name, obj.stats);
            *stop = YES;
            //刷新数据
        }else if (idx == 29)
        {
            NSLog(@"%@ is enough", [cell.type capitalizedString]);
        }
    }];
    
    [self refreshRuneEffect];
}

#pragma mark - TableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * Identifier = [NSString stringWithFormat:@"runeCellIdentifier"];
    RuneTableCell * cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[RuneTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    if (self.runesDataArr.count > 0 && cell != nil) {
        RuneData_EN * runeData = [self.runesDataArr objectAtIndex:indexPath.row];
        NSDictionary * runePicDic = [GetData getRuneDataPicDicImageName_EN:runeData.square];
        [cell.iconImgV setImage:NULL NameKey:[runePicDic objectForKey:@"NameKey"] inCache:NULL named:NULL WithContentsOfFile:[runePicDic objectForKey:@"Path"] cacheFromURL:[runePicDic objectForKey:@"URL"]];
        cell.name.text = runeData.name;
        cell.perDescription.text = runeData.descriptions;
        cell.type = runeData.type;
        cell.stats = runeData.stats;
        tableView.estimatedRowHeight = cell.contentView.bounds.size.height;
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.runesDataArr.count > 0) {
        return self.runesDataArr.count;
    }else
    {
        return 0;
    }
}
@end
