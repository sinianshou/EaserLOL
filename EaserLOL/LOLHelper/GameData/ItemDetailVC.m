//
//  ItemDetailVC.m
//  LOLHelper
//
//  Created by Easer Liu on 08/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "ItemDetailVC.h"
#import "GetData.h"
#import "PerCategory.h"

@interface ItemDetailVC ()

@property (strong, nonatomic) NSString * cachesDir;
@property (assign, nonatomic) CGFloat contentHeight;
@property (assign, nonatomic) CGSize screenSize;

@end

@implementation ItemDetailVC

-(instancetype)initVoid
{
    self = [super init];
    
    self.cachesDir =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    self.screenSize = [UIScreen mainScreen].bounds.size;
    self.frame = CGRectMake(0, 0, self.screenSize.width, self.screenSize.height);
    
    [self createControls];
    if (self.itemResouse != nil) {
        [self resetControls];
    }
    
    return self;
}

-(void)createControls
{
    //640*326
    UIImageView * bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.screenSize.width, self.screenSize.width*326/640)];
    bg.image = [UIImage imageNamed:@"good_data_view_detail_background"];
    [self addSubview:bg];
    
    self.golds = [[UILabel alloc] init];
    self.golds.bounds = CGRectMake(0, 0, self.screenSize.width-20, 10);
    self.golds.center = CGPointMake(self.golds.bounds.size.width/2 + 10, bg.frame.origin.y + bg.frame.size.height - (self.golds.bounds.size.height/2 + 10));
    self.golds.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.golds];
    
    self.icon = [[UIImageView alloc] init];
    self.icon.bounds = CGRectMake(0, 0, 48, 48);
    self.icon.center = CGPointMake(self.icon.bounds.size.width/2 + 10, self.golds.frame.origin.y - (self.icon.bounds.size.height/2 + 10));
    [self addSubview:self.icon];
    
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.frame.origin.x + self.icon.frame.size.width + 10, self.icon.frame.origin.y, self.screenSize.width - (self.icon.frame.origin.x + self.icon.frame.size.width + 20), self.icon.frame.size.height/3)];
    self.name.font = [UIFont systemFontOfSize:self.name.bounds.size.height-1];
    self.name.textColor = [UIColor whiteColor];
    [self addSubview:self.name];
    
    self.tags = [[UILabel alloc] initWithFrame:CGRectMake(self.name.frame.origin.x, self.name.frame.origin.y + self.name.frame.size.height, self.name.frame.size.width, self.name.frame.size.height)];
    self.tags.font = [UIFont systemFontOfSize:self.tags.bounds.size.height-3];
    self.tags.textColor = [UIColor grayColor];
    [self addSubview:self.tags];
    
    self.maps = [[UILabel alloc] initWithFrame:CGRectMake(self.tags.frame.origin.x, self.tags.frame.origin.y + self.tags.frame.size.height, self.tags.frame.size.width, self.tags.frame.size.height)];
    self.maps.font = self.tags.font;
    self.maps.textColor = [UIColor grayColor];
    [self addSubview:self.maps];
    
    UIButton * backB = [[UIButton alloc] init];
    backB.bounds = CGRectMake(0, 0, 50, 32);
    backB.center = CGPointMake(10 + backB.bounds.size.width/2, 20 + backB.bounds.size.height/2);
    [backB setTitle:@"    Back" forState:UIControlStateNormal];
    [backB setTitleColor:[UIColor colorWithRed:205/255.00 green:185/255.00 blue:130/255.00 alpha:1] forState:UIControlStateNormal];
    backB.titleLabel.font = [UIFont systemFontOfSize:15];
    [backB addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backB setBackgroundImage:[UIImage imageNamed:@"nav_btn_back_normal"] forState:UIControlStateNormal];
    [self addSubview:backB];
    
    UILabel * itemDetail = [[UILabel alloc] init];
    itemDetail.text = [NSString stringWithFormat:@"Item Detail"];
    itemDetail.font = [UIFont systemFontOfSize:15];
    itemDetail.textColor = backB.currentTitleColor;
    [itemDetail sizeToFit];
    itemDetail.center = CGPointMake(self.screenSize.width/2, backB.center.y);
    [self addSubview:itemDetail];
    
    self.desTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, bg.frame.origin.y + bg.frame.size.height + 10, self.screenSize.width - 10, 15)];
    self.desTitle.font = [UIFont systemFontOfSize:15];
    self.desTitle.text = @"Description";
    [self addSubview:self.desTitle];
    
    self.descriptionLa = [[UILabel alloc] initWithFrame:CGRectMake(10, self.desTitle.frame.origin.y + self.desTitle.frame.size.height + 10, self.screenSize.width - 10, 10)];
    self.descriptionLa.font = [UIFont systemFontOfSize:10];
    self.descriptionLa.numberOfLines = 0;
    self.descriptionLa.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:self.descriptionLa];
    
    self.fromTitle = [[UILabel alloc] init];
    self.fromTitle.bounds = CGRectMake(0, 0, self.screenSize.width - 10, 15);
    self.fromTitle.font = [UIFont systemFontOfSize:15];
    self.fromTitle.text = @"FromItems";
    self.fromTitle.hidden = YES;
    [self addSubview:self.fromTitle];
    
    self.fromArrM = [NSMutableArray array];
    
    self.intoTitle = [[UILabel alloc] init];
    self.intoTitle.bounds = CGRectMake(0, 0, self.screenSize.width - 10, 15);
    self.intoTitle.font = [UIFont systemFontOfSize:15];
    self.intoTitle.text = @"IntoItems";
    self.intoTitle.hidden = YES;
    [self addSubview:self.intoTitle];
    
    self.intoArrM = [NSMutableArray array];
    
    self.backgroundColor = [UIColor whiteColor];
}

