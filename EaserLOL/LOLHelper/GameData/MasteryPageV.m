//
//  MasteryPageV.m
//  LOLHelper
//
//  Created by Easer Liu on 11/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "MasteryPageV.h"
#import "GetData.h"
#import "PerCategory.h"

typedef NS_ENUM(NSUInteger, MasteryButtonStates) {
    MasteryButtonStatesCanNotSelect = 0,
    MasteryButtonStatesCanSelect,
    MasteryButtonStatesMidLevelSelect,
    MasteryButtonStatesMaxLevelSelect,
    MasteryButtonStatesCanNotReduce,
};

@interface MasteryButton:UIButton

@property (strong, nonatomic) MasteryData_EN * masteryData;
@property (strong, nonatomic) NSArray * desArr;
@property (strong, nonatomic) NSString * currentLe;
@property (strong, nonatomic) NSString * buttonIndex;

-(instancetype)initWithMasteryData_EN:(MasteryData_EN *) masteryData;
-(void)cannotSelected;
-(void)canSelectedWithColor:(UIColor *)color;
-(void)didSelectedWithColor:(UIColor *)color;
-(void)didLockedWithColor:(UIColor *)color;
-(void)addLevel;
-(void)reduceLevel;
-(void)levelToMax:(NSString *)maxStr;
-(void)levelToMin;

@end

@interface ButtonDetailV:UIView

@property (strong, nonatomic) UIImageView * iconV;
@property (strong, nonatomic) UILabel * nameLa;
@property (strong, nonatomic) UILabel * levelLa;
@property (strong, nonatomic) UILabel * currentLeDes;
@property (strong, nonatomic) UILabel * nextLeDes;
@property (strong, nonatomic) UIButton * addButton;
@property (strong, nonatomic) UIButton * reduceButton;
@property (strong, nonatomic) NSString * buttonIndex;


-(instancetype)initWithPerWidth:(CGFloat)width;
-(void)resetButtonDetailVWithMasteryButton:(MasteryButton *) masteryButton;

@end

@interface MasteryPageV ()

@property (strong, nonatomic) UIColor * perColor;
@property (strong, nonatomic) UIColor * lockColor;
@property (strong, nonatomic) NSDictionary * buttonIndexDic;
@property (strong, nonatomic) NSMutableArray <MasteryButton *>* buttonsArrM;
@property (strong, nonatomic) ButtonDetailV * buttonDetailV;

@end

@implementation MasteryPageV


-(instancetype)initWithFrame:(CGRect)frame masteriesArr:(nonnull NSArray <MasteryData_EN *> *)masteriesArr
{
    self = [super initWithFrame:frame];
    //availablePoint
    self.totalPoint = [NSString stringWithFormat:@"0"];
    self.availablePoint = [NSString stringWithFormat:@"30"];
    self.buttonIndexDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"0", @"1", nil], @"600", [NSArray arrayWithObjects:@"2", @"3", @"4", nil], @"705", [NSArray arrayWithObjects:@"5", @"6", nil], @"1206", [NSArray arrayWithObjects:@"7", @"8", @"9", nil], @"1311", [NSArray arrayWithObjects:@"10", @"11", nil], @"1812", [NSArray arrayWithObjects:@"12", @"13", @"14", nil], @"1917", nil];
//    [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"0", @"1", nil], [NSArray arrayWithObjects:@"2", @"3", @"4", nil], [NSArray arrayWithObjects:@"5", @"6", nil], [NSArray arrayWithObjects:@"7", @"8", @"9", nil], [NSArray arrayWithObjects:@"10", @"11", nil], [NSArray arrayWithObjects:@"12", @"13", @"14", nil], nil];
    
    NSArray <MasteryData_EN *>* masteriesResultArr = [masteriesArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSNumber * i1 = [NSNumber numberWithInt:((MasteryData_EN *)obj1).id.intValue];
        NSNumber * i2 = [NSNumber numberWithInt:((MasteryData_EN *)obj2).id.intValue];
        NSComparisonResult result = [i1 compare:i2];
        return result == NSOrderedDescending; // 升序
        //        return result == NSOrderedAscending;  // 降序
        
    }];
    
