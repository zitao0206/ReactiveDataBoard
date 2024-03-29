//
//  RACContentViewController.h
//  ReactiveDataBoard_Example
//
//  Created by lizitao on 2019/10/18.
//  Copyright © 2019 zitao0206. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReactiveBlackBoard.h"

NS_ASSUME_NONNULL_BEGIN

@interface RACContentViewController : UIViewController
@property (nonatomic, strong) ReactiveBlackBoard *blackBoard;
@end

NS_ASSUME_NONNULL_END