-(void)resetWithItem:(Item_EN *) item startRect:(CGRect) startRect
{
    self.startRect = startRect;
    self.itemResouse = item;
    NSLog(@"startRect is %f %f %f %f, item id is %@", self.startRect.origin.x, self.startRect.origin.y, self.startRect.size.width, self.startRect.size.height, self.itemResouse.id);
    
    [self resetControls];
}

-(void)resetControls
{
    //malloc_history 2019 0x7fc1a3ed8f20 |grep 0x7fc1a3ed8f20
    NSString * iconNameKey = [NSString stringWithFormat:@"item_EN_%@.png", self.itemResouse.id];
//    self.cachesDir =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString * iconPath = [self.cachesDir stringByAppendingPathComponent:iconNameKey];
    NSURL * iconURL = [GetData getItemSquareWithImageName_EN:self.itemResouse.square];
    [self.icon setImage:NULL NameKey:iconNameKey inCache:NULL named:iconNameKey WithContentsOfFile:iconPath cacheFromURL:iconURL];
    
    self.name.text = self.itemResouse.name;
    self.tags.text = self.itemResouse.tags;
    self.maps.text = self.itemResouse.maps;
    NSMutableAttributedString * goldAtt = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Total:%@ Sell:%@ Base:%@", self.itemResouse.total, self.itemResouse.sell, self.itemResouse.base]];
    [goldAtt addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,6)];
    [goldAtt addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(6,self.itemResouse.total.length)];
    [goldAtt addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(self.itemResouse.total.length +7,5)];
    [goldAtt addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(self.itemResouse.total.length +12,self.itemResouse.sell.length)];
    [goldAtt addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(self.itemResouse.total.length +7+self.itemResouse.sell.length +6,5)];
    [goldAtt addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(self.itemResouse.total.length +7+self.itemResouse.sell.length +6+5,self.itemResouse.base.length)];
    self.golds.attributedText = goldAtt;
    
    self.descriptionLa.frame = CGRectMake(10, self.desTitle.frame.origin.y + self.desTitle.frame.size.height + 10, self.screenSize.width - 10, 10);
    self.descriptionLa.text = self.itemResouse.sanitizedDescription;
    [self.descriptionLa sizeToFit];
    self.contentHeight = self.descriptionLa.frame.origin.y + self.descriptionLa.frame.size.height + 10;
    
    //配置fromItems
    if (self.fromArrM.count > 0) {
        [self.fromArrM enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.fromArrM removeAllObjects];
    }
    if (self.itemResouse.from != nil) {
        self.fromTitle.center = CGPointMake(self.fromTitle.bounds.size.width/2 + 10, self.descriptionLa.frame.origin.y + self.descriptionLa.frame.size.height + self.fromTitle.bounds.size.height/2 + 10);
        self.fromTitle.hidden = NO;
        
        NSArray * fromIdArr = [self.itemResouse.from componentsSeparatedByString:@"/"];
        [fromIdArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton * bu = [[UIButton alloc] init];
            bu.bounds = CGRectMake(0, 0, 32, 32);
            [bu setTitle:obj forState:UIControlStateNormal];
            [bu setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            NSString * iconNameKey = [NSString stringWithFormat:@"item_EN_%@.png", obj];
            NSString * iconPath = [self.cachesDir stringByAppendingPathComponent:iconNameKey];
            NSURL * iconURL = [GetData getItemSquareWithImageName_EN:[NSString stringWithFormat:@"%@.png", obj]];
            [bu setImage:NULL NameKey:iconNameKey inCache:NULL named:iconNameKey WithContentsOfFile:iconPath cacheFromURL:iconURL forState:UIControlStateNormal];
            if (self.fromArrM.count > 0) {
                if (self.fromArrM.lastObject.center.x + 15 + 48 >= self.screenSize.width) {
                    bu.center = CGPointMake(bu.bounds.size.width/2 + 10, self.fromArrM.lastObject.center.y + 5 + bu.bounds.size.height);
                }else
                {
                    bu.center = CGPointMake(self.fromArrM.lastObject.center.x + bu.bounds.size.width + 5, self.fromArrM.lastObject.center.y);
                }
            }else
            {
                bu.center = CGPointMake(bu.bounds.size.width/2 + 10, self.fromTitle.center.y + self.fromTitle.frame.size.height/2 + 10 + bu.bounds.size.height/2);
            }
            [self addSubview:bu];
            [self.fromArrM addObject:bu];
        }];
        
        self.contentHeight = self.fromArrM.lastObject.frame.origin.y + self.fromArrM.lastObject.frame.size.height + 10;
    }else
    {
        self.fromTitle.hidden = YES;
    }
    
    //配置intoItems
    if (self.intoArrM.count > 0) {
        [self.intoArrM enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.intoArrM removeAllObjects];
    }
    if (self.itemResouse.into != nil) {
        if (self.fromArrM.count > 0) {
            self.intoTitle.frame = CGRectMake(10, self.fromArrM.lastObject.frame.origin.y + self.fromArrM.lastObject.frame.size.height + 10, self.intoTitle.frame.size.width, self.intoTitle.frame.size.height);
        }else
        {
            self.intoTitle.center = CGPointMake(self.intoTitle.bounds.size.width/2 + 10, self.descriptionLa.frame.origin.y + self.descriptionLa.frame.size.height + self.intoTitle.bounds.size.height/2 + 10);
        }
        self.intoTitle.hidden = NO;
        
        NSArray * intoItemArr = [self.itemResouse.into componentsSeparatedByString:@"/"];
        [intoItemArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton * bu = [[UIButton alloc] init];
            bu.bounds = CGRectMake(0, 0, 32, 32);
            [bu setTitle:obj forState:UIControlStateNormal];
            [bu setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            NSString * iconNameKey = [NSString stringWithFormat:@"item_EN_%@.png", obj];
            NSString * iconPath = [self.cachesDir stringByAppendingPathComponent:iconNameKey];
            NSURL * iconURL = [GetData getItemSquareWithImageName_EN:[NSString stringWithFormat:@"%@.png", obj]];
            [bu setImage:NULL NameKey:iconNameKey inCache:NULL named:iconNameKey WithContentsOfFile:iconPath cacheFromURL:iconURL forState:UIControlStateNormal];
            if (self.intoArrM.count > 0) {
                if (self.intoArrM.lastObject.center.x + 15 + 48 >= self.screenSize.width) {
                    bu.center = CGPointMake(bu.bounds.size.width/2 + 10, self.intoArrM.lastObject.center.y + 5 + bu.bounds.size.height);
                }else
                {
                    bu.center = CGPointMake(self.intoArrM.lastObject.center.x + bu.bounds.size.width + 5, self.intoArrM.lastObject.center.y);
                }
            }else
            {
                bu.center = CGPointMake(bu.bounds.size.width/2 + 10, self.intoTitle.center.y + self.intoTitle.frame.size.height/2 + 10 + bu.bounds.size.height/2);
            }
            [self addSubview:bu];
            [self.intoArrM addObject:bu];
            
        }];
        self.contentHeight = self.intoArrM.lastObject.frame.origin.y + self.intoArrM.lastObject.frame.size.height + 10;
    }else
    {
        self.intoTitle.hidden = YES;
    }
    
    self.contentSize = CGSizeMake(self.screenSize.width, self.contentHeight);
    NSLog(@"screen height is %f, contentSize height is %f", self.screenSize.height, self.contentSize.height);
}

-(void)backAction
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeScale(self.startRect.size.width/self.screenSize.width, self.startRect.size.height/self.screenSize.height);
        self.center = CGPointMake(self.startRect.origin.x + self.startRect.size.width/2, self.startRect.origin.y + self.startRect.size.height/2);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
