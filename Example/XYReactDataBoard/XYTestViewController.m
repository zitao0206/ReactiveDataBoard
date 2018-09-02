//
//  XYTestViewController.m
//  XYReactDataBoard_Example
//
//  Created by lizitao on 2018/9/2.
//  Copyright © 2018年 lizitao000. All rights reserved.
//

#import "XYTestViewController.h"
#import "XYReactBlackBoard.h"
#import "XYReactWhiteBoard.h"

@interface XYTestViewController ()
@property (nonatomic, strong) XYReactBlackBoard *blackBoard;
@end

@implementation XYTestViewController

- (void)dealloc
{
    [[XYReactWhiteBoard shareBoard] removeValueForKey:@"xy_whiteBoard"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.blackBoard setValue:@"hello, blackBoard..." forKey:@"xy_blackBoard"];
    });
    
    [[self.blackBoard signalForKey:@"xy_blackBoard"] subscribeNext:^(id  _Nullable x) {
        NSLog(@"-------->%@",x);
    }];
    
    //    [self.blackBoard setValue:@"test1" forKey:@"video_edit_key"];
    //
    //    [self.blackBoard pauseSignalForKey:@"video_edit_key"];
    //
    //    [self.blackBoard setValue:@"test123" forKey:@"video_edit_key"];
    //
    //    [self.blackBoard restartSignalForKey:@"video_edit_key"];
    
    //    [self.blackBoard removeValueForKey:@"video_edit_key"];
    
    //需要dealloc中手动释放
    [[[XYReactWhiteBoard shareBoard] signalForKey:@"xy_whiteBoard"] subscribeNext:^(id  _Nullable x) {
        NSLog(@"----------------->%@",x);
    }];
    
    //带自动释放的白板
    [[[XYReactWhiteBoard shareBoard] signalForKeyPath:XY_KEYPATH(@"xy_whiteBoard_keyPath")] subscribeNext:^(id x) {
        NSLog(@"----------------->%@",x);
    }];
}

- (XYReactBlackBoard *)blackBoard
{
    if (_blackBoard == nil) {
        _blackBoard = [XYReactBlackBoard new];
    }
    return _blackBoard;
}

@end
