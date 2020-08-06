//
//  RACViewController.m
//  ReactiveDataBoard
//
//  Created by leon0206 on 10/18/2019.
//  Copyright (c) 2019 leon0206. All rights reserved.
//

#import "RACViewController.h"
#import "RACContentViewController.h"
#import "ReactiveWhiteBoard.h"

@interface RACViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation RACViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView  alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    [[self.blackBoard addObserver:self forKey:@"rac_test_key"] subscribeNext:^(id  _Nullable x) {
           NSLog(@"RACViewController----->%@",x);
    }];
    
    [[self.blackBoard valueForKey:@"rac_test_key"] subscribeNext:^(id  _Nullable x) {
            NSLog(@"RACViewController----->%@",x);
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self.blackBoard setValue:@"pauseSignalForKey" forKey:@"rac_test_key"];
        
//         [self.blackBoard pauseSignalForKey:@"rac_test_key"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
//            [self.blackBoard setValue:@"pauseSignalForKey" forKey:@"rac_test_key"];
            
//            [self.blackBoard restartSignalForKey:@"rac_test_key"];
            
//            [self.blackBoard setValue:@"restartSignalForKey" forKey:@"rac_test_key"];
            
        });
    });
    [RACWB setValue:@"value" forKey:@"rac_test_key"];
    [[ReactiveWhiteBoard whiteBoard] addObserver:self forKey:@"key"];
    [[ReactiveWhiteBoard whiteBoard] removeObserver:self forKey:@"key"];
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
        contentCell.textLabel.text = @"RACContentViewController";
    }
    return contentCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
   if (indexPath.row == 0) {
       RACContentViewController *vc = [RACContentViewController new];
        vc.blackBoard = self.blackBoard;
        [self.navigationController pushViewController:vc animated:YES];
   }
}

@end