//    MasteryButton __block * lastButton = nil;
    self.buttonsArrM = [NSMutableArray array];
    [masteriesResultArr enumerateObjectsUsingBlock:^(MasteryData_EN * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MasteryButton * button = [[MasteryButton alloc] initWithMasteryData_EN:obj];
        CGFloat restX = (self.bounds.size.width - button.bounds.size.width*3)/4;
        CGFloat restY = (self.bounds.size.height - button.bounds.size.height*6)/7;
        if (self.buttonsArrM.count > 0) {
            
            int i1 = (self.buttonsArrM.lastObject.masteryData.id.integerValue%100)/10;
            int i2 = (button.masteryData.id.integerValue%100)/10;
            NSLog(@"id1 is %@ i1 is %d id2 is %@ i2 is %d",self.buttonsArrM.lastObject.masteryData.id, i1,button.masteryData.id, i2);
            if (i1 < i2) {
                button.center = CGPointMake(restX + button.bounds.size.width/2, self.buttonsArrM.lastObject.center.y + restY + button.bounds.size.height);
                if (self.buttonsArrM.lastObject.center.x <= self.bounds.size.width/2) {
                    self.buttonsArrM.lastObject.center = CGPointMake(self.self.bounds.size.width - restX - self.buttonsArrM.lastObject.bounds.size.width/2, self.buttonsArrM.lastObject.center.y);
                    UIImageView * imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"talent_choose_none"]];
                    imgV.center = CGPointMake(self.bounds.size.width/2, self.buttonsArrM.lastObject.center.y);
                    [self addSubview:imgV];
                }
            }else
            {
                button.center = CGPointMake(self.buttonsArrM.lastObject.center.x + restX + button.bounds.size.width, self.buttonsArrM.lastObject.center.y);
            }
        }else
        {
            button.center = CGPointMake(restX + button.bounds.size.width/2, restY + button.bounds.size.height/2);
        }
        [button addTarget:self action:@selector(showButtonDetail:) forControlEvents:UIControlEventTouchUpInside];
//        lastButton =button;
        [self.buttonsArrM addObject:button];
        button.buttonIndex = [NSString stringWithFormat:@"%d", (int)[self.buttonsArrM indexOfObject:button]];
        [self addSubview:button];
    }];
    if ([self.buttonsArrM.lastObject.masteryData.masteryTree isEqualToString:@"Cunning"]) {
        self.perColor = [UIColor colorWithRed:255/255.00 green:0/255.00 blue:255/255.00 alpha:1];
    }else if ([self.buttonsArrM.lastObject.masteryData.masteryTree isEqualToString:@"Resolve"])
    {
        self.perColor = [UIColor colorWithRed:0/255.00 green:255/255.00 blue:255/255.00 alpha:1];
    }else if ([self.buttonsArrM.lastObject.masteryData.masteryTree isEqualToString:@"Ferocity"])
    {
        self.perColor = [UIColor redColor];
    }
    self.lockColor = [UIColor colorWithRed:205/255.00 green:185/255.00 blue:130/255.00 alpha:1];
    [self updateMasteriesButtonsStates];
