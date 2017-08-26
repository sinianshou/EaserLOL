//
//  MenuControlH.m
//  testTable
//
//  Created by Easer Liu on 6/11/17.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "MenuControlH.h"
#import "OptimizeLog.h"

@interface MenuControlH ()

@property CGRect viewFrame;
@property (strong, nonatomic) NSMutableArray * buttons;
@property (strong, nonatomic) NSMutableString * name;

@end


@implementation MenuControlH

+(nonnull UIView *) menuControlHWithNormalTitles:(nonnull NSArray*) normalTitles SelectedTitles:(nullable NSArray*) selectedTitles Images:(nullable NSArray*)images
{
    return [[self alloc] initWithNormalTitles: normalTitles SelectedTitles: selectedTitles  Images:images];
}

- (nonnull UIView *)initWithNormalTitles:(nonnull NSArray*) normalTitles SelectedTitles:(nullable NSArray*) selectedTitles Images:(nullable NSArray*)images
{
    self = [super init];
    
    self.name = [NSMutableString stringWithFormat:@"MenuControlH"];
    self.buttons = [[NSMutableArray alloc] init];
    
    NSLog(@"一共要创建%lu个按钮",(unsigned long)normalTitles.count);
    for (int i = 0; i < normalTitles.count; i++) {
        UIButton * b = [[UIButton alloc] init];
        b.tag = i;
        b.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        
        b.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor brownColor] forState:UIControlStateSelected];
        
        [b setTitle:normalTitles[i] forState:UIControlStateNormal];
        NSLog(@"按钮的标题是%@", [b titleForState:UIControlStateNormal]);
        [b addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:b];
        [self.buttons addObject:b];
    }
    
    UIButton* but =self.buttons[0];
    but.selected = YES;
    
    NSLog(@"创建了%lu个按钮",(unsigned long)self.buttons.count);
    
    //为各button布局
    [self resizingButtons];
    
    //添加手势
    [self setRecognizerForView:self];
    
    //返回自己
    return self;
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)resizingButtons
{
    NSMutableDictionary * views = [[NSMutableDictionary alloc] init];
    NSMutableString * vflH = [NSMutableString stringWithFormat:@"H:|-1-"];
    NSLog(@"self.buttons里有%lu个按钮",(unsigned long)self.buttons.count);
    NSString * firstButtonString;
    for (int i = 0; i < self.buttons.count;i++) {
        UIButton * b = self.buttons[i];
        NSString * buttonString = [NSString stringWithFormat:@"button%d",i];
        if (firstButtonString == nil || firstButtonString == buttonString) {
            firstButtonString = [NSString stringWithFormat:@"%@",buttonString];
        }
        
        NSLog(@"firstTitle 是 %@",firstButtonString);
        [vflH appendFormat:@"[%@(==%@)]-",buttonString,firstButtonString];
        NSLog(@"vflH 是 %@",vflH);
        [views setObject:b forKey:buttonString];
        NSString * vflV = [NSString stringWithFormat:@"V:|[%@]|",buttonString];
        
        NSLog(@"vflV 是 %@",vflV);
        
        
        NSArray * constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:vflV options:0 metrics:NULL views:views];
        [self addConstraints:constraintsV];
    }
    [vflH appendString:@"1-|"];
    NSLog(@"vflH 是 %@",vflH);
    NSArray * constraintsH = [NSLayoutConstraint constraintsWithVisualFormat:vflH options:0 metrics:NULL views:views];
    [self addConstraints:constraintsH];
}

-(void)setRecognizerForView:(UIView *) view
{
    //左滑手势
    UISwipeGestureRecognizer * recognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer1 setDirection:UISwipeGestureRecognizerDirectionLeft];
    [view addGestureRecognizer:recognizer1];
    
    //右滑手势
    UISwipeGestureRecognizer * recognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer2 setDirection:UISwipeGestureRecognizerDirectionRight];
    [view addGestureRecognizer:recognizer2];
    
    //拖动手势
    UIPanGestureRecognizer * pan01 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    pan01.minimumNumberOfTouches = 1;
    pan01.maximumNumberOfTouches = 2;
    [view addGestureRecognizer:pan01];
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    self.viewFrame = self.frame;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGPoint p ;
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            p = CGPointMake(self.viewFrame.size.width/2,self.viewFrame.size.height/2);
            [self MoveViewCenter:self ToPoint:p];
            
            
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            p = CGPointMake(-(self.viewFrame.size.width/2) + screenSize.width,self.viewFrame.size.height/2);
            [self MoveViewCenter:self ToPoint:p];
            break;
            
        default:
            break;
            
    }
}

