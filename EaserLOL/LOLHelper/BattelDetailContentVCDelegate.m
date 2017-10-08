//
//  BattelDetailContentVCDelegate.m
//  LOLHelper
//
//  Created by Easer Liu on 04/08/2017.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "BattelDetailContentVCDelegate.h"
@interface BattelDetailContentVCDelegate ()

@property (assign, nonatomic) CGFloat startContentOffSetX;

@end
@implementation BattelDetailContentVCDelegate

#pragma mark - UIScrollViewDelegate 委托

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.contentVCDelegatePro changeWhenScrollByRate:scrollView.contentOffset.x/(scrollView.contentSize.width*2/3)];

}
// 当开始滚动视图时，执行该方法。一次有效滑动（开始滑动，滑动一小段距离，只要手指不松开，只算一次滑动），只执行一次。
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillBeginDragging");
    self.startContentOffSetX = scrollView.contentOffset.x;
    
}
// 滑动视图，当手指离开屏幕那一霎那，调用该方法。一次有效滑动，只执行一次。
// decelerate,指代，当我们手指离开那一瞬后，视图是否还将继续向前滚动（一段距离），经过测试，decelerate=YES
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollViewDidEndDragging");
    if (decelerate) {
        NSLog(@"decelerate");
        [scrollView setDecelerationRate:0];
        
    }else{
        NSLog(@"no decelerate");
        if (scrollView.contentOffset.x < scrollView.contentSize.width/6)
        {
            [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width*0/3, 0) animated:YES];
        }else if (scrollView.contentOffset.x > scrollView.contentSize.width*3/6)
        {
            
            [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width*2/3, 0) animated:YES];
        }else
        {
            [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width*1/3, 0) animated:YES];
        }
    }
    
    CGPoint point=scrollView.contentOffset;
    NSLog(@"%f,%f",point.x,point.y);
    NSLog(@"scrollView.contentInset is %f %f", scrollView.contentInset.left,scrollView.contentInset.right);
}
// 滑动减速时调用该方法。
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillBeginDecelerating");
    if (scrollView.contentOffset.x > self.startContentOffSetX) {
        //向左滑动
        
        if (scrollView.contentOffset.x < scrollView.contentSize.width*1/3)
        {
            [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width*1/3, 0) animated:YES];
        }else if (scrollView.contentOffset.x > scrollView.contentSize.width*1/3 && scrollView.contentOffset.x < scrollView.contentSize.width*2/3)
        {
            [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width*2/3, 0) animated:YES];
        }
    }else
    {
        //向右滑动
        if (scrollView.contentOffset.x < scrollView.contentSize.width*1/3)
        {
            [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width*0/3, 0) animated:YES];
        }else if (scrollView.contentOffset.x > scrollView.contentSize.width*1/3 && scrollView.contentOffset.x < scrollView.contentSize.width*2/3)
        {
            [scrollView setContentOffset:CGPointMake(scrollView.contentSize.width*1/3, 0) animated:YES];
        }
    }
    
    // 该方法在scrollViewDidEndDragging方法之后。
}
@end
