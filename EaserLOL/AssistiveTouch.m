#import"AssistiveTouch.h"
#import "UIViewPer.h"

@interface AssistiveTouch()
{
    CAShapeLayer *maskLayer;}
@property BOOL isExpanded;

@end

@implementation AssistiveTouch

-(id)initWithFrame:(CGRect)frame

{
    self= [super initWithFrame:frame];
    
    if(self) {
        self.backgroundColor= [UIColor clearColor];
        self.windowLevel=UIWindowLevelAlert+1;
        
//        self.layer.cornerRadius= frame.size.width/2;
//        self.clipsToBounds = YES;
        
        self.isExpanded = NO;
        self.circleButtons = [[NSMutableArray alloc] init];
        self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.ciecleColor = nil;
        
        //这句话很重要
        [self setDefaultRoundMenuWithFrame];
        
        
        [self.centerButton addTarget:self action:@selector(doExpandCircleMenu) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]  initWithTarget:self action:@selector(changePostion:)];
        [self.centerButton addGestureRecognizer:pan];
        
        [self addSubview:self.centerButton];
        [self bringSubviewToFront:self.centerButton];
        
        [self makeKeyAndVisible];
        
        
    }
    
    return self;
    
}

-(void)setDefaultRoundMenuWithFrame
{
    self.ciecleColor = [UIColor yellowColor];
    
    self.centerButton.backgroundColor = [UIColor orangeColor];
    CGFloat CenterButtonDefaultRadius = self.frame.size.height/2;
    [self setCenterButtonWithRadius:CenterButtonDefaultRadius];
    
    
    NSArray * iconArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"icon_can"],
                           [UIImage imageNamed:@"icon_pos"],
                           [UIImage imageNamed:@"icon_img"],
                           [UIImage imageNamed:@"icon_can"],
                           [UIImage imageNamed:@"icon_pos"],
                           [UIImage imageNamed:@"icon_img"],
                           [UIImage imageNamed:@"icon_can"], nil];
    CGFloat CircleButtonDefaultRadius = CenterButtonDefaultRadius;
    
    
    [self setCircleButtonsWithImgs:iconArray Radius:CircleButtonDefaultRadius];
}

-(void)setCenterButtonWithRadius:(CGFloat)CBRadius
{
    self.bounds = CGRectMake(0, 0, CBRadius*2, CBRadius*2);
    self.layer.cornerRadius= CBRadius;
    self.clipsToBounds = YES;
    
    self.centerButton.bounds = CGRectMake(0, 0, CBRadius*2, CBRadius*2);
    self.centerButton.layer.cornerRadius = CBRadius;
    self.centerButton.clipsToBounds = YES;
    self.centerButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self setNeedsDisplay];
    [self layoutIfNeeded];
}

-(void)setCircleButtonsWithImgs: (NSArray<UIImage*>*) iconArray Radius:(CGFloat) circleButtonRadius
{
    NSLog(@"圆形菜单要创建%lu个按钮",(unsigned long)iconArray.count);
    [self.circleButtons removeAllObjects];
    for (int i = 0; i < iconArray.count; i++) {
        UIButton * button = [[UIButton alloc] initWithName:[NSString stringWithFormat:@"button%d",i]];
        button.tag = i;
        button.bounds = CGRectMake(0, 0, circleButtonRadius*2, circleButtonRadius*2);
        button.layer.cornerRadius = circleButtonRadius;
        button.clipsToBounds = YES;
        button.backgroundColor = [UIColor clearColor];
        button.center = self.centerButton.center;
        [button setImage:iconArray[i] forState:UIControlStateNormal];
        button.enabled = NO;
        button.hidden = YES;
        [button addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:button belowSubview:self.centerButton];
        [self.circleButtons addObject:button];
    }
}
-(void)doExpandCircleMenu
{
    if (self.isExpanded == YES) {
        [self shrinkButtons];
        [self shrinkCircleMenu];
        self.isExpanded = NO;
    }else if (self.isExpanded == NO)
    {
        [self expandCircleMenu];
        [self expandButtons];
        self.isExpanded = YES;
    }
}

-(void)shrinkCircleMenu
{
    CGRect fromRect = self.bounds;
    CGRect toRect = self.centerButton.frame;
    [self animateFromFrame:fromRect toFrame:toRect];
}

-(void)expandCircleMenu
{
    
    CGRect expandRect;
    if (self.circleButtons.count > 0) {
        expandRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.centerButton.bounds.size.height + self.circleButtons[0].bounds.size.height*2 + 8, self.centerButton.bounds.size.height + self.circleButtons[0].bounds.size.height*2 + 8);
    }else
    {
        expandRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width*2, self.bounds.size.height*2);
    }
    self.bounds = expandRect;
    self.layer.cornerRadius = expandRect.size.width/2;
    self.clipsToBounds = YES;
    
    self.centerButton.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2);
    
    CGRect fromRect = self.centerButton.frame;
    CGRect toRect = self.bounds;
    
    [self animateFromFrame:fromRect toFrame:toRect];
    
}

