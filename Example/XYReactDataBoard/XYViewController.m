//
//  XYViewController.m
//  XYReactDataBoard
//
//  Created by lizitao000 on 01/19/2018.
//  Copyright (c) 2018 lizitao000. All rights reserved.
//

#import "XYViewController.h"
#import "XYTestViewController.h"
#import "XYReactWhiteBoard.h"

@interface XYViewController ()

@end

@implementation XYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *helloBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    helloBtn.backgroundColor = [UIColor redColor];
    [helloBtn setTitle:@"测试入口" forState:UIControlStateNormal];
    [helloBtn addTarget:self action:@selector(jumpTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:helloBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[XYReactWhiteBoard shareBoard] setValue:@"hello, whiteBoard" forKey:@"xy_whiteBoard"];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[XYReactWhiteBoard shareBoard] setValue:@"hello, whiteBoard_keyPath" forKey:@"xy_whiteBoard_keyPath"];
    });
    
}

- (void)jumpTo
{
    XYTestViewController *testVC = [XYTestViewController new];
    [self.navigationController pushViewController:testVC animated:YES];
}

@end
