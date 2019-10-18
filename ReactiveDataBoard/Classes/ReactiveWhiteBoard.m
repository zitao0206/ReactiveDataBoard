//
//  ReactiveWhiteBoard.m
//  ReactiveDataBoard
//
//  Created by lizitao on 2018/1/19.
//

#import "ReactiveWhiteBoard.h"
typedef NS_ENUM(NSInteger, ReactiveBlackBoardFlagValue) {
    ReactiveBlackBoardFlagOn = 0,
    ReactiveBlackBoardFlagOff,
};
@interface ReactiveWhiteBoard ()
@property (nonatomic, strong) NSMutableDictionary <NSString *, RACSubject *> *observers;
@property (nonatomic, strong) NSMutableDictionary *values;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSNumber *> *flags;
@end

@implementation ReactiveWhiteBoard

static ReactiveWhiteBoard *defaultboard;
static dispatch_once_t onceToken;

+ (instancetype)whiteBoard
{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    dispatch_once(&onceToken, ^{
        defaultboard = [super allocWithZone:zone];
    });
    return defaultboard;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return defaultboard;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    return defaultboard;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self.values) {
        [self.values setValue:value forKey:key];
    }
    if (ReactiveBlackBoardFlagOn == [[self.flags valueForKey:key] integerValue]) {
        NSArray *arr = [self subjectsForKey:key];
        [arr enumerateObjectsUsingBlock:^(RACSubject *subject, NSUInteger idx, BOOL * _Nonnull stop) {
            [subject sendNext:value];
        }];
    }
}

- (id)valueForKey:(NSString *)key
{
    if (key.length <= 0) return nil;
    return [self.values objectForKey:key];
}

- (RACSignal *)addObserver:(id)obj forKey:(NSString *)key
{
    if (key.length <= 0) return [RACSignal empty];
    @synchronized (self) {
       [self.flags setValue:@(ReactiveBlackBoardFlagOn) forKey:key];
       NSString *insideKey = [NSString stringWithFormat:@"%@_%@_%p",key,NSStringFromClass([obj class]),obj];
       RACSubject *subject = [RACSubject subject];
       [self.observers setValue:subject forKey:insideKey];
       return subject;
    }
}

- (NSArray *)subjectsForKey:(NSString *)key
{
     __block NSMutableArray *allSubjects = [NSMutableArray array];
     @synchronized (allSubjects) {
        [self.observers.allKeys enumerateObjectsUsingBlock:^(NSString *insideKey, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([insideKey hasPrefix:key]) {
                [allSubjects addObject:[self.observers objectForKey:insideKey]];
            }
        }];
        return allSubjects;
    }
}

- (void)pauseSignalForKey:(NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self.flags) {
        [self.flags setValue:@(ReactiveBlackBoardFlagOff) forKey:key];
    }
}

- (void)restartSignalForKey:(NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self.flags) {
        [self.flags setValue:@(ReactiveBlackBoardFlagOn) forKey:key];
    }
}

- (void)removeObserver:(id)obj forKey:(NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self.observers) {
        NSString *insideKey = [NSString stringWithFormat:@"%@_%@_%p",key,NSStringFromClass([obj class]),obj];
         RACSubject *subject = [self.observers objectForKey:insideKey];
        if (subject) {
            [self.observers removeObjectForKey:insideKey];
        }
    }
}

- (void)removeAllObjObservers:(id)obj
{
    if (!obj) return;
    NSString *obj_str = [NSString stringWithFormat:@"%@_%p",NSStringFromClass([obj class]),obj];
    if (obj_str.length <= 0) return;
    @synchronized (self.observers) {
        [self.observers.allKeys enumerateObjectsUsingBlock:^(NSString *insideKey, NSUInteger idx, BOOL * _Nonnull stop) {
           if ([insideKey containsString:obj_str]) {
                 [self.observers removeObjectForKey:insideKey];
           }
        }];
    }
}

- (void)removeAllKeyObservers:(NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self.observers) {
        [self.observers.allKeys enumerateObjectsUsingBlock:^(NSString *insideKey, NSUInteger idx, BOOL * _Nonnull stop) {
           if ([insideKey hasPrefix:key]) {
                 [self.observers removeObjectForKey:insideKey];
           }
        }];
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
