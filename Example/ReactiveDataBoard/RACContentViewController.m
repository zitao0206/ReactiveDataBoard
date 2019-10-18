//
//  RACContentViewController.m
//  ReactiveDataBoard_Example
//
//  Created by lizitao on 2019/10/18.
//  Copyright © 2019 leon0206. All rights reserved.
//

#import "RACContentViewController.h"

@interface RACContentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation RACContentViewController

- (void)dealloc
{
//    [self.blackBoard removeObserver:self forKey:@"rac_test_key"];
//    [self.blackBoard removeObserver:self forKey:@"rac_test_123_key"];
    [self.blackBoard removeAllObjObservers:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView  alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    [[self.blackBoard addObserver:self forKey:@"rac_test_key"] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"RACContentViewController----->rac_test_key %@",x);
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 0; i < 100; i++) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0.3), ^{
                     [self.blackBoard setValue:@"多线程1" forKey:@"rac_test_key"];
                 });
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0.3), ^{
                 [self.blackBoard setValue:@"多线程2" forKey:@"rac_test_key"];
             });
        }
     
    });
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
    return 200.0;
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
