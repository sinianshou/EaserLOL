//
//  TableViewDelegate.m
//  LOLHelper
//
//  Created by Easer Liu on 5/28/17.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "TableViewDataSource.h"
#import "ChineseNewestVideos+CoreDataClass.h"
#import "ChineseAuthors+CoreDataClass.h"
#import "AppDelegate.h"
#import "TableHeaderViewModel.h"
#import "OptimizeLog.h"



@implementation TableViewDataSource

@synthesize myTableView;
@synthesize tableCell;
@synthesize LHfetchedResultsController;
@synthesize numberOfRows;
@synthesize dataTemp;
@synthesize isPaused;
@synthesize type;
@synthesize imgAche;
@synthesize cellHeight;
@synthesize NumCell;
@synthesize offSet;
@synthesize headerView;
@synthesize headerStatue;


-(id)initWithTableView:(UITableView *) tableView
{
    self = [super init];
    if (self) {
        self.myTableView = tableView;
        self.myTableView.dataSource = self;
        self.myTableView.delegate = self;
        self.headerView = [TableHeaderViewModel getTableHeaderView];
        self.headerStatue = Normal;
        self.NumCell = 0;
    }
    return self;
}

-(void)dataSourceWithFreeChampionsList:(NSArray *)freeChampionsList
{
    self.tableCell = [TableCellModel getCellOfFreeChampionsList];
    ChineseNewestVideos * re1 = [freeChampionsList lastObject];
    UITextView * textView = [tableCell viewWithTag:11];
    textView.text = re1.title;
    
    NSLog(@"text is %lu",(unsigned long)tableCell.subviews.count);
    NSLog(@"text is %@",textView.text);
    
    self.numberOfRows = 1;
    
}




-(void)dataSourceWithChineseNewestVideosFetchedResultsController
{
    self.type = ChineseNewestVideosList;
    [self setLHFetchedResultsController];
}

-(void)dataSourceWithChineseAuthorsFetchedResultsController
{
    self.type = ChineseAuthorsList;
    [self setLHFetchedResultsController];
}