//    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj isKindOfClass:[MasteryButton class]]) {
//            [((MasteryButton *) obj) didSelectedWithColor:self.perColor];
//        }
//    }];
    [self updateButtonDetailV];
    [self addTarget:self action:@selector(dispearButtonDetail) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

-(void)updateMasteriesButtonsStates
{
    [self.buttonIndexDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSArray * groupArr = obj;
        int needKey = ((NSString *)key).intValue%100;
        int overKey = ((NSString *)key).intValue/100;
        [groupArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MasteryButton * button = [self.buttonsArrM objectAtIndex:((NSString *)obj).integerValue];
            if (self.totalPoint.intValue >= overKey) {
                [button didLockedWithColor:self.lockColor];
                
            }else if (self.totalPoint.intValue >= needKey)
            {
                if ([button.currentLe isEqualToString:@"0"]) {
                    [button canSelectedWithColor:self.perColor];
                }else
                {
                    [button didSelectedWithColor:self.perColor];
                }
                
            }else
            {
                [button cannotSelected];
            }
        }];
    }];
}
-(void)updateButtonDetailButtonsStates
{
    MasteryButton * masteryButton = [self.buttonsArrM objectAtIndex:self.buttonDetailV.buttonIndex.integerValue];
//    self.buttonDetailV.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    if (CGColorEqualToColor(masteryButton.layer.borderColor, self.perColor.CGColor)) {
        if (self.availablePoint.intValue <= 0 || [masteryButton.currentLe isEqualToString:masteryButton.masteryData.ranks]) {
            self.buttonDetailV.addButton.enabled = NO;
            self.buttonDetailV.addButton.alpha = 0.5;
        }else
        {
            self.buttonDetailV.addButton.enabled = YES;
            self.buttonDetailV.addButton.alpha = 1;
        }
        if ([masteryButton.currentLe isEqualToString:@"0"]) {
            self.buttonDetailV.reduceButton.enabled = NO;
            self.buttonDetailV.reduceButton.alpha = 0.5;
        }else
        {
            self.buttonDetailV.reduceButton.enabled = YES;
            self.buttonDetailV.reduceButton.alpha = 1;
        }
    }else
    {
        self.buttonDetailV.addButton.enabled = NO;
        self.buttonDetailV.addButton.alpha = 0.5;
        self.buttonDetailV.reduceButton.enabled = NO;
        self.buttonDetailV.reduceButton.alpha = 0.5;
    }
}

-(void)updateAvailablePoint:(NSString *)pointStr
{
    self.availablePoint = pointStr;
    [self updateButtonDetailButtonsStates];
    [self updateMasteriesButtonsStates];
}
-(void)showButtonDetail:(MasteryButton *) masteryButton
{
    [self updateButtonDetailV];
    if (self.buttonDetailV.hidden) {
        [self.buttonDetailV resetButtonDetailVWithMasteryButton:masteryButton];
        [self updateButtonDetailButtonsStates];
        self.buttonDetailV.hidden = NO;
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.5
              initialSpringVelocity:20
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.buttonDetailV.alpha = 1;
                             self.buttonDetailV.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                         }];
    }else
    {
        [self dispearButtonDetail];
    }
    
}
-(void)dispearButtonDetail
{
    if (!self.buttonDetailV.hidden) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.buttonDetailV.alpha = 0;
//            self.buttonDetailV.transform = CGAffineTransformMakeScale(0.5, 0.5);
//        } completion:^(BOOL finished) {
//            self.buttonDetailV.hidden = YES;
//        }];
        
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:5
              initialSpringVelocity:5
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.buttonDetailV.alpha = 0;
                             self.buttonDetailV.transform = CGAffineTransformMakeScale(0.5, 0.5);
                         } completion:^(BOOL finished) {
                             self.buttonDetailV.hidden = YES;
                         }];
    }
}
-(void)updateButtonDetailV
{
    if (self.buttonDetailV == nil) {
        self.buttonDetailV = [[ButtonDetailV alloc] initWithPerWidth:self.bounds.size.width*4/5];
        self.buttonDetailV.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/4);
        
        self.addButton = self.buttonDetailV.addButton;
        self.reduceButton = self.buttonDetailV.reduceButton;
        [self.buttonDetailV.addButton addTarget:self action:@selector(addMasteryButtonLevel) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonDetailV.reduceButton addTarget:self action:@selector(reduceMasteryButtonLevel) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonDetailV.addButton addTarget:self action:@selector(MasteryButtonLevelToMax) forControlEvents:UIControlEventTouchDownRepeat];
        [self.buttonDetailV.reduceButton addTarget:self action:@selector(MasteryButtonLevelToMin) forControlEvents:UIControlEventTouchDownRepeat];
        [self addSubview:self.buttonDetailV];
    }
}
-(void)addMasteryButtonLevel
{
    if (self.availablePoint.intValue > 0) {
        int __block totalP = self.totalPoint.intValue;
        MasteryButton * button = [self.buttonsArrM objectAtIndex:self.buttonDetailV.buttonIndex.integerValue];
        totalP -= button.currentLe.intValue;
        NSArray * __block treamArr = nil;
        [self.buttonIndexDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([((NSArray *)obj) containsObject:button.buttonIndex]) {
                treamArr = obj;
                *stop = YES;
            }
        }];
        if (treamArr.count > 2) {
            [treamArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MasteryButton * preButton = [self.buttonsArrM objectAtIndex:((NSString*)obj).integerValue];
                if (![preButton.buttonIndex isEqualToString:button.buttonIndex] && [preButton.currentLe isEqualToString:@"1"]) {
                    totalP -= preButton.currentLe.intValue;
                    [preButton reduceLevel];
                    totalP += preButton.currentLe.intValue;
                }
            }];
        }else
        {
            [treamArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MasteryButton * preButton = [self.buttonsArrM objectAtIndex:((NSString*)obj).integerValue];
                if (![preButton.buttonIndex isEqualToString:button.buttonIndex] && preButton.currentLe.intValue + button.currentLe.integerValue >=5) {
                    totalP -= preButton.currentLe.intValue;
                    [preButton reduceLevel];
                    totalP += preButton.currentLe.intValue;
                }
            }];
        }
        [button addLevel];
        totalP += button.currentLe.intValue;
        self.totalPoint = [NSString stringWithFormat:@"%d", totalP];
        [self.buttonDetailV resetButtonDetailVWithMasteryButton:button];
