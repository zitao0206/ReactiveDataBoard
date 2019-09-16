//
//  XYReactDataBoardSubject.m
//  XYReactDataBoard
//
//  Created by lizitao on 2018/1/10.
//

#import "MDReactDataBoardSubject.h"

@interface MDReactDataBoardSubject ()
@property (nonatomic, strong) id <RACSubscriber> subscriber;
@end

@implementation MDReactDataBoardSubject

- (RACDisposable *)subscribe:(id<RACSubscriber>)subscriber
{
    if (!self.subscriber) {
        self.subscriber = subscriber;
        return [super subscribe:subscriber];
    }
    return nil;
}

- (void)sendNext:(id)value
{
    @synchronized (self) {
        [self.subscriber sendNext:value];
    }
}

@end