-(void)dataSourceWithFetchedResultsController:(NSInteger)tag
{
    switch (tag) {
        case 0:
            self.type = ChineseNewestVideosList;
            break;
        case 1:
            self.type = ChineseAuthorsList;
            break;
        case 2:
            self.type = ChineseChannelList;
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        case 5:
            
            break;
            
        default:
            break;
    }
    [self setLHFetchedResultsController];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier;
    switch (self.type) {
            //初始化ChineseNewestVideo的cell并配置数据
        case ChineseNewestVideosList:
            identifier = @"ChineseNewestVideos";
            self.tableCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (self.tableCell == nil) {
                self.tableCell = [TableCellModel getCellOfChineseNewestVideosWithIdentifier:identifier];
                self.NumCell++;
                NSLog(@"创建一个新的Cell,共%lD个cell",(long)self.NumCell);
                
            }else
            {
                NSLog(@"重用一个Cell");
            }
            
            [self configChineseNewestVideoCell:(TableCellModel *)self.tableCell index:indexPath ];
            break;
           
        case ChineseAuthorsList: case ChineseChannelList:
            identifier = @"ChineseAuthors";
            self.tableCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (self.tableCell == nil) {
                self.tableCell = [TableCellModel getCellOfChineseAuthorsWithIdentifier:identifier];
                self.NumCell++;
                NSLog(@"创建一个新的Cell,共%lD个cell",(long)self.NumCell);
                
            }else
            {
                NSLog(@"重用一个Cell");
            }
            
            [self configChineseAuthorCell:self.tableCell index:indexPath ];
            break;
            
        default:
            break;
    }

    [self.tableCell setNeedsDisplay];
    [self.tableCell layoutIfNeeded];
    // Configure the cell with data from the managed object.
    return self.tableCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[self.LHfetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.LHfetchedResultsController sections] objectAtIndex:section];
        self.numberOfRows = [sectionInfo numberOfObjects];
        return self.numberOfRows;
    } else
        return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.LHfetchedResultsController sections] count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChineseNewestVideos * Video;
    ChineseAuthors * author;
    NSMutableString * content = [[NSMutableString alloc] init];
    
    NSMutableString * pageContentStr = [NSMutableString stringWithContentsOfFile:[NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle]resourcePath],@"/PageView.html"] encoding:NSUTF8StringEncoding error:NULL];
    switch (self.type) {
        case ChineseNewestVideosList:
            Video = [self.LHfetchedResultsController objectAtIndexPath:indexPath];
            content = [NSMutableString stringWithFormat:@"%@",Video.content];
            [content stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            pageContentStr = [pageContentStr stringByReplacingOccurrencesOfString:@"WaitingReplaceTitle" withString:Video.title];
            pageContentStr = [pageContentStr stringByReplacingOccurrencesOfString:@"WaitingReplaceTime" withString:Video.createdate];
            pageContentStr = [pageContentStr stringByReplacingOccurrencesOfString:@"WaitingReplaceVideo" withString:content];
            content = pageContentStr;
            break;
        case ChineseAuthorsList: case ChineseChannelList:
            author = [self.LHfetchedResultsController objectAtIndexPath:indexPath];
            break;
            
        default:
            break;
    }
    if ([self.myLHUpDropDelegate respondsToSelector:@selector(didSelectedCell:)]) {
        [self.myLHUpDropDelegate didSelectedCell:content];
    }
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return self.headerView;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return self.headerView.bounds.size.height;
//}

#pragma mark - fetchedResultsDelegate methods

-(void)didselectRowData:(id)data
{
}

- (void)configChineseNewestVideoCell:(UITableViewCell *)cell index:(NSIndexPath *)indexPath
{
    //获取对应indexPat的video数据
    ChineseNewestVideos * Video = [self.LHfetchedResultsController objectAtIndexPath:indexPath];
    
    //获取ImageView
    UIImageView * imgView = [cell viewWithTag:11];
    
    NSArray *indexPaths = [self.myTableView indexPathsForVisibleRows];
    for (NSIndexPath *visibleIndexPath in indexPaths)
    {
        if (indexPath == visibleIndexPath)
        {
            if ((imgView.image = [self.imgAche objectForKey:Video.img]))
            {}else
            {
                [self ahceChineseNewestVideosImg:Video.img IndexPath:indexPath];
                
                NSLog(@"Video title is %@ img is %@",Video.title,Video.img);
            break;
            }
        }
    }
    UILabel * title = [cell viewWithTag:12];
    title.text = Video.title;
    
    UITextView * description = [cell viewWithTag:13];
    description.text = Video.title;
    
    UILabel * createDate = [cell viewWithTag:14];
    createDate.text = Video.createdate;
    
    UILabel * author = [cell viewWithTag:15];
    author.text = [NSString stringWithFormat:@"Data Count is %lu",(unsigned long)self.numberOfRows];

    self.cellHeight = author.frame.origin.y + author.frame.size.height + 5;
    self.myTableView.estimatedRowHeight = self.cellHeight;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)configChineseAuthorCell:(UITableViewCell *)cell index:(NSIndexPath *)indexPath
{
    //获取对应indexPat的video数据
    ChineseAuthors * author = [self.LHfetchedResultsController objectAtIndexPath:indexPath];
    
    //获取ImageView
    UIImageView * imgView = [cell viewWithTag:11];
    
    NSArray *indexPaths = [self.myTableView indexPathsForVisibleRows];
    for (NSIndexPath *visibleIndexPath in indexPaths)
    {
        if (indexPath == visibleIndexPath)
        {
            if ((imgView.image = [self.imgAche objectForKey:author.img]))
            {}else
            {
                [self ahceChineseNewestVideosImg:author.img IndexPath:indexPath];
                NSLog(@"author name is %@ img is %@",author.name,author.img);
                break;
            }
        }
    }
    
    UILabel * name = [cell viewWithTag:12];
    name.text = author.name;
    
    UITextView * description = [cell viewWithTag:13];
    description.text = author.desc;
    
    UILabel * isex = [cell viewWithTag:14];
    isex.text = author.isex;
    
    self.cellHeight = isex.frame.origin.y + isex.frame.size.height + 5;
    self.myTableView.estimatedRowHeight = self.cellHeight;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
}

-(void)setLHFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController
{
    self.LHfetchedResultsController = fetchedResultsController;
    self.LHfetchedResultsController.delegate = self;
    NSError * err;
    if (![self.LHfetchedResultsController performFetch:&err]) {
        //启动
        NSLog(@"Unresolved error : %@, %@",err,[err userInfo]);
        exit(-1);
    }
    [self.myTableView reloadData];
}

-(void)setLHFetchedResultsController
{
    NSDictionary * entityNameAndSort;
    NSPredicate * predicate;
    switch (self.type) {
            //如果抓取的是
        case ChineseNewestVideosList:
            entityNameAndSort = @{@"entityName":@"ChineseNewestVideos", @"sort":@"createdate"};
            break;
            
        case ChineseAuthorsList:
            entityNameAndSort = @{@"entityName":@"ChineseAuthors", @"sort":@"id"};
            predicate = [NSPredicate predicateWithFormat:@"isex = 1"];
            break;
        case ChineseChannelList:
            entityNameAndSort = @{@"entityName":@"ChineseAuthors", @"sort":@"id"};
            predicate = [NSPredicate predicateWithFormat:@"isex != 1"];
            break;
            
        default:
            break;
    }
    
    
    
    NSManagedObjectContext * context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    
    NSFetchRequest * request = [ChineseNewestVideos fetchRequest];
    NSEntityDescription * testEntity = [NSEntityDescription entityForName:[entityNameAndSort valueForKey:@"entityName"] inManagedObjectContext:context];
    request.entity = testEntity;
    NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:[entityNameAndSort valueForKey:@"sort"] ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    [request setFetchBatchSize:20];
    if (predicate != nil) {
        [request setPredicate:predicate];
    }
    NSFetchedResultsController * LHFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
 
    [self setLHFetchedResultsController:LHFetchedResultsController];
}

-(void)setPaused:(BOOL)paused
{
    self.isPaused = paused;
    if (self.isPaused) {
        self.LHfetchedResultsController.delegate = nil;
    }else
    {
        self.LHfetchedResultsController.delegate = self;
        [self.LHfetchedResultsController performFetch:NULL];
        [self.myTableView reloadData];
    }
}

- (void)ahceChineseNewestVideosImg:(NSString *) imgString IndexPath:(NSIndexPath *)indexPath
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[imgString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    
    // create an session data task to obtain and download the app icon
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse *response, NSError *error){
                                                       
                                                       // in case we want to know the response status code
                                                       //NSInteger HTTPStatusCode = [(NSHTTPURLResponse *)response statusCode];
                                                       
                                                       if (error != nil)
                                                       {
                                                           if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection)
                                                           {
                                                               // if you get error NSURLErrorAppTransportSecurityRequiresSecureConnection (-1022),
                                                               // then your Info.plist has not been properly configured to match the target server.
                                                               //
                                                               abort();
                                                           }
                                                       }
                                                       
                                                       [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                                                           
                                                           // Set appIcon and clear temporary data/image
                                                           UIImage *image = [[UIImage alloc] initWithData:data];
                                                           
                                                           [self.imgAche setObject:image forKey:imgString];
                                                           TableCellModel * cell = [self.myTableView cellForRowAtIndexPath:indexPath];
                                                           ((UIImageView *)[cell viewWithTag:11]).image = image;
                                                       }];
                                                   }];
    
    [dataTask resume];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIView * view01 = [self.myTableView viewWithTag:31];
    NSLog(@"header frame is %f %f %f %f",view01.frame.origin.x, view01.frame.origin.y, view01.frame.size.width, view01.frame.size.height);
    NSLog(@"tabl.view.frame is %f %f %f %f",self.myTableView.frame.origin.x, self.myTableView.frame.origin.y, self.myTableView.frame.size.width, self.myTableView.frame.size.height);
    UIImageView * imgView = [view01 viewWithTag:12];
    CGFloat sectionHeaderHeight = imgView.bounds.size.height*2/3;
    if (scrollView.contentOffset.y >= sectionHeaderHeight)
    {
        view01.frame = CGRectMake(view01.frame.origin.x, (scrollView.contentOffset.y-sectionHeaderHeight), view01.frame.size.width, view01.frame.size.height);
        self.headerStatue = UpToTop;
        
        if ([self.myLHUpDropDelegate respondsToSelector:@selector(changeNavigationStatu:)]) {
            [self.myLHUpDropDelegate changeNavigationStatu:@"UpToTop"];
        }
        
        NSLog(@"headerStatue update");
    }else
    {
        view01.frame = CGRectMake(view01.frame.origin.x, 0, view01.frame.size.width, view01.frame.size.height);
        if ([self.myLHUpDropDelegate respondsToSelector:@selector(changeNavigationStatu:)]) {
            [self.myLHUpDropDelegate changeNavigationStatu:@"Normal"];
        }
    }
    [self.myTableView layoutIfNeeded];
    NSLog(@"offset is %f, %f",scrollView.contentOffset.y,scrollView.contentInset.top);
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
//{
//    [self.tableView beginUpdates];
//}
//
//-(void)controller:(NSFetchedResultsController*)controller didChangeObject:(nonnull id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath
//{
//    if (type == NSFetchedResultsChangeInsert) {
//        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    } else if (type == NSFetchedResultsChangeMove) {
//        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
//    } else if (type == NSFetchedResultsChangeDelete) {
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    } else {
////        NSAssert(NO,@"");
//    }
//    //实时更新，但当数据量大时会造成拥挤
////    [self.tableView reloadData];
//}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
//    [self.tableView endUpdates];
    [self.myTableView reloadData];
}

@end