//        [self updateMasteriesButtonsStates];
    }
    
    
}
-(void)reduceMasteryButtonLevel
{
    int totalP = self.totalPoint.intValue;
    MasteryButton * button = [self.buttonsArrM objectAtIndex:self.buttonDetailV.buttonIndex.integerValue];
    totalP -= button.currentLe.intValue;
    [button reduceLevel];
    totalP += button.currentLe.intValue;
    self.totalPoint = [NSString stringWithFormat:@"%d", totalP];
    [self.buttonDetailV resetButtonDetailVWithMasteryButton:button];
//    [self updateButtonDetailButtonsStates];
//    [self updateMasteriesButtonsStates];
}
-(void)MasteryButtonLevelToMax
{
    int __block totalP = self.totalPoint.intValue;
    MasteryButton * button = [self.buttonsArrM objectAtIndex:self.buttonDetailV.buttonIndex.integerValue];
    totalP -= button.currentLe.intValue;
    NSArray * __block treamArr = nil;
    [self.buttonIndexDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([((NSArray *)obj) containsObject:button.buttonIndex]) {
            treamArr = obj;
            *stop = YES;
        }
    }];
    int __block p = 0;
    if (treamArr.count > 2) {
        [treamArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MasteryButton * preButton = [self.buttonsArrM objectAtIndex:((NSString*)obj).integerValue];
            if (![preButton.buttonIndex isEqualToString:button.buttonIndex] && [preButton.currentLe isEqualToString:@"1"]) {
                totalP -= preButton.currentLe.intValue;
                [preButton levelToMin];
                totalP += preButton.currentLe.intValue;
            }
        }];
    }else
    {
        [treamArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MasteryButton * preButton = [self.buttonsArrM objectAtIndex:((NSString*)obj).integerValue];
            if (![preButton.buttonIndex isEqualToString:button.buttonIndex] && preButton.currentLe.intValue + button.currentLe.integerValue >=5) {
                totalP -= preButton.currentLe.intValue;
                p = preButton.currentLe.intValue;
                [preButton levelToMin];
                totalP += preButton.currentLe.intValue;
            }
        }];
    }
    p += button.currentLe.intValue+self.availablePoint.intValue;
    NSLog(@"p is %d button.currentLe is %@ self.availablePoint is %@", p, button.currentLe, self.availablePoint);
    if (p < button.masteryData.ranks.intValue && treamArr.count < 3) {
        [button levelToMax:[NSString stringWithFormat:@"%d", p]];
    }else
    {
        [button levelToMax:button.masteryData.ranks];
    }
    
    totalP += button.currentLe.intValue;
    self.totalPoint = [NSString stringWithFormat:@"%d", totalP];
    [self.buttonDetailV resetButtonDetailVWithMasteryButton:button];
    //    [self updateButtonDetailButtonsStates];