-(void) handlePanFrom:(UIPanGestureRecognizer *) pan
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGPoint translation = [pan translationInView:self];
    CGPoint p ;
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.viewFrame = self.frame;
    }
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged || pan.state == UIGestureRecognizerStateEnded) {
        self.frame = CGRectMake((self.viewFrame.origin.x + translation.x), self.viewFrame.origin.y, self.viewFrame.size.width, self.viewFrame.size.height);
        NSLog(@"Origin.x is %f",self.frame.origin.x);
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.frame.origin.x < (-self.viewFrame.size.width + screenSize.width))
        {
            p = CGPointMake(-(self.viewFrame.size.width/2) + screenSize.width,self.viewFrame.origin.y + self.viewFrame.size.height/2);
            [self MoveViewCenter:self ToPoint:p];
        }else if (self.frame.origin.x >0)
        {
            p = CGPointMake(self.viewFrame.size.width/2,self.viewFrame.origin.y + self.viewFrame.size.height/2);
            [self MoveViewCenter:self ToPoint:p];
        }
    }
    for (UIButton * b in self.buttons) {
        NSLog(@"button named %@ frame is :%f %f %f %f",[b titleForState:UIControlStateNormal],b.frame.origin.x,b.frame.origin.y,b.frame.size.width,b.frame.size.height);
    }
    NSLog(@"MenuControlH frame is: :%f %f %f %f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    NSLog(@"MenuControlH has %lu views",[self subviews].count);
}


-(void)click:(UIButton *) button
{
    for (UIButton * b in  self.buttons){
        if ([b titleForState:UIControlStateNormal] != [button titleForState:UIControlStateNormal])
        {
            b.selected = NO;
        }
    }
    button.selected = YES;
    NSLog(@"button named %@ frame is :%f %f %f %f", [button titleForState:UIControlStateNormal],button.frame.origin.x,button.frame.origin.y,button.frame.size.width,button.frame.size.height);
    [self moveButtonToCenter:button];
}

-(void)moveButtonToCenter:(UIButton *) button
{
    CGPoint bP = button.center;
    CGFloat ScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat dicCX = ScreenWidth/2 - (bP.x + self.frame.origin.x);
    CGFloat dicLX = -self.frame.origin.x;
    CGFloat dicRX = ScreenWidth - (self.frame.origin.x + self.frame.size.width);
    NSLog(@"dics are CX %f LX %f RX %f",dicCX,dicLX,dicRX);
    if (dicCX > 0) {
        if (dicCX >= dicLX) {
            CGPoint p = CGPointMake((self.center.x + dicLX),self.center.y);
            [self MoveViewCenter:self ToPoint:p];
        }else if(dicCX < dicLX)
        {
            CGPoint p = CGPointMake((self.center.x + dicCX),self.center.y);
            [self MoveViewCenter:self ToPoint:p];
        }
    }else if(dicCX < 0)
    {
        if (dicCX >= dicRX) {
            CGPoint p = CGPointMake((self.center.x + dicCX),self.center.y);
            [self MoveViewCenter:self ToPoint:p];
        }else if(dicCX < dicRX)
        {
            CGPoint p = CGPointMake((self.center.x + dicRX),self.center.y);
            [self MoveViewCenter:self ToPoint:p];
        }
    }
}

-(void)MoveViewCenter:(UIView *)view ToPoint:(CGPoint) point
{
    [UIView beginAnimations:@"ViewMoveToPoint"context:nil];
    
    [UIView setAnimationDuration:0.2f];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationRepeatAutoreverses:NO];
    
    view.center = point;
    
    [UIView commitAnimations];
    NSLog(@"view named %@ move to point(%f,%f)",self.name,point.x,point.y);
}

@end
