//
//  RACMainViewController.m
//  ReactiveDataBoard_Example
//
//  Created by lizitao on 2019/10/18.
//  Copyright © 2019 leon0206. All rights reserved.
//

#import "RACMainViewController.h"
#import "RACContentViewController.h"
#import "RACViewController.h"
#import <ReactiveDataBoard/ReactiveDataBoard.h>

@interface RACMainViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ReactiveBlackBoard *blackBoard;
@end

@implementation RACMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView  alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[RACWB addObserver:self forKey:@"rac_test_key"] subscribeNext:^(id  _Nullable x) {
        NSLog(@"RACMainViewController----->%@",x);
    }];
    
  
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!contentCell) {
        contentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    contentCell.backgroundColor = [UIColor lightGrayColor];
    contentCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        contentCell.textLabel.text = @"RACViewController";
    }
   
    return contentCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.row == 0) {
       RACViewController *vc = [RACViewController new];
       vc.blackBoard = self.blackBoard;
       [self.navigationController pushViewController:vc animated:YES];
   }
}

- (ReactiveBlackBoard *)blackBoard
{
    if (!_blackBoard) {
        _blackBoard = [ReactiveBlackBoard new];
    }
    return _blackBoard;
}
@end
