//
//  PageViewController.m
//  LOLHelper
//
//  Created by Easer Liu on 6/13/17.
//  Copyright © 2017 Liu Easer. All rights reserved.
//

#import "PageViewController.h"
#import "OptimizeLog.h"

@interface PageViewController ()
@property (strong, nonatomic) IBOutlet UINavigationBar *PageNavigation;
@property (strong, nonatomic) IBOutlet UIWebView *PageView;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.PageView loadHTMLString:self.content baseURL:[NSURL URLWithString:@"baidu"]];
    
    [self resizingControlls];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)resizingControlls
{
    self.PageNavigation.translatesAutoresizingMaskIntoConstraints = NO;
    self.PageView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary * views = [[NSDictionary alloc] initWithObjectsAndKeys:self.PageView,@"PageView",self.PageNavigation,@"PageNavigation", nil];
    NSString * vflV = [NSString stringWithFormat:@"V:|[PageNavigation][PageView]|"];
    NSArray * constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:vflV options:0 metrics:nil views:views];
    [self.view addConstraints:constraintsV];
    
    NSString * vflH01 = [NSString  stringWithFormat:@"H:|[PageNavigation]|"];
    NSArray * constraintsH01 = [NSLayoutConstraint constraintsWithVisualFormat:vflH01 options:0 metrics:nil views:views];
    [self.view addConstraints:constraintsH01];
    
    NSString * vflH02 = [NSString stringWithFormat:@"H:|[PageView]|"];
    NSArray * constraintsH02 = [NSLayoutConstraint constraintsWithVisualFormat:vflH02 options:0 metrics:nil views:views];
    [self.view addConstraints:constraintsH02];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