-(void)expandButtons
{
    if (self.circleButtons.count>0) {
        CGFloat raduis = (self.centerButton.bounds.size.height + self.circleButtons[0].bounds.size.height)/2 + 2;
        for (int i = 0; i < self.circleButtons.count; i++) {
            UIButton * button = self.circleButtons[i];
            button.center = self.centerButton.center;
            button.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:0.2
                                  delay:i * 0.02
                 usingSpringWithDamping:0.5
                  initialSpringVelocity:5
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 button.center = CGPointMake(self.centerButton.center.x + raduis * cos(M_PI*2/self.circleButtons.count*i), self.centerButton.center.y + raduis * sin(M_PI*2/self.circleButtons.count*i));
                                 button.hidden = NO;
                                 button.enabled = YES;
                             } completion:^(BOOL finished) {
                                 
                             }];
        }
    }
}
-(void)shrinkButtons
{
    if (self.circleButtons.count>0) {
        for (int i = 0; i < self.circleButtons.count; i++) {
            UIButton * button = self.circleButtons[i];
            button.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:0.2
                                  delay:i * 0.02
                 usingSpringWithDamping:0.5
                  initialSpringVelocity:5
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 button.center = self.centerButton.center;
                                 button.hidden = YES;
                                 button.enabled = NO;
                             } completion:^(BOOL finished) {
                                 
                                 
                             }];
        }
    }
}

-(void)animateFromFrame:(CGRect)fromFrame toFrame:(CGRect)toFrame
{
    //创建两个圆形的 UIBezierPath 实例；一个是 button 的 size ，另外一个则拥有足够覆盖屏幕的半径。最终的动画则是在这两个贝塞尔路径之间进行的
    UIBezierPath *maskStartBP =  [UIBezierPath bezierPathWithOvalInRect:fromFrame];
    
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect:toFrame];
    
    
    //创建一个 CAShapeLayer 来负责展示圆形遮盖
    if (maskLayer == nil) {
        maskLayer = [CAShapeLayer layer];
        [self.layer insertSublayer:maskLayer below:self.circleButtons[0].layer];
    }
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = self.ciecleColor.CGColor;
    maskLayer.path = maskFinalBP.CGPath; //将它的 path 指定为最终的 path 来避免在动画完成后会回弹
//    toVC.view.layer.mask = maskLayer;
    
    
    //创建一个关于 path 的 CABasicAnimation 动画来从 circleMaskPathInitial.CGPath 到 circleMaskPathFinal.CGPath 。同时指定它的 delegate 来在完成动画时做一些清除工作
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(maskStartBP.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((maskFinalBP.CGPath));
    maskLayerAnimation.duration = 0.1;
    maskLayerAnimation.delegate = self;
    maskLayerAnimation.removedOnCompletion = YES;
    
    [maskLayer addAnimation:maskLayerAnimation forKey:nil];
}

/**
 * 动画开始时
 */
- (void)animationDidStart:(CAAnimation *)theAnimation
{
    NSLog(@"begin");
}

/**
 * 动画结束时
 */
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (self.isExpanded == NO) {
        
        CGRect shrinkRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.centerButton.bounds.size.width, self.centerButton.bounds.size.height);
        self.bounds = shrinkRect;
        self.layer.cornerRadius = shrinkRect.size.width/2;
        self.clipsToBounds = YES;
        
        self.centerButton.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2);
        
        
    }
}
//按钮事件

-(void)choose:(UIButton*) butotn

{
    
    NSLog(@"悬浮窗");
    
    
}

//手势事件 －－ 改变位置

-(void)changePostion:(UIPanGestureRecognizer*)pan

{
    
    CGPoint point = [pan translationInView:self];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGRect originalFrame =self.frame;
    
    if(originalFrame.origin.x>=0&& originalFrame.origin.x+originalFrame.size.width<= width) {
        
        originalFrame.origin.x+= point.x;
        
    }
    
    if(originalFrame.origin.y>=0&& originalFrame.origin.y+originalFrame.size.height<= height) {
        
        originalFrame.origin.y+= point.y;
        
    }
    
    self.frame= originalFrame;
    
    [pan setTranslation:CGPointZero inView:self];
    
    if(pan.state==UIGestureRecognizerStateBegan) {
        if (self.isExpanded == YES) {
            [self shrinkCircleMenu];
            [self shrinkButtons];
            self.isExpanded = NO;
        }
        self.centerButton.enabled=NO;
        
    }else if(pan.state==UIGestureRecognizerStateChanged){
        
    }else{
        
        CGRect frame =self.frame;
        
        //记录是否越界
        
        BOOL isOver =NO;
        
        if(frame.origin.x<0) {
            
            frame.origin.x=0;
            
            isOver =YES;
            
        }else if(frame.origin.x+frame.size.width> width) {
            
            frame.origin.x= width - frame.size.width;
            
            isOver =YES;
            
        }
        
        if(frame.origin.y<0) {
            
            frame.origin.y=0;
            
            isOver =YES;
            
        }else if(frame.origin.y+frame.size.height> height) {
            
            frame.origin.y= height - frame.size.height;
            
            isOver =YES;
            
        }
        
        if(isOver) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.frame= frame;
                
            }];
            
        }
        
        self.centerButton.enabled=YES;
        
    }
    
}

-(void)setCenterButtonIconForState:(NSArray *)IconStateArrs
{
    NSArray * IconStateArr = nil;
    for (IconStateArr in IconStateArrs) {
        [self.centerButton setImage:IconStateArr[0] forState:(UIControlState)IconStateArr[1]];
    }
}
@end
