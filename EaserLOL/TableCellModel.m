//
//  TableCellModel.m
//  LOLHelper
//
//  Created by Easer Liu on 5/27/17.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableCellModel.h"
#import "OptimizeLog.h"

@implementation TableCellModel

+(UITableViewCell *) getCellOfFreeChampionsList
{
    TableCellModel * tableCell = [[super alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NULL];
    UITextView * textView = [[UITextView alloc] init];
    textView.tag = 11;
    textView.text = @"无信息";
    textView.frame = CGRectMake(5, 5, 70, 20);
    textView.backgroundColor = [UIColor blueColor];
    [tableCell.contentView addSubview:textView];
    
    UILabel * la = [[UILabel alloc] init];
    la.frame = CGRectMake(5, 30, 300, 20);
    la.tag = 12;
    [tableCell.contentView addSubview:la];
    
    NSLog(@"%@", textView.text);
    NSLog(@"count is %lu", (unsigned long)tableCell.subviews.count);
    return tableCell;
}

+(UITableViewCell *) getCellOfChineseNewestVideosWithIdentifier:(NSString *) identifier
{
    TableCellModel * tableCell = [[super alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    //分辨率 183x108
    UIImageView * img = [[UIImageView alloc] init];
    img.tag = 11;
    [tableCell.contentView addSubview:img];
    
    UILabel * title = [[UILabel alloc] init];
    title.tag = 12;
    [tableCell.contentView addSubview:title];
    
    UITextView * description = [[UITextView alloc] init];
    description.tag = 13;
    description.selectable = NO;
    [tableCell.contentView addSubview:description];
    
    UILabel * createDate = [[UILabel alloc] init];
    createDate.tag = 14;
    createDate.font = [UIFont systemFontOfSize:10];
    [tableCell.contentView addSubview:createDate];
    
    UILabel * author = [[UILabel alloc] init];
    author.tag = 15;
    author.font = [UIFont systemFontOfSize:10];
    [tableCell.contentView addSubview:author];
    
    NSLog(@"tableCell.subviews.count is %lu", (unsigned long)tableCell.subviews.count);
    [self resizingChineseNewestVideosCell:tableCell];
    return tableCell;

}
+(void)resizingChineseNewestVideosCell:(TableCellModel*)tableCell
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    UIImageView * imgView = [tableCell viewWithTag:11];
    imgView.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel * title = [tableCell viewWithTag:12];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    UITextView * description = [tableCell viewWithTag:13];
    description.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel * createDate = [tableCell viewWithTag:14];
    createDate.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel * author = [tableCell viewWithTag:15];
    author.translatesAutoresizingMaskIntoConstraints = NO;

    //添加垂直方向的约束
    CGFloat w1 = screenSize.width/3;
    CGFloat h1 = 108*(screenSize.width)/(183*3);
    NSNumber * marginW = [NSNumber numberWithFloat:w1];
    NSNumber * marginH = [NSNumber numberWithFloat:h1];
    NSDictionary *mertrics = NSDictionaryOfVariableBindings(marginW,marginH);
    NSString *vflV1 = @"V:|-5-[imgView(marginH)]-[createDate(15)]-3-|";
    NSDictionary * viewsV1 = NSDictionaryOfVariableBindings(imgView,createDate);
    NSArray * constraintsV1 = [NSLayoutConstraint constraintsWithVisualFormat:vflV1 options:0 metrics:mertrics views:viewsV1];
    [tableCell.contentView addConstraints:constraintsV1] ;
    
    NSString * vflV2 = @"V:|-5-[title(20)]-[description]-[author(15)]-3-|";
    NSDictionary * viewsV2 = NSDictionaryOfVariableBindings(title,description,author);
    NSArray * constraintsV2 = [NSLayoutConstraint constraintsWithVisualFormat:vflV2 options:0 metrics:NULL views:viewsV2];
    [tableCell.contentView addConstraints:constraintsV2];
    //水平方向的约束
    NSString * vflH1 = @"H:|-5-[imgView(marginW)]-[title]-5-|";
    NSDictionary * viewsH1 = NSDictionaryOfVariableBindings(imgView,title);
    NSArray * constraintsH1 = [NSLayoutConstraint constraintsWithVisualFormat:vflH1 options:0 metrics:mertrics views:viewsH1];
    [tableCell.contentView addConstraints:constraintsH1];
    
    NSString * vflH2 = @"H:|-5-[imgView]-[description]-5-|";
    NSDictionary * viewsH2 = NSDictionaryOfVariableBindings(imgView,description);
    NSArray * constraintsH2 = [NSLayoutConstraint constraintsWithVisualFormat:vflH2 options:0 metrics:NULL views:viewsH2];
    [tableCell.contentView addConstraints:constraintsH2];
    
    NSString * vflH3 = @"H:|-5-[createDate]-[author]-5-|";
    NSDictionary * viewsH3 = NSDictionaryOfVariableBindings(createDate,author);
    NSArray * constraintsH3 = [NSLayoutConstraint constraintsWithVisualFormat:vflH3 options:0 metrics:NULL views:viewsH3];
    [tableCell.contentView addConstraints:constraintsH3];
    
    [tableCell.contentView reloadInputViews];
}
+(UITableViewCell *) getCellOfChineseAuthorsWithIdentifier:(NSString *) identifier
{
    TableCellModel * tableCell = [[super alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    //分辨率 135x135
    UIImageView * img = [[UIImageView alloc] init];
    img.tag = 11;
    [tableCell.contentView addSubview:img];
    
    UILabel * name = [[UILabel alloc] init];
    name.tag = 12;
    [tableCell.contentView addSubview:name];
    
    UITextView * description = [[UITextView alloc] init];
    description.tag = 13;
    description.selectable = NO;
    [tableCell.contentView addSubview:description];
    
    UILabel * isex = [[UILabel alloc] init];
    isex.tag = 14;
    isex.font = [UIFont systemFontOfSize:10];
    [tableCell.contentView addSubview:isex];
    
    NSLog(@"tableCell.subviews.count is %lu", (unsigned long)tableCell.subviews.count);
    [self resizingChineseAuthorsCell:tableCell];
    return tableCell;
    
}
+(void)resizingChineseAuthorsCell:(TableCellModel*)tableCell
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    UIImageView * imgView = [tableCell viewWithTag:11];
    imgView.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel * name = [tableCell viewWithTag:12];
    name.translatesAutoresizingMaskIntoConstraints = NO;
    UITextView * description = [tableCell viewWithTag:13];
    description.translatesAutoresizingMaskIntoConstraints = NO;
    UILabel * isex = [tableCell viewWithTag:14];
    isex.translatesAutoresizingMaskIntoConstraints = NO;
    
    //添加垂直方向的约束
    CGFloat w1 = screenSize.width/3;
    CGFloat h1 = 108*(screenSize.width)/(183*3);
    NSNumber * marginW = [NSNumber numberWithFloat:w1];
    NSNumber * marginH = [NSNumber numberWithFloat:h1];
    NSDictionary *mertrics = NSDictionaryOfVariableBindings(marginW,marginH);
    NSDictionary * views = NSDictionaryOfVariableBindings(imgView,name,description,isex);
    NSString *vflV1 = @"V:|-5-[imgView(marginW)]-3-|";
    NSArray * constraintsV1 = [NSLayoutConstraint constraintsWithVisualFormat:vflV1 options:0 metrics:mertrics views:views];
    [tableCell.contentView addConstraints:constraintsV1] ;
    
    NSString * vflV2 = @"V:|-5-[name(20)]-[description]-3-|";
    NSArray * constraintsV2 = [NSLayoutConstraint constraintsWithVisualFormat:vflV2 options:0 metrics:NULL views:views];
    [tableCell.contentView addConstraints:constraintsV2];
    
    NSString * vflV3 = @"V:|-5-[isex(20)]-[description]-3-|";
    NSArray * constraintsV3 = [NSLayoutConstraint constraintsWithVisualFormat:vflV3 options:0 metrics:NULL views:views];
    [tableCell.contentView addConstraints:constraintsV3];
    //水平方向的约束
    NSString * vflH1 = @"H:|-5-[imgView(marginW)]-[name]-[isex]-5-|";
    NSArray * constraintsH1 = [NSLayoutConstraint constraintsWithVisualFormat:vflH1 options:0 metrics:mertrics views:views];
    [tableCell.contentView addConstraints:constraintsH1];
    
    NSString * vflH2 = @"H:|-5-[imgView]-[description]-5-|";
    NSArray * constraintsH2 = [NSLayoutConstraint constraintsWithVisualFormat:vflH2 options:0 metrics:NULL views:views];
    [tableCell.contentView addConstraints:constraintsH2];
    
    [tableCell.contentView reloadInputViews];
}
@end