//    [self updateMasteriesButtonsStates];
    
}
-(void)MasteryButtonLevelToMin
{
    int totalP = self.totalPoint.intValue;
    MasteryButton * button = [self.buttonsArrM objectAtIndex:self.buttonDetailV.buttonIndex.integerValue];
    totalP -= button.currentLe.intValue;
    [button levelToMin];
    totalP += button.currentLe.intValue;
    self.totalPoint = [NSString stringWithFormat:@"%d", totalP];
    [self.buttonDetailV resetButtonDetailVWithMasteryButton:button];
    //    [self updateButtonDetailButtonsStates];
//    [self updateMasteriesButtonsStates];
}


-(void)resetPoints
{
    [self.buttonsArrM enumerateObjectsUsingBlock:^(MasteryButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj levelToMin];
    }];
    self.totalPoint = [NSString stringWithFormat:@"0"];
//    self.availablePoint = [NSString stringWithFormat:@"30"];
//    [self updateMasteriesButtonsStates];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self perLayoutViews];
}
-(void)perLayoutViews
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation MasteryButton

-(instancetype)initWithMasteryData_EN:(MasteryData_EN *) masteryData
{
    self = [super init];
    self.bounds = CGRectMake(0, 0, 32, 32);
    self.masteryData = masteryData;
    if ([self.masteryData.ranks isEqualToString:@"1"]) {
        [self createCircleControls];
    }else
    {
        [self createRectControls];
    }
    [self cannotSelected];
    return self;
}
-(void)createControls
{
    NSDictionary * dic = [GetData getMasteryDataPicDicImageName_EN:self.masteryData.square];
    [self setBackGroundImage:NULL NameKey:[dic objectForKey:@"NameKey"] inCache:NULL named:[dic objectForKey:@"NameKey"] WithContentsOfFile:[dic objectForKey:@"Path"] cacheFromURL:[dic objectForKey:@"URL"] forState:UIControlStateNormal];
    self.currentLe = [NSString stringWithFormat:@"0"];
    [self setTitle:[NSString stringWithFormat:@"%@/%@", self.currentLe, self.masteryData.ranks] forState:UIControlStateNormal];
    
    self.desArr = [self.masteryData.sanitizedDescription componentsSeparatedByString:[NSString stringWithFormat:@"<br>"]];
}
-(void)createRectControls
{
    [self createControls];
    self.titleLabel.backgroundColor = [UIColor blackColor];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.titleLabel.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height/3);
    self.titleLabel.font = [UIFont systemFontOfSize:self.titleLabel.bounds.size.height];
    self.titleLabel.layer.cornerRadius = self.titleLabel.bounds.size.height/2;
    self.titleLabel.layer.masksToBounds = YES;
    self.titleEdgeInsets = UIEdgeInsetsMake(-(self.bounds.size.height+self.titleLabel.bounds.size.height), 0, 0, 0);
}
-(void)createCircleControls
{
    [self createControls];
    [self setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    self.layer.cornerRadius = self.bounds.size.width/2;
    self.clipsToBounds = YES;
}
-(void)addLevel
{
    int addLe = 0;
    switch (self.masteryData.ranks.intValue) {
        case 1:
            addLe= self.currentLe.intValue+1>1?1:self.currentLe.intValue+1;
            break;
            
        case 5:
            addLe= self.currentLe.intValue+1>5?5:self.currentLe.intValue+1;
            break;
            
        default:
            break;
    }
    self.currentLe = [NSString stringWithFormat:@"%d", addLe];
    [self setTitle:[NSString stringWithFormat:@"%@/%@", self.currentLe, self.masteryData.ranks] forState:UIControlStateNormal];
}
-(void)reduceLevel
{
    int preLe = self.currentLe.intValue-1<0?0:self.currentLe.intValue-1;
    self.currentLe = [NSString stringWithFormat:@"%d", preLe];
    [self setTitle:[NSString stringWithFormat:@"%@/%@", self.currentLe, self.masteryData.ranks] forState:UIControlStateNormal];
}

-(void)levelToMax:(NSString *)maxStr
{
    self.currentLe = [NSString stringWithFormat:@"%@", maxStr];
    [self setTitle:[NSString stringWithFormat:@"%@/%@", self.currentLe, self.masteryData.ranks] forState:UIControlStateNormal];
}
-(void)levelToMin
{
    self.currentLe = [NSString stringWithFormat:@"0"];
    [self setTitle:[NSString stringWithFormat:@"%@/%@", self.currentLe, self.masteryData.ranks] forState:UIControlStateNormal];
}
-(void)cannotSelected
{
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor grayColor].CGColor;
}
-(void)canSelectedWithColor:(UIColor *)color
{
    self.layer.borderWidth = 1;
    self.layer.borderColor = color.CGColor;
}
-(void)didSelectedWithColor:(UIColor *)color
{
    if ([self.currentLe isEqualToString:self.masteryData.ranks]) {
        self.layer.borderWidth = 3;
    }else
    {
        self.layer.borderWidth = 2;
    }
    self.layer.borderColor = color.CGColor;
}

