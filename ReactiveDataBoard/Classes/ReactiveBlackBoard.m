//
//  ReactiveBlackBoard.m
//  ReactiveDataBoard
//
//  Created by lizitao on 2018/1/19.
//

#import "ReactiveBlackBoard.h"
typedef NS_ENUM(NSInteger, ReactiveBlackBoardFlagValue) {
    ReactiveBlackBoardFlagOn = 0,
    ReactiveBlackBoardFlagOff,
};
@interface ReactiveBlackBoard ()
@property (nonatomic, strong) NSMutableDictionary <NSString *, RACSubject *> *observers;
@property (nonatomic, strong) NSMutableDictionary *values;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSNumber *> *flags;
@end

@implementation ReactiveBlackBoard

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self) {
        
        [self.values setValue:value forKey:key];
        if (![self.flags valueForKey:key]) {
            [self.flags setValue:@(1) forKey:key];
        }
    }
    if ([[self.flags valueForKey:key] integerValue]) {
         [[self subjectForKey:key] sendNext:value];
    }
}

- (void)pauseSignalForKey:(NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self) {
        [self.flags setValue:@(0) forKey:key];
    }
}

- (void)restartSignalForKey:(NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self) {
        [self.flags setValue:@(1) forKey:key];
    }
}

- (id)valueForKey:(NSString *)key
{
    return [self.values objectForKey:key];
}

- (RACSignal *)signalForKey:(NSString *)key
{
    if (key.length <= 0) return [RACSignal empty];
    RACSubject *subject = [self subjectForKey:key];
    if (!subject) {
        subject = [RACSubject subject];
        @synchronized (self) {
            [self.observers setValue:subject forKey:key];
            [self.rac_deallocDisposable addDisposable:[RACDisposable disposableWithBlock:^{
                [subject sendCompleted];
            }]];
        }
    }
    return subject;
}

- (RACSubject *)subjectForKey:(NSString *)key
{
    return [self.observers objectForKey:key];
}

- (void)removeValueForKey:(NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self) {
        [self.observers removeObjectForKey:key];
        [self.values removeObjectForKey:key];
        [self.flags removeObjectForKey:key];
    }
}

- (NSMutableDictionary *)observers
{
    if (!_observers) {
        _observers = [NSMutableDictionary dictionary];
    }
    return _observers;
}

- (NSMutableDictionary *)values
{
    if (!_values) {
        _values = [NSMutableDictionary dictionary];
    }
    return _values;
}

- (NSMutableDictionary *)flags
{
    if (!_flags) {
        _flags = [NSMutableDictionary dictionary];
    }
    return _flags;
}

@end
