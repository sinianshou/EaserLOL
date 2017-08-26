//
//  FKFlowLayout.m
//  UICollectionViewControllerTest
//
//  Created by yeeku on 13-6-24.
//  Copyright (c) 2013年 crazyit.org. All rights reserved.
//

#import "SKFlowLayout.h"

@implementation SKFlowLayout
#define ACTIVE_DISTANCE 250
#define ZOOM_FACTOR 0.5
-(id)init
{
	self = [super init];
	if (self)
	{
		// 设置每个单元格的大小
		self.itemSize = CGSizeMake(154,280);
		// 设置该控件的滚动方向
		self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		// 设置各分区上、下、左、右保留的空白区的大小
        CGFloat InsetH = ([UIScreen mainScreen].bounds.size.width - self.itemSize.width)/3;
		self.sectionInset = UIEdgeInsetsMake(0.0, InsetH, 0.0, InsetH);
		// 设置各单元格之间最小的行间距
        self.minimumLineSpacing = 10.0;
	}
	return self;
}
// 该方法的返回值决定当UICollectionView的bounds改变时，是否需要重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
	// 返回YES表示需要重新布局
	return YES;
}
// 该方法的返回值控制指定CGRect区域内各单元格的大小、位置等布局属性
-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
	NSArray* array = [super layoutAttributesForElementsInRect:rect];
	// 定义一个CGRect，用于记录该UICollectionView的可视区域
	CGRect visibleRect;
	// 设置visibleRect的原点等于contentView的偏移
	visibleRect.origin = self.collectionView.contentOffset;
	// 设置visibleRect的大小与contentView的大小相同
	visibleRect.size = self.collectionView.bounds.size;
	
	for (UICollectionViewLayoutAttributes* attributes in array) {
		if (CGRectIntersectsRect(attributes.frame, rect))
		{
			// 用可视区域的中心减去当前单元控件的中心，得到该单元格与中心的距离
			CGFloat distance = CGRectGetMidX(visibleRect)
				- attributes.center.x;
//            // 如果该单元格与中心小于指定值，就对该控件进行放大
//            if (ABS(distance) < ACTIVE_DISTANCE)
//            {
//                // 计算放大比例：该单元格与中心的距离越大，放大比例越小
//                CGFloat zoom = 1 + ZOOM_FACTOR *
//                    (1 - ABS(distance / ACTIVE_DISTANCE));
//                // 设置对单元格在X方向、Y方向上进行放大zoom倍
//                attributes.transform3D = CATransform3DMakeScale(
//                    zoom, zoom, 1.0);
//                attributes.zIndex = 1;
//            }
            
            // 如果该单元格与中心小于指定值，就对该控件进行放大
            CGFloat zoom =(1-ABS(ZOOM_FACTOR*distance/ACTIVE_DISTANCE)) < ZOOM_FACTOR?ZOOM_FACTOR:(1-ABS(ZOOM_FACTOR*distance/ACTIVE_DISTANCE));
            attributes.transform3D = CATransform3DMakeScale( zoom, zoom, 1.0);
            attributes.zIndex = 1;
		}
	}
	return array;
}
@end
