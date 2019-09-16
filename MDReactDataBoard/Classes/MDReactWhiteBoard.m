//
//  XYReactWhiteBoard.m
//  XYReactDataBoard
//
//  Created by lizitao on 2018/1/10.
//

#import "XYReactWhiteBoard.h"
#import "XYReactDataBoardSubject.h"
@interface XYReactWhiteBoard ()
@property (nonatomic, strong) NSMutableDictionary *subjects;
@property (nonatomic, strong) NSMutableDictionary *values;
@property (nonatomic, strong) NSMapTable *mapTable;
@property (nonatomic, strong) NSMutableDictionary *keyPaths;
@property (nonatomic, strong) dispatch_source_t dispatchSource;
@property (nonatomic, assign) BOOL isWatching;

@end

@implementation XYReactWhiteBoard

static XYReactWhiteBoard *whiteBoard;
static dispatch_once_t onceToken;

+ (instancetype)shareBoard
{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    dispatch_once(&onceToken, ^{
        whiteBoard = [super allocWithZone:zone];
    });
    return whiteBoard;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return whiteBoard;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    return whiteBoard;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self) {
        if (value) {
            [self.values setObject:value forKey:key];
        } else {
            [self.values removeObjectForKey:key];
        }
        if (self.keyPaths.count > 0) {
            for (NSString *keyPath in self.keyPaths.allKeys) {
                NSArray *array = [keyPath componentsSeparatedByString:@" "];
                if ([array.firstObject isEqualToString:key]) {
                    [[self subjectForKey:keyPath] sendNext:value];
                }
            }
        }
        [[self subjectForKey:key] sendNext:value];
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
    if (subject == nil) {
        subject = [RACSubject subject];
        @synchronized (self) {
            [self.subjects setObject:subject forKey:key];
            [self.rac_deallocDisposable addDisposable:[RACDisposable disposableWithBlock:^{
                [subject sendCompleted];
            }]];
        }
    }
    return subject;
}

- (RACSignal *)signalForKeyPath:(NSString *)keyPath
{
    [self handleKeyPath:keyPath];
    if (keyPath.length <= 0) return [RACSignal empty];
    RACSubject *subject = [self subjectForKey:keyPath];
    if (subject == nil) {
        subject = [RACSubject subject];
        @synchronized (self) {
            [self.subjects setObject:subject forKey:keyPath];
            [self.rac_deallocDisposable addDisposable:[RACDisposable disposableWithBlock:^{
                [subject sendCompleted];
            }]];
        }
    }
    return subject;
}

- (nonnull RACSignal *)singleSignalForKey:(nonnull NSString *)key
{
    if (key.length <= 0) return [RACSignal empty];
    RACSubject *subject = [self subjectForKey:key];
    if (subject == nil || ![subject isKindOfClass:[XYReactDataBoardSubject class]]) {
        subject = [XYReactDataBoardSubject subject];
        @synchronized (self) {
            [self.subjects setObject:subject forKey:key];
            [self.rac_deallocDisposable addDisposable:[RACDisposable disposableWithBlock:^{
                [subject sendCompleted];
            }]];
        }
    }
    return subject;
}

- (nonnull RACSignal *)singleSignalForKeyPath:(nonnull NSString *)keyPath
{
    [self handleKeyPath:keyPath];
    if (keyPath.length <= 0) return [RACSignal empty];
    RACSubject *subject = [self subjectForKey:keyPath];
    if (subject == nil || ![subject isKindOfClass:[XYReactDataBoardSubject class]]) {
        subject = [XYReactDataBoardSubject subject];
        @synchronized (self) {
            [self.subjects setObject:subject forKey:keyPath];
            [self.rac_deallocDisposable addDisposable:[RACDisposable disposableWithBlock:^{
                [subject sendCompleted];
            }]];
        }
    }
    return subject;
}

- (RACSubject *)subjectForKey:(NSString *)key
{
    return [self.subjects objectForKey:key];
}

#pragma mark - memory address handle

- (NSString *)handleKeyPath:(NSString *)keyPath
{
    NSArray *array = [keyPath componentsSeparatedByString:@" "];
    NSString *ptr = array.lastObject;
    if (ptr.length > 0) {
        ptr = [ptr hasPrefix:@"0x"] ? ptr : [@"0x" stringByAppendingString:ptr];
        unsigned long long hex = strtoull(ptr.UTF8String, NULL, 0);
        id obj = (__bridge id)(void *)hex;
        if (obj) {
            [self.mapTable setObject:obj forKey:keyPath];
            [self.keyPaths setObject:keyPath forKey:keyPath];
        }
    }
    if (!self.isWatching && self.keyPaths.count > 0) {
        self.isWatching = YES;
        [self startWatch];
    }
    return array.firstObject;
}

- (void)visitAllElements
{
    NSLog(@"数据白板keyPath：%@", self.mapTable);
    for (NSString *keyPath in self.keyPaths.allKeys) {
        id obj = [self.mapTable objectForKey:keyPath];
        if (!obj) {
            @synchronized (self) {
                [self.keyPaths removeObjectForKey:keyPath];
                [self.values removeObjectForKey:keyPath];
                [self.subjects removeObjectForKey:keyPath];
            }
        }
    }
}

#pragma mark - accessor

- (NSMutableDictionary *)subjects
{
    if (nil == _subjects) {
        _subjects = [NSMutableDictionary dictionary];
    }
    return _subjects;
}

- (NSMutableDictionary *)values
{
    if (nil == _values) {
        _values = [NSMutableDictionary dictionary];
    }
    return _values;
}

- (NSMapTable *)mapTable
{
    if (nil == _mapTable) {
       _mapTable = [NSMapTable mapTableWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableWeakMemory];
    }
    return _mapTable;
}

- (dispatch_source_t)dispatchSource
{
    if (nil == _dispatchSource) {
        dispatch_queue_t dispatchQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
        _dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatchQueue);
        dispatch_source_set_timer(_dispatchSource,
                                  dispatch_time(DISPATCH_TIME_NOW, 0),
                                  NSEC_PER_SEC,
                                  0);
        dispatch_source_set_event_handler(_dispatchSource, ^{
            [self visitAllElements];
            if (self.subjects.count == 0) {
                [self suspendWatch];
                self.isWatching = NO;
            }
        });
    }
    return _dispatchSource;
}

- (NSMutableDictionary *)keyPaths
{
    if (nil == _keyPaths) {
        _keyPaths = [NSMutableDictionary dictionary];
    }
    return _keyPaths;
}

- (void)startWatch
{
    dispatch_resume(self.dispatchSource);
}

- (void)suspendWatch
{
    dispatch_suspend(self.dispatchSource);
}

#pragma mark - remove and destroy

- (void)removeValueForKey:(nonnull NSString *)key
{
    if (key.length <= 0) return;
    @synchronized (self) {
        [self.values removeObjectForKey:key];
    }
}

- (void)destroysShareBoard
{
    whiteBoard = nil;
    onceToken = 0;
}

@end