-(void)didLockedWithColor:(UIColor *)color
{
    if ([self.currentLe isEqualToString:self.masteryData.ranks]) {
        self.layer.borderWidth = 3;
    }else if([self.currentLe isEqualToString:@"0"])
    {
        self.layer.borderWidth = 1;
    }else
    {
        self.layer.borderWidth = 2;
    }
    self.layer.borderColor = color.CGColor;
}
@end

@implementation ButtonDetailV

-(instancetype)initWithPerWidth:(CGFloat)width
{
    self = [super init];
    self.bounds = CGRectMake(0, 0, width, 50);
    self.backgroundColor = [UIColor colorWithDisplayP3Red:0 green:0 blue:0 alpha:0.8];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:205/255.00 green:185/255.00 blue:130/255.00 alpha:1].CGColor;
    self.alpha = 0;
    self.hidden = YES;
    self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    self.iconV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 32, 32)];
    [self addSubview:self.iconV];
    
    self.nameLa = [[UILabel alloc] initWithFrame:CGRectMake(self.iconV.frame.origin.x + self.iconV.frame.size.width + 10, self.iconV.frame.origin.y, self.bounds.size.width - (self.iconV.frame.origin.x + self.iconV.frame.size.width + 20), 20)];
    self.nameLa.textColor = [UIColor whiteColor];
    self.nameLa.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.nameLa];
    
    self.levelLa = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLa.frame.origin.x , self.nameLa.frame.origin.y + self.nameLa.frame.size.height, self.nameLa.frame.size.width, 12)];
    self.levelLa.textColor = [UIColor grayColor];
    self.levelLa.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.levelLa];
    
    self.currentLeDes = [[UILabel alloc] initWithFrame:CGRectMake(10 , self.iconV.frame.origin.y + self.iconV.frame.size.height + 10, self.bounds.size.width - 20, 12)];
    self.currentLeDes.numberOfLines = 0;
    self.currentLeDes.textColor = [UIColor grayColor];
    self.currentLeDes.font = self.levelLa.font;
    [self addSubview:self.currentLeDes];
    
    self.nextLeDes = [[UILabel alloc] initWithFrame:self.currentLeDes.frame];
    self.nextLeDes.numberOfLines = 0;
    self.nextLeDes.textColor = [UIColor grayColor];
    self.nextLeDes.font = self.levelLa.font;
    self.nextLeDes.hidden = YES;
    [self addSubview:self.nextLeDes];
    
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(10, self.nextLeDes.frame.origin.y + self.nextLeDes.frame.size.height + 10, self.bounds.size.width/2-15, 20)];
    [self.addButton setImage:[UIImage imageNamed:@"talent_icon_add"] forState:UIControlStateNormal];
    self.addButton.layer.borderWidth = 1;
    self.addButton.layer.borderColor = self.layer.borderColor;
    [self addSubview:self.addButton];
    
    self.reduceButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/2+5, self.addButton.frame.origin.y, self.addButton.bounds.size.width, 20)];
    [self.reduceButton setImage:[UIImage imageNamed:@"talent_icon_reduce"] forState:UIControlStateNormal];
    self.reduceButton.layer.borderWidth = 1;
    self.reduceButton.layer.borderColor = self.layer.borderColor;
    [self addSubview:self.reduceButton];
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, self.addButton.frame.origin.y + self.addButton.frame.size.height + 10);
    
    return self;
}



-(void)resetButtonDetailVWithMasteryButton:(MasteryButton *) masteryButton
{
    self.buttonIndex = masteryButton.buttonIndex;
    self.iconV.image = masteryButton.currentBackgroundImage;
    self.nameLa.text = masteryButton.masteryData.name;
    self.levelLa.text = [NSString stringWithFormat:@"Le: %@", masteryButton.currentTitle];
    NSUInteger cuNum = masteryButton.currentLe.integerValue-1<0?0:masteryButton.currentLe.integerValue-1;
    self.currentLeDes.text = [masteryButton.desArr objectAtIndex:cuNum];
    if ([masteryButton.currentLe isEqualToString:@"0"] || [masteryButton.currentLe isEqualToString:@"5"] || [masteryButton.masteryData.ranks isEqualToString:@"1"]) {
        self.nextLeDes.text = nil;
    }else
    {
        self.nextLeDes.text = [NSString stringWithFormat:@"Next level\n%@", [masteryButton.desArr objectAtIndex:masteryButton.currentLe.integerValue]];
    }
    //0 1 2 3 4 5
    //0 0 1 2 3 4
    //* 1 2 3 4 *
    
    [self relayoutSubs];
    
}
-(void)relayoutSubs
{
    self.currentLeDes.bounds = CGRectMake(0 , 0, self.bounds.size.width - 20, 12);
    [self.currentLeDes sizeToFit];
    self.currentLeDes.frame = CGRectMake(10 , self.iconV.frame.origin.y + self.iconV.frame.size.height + 10, self.bounds.size.width - 20, self.currentLeDes.frame.size.height);
    if (self.nextLeDes.text != nil) {
        self.nextLeDes.bounds = self.currentLeDes.bounds;
        self.nextLeDes.hidden = NO;
        [self.nextLeDes sizeToFit];
        self.nextLeDes.frame = CGRectMake(10 , self.currentLeDes.frame.origin.y + self.currentLeDes.frame.size.height + 10, self.bounds.size.width - 20, self.nextLeDes.frame.size.height);
    }else
    {
        self.nextLeDes.hidden = YES;
        self.nextLeDes.frame = self.currentLeDes.frame;
    }
    self.addButton.center = CGPointMake(self.addButton.center.x, self.nextLeDes.center.y + self.nextLeDes.bounds.size.height/2 + 10 + self.addButton.bounds.size.height/2);
    self.reduceButton.center = CGPointMake(self.reduceButton.center.x, self.addButton.center.y);
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, self.addButton.frame.origin.y + self.addButton.frame.size.height + 10);
}
@end
